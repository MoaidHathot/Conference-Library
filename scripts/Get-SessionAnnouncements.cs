#!/usr/bin/env dotnet run
// Get-SessionAnnouncements.cs
// .NET 10 file-based program (run with `dotnet run --file <this>.cs -- <args>`).
//
// Extracts the structured "key announcements" for a single Microsoft Build
// session into a strict-JSON file (announcements.json) that downstream
// resolution + render scripts join across sessions.
//
// The list of announcements is parsed mechanically from the session's
// summary.md (`## Key announcements` section); the LLM's job is only to
// enrich each pre-found announcement with category / longDescription /
// speakers / explicitLinks / codeSnippets. This minimises the model's
// hallucination surface: it can't add or skip announcements, only enrich
// the ones the summarizer already curated.
//
// Designed to be invoked per-session by Get-SessionAnnouncements.ps1, which
// owns concurrency the same way Get-SessionSummaries.ps1 does.
//
// Assumes: the user is already signed in to GitHub Copilot on this machine
// (the SDK uses the logged-in CLI session). No env vars, no token plumbing.
//
// Exit codes:
//   0  success - announcements.json written to --out
//   2  bad arguments
//   3  missing input file
//   4  Copilot session error (network, model, permission, timeout)
//   5  empty / blank / non-JSON response from model
//   6  no announcements found in summary.md (legitimate skip - writes an
//      empty-but-valid announcements.json so downstream skip logic works)
//
// Usage:
//   dotnet run --file Get-SessionAnnouncements.cs -- `
//     --summary    sessions/Build/2026/KEY01/summary.md `
//     --transcript sessions/Build/2026/KEY01/transcript.md `
//     --metadata   sessions/Build/2026/KEY01/rich-manifest.json `
//     --frames-dir sessions/Build/2026/KEY01/announcement-frames `
//     --out        sessions/Build/2026/KEY01/announcements.json `
//     [--model claude-opus-4.7-1m] `
//     [--timeout-minutes 5] `
//     [--window-seconds 90]

#:package GitHub.Copilot.SDK@0.3.0

// File-based .NET 10 apps default to trim-friendly settings, which include
// disabling the reflection-based System.Text.Json serializer (it would need
// reflection metadata that trimming strips). Re-enable it here - our payload
// is tiny and reflection-mode keeps the manifest record concise.
#:property JsonSerializerIsReflectionEnabledByDefault=true

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using GitHub.Copilot.SDK;

// ---- argument parsing -----------------------------------------------------

string? summaryPath    = null;
string? transcriptPath = null;
string? metadataPath   = null;
string? framesDir      = null;
string? outputPath     = null;
string  model          = "claude-opus-4.7-1m";
int     timeoutMinutes = 5;
int     windowSeconds  = 90;

for (var i = 0; i < args.Length; i++)
{
    switch (args[i])
    {
        case "--summary":         summaryPath    = NextArg(); break;
        case "--transcript":      transcriptPath = NextArg(); break;
        case "--metadata":        metadataPath   = NextArg(); break;
        case "--frames-dir":      framesDir      = NextArg(); break;
        case "--out":             outputPath     = NextArg(); break;
        case "--model":           model          = NextArg(); break;
        case "--timeout-minutes": timeoutMinutes = int.Parse(NextArg(), CultureInfo.InvariantCulture); break;
        case "--window-seconds":  windowSeconds  = int.Parse(NextArg(), CultureInfo.InvariantCulture); break;
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

if (summaryPath is null || transcriptPath is null || metadataPath is null || outputPath is null)
{
    await Console.Error.WriteLineAsync("--summary, --transcript, --metadata, --out are all required");
    PrintUsage();
    return 2;
}

if (!File.Exists(summaryPath))    { await Console.Error.WriteLineAsync($"summary not found: {summaryPath}");       return 3; }
if (!File.Exists(transcriptPath)) { await Console.Error.WriteLineAsync($"transcript not found: {transcriptPath}"); return 3; }
if (!File.Exists(metadataPath))   { await Console.Error.WriteLineAsync($"metadata not found: {metadataPath}");     return 3; }

// ---- read inputs ----------------------------------------------------------

var summaryText    = await File.ReadAllTextAsync(summaryPath);
var transcriptText = await File.ReadAllTextAsync(transcriptPath);
var metadataJson   = await File.ReadAllTextAsync(metadataPath);

var manifest = JsonSerializer.Deserialize<RichManifest>(metadataJson, new JsonSerializerOptions
{
    PropertyNameCaseInsensitive = true
}) ?? throw new InvalidOperationException("rich-manifest.json deserialized to null");

var sessionCode  = manifest.Code  ?? Path.GetFileName(Path.GetDirectoryName(Path.GetFullPath(summaryPath))) ?? "?";
var sessionTitle = manifest.Title ?? "(untitled)";

// ---- 1. parse `## Key announcements` mechanically ------------------------

var parsedAnnouncements = ParseKeyAnnouncements(summaryText).ToList();

if (parsedAnnouncements.Count == 0)
{
    await Console.Error.WriteLineAsync(
        $"[{sessionCode}] no '## Key announcements' bullets parsed from summary.md; writing empty announcements.json.");
    var empty = new AnnouncementsFile(
        schemaVersion: 1,
        sessionCode:   sessionCode,
        sessionTitle:  sessionTitle,
        sessionSpeakers: SplitSpeakers(manifest.SpeakerNames),
        durationMinutes: manifest.DurationMinutes,
        extractedAt:   DateTimeOffset.UtcNow.ToString("o"),
        model:         null,
        windowSeconds: windowSeconds,
        announcements: new List<Announcement>(),
        errors:        new List<string> { "no-key-announcements-section" });
    await WriteAnnouncementsAsync(outputPath, empty);
    return 6;
}

await Console.Error.WriteLineAsync(
    $"[{sessionCode}] parsed {parsedAnnouncements.Count} announcement(s) from summary.md.");

// ---- 2. index the transcript by timestamp --------------------------------

var transcriptLines = ParseTranscriptLines(transcriptText).ToList();

// ---- 3. for each announcement, build a transcript window + frames -------

var requests = new List<EnrichmentRequest>(parsedAnnouncements.Count);

foreach (var p in parsedAnnouncements)
{
    var window      = SliceTranscriptWindow(transcriptLines, p.TimestampSeconds, windowSeconds);
    var windowText  = string.Join("\n", window.Select(l => $"[{FormatHms(l.Seconds)}] {l.Text}"));
    var frames      = ListFramesForTimestamp(framesDir, p.Timestamp);

    requests.Add(new EnrichmentRequest(
        Name:             p.Name,
        Timestamp:        p.Timestamp,
        TimestampSeconds: p.TimestampSeconds,
        ShortDescription: p.ShortDescription,
        IsInferred:       p.IsInferred,
        TranscriptWindow: windowText,
        Frames:           frames));
}

// ---- 4. build prompt + call Copilot --------------------------------------

const string SystemPrompt = """
You are an analyst enriching a list of Microsoft Build conference key announcements with structured detail for an indexed knowledge base.

INPUT: a session header plus an ordered list of announcements. Each announcement comes with a `name`, `timestamp`, `shortDescription`, and a `transcriptWindow` (the lines of the transcript +/- 90 seconds around that timestamp).

TASK: for EACH announcement, in the same order and same count, produce ONE JSON object enriching the four fields below. Do NOT add, drop, reorder, rename, or split announcements.

Output MUST be a single JSON object with this shape and nothing else:
{
  "announcements": [
    {
      "name": "<echo input name verbatim>",
      "timestamp": "<echo input timestamp verbatim>",
      "category": "<one of: model, service, SDK, framework, library, tool, runtime, hardware, spec, feature, platform, concept>",
      "longDescription": "<2-4 sentence description synthesized strictly from the transcriptWindow. No invention. Resolve obvious caption mishearings (e.g. Maya -> Maia, Raisin -> Ryzen, Repplet -> Replit). Mark uncertain corrections with [inferred].>",
      "speakers": ["<canonical speaker name(s) at this timestamp, taken from `Speaker:` prefixes inside the transcriptWindow when present; empty array if none identifiable>"],
      "explicitLinks": [
        { "kind": "<github|nuget|npm|pypi|docs|blog|marketplace|samples|other>", "url": "<verbatim URL from the transcriptWindow>" }
      ],
      "codeSnippets": [
        { "language": "<best guess: sql, csharp, powershell, bash, javascript, python, yaml, json, plaintext, ...>", "code": "<verbatim code block from the transcriptWindow>", "timestamp": "<HH:MM:SS of the line where the code appears, or echo the announcement timestamp if unclear>" }
      ]
    }
  ]
}

STRICT RULES:
- The `announcements` array length MUST equal the number of input announcements.
- `name` and `timestamp` are echoed verbatim - any deviation will be rejected.
- `category` MUST be one of the listed values, lowercase, exactly as written. Pick the closest fit. "feature" is for capabilities of an existing product; "concept" is for ideas/patterns/architectures, not products.
- `longDescription` is grounded ONLY in the transcriptWindow. If the window is too thin, fall back to a one-sentence factual statement; do NOT invent.
- `explicitLinks` contains only URLs that appear LITERALLY in the transcriptWindow (typically as "github.com/...", "aka.ms/...", "learn.microsoft.com/..."). Do NOT fabricate URLs. If none, return [].
- `codeSnippets` contains only code that appears in fenced code blocks OR clearly-recognisable inline code in the transcriptWindow. Auto-caption transcripts rarely have real code; an empty array is the common, correct answer. Do NOT synthesise getting-started snippets.
- `speakers` is taken from `<Name>:` prefixes inside the transcriptWindow. If the window has none, return [].
- Output a SINGLE JSON object. No markdown, no code fences, no prose, no comments before or after.
""";

var promptBuilder = new StringBuilder();
promptBuilder.AppendLine($"Session: {sessionTitle}");
promptBuilder.AppendLine($"Code: {sessionCode}");
if (!string.IsNullOrWhiteSpace(manifest.SpeakerNames))
{
    promptBuilder.AppendLine($"Session-level speakers: {manifest.SpeakerNames}");
}
if (manifest.DurationMinutes is int dur)
{
    promptBuilder.AppendLine($"Duration: {dur} minutes");
}
promptBuilder.AppendLine();
promptBuilder.AppendLine($"Announcements to enrich ({requests.Count}):");
promptBuilder.AppendLine();

for (var i = 0; i < requests.Count; i++)
{
    var r = requests[i];
    promptBuilder.AppendLine($"--- Announcement {i + 1} of {requests.Count} ---");
    promptBuilder.AppendLine($"name: {r.Name}");
    promptBuilder.AppendLine($"timestamp: {r.Timestamp}");
    promptBuilder.AppendLine($"shortDescription: {r.ShortDescription}");
    promptBuilder.AppendLine("transcriptWindow:");
    promptBuilder.AppendLine("```");
    promptBuilder.AppendLine(r.TranscriptWindow);
    promptBuilder.AppendLine("```");
    promptBuilder.AppendLine();
}

promptBuilder.AppendLine("Produce the JSON object now.");
var prompt = promptBuilder.ToString();

await Console.Error.WriteLineAsync(
    $"[{sessionCode}] requesting enrichment via Copilot ({model}, prompt={prompt.Length:N0} chars, {requests.Count} announcements)...");

await using var client = new CopilotClient(new CopilotClientOptions
{
    Cwd = Environment.CurrentDirectory,
    UseLoggedInUser = true
});

await client.StartAsync().ConfigureAwait(false);

var resolvedModel = await ResolveModelAsync(client, model);
if (!string.Equals(resolvedModel, model, StringComparison.OrdinalIgnoreCase))
{
    await Console.Error.WriteLineAsync($"[{sessionCode}] requested model '{model}' unavailable; using '{resolvedModel}'.");
}

var response   = new StringBuilder();
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
    Prompt      = prompt,
    Attachments = []
}, CancellationToken.None).ConfigureAwait(false);

try
{
    await completion.Task.WaitAsync(TimeSpan.FromMinutes(timeoutMinutes)).ConfigureAwait(false);
}
catch (TimeoutException)
{
    await Console.Error.WriteLineAsync($"[{sessionCode}] Copilot session timed out after {timeoutMinutes}m.");
    await client.StopAsync().ConfigureAwait(false);
    return 4;
}
catch (Exception ex)
{
    await Console.Error.WriteLineAsync($"[{sessionCode}] Copilot error: {ex.Message}");
    await client.StopAsync().ConfigureAwait(false);
    return 4;
}

await client.StopAsync().ConfigureAwait(false);

var rawResponse = response.ToString().Trim();
if (string.IsNullOrWhiteSpace(rawResponse))
{
    await Console.Error.WriteLineAsync($"[{sessionCode}] model returned empty content.");
    return 5;
}

// ---- 5. parse the model JSON (tolerant of code fences) ------------------

var jsonBody = ExtractJsonObject(rawResponse);
EnrichmentResponse? enrichment;
try
{
    enrichment = JsonSerializer.Deserialize<EnrichmentResponse>(jsonBody, new JsonSerializerOptions
    {
        PropertyNameCaseInsensitive = true,
        ReadCommentHandling         = JsonCommentHandling.Skip,
        AllowTrailingCommas         = true
    });
}
catch (JsonException ex)
{
    await Console.Error.WriteLineAsync($"[{sessionCode}] model returned non-JSON content: {ex.Message}");
    await Console.Error.WriteLineAsync($"[{sessionCode}] first 200 chars of response: {rawResponse[..Math.Min(200, rawResponse.Length)]}");
    return 5;
}

if (enrichment?.Announcements is null || enrichment.Announcements.Count == 0)
{
    await Console.Error.WriteLineAsync($"[{sessionCode}] model returned JSON with no announcements.");
    return 5;
}

if (enrichment.Announcements.Count != requests.Count)
{
    await Console.Error.WriteLineAsync(
        $"[{sessionCode}] model returned {enrichment.Announcements.Count} announcements, expected {requests.Count}. " +
        "Merging by best-effort name match.");
}

// ---- 6. merge mechanical truth with model enrichment --------------------

// Pair each parsed announcement (the source of truth for name + timestamp +
// shortDescription + frames + isInferred) with the model's enrichment.
// Match by index first, fall back to case-insensitive name match for
// resilience against minor model drift.
var enrichedByIndex = enrichment.Announcements;
var enrichedByName  = enrichment.Announcements
    .Where(a => !string.IsNullOrWhiteSpace(a.Name))
    .GroupBy(a => Normalise(a.Name!))
    .ToDictionary(g => g.Key, g => g.First());

var validCategories = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
{
    "model", "service", "SDK", "framework", "library", "tool",
    "runtime", "hardware", "spec", "feature", "platform", "concept"
};

var merged    = new List<Announcement>(requests.Count);
var mergeErrs = new List<string>();

for (var i = 0; i < requests.Count; i++)
{
    var req = requests[i];

    EnrichedAnnouncement? enr = i < enrichedByIndex.Count ? enrichedByIndex[i] : null;
    if (enr is null || (enr.Name is not null && !string.Equals(Normalise(enr.Name), Normalise(req.Name), StringComparison.OrdinalIgnoreCase)))
    {
        enrichedByName.TryGetValue(Normalise(req.Name), out enr);
    }

    var category = enr?.Category?.Trim();
    if (string.IsNullOrEmpty(category) || !validCategories.Contains(category))
    {
        if (!string.IsNullOrEmpty(category))
        {
            mergeErrs.Add($"announcement '{req.Name}': category '{category}' not in fixed taxonomy; defaulted to 'concept'.");
        }
        category = "concept";
    }
    else
    {
        // Normalise SDK casing back to "SDK", everything else lowercase.
        category = category.Equals("SDK", StringComparison.OrdinalIgnoreCase) ? "SDK" : category.ToLowerInvariant();
    }

    merged.Add(new Announcement(
        Name:             req.Name,
        Category:         category,
        ShortDescription: req.ShortDescription,
        LongDescription:  string.IsNullOrWhiteSpace(enr?.LongDescription) ? req.ShortDescription : enr!.LongDescription!.Trim(),
        Timestamp:        req.Timestamp,
        TimestampSeconds: req.TimestampSeconds,
        Speakers:         enr?.Speakers?.Where(s => !string.IsNullOrWhiteSpace(s)).Select(s => s.Trim()).ToList() ?? new List<string>(),
        Frames:           req.Frames,
        ExplicitLinks:    enr?.ExplicitLinks?.Where(l => !string.IsNullOrWhiteSpace(l.Url)).ToList() ?? new List<LinkEntry>(),
        CodeSnippets:     enr?.CodeSnippets?.Where(s => !string.IsNullOrWhiteSpace(s.Code)).ToList() ?? new List<CodeSnippet>(),
        IsInferred:       req.IsInferred));
}

// ---- 7. write announcements.json ----------------------------------------

var file = new AnnouncementsFile(
    schemaVersion:   1,
    sessionCode:     sessionCode,
    sessionTitle:    sessionTitle,
    sessionSpeakers: SplitSpeakers(manifest.SpeakerNames),
    durationMinutes: manifest.DurationMinutes,
    extractedAt:     DateTimeOffset.UtcNow.ToString("o"),
    model:           resolvedModel,
    windowSeconds:   windowSeconds,
    announcements:   merged,
    errors:          mergeErrs);

await WriteAnnouncementsAsync(outputPath, file);

await Console.Error.WriteLineAsync(
    $"[{sessionCode}] wrote {outputPath} ({merged.Count} announcement(s), {mergeErrs.Count} merge-warning(s)).");
return 0;

// ---- helpers --------------------------------------------------------------

static List<string> SplitSpeakers(string? speakerNames)
{
    if (string.IsNullOrWhiteSpace(speakerNames)) return new List<string>();
    return speakerNames
        .Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
        .ToList();
}

static IEnumerable<ParsedAnnouncement> ParseKeyAnnouncements(string summary)
{
    // Slice out the `## Key announcements` section. Section ends at the next
    // `## ` header or end-of-file.
    var sectionRx = new Regex(@"^##\s+Key\s+announcements\s*$(?<body>.*?)(?=^##\s+|\z)",
        RegexOptions.Multiline | RegexOptions.IgnoreCase | RegexOptions.Singleline);
    var sectionMatch = sectionRx.Match(summary);
    if (!sectionMatch.Success) yield break;
    var body = sectionMatch.Groups["body"].Value;

    // Bullet shapes observed across 446 summaries:
    //   - **<name>** [HH:MM:SS] - <short>            (KEY01-style; em-dash or hyphen, ts after name)
    //   - **<name>** *(MM:SS)*: <short>              (OD858-style; italic parens, ts after name)
    //   - **<name>** *(~HH:MM:SS)*: <short>          (BRK202-style; ~ approximate-prefix)
    //   - **<name>** (HH:MM:SS) - <short>            (occasional; parens, ts after name)
    //   - **<name>** - <short> [HH:MM:SS].           (BRK204-style; ts at END of line)
    // Two passes: front-loaded timestamps first, then trailing timestamps for
    // bullets the first pass missed. Both passes tolerate ~ approximate
    // prefix and optional italic markers on the timestamp delimiter.
    var bulletFrontRx = new Regex(
        @"^[\-\*]\s+\*\*(?<name>.+?)\*\*\s*\*?\s*[\[\(]\s*~?\s*(?<ts>\d{1,2}:\d{2}(?::\d{2})?)\s*[\]\)]\s*\*?\s*[:\-\u2013\u2014]\s+(?<short>.+?)$",
        RegexOptions.Multiline);
    var bulletTrailRx = new Regex(
        @"^[\-\*]\s+\*\*(?<name>.+?)\*\*\s*[:\-\u2013\u2014]\s+(?<short>.+?)\s*[\[\(]\s*~?\s*(?<ts>\d{1,2}:\d{2}(?::\d{2})?)\s*[\]\)]\s*\.?\s*$",
        RegexOptions.Multiline);

    // Track matched line offsets so the trailing pass doesn't double-count a
    // bullet the front pass already claimed (e.g. a bullet that happens to
    // have a parenthesised timestamp both after the name and at the end).
    var claimedOffsets = new HashSet<int>();

    foreach (Match m in bulletFrontRx.Matches(body))
    {
        claimedOffsets.Add(m.Index);
        var p = BuildAnnouncement(m);
        if (p is not null) yield return p;
    }

    foreach (Match m in bulletTrailRx.Matches(body))
    {
        if (claimedOffsets.Contains(m.Index)) continue;
        var p = BuildAnnouncement(m);
        if (p is not null) yield return p;
    }

    static ParsedAnnouncement? BuildAnnouncement(Match m)
    {
        var name   = m.Groups["name"].Value.Trim();
        var tsRaw  = m.Groups["ts"].Value.Trim();
        var short_ = m.Groups["short"].Value.Trim().TrimEnd('.', ' ', '\t');

        var (ts, seconds) = NormaliseTimestamp(tsRaw);
        if (seconds < 0) return null;

        var isInferred = name.Contains("[inferred]", StringComparison.OrdinalIgnoreCase)
                      || short_.Contains("[inferred]", StringComparison.OrdinalIgnoreCase);

        return new ParsedAnnouncement(
            Name:             name,
            Timestamp:        ts,
            TimestampSeconds: seconds,
            ShortDescription: short_,
            IsInferred:       isInferred);
    }
}

static (string formatted, int seconds) NormaliseTimestamp(string raw)
{
    var parts = raw.Split(':');
    int h, mm, ss;
    if (parts.Length == 3)
    {
        if (!int.TryParse(parts[0], NumberStyles.Integer, CultureInfo.InvariantCulture, out h)) return ("", -1);
        if (!int.TryParse(parts[1], NumberStyles.Integer, CultureInfo.InvariantCulture, out mm)) return ("", -1);
        if (!int.TryParse(parts[2], NumberStyles.Integer, CultureInfo.InvariantCulture, out ss)) return ("", -1);
    }
    else if (parts.Length == 2)
    {
        h = 0;
        if (!int.TryParse(parts[0], NumberStyles.Integer, CultureInfo.InvariantCulture, out mm)) return ("", -1);
        if (!int.TryParse(parts[1], NumberStyles.Integer, CultureInfo.InvariantCulture, out ss)) return ("", -1);
    }
    else
    {
        return ("", -1);
    }
    if (mm > 59 || ss > 59 || h < 0 || mm < 0 || ss < 0) return ("", -1);
    return ($"{h:00}:{mm:00}:{ss:00}", h * 3600 + mm * 60 + ss);
}

static string FormatHms(int seconds)
{
    if (seconds < 0) seconds = 0;
    var h = seconds / 3600;
    var m = (seconds % 3600) / 60;
    var s = seconds % 60;
    return $"{h:00}:{m:00}:{s:00}";
}

static IEnumerable<TranscriptLine> ParseTranscriptLines(string transcript)
{
    // The cleaned transcript format produced by Invoke-BuildIngestion.ps1 is
    // one line per caption cue:
    //   **[HH:MM:SS]** <text...>
    // We accept the bold marker as optional for resilience.
    var rx = new Regex(@"^(?:\*\*)?\[(\d{2}):(\d{2}):(\d{2})\](?:\*\*)?\s*(?<text>.*)$",
        RegexOptions.Multiline);
    foreach (Match m in rx.Matches(transcript))
    {
        var h  = int.Parse(m.Groups[1].Value, CultureInfo.InvariantCulture);
        var mm = int.Parse(m.Groups[2].Value, CultureInfo.InvariantCulture);
        var ss = int.Parse(m.Groups[3].Value, CultureInfo.InvariantCulture);
        yield return new TranscriptLine(h * 3600 + mm * 60 + ss, m.Groups["text"].Value.TrimEnd());
    }
}

static List<TranscriptLine> SliceTranscriptWindow(List<TranscriptLine> lines, int center, int windowSeconds)
{
    var lo = center - windowSeconds;
    var hi = center + windowSeconds;
    return lines.Where(l => l.Seconds >= lo && l.Seconds <= hi).ToList();
}

static List<string> ListFramesForTimestamp(string? framesDir, string hms)
{
    if (string.IsNullOrWhiteSpace(framesDir) || !Directory.Exists(framesDir)) return new List<string>();
    var folder = Path.Combine(framesDir, hms.Replace(':', '-'));
    if (!Directory.Exists(folder)) return new List<string>();
    // Path stored relative to the session dir (parent of the frames dir),
    // so consumers (HTML renderer, JSON viewers) can build absolute or
    // doc-root-relative URLs as needed.
    var parent = Path.GetDirectoryName(Path.GetFullPath(framesDir));
    return Directory.EnumerateFiles(folder, "frame-*.jpg")
        .Select(f =>
        {
            if (parent is null) return Path.GetFileName(f);
            var rel = Path.GetRelativePath(parent, f);
            return rel.Replace('\\', '/');
        })
        .OrderBy(p => p, StringComparer.OrdinalIgnoreCase)
        .ToList();
}

static string Normalise(string s)
{
    return new string(s.Where(c => !char.IsWhiteSpace(c) && !char.IsPunctuation(c)).ToArray())
        .ToLowerInvariant();
}

// Strip optional ```json ... ``` fences and any leading/trailing prose so the
// JSON deserializer sees just the object. Defensive: even with a strict
// "single JSON object, no prose" instruction the model occasionally wraps.
static string ExtractJsonObject(string raw)
{
    var trimmed = raw.Trim();

    // Fenced code block?
    var fenceRx = new Regex(@"^```(?:json|JSON)?\s*\n(?<body>.*?)\n```\s*$", RegexOptions.Singleline);
    var fence = fenceRx.Match(trimmed);
    if (fence.Success)
    {
        trimmed = fence.Groups["body"].Value.Trim();
    }

    // Find first `{` and matching balanced `}` ignoring braces inside strings.
    var firstBrace = trimmed.IndexOf('{');
    if (firstBrace < 0) return trimmed;

    var depth     = 0;
    var inString  = false;
    var escaping  = false;
    for (var i = firstBrace; i < trimmed.Length; i++)
    {
        var c = trimmed[i];
        if (escaping) { escaping = false; continue; }
        if (c == '\\' && inString) { escaping = true; continue; }
        if (c == '"') { inString = !inString; continue; }
        if (inString) continue;
        if (c == '{') depth++;
        else if (c == '}')
        {
            depth--;
            if (depth == 0)
            {
                return trimmed.Substring(firstBrace, i - firstBrace + 1);
            }
        }
    }
    return trimmed.Substring(firstBrace);
}

static async Task<string> ResolveModelAsync(CopilotClient client, string requested)
{
    try
    {
        var models    = await client.ListModelsAsync(CancellationToken.None).ConfigureAwait(false);
        var modelList = models.ToList();

        var exact = modelList.FirstOrDefault(m => string.Equals(m.Id, requested, StringComparison.OrdinalIgnoreCase));
        if (exact is not null) return exact.Id;

        var family = modelList
                         .Where(m => m.Id.Contains("claude-opus", StringComparison.OrdinalIgnoreCase))
                         .OrderByDescending(m => m.Id, StringComparer.OrdinalIgnoreCase)
                         .FirstOrDefault()
                     ?? modelList
                         .Where(m => m.Id.Contains("claude", StringComparison.OrdinalIgnoreCase))
                         .OrderByDescending(m => m.Id, StringComparer.OrdinalIgnoreCase)
                         .FirstOrDefault();
        if (family is not null) return family.Id;

        var any = modelList.FirstOrDefault();
        if (any is not null) return any.Id;
    }
    catch
    {
        // Listing failed - let session creation surface the real error.
    }

    return requested;
}

static async Task WriteAnnouncementsAsync(string path, AnnouncementsFile file)
{
    var outDir = Path.GetDirectoryName(Path.GetFullPath(path));
    if (!string.IsNullOrEmpty(outDir)) Directory.CreateDirectory(outDir);

    var json = JsonSerializer.Serialize(file, new JsonSerializerOptions
    {
        WriteIndented            = true,
        DefaultIgnoreCondition   = JsonIgnoreCondition.Never,
        Encoder                  = System.Text.Encodings.Web.JavaScriptEncoder.UnsafeRelaxedJsonEscaping
    });
    await File.WriteAllTextAsync(path, json + Environment.NewLine);
}

static void PrintUsage()
{
    Console.Error.WriteLine("""
Usage:
  dotnet run --file Get-SessionAnnouncements.cs -- \
    --summary    <path/to/summary.md> \
    --transcript <path/to/transcript.md> \
    --metadata   <path/to/rich-manifest.json> \
    --frames-dir <path/to/announcement-frames> \
    --out        <path/to/announcements.json> \
    [--model claude-opus-4.7-1m] \
    [--timeout-minutes 5] \
    [--window-seconds 90]

Parses `## Key announcements` from summary.md mechanically, builds a transcript
window per announcement, lists pre-sampled frames from disk, then asks GitHub
Copilot to enrich each announcement (category / longDescription / speakers /
explicitLinks / codeSnippets) under strict JSON output rules. Writes a single
announcements.json suitable for cross-session entity resolution.
""");
}

// ---- types ---------------------------------------------------------------

internal sealed record ParsedAnnouncement(
    string Name,
    string Timestamp,
    int    TimestampSeconds,
    string ShortDescription,
    bool   IsInferred);

internal sealed record TranscriptLine(int Seconds, string Text);

internal sealed record EnrichmentRequest(
    string       Name,
    string       Timestamp,
    int          TimestampSeconds,
    string       ShortDescription,
    bool         IsInferred,
    string       TranscriptWindow,
    List<string> Frames);

// ---- model response shape ------------------------------------------------

internal sealed class EnrichmentResponse
{
    [JsonPropertyName("announcements")]
    public List<EnrichedAnnouncement> Announcements { get; set; } = new();
}

internal sealed class EnrichedAnnouncement
{
    [JsonPropertyName("name")]            public string?            Name            { get; set; }
    [JsonPropertyName("timestamp")]       public string?            Timestamp       { get; set; }
    [JsonPropertyName("category")]        public string?            Category        { get; set; }
    [JsonPropertyName("longDescription")] public string?            LongDescription { get; set; }
    [JsonPropertyName("speakers")]        public List<string>?      Speakers        { get; set; }
    [JsonPropertyName("explicitLinks")]   public List<LinkEntry>?   ExplicitLinks   { get; set; }
    [JsonPropertyName("codeSnippets")]    public List<CodeSnippet>? CodeSnippets    { get; set; }
}

// ---- on-disk announcements.json shape -----------------------------------

internal sealed record AnnouncementsFile(
    [property: JsonPropertyName("schemaVersion")]   int             schemaVersion,
    [property: JsonPropertyName("sessionCode")]     string          sessionCode,
    [property: JsonPropertyName("sessionTitle")]    string          sessionTitle,
    [property: JsonPropertyName("sessionSpeakers")] List<string>    sessionSpeakers,
    [property: JsonPropertyName("durationMinutes")] int?            durationMinutes,
    [property: JsonPropertyName("extractedAt")]     string          extractedAt,
    [property: JsonPropertyName("model")]           string?         model,
    [property: JsonPropertyName("windowSeconds")]   int             windowSeconds,
    [property: JsonPropertyName("announcements")]   List<Announcement> announcements,
    [property: JsonPropertyName("errors")]          List<string>    errors);

internal sealed record Announcement(
    [property: JsonPropertyName("name")]             string            Name,
    [property: JsonPropertyName("category")]         string            Category,
    [property: JsonPropertyName("shortDescription")] string            ShortDescription,
    [property: JsonPropertyName("longDescription")]  string            LongDescription,
    [property: JsonPropertyName("timestamp")]        string            Timestamp,
    [property: JsonPropertyName("timestampSeconds")] int               TimestampSeconds,
    [property: JsonPropertyName("speakers")]         List<string>      Speakers,
    [property: JsonPropertyName("frames")]           List<string>      Frames,
    [property: JsonPropertyName("explicitLinks")]    List<LinkEntry>   ExplicitLinks,
    [property: JsonPropertyName("codeSnippets")]     List<CodeSnippet> CodeSnippets,
    [property: JsonPropertyName("isInferred")]       bool              IsInferred);

internal sealed class LinkEntry
{
    [JsonPropertyName("kind")] public string? Kind { get; set; }
    [JsonPropertyName("url")]  public string? Url  { get; set; }
}

internal sealed class CodeSnippet
{
    [JsonPropertyName("language")]  public string? Language  { get; set; }
    [JsonPropertyName("code")]      public string? Code      { get; set; }
    [JsonPropertyName("timestamp")] public string? Timestamp { get; set; }
}

// Subset of the rich-manifest.json shape we read. Extra fields silently
// ignored. PowerShell's ConvertTo-Json unwraps single-element arrays to a
// scalar; we don't read array-shaped fields here so we don't need the same
// converter Get-SessionSummary.cs has.
internal sealed record RichManifest(
    [property: JsonPropertyName("code")]            string? Code,
    [property: JsonPropertyName("title")]           string? Title,
    [property: JsonPropertyName("speakerNames")]    string? SpeakerNames,
    [property: JsonPropertyName("durationMinutes")] int?    DurationMinutes);
