#!/usr/bin/env dotnet run
// Resolve-Themes.cs
// .NET 10 file-based program (run with `dotnet run --file <this>.cs -- <args>`).
//
// Discovers cross-cutting THEMES across a conference event, then assigns
// 1-3 themes per session. Two GitHub Copilot calls in one invocation,
// driven by Resolve-Themes.ps1.
//
// Pass A: given {code, title, summary} for every session, return 15-25
//         themes ({slug, name, description}).
// Pass B: given the theme list from Pass A and the same session list,
//         return per-session theme assignments (1-3 per session).
//
// Exit codes:
//   0  success - themes.json + theme-assignments.json written
//   2  bad arguments
//   3  missing input file
//   4  Copilot session error (network, model, permission, timeout)
//   5  empty / blank / non-JSON response from model
//   7  output sanity check failed
//
// Usage:
//   dotnet run --file Resolve-Themes.cs -- \
//     --sessions-list   catalog/Build/2026/themes/sessions-list.json \
//     --themes-out      catalog/Build/2026/themes/themes.json \
//     --assignments-out catalog/Build/2026/themes/theme-assignments.json \
//     [--model claude-opus-4.7-1m] [--timeout-minutes 10]

#:package GitHub.Copilot.SDK@0.3.0
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

string? sessionsListPath   = null;
string? themesOutPath      = null;
string? assignmentsOutPath = null;
string  model              = "claude-opus-4.7-1m";
int     timeoutMinutes     = 10;

for (var i = 0; i < args.Length; i++)
{
    switch (args[i])
    {
        case "--sessions-list":   sessionsListPath   = NextArg(); break;
        case "--themes-out":      themesOutPath      = NextArg(); break;
        case "--assignments-out": assignmentsOutPath = NextArg(); break;
        case "--model":           model              = NextArg(); break;
        case "--timeout-minutes": timeoutMinutes     = int.Parse(NextArg(), CultureInfo.InvariantCulture); break;
        case "--help" or "-h":    PrintUsage(); return 0;
        default:
            await Console.Error.WriteLineAsync($"Unknown argument: {args[i]}");
            PrintUsage();
            return 2;
    }
    string NextArg()
    {
        if (i + 1 >= args.Length) throw new ArgumentException($"Missing value for {args[i]}");
        return args[++i];
    }
}

if (sessionsListPath is null || themesOutPath is null || assignmentsOutPath is null)
{
    await Console.Error.WriteLineAsync("Missing required argument(s). Use --help for usage.");
    return 2;
}
if (!File.Exists(sessionsListPath))
{
    await Console.Error.WriteLineAsync($"Sessions list not found: {sessionsListPath}");
    return 3;
}

void PrintUsage() => Console.WriteLine(
    "Resolve-Themes.cs - discover themes and assign to sessions.\n\n" +
    "Required:\n" +
    "  --sessions-list    PATH    JSON with { sessions: [{code, title, summary, ...}] }\n" +
    "  --themes-out       PATH    Output themes.json\n" +
    "  --assignments-out  PATH    Output theme-assignments.json\n\n" +
    "Optional:\n" +
    "  --model            ID      Copilot model id (default: claude-opus-4.7-1m)\n" +
    "  --timeout-minutes  N       Per-call timeout (default: 10)");

// ---- shared constants -----------------------------------------------------

const string DiscoverSystemPrompt =
    "You are a conference taxonomy assistant. Given a list of Microsoft Build sessions (code, title, one-line summary), discover 15-25 cross-cutting THEMES that organise the sessions. " +
    "Each theme groups sessions by topic, not by format. AVOID format-based themes (do not output themes like 'Keynote', 'Lab', 'Lightning Talk'). " +
    "Aim for topical themes like 'AI Agents', 'Windows Development', 'Azure Infrastructure', 'Developer Experience', 'Multi-Agent Orchestration', 'Data & Analytics', 'Security & Identity'. " +
    "Themes should be MUTUALLY INFORMATIVE: a session that lands in two themes should reveal something different about it from each.\n\n" +
    "Each theme has three fields:\n" +
    "  slug:        kebab-case, [a-z0-9-]+, unique across the whole list, 2-4 words max\n" +
    "  name:        title-cased display name, 2-5 words\n" +
    "  description: ONE sentence (~25 words) defining the scope precisely enough that a human can tell whether a given session fits.\n\n" +
    "Output STRICT JSON only. No markdown fences. No commentary. The shape is:\n" +
    "{\n" +
    "  \"themes\": [\n" +
    "    { \"slug\": \"ai-agents\", \"name\": \"AI Agents\", \"description\": \"Building, orchestrating, and deploying autonomous AI agents across surfaces.\" }\n" +
    "  ]\n" +
    "}";

const string AssignSystemPrompt =
    "You are a conference taxonomy assistant. Given (a) a list of THEMES and (b) a list of conference sessions, assign 1-3 theme slugs to EACH session. " +
    "Prefer the smallest number of themes that captures the session's primary content. Use 2-3 only when the session genuinely sits at the intersection. " +
    "EVERY session in the input MUST appear in the output exactly once. EVERY assigned slug MUST appear in the input themes list verbatim - do not invent new slugs.\n\n" +
    "Output STRICT JSON only. No markdown fences. No commentary. The shape is:\n" +
    "{\n" +
    "  \"assignments\": [\n" +
    "    { \"code\": \"KEY01\", \"themes\": [\"ai-agents\", \"developer-experience\"] },\n" +
    "    { \"code\": \"BRK200\", \"themes\": [\"ai-agents\"] }\n" +
    "  ]\n" +
    "}";

var JsonOpts = new JsonSerializerOptions
{
    PropertyNameCaseInsensitive = true,
    ReadCommentHandling         = JsonCommentHandling.Skip,
    AllowTrailingCommas         = true
};

var JsonOptsWrite = new JsonSerializerOptions
{
    WriteIndented            = true,
    DefaultIgnoreCondition   = JsonIgnoreCondition.WhenWritingNull,
    PropertyNamingPolicy     = JsonNamingPolicy.CamelCase
};

// ---- read input -----------------------------------------------------------

SessionsListFile sessionsFile;
try
{
    var json = await File.ReadAllTextAsync(sessionsListPath).ConfigureAwait(false);
    sessionsFile = JsonSerializer.Deserialize<SessionsListFile>(json, JsonOpts)
                   ?? throw new InvalidOperationException("null payload");
}
catch (Exception ex)
{
    await Console.Error.WriteLineAsync($"Failed to read sessions list ({sessionsListPath}): {ex.Message}");
    return 3;
}

var sessions = sessionsFile.Sessions ?? new List<SessionInput>();
if (sessions.Count == 0)
{
    await Console.Error.WriteLineAsync("Sessions list is empty - nothing to do.");
    return 3;
}

await Console.Error.WriteLineAsync($"Loaded {sessions.Count} session(s) from {sessionsListPath}");

// ---- shared Copilot client ------------------------------------------------

await using var client = new CopilotClient(new CopilotClientOptions
{
    Cwd             = Environment.CurrentDirectory,
    UseLoggedInUser = true
});

await client.StartAsync().ConfigureAwait(false);

var resolvedModel = await ResolveModelAsync(client, model);
if (!string.Equals(resolvedModel, model, StringComparison.OrdinalIgnoreCase))
{
    await Console.Error.WriteLineAsync($"Requested model '{model}' unavailable; using '{resolvedModel}'.");
}

// ---- Pass A: discover themes ---------------------------------------------

await Console.Error.WriteLineAsync("Pass A (discover): asking model for themes...");
var passAStarted = DateTimeOffset.UtcNow;
var passAPrompt  = BuildPassAPrompt(sessions);
var rawA = await CallCopilotAsync(client, resolvedModel, DiscoverSystemPrompt, passAPrompt, timeoutMinutes);
if (rawA is null) { await client.StopAsync().ConfigureAwait(false); return 4; }
if (string.IsNullOrWhiteSpace(rawA))
{
    await Console.Error.WriteLineAsync("Pass A returned empty content.");
    await client.StopAsync().ConfigureAwait(false);
    return 5;
}

ThemesResponse? themesResp;
try
{
    themesResp = JsonSerializer.Deserialize<ThemesResponse>(ExtractJsonObject(rawA), JsonOpts);
}
catch (Exception ex)
{
    await Console.Error.WriteLineAsync($"Pass A: failed to parse JSON ({ex.Message}). Raw response:");
    await Console.Error.WriteLineAsync(rawA);
    await client.StopAsync().ConfigureAwait(false);
    return 5;
}
if (themesResp?.Themes is null || themesResp.Themes.Count == 0)
{
    await Console.Error.WriteLineAsync("Pass A: themes list is empty.");
    await client.StopAsync().ConfigureAwait(false);
    return 5;
}

// Normalize slug + collect set for Pass B validation.
foreach (var t in themesResp.Themes)
{
    t.Slug = (t.Slug ?? string.Empty).Trim().ToLowerInvariant();
    t.Name = (t.Name ?? string.Empty).Trim();
    t.Description = (t.Description ?? string.Empty).Trim();
}
var slugSet = new HashSet<string>(themesResp.Themes.Select(t => t.Slug), StringComparer.Ordinal);
var passAElapsed = DateTimeOffset.UtcNow - passAStarted;
await Console.Error.WriteLineAsync($"Pass A: got {themesResp.Themes.Count} themes in {passAElapsed.TotalSeconds:F1}s.");

// ---- Pass B: assign themes per session -----------------------------------

await Console.Error.WriteLineAsync("Pass B (assign): asking model for per-session assignments...");
var passBStarted = DateTimeOffset.UtcNow;
var passBPrompt  = BuildPassBPrompt(sessions, themesResp.Themes);
var rawB = await CallCopilotAsync(client, resolvedModel, AssignSystemPrompt, passBPrompt, timeoutMinutes);
if (rawB is null) { await client.StopAsync().ConfigureAwait(false); return 4; }
if (string.IsNullOrWhiteSpace(rawB))
{
    await Console.Error.WriteLineAsync("Pass B returned empty content.");
    await client.StopAsync().ConfigureAwait(false);
    return 5;
}

AssignmentsResponse? assignResp;
try
{
    assignResp = JsonSerializer.Deserialize<AssignmentsResponse>(ExtractJsonObject(rawB), JsonOpts);
}
catch (Exception ex)
{
    await Console.Error.WriteLineAsync($"Pass B: failed to parse JSON ({ex.Message}). Raw response (first 2000 chars):");
    await Console.Error.WriteLineAsync(rawB.Length > 2000 ? rawB.Substring(0, 2000) : rawB);
    await client.StopAsync().ConfigureAwait(false);
    return 5;
}

await client.StopAsync().ConfigureAwait(false);

if (assignResp?.Assignments is null)
{
    await Console.Error.WriteLineAsync("Pass B: assignments list missing.");
    return 5;
}
var passBElapsed = DateTimeOffset.UtcNow - passBStarted;
await Console.Error.WriteLineAsync($"Pass B: got {assignResp.Assignments.Count} assignments in {passBElapsed.TotalSeconds:F1}s.");

// ---- sanity-check the assignments ----------------------------------------

var codeSet      = new HashSet<string>(sessions.Select(s => s.Code), StringComparer.OrdinalIgnoreCase);
var sanitized    = new List<SessionAssignment>(assignResp.Assignments.Count);
var unknownCodes = new List<string>();
var unknownSlugs = new SortedSet<string>(StringComparer.Ordinal);
var missingCodes = new List<string>(codeSet);
var perThemeCount = new Dictionary<string, int>(StringComparer.Ordinal);
foreach (var slug in slugSet) perThemeCount[slug] = 0;

foreach (var a in assignResp.Assignments)
{
    var code = (a.Code ?? string.Empty).Trim();
    if (!codeSet.Contains(code)) { unknownCodes.Add(code); continue; }
    missingCodes.Remove(code);

    var keepSlugs = new List<string>();
    foreach (var s in (a.Themes ?? new List<string>()))
    {
        var slug = (s ?? string.Empty).Trim().ToLowerInvariant();
        if (string.IsNullOrEmpty(slug)) continue;
        if (!slugSet.Contains(slug)) { unknownSlugs.Add(slug); continue; }
        if (keepSlugs.Contains(slug)) continue;
        keepSlugs.Add(slug);
        perThemeCount[slug] = perThemeCount[slug] + 1;
    }
    sanitized.Add(new SessionAssignment { Code = code, Themes = keepSlugs });
}

if (unknownCodes.Count > 0)
    await Console.Error.WriteLineAsync($"Sanity: {unknownCodes.Count} assignment(s) referenced unknown session codes; dropped.");
if (unknownSlugs.Count > 0)
    await Console.Error.WriteLineAsync($"Sanity: {unknownSlugs.Count} unknown theme slug(s) referenced; dropped. ({string.Join(", ", unknownSlugs.Take(10))}...)");
if (missingCodes.Count > 0)
    await Console.Error.WriteLineAsync($"Sanity: {missingCodes.Count} session(s) without any assignment - they'll appear under no theme.");

// Update sessionCount on the themes list using the per-theme tally.
foreach (var t in themesResp.Themes)
{
    t.SessionCount = perThemeCount.TryGetValue(t.Slug, out var c) ? c : 0;
}

// ---- write outputs --------------------------------------------------------

var generatedAt = DateTime.UtcNow.ToString("o");
Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(themesOutPath))!);
Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(assignmentsOutPath))!);

await File.WriteAllTextAsync(themesOutPath,
    JsonSerializer.Serialize(new ThemesFile
    {
        SchemaVersion = 1,
        GeneratedAt   = generatedAt,
        Model         = resolvedModel,
        TotalSessions = sessions.Count,
        Themes        = themesResp.Themes.OrderByDescending(t => t.SessionCount).ThenBy(t => t.Slug, StringComparer.Ordinal).ToList()
    }, JsonOptsWrite)).ConfigureAwait(false);

await File.WriteAllTextAsync(assignmentsOutPath,
    JsonSerializer.Serialize(new AssignmentsFile
    {
        SchemaVersion = 1,
        GeneratedAt   = generatedAt,
        Model         = resolvedModel,
        TotalSessions = sessions.Count,
        Assignments   = sanitized.OrderBy(a => a.Code, StringComparer.OrdinalIgnoreCase).ToList(),
        UnknownCodes  = unknownCodes,
        UnknownSlugs  = unknownSlugs.ToList(),
        MissingCodes  = missingCodes
    }, JsonOptsWrite)).ConfigureAwait(false);

await Console.Error.WriteLineAsync($"Wrote {themesOutPath}");
await Console.Error.WriteLineAsync($"Wrote {assignmentsOutPath}");
return (unknownSlugs.Count == 0 && unknownCodes.Count == 0) ? 0 : 7;

// =============================================================================
// Helpers (top-level local functions + record / model types follow below).
// =============================================================================

static string BuildPassAPrompt(List<SessionInput> sessions)
{
    var sb = new StringBuilder();
    sb.AppendLine("Discover themes from this session list. Each row is `CODE | TITLE | SUMMARY`.");
    sb.AppendLine();
    foreach (var s in sessions)
    {
        sb.Append(s.Code).Append(" | ").Append(SanitizeOneLine(s.Title)).Append(" | ").AppendLine(SanitizeOneLine(s.Summary));
    }
    sb.AppendLine();
    sb.Append("Total sessions: ").Append(sessions.Count).AppendLine(". Now produce the themes JSON described in the system message.");
    return sb.ToString();
}

static string BuildPassBPrompt(List<SessionInput> sessions, List<ThemeRecord> themes)
{
    var sb = new StringBuilder();
    sb.AppendLine("THEMES (slug | name | description):");
    foreach (var t in themes)
    {
        sb.Append(t.Slug).Append(" | ").Append(t.Name).Append(" | ").AppendLine(SanitizeOneLine(t.Description));
    }
    sb.AppendLine();
    sb.AppendLine("SESSIONS (CODE | TITLE | SUMMARY):");
    foreach (var s in sessions)
    {
        sb.Append(s.Code).Append(" | ").Append(SanitizeOneLine(s.Title)).Append(" | ").AppendLine(SanitizeOneLine(s.Summary));
    }
    sb.AppendLine();
    sb.Append("Now produce the assignments JSON described in the system message. EVERY one of the ").Append(sessions.Count).AppendLine(" sessions above MUST appear in the output.");
    return sb.ToString();
}

static string SanitizeOneLine(string? s)
{
    if (string.IsNullOrEmpty(s)) return string.Empty;
    var line = s.Replace("\r", " ").Replace("\n", " ").Replace("|", "/");
    return Regex.Replace(line, @"\s+", " ").Trim();
}

static async Task<string?> CallCopilotAsync(
    CopilotClient client, string model, string systemPrompt, string userPrompt, int timeoutMinutes)
{
    var response   = new StringBuilder();
    var completion = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);

    await using var session = await client.CreateSessionAsync(new SessionConfig
    {
        Model = model,
        OnPermissionRequest = PermissionHandler.ApproveAll,
        SystemMessage = new SystemMessageConfig
        {
            Mode    = SystemMessageMode.Replace,
            Content = systemPrompt
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
        Prompt      = userPrompt,
        Attachments = []
    }, CancellationToken.None).ConfigureAwait(false);

    try
    {
        await completion.Task.WaitAsync(TimeSpan.FromMinutes(timeoutMinutes)).ConfigureAwait(false);
    }
    catch (TimeoutException)
    {
        await Console.Error.WriteLineAsync($"Copilot call timed out after {timeoutMinutes}m.");
        return null;
    }
    catch (Exception ex)
    {
        await Console.Error.WriteLineAsync($"Copilot error: {ex.Message}");
        return null;
    }

    return response.ToString().Trim();
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
    catch { /* listing failed - let session creation surface the real error */ }
    return requested;
}

static string ExtractJsonObject(string raw)
{
    // Strip ```json ... ``` fences and any leading commentary; return the
    // substring from the first '{' through the matching final '}'.
    var trimmed = raw.Trim();
    if (trimmed.StartsWith("```"))
    {
        var firstNewline = trimmed.IndexOf('\n');
        if (firstNewline > 0) trimmed = trimmed.Substring(firstNewline + 1);
        var fenceEnd = trimmed.LastIndexOf("```", StringComparison.Ordinal);
        if (fenceEnd > 0) trimmed = trimmed.Substring(0, fenceEnd);
        trimmed = trimmed.Trim();
    }
    var firstBrace = trimmed.IndexOf('{');
    var lastBrace  = trimmed.LastIndexOf('}');
    if (firstBrace < 0 || lastBrace <= firstBrace) return trimmed;
    return trimmed.Substring(firstBrace, lastBrace - firstBrace + 1);
}

// ---- input / output model types -------------------------------------------

public class SessionsListFile
{
    public int SchemaVersion { get; set; }
    public string? Conference { get; set; }
    public string? EventId { get; set; }
    public List<SessionInput>? Sessions { get; set; }
}

public class SessionInput
{
    public string Code { get; set; } = string.Empty;
    public string? Title { get; set; }
    public string? Summary { get; set; }
    public string? SessionType { get; set; }
    public List<string>? Tags { get; set; }
}

public class ThemeRecord
{
    public string Slug { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public int SessionCount { get; set; }
}

public class ThemesResponse
{
    public List<ThemeRecord>? Themes { get; set; }
}

public class ThemesFile
{
    public int SchemaVersion { get; set; }
    public string? GeneratedAt { get; set; }
    public string? Model { get; set; }
    public int TotalSessions { get; set; }
    public List<ThemeRecord>? Themes { get; set; }
}

public class SessionAssignment
{
    public string Code { get; set; } = string.Empty;
    public List<string> Themes { get; set; } = new();
}

public class AssignmentsResponse
{
    public List<SessionAssignment>? Assignments { get; set; }
}

public class AssignmentsFile
{
    public int SchemaVersion { get; set; }
    public string? GeneratedAt { get; set; }
    public string? Model { get; set; }
    public int TotalSessions { get; set; }
    public List<SessionAssignment>? Assignments { get; set; }
    public List<string>? UnknownCodes { get; set; }
    public List<string>? UnknownSlugs { get; set; }
    public List<string>? MissingCodes { get; set; }
}
