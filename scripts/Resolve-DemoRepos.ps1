# Resolve-DemoRepos.ps1
#
# Build a session-code -> demo-repo map by parsing Microsoft's own
# microsoft/build26-next-steps repo. That repo is a per-topic markdown
# catalogue maintained by Microsoft of every session's interactive
# resources, with a stable table format:
#
#   | Session | Presenters | Repo | Session Page |
#   | ...    | [Names](..)| [Repo](https://aka.ms/build26/<CODE>) | [<CODE>](..)
#
# So we don't need GitHub search at all - the canonical mapping is
# already curated. We just fetch the 6 topic markdowns, extract
# the table rows, and write:
#
#   catalog/<Conf>/<Event>/demo-repos/
#     demo-repos.json    one record per session with code, akaUrl,
#                        finalUrl (after redirect resolution),
#                        sourceTopic, fetchedAt
#     resolution-report.json
#                        diff-friendly audit: topics scanned, rows
#                        parsed, redirects followed, failures
#
# The aka.ms URLs are HTTP 301 redirects to the underlying GitHub repo
# (or sometimes Microsoft Learn / docs.microsoft.com). We follow them
# once at resolve time to capture the canonical URL, falling back to
# the aka.ms URL if the redirect fails.
#
# Idempotent: re-running skips fetching when demo-repos.json exists AND
# is younger than -CacheTtlDays. Pass -Force to refresh.
[CmdletBinding()]
param(
    [Parameter()][string]$Conference = 'Build',
    [Parameter()][string]$EventId    = '2026',

    # Upstream repo + branch we read from. Hard-coded for Build 2026; an
    # entry would need to be added per future event when Microsoft ships
    # the equivalent build27-next-steps repo.
    [Parameter()][string]$UpstreamRepo   = 'microsoft/build26-next-steps',
    [Parameter()][string]$UpstreamBranch = 'main',

    # The 6 topic files under /docs/. If Microsoft adds or renames topics
    # in a future year we'd just edit this list.
    [Parameter()][string[]]$TopicFiles = @(
        'agents-apps.md',
        'cloud-platform-data.md',
        'devtools-frameworks.md',
        'model-training.md',
        'responsible-ai.md',
        'windows.md'
    ),

    [Parameter()][int]$CacheTtlDays = 7,

    # When set, follow each aka.ms/build26/<CODE> redirect to capture the
    # final URL. Adds ~10s wall-clock for ~90 redirects with concurrency 8.
    # Default ON - the final URL is what we want to show on the site.
    [Parameter()][bool]$FollowRedirects = $true,

    [Parameter()][int]$RedirectTimeoutSeconds = 10,
    [Parameter()][ValidateRange(1, 32)][int]$RedirectConcurrency = 8,

    [Parameter()][switch]$Force,

    [Parameter()][string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$outDir = Join-Path $RepoRoot "catalog\$Conference\$EventId\demo-repos"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
$outPath    = Join-Path $outDir 'demo-repos.json'
$reportPath = Join-Path $outDir 'resolution-report.json'

# Idempotency: skip when the cached file is younger than the TTL.
if (-not $Force -and (Test-Path -LiteralPath $outPath)) {
    $age = (Get-Date).ToUniversalTime() - (Get-Item -LiteralPath $outPath).LastWriteTimeUtc
    if ($age.TotalDays -lt $CacheTtlDays) {
        Write-Host "Demo repos cache is $([Math]::Round($age.TotalHours,1))h old (TTL=$CacheTtlDays days). Pass -Force to refresh." -ForegroundColor Green
        return
    }
}

# --------------------------------------------------------------------------
# Fetch + parse each topic markdown
# --------------------------------------------------------------------------

# raw.githubusercontent.com serves the file straight from the repo without
# the GitHub UI chrome (faster, no rate-limit on anonymous reads at this
# volume). The branch ref is resolved on each fetch so we always get HEAD.
$rawBaseUrl = "https://raw.githubusercontent.com/$UpstreamRepo/$UpstreamBranch/docs"

$rows = New-Object 'System.Collections.Generic.List[pscustomobject]'
$failed = New-Object 'System.Collections.Generic.List[pscustomobject]'

Write-Host "Fetching $($TopicFiles.Count) topic markdown(s) from $UpstreamRepo@$UpstreamBranch ..." -ForegroundColor Cyan

foreach ($file in $TopicFiles) {
    $url = "$rawBaseUrl/$file"
    try {
        $md = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 30
    } catch {
        Write-Warning "Failed to fetch $url ($_)"
        $failed.Add([pscustomobject]@{ topic = $file; error = "fetch failed: $_" }) | Out-Null
        continue
    }
    $body = $md.Content

    # Look for the Session Repositories section's table. The table always
    # starts with `| Session | Presenters | Repo | Session Page |`. We
    # parse until we hit a blank line or the next header.
    $tableRegex = '(?ms)\| Session \| Presenters \| Repo \| Session Page \|\s*\r?\n\|[-\s|]+\|\s*\r?\n((?:\|.*?\|\s*\r?\n)+)'
    $tableMatch = [regex]::Match($body, $tableRegex)
    if (-not $tableMatch.Success) {
        Write-Warning "  $file - table not found (Microsoft may have changed the format)"
        $failed.Add([pscustomobject]@{ topic = $file; error = 'table not found' }) | Out-Null
        continue
    }

    $tableBody = $tableMatch.Groups[1].Value
    $rowMatches = [regex]::Matches($tableBody, '(?m)^\|\s*(?<title>[^|]+?)\s*\|\s*(?<presenters>[^|]*?)\s*\|\s*(?<repoCell>[^|]+?)\s*\|\s*(?<codeCell>[^|]+?)\s*\|\s*$')

    $countThisFile = 0
    foreach ($rm in $rowMatches) {
        $title     = $rm.Groups['title'].Value.Trim()
        $repoCell  = $rm.Groups['repoCell'].Value.Trim()
        $codeCell  = $rm.Groups['codeCell'].Value.Trim()

        # Extract the aka.ms URL from the repoCell. Pattern: [Repo](https://aka.ms/build26/<CODE>)
        $repoUrlMatch = [regex]::Match($repoCell, '\((https?://[^\s\)]+)\)')
        if (-not $repoUrlMatch.Success) { continue }
        $akaUrl = $repoUrlMatch.Groups[1].Value

        # Extract the session code from the codeCell. Pattern: [BRK201](https://build.microsoft.com/...)
        $codeMatch = [regex]::Match($codeCell, '\[([A-Z]+\d+[A-Z]?(?:-R\d+|-O\d+|D)?)\]')
        $code = if ($codeMatch.Success) { $codeMatch.Groups[1].Value } else { '' }
        if (-not $code) {
            # Fallback: pull the code out of the aka.ms URL itself
            $codeFromUrl = [regex]::Match($akaUrl, 'build26/([A-Z][A-Z0-9-]+)')
            if ($codeFromUrl.Success) { $code = $codeFromUrl.Groups[1].Value }
        }
        if (-not $code) { continue }

        $rows.Add([pscustomobject]@{
            code        = $code
            title       = $title
            akaUrl      = $akaUrl
            finalUrl    = $null         # filled in below if FollowRedirects
            sourceTopic = ($file -replace '\.md$', '')
        }) | Out-Null
        $countThisFile++
    }
    Write-Host "  $file -> $countThisFile row(s)" -ForegroundColor DarkGray
}

if ($rows.Count -eq 0) {
    throw "No demo-repo rows parsed from any topic file. Did Microsoft change the table format?"
}

# Dedupe by (code, akaUrl) - sometimes a session is listed under more than
# one topic. Keep the first sourceTopic encountered for determinism.
$dedup = @{}
$ordered = New-Object 'System.Collections.Generic.List[pscustomobject]'
foreach ($r in $rows) {
    $key = "$($r.code)|$($r.akaUrl)"
    if ($dedup.ContainsKey($key)) { continue }
    $dedup[$key] = $true
    $ordered.Add($r) | Out-Null
}
Write-Host "Parsed $($rows.Count) raw row(s); $($ordered.Count) unique after dedup." -ForegroundColor DarkGray

# --------------------------------------------------------------------------
# Follow aka.ms redirects to canonical URLs (parallel)
# --------------------------------------------------------------------------

$redirectsFollowed = 0
$redirectsFailed   = 0
if ($FollowRedirects) {
    Write-Host "Resolving aka.ms redirects (concurrency $RedirectConcurrency, timeout ${RedirectTimeoutSeconds}s)..." -ForegroundColor Cyan
    $sw = [System.Diagnostics.Stopwatch]::StartNew()

    $resolved = $ordered | ForEach-Object -ThrottleLimit $RedirectConcurrency -Parallel {
        $r = $_
        $timeoutSec = $using:RedirectTimeoutSeconds
        try {
            # MaximumRedirection 5 lets us hop through aka.ms -> short -> final.
            # -SkipHttpErrorCheck so 404s on a stale aka.ms entry don't blow up
            # the batch - we just record the failure and keep the original URL.
            $resp = Invoke-WebRequest -Uri $r.akaUrl -MaximumRedirection 5 `
                                       -UseBasicParsing -TimeoutSec $timeoutSec `
                                       -SkipHttpErrorCheck -ErrorAction Stop
            $final = if ($resp.BaseResponse.RequestMessage.RequestUri) {
                "$($resp.BaseResponse.RequestMessage.RequestUri)"
            } else { $r.akaUrl }
            return [pscustomobject]@{
                code        = $r.code
                title       = $r.title
                akaUrl      = $r.akaUrl
                finalUrl    = $final
                sourceTopic = $r.sourceTopic
                httpStatus  = [int]$resp.StatusCode
            }
        } catch {
            return [pscustomobject]@{
                code        = $r.code
                title       = $r.title
                akaUrl      = $r.akaUrl
                finalUrl    = $r.akaUrl   # keep aka.ms as the user-visible URL
                sourceTopic = $r.sourceTopic
                httpStatus  = $null
                redirectError = "$_"
            }
        }
    }
    $sw.Stop()

    $redirectsFollowed = @($resolved | Where-Object { $_.httpStatus }).Count
    $redirectsFailed   = @($resolved | Where-Object { -not $_.httpStatus }).Count
    Write-Host ("Resolved $($redirectsFollowed) redirect(s) in {0:N1}s ($redirectsFailed failure(s))." -f $sw.Elapsed.TotalSeconds) -ForegroundColor DarkGray

    $ordered = $resolved | Sort-Object code
}

# --------------------------------------------------------------------------
# Write outputs
# --------------------------------------------------------------------------

$generatedAt = (Get-Date).ToUniversalTime().ToString('o')

# Group by host of finalUrl so the report tells the maintainer where the
# canonical resources actually live (github.com vs learn.microsoft.com vs ...).
$byHost = @{}
foreach ($r in $ordered) {
    $h = try { ([uri]$r.finalUrl).Host } catch { 'unknown' }
    $h = $h.ToLowerInvariant()
    if (-not $byHost.ContainsKey($h)) { $byHost[$h] = 0 }
    $byHost[$h] = $byHost[$h] + 1
}
$hostBuckets = @($byHost.GetEnumerator() | Sort-Object @{Expression='Value'; Descending=$true} |
    ForEach-Object { [pscustomobject]@{ host = $_.Key; count = $_.Value } })

$payload = [pscustomobject]@{
    schemaVersion = 1
    generatedAt   = $generatedAt
    conference    = $Conference
    eventId       = $EventId
    upstream      = "$UpstreamRepo@$UpstreamBranch"
    totalRepos    = $ordered.Count
    repos         = @($ordered)
}
$payload | ConvertTo-Json -Depth 5 |
    Set-Content -LiteralPath $outPath -Encoding utf8
Write-Host "Wrote $outPath" -ForegroundColor Cyan

$report = [pscustomobject]@{
    schemaVersion     = 1
    generatedAt       = $generatedAt
    upstream          = "$UpstreamRepo@$UpstreamBranch"
    topicsScanned     = $TopicFiles
    rowsParsed        = $rows.Count
    uniqueRepos       = $ordered.Count
    redirectsFollowed = $redirectsFollowed
    redirectsFailed   = $redirectsFailed
    failures          = @($failed)
    hostBuckets       = $hostBuckets
}
$report | ConvertTo-Json -Depth 5 |
    Set-Content -LiteralPath $reportPath -Encoding utf8
Write-Host "Wrote $reportPath" -ForegroundColor Cyan

Write-Host ''
Write-Host "Demo-repo resolution complete:" -ForegroundColor Green
Write-Host "  Unique repos:      $($ordered.Count)"
Write-Host "  Redirects ok/fail: $redirectsFollowed / $redirectsFailed"
Write-Host "  Top hosts:"
foreach ($b in ($hostBuckets | Select-Object -First 4)) {
    Write-Host ("    {0,4} | {1}" -f $b.count, $b.host)
}
Write-Host ''
Write-Host "Next: scripts/Build-Book.ps1 -Conference $Conference -EventId $EventId" -ForegroundColor Cyan
