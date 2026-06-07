# Resolve-Themes.ps1
#
# Driver for Resolve-Themes.cs. Gathers every per-session summary.md
# (Overview paragraph) + rich-manifest.json (code, title, sessionType, tags)
# into a slim sessions-list.json, then invokes the .NET 10 file-based
# program which makes TWO Copilot calls (discover + assign) and writes:
#
#   catalog/<Conf>/<Event>/themes/
#     sessions-list.json        the input we built (also kept on disk for
#                               debugging - re-running the .cs alone is
#                               trivial when you tweak the prompt and just
#                               want the model output to change)
#     themes.json               Copilot's theme list with sessionCount
#                               tallied from the assignments
#     theme-assignments.json    per-session theme assignments (+ a sanity
#                               report of unknown codes / slugs / missing
#                               sessions that didn't get an assignment)
#     themes-report.json        run report (timing, counts, errors)
#
# Idempotent: re-running with the same source files skips the Copilot
# calls when both outputs exist AND are newer than the youngest summary.md.
# Pass -Force to bypass.
#
# Pure-PowerShell shape mirrors Get-SessionAnnouncements.ps1 - the heavy
# lifting is in the .cs, this just builds the input + invokes + reports.
[CmdletBinding()]
param(
    [Parameter()][string]$Conference = 'Build',
    [Parameter()][string]$EventId    = '2026',
    [Parameter()][string]$Model      = 'claude-opus-4.7-1m',

    # Per-Copilot-call timeout. Pass A is small (~110 KB prompt); Pass B
    # is the bigger one (~110 KB prompt + a ~30 KB response). 10 min per
    # call is generous on Claude Opus 1M.
    [Parameter()][ValidateRange(1, 30)][int]$TimeoutMinutes = 10,

    [Parameter()][switch]$Force,

    [Parameter()][string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$sessionsRoot = Join-Path $RepoRoot "sessions\$Conference\$EventId"
if (-not (Test-Path -LiteralPath $sessionsRoot)) {
    throw "Sessions root not found: $sessionsRoot. Run Invoke-BuildIngestion.ps1 and Get-SessionSummaries.ps1 first."
}
$themesScript = Join-Path $PSScriptRoot 'Resolve-Themes.cs'
if (-not (Test-Path -LiteralPath $themesScript)) {
    throw "Resolve-Themes.cs not found alongside this driver."
}

$outDir = Join-Path $RepoRoot "catalog\$Conference\$EventId\themes"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
$sessionsListPath   = Join-Path $outDir 'sessions-list.json'
$themesOutPath      = Join-Path $outDir 'themes.json'
$assignmentsOutPath = Join-Path $outDir 'theme-assignments.json'
$reportPath         = Join-Path $outDir 'themes-report.json'

# --------------------------------------------------------------------------
# helpers
# --------------------------------------------------------------------------

function Get-OverviewParagraph {
    # Extract the FIRST non-empty paragraph under `## Overview` in summary.md.
    # Falls back to the API description in rich-manifest.json when there's
    # no summary at all (rare - newly-ingested sessions before the summarizer
    # has run).
    param([string]$SummaryPath, [string]$FallbackDescription)
    if (-not (Test-Path -LiteralPath $SummaryPath)) {
        return ($FallbackDescription ?? '').Trim()
    }
    $md = Get-Content -Raw -LiteralPath $SummaryPath
    # Match the Overview section up to the next H2 (## ...) heading.
    $rx = '## Overview\s*\r?\n(?<body>(?:.+?\r?\n)*?)(?=\r?\n## |\Z)'
    $match = [regex]::Match($md, $rx, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if (-not $match.Success) {
        return ($FallbackDescription ?? '').Trim()
    }
    $body = $match.Groups['body'].Value.Trim()
    # First non-empty paragraph (split on blank line).
    $paragraphs = [regex]::Split($body, '\r?\n\r?\n') | Where-Object { $_.Trim() }
    if ($paragraphs.Count -eq 0) {
        return ($FallbackDescription ?? '').Trim()
    }
    return ($paragraphs[0] -replace '\r?\n', ' ').Trim()
}

# --------------------------------------------------------------------------
# build the sessions-list.json input payload
# --------------------------------------------------------------------------

$sessionDirs = Get-ChildItem -LiteralPath $sessionsRoot -Directory
$inputs = New-Object 'System.Collections.Generic.List[pscustomobject]'
$youngestSummary = [DateTime]::MinValue
$noSummaryCount  = 0
foreach ($d in $sessionDirs) {
    $manifestPath = Join-Path $d.FullName 'rich-manifest.json'
    if (-not (Test-Path -LiteralPath $manifestPath)) { continue }
    $m = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json -Depth 12

    $summaryPath = Join-Path $d.FullName 'summary.md'
    $summaryText = Get-OverviewParagraph -SummaryPath $summaryPath -FallbackDescription $m.description
    if (-not $summaryText) { $noSummaryCount++ }

    if (Test-Path -LiteralPath $summaryPath) {
        $sAge = (Get-Item -LiteralPath $summaryPath).LastWriteTimeUtc
        if ($sAge -gt $youngestSummary) { $youngestSummary = $sAge }
    }

    $inputs.Add([pscustomobject][ordered]@{
        code        = $m.code
        title       = $m.title
        summary     = $summaryText
        sessionType = $m.sessionType
        tags        = $m.tags
    }) | Out-Null
}
Write-Host "Built input for $($inputs.Count) session(s); $noSummaryCount fell back to catalog description (no summary.md)." -ForegroundColor DarkGray

$payload = [pscustomobject]@{
    schemaVersion = 1
    conference    = $Conference
    eventId       = $EventId
    sessions      = $inputs.ToArray()
}
$payload | ConvertTo-Json -Depth 6 |
    Set-Content -LiteralPath $sessionsListPath -Encoding utf8
Write-Host "Wrote input: $sessionsListPath" -ForegroundColor DarkGray

# --------------------------------------------------------------------------
# idempotency: skip when outputs are present and newer than every summary
# --------------------------------------------------------------------------

if (-not $Force -and
    (Test-Path -LiteralPath $themesOutPath) -and
    (Test-Path -LiteralPath $assignmentsOutPath)) {
    $tAge = (Get-Item -LiteralPath $themesOutPath).LastWriteTimeUtc
    $aAge = (Get-Item -LiteralPath $assignmentsOutPath).LastWriteTimeUtc
    if ($tAge -gt $youngestSummary -and $aAge -gt $youngestSummary) {
        Write-Host "Themes outputs already up-to-date (newer than every summary.md). Pass -Force to regenerate." -ForegroundColor Green
        return
    }
}

# --------------------------------------------------------------------------
# invoke the .NET 10 file-based program (two Copilot calls)
# --------------------------------------------------------------------------

Write-Host "Invoking Resolve-Themes.cs (model=$Model, timeout=${TimeoutMinutes}m per call)..." -ForegroundColor Cyan

$sw = [System.Diagnostics.Stopwatch]::StartNew()

$psi = [System.Diagnostics.ProcessStartInfo]@{
    FileName               = 'dotnet'
    UseShellExecute        = $false
    RedirectStandardOutput = $true
    RedirectStandardError  = $true
    CreateNoWindow         = $true
}
foreach ($a in @(
    'run','--file', $themesScript, '--'
    '--sessions-list',   $sessionsListPath
    '--themes-out',      $themesOutPath
    '--assignments-out', $assignmentsOutPath
    '--model',           $Model
    '--timeout-minutes', "$TimeoutMinutes"
)) { [void]$psi.ArgumentList.Add($a) }

$proc = [System.Diagnostics.Process]::Start($psi)
# Read both streams concurrently to avoid OS pipe buffer deadlocks. Live-
# streaming stderr via add_ErrorDataReceived has been observed to crash
# the host with "There is no Runspace available to run scripts" because
# the callback fires on a thread-pool thread without a PowerShell Runspace.
# Buffer it to a string + dump at the end - the user still sees Pass A
# vs Pass B progress, just after the process exits rather than live.
$stdoutTask = $proc.StandardOutput.ReadToEndAsync()
$stderrTask = $proc.StandardError.ReadToEndAsync()

# Hard wall-clock cap (two Copilot calls + restore + scaffolding overhead).
$exited = $proc.WaitForExit([int]([TimeSpan]::FromMinutes(2 * $TimeoutMinutes + 5).TotalMilliseconds))
if (-not $exited) {
    try { $proc.Kill($true) } catch { }
}
[void]$stdoutTask.Wait()
[void]$stderrTask.Wait()
$sw.Stop()

$exitCode   = if ($exited) { $proc.ExitCode } else { -1 }
$stderrText = $stderrTask.Result
# Dump the C# program's stderr lines (Pass A / Pass B progress, sanity
# warnings). Indented so they're visually distinct from the driver's own
# Write-Host lines.
if ($stderrText) {
    Write-Host ''
    Write-Host 'Resolve-Themes.cs stderr:' -ForegroundColor DarkGray
    $stderrText -split "`r?`n" | Where-Object { $_ } | ForEach-Object {
        Write-Host "  $_" -ForegroundColor DarkGray
    }
}

# --------------------------------------------------------------------------
# summary + report
# --------------------------------------------------------------------------

Write-Host ''
$status = switch ($exitCode) {
    0       { 'ok' }
    7       { 'ok-with-sanity-warnings' }
    -1      { 'timeout' }
    default { "exit-$exitCode" }
}
$colour = if ($status -eq 'ok') { 'Green' }
          elseif ($status -eq 'ok-with-sanity-warnings') { 'Yellow' }
          else { 'Red' }
Write-Host ("Resolve-Themes.cs finished in {0:N1}s with status: $status" -f $sw.Elapsed.TotalSeconds) -ForegroundColor $colour

$themesCount       = 0
$assignedCount     = 0
$missingCount      = 0
$unknownSlugsCount = 0
if ($exitCode -in @(0, 7) -and (Test-Path -LiteralPath $themesOutPath) -and (Test-Path -LiteralPath $assignmentsOutPath)) {
    $themes      = (Get-Content -Raw -LiteralPath $themesOutPath      | ConvertFrom-Json -Depth 8)
    $assignments = (Get-Content -Raw -LiteralPath $assignmentsOutPath | ConvertFrom-Json -Depth 8)
    $themesCount       = @($themes.themes).Count
    $assignedCount     = @($assignments.assignments).Count
    $missingCount      = @($assignments.missingCodes).Count
    $unknownSlugsCount = @($assignments.unknownSlugs).Count
    Write-Host "  Themes:      $themesCount"
    Write-Host "  Assignments: $assignedCount (of $($inputs.Count) sessions)"
    if ($missingCount -gt 0) {
        Write-Host "  Unassigned:  $missingCount session(s) - will appear under no theme" -ForegroundColor Yellow
    }
    if ($unknownSlugsCount -gt 0) {
        Write-Host "  Unknown slugs: $unknownSlugsCount dropped (model invented theme slugs)" -ForegroundColor Yellow
    }
    Write-Host ''
    Write-Host "Top 5 themes by sessionCount:"
    foreach ($t in (@($themes.themes) | Select-Object -First 5)) {
        Write-Host ("  [{0,3}x] {1}  ({2})" -f $t.sessionCount, $t.name, $t.slug)
    }
}

$report = [pscustomobject]@{
    schemaVersion     = 1
    conference        = $Conference
    eventId           = $EventId
    completedAt       = (Get-Date).ToUniversalTime().ToString('o')
    elapsedSeconds    = [Math]::Round($sw.Elapsed.TotalSeconds, 1)
    model             = $Model
    status            = $status
    exitCode          = $exitCode
    inputSessions     = $inputs.Count
    themesCount       = $themesCount
    assignedCount     = $assignedCount
    missingCount      = $missingCount
    unknownSlugsCount = $unknownSlugsCount
}
$report | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $reportPath -Encoding utf8

Write-Host ''
Write-Host "Run report: $reportPath" -ForegroundColor Cyan
Write-Host "Next: scripts/Build-Book.ps1 -Conference $Conference -EventId $EventId" -ForegroundColor Cyan

if ($exitCode -notin @(0, 7)) {
    exit $exitCode
}
