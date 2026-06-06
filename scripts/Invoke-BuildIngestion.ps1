# Invoke-BuildIngestion.ps1
#
# Iterate the Build catalog and, for each session:
#   - fetch the Medius embed page (onDemand URL), extract captionsConfiguration
#     JS object, pick the SAS-signed VTT for --CaptionLanguages, download it
#   - convert VTT -> transcript.md
#   - ffmpeg-seek N evenly-spaced frames from downloadVideoLink -> frames/*.jpg
#   - render the API's aiDescription -> ai-description.html (placeholder until
#     Get-SessionSummaries.ps1 runs)
#   - write rich-manifest.json (catalog metadata + artifact paths)
#
# Why not the API's captionFileLink? That URL serves a Microsoft Word .docx
# (the official accessibility transcript document), not a VTT. The Medius
# embed page inlines a captionsConfiguration block with SAS-signed
# Caption_<lang>.vtt URLs that we can download directly — same path
# Zakira.Replay's MediusTranscriptInterceptor uses, ported here.
#
# Idempotent: re-running skips sessions whose rich-manifest.json's
# `catalogFetchedAt` matches the current catalog snapshot. -Force bypasses.
[CmdletBinding()]
param(
    [Parameter()][string]$Conference = 'Build',

    [Parameter()][string]$EventId = '2026',

    [Parameter()][ValidateRange(1, 200)][int]$FrameCount = 15,

    [Parameter()][ValidateRange(2, 31)][int]$JpegQuality = 4,

    [Parameter()][ValidateRange(1, 64)][int]$Concurrency = 10,

    # Comma- or array-friendly caption language preferences. The Medius embed
    # advertises ~36 languages per session; we pick the first one matching
    # by primary BCP-47 subtag (en matches en-US, en-GB, etc.).
    [Parameter()][string[]]$CaptionLanguages = @('en'),

    [Parameter()][string[]]$OnlyCodes = @(),

    [Parameter()][switch]$Force,

    [Parameter()][string]$FfmpegPath,

    # Path to the Zakira.Replay CLI binary (or the .NET tool entrypoint). When set, sessions
    # whose `onDemand` URL points to `mediastream.microsoft.com` (Microsoft Build "InstaVOD"
    # Shaka-player wrappers like BRK247 / BRK201) are routed through `zakira-replay analyze
    # --prefer-inline-media`, whose `MediastreamTranscriptInterceptor` fetches the player
    # config JSON, resolves the HLS master URL, downloads the subtitle playlist's
    # `Segment(N).vtt` files in parallel, dedupes the rolling captions, and emits a clean
    # merged VTT this script then copies to `transcript.vtt`. Mandatory for those sessions;
    # plain Medius sessions (medius.microsoft.com / medius.studios.ms) continue to work via
    # the in-script `Get-MediusEmbedInfo` path even when this is unset. Resolution:
    #   1) -ZakiraReplayPath argument
    #   2) ZAKIRA_REPLAY env var
    #   3) `zakira-replay` on PATH
    [Parameter()][string]$ZakiraReplayPath,

    [Parameter()][string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

# --------------------------------------------------------------------------
# Locate ffmpeg.
# --------------------------------------------------------------------------

if (-not $FfmpegPath) {
    $FfmpegPath = (Get-Command ffmpeg -ErrorAction SilentlyContinue)?.Source
    if (-not $FfmpegPath) {
        $portable = Join-Path $env:LOCALAPPDATA 'Zakira.Replay\portable\ffmpeg.exe'
        if (Test-Path -LiteralPath $portable) { $FfmpegPath = $portable }
    }
}
if (-not $FfmpegPath -or -not (Test-Path -LiteralPath $FfmpegPath)) {
    throw "ffmpeg not found. Pass -FfmpegPath, install ffmpeg on PATH, or run ``zakira-replay deps install ffmpeg``."
}

# --------------------------------------------------------------------------
# Locate zakira-replay (optional). When unset we degrade gracefully:
# mediastream-hosted sessions become 'partial' with a clear error message
# instead of failing the run.
# --------------------------------------------------------------------------

if (-not $ZakiraReplayPath) {
    if ($env:ZAKIRA_REPLAY) {
        $ZakiraReplayPath = $env:ZAKIRA_REPLAY
    }
    else {
        $ZakiraReplayPath = (Get-Command zakira-replay -ErrorAction SilentlyContinue)?.Source
    }
}
if ($ZakiraReplayPath -and -not (Test-Path -LiteralPath $ZakiraReplayPath)) {
    Write-Warning "ZakiraReplayPath '$ZakiraReplayPath' does not exist; mediastream sessions will fail with a clear error. Install via ``dotnet tool install -g Zakira.Replay`` or unset to use PATH lookup."
    $ZakiraReplayPath = $null
}

$catalogPath = Join-Path $RepoRoot "catalog\$Conference\$EventId\catalog.json"
if (-not (Test-Path -LiteralPath $catalogPath)) {
    throw "Catalog not found: $catalogPath. Run scripts/Get-BuildCatalog.ps1 -Conference $Conference -EventId $EventId first."
}

$sessionsRoot = Join-Path $RepoRoot "sessions\$Conference\$EventId"
New-Item -ItemType Directory -Path $sessionsRoot -Force | Out-Null

$catalog = Get-Content -Raw -LiteralPath $catalogPath | ConvertFrom-Json -Depth 20
$catalogFetchedAt = $catalog.fetchedAt

$sessions = $catalog.sessions
if ($OnlyCodes.Count -gt 0) {
    $sessions = $sessions | Where-Object { $OnlyCodes -contains $_.sessionCode }
    Write-Host "Filtered to $($sessions.Count) session(s) by -OnlyCodes." -ForegroundColor Cyan
}

Write-Host "Ingesting $($sessions.Count) session(s) from $catalogPath" -ForegroundColor Cyan
Write-Host "  Frames per session: $FrameCount (qscale $JpegQuality)"
Write-Host "  Concurrency:        $Concurrency"
Write-Host "  Caption languages:  $($CaptionLanguages -join ', ')"
Write-Host "  ffmpeg:             $FfmpegPath"
Write-Host "  zakira-replay:      $(if ($ZakiraReplayPath) { $ZakiraReplayPath } else { '(not configured; mediastream sessions will fail)' })"
Write-Host "  Output root:        $sessionsRoot"
Write-Host ''

# --------------------------------------------------------------------------
# Per-session worker (inlined; PowerShell ForEach-Object -Parallel refuses to
# capture scriptblock values via $using:).
# --------------------------------------------------------------------------

$sw = [System.Diagnostics.Stopwatch]::StartNew()
$results = $sessions | ForEach-Object -ThrottleLimit $Concurrency -Parallel {
    $Session          = $_
    $SessionsRoot     = $using:sessionsRoot
    $FfmpegPath       = $using:FfmpegPath
    $FrameCount       = $using:FrameCount
    $JpegQuality      = $using:JpegQuality
    $CaptionLanguages = $using:CaptionLanguages
    $CatalogFetchedAt = $using:catalogFetchedAt
    $Force            = $using:Force
    $ZakiraReplayPath = $using:ZakiraReplayPath

    $code = $Session.sessionCode
    if ([string]::IsNullOrWhiteSpace($code)) {
        return [pscustomobject]@{ code = '(no code)'; status = 'skipped'; reason = 'session has no sessionCode'; errors = @(); frames = 0 }
    }

    $sessionDir = Join-Path $SessionsRoot $code
    $manifestPath = Join-Path $sessionDir 'rich-manifest.json'

    if (-not $Force -and (Test-Path -LiteralPath $manifestPath)) {
        try {
            $existing = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json -Depth 5
            if ($existing.ingestion.catalogFetchedAt -eq $CatalogFetchedAt) {
                return [pscustomobject]@{ code = $code; status = 'skipped'; reason = 'up-to-date'; errors = @(); frames = 0 }
            }
        }
        catch { }
    }

    New-Item -ItemType Directory -Path $sessionDir -Force | Out-Null

    # ---- helpers ----

    function Extract-BraceBalancedJson {
        # Walk forward from $OpenIndex (the '{' position) counting brace depth
        # while skipping over string literals so braces inside strings don't
        # unbalance the count. Returns null on truncated/malformed input.
        param([string]$Text, [int]$OpenIndex)
        $depth   = 0
        $inStr   = $false
        $escaped = $false
        for ($i = $OpenIndex; $i -lt $Text.Length; $i++) {
            $c = $Text[$i]
            if ($inStr) {
                if ($escaped) { $escaped = $false; continue }
                if ($c -eq '\') { $escaped = $true; continue }
                if ($c -eq '"') { $inStr = $false }
                continue
            }
            switch ($c) {
                '"' { $inStr = $true }
                '{' { $depth++ }
                '}' {
                    $depth--
                    if ($depth -eq 0) {
                        return $Text.Substring($OpenIndex, $i - $OpenIndex + 1)
                    }
                }
            }
        }
        return $null
    }

    function Get-MediusEmbedInfo {
        # Fetch the Medius embed HTML once and pull TWO things out of it:
        #   1. The SAS-signed VTT caption URL matching the requested language
        #      preferences (primary BCP-47 subtag match: 'en' matches 'en-US').
        #   2. An HLS (.m3u8) URL pointing at the on-demand video stream, used
        #      as a frame-sampling fallback when the catalog has no
        #      downloadVideoLink (e.g. recent breakouts that only expose the
        #      Medius streaming player, no direct MP4 download).
        #
        # Returns @{ CaptionUrl=...; CaptionLanguage=...; HlsUrl=... } with any
        # missing piece set to $null; or $null if the page itself was
        # unreachable.
        param([string]$EmbedUrl, [string[]]$Preferences)
        try {
            $html = Invoke-WebRequest -Uri $EmbedUrl -UseBasicParsing -TimeoutSec 60 |
                    Select-Object -ExpandProperty Content
        }
        catch {
            return $null
        }

        $captionUrl = $null
        $captionLang = $null
        $hlsUrl = $null

        # ---- caption pick ----
        $marker = $html.IndexOf('captionsConfiguration')
        if ($marker -ge 0) {
            $open = $html.IndexOf('{', $marker)
            if ($open -ge 0) {
                $json = Extract-BraceBalancedJson -Text $html -OpenIndex $open
                if ($json) {
                    try {
                        $cfg = $json | ConvertFrom-Json -Depth 10
                        if ($cfg.languageList) {
                            $entries = @()
                            foreach ($entry in $cfg.languageList) {
                                if (-not $entry.src) { continue }
                                $lang = $null
                                if ($entry.src -match '/Caption_([A-Za-z]{2,3}(?:-[A-Za-z0-9]{2,8})*)\.(?:vtt|srt)\b') {
                                    $lang = $Matches[1]
                                }
                                elseif ($entry.srclang) {
                                    $lang = $entry.srclang
                                }
                                $entries += [pscustomobject]@{ Url = $entry.src; Language = $lang }
                            }
                            $pick = $null
                            foreach ($pref in $Preferences) {
                                if ([string]::IsNullOrWhiteSpace($pref)) { continue }
                                $prefPrimary = ($pref -split '-')[0].ToLowerInvariant()
                                $pick = $entries | Where-Object {
                                    $entryPrimary = if ($_.Language) { ($_.Language -split '-')[0].ToLowerInvariant() } else { '' }
                                    $entryPrimary -eq $prefPrimary
                                } | Select-Object -First 1
                                if ($pick) { break }
                            }
                            if (-not $pick) {
                                $pick = $entries | Where-Object {
                                    $p = if ($_.Language) { ($_.Language -split '-')[0].ToLowerInvariant() } else { '' }
                                    $p -eq 'en'
                                } | Select-Object -First 1
                            }
                            if (-not $pick -and $entries.Count -gt 0) { $pick = $entries[0] }
                            if ($pick) {
                                $captionUrl = $pick.Url
                                $captionLang = $pick.Language
                            }
                        }
                    }
                    catch { }
                }
            }
        }

        # ---- HLS pick ----
        # The Medius player serves HLS from stream.event.microsoft.com under
        # two regions ('prodwe' = west europe, 'prodnc' = north central US).
        # Both refer to the same content; either works for frame extraction.
        # Prefer the first one the page advertises (which is usually the
        # geo-optimal route).
        $hlsMatches = [regex]::Matches($html, 'https?://[^"\s'']+\.m3u8[^"\s'']*')
        if ($hlsMatches.Count -gt 0) {
            $hlsUrl = $hlsMatches[0].Value
        }

        return [pscustomobject]@{
            CaptionUrl      = $captionUrl
            CaptionLanguage = $captionLang
            HlsUrl          = $hlsUrl
        }
    }

    function Test-IsMediastreamPlayerUrl {
        # Returns $true when $Url is a Microsoft mediastream.microsoft.com Shaka-player
        # wrapper carrying a `path=` query (the only shape Zakira.Replay's
        # MediastreamTranscriptInterceptor can resolve). Mirrors the C# detection in
        # MediastreamTranscriptInterceptor.IsMediastreamPlayerUrl so the two stay in sync.
        param([string]$Url)
        if ([string]::IsNullOrWhiteSpace($Url)) { return $false }
        $uri = $null
        if (-not [Uri]::TryCreate($Url, [UriKind]::Absolute, [ref]$uri)) { return $false }
        if ($uri.Host.ToLowerInvariant() -ne 'mediastream.microsoft.com') { return $false }
        if ($uri.AbsolutePath -notmatch '(?i)player\.html') { return $false }
        return $uri.Query -match '(?i)path='
    }

    function Get-MediastreamSessionInfo {
        # For sessions whose onDemand URL points to mediastream.microsoft.com (BRK247 / BRK201
        # shape), shell out to Zakira.Replay's `analyze --prefer-inline-media` which runs the
        # MediastreamTranscriptInterceptor: fetches the player config JSON, resolves the HLS
        # master URL via cdns + manifests, downloads the subtitle playlist's Segment(N).vtt
        # files in parallel, dedupes the rolling captions, and writes a merged VTT.
        #
        # We then copy the merged VTT into $SessionDir as transcript.vtt (mirroring the
        # Medius path's output shape) and read the run's manifest.json to lift the HLS master
        # URL out for the frame-extraction step. Returns $null when zakira-replay isn't
        # configured OR when the analyze invocation produced no usable artifacts.
        param(
            [string]$EmbedUrl,
            [string]$SessionDir,
            [string]$ZakiraReplayPath,
            [string]$Code,
            [string[]]$CaptionLanguages
        )
        if ([string]::IsNullOrWhiteSpace($ZakiraReplayPath)) {
            return $null
        }

        # Pin a deterministic per-session run-id + runs-directory so the run is locatable from
        # PowerShell without parsing zakira-replay's stdout. Keeping the runs alongside the
        # session dir means cleanup is trivial (rm .zakira-runs) and the cache hits on re-run.
        $runsDir = Join-Path $SessionDir '.zakira-runs'
        $runId   = "mediastream-$Code"
        New-Item -ItemType Directory -Path $runsDir -Force | Out-Null

        $captionPref = if ($CaptionLanguages -and $CaptionLanguages.Count -gt 0) {
            $CaptionLanguages -join ','
        } else { 'auto' }

        $psi = [System.Diagnostics.ProcessStartInfo]@{
            FileName               = $ZakiraReplayPath
            UseShellExecute        = $false
            RedirectStandardOutput = $true
            RedirectStandardError  = $true
            CreateNoWindow         = $true
        }
        # Env var pins where the runs/ tree lands so the parallel sessions don't collide on a
        # shared cwd. Mirrored against the official precedence in Zakira.Replay's
        # DependencyResolver (env var > config > <cwd>/runs).
        $psi.Environment['ZAKIRA_REPLAY_RUNS_DIRECTORY'] = $runsDir
        foreach ($a in @(
            'analyze', $EmbedUrl,
            '--prefer-inline-media',
            '--capture-mode', 'browser',
            # Pin frames to a tiny interval-strategy budget. We're invoking Zakira.Replay
            # ONLY for the transcript (the mediastream interceptor's caption pipeline);
            # Conference-Library extracts its own 15 frames downstream via ffmpeg seeks
            # against the resolved HLS URL. Without these flags the default scene-strategy
            # extraction makes ffmpeg scan the entire 45-65 min HLS stream looking for
            # scene cuts, which can take 5+ minutes per session and routinely trips the
            # 7-minute timeout on longer sessions (LIVE101).
            '--frames', '1',
            '--frame-strategy', 'interval',
            '--cache',
            '--run-id', $runId,
            '--caption-languages', $captionPref,
            '--output-format', 'json'
        )) { [void]$psi.ArgumentList.Add($a) }

        $proc = [System.Diagnostics.Process]::Start($psi)
        $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
        $stderrTask = $proc.StandardError.ReadToEndAsync()
        # 7-minute cap: a typical 47-minute session like BRK247 has ~700 4s VTT segments;
        # at 16-way parallelism (the interceptor's bounded concurrency) and ~500ms per
        # segment fetch on Azure Front Door, that's ~22s for transcript download. The rest
        # is browser navigation (~5-10s with --prefer-inline-media). 7 minutes is ~10x the
        # observed ceiling, generous enough for slow networks but bounded so a hung run
        # doesn't stall a 443-session batch.
        if (-not $proc.WaitForExit(420000)) {
            try { $proc.Kill($true) } catch { }
            return [pscustomobject]@{
                Error = "zakira-replay analyze timed out after 7 minutes for $EmbedUrl"
            }
        }
        [void]$stdoutTask.Wait()
        [void]$stderrTask.Wait()
        if ($proc.ExitCode -ne 0) {
            $errPayload = ($stderrTask.Result | Out-String).Trim()
            if ([string]::IsNullOrWhiteSpace($errPayload)) { $errPayload = ($stdoutTask.Result | Out-String).Trim() }
            return [pscustomobject]@{
                Error = "zakira-replay analyze exit=$($proc.ExitCode): $errPayload"
            }
        }

        # Walk the run dir for the artifacts the interceptor produced. Cleanest source of
        # truth is manifest.json's artifact index; fall back to disk-walk if the schema
        # shifts under us.
        $runDir = Join-Path $runsDir $runId
        if (-not (Test-Path -LiteralPath $runDir)) {
            return [pscustomobject]@{
                Error = "zakira-replay completed but produced no run directory at $runDir"
            }
        }

        $manifestPath = Join-Path $runDir 'manifest.json'
        $hlsFromRun   = $null
        if (Test-Path -LiteralPath $manifestPath) {
            try {
                $runManifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json -Depth 12
                # The HLS master URL the MediastreamTranscriptInterceptor resolved (the same
                # URL the browser frame-extraction sidestep used) isn't persisted as a
                # top-level manifest field today; it surfaces inside the structured
                # CAPTURE_MEDIASTREAM_TRANSCRIPT_DISCOVERED warning message in the exact
                # form "...resolved to HLS master: <url>". Parse it back out; falls back
                # gracefully when the warning shape ever changes.
                $discovered = $runManifest.warnings | Where-Object {
                    $_.code -eq 'CAPTURE_MEDIASTREAM_TRANSCRIPT_DISCOVERED'
                } | Select-Object -First 1
                if ($discovered -and $discovered.message -match 'resolved to HLS master:\s*(?<url>https?\S+)') {
                    $hlsFromRun = $Matches['url']
                }
            }
            catch { }
        }

        # Find the merged VTT. The interceptor writes one file matching mediastream-NNNN-*.vtt
        # under captions/. There should be exactly one per --caption-languages pick.
        $captionsDir = Join-Path $runDir 'captions'
        $mergedVtt = if (Test-Path -LiteralPath $captionsDir) {
            Get-ChildItem -LiteralPath $captionsDir -Filter 'mediastream-*.vtt' -File -ErrorAction SilentlyContinue |
                Sort-Object Length -Descending | Select-Object -First 1
        } else { $null }

        if (-not $mergedVtt) {
            # If no VTT but we DID get the HLS URL, frame extraction can still proceed.
            # Caller emits a partial-status warning.
            return [pscustomobject]@{
                CaptionUrl      = $null
                CaptionLanguage = $null
                HlsUrl          = $hlsFromRun
                LocalVttPath    = $null
                Error           = if ($hlsFromRun) { 'mediastream session yielded no captions (frames-only)' } else { 'mediastream session yielded no captions and no HLS URL' }
            }
        }

        # Infer the language tag from the file name: mediastream-NNNN-<lang>.vtt
        $lang = $null
        if ($mergedVtt.BaseName -match '^mediastream-\d{4}-(?<lang>.+)$') {
            $lang = $Matches['lang']
        }

        return [pscustomobject]@{
            # CaptionUrl is the player config URL (audit trail) since the actual captions are
            # assembled from N segments, not a single URL.
            CaptionUrl      = $EmbedUrl
            CaptionLanguage = $lang
            HlsUrl          = $hlsFromRun
            LocalVttPath    = $mergedVtt.FullName
            Error           = $null
        }
    }

    function Convert-VttToMarkdown {
        param([string]$VttContent)
        $sb = [System.Text.StringBuilder]::new()
        $lines = $VttContent -split "`r?`n"
        $i = 0
        while ($i -lt $lines.Length -and $lines[$i] -notmatch '-->') { $i++ }
        while ($i -lt $lines.Length) {
            $line = $lines[$i]
            if ($line -match '^(\d{2}:)?(\d{2}):(\d{2})[.,](\d{3})\s*-->\s*(\d{2}:)?(\d{2}):(\d{2})[.,](\d{3})') {
                $start = ($line -split '-->')[0].Trim() -replace '\..*$', ''
                $i++
                $textLines = @()
                while ($i -lt $lines.Length -and -not [string]::IsNullOrWhiteSpace($lines[$i])) {
                    $cue = $lines[$i]
                    if ($cue -match '^<v\s+([^>]+)>(.*?)(</v>)?$') {
                        $cue = "[$($Matches[1].Trim())] $($Matches[2])"
                    }
                    $cue = [regex]::Replace($cue, '<[^>]+>', '')
                    $textLines += $cue
                    $i++
                }
                $text = ($textLines -join ' ').Trim()
                if (-not [string]::IsNullOrWhiteSpace($text)) {
                    [void]$sb.AppendLine("**[$start]** $text")
                }
            }
            $i++
        }
        return $sb.ToString().TrimEnd()
    }

    function Get-FacetValues {
        # IMPORTANT: PowerShell's `return` unwraps single-element collections,
        # which would cause single-tag/single-topic sessions to serialise as
        # JSON scalars instead of arrays in rich-manifest.json. The comma
        # operator (`,$out`) wraps the result in a length-1 array, which the
        # `return` unwrap then peels off back to the original $out array,
        # preserving its collection identity even when it has one element.
        param($Facets)
        if ($null -eq $Facets) { return ,@() }
        $out = @()
        foreach ($f in @($Facets)) {
            if ($f -is [string]) { $out += $f; continue }
            if ($f.displayValue) { $out += $f.displayValue; continue }
            if ($f.logicalValue) { $out += $f.logicalValue }
        }
        return ,$out
    }
    function Get-FacetValue {
        param($Facet)
        if ($null -eq $Facet) { return $null }
        if ($Facet -is [string]) { return $Facet }
        if ($Facet.displayValue) { return $Facet.displayValue }
        if ($Facet.logicalValue) { return $Facet.logicalValue }
        return $null
    }
    function Get-EvenlySpacedTimestamps {
        param([double]$DurationSeconds, [int]$Count)
        if ($DurationSeconds -le 0 -or $Count -lt 1) { return @() }
        $step = $DurationSeconds / ($Count + 1)
        return @(1..$Count | ForEach-Object { [Math]::Round($step * $_, 1) })
    }
    function Format-Timestamp {
        param([double]$Seconds)
        $ts = [TimeSpan]::FromSeconds($Seconds)
        if ($ts.TotalHours -ge 1) {
            return "{0:00}-{1:00}-{2:00}" -f [int]$ts.TotalHours, $ts.Minutes, $ts.Seconds
        }
        return "{0:00}-{1:00}" -f $ts.Minutes, $ts.Seconds
    }

    # ---- pipeline ----

    $errors          = @()
    $captionRel      = $null
    $transcriptRel   = $null
    $captionLangUsed = $null
    $framesRel       = @()
    $summaryRel      = $null
    $docxRel         = $null
    $hlsUrl          = $null

    # 1. Fetch the on-demand transcript + HLS URL. Two distinct player flavours appear in the
    #    Microsoft Build catalog and require different scraping strategies:
    #      Medius        (medius.microsoft.com / medius.studios.ms) - inline captionsConfiguration
    #                    + coreConfiguration in the embed HTML; Get-MediusEmbedInfo handles
    #                    both in a single HTML fetch.
    #      Mediastream   (mediastream.microsoft.com/.../player.html?path=Config-*.json) - the
    #                    embed HTML has NO inline captions; the player config JSON lives at the
    #                    URL given in the `path=` query, points to an HLS master with a separate
    #                    Segment(N).vtt subtitle playlist, and the captions are rolling cues that
    #                    must be downloaded in parallel and deduped. Get-MediastreamSessionInfo
    #                    delegates to `zakira-replay analyze --prefer-inline-media` which runs
    #                    Zakira.Replay's MediastreamTranscriptInterceptor.
    $mediusInfo = $null
    if ([string]::IsNullOrWhiteSpace($Session.onDemand)) {
        $errors += 'no onDemand URL; cannot reach Medius/Mediastream embed for VTT or HLS'
    }
    elseif (Test-IsMediastreamPlayerUrl -Url $Session.onDemand) {
        # Mediastream branch. Delegates to Zakira.Replay's interceptor; copies the merged VTT
        # into $sessionDir to match the artifact shape the Medius branch produces.
        if ([string]::IsNullOrWhiteSpace($ZakiraReplayPath)) {
            $errors += 'mediastream session needs Zakira.Replay; pass -ZakiraReplayPath or install via ``dotnet tool install -g Zakira.Replay``'
        }
        else {
            $mediastreamInfo = Get-MediastreamSessionInfo `
                -EmbedUrl         $Session.onDemand `
                -SessionDir       $sessionDir `
                -ZakiraReplayPath $ZakiraReplayPath `
                -Code             $code `
                -CaptionLanguages $CaptionLanguages
            if ($null -eq $mediastreamInfo) {
                $errors += 'zakira-replay invocation produced no result for mediastream session'
            }
            elseif ($mediastreamInfo.Error) {
                $errors += $mediastreamInfo.Error
                if ($mediastreamInfo.HlsUrl) { $hlsUrl = $mediastreamInfo.HlsUrl }
            }
            else {
                $hlsUrl = $mediastreamInfo.HlsUrl
                if ($mediastreamInfo.LocalVttPath -and (Test-Path -LiteralPath $mediastreamInfo.LocalVttPath)) {
                    try {
                        $vttPath = Join-Path $sessionDir 'transcript.vtt'
                        Copy-Item -LiteralPath $mediastreamInfo.LocalVttPath -Destination $vttPath -Force
                        $vttContent = Get-Content -Raw -LiteralPath $vttPath -Encoding utf8
                        $md = Convert-VttToMarkdown -VttContent $vttContent
                        $mdPath = Join-Path $sessionDir 'transcript.md'
                        Set-Content -LiteralPath $mdPath -Value $md -Encoding utf8
                        $captionRel = 'transcript.vtt'
                        $transcriptRel = 'transcript.md'
                        $captionLangUsed = $mediastreamInfo.CaptionLanguage
                    }
                    catch {
                        $errors += "mediastream VTT copy/parse failed ($($mediastreamInfo.CaptionLanguage)): $($_.Exception.Message)"
                    }
                }
            }
        }
    }
    else {
        # Medius branch (the original path; unchanged behaviour for medius.microsoft.com URLs).
        $mediusInfo = Get-MediusEmbedInfo -EmbedUrl $Session.onDemand -Preferences $CaptionLanguages
        if (-not $mediusInfo) {
            $errors += 'Medius embed unreachable or unparseable'
        }
        else {
            $hlsUrl = $mediusInfo.HlsUrl
            if (-not $mediusInfo.CaptionUrl) {
                $errors += 'Medius embed has no parseable captionsConfiguration'
            }
            else {
                try {
                    $vttPath = Join-Path $sessionDir 'transcript.vtt'
                    Invoke-WebRequest -Uri $mediusInfo.CaptionUrl -OutFile $vttPath -UseBasicParsing -TimeoutSec 60 | Out-Null
                    $vttContent = Get-Content -Raw -LiteralPath $vttPath -Encoding utf8
                    $md = Convert-VttToMarkdown -VttContent $vttContent
                    $mdPath = Join-Path $sessionDir 'transcript.md'
                    Set-Content -LiteralPath $mdPath -Value $md -Encoding utf8
                    $captionRel = 'transcript.vtt'
                    $transcriptRel = 'transcript.md'
                    $captionLangUsed = $mediusInfo.CaptionLanguage
                }
                catch {
                    $errors += "Medius VTT download/parse failed ($($mediusInfo.CaptionLanguage)): $($_.Exception.Message)"
                }
            }
        }
    }

    # 1b. ALSO save the official Microsoft .docx transcript (captionFileLink)
    #     as a side-artifact - useful for accessibility tooling / archival.
    if (-not [string]::IsNullOrWhiteSpace($Session.captionFileLink)) {
        try {
            $docxPath = Join-Path $sessionDir 'transcript-official.docx'
            Invoke-WebRequest -Uri $Session.captionFileLink -OutFile $docxPath -UseBasicParsing -TimeoutSec 60 | Out-Null
            $docxRel = 'transcript-official.docx'
        }
        catch {
            # Non-fatal; we have the VTT path above.
            $errors += "official .docx fetch failed: $($_.Exception.Message)"
        }
    }

    # 2. Frames. Prefer the direct MP4 (downloadVideoLink) because HTTP-range
    #    seeks are dramatically faster than HLS segment downloads. Fall back
    #    to the HLS master playlist scraped from the Medius embed (covers
    #    sessions like BRK260 that only expose a streaming player).
    $videoSource = if (-not [string]::IsNullOrWhiteSpace($Session.downloadVideoLink)) {
        @{ Url = $Session.downloadVideoLink; Kind = 'mp4' }
    }
    elseif ($hlsUrl) {
        @{ Url = $hlsUrl; Kind = 'hls' }
    }
    else { $null }

    $durationSeconds = if ($Session.durationInMinutes) { [double]$Session.durationInMinutes * 60.0 } else { 0.0 }
    # OD/ODSP and a few BRK sessions have durationInMinutes=0 in the catalog
    # because they weren't scheduled into a fixed wall-clock slot. ffprobe
    # the actual video to discover its runtime - same network cost as one
    # frame seek, unblocks ~30 sessions that would otherwise be frameless.
    # Also catches cases where the catalog overstates the duration; we
    # prefer the probed value when it's smaller so the last frames don't
    # land past the real end of the video.
    if ($videoSource) {
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
                foreach ($a in @('-v','error','-show_entries','format=duration','-of','csv=p=0',$videoSource.Url)) {
                    [void]$psi.ArgumentList.Add($a)
                }
                $proc = [System.Diagnostics.Process]::Start($psi)
                $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
                [void]$proc.StandardError.ReadToEndAsync()
                if ($proc.WaitForExit(15000)) {
                    [void]$stdoutTask.Wait()
                    $probeOut = $stdoutTask.Result
                    if ($probeOut) {
                        $probed = 0.0
                        if ([double]::TryParse(($probeOut | Out-String).Trim(),
                                [System.Globalization.NumberStyles]::Float,
                                [System.Globalization.CultureInfo]::InvariantCulture,
                                [ref]$probed) -and $probed -gt 0) {
                            if ($durationSeconds -le 0) {
                                $durationSeconds = $probed
                            } elseif ($probed -lt $durationSeconds) {
                                # Catalog overshot - trust ffprobe to avoid past-end seeks.
                                $durationSeconds = $probed
                            }
                        }
                    }
                } else {
                    try { $proc.Kill($true) } catch { }
                }
            } catch { }
        }
    }
    if (-not $videoSource) {
        $errors += 'no downloadVideoLink and no HLS URL on Medius embed'
    }
    elseif ($durationSeconds -le 0) {
        $errors += 'no durationInMinutes and ffprobe could not determine video length'
    }
    else {
        $framesDir = Join-Path $sessionDir 'frames'
        # Wipe stale frame files from previous runs before sampling fresh
        # ones. Old runs used different counts/timestamps, leaving leftover
        # frame-005-25-00.jpg etc. that we never reference but clutter disk
        # and confuse "how many frames does this session have" diagnostics.
        # Preserves any sibling subdirectories (e.g. announcement-frames/).
        if (Test-Path -LiteralPath $framesDir) {
            Get-ChildItem -LiteralPath $framesDir -File -Filter 'frame-*.jpg' -ErrorAction SilentlyContinue |
                Remove-Item -Force -ErrorAction SilentlyContinue
        }
        New-Item -ItemType Directory -Path $framesDir -Force | Out-Null
        $timestamps = Get-EvenlySpacedTimestamps -DurationSeconds $durationSeconds -Count $FrameCount
        for ($i = 0; $i -lt $timestamps.Count; $i++) {
            $ts = $timestamps[$i]
            $tsLabel = Format-Timestamp -Seconds $ts
            $frameName = "frame-{0:000}-{1}.jpg" -f ($i + 1), $tsLabel
            $framePath = Join-Path $framesDir $frameName
            # `-ss BEFORE -i` works as a header-seek hint for both MP4 (HTTP
            # range, sub-second) and HLS (playlist index, ~5-10 s per frame).
            # Putting -ss AFTER -i forces decode-through which is ~3x slower
            # for HLS and unnecessary for our keyframe-aligned sampling.
            # Resize to 1280px wide + slightly-lossy q:v 4 to keep the total
            # docs/ payload under the GitHub Pages 1 GB soft limit; full-HD
            # is overkill for a static-site preview gallery.
            $ffArgs = @(
                '-hide_banner','-loglevel','error','-y'
                '-ss', ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0}', $ts))
                '-i', $videoSource.Url
                '-frames:v','1'
                '-vf','scale=1280:-2'
                '-q:v', $JpegQuality
                $framePath
            )
            try {
                & $FfmpegPath @ffArgs 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $framePath)) {
                    $framesRel += "frames/$frameName"
                }
                else {
                    $errors += "ffmpeg failed at $tsLabel (exit $LASTEXITCODE, source=$($videoSource.Kind))"
                }
            }
            catch {
                $errors += "ffmpeg threw at $tsLabel : $($_.Exception.Message)"
            }
        }
    }

    # 3. Summary placeholder from the API's aiDescription. Get-SessionSummaries.ps1
    #    will overwrite summary.md with the Copilot-generated Markdown summary.
    if (-not [string]::IsNullOrWhiteSpace($Session.aiDescription)) {
        $aiPath = Join-Path $sessionDir 'ai-description.html'
        Set-Content -LiteralPath $aiPath -Value $Session.aiDescription -Encoding utf8
        $summaryRel = 'ai-description.html'
    }

    # 4. Rich manifest.
    $manifest = [pscustomobject]@{
        schemaVersion     = 1
        code              = $code
        title             = $Session.title
        description       = $Session.description
        sessionType       = (Get-FacetValue $Session.sessionType)
        topics            = (Get-FacetValues $Session.topic)
        tags              = (Get-FacetValues $Session.tags)
        level             = (Get-FacetValues $Session.sessionLevel)
        programmingLanguages = (Get-FacetValues $Session.programmingLanguages)
        audienceTypes     = (Get-FacetValues $Session.audienceTypes)
        solutionArea      = (Get-FacetValues $Session.solutionArea)
        theme             = (Get-FacetValues $Session.theme)
        deliveryTypes     = (Get-FacetValues $Session.deliveryTypes)
        durationMinutes   = $Session.durationInMinutes
        startDateTime     = $Session.startDateTime
        endDateTime       = $Session.endDateTime
        location          = (Get-FacetValue $Session.location)
        speakerNames      = $Session.speakerNames
        speakerIds        = @($Session.speakerIds)
        speakerTypes      = (Get-FacetValues $Session.SpeakerTypes)
        associatedCompanies = (Get-FacetValues $Session.associatedCompanies)
        sessionLinks      = @($Session.sessionLinks)
        relatedResources  = @($Session.relatedResources)
        relatedSessionCodes = @($Session.relatedSessionCodes)
        registrationLink  = $Session.registrationLink
        viewingOptions    = (Get-FacetValues $Session.viewingOptions)
        captionLanguage   = (Get-FacetValues $Session.captionLanguage)
        audioLanguage     = (Get-FacetValues $Session.audioLanguage)
        aslSupported      = $Session.aslSupported
        onDemandUrl       = $Session.onDemand
        downloadVideoUrl  = $Session.downloadVideoLink
        hlsUrl            = $hlsUrl
        captionFileUrl    = $Session.captionFileLink
        slideDeckUrl      = $Session.slideDeck
        thumbnailUrl      = $Session.onDemandThumbnail
        sessionUrl        = "https://build.microsoft.com/en-US/sessions/$code`?source=sessions"
        artifacts = [pscustomobject]@{
            transcriptVtt     = $captionRel
            transcript        = $transcriptRel
            transcriptLang    = $captionLangUsed
            officialTranscriptDocx = $docxRel
            summary           = $summaryRel
            frames            = $framesRel
        }
        ingestion = [pscustomobject]@{
            catalogFetchedAt = $CatalogFetchedAt
            ingestedAt       = (Get-Date).ToUniversalTime().ToString('o')
            schemaVersion    = 1
            errors           = $errors
        }
        sessionLastUpdate = $Session.lastUpdate
    }
    $manifest | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $manifestPath -Encoding utf8

    $status = if ($errors.Count -eq 0) { 'ok' }
              elseif ($transcriptRel -or $framesRel.Count -gt 0) { 'partial' }
              else { 'failed' }

    return [pscustomobject]@{
        code   = $code
        status = $status
        frames = $framesRel.Count
        errors = $errors
    }
}
$sw.Stop()

# --------------------------------------------------------------------------
# Summarise + persist the run report.
# --------------------------------------------------------------------------

$ok       = @($results | Where-Object { $_.status -eq 'ok' })
$partial  = @($results | Where-Object { $_.status -eq 'partial' })
$failed   = @($results | Where-Object { $_.status -eq 'failed' })
$skipped  = @($results | Where-Object { $_.status -eq 'skipped' })

$failedColor = if ($failed.Count -gt 0) { 'Red' } else { 'DarkGray' }

Write-Host ''
Write-Host ("Ingestion complete in {0:N1}s." -f $sw.Elapsed.TotalSeconds) -ForegroundColor Cyan
Write-Host ("  ok:      {0}" -f $ok.Count)      -ForegroundColor Green
Write-Host ("  partial: {0}" -f $partial.Count) -ForegroundColor Yellow
Write-Host ("  failed:  {0}" -f $failed.Count)  -ForegroundColor $failedColor
Write-Host ("  skipped: {0}" -f $skipped.Count) -ForegroundColor DarkGray

if ($partial.Count -gt 0 -or $failed.Count -gt 0) {
    Write-Host ''
    Write-Host 'Sessions with issues:' -ForegroundColor Yellow
    $results | Where-Object { $_.status -in @('partial','failed') } | Sort-Object code | ForEach-Object {
        Write-Host ("  [{0}] {1}" -f $_.status, $_.code) -ForegroundColor Yellow
        $_.errors | ForEach-Object { Write-Host ("      - {0}" -f $_) -ForegroundColor DarkYellow }
    }
}

$reportPath = Join-Path $RepoRoot "catalog\$Conference\$EventId\ingestion-report.json"
@{
    schemaVersion     = 1
    eventId           = $EventId
    completedAt       = (Get-Date).ToUniversalTime().ToString('o')
    elapsedSeconds    = [Math]::Round($sw.Elapsed.TotalSeconds, 1)
    concurrency       = $Concurrency
    frameCount        = $FrameCount
    captionLanguages  = $CaptionLanguages
    counts            = @{ ok = $ok.Count; partial = $partial.Count; failed = $failed.Count; skipped = $skipped.Count }
    catalogFetchedAt  = $catalogFetchedAt
    results           = $results
} | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $reportPath -Encoding utf8
Write-Host ''
Write-Host "Run report: $reportPath" -ForegroundColor Cyan
Write-Host "Next: scripts/Get-SessionSummaries.ps1 -Conference $Conference -EventId $EventId" -ForegroundColor Cyan
