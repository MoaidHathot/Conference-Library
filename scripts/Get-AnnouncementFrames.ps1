# Get-AnnouncementFrames.ps1
#
# For each ingested session that has a summary.md, parse the [HH:MM:SS]
# timestamps in the "Key announcements" section (and anywhere else in the
# summary) and ffmpeg-seek 4 frames around each one:
#
#     T - 10 s,  T - 5 s,  T + 5 s,  T + 10 s
#
# Output lands at:
#   sessions/<Conference>/<EventId>/<CODE>/announcement-frames/<HH-MM-SS>/frame-<offset>s.jpg
#
# Build-Book.ps1's Inject-AnnouncementFrames helper then surfaces these in the
# rendered summary as a hover-strip next to each timestamp.
#
# Idempotent: skips timestamps whose folder already contains all 4 frames
# unless -Force. Uses the same MP4 -> HLS fallback strategy as
# Invoke-BuildIngestion.ps1, and is safe to run before or after that script
# (it falls back gracefully when the rich-manifest has no playable video URL).
[CmdletBinding()]
param(
    [Parameter()][string]$Conference = 'Build',
    [Parameter()][string]$EventId    = '2026',

    # Per-side offsets in seconds around each announcement timestamp.
    [Parameter()][int[]]$Offsets = @(-10, -5, 5, 10),

    [Parameter()][ValidateRange(2, 31)][int]$JpegQuality = 5,
    [Parameter()][ValidateRange(1, 64)][int]$Concurrency = 8,

    # Bound on per-session ffmpeg work; 50 announcements * 4 frames * ~10 s
    # (HLS) ≈ 33 min for the worst case. Keeps a stuck Medius from wedging
    # the batch.
    [Parameter()][int]$TimeoutMinutes = 20,

    [Parameter()][string[]]$OnlyCodes = @(),

    # Re-run for sessions that already have all expected frames.
    [Parameter()][switch]$Force,

    [Parameter()][string]$FfmpegPath,

    [Parameter()][string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

if (-not $FfmpegPath) {
    $FfmpegPath = (Get-Command ffmpeg -ErrorAction SilentlyContinue)?.Source
    if (-not $FfmpegPath) {
        $portable = Join-Path $env:LOCALAPPDATA 'Zakira.Replay\portable\ffmpeg.exe'
        if (Test-Path -LiteralPath $portable) { $FfmpegPath = $portable }
    }
}
if (-not $FfmpegPath -or -not (Test-Path -LiteralPath $FfmpegPath)) {
    throw "ffmpeg not found. Pass -FfmpegPath or install ffmpeg on PATH."
}

$sessionsRoot = Join-Path $RepoRoot "sessions\$Conference\$EventId"
if (-not (Test-Path -LiteralPath $sessionsRoot)) {
    throw "Sessions root not found: $sessionsRoot. Run Invoke-BuildIngestion.ps1 -Conference $Conference -EventId $EventId first."
}

# Discover candidate sessions: must have summary.md AND rich-manifest.json
# with at least one of downloadVideoUrl / hlsUrl.
$candidates = Get-ChildItem -LiteralPath $sessionsRoot -Directory | ForEach-Object {
    $dir = $_.FullName
    $summary  = Join-Path $dir 'summary.md'
    $manifest = Join-Path $dir 'rich-manifest.json'
    if (-not (Test-Path -LiteralPath $summary))  { return }
    if (-not (Test-Path -LiteralPath $manifest)) { return }
    $m = try { Get-Content -Raw -LiteralPath $manifest | ConvertFrom-Json -Depth 12 } catch { $null }
    if (-not $m) { return }
    $videoUrl = if ($m.downloadVideoUrl) { $m.downloadVideoUrl } elseif ($m.hlsUrl) { $m.hlsUrl } else { $null }
    if (-not $videoUrl) { return }
    [pscustomobject]@{
        Code        = $_.Name
        Directory   = $dir
        SummaryPath = $summary
        VideoUrl    = $videoUrl
    }
}

if ($OnlyCodes.Count -gt 0) {
    $candidates = $candidates | Where-Object { $OnlyCodes -contains $_.Code }
}

if (-not $candidates -or $candidates.Count -eq 0) {
    Write-Warning "No summarizable sessions with a video source found under $sessionsRoot."
    return
}

Write-Host "Capturing announcement frames for $($candidates.Count) session(s)" -ForegroundColor Cyan
Write-Host "  Offsets (s):     $($Offsets -join ', ')"
Write-Host "  Concurrency:     $Concurrency"
Write-Host "  Timeout/session: $TimeoutMinutes min"
Write-Host "  ffmpeg:          $FfmpegPath"
Write-Host ''

$sw = [System.Diagnostics.Stopwatch]::StartNew()

$results = $candidates | ForEach-Object -ThrottleLimit $Concurrency -Parallel {
    $session     = $_
    $FfmpegPath  = $using:FfmpegPath
    $Offsets     = $using:Offsets
    $JpegQuality = $using:JpegQuality
    $Force       = $using:Force
    $TimeoutMin  = $using:TimeoutMinutes

    $deadline = (Get-Date).AddMinutes($TimeoutMin)

    # ---- helpers (must be re-declared inside the parallel scriptblock) ----
    function Parse-HmsToSeconds {
        param([string]$Hms)
        $parts = $Hms -split ':'
        if ($parts.Count -ne 3) { return -1 }
        $h = [int]$parts[0]; $m = [int]$parts[1]; $s = [int]$parts[2]
        return ($h * 3600) + ($m * 60) + $s
    }
    function Format-OffsetTag {
        param([int]$Offset)
        if ($Offset -ge 0) { return "p{0:00}s" -f $Offset }   # p05s, p10s
        else               { return "m{0:00}s" -f [Math]::Abs($Offset) }  # m05s, m10s
    }

    # ---- parse summary for timestamps ----
    # Match bare HH:MM:SS regardless of surrounding punctuation. Anchors below
    # the timestamp (?<![\d:]) and (?![\d:]) prevent partial matches inside
    # longer numeric strings (e.g. "0:00:00:00"). Captures both bracketed
    # ([00:14:10]), parenthesized ((00:14:10), (~00:14:10)), and bare
    # (00:14:10 in prose) forms.
    $summaryText = Get-Content -Raw -LiteralPath $session.SummaryPath
    $matches = [regex]::Matches($summaryText, '(?<![\d:])(\d{2}:\d{2}:\d{2})(?![\d:])')
    $uniqueTs = $matches | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
    if ($uniqueTs.Count -eq 0) {
        return [pscustomobject]@{ code = $session.Code; status = 'no-timestamps'; total = 0; captured = 0; skipped = 0; failed = 0; elapsedS = 0 }
    }

    # ffprobe once per session for the true video duration. Caps every
    # timestamp+offset combo to avoid past-end seeks (which produce ffmpeg
    # exit -22 and clutter the report with bogus "failed" frames). Hard
    # timeout via Process so a hanging stream doesn't wedge the worker.
    # Best-effort: if ffprobe errors out or times out, we fall through to
    # the previous "try everything" behaviour.
    $videoDurationSec = [double]::MaxValue
    $ffprobePath = $FfmpegPath -replace '(?i)ffmpeg(\.exe)?$', 'ffprobe$1'
    if (Test-Path -LiteralPath $ffprobePath) {
        try {
            $psi = [System.Diagnostics.ProcessStartInfo]@{
                FileName               = $ffprobePath
                UseShellExecute        = $false
                RedirectStandardOutput = $true
                RedirectStandardError  = $true
                CreateNoWindow         = $true
            }
            foreach ($a in @('-v','error','-show_entries','format=duration','-of','csv=p=0',$session.VideoUrl)) {
                [void]$psi.ArgumentList.Add($a)
            }
            $proc = [System.Diagnostics.Process]::Start($psi)
            $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
            [void]$proc.StandardError.ReadToEndAsync()
            if ($proc.WaitForExit(15000)) {  # 15-second hard cap
                [void]$stdoutTask.Wait()
                $probeOut = $stdoutTask.Result
                if ($probeOut) {
                    $probed = 0.0
                    if ([double]::TryParse(($probeOut | Out-String).Trim(),
                            [System.Globalization.NumberStyles]::Float,
                            [System.Globalization.CultureInfo]::InvariantCulture,
                            [ref]$probed) -and $probed -gt 0) {
                        $videoDurationSec = $probed
                    }
                }
            } else {
                try { $proc.Kill($true) } catch { }
            }
        } catch { }
    }

    $afRoot = Join-Path $session.Directory 'announcement-frames'
    New-Item -ItemType Directory -Path $afRoot -Force | Out-Null

    $ssw = [System.Diagnostics.Stopwatch]::StartNew()
    $total = 0; $captured = 0; $skipped = 0; $failed = 0

    foreach ($ts in $uniqueTs) {
        if ((Get-Date) -gt $deadline) {
            break  # session-level wall-clock budget exceeded
        }
        $tsSeconds = Parse-HmsToSeconds $ts
        if ($tsSeconds -lt 0) { continue }
        $folder = $ts -replace ':', '-'
        $folderPath = Join-Path $afRoot $folder
        New-Item -ItemType Directory -Path $folderPath -Force | Out-Null

        foreach ($offset in $Offsets) {
            $total++
            $target = $tsSeconds + $offset
            if ($target -lt 0 -or $target -ge $videoDurationSec) { $skipped++; continue }
            $tag = Format-OffsetTag $offset
            $framePath = Join-Path $folderPath "frame-$tag.jpg"
            if (-not $Force -and (Test-Path -LiteralPath $framePath) -and (Get-Item -LiteralPath $framePath).Length -gt 0) {
                $skipped++; continue
            }
            $ssArg = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0}', $target)
            # Capture at 1280px wide so the lightbox view (which uses the
            # same JPEG as the hover thumbnail) shows sharp detail when the
            # user clicks. CSS still renders these as 140px-wide thumbnails
            # in the hover strip. q5 keeps each frame ~70-110 KB.
            $ffArgs = @(
                '-hide_banner','-loglevel','error','-y'
                '-ss', $ssArg
                '-i', $session.VideoUrl
                '-frames:v','1'
                '-vf','scale=1280:-2'
                '-q:v', $JpegQuality
                $framePath
            )
            try {
                & $FfmpegPath @ffArgs 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $framePath) -and (Get-Item -LiteralPath $framePath).Length -gt 0) {
                    $captured++
                }
                else {
                    $failed++
                }
            }
            catch {
                $failed++
            }
            if ((Get-Date) -gt $deadline) { break }
        }
    }
    $ssw.Stop()

    return [pscustomobject]@{
        code     = $session.Code
        status   = if ($failed -eq 0 -and $captured -gt 0) { 'ok' }
                   elseif ($captured -gt 0) { 'partial' }
                   elseif ($skipped -gt 0) { 'up-to-date' }
                   else { 'failed' }
        total    = $total
        captured = $captured
        skipped  = $skipped
        failed   = $failed
        elapsedS = [Math]::Round($ssw.Elapsed.TotalSeconds, 1)
    }
}

$sw.Stop()

$ok       = @($results | Where-Object { $_.status -eq 'ok' })
$partial  = @($results | Where-Object { $_.status -eq 'partial' })
$failed   = @($results | Where-Object { $_.status -eq 'failed' })
$upToDate = @($results | Where-Object { $_.status -eq 'up-to-date' })
$noTs     = @($results | Where-Object { $_.status -eq 'no-timestamps' })
$totalCaptured = ($results | Measure-Object captured -Sum).Sum

Write-Host ''
Write-Host ("Announcement-frame capture complete in {0:N1}s." -f $sw.Elapsed.TotalSeconds) -ForegroundColor Cyan
Write-Host ("  ok:             {0}" -f $ok.Count)       -ForegroundColor Green
Write-Host ("  partial:        {0}" -f $partial.Count)  -ForegroundColor Yellow
Write-Host ("  failed:         {0}" -f $failed.Count)   -ForegroundColor $(if ($failed.Count -gt 0) { 'Red' } else { 'DarkGray' })
Write-Host ("  up-to-date:     {0}" -f $upToDate.Count) -ForegroundColor DarkGray
Write-Host ("  no-timestamps:  {0}" -f $noTs.Count)     -ForegroundColor DarkGray
Write-Host ("  frames captured this run: {0}" -f $totalCaptured) -ForegroundColor Cyan

$reportPath = Join-Path $RepoRoot "catalog\$Conference\$EventId\announcement-frames-report.json"
@{
    schemaVersion  = 1
    conference     = $Conference
    eventId        = $EventId
    completedAt    = (Get-Date).ToUniversalTime().ToString('o')
    elapsedSeconds = [Math]::Round($sw.Elapsed.TotalSeconds, 1)
    concurrency    = $Concurrency
    offsets        = $Offsets
    counts         = @{
        ok            = $ok.Count
        partial       = $partial.Count
        failed        = $failed.Count
        upToDate      = $upToDate.Count
        noTimestamps  = $noTs.Count
        framesTotal   = $totalCaptured
    }
    results        = $results
} | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $reportPath -Encoding utf8

Write-Host ''
Write-Host "Run report: $reportPath" -ForegroundColor Cyan
Write-Host "Next: scripts/Build-Book.ps1 -Conference $Conference -EventId $EventId" -ForegroundColor Cyan
