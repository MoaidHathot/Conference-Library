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

    [Parameter()][ValidateRange(1, 50)][int]$FrameCount = 5,

    [Parameter()][ValidateRange(2, 31)][int]$JpegQuality = 2,

    [Parameter()][ValidateRange(1, 64)][int]$Concurrency = 10,

    # Comma- or array-friendly caption language preferences. The Medius embed
    # advertises ~36 languages per session; we pick the first one matching
    # by primary BCP-47 subtag (en matches en-US, en-GB, etc.).
    [Parameter()][string[]]$CaptionLanguages = @('en'),

    [Parameter()][string[]]$OnlyCodes = @(),

    [Parameter()][switch]$Force,

    [Parameter()][string]$FfmpegPath,

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

    function Get-CaptionUrlFromMediusEmbed {
        # Hit the Medius embed page and pick a SAS-signed VTT URL from
        # captionsConfiguration.languageList[] using the requested language
        # preferences (primary BCP-47 subtag match: 'en' matches 'en-US').
        # Returns @{ Url = ...; Language = 'en-US' } or $null.
        param([string]$EmbedUrl, [string[]]$Preferences)
        try {
            $html = Invoke-WebRequest -Uri $EmbedUrl -UseBasicParsing -TimeoutSec 60 |
                    Select-Object -ExpandProperty Content
        }
        catch {
            return $null
        }
        $marker = $html.IndexOf('captionsConfiguration')
        if ($marker -lt 0) { return $null }
        $open = $html.IndexOf('{', $marker)
        if ($open -lt 0) { return $null }
        $json = Extract-BraceBalancedJson -Text $html -OpenIndex $open
        if (-not $json) { return $null }
        try {
            $cfg = $json | ConvertFrom-Json -Depth 10
        } catch { return $null }
        if (-not $cfg.languageList) { return $null }

        # Build a list of {url, language} from each entry.
        $entries = @()
        foreach ($entry in $cfg.languageList) {
            if (-not $entry.src) { continue }
            # Prefer the BCP-47 tag embedded in the filename (Caption_en-US.vtt)
            # over the terse srclang attribute.
            $lang = $null
            if ($entry.src -match '/Caption_([A-Za-z]{2,3}(?:-[A-Za-z0-9]{2,8})*)\.(?:vtt|srt)\b') {
                $lang = $Matches[1]
            }
            elseif ($entry.srclang) {
                $lang = $entry.srclang
            }
            $entries += [pscustomobject]@{ Url = $entry.src; Language = $lang }
        }
        if ($entries.Count -eq 0) { return $null }

        # Primary-subtag match: 'en' -> any 'en*' entry.
        foreach ($pref in $Preferences) {
            if ([string]::IsNullOrWhiteSpace($pref)) { continue }
            $prefPrimary = ($pref -split '-')[0].ToLowerInvariant()
            $match = $entries | Where-Object {
                $entryPrimary = if ($_.Language) { ($_.Language -split '-')[0].ToLowerInvariant() } else { '' }
                $entryPrimary -eq $prefPrimary
            } | Select-Object -First 1
            if ($match) { return $match }
        }

        # Fallback: English, then the first entry.
        $english = $entries | Where-Object {
            $p = if ($_.Language) { ($_.Language -split '-')[0].ToLowerInvariant() } else { '' }
            $p -eq 'en'
        } | Select-Object -First 1
        if ($english) { return $english }
        return $entries[0]
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

    $errors         = @()
    $captionRel     = $null
    $transcriptRel  = $null
    $captionLangUsed = $null
    $framesRel      = @()
    $summaryRel     = $null
    $docxRel        = $null

    # 1. Caption + transcript via the Medius embed page (not captionFileLink,
    #    which serves a .docx — we save that separately as docx).
    if ([string]::IsNullOrWhiteSpace($Session.onDemand)) {
        $errors += 'no onDemand URL; cannot reach Medius embed for VTT'
    }
    else {
        $pick = Get-CaptionUrlFromMediusEmbed -EmbedUrl $Session.onDemand -Preferences $CaptionLanguages
        if (-not $pick) {
            $errors += 'Medius embed has no parseable captionsConfiguration'
        }
        else {
            try {
                $vttPath = Join-Path $sessionDir 'transcript.vtt'
                Invoke-WebRequest -Uri $pick.Url -OutFile $vttPath -UseBasicParsing -TimeoutSec 60 | Out-Null
                $vttContent = Get-Content -Raw -LiteralPath $vttPath -Encoding utf8
                $md = Convert-VttToMarkdown -VttContent $vttContent
                $mdPath = Join-Path $sessionDir 'transcript.md'
                Set-Content -LiteralPath $mdPath -Value $md -Encoding utf8
                $captionRel = 'transcript.vtt'
                $transcriptRel = 'transcript.md'
                $captionLangUsed = $pick.Language
            }
            catch {
                $errors += "Medius VTT download/parse failed ($($pick.Language)): $($_.Exception.Message)"
            }
        }
    }

    # 1b. ALSO save the official Microsoft .docx transcript (captionFileLink)
    #     as a side-artifact — useful for accessibility tooling / archival.
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

    # 2. Frames.
    $durationSeconds = if ($Session.durationInMinutes) { [double]$Session.durationInMinutes * 60.0 } else { 0.0 }
    if ([string]::IsNullOrWhiteSpace($Session.downloadVideoLink)) {
        $errors += 'no downloadVideoLink'
    }
    elseif ($durationSeconds -le 0) {
        $errors += 'no durationInMinutes; cannot space frames'
    }
    else {
        $framesDir = Join-Path $sessionDir 'frames'
        New-Item -ItemType Directory -Path $framesDir -Force | Out-Null
        $timestamps = Get-EvenlySpacedTimestamps -DurationSeconds $durationSeconds -Count $FrameCount
        for ($i = 0; $i -lt $timestamps.Count; $i++) {
            $ts = $timestamps[$i]
            $tsLabel = Format-Timestamp -Seconds $ts
            $frameName = "frame-{0:000}-{1}.jpg" -f ($i + 1), $tsLabel
            $framePath = Join-Path $framesDir $frameName
            $ffArgs = @(
                '-hide_banner','-loglevel','error','-y'
                '-ss', ([string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0}', $ts))
                '-i', $Session.downloadVideoLink
                '-frames:v','1','-q:v', $JpegQuality
                $framePath
            )
            try {
                & $FfmpegPath @ffArgs 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $framePath)) {
                    $framesRel += "frames/$frameName"
                }
                else {
                    $errors += "ffmpeg failed at $tsLabel (exit $LASTEXITCODE)"
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
