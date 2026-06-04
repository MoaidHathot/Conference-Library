# Get-SessionSummaries.ps1
#
# For each ingested session, invoke scripts/Get-SessionSummary.cs (the .NET 10
# file-based program) which calls GitHub Copilot to produce summary.md from
# transcript.md + rich-manifest.json. Idempotent: skips sessions that already
# have summary.md unless -Force.
#
# Concurrency lives here, not in the C# tool. The Copilot SDK opens a fresh
# session per invocation; running N in parallel keeps each session
# independent and trivially cancellable.
[CmdletBinding()]
param(
    [Parameter()][string]$Conference = 'Build',

    [Parameter()][string]$EventId = '2026',

    # Default 10 to match the ingestion driver. The Copilot SDK can absolutely
    # run 10 sessions in parallel against the signed-in user's tier; if you
    # hit rate limits (HTTP 429 in the C# tool's stderr), drop to 4-6.
    [Parameter()][ValidateRange(1, 32)][int]$Concurrency = 10,

    # Model id passed through to the C# tool. claude-opus-4.7-1m is the
    # long-context (1M token) Anthropic Opus variant — handles the ~500 KB
    # transcripts of long keynotes without truncation.
    [Parameter()][string]$Model = 'claude-opus-4.7-1m',

    [Parameter()][int]$TimeoutMinutes = 5,

    [Parameter()][string[]]$OnlyCodes = @(),

    # Reprocess sessions that already have summary.md.
    [Parameter()][switch]$Force,

    [Parameter()][string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$sessionsRoot = Join-Path $RepoRoot "sessions\$Conference\$EventId"
if (-not (Test-Path -LiteralPath $sessionsRoot)) {
    throw "Sessions root not found: $sessionsRoot. Run Invoke-BuildIngestion.ps1 -Conference $Conference -EventId $EventId first."
}
$summarizerScript = Join-Path $PSScriptRoot 'Get-SessionSummary.cs'
if (-not (Test-Path -LiteralPath $summarizerScript)) {
    throw "Summarizer C# script not found: $summarizerScript"
}

# Discover candidate sessions: a session is summarizable when it has
# transcript.md AND rich-manifest.json. We don't care about frames here.
$candidates = Get-ChildItem -LiteralPath $sessionsRoot -Directory | ForEach-Object {
    $dir = $_.FullName
    $transcript = Join-Path $dir 'transcript.md'
    $manifest   = Join-Path $dir 'rich-manifest.json'
    if ((Test-Path -LiteralPath $transcript) -and (Test-Path -LiteralPath $manifest)) {
        [pscustomobject]@{
            Code         = $_.Name
            Directory    = $dir
            Transcript   = $transcript
            Manifest     = $manifest
            SummaryPath  = Join-Path $dir 'summary.md'
        }
    }
}

if ($OnlyCodes.Count -gt 0) {
    $candidates = $candidates | Where-Object { $OnlyCodes -contains $_.Code }
}

if (-not $candidates -or $candidates.Count -eq 0) {
    Write-Warning "No summarizable sessions found under $sessionsRoot."
    return
}

# Idempotency filter: skip sessions whose summary.md exists AND was generated
# from a transcript that hasn't changed since (mtime comparison). Cheap and
# good enough for our re-run cadence.
if (-not $Force) {
    $candidates = $candidates | Where-Object {
        if (-not (Test-Path -LiteralPath $_.SummaryPath)) { return $true }
        $summaryAge   = (Get-Item -LiteralPath $_.SummaryPath).LastWriteTimeUtc
        $transcriptAge = (Get-Item -LiteralPath $_.Transcript).LastWriteTimeUtc
        return $transcriptAge -gt $summaryAge
    }
}

if (-not $candidates -or $candidates.Count -eq 0) {
    Write-Host "All summaries are up to date. Pass -Force to regenerate." -ForegroundColor Green
    return
}

Write-Host "Summarizing $($candidates.Count) session(s) under $sessionsRoot" -ForegroundColor Cyan
Write-Host "  Model:          $Model"
Write-Host "  Concurrency:    $Concurrency"
Write-Host "  Timeout:        $TimeoutMinutes min/session"
Write-Host "  Summarizer:     $summarizerScript"
Write-Host ''

$sw = [System.Diagnostics.Stopwatch]::StartNew()

$results = $candidates | ForEach-Object -ThrottleLimit $Concurrency -Parallel {
    $session          = $_
    $summarizerScript = $using:summarizerScript
    $model            = $using:Model
    $timeoutMinutes   = $using:TimeoutMinutes

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
        'run','--file', $summarizerScript, '--'
        '--transcript', $session.Transcript
        '--metadata',   $session.Manifest
        '--out',        $session.SummaryPath
        '--model',      $model
        '--timeout-minutes', "$timeoutMinutes"
    )) { [void]$psi.ArgumentList.Add($a) }

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $proc = [System.Diagnostics.Process]::Start($psi)
    # Read both streams concurrently to avoid a deadlock when one fills its
    # OS pipe buffer (transcripts can produce large stderr on retries).
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

    $status = if ($exitCode -eq 0) { 'ok' } elseif ($exitCode -eq -1) { 'timeout' } else { "exit-$exitCode" }
    return [pscustomobject]@{
        code     = $session.Code
        status   = $status
        elapsedS = [Math]::Round($sw.Elapsed.TotalSeconds, 1)
        stderr   = $stderrText
    }
}

$sw.Stop()

# --------------------------------------------------------------------------
# Summarise.
# --------------------------------------------------------------------------

$ok     = @($results | Where-Object { $_.status -eq 'ok' })
$failed = @($results | Where-Object { $_.status -ne 'ok' })

Write-Host ''
Write-Host ("Summaries complete in {0:N1}s." -f $sw.Elapsed.TotalSeconds) -ForegroundColor Cyan
Write-Host ("  ok:     {0}" -f $ok.Count) -ForegroundColor Green
$failedColor = if ($failed.Count -gt 0) { 'Red' } else { 'DarkGray' }
Write-Host ("  failed: {0}" -f $failed.Count) -ForegroundColor $failedColor

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

$reportPath = Join-Path $RepoRoot "catalog\$Conference\$EventId\summaries-report.json"
@{
    schemaVersion  = 1
    eventId        = $EventId
    completedAt    = (Get-Date).ToUniversalTime().ToString('o')
    elapsedSeconds = [Math]::Round($sw.Elapsed.TotalSeconds, 1)
    concurrency    = $Concurrency
    model          = $Model
    counts         = @{ ok = $ok.Count; failed = $failed.Count }
    results        = $results | Select-Object code, status, elapsedS  # omit stderr from disk report
} | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $reportPath -Encoding utf8

Write-Host ''
Write-Host "Run report: $reportPath" -ForegroundColor Cyan
Write-Host "Next: scripts/Build-Book.ps1 -Conference $Conference -EventId $EventId" -ForegroundColor Cyan
