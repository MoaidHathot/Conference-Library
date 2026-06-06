# Get-SessionAnnouncements.ps1
#
# For each session with a summary.md, invoke scripts/Get-SessionAnnouncements.cs
# (the .NET 10 file-based program) which calls GitHub Copilot to enrich the
# session's `## Key announcements` bullets into a strict-JSON file
# (announcements.json) suitable for cross-session entity resolution.
#
# Idempotent: skips sessions whose announcements.json is newer than their
# summary.md unless -Force.
#
# Concurrency lives here, not in the C# tool. The Copilot SDK opens a fresh
# session per invocation; running N in parallel keeps each session
# independent and trivially cancellable. Mirrors the parallelism pattern
# used by Get-SessionSummaries.ps1.
[CmdletBinding()]
param(
    [Parameter()][string]$Conference = 'Build',

    [Parameter()][string]$EventId = '2026',

    # Default 10 to match the summarizer driver. If you hit rate limits
    # (HTTP 429 in the C# tool's stderr), drop to 4-6.
    [Parameter()][ValidateRange(1, 32)][int]$Concurrency = 10,

    # Model id passed through to the C# tool. claude-opus-4.7-1m is the
    # long-context (1M token) Anthropic Opus variant - handles wide
    # transcript windows without truncation even for keynote-length sessions.
    [Parameter()][string]$Model = 'claude-opus-4.7-1m',

    [Parameter()][int]$TimeoutMinutes = 5,

    # Transcript window (in seconds) +/- around each announcement timestamp
    # that the LLM is asked to enrich from. 90 s is a comfortable single
    # speaker beat; 180 s captures back-and-forth demos.
    [Parameter()][ValidateRange(30, 600)][int]$WindowSeconds = 90,

    [Parameter()][string[]]$OnlyCodes = @(),

    # Reprocess sessions that already have an up-to-date announcements.json.
    [Parameter()][switch]$Force,

    [Parameter()][string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$sessionsRoot = Join-Path $RepoRoot "sessions\$Conference\$EventId"
if (-not (Test-Path -LiteralPath $sessionsRoot)) {
    throw "Sessions root not found: $sessionsRoot. Run Invoke-BuildIngestion.ps1 -Conference $Conference -EventId $EventId and Get-SessionSummaries.ps1 first."
}
$extractorScript = Join-Path $PSScriptRoot 'Get-SessionAnnouncements.cs'
if (-not (Test-Path -LiteralPath $extractorScript)) {
    throw "Announcements extractor C# script not found: $extractorScript"
}

# Discover candidate sessions: must have summary.md, transcript.md, and
# rich-manifest.json. The frames dir is optional - if absent, the extractor
# emits an empty frames[] array for each announcement.
$candidates = Get-ChildItem -LiteralPath $sessionsRoot -Directory | ForEach-Object {
    $dir = $_.FullName
    $summary    = Join-Path $dir 'summary.md'
    $transcript = Join-Path $dir 'transcript.md'
    $manifest   = Join-Path $dir 'rich-manifest.json'
    $framesDir  = Join-Path $dir 'announcement-frames'
    if ((Test-Path -LiteralPath $summary) -and
        (Test-Path -LiteralPath $transcript) -and
        (Test-Path -LiteralPath $manifest)) {
        [pscustomobject]@{
            Code              = $_.Name
            Directory         = $dir
            Summary           = $summary
            Transcript        = $transcript
            Manifest          = $manifest
            FramesDir         = $framesDir
            AnnouncementsPath = Join-Path $dir 'announcements.json'
        }
    }
}

if ($OnlyCodes.Count -gt 0) {
    $candidates = $candidates | Where-Object { $OnlyCodes -contains $_.Code }
}

if (-not $candidates -or $candidates.Count -eq 0) {
    Write-Warning "No summarized sessions found under $sessionsRoot. Run Get-SessionSummaries.ps1 first."
    return
}

# Idempotency filter: skip sessions whose announcements.json exists AND is
# newer than the summary it was derived from. We also re-run when the
# transcript has moved newer than the existing announcements.json so any
# upstream re-ingest re-triggers a re-extraction.
if (-not $Force) {
    $candidates = $candidates | Where-Object {
        if (-not (Test-Path -LiteralPath $_.AnnouncementsPath)) { return $true }
        $annAge        = (Get-Item -LiteralPath $_.AnnouncementsPath).LastWriteTimeUtc
        $summaryAge    = (Get-Item -LiteralPath $_.Summary).LastWriteTimeUtc
        $transcriptAge = (Get-Item -LiteralPath $_.Transcript).LastWriteTimeUtc
        return ($summaryAge -gt $annAge) -or ($transcriptAge -gt $annAge)
    }
}

if (-not $candidates -or $candidates.Count -eq 0) {
    Write-Host "All announcements are up to date. Pass -Force to regenerate." -ForegroundColor Green
    return
}

Write-Host "Extracting announcements for $($candidates.Count) session(s) under $sessionsRoot" -ForegroundColor Cyan
Write-Host "  Model:          $Model"
Write-Host "  Concurrency:    $Concurrency"
Write-Host "  Window:         +/-$WindowSeconds s around each announcement timestamp"
Write-Host "  Timeout:        $TimeoutMinutes min/session"
Write-Host "  Extractor:      $extractorScript"
Write-Host ''

$sw = [System.Diagnostics.Stopwatch]::StartNew()

$results = $candidates | ForEach-Object -ThrottleLimit $Concurrency -Parallel {
    $session         = $_
    $extractorScript = $using:extractorScript
    $model           = $using:Model
    $timeoutMinutes  = $using:TimeoutMinutes
    $windowSeconds   = $using:WindowSeconds

    # Use System.Diagnostics.Process directly: PowerShell's Start-Process -Wait
    # inside ForEach-Object -Parallel was observed to hang for several minutes
    # even after the child process exited (suspected handle-release issue with
    # RedirectStandard{Output,Error} files in a parallel runspace). Direct
    # Process invocation with async stream reads is reliable.
    $psi = [System.Diagnostics.ProcessStartInfo]@{
        FileName               = 'dotnet'
        UseShellExecute        = $false
        RedirectStandardOutput = $true
        RedirectStandardError  = $true
        CreateNoWindow         = $true
    }
    foreach ($a in @(
        'run','--file', $extractorScript, '--'
        '--summary',         $session.Summary
        '--transcript',      $session.Transcript
        '--metadata',        $session.Manifest
        '--frames-dir',      $session.FramesDir
        '--out',             $session.AnnouncementsPath
        '--model',           $model
        '--timeout-minutes', "$timeoutMinutes"
        '--window-seconds',  "$windowSeconds"
    )) { [void]$psi.ArgumentList.Add($a) }

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $proc = [System.Diagnostics.Process]::Start($psi)
    # Read both streams concurrently to avoid a deadlock when one fills its
    # OS pipe buffer.
    $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
    $stderrTask = $proc.StandardError.ReadToEndAsync()
    # Hard wall-clock cap so a wedged Copilot session can't block the batch.
    $exited = $proc.WaitForExit([int]([TimeSpan]::FromMinutes($timeoutMinutes + 2).TotalMilliseconds))
    if (-not $exited) {
        try { $proc.Kill($true) } catch { }
    }
    [void]$stdoutTask.Wait()
    [void]$stderrTask.Wait()
    $sw.Stop()

    $exitCode   = if ($exited) { $proc.ExitCode } else { -1 }
    $stderrText = $stderrTask.Result

    # Exit code 6 is "no key announcements in summary" - legitimate, not a
    # failure. The file is still written (empty) so the skip rule on the
    # next run is correct.
    $status = switch ($exitCode) {
        0       { 'ok' }
        6       { 'empty' }
        -1      { 'timeout' }
        default { "exit-$exitCode" }
    }

    # Best-effort count of how many announcements we ended up with, for the
    # run report. We re-read the file rather than parsing stderr.
    $count = 0
    if ((Test-Path -LiteralPath $session.AnnouncementsPath) -and ($status -eq 'ok' -or $status -eq 'empty')) {
        try {
            $j = Get-Content -Raw -LiteralPath $session.AnnouncementsPath | ConvertFrom-Json -Depth 20
            if ($j.announcements) { $count = @($j.announcements).Count }
        } catch { }
    }

    return [pscustomobject]@{
        code     = $session.Code
        status   = $status
        count    = $count
        elapsedS = [Math]::Round($sw.Elapsed.TotalSeconds, 1)
        stderr   = $stderrText
    }
}

$sw.Stop()

# --------------------------------------------------------------------------
# Summarise.
# --------------------------------------------------------------------------

$ok     = @($results | Where-Object { $_.status -eq 'ok' })
$empty  = @($results | Where-Object { $_.status -eq 'empty' })
$failed = @($results | Where-Object { $_.status -notin @('ok','empty') })
$totalAnnouncements = ($results | Measure-Object count -Sum).Sum

Write-Host ''
Write-Host ("Announcement extraction complete in {0:N1}s." -f $sw.Elapsed.TotalSeconds) -ForegroundColor Cyan
Write-Host ("  ok:     {0}" -f $ok.Count) -ForegroundColor Green
Write-Host ("  empty:  {0}  (no '## Key announcements' bullets)" -f $empty.Count) -ForegroundColor DarkGray
$failedColor = if ($failed.Count -gt 0) { 'Red' } else { 'DarkGray' }
Write-Host ("  failed: {0}" -f $failed.Count) -ForegroundColor $failedColor
Write-Host ("  announcements captured this run: {0}" -f $totalAnnouncements) -ForegroundColor Cyan

if ($failed.Count -gt 0) {
    Write-Host ''
    Write-Host 'Failed sessions (re-run with -OnlyCodes to retry):' -ForegroundColor Yellow
    $failed | Sort-Object code | ForEach-Object {
        Write-Host ("  [{0}] {1} ({2}s)" -f $_.status, $_.code, $_.elapsedS) -ForegroundColor Yellow
        if ($_.stderr) {
            $_.stderr -split "`r?`n" | Where-Object { $_ } | Select-Object -First 3 | ForEach-Object {
                Write-Host ("      $_") -ForegroundColor DarkYellow
            }
        }
    }
}

$reportPath = Join-Path $RepoRoot "catalog\$Conference\$EventId\announcements-report.json"
@{
    schemaVersion  = 1
    conference     = $Conference
    eventId        = $EventId
    completedAt    = (Get-Date).ToUniversalTime().ToString('o')
    elapsedSeconds = [Math]::Round($sw.Elapsed.TotalSeconds, 1)
    concurrency    = $Concurrency
    model          = $Model
    windowSeconds  = $WindowSeconds
    counts         = @{
        ok            = $ok.Count
        empty         = $empty.Count
        failed        = $failed.Count
        announcements = $totalAnnouncements
    }
    results        = $results | Select-Object code, status, count, elapsedS  # omit stderr from disk report
} | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $reportPath -Encoding utf8

Write-Host ''
Write-Host "Run report: $reportPath" -ForegroundColor Cyan
Write-Host "Next: scripts/Resolve-AnnouncementEntities.ps1 -Conference $Conference -EventId $EventId" -ForegroundColor Cyan
