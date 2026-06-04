# Get-BuildCatalog.ps1
#
# Crawl the public Microsoft Build session catalog and persist a complete catalog snapshot.
#
# Microsoft Build exposes a clean, anonymous, CORS-open JSON API at
# https://api-v2.build.microsoft.com/api. This script hits:
#   POST /session/search          (one call, returns 443+ ids + facets)
#   GET  /session/{localizedId}   (one call per session, returns the full record)
# and writes the merged result to catalog/<Conference>/<EventId>/catalog.json
# plus a slim catalog/<Conference>/<EventId>/sessions-index.json that's easier
# to diff in git.
#
# Idempotent: re-running overwrites the snapshot. The git history is the audit
# trail (use `git diff catalog/<Conference>/<EventId>/sessions-index.json` to see what
# changed between runs).
[CmdletBinding()]
param(
    # Conference identifier. The Microsoft Build adapter is currently the
    # only supported value; future conferences will get their own crawler
    # scripts but should write to the same catalog/<Conference>/<EventId>/
    # layout this script produces.
    [Parameter()]
    [string]$Conference = 'Build',

    # Catalog year / event id segment. Sessions land under
    # sessions/<Conference>/<EventId>/.
    [Parameter()]
    [string]$EventId = '2026',

    # Microsoft Build session catalog language. Affects the localizedId pattern
    # in detail calls; en-US is the canonical reference.
    [Parameter()]
    [string]$Language = 'en-US',

    # Polite throttle between detail calls (ms). Empirically the API is fine at
    # 75 ms; raise if the run hits 5xx, lower if you're impatient.
    [Parameter()]
    [int]$ThrottleMilliseconds = 75,

    # Concurrent detail fetches. Default 10 (matches the ingestion default).
    # The API uses an Azure Front Door fronting an App Service; 10 has been
    # observed to be comfortable.
    [Parameter()]
    [ValidateRange(1, 64)]
    [int]$Concurrency = 10,

    # Root of the Conference-Library repo. Defaults to the repo root resolved
    # relative to this script.
    [Parameter()]
    [string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$apiBase = 'https://api-v2.build.microsoft.com/api'
$headers = @{
    Accept  = 'application/json'
    Origin  = 'https://build.microsoft.com'
    Referer = 'https://build.microsoft.com/'
}

$catalogDir = Join-Path $RepoRoot "catalog\$Conference\$EventId"
New-Item -ItemType Directory -Path $catalogDir -Force | Out-Null

Write-Host "Crawling Microsoft Build $EventId catalog (conference=$Conference)..." -ForegroundColor Cyan
Write-Host "  API base:            $apiBase"
Write-Host "  Concurrency:         $Concurrency"
Write-Host "  Throttle:            ${ThrottleMilliseconds}ms between detail calls"
Write-Host "  Output:              $catalogDir"
Write-Host ''

# --------------------------------------------------------------------------
# Step 1 — search for all session ids in one call.
# --------------------------------------------------------------------------

$searchBody = @{
    searchText         = ''
    searchFacets       = @{}
    favoritesIds       = @()
    recommendedItemIds = @()
    searchPage         = 1
    itemsPerPage       = 2000
    sortOption         = 'None'
    language           = $Language
} | ConvertTo-Json -Compress

$searchUrl = "$apiBase/session/search"
Write-Host "[1/2] Searching catalog..." -ForegroundColor Yellow
$searchSw = [System.Diagnostics.Stopwatch]::StartNew()
$catalog = Invoke-RestMethod -Uri $searchUrl -Method POST -Headers $headers `
    -ContentType 'application/json' -Body $searchBody
$searchSw.Stop()

if (-not $catalog.data -or $catalog.data.Count -eq 0) {
    throw "Catalog search returned no results. The API shape may have changed; inspect $searchUrl manually."
}

Write-Host ("  found {0} session(s) in {1}ms" -f $catalog.total, $searchSw.ElapsedMilliseconds)
Write-Host ''

# --------------------------------------------------------------------------
# Step 2 — fetch every session detail. Parallel with a polite throttle.
# --------------------------------------------------------------------------

Write-Host "[2/2] Fetching session detail..." -ForegroundColor Yellow
$detailSw = [System.Diagnostics.Stopwatch]::StartNew()

$ids       = $catalog.data | ForEach-Object { $_.localizedId }
$idCount   = $ids.Count
$detail    = [System.Collections.Concurrent.ConcurrentDictionary[string, psobject]]::new()
$failures  = [System.Collections.Concurrent.ConcurrentBag[string]]::new()
$completed = 0

# ForEach-Object -Parallel uses PowerShell 7+; $using:* passes captured values
# (parallel scriptblocks run in fresh runspaces, no implicit closure capture).
$ids | ForEach-Object -ThrottleLimit $Concurrency -Parallel {
    $id = $_
    $headers = $using:headers
    $apiBase = $using:apiBase
    $throttle = $using:ThrottleMilliseconds
    $detail = $using:detail
    $failures = $using:failures
    $idCount = $using:idCount

    try {
        $session = Invoke-RestMethod -Uri "$apiBase/session/$id" -Headers $headers -Method GET -TimeoutSec 30
        [void]$detail.TryAdd($id, $session)
    }
    catch {
        # Surface but don't abort the whole crawl; a partial catalog is better than none.
        [void]$failures.Add("$id : $($_.Exception.Message)")
    }

    if ($throttle -gt 0) { Start-Sleep -Milliseconds $throttle }
}

$detailSw.Stop()
$sessions = @($detail.Values | Sort-Object sessionCode)
Write-Host ("  fetched {0}/{1} session(s) in {2:N1}s" -f $sessions.Count, $idCount, $detailSw.Elapsed.TotalSeconds)
if ($failures.Count -gt 0) {
    Write-Warning "  $($failures.Count) detail call(s) failed (catalog will be incomplete this run; re-run to retry):"
    $failures | ForEach-Object { Write-Warning "    - $_" }
}
Write-Host ''

# --------------------------------------------------------------------------
# Write outputs.
# --------------------------------------------------------------------------

# Full snapshot — every field the API returned. This is the canonical input for
# the ingestion driver; do not hand-edit. ~5 MB for the full Build catalog.
$catalogPath = Join-Path $catalogDir 'catalog.json'
$snapshot = [pscustomobject]@{
    schemaVersion = 1
    eventId       = $EventId
    apiBase       = $apiBase
    fetchedAt     = (Get-Date).ToUniversalTime().ToString('o')
    total         = $catalog.total
    fetched       = $sessions.Count
    failures      = @($failures)
    facets        = $catalog.facets
    sessions      = $sessions
}
$snapshot | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $catalogPath -Encoding utf8
Write-Host "  wrote $catalogPath ($([math]::Round((Get-Item $catalogPath).Length / 1KB, 1)) KB)" -ForegroundColor Green

# Slim diff-friendly index — one line per session with the fields most likely
# to change between catalog refreshes (status, schedule, speaker roster, tags).
# git diff against this answers "what changed?" cheaply.
$indexPath = Join-Path $catalogDir 'sessions-index.json'
$slim = $sessions | ForEach-Object {
    [pscustomobject]@{
        sessionCode      = $_.sessionCode
        localizedId      = $_.localizedId
        title            = $_.title
        sessionType      = $_.sessionType
        topic            = @($_.topic)
        tags             = @($_.tags)
        sessionLevel     = @($_.sessionLevel)
        startDateTime    = $_.startDateTime
        endDateTime      = $_.endDateTime
        durationInMinutes= $_.durationInMinutes
        speakerNames     = $_.speakerNames
        hasCaption       = -not [string]::IsNullOrWhiteSpace($_.captionFileLink)
        hasVideoDownload = -not [string]::IsNullOrWhiteSpace($_.downloadVideoLink)
        hasOnDemand      = -not [string]::IsNullOrWhiteSpace($_.onDemand)
        lastUpdate       = $_.lastUpdate
    }
} | Sort-Object sessionCode
$slim | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $indexPath -Encoding utf8
Write-Host "  wrote $indexPath ($([math]::Round((Get-Item $indexPath).Length / 1KB, 1)) KB)" -ForegroundColor Green
Write-Host ''
Write-Host "Done. Next: scripts/Invoke-BuildIngestion.ps1 -Conference $Conference -EventId $EventId" -ForegroundColor Cyan
