#!/usr/bin/env dotnet run
// Get-SessionSummary.cs
// .NET 10 file-based program (run with `dotnet run --file <this>.cs -- <args>`).
//
// Produces a Markdown summary of a single Microsoft Build session by feeding the
// session's official metadata + transcript to GitHub Copilot via the GitHub.Copilot.SDK.
// Designed to be invoked per-session by a PowerShell driver that controls concurrency
// (so concurrency lives in the orchestrator, not here).
//
// Assumes: the user is already signed in to GitHub Copilot on this machine
// (the SDK uses the logged-in CLI session). No env vars, no token plumbing.
//
// Exit codes:
//   0  success — summary written to --out
//   2  bad arguments
//   3  missing input file
//   4  Copilot session error (network, model, permission)
//   5  empty / blank response from model
//
// Usage:
//   dotnet run --file Get-SessionSummary.cs -- `
//     --transcript sessions/2026/KEY01/transcript.md `
//     --metadata sessions/2026/KEY01/rich-manifest.json `
//     --out sessions/2026/KEY01/summary.md `
//     [--model claude-opus-4.7-1m] `
//     [--timeout-minutes 5]

#:package GitHub.Copilot.SDK@0.3.0

// File-based .NET 10 apps default to trim-friendly settings, which include
// disabling the reflection-based System.Text.Json serializer (it would need
// reflection metadata that trimming strips). Re-enable it here — our payload
// is tiny and reflection-mode keeps the manifest record concise. A source-gen
// JsonSerializerContext would also work but adds boilerplate.
#:property JsonSerializerIsReflectionEnabledByDefault=true

using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading;
using System.Threading.Tasks;
using GitHub.Copilot.SDK;

// ---- argument parsing -----------------------------------------------------

string? transcriptPath = null;
string? metadataPath   = null;
string? outputPath     = null;
string  model          = "claude-opus-4.7-1m";
int     timeoutMinutes = 5;

for (var i = 0; i < args.Length; i++)
{
    switch (args[i])
    {
        case "--transcript":      transcriptPath = NextArg(); break;
        case "--metadata":        metadataPath   = NextArg(); break;
        case "--out":             outputPath     = NextArg(); break;
        case "--model":           model          = NextArg(); break;
        case "--timeout-minutes": timeoutMinutes = int.Parse(NextArg()); break;
        case "--help" or "-h":    PrintUsage(); return 0;
        default:
            await Console.Error.WriteLineAsync($"unknown argument: {args[i]}");
            PrintUsage();
            return 2;
    }

    string NextArg()
    {
        if (i + 1 >= args.Length)
        {
            Console.Error.WriteLine($"missing value for {args[i]}");
            Environment.Exit(2);
        }
        return args[++i];
    }
}

if (transcriptPath is null || metadataPath is null || outputPath is null)
{
    await Console.Error.WriteLineAsync("--transcript, --metadata, --out are all required");
    PrintUsage();
    return 2;
}

if (!File.Exists(transcriptPath))
{
    await Console.Error.WriteLineAsync($"transcript not found: {transcriptPath}");
    return 3;
}
if (!File.Exists(metadataPath))
{
    await Console.Error.WriteLineAsync($"metadata not found: {metadataPath}");
    return 3;
}

// ---- read inputs ----------------------------------------------------------

var transcript = await File.ReadAllTextAsync(transcriptPath);
if (string.IsNullOrWhiteSpace(transcript))
{
    await Console.Error.WriteLineAsync($"transcript is empty: {transcriptPath}");
    return 3;
}

// The metadata file is the rich-manifest.json the ingestion script wrote per
// session. We pull the fields the summarizer needs from it; missing fields
// degrade gracefully. The full file is *not* sent to the model — only the
// curated context block below — so the model can't be confused by paths,
// schema version, etc.
var metadataJson = await File.ReadAllTextAsync(metadataPath);
var manifest = JsonSerializer.Deserialize<RichManifest>(metadataJson, new JsonSerializerOptions
{
    PropertyNameCaseInsensitive = true
}) ?? throw new InvalidOperationException("rich-manifest.json deserialized to null");

// ---- prompts --------------------------------------------------------------

// System prompt is intentionally strict about hallucination — auto-captions
// garble proper nouns and the model has no way to know what's "really" there
// without the rule. The transcript-as-truth rule + the [inferred] tag give
// the agent a way to flag uncertain corrections without inventing.
const string SystemPrompt = """
You are an analyst summarizing Microsoft Build conference session transcripts for an indexed knowledge base.

Rules:
- Ground every claim in the transcript and metadata provided. Do NOT invent quotes, statistics, product names, attributions, or follow-up links.
- Auto-generated captions garble proper nouns (e.g. Ryzen->Raisin, Maia->Maya, Replit->Repplet, Vera Rubin->Verirubin). Recognise these mishearings and use the canonical product/person name when the context clearly identifies it; mark uncertain corrections with [inferred].
- Output is GitHub-flavoured Markdown.
- Sections, in this exact order, OMITTING any that would be empty:
  1. `# Summary` — heading only, no body.
  2. `## Overview` — 2-3 sentence thesis of the session.
  3. `## Key announcements` — bullet list. Each bullet: bold the announcement, then a one-sentence elaboration. Include the timestamp from the transcript when one is present.
  4. `## Topics covered` — bullet list of substantive topics (not "the speaker introduced X", actual subject matter).
  5. `## Notable quotes` — at most 3 verbatim quotes from the transcript, each attributed to a speaker when the transcript identifies one. Use blockquote syntax (`>`).
  6. `## Products and tools mentioned` — flat bullet list of canonical names.
  7. `## Speakers featured` — bullet list; include role/title when the transcript or metadata names one.
  8. `## Follow-up resources` — only links explicitly mentioned in the transcript (not invented).
- Length target: 400-800 words. The summary should let a conference attendee decide whether to watch the full session.
- No emoji. No filler ("This session was great", "Don't miss it"). No first-person voice. No prelude. No sign-off.
""";

var promptBuilder = new StringBuilder();
promptBuilder.AppendLine($"Session: {manifest.Title ?? "(untitled)"}");
promptBuilder.AppendLine($"Code: {manifest.Code ?? "(unknown)"}");
if (!string.IsNullOrWhiteSpace(manifest.SpeakerNames))
{
    promptBuilder.AppendLine($"Speakers: {manifest.SpeakerNames}");
}
if (manifest.DurationMinutes is int dur)
{
    promptBuilder.AppendLine($"Duration: {dur} minutes");
}
if (manifest.Topics is { Length: > 0 })
{
    promptBuilder.AppendLine($"Topics: {string.Join(", ", manifest.Topics)}");
}
if (manifest.Tags is { Length: > 0 })
{
    promptBuilder.AppendLine($"Tags: {string.Join(", ", manifest.Tags)}");
}
if (manifest.Level is { Length: > 0 })
{
    promptBuilder.AppendLine($"Level: {string.Join(", ", manifest.Level)}");
}
if (!string.IsNullOrWhiteSpace(manifest.Description))
{
    promptBuilder.AppendLine();
    promptBuilder.AppendLine("Official description:");
    promptBuilder.AppendLine(manifest.Description.Trim());
}
promptBuilder.AppendLine();
promptBuilder.AppendLine("Transcript (auto-captioned, may contain mishearings):");
promptBuilder.AppendLine(transcript);
promptBuilder.AppendLine();
promptBuilder.AppendLine("Produce the Markdown summary now.");

var prompt = promptBuilder.ToString();

await Console.Error.WriteLineAsync(
    $"[{manifest.Code ?? "?"}] requesting summary via Copilot ({model}, prompt={prompt.Length:N0} chars)...");

// ---- Copilot session ------------------------------------------------------

await using var client = new CopilotClient(new CopilotClientOptions
{
    Cwd = Environment.CurrentDirectory,
    UseLoggedInUser = true
});

await client.StartAsync().ConfigureAwait(false);

// Model selection: prefer the requested model exactly. If unavailable on the
// signed-in user's Copilot tier, fall back to the first Anthropic-family model,
// then to whatever model the listing returns. This mirrors how the LLM
// scaffolding in Zakira.Replay degrades — a wrong model id should not abort.
var resolvedModel = await ResolveModelAsync(client, model);
if (!string.Equals(resolvedModel, model, StringComparison.OrdinalIgnoreCase))
{
    await Console.Error.WriteLineAsync($"[{manifest.Code ?? "?"}] requested model '{model}' unavailable; using '{resolvedModel}'.");
}

var response = new StringBuilder();
var completion = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);

await using var session = await client.CreateSessionAsync(new SessionConfig
{
    Model = resolvedModel,
    OnPermissionRequest = PermissionHandler.ApproveAll,
    SystemMessage = new SystemMessageConfig
    {
        Mode    = SystemMessageMode.Replace,
        Content = SystemPrompt
    },
    WorkingDirectory = Environment.CurrentDirectory,
    Streaming = false
}, CancellationToken.None).ConfigureAwait(false);

using var subscription = session.On(evt =>
{
    switch (evt)
    {
        case AssistantMessageEvent msg when !string.IsNullOrWhiteSpace(msg.Data?.Content):
            // The SDK fires AssistantMessageEvent with the FULL latest content
            // for each delta; replacing (not appending) yields the final message.
            response.Clear();
            response.Append(msg.Data.Content);
            break;
        case SessionErrorEvent err:
            completion.TrySetException(new InvalidOperationException(
                $"Copilot session error: {err.Data?.Message}"));
            break;
        case SessionIdleEvent:
            completion.TrySetResult();
            break;
    }
});

await session.SendAsync(new MessageOptions
{
    Prompt = prompt,
    Attachments = []
}, CancellationToken.None).ConfigureAwait(false);

try
{
    await completion.Task.WaitAsync(TimeSpan.FromMinutes(timeoutMinutes)).ConfigureAwait(false);
}
catch (TimeoutException)
{
    await Console.Error.WriteLineAsync(
        $"[{manifest.Code ?? "?"}] Copilot session timed out after {timeoutMinutes}m.");
    await client.StopAsync().ConfigureAwait(false);
    return 4;
}
catch (Exception ex)
{
    await Console.Error.WriteLineAsync($"[{manifest.Code ?? "?"}] Copilot error: {ex.Message}");
    await client.StopAsync().ConfigureAwait(false);
    return 4;
}

await client.StopAsync().ConfigureAwait(false);

var summary = response.ToString().Trim();
if (string.IsNullOrWhiteSpace(summary))
{
    await Console.Error.WriteLineAsync($"[{manifest.Code ?? "?"}] model returned empty content.");
    return 5;
}

// ---- write output ---------------------------------------------------------

// Prepend a small audit header (model, time, source paths) as an HTML comment
// so the summary file is self-describing without disrupting the rendered
// Markdown. mdBook / VitePress / Lunr all strip HTML comments cleanly.
var header = $"""
<!--
  Source:    {Path.GetFullPath(transcriptPath)}
  Metadata:  {Path.GetFullPath(metadataPath)}
  Model:     {resolvedModel}
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: {DateTimeOffset.UtcNow:o}
-->
""";

var finalContent = header + Environment.NewLine + summary + Environment.NewLine;

var outDir = Path.GetDirectoryName(Path.GetFullPath(outputPath));
if (!string.IsNullOrEmpty(outDir))
{
    Directory.CreateDirectory(outDir);
}
await File.WriteAllTextAsync(outputPath, finalContent);

await Console.Error.WriteLineAsync(
    $"[{manifest.Code ?? "?"}] wrote {outputPath} ({summary.Length:N0} chars)");
return 0;

// ---- helpers --------------------------------------------------------------

static async Task<string> ResolveModelAsync(CopilotClient client, string requested)
{
    try
    {
        var models = await client.ListModelsAsync(CancellationToken.None).ConfigureAwait(false);
        var modelList = models.ToList();

        // Exact match wins.
        var exact = modelList.FirstOrDefault(m => string.Equals(m.Id, requested, StringComparison.OrdinalIgnoreCase));
        if (exact is not null) return exact.Id;

        // Same family fallback: any claude-opus before any other claude before anything else.
        // The 1m suffix is the long-context variant; without it, any claude-opus is fine.
        var family = modelList
                         .Where(m => m.Id.Contains("claude-opus", StringComparison.OrdinalIgnoreCase))
                         .OrderByDescending(m => m.Id, StringComparer.OrdinalIgnoreCase)
                         .FirstOrDefault()
                     ?? modelList
                         .Where(m => m.Id.Contains("claude", StringComparison.OrdinalIgnoreCase))
                         .OrderByDescending(m => m.Id, StringComparer.OrdinalIgnoreCase)
                         .FirstOrDefault();
        if (family is not null) return family.Id;

        // Last resort: whatever's there.
        var any = modelList.FirstOrDefault();
        if (any is not null) return any.Id;
    }
    catch
    {
        // Listing failed (network, auth) — let session creation surface a real error message.
    }

    return requested;
}

static void PrintUsage()
{
    Console.Error.WriteLine("""
Usage:
  dotnet run --file Get-SessionSummary.cs -- \
    --transcript <path/to/transcript.md> \
    --metadata <path/to/rich-manifest.json> \
    --out <path/to/summary.md> \
    [--model claude-opus-4.7-1m] \
    [--timeout-minutes 5]

Reads the transcript and the curated metadata fields from rich-manifest.json,
asks GitHub Copilot to produce a strict-format Markdown summary, and writes
it to --out. Designed to be invoked per-session by a PowerShell driver that
controls concurrency.
""");
}

// Subset of the rich-manifest.json shape we read. Extra fields in the file
// are silently ignored.
//
// PowerShell's ConvertTo-Json unwraps single-element arrays to their scalar
// value (e.g. one-tag session writes `"level": "(200) Intermediate"`, not
// `"level": ["(200) Intermediate"]`). The custom converter below accepts
// either shape so the .ps1 ingestion side doesn't have to coerce.
internal sealed record RichManifest(
    [property: JsonPropertyName("code")]             string?   Code,
    [property: JsonPropertyName("title")]            string?   Title,
    [property: JsonPropertyName("description")]      string?   Description,
    [property: JsonPropertyName("speakerNames")]     string?   SpeakerNames,
    [property: JsonPropertyName("durationMinutes")]  int?      DurationMinutes,
    [property: JsonPropertyName("topics")]
    [property: JsonConverter(typeof(StringOrStringArrayConverter))]
    string[]? Topics,
    [property: JsonPropertyName("tags")]
    [property: JsonConverter(typeof(StringOrStringArrayConverter))]
    string[]? Tags,
    [property: JsonPropertyName("level")]
    [property: JsonConverter(typeof(StringOrStringArrayConverter))]
    string[]? Level);

internal sealed class StringOrStringArrayConverter : JsonConverter<string[]?>
{
    public override string[]? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        => reader.TokenType switch
        {
            JsonTokenType.Null       => null,
            JsonTokenType.String     => new[] { reader.GetString()! },
            JsonTokenType.StartArray => JsonSerializer.Deserialize<string[]>(ref reader, options),
            _                        => throw new JsonException(
                $"Expected string or string[] but got {reader.TokenType}")
        };

    public override void Write(Utf8JsonWriter writer, string[]? value, JsonSerializerOptions options)
    {
        if (value is null) { writer.WriteNullValue(); return; }
        JsonSerializer.Serialize(writer, value, options);
    }
}
