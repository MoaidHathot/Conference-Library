# Search-AnnouncementLinks.ps1
#
# Step 3b of the announcements pipeline. For each canonical entity in
# entities-enriched.json that doesn't already have an authoritative
# external link from the manual layer, run Zakira.Recall via dnx to
# search the web, filter the results through a Microsoft-and-partners
# allowlist, and write the best github / docs / nuget / blog URLs back
# into entities-enriched.json under a new source layer:
#
#     source: "search"
#
# Inputs:
#   - catalog/<Conf>/<Event>/announcements/entities-enriched.json   (Step 3 output)
#   - catalog/<Conf>/<Event>/announcements/manual-links.json         (always wins)
#
# Outputs:
#   - updates entities-enriched.json in place (adds links + linkCounts.search)
#   - catalog/<Conf>/<Event>/announcements/search-cache/<entity-slug>.json
#       (per-entity cache: raw recall output + selected links + timestamp;
#        skip-rule on next run is `cache age < -CacheTtlDays`)
#   - catalog/<Conf>/<Event>/announcements/search-report.json
#       (per-run summary: counts per kind, ambiguity rate, unresolved count)
#
# Zakira.Recall is invoked via .NET 10's dnx runner. The first invocation
# resolves the tool from NuGet (~40 MB; 1-2 min one time). The duckduckgo
# provider uses the HTML API (no Playwright); duckduckgo-browser and bing
# fall back to Playwright if duckduckgo trips a captcha / health drop.
#
# Concurrency: -SearchConcurrency (default 8) parallel `recall search`
# processes via PowerShell ForEach-Object -Parallel. Each is a fresh
# process with its own ephemeral state, so they can't conflict on
# Playwright user-data dirs even if the provider falls back.
[CmdletBinding()]
param(
    [Parameter()][string]$Conference = 'Build',
    [Parameter()][string]$EventId    = '2026',

    [Parameter()][ValidateRange(1, 32)][int]$SearchConcurrency = 8,
    [Parameter()][int]$CacheTtlDays = 30,
    [Parameter()][string]$Provider  = 'duckduckgo',
    [Parameter()][string]$RecallPackageVersion = '0.5.0',

    # Per-process wall-clock budget for a single recall invocation. Stops
    # a wedged Playwright session from blocking the whole batch.
    [Parameter()][int]$TimeoutSeconds = 60,

    # Subset by entity slug (e.g. -OnlyEntities horizon-db,agent-merge)
    [Parameter()][string[]]$OnlyEntities = @(),

    # Bypass cache entirely (re-query every entity).
    [Parameter()][switch]$Force,

    # Skip entities that already have a search-derived link of the same kind
    # in entities-enriched.json from a prior run. Default is to re-merge,
    # honouring TTL.
    [Parameter()][switch]$SkipExistingSearch,

    [Parameter()][string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

# Resolve dnx up front so all child invocations use the same absolute path.
# Process.Start({UseShellExecute=false}) can't follow PATHEXT to find .cmd
# launchers, and on Windows `dnx` is shipped as dnx.cmd by the dotnet SDK
# (in C:\Program Files\dotnet\). Get-Command does the right resolution.
$script:DnxPath = (Get-Command dnx -ErrorAction SilentlyContinue)?.Source
if (-not $script:DnxPath) {
    throw "dnx not found on PATH. Install the .NET 10 SDK (which ships dnx) and retry."
}

# --------------------------------------------------------------------------
# helpers (defined before use)
# --------------------------------------------------------------------------

function Get-CategorySuffix {
    # Steer the search-engine ranking toward the right ecosystem per category.
    # Single suffix per entity to keep this to one query call per entity.
    param([string]$category)
    switch -Regex ($category) {
        '^(SDK|library|framework|runtime)$' { return 'github nuget' }
        '^model$'                            { return 'huggingface documentation' }
        default                              { return 'microsoft learn docs' }
    }
}

function Get-EntityKeyTokens {
    # Significant tokens from the canonical name, stripped of common Build-talk
    # noise. Used for name-match scoring and to decide which key tokens MUST
    # appear in a search result's title/snippet for it to count.
    param([string]$name)
    $stop = @('a','an','the','and','or','but','of','for','to','in','on','at','by','with',
              'is','are','was','were','be','been','being','as','from','into','via',
              'public','preview','private','limited','beta','experimental','ga','generally','available',
              'coming','soon','now','new','first','inferred','support','supports','use','using','built')
    $stopSet = New-Object 'System.Collections.Generic.HashSet[string]' ([string[]]$stop, [StringComparer]::OrdinalIgnoreCase)
    return ($name.ToLowerInvariant() -replace '[^a-z0-9]+', ' ').Trim() -split '\s+' |
        Where-Object { $_ -and $_.Length -gt 1 -and -not $stopSet.Contains($_) }
}

function Get-DomainKind {
    # Map a URL host+path to one of our normalised link kinds. Returns $null
    # when the URL falls outside the allowlist (i.e. should be rejected).
    param([string]$url)
    if ([string]::IsNullOrWhiteSpace($url)) { return $null }
    try {
        $uri = [Uri]$url
    } catch { return $null }
    $hostL = $uri.Host.ToLowerInvariant()
    $pathL = $uri.AbsolutePath.ToLowerInvariant()

    # --- registries (always allowed; clearly canonical) ---
    if ($hostL -eq 'www.nuget.org' -or $hostL -eq 'nuget.org') {
        if ($pathL -match '^/packages/[^/]+') { return 'nuget' } else { return $null }
    }
    if ($hostL -eq 'www.npmjs.com' -or $hostL -eq 'npmjs.com') {
        if ($pathL -match '^/package/[^/]+') { return 'npm' } else { return $null }
    }
    if ($hostL -eq 'pypi.org') {
        if ($pathL -match '^/project/[^/]+') { return 'pypi' } else { return $null }
    }
    if ($hostL -eq 'crates.io') {
        if ($pathL -match '^/crates/[^/]+') { return 'crates' } else { return $null }
    }
    if ($hostL -eq 'huggingface.co') { return 'huggingface' }

    # --- GitHub: only /<org>/<repo> (depth >= 2) and only allowlisted orgs ---
    if ($hostL -eq 'github.com') {
        # Allowed orgs (Microsoft + first-party partners commonly seen at Build).
        $allowedOrgs = @(
            'microsoft','azure','azure-samples','dotnet','copilot','github','githubnext',
            'openai','anthropics','anthropic','nvidia','nvidia-omniverse','uipath','replit',
            'qualcomm','amd','intel','huggingface','meta-llama','google-deepmind',
            'opensource-microsoft','microsoftgraph','microsoftdocs','PowerShell','vscode'
        )
        $orgLower = New-Object 'System.Collections.Generic.HashSet[string]' ([string[]]$allowedOrgs, [StringComparer]::OrdinalIgnoreCase)
        # Reject search/topics/marketplace/sponsors and 1-segment paths.
        if ($pathL -match '^/(topics|search|marketplace|sponsors|orgs|features|customer-stories|pricing|enterprise|about|copilot$)') {
            return $null
        }
        $segs = $pathL.Trim('/').Split('/')
        if ($segs.Count -lt 2) { return $null }
        $org = $segs[0]
        if (-not $orgLower.Contains($org)) { return $null }
        # Reject obvious non-repo paths under an allowed org.
        if ($segs[1] -in @('.github','community','docs','blog','sponsors','followers','following','stars','repositories')) { return $null }
        return 'github'
    }
    if ($hostL.EndsWith('.github.io')) {
        # microsoft.github.io and friends.
        $subdomain = $hostL -replace '\.github\.io$', ''
        if ($subdomain -in @('microsoft','azure','dotnet','copilot','githubnext','openai','nvidia','uipath','huggingface')) {
            return 'docs'
        }
        return $null
    }

    # --- Microsoft official docs / blogs / portals ---
    if ($hostL -eq 'learn.microsoft.com' -or $hostL -eq 'docs.microsoft.com') { return 'docs' }
    if ($hostL -eq 'aka.ms')                                                   { return 'docs' }
    if ($hostL -eq 'azure.microsoft.com')                                      { return 'docs' }
    if ($hostL -eq 'www.microsoft.com' -or $hostL -eq 'microsoft.com')         { return 'docs' }
    if ($hostL -eq 'copilot.microsoft.com')                                    { return 'docs' }
    if ($hostL -eq 'developer.microsoft.com')                                  { return 'docs' }
    if ($hostL -eq 'devblogs.microsoft.com')                                   { return 'blog' }
    if ($hostL -eq 'techcommunity.microsoft.com')                              { return 'blog' }
    if ($hostL -eq 'opensource.microsoft.com')                                 { return 'docs' }
    if ($hostL.EndsWith('.microsoft.com'))                                     { return 'docs' }

    # --- Partner first-party domains (only when content is clearly theirs) ---
    if ($hostL.EndsWith('.openai.com') -or $hostL -eq 'openai.com') { return 'docs' }
    if ($hostL.EndsWith('.anthropic.com'))                          { return 'docs' }
    if ($hostL.EndsWith('.nvidia.com'))                             { return 'docs' }
    if ($hostL -eq 'developer.nvidia.com')                          { return 'docs' }
    if ($hostL.EndsWith('.uipath.com'))                             { return 'docs' }
    if ($hostL.EndsWith('.qualcomm.com'))                           { return 'docs' }
    if ($hostL.EndsWith('.amd.com'))                                { return 'docs' }
    if ($hostL.EndsWith('.intel.com'))                              { return 'docs' }
    if ($hostL -eq 'replit.com' -or $hostL -eq 'docs.replit.com')   { return 'docs' }

    return $null
}

function Score-Candidate {
    # Heuristic 0-10 score for one search hit given the entity.
    # Returns @{ score; reasons[] } for diagnosability.
    param(
        $hit,                  # the recall result object with .Url .Title .Snippet .Host .Rank
        [string]$canonicalName,
        [string[]]$keyTokens
    )
    $score   = 0
    $reasons = New-Object 'System.Collections.Generic.List[string]'

    $title   = ($hit.Title   ?? '').ToString()
    $snippet = ($hit.Snippet ?? '').ToString()
    $url     = ($hit.Url     ?? '').ToString()
    $hostL   = (($hit.Host   ?? '')).ToString().ToLowerInvariant()
    $rank    = if ($hit.Rank) { [int]$hit.Rank } else { 99 }

    $hay = ($title + ' ' + $snippet).ToLowerInvariant()
    $canonLower = $canonicalName.ToLowerInvariant()

    # Verbatim canonical-name match in title or snippet = strongest signal.
    if ($title.IndexOf($canonicalName, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
        $score += 4; $reasons.Add('verbatim-name-in-title') | Out-Null
    } elseif ($snippet.IndexOf($canonicalName, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
        $score += 3; $reasons.Add('verbatim-name-in-snippet') | Out-Null
    }

    # Significant-token coverage in title/snippet.
    $hitTokens = 0
    foreach ($t in $keyTokens) {
        if ($hay.Contains($t.ToLowerInvariant())) { $hitTokens++ }
    }
    if ($keyTokens.Count -gt 0) {
        $coverage = $hitTokens / [double]$keyTokens.Count
        if ($coverage -ge 0.75) { $score += 3; $reasons.Add('high-token-coverage') | Out-Null }
        elseif ($coverage -ge 0.5)  { $score += 2; $reasons.Add('med-token-coverage') | Out-Null }
        elseif ($coverage -ge 0.25) { $score += 1; $reasons.Add('low-token-coverage') | Out-Null }
    }

    # Domain bonus: primary Microsoft + GitHub-microsoft-org are gold-tier.
    if ($hostL -eq 'learn.microsoft.com' -or $hostL -eq 'docs.microsoft.com' -or $hostL -eq 'aka.ms') {
        $score += 2; $reasons.Add('primary-msft-docs-domain') | Out-Null
    }
    elseif ($hostL -eq 'azure.microsoft.com' -or $hostL.EndsWith('.microsoft.com')) {
        $score += 1; $reasons.Add('msft-product-domain') | Out-Null
    }
    if ($hostL -eq 'github.com') {
        if ($url -match 'github\.com/(microsoft|Azure|dotnet|copilot|github)/') {
            $score += 2; $reasons.Add('github-msft-org') | Out-Null
        } else {
            $score += 1; $reasons.Add('github-allowed-org') | Out-Null
        }
    }
    if ($hostL -eq 'huggingface.co' -or $hostL -eq 'www.nuget.org' -or $hostL -eq 'nuget.org') {
        $score += 1; $reasons.Add('registry-domain') | Out-Null
    }

    # Position bonus: top-3 results are usually the most relevant.
    if ($rank -le 3) { $score += 1; $reasons.Add("rank-$rank") | Out-Null }

    return [pscustomobject]@{ Score = $score; Reasons = $reasons.ToArray() }
}

function Invoke-RecallSearch {
    # One recall search invocation. Returns parsed JSON (or $null on failure).
    # Captures stdout + stderr separately. dnx --yes auto-confirms the first
    # tool-restore prompt; subsequent calls are silent.
    param(
        [string]$Query,
        [string]$Provider,
        [int]$Limit,
        [int]$TimeoutSeconds,
        [string]$RecallPackageVersion
    )

    $psi = [System.Diagnostics.ProcessStartInfo]@{
        FileName               = 'dnx'
        UseShellExecute        = $false
        RedirectStandardOutput = $true
        RedirectStandardError  = $true
        CreateNoWindow         = $true
    }
    foreach ($a in @(
        "Zakira.Recall@$RecallPackageVersion", '--yes', '--',
        'search', $Query,
        '--provider',     $Provider,
        '--limit',        "$Limit",
        '--fallback',     'true',
        '--output',       'json'
    )) { [void]$psi.ArgumentList.Add($a) }

    $proc = [System.Diagnostics.Process]::Start($psi)
    $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
    $stderrTask = $proc.StandardError.ReadToEndAsync()
    $exited = $proc.WaitForExit([int]([TimeSpan]::FromSeconds($TimeoutSeconds + 30).TotalMilliseconds))
    if (-not $exited) {
        try { $proc.Kill($true) } catch { }
        return @{ ok = $false; error = "timeout after ${TimeoutSeconds}s"; raw = $null }
    }
    [void]$stdoutTask.Wait()
    [void]$stderrTask.Wait()

    $stdout = $stdoutTask.Result
    $stderr = $stderrTask.Result
    if ($proc.ExitCode -ne 0) {
        return @{ ok = $false; error = "exit-$($proc.ExitCode): $($stderr.Trim() | Select-Object -First 1)"; raw = $stdout }
    }
    try {
        $parsed = $stdout | ConvertFrom-Json -Depth 30
        return @{ ok = $true; raw = $stdout; data = $parsed }
    } catch {
        return @{ ok = $false; error = "json-parse: $($_.Exception.Message)"; raw = $stdout }
    }
}

# --------------------------------------------------------------------------
# load inputs
# --------------------------------------------------------------------------

$annRoot   = Join-Path $RepoRoot "catalog\$Conference\$EventId\announcements"
$entitiesPath  = Join-Path $annRoot 'entities-enriched.json'
$manualPath    = Join-Path $annRoot 'manual-links.json'
$cacheRoot     = Join-Path $annRoot 'search-cache'
$reportPath    = Join-Path $annRoot 'search-report.json'

if (-not (Test-Path -LiteralPath $entitiesPath)) {
    throw "entities-enriched.json not found: $entitiesPath. Run Enrich-AnnouncementLinks.ps1 first."
}
New-Item -ItemType Directory -Path $cacheRoot -Force | Out-Null

$doc = Get-Content -Raw -LiteralPath $entitiesPath | ConvertFrom-Json -Depth 30
$entities = @($doc.entities)

$manualDoc = if (Test-Path -LiteralPath $manualPath) {
    Get-Content -Raw -LiteralPath $manualPath | ConvertFrom-Json -Depth 10
} else { $null }
$manualKindsByEntity = @{}  # entity-id -> Set<kind>
if ($manualDoc -and $manualDoc.entities) {
    foreach ($prop in $manualDoc.entities.PSObject.Properties) {
        $set = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($l in @($prop.Value)) {
            if ($l.kind) { [void]$set.Add($l.kind) }
        }
        $manualKindsByEntity[$prop.Name] = $set
    }
}

# Optional subset filter.
if ($OnlyEntities.Count -gt 0) {
    $wantSet = New-Object 'System.Collections.Generic.HashSet[string]' ([string[]]$OnlyEntities, [StringComparer]::OrdinalIgnoreCase)
    $entities = $entities | Where-Object {
        $slug = ($_.id -split ':')[-1]
        $wantSet.Contains($slug) -or $wantSet.Contains($_.id)
    }
}

Write-Host "Search-AnnouncementLinks: $($entities.Count) entit(ies) candidate for web-search enrichment" -ForegroundColor Cyan
Write-Host "  Provider:        $Provider (with fallback: duckduckgo-browser, bing)"
Write-Host "  Concurrency:     $SearchConcurrency"
Write-Host "  Cache TTL:       $CacheTtlDays days"
Write-Host "  Recall package:  Zakira.Recall@$RecallPackageVersion (via dnx)"
Write-Host "  Cache root:      $cacheRoot"
Write-Host ''

# --------------------------------------------------------------------------
# parallel pass: run recall search per entity, write per-entity cache files.
# --------------------------------------------------------------------------

$sw = [System.Diagnostics.Stopwatch]::StartNew()

$jobInputs = foreach ($e in $entities) {
    $slug = ($e.id -split ':')[-1]
    $cachePath = Join-Path $cacheRoot ($slug + '.json')

    # Skip-from-cache check.
    $skipReason = $null
    if (-not $Force -and (Test-Path -LiteralPath $cachePath)) {
        $age = (Get-Date) - (Get-Item -LiteralPath $cachePath).LastWriteTime
        if ($age.TotalDays -lt $CacheTtlDays) {
            $skipReason = "cache-fresh ($([Math]::Round($age.TotalDays,1))d)"
        }
    }

    [pscustomobject]@{
        Id            = $e.id
        Slug          = $slug
        CanonicalName = $e.canonicalName
        Category      = $e.category
        Tagline       = $e.tagline
        CachePath     = $cachePath
        SkipReason    = $skipReason
    }
}

# Funnel cacheable entities through a parallel pipeline; emit one
# enrichment-result per entity. Each parallel worker is its own process via
# Invoke-RecallSearch, so they're naturally isolated.
$results = $jobInputs | ForEach-Object -ThrottleLimit $SearchConcurrency -Parallel {
    $j = $_
    $RepoRoot              = $using:RepoRoot
    $Provider              = $using:Provider
    $TimeoutSeconds        = $using:TimeoutSeconds
    $RecallPackageVersion  = $using:RecallPackageVersion
    $DnxPath               = $using:script:DnxPath

    if ($j.SkipReason) {
        return [pscustomobject]@{
            Id = $j.Id; Slug = $j.Slug; Status = 'skipped-cache'; Detail = $j.SkipReason; Selected = $null; Raw = $null
        }
    }

    # Helper functions cannot cross runspace boundaries; redeclare the few
    # tiny ones we need inside the parallel scriptblock.
    function _Suffix([string]$c) {
        switch -Regex ($c) {
            '^(SDK|library|framework|runtime)$' { return 'github nuget' }
            '^model$'                            { return 'huggingface documentation' }
            default                              { return 'microsoft learn docs' }
        }
    }
    $suffix = _Suffix $j.Category
    $query  = "$($j.CanonicalName) Microsoft Build 2026 $suffix"

    # Inline Invoke-RecallSearch (parallel runspaces can't see outer funcs).
    # On Windows dnx is shipped as dnx.cmd. .NET 5+ Process.Start can launch
    # .cmd files directly when given the full path; it handles the batch-
    # file quoting internally so ArgumentList items with spaces pass through
    # cleanly. Going through cmd.exe /c instead breaks on paths like
    # `C:\Program Files\dotnet\dnx.cmd` because /c re-parses without quoting.
    $psi = [System.Diagnostics.ProcessStartInfo]@{
        FileName               = $DnxPath
        UseShellExecute        = $false
        RedirectStandardOutput = $true
        RedirectStandardError  = $true
        CreateNoWindow         = $true
    }
    foreach ($a in @(
        "Zakira.Recall@$RecallPackageVersion", '--yes', '--',
        'search', $query,
        '--provider',     $Provider,
        '--limit',        '15',
        '--fallback',     'true',
        '--output',       'json'
    )) { [void]$psi.ArgumentList.Add($a) }

    $ssw = [System.Diagnostics.Stopwatch]::StartNew()
    $proc = [System.Diagnostics.Process]::Start($psi)
    $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
    $stderrTask = $proc.StandardError.ReadToEndAsync()
    $exited = $proc.WaitForExit([int]([TimeSpan]::FromSeconds($TimeoutSeconds + 30).TotalMilliseconds))
    if (-not $exited) {
        try { $proc.Kill($true) } catch { }
        $ssw.Stop()
        return [pscustomobject]@{
            Id = $j.Id; Slug = $j.Slug; Status = 'timeout'; Detail = "${TimeoutSeconds}s exceeded"; Selected = $null; Raw = $null
        }
    }
    [void]$stdoutTask.Wait()
    [void]$stderrTask.Wait()
    $ssw.Stop()
    $stdout = $stdoutTask.Result

    $parsed = $null
    if ($proc.ExitCode -eq 0) {
        try { $parsed = $stdout | ConvertFrom-Json -Depth 30 } catch { $parsed = $null }
    }

    return [pscustomobject]@{
        Id        = $j.Id
        Slug      = $j.Slug
        Status    = if ($parsed) { 'searched' } else { 'failed' }
        Detail    = if ($parsed) { "$(@($parsed.Results).Count) result(s)" } else { "exit-$($proc.ExitCode): $(($stderrTask.Result.Trim() -split "`n" | Select-Object -First 1))" }
        Query     = $query
        ElapsedS  = [Math]::Round($ssw.Elapsed.TotalSeconds, 1)
        Raw       = $stdout
    }
}

$sw.Stop()
Write-Host ("Recall search phase complete in {0:N1}s." -f $sw.Elapsed.TotalSeconds) -ForegroundColor Cyan
$searched     = @($results | Where-Object Status -eq 'searched')
$skippedCache = @($results | Where-Object Status -eq 'skipped-cache')
$failed       = @($results | Where-Object Status -in @('failed','timeout'))
Write-Host ("  searched:     {0}" -f $searched.Count) -ForegroundColor Green
Write-Host ("  skipped:      {0}" -f $skippedCache.Count) -ForegroundColor DarkGray
Write-Host ("  failed:       {0}" -f $failed.Count) -ForegroundColor $(if ($failed.Count -gt 0) { 'Yellow' } else { 'DarkGray' })
if ($failed.Count -gt 0) {
    Write-Host "  First 3 failures:" -ForegroundColor Yellow
    $failed | Select-Object -First 3 | ForEach-Object {
        Write-Host "    $($_.Slug): $($_.Detail)" -ForegroundColor DarkYellow
    }
}

# --------------------------------------------------------------------------
# serial pass: parse + filter + score + cache + project links per entity.
# Kept serial because the per-entity work is sub-millisecond and we want
# deterministic UI output.
# --------------------------------------------------------------------------

$entityIndex = @{}
foreach ($e in $entities) { $entityIndex[$e.id] = $e }

$nowIso = (Get-Date).ToUniversalTime().ToString('o')
$pickedLinksByEntity = @{}  # id -> array of selected link records
$reportRows = New-Object 'System.Collections.Generic.List[object]'

foreach ($r in $results) {
    try {
    $e = $entityIndex[$r.Id]
    if (-not $e) { continue }
    $cachePath = (Get-Item -LiteralPath (Join-Path $cacheRoot ($r.Slug + '.json')) -ErrorAction SilentlyContinue)?.FullName
    if (-not $cachePath) { $cachePath = Join-Path $cacheRoot ($r.Slug + '.json') }

    # Cache-hit: load previous selectedLinks from disk.
    if ($r.Status -eq 'skipped-cache') {
        try {
            $cached = Get-Content -Raw -LiteralPath $cachePath | ConvertFrom-Json -Depth 30
            $pickedLinksByEntity[$r.Id] = @($cached.selectedLinks)
            $reportRows.Add([pscustomobject]@{ id = $r.Id; status = 'cache-hit'; linksAdded = @($cached.selectedLinks).Count }) | Out-Null
        } catch {
            $reportRows.Add([pscustomobject]@{ id = $r.Id; status = 'cache-parse-error'; linksAdded = 0 }) | Out-Null
        }
        continue
    }

    if ($r.Status -ne 'searched' -or -not $r.Raw) {
        $reportRows.Add([pscustomobject]@{ id = $r.Id; status = $r.Status; linksAdded = 0; detail = $r.Detail }) | Out-Null
        continue
    }

    $parsed = try { $r.Raw | ConvertFrom-Json -Depth 30 } catch { $null }
    if (-not $parsed) {
        $reportRows.Add([pscustomobject]@{ id = $r.Id; status = 'json-parse-error'; linksAdded = 0 }) | Out-Null
        continue
    }

    # Filter through allowlist + score each hit, pick best per kind.
    $keyTokens = @(Get-EntityKeyTokens $e.canonicalName)
    $candidates = New-Object 'System.Collections.Generic.List[object]'
    foreach ($hit in @($parsed.Results)) {
        $kind = Get-DomainKind $hit.Url
        if (-not $kind) { continue }
        $scored = Score-Candidate -hit $hit -canonicalName $e.canonicalName -keyTokens $keyTokens
        if ($scored.Score -lt 4) { continue }   # rejection floor
        $candidates.Add([pscustomobject]@{
            Hit     = $hit
            Kind    = $kind
            Score   = $scored.Score
            Reasons = $scored.Reasons
        }) | Out-Null
    }

    # Best per kind: highest score wins, then lowest rank, then shortest URL.
    $best = $candidates |
        Group-Object Kind |
        ForEach-Object {
            $top = $_.Group |
                Sort-Object @{ Expression={ $_.Score }; Descending=$true }, `
                            @{ Expression={ [int]($_.Hit.Rank ?? 99) }; Descending=$false }, `
                            @{ Expression={ ($_.Hit.Url).Length }; Descending=$false } |
                Select-Object -First 1
            $top
        }

    # Cap to a sensible per-entity max so a single noisy entity can't
    # explode the link list. Github + docs + nuget + blog is plenty.
    $selected = $best | Sort-Object @{ Expression={ $_.Score }; Descending=$true } | Select-Object -First 4

    $selectedLinks = foreach ($s in $selected) {
        $confidence = if ($s.Score -ge 8) { 'high' } elseif ($s.Score -ge 6) { 'medium' } else { 'low' }
        [pscustomobject][ordered]@{
            kind             = $s.Kind
            url              = $s.Hit.CanonicalUrl ?? $s.Hit.Url
            label            = $s.Hit.Title
            source           = 'search'
            sourceProvider   = $s.Hit.Provider ?? $Provider
            sourceQuery      = $r.Query
            sourceConfidence = $confidence
            sourceScore      = $s.Score
            sourceReasons    = $s.Reasons
            sourceSnippet    = $s.Hit.Snippet
        }
    }
    $pickedLinksByEntity[$r.Id] = @($selectedLinks)

    # Write per-entity cache (raw + selection).
    $cacheDoc = [ordered]@{
        schemaVersion = 1
        entityId      = $r.Id
        canonicalName = $e.canonicalName
        category      = $e.category
        queriedAt     = $nowIso
        provider      = $Provider
        query         = $r.Query
        rawResults    = @($parsed.Results)
        selectedLinks = @($selectedLinks)
    }
    $cacheDoc | ConvertTo-Json -Depth 30 | Set-Content -LiteralPath $cachePath -Encoding utf8

    $reportRows.Add([pscustomobject]@{
        id         = $r.Id
        status     = if ($selectedLinks.Count -gt 0) { 'ok' } else { 'no-allowlist-hits' }
        linksAdded = @($selectedLinks).Count
        elapsedS   = $r.ElapsedS
    }) | Out-Null
    } catch {
        Write-Host "PARSE-FAIL entity=$($r.Id) $($_.Exception.GetType().FullName): $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "  at $($_.InvocationInfo.PositionMessage)" -ForegroundColor DarkRed
        throw
    }
}

# --------------------------------------------------------------------------
# merge selected search links back into entities-enriched.json. Honour the
# manual layer (manual wins, never replaced). Replace any pre-existing
# 'source: "search"' links for the same entity (this run is the source of
# truth for the search layer).
# --------------------------------------------------------------------------

$kindOrder   = @{ 'github' = 1; 'nuget' = 2; 'npm' = 3; 'pypi' = 4; 'crates' = 5; 'huggingface' = 6; 'docs' = 7; 'samples' = 8; 'marketplace' = 9; 'blog' = 10; 'other' = 99 }
$sourceOrder = @{ 'manual' = 1; 'transcript' = 2; 'search' = 3; 'model' = 4 }

foreach ($e in $entities) {
    try {
    $existingLinks = @($e.links)
    # Drop previous search-layer links for a clean re-merge.
    $existingLinks = @($existingLinks | Where-Object { $_.source -ne 'search' })

    $newLinks = if ($pickedLinksByEntity.ContainsKey($e.id)) { $pickedLinksByEntity[$e.id] } else { @() }

    # If manual layer already has a link of this kind, drop the search candidate of the same kind.
    if ($manualKindsByEntity.ContainsKey($e.id)) {
        $manualKinds = $manualKindsByEntity[$e.id]
        $newLinks = @($newLinks | Where-Object { -not $manualKinds.Contains($_.kind) })
    }

    # Drop search candidates whose URL exactly matches an existing transcript/manual link (dedupe by normalised URL).
    $existingUrlKeys = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($l in $existingLinks) {
        try {
            $u = [Uri]$l.url
            $key = "$($u.Scheme.ToLowerInvariant())://$($u.Host.ToLowerInvariant())$($u.AbsolutePath.ToLowerInvariant().TrimEnd('/'))"
            [void]$existingUrlKeys.Add($key)
        } catch { }
    }
    $newLinks = @($newLinks | Where-Object {
        try {
            $u = [Uri]$_.url
            $key = "$($u.Scheme.ToLowerInvariant())://$($u.Host.ToLowerInvariant())$($u.AbsolutePath.ToLowerInvariant().TrimEnd('/'))"
            -not $existingUrlKeys.Contains($key)
        } catch { $true }
    })

    $mergedLinks = @($existingLinks) + @($newLinks)
    $mergedSorted = $mergedLinks | Sort-Object `
        @{ Expression={ $sourceOrder[$_.source] }; Ascending=$true }, `
        @{ Expression={ if ($kindOrder.ContainsKey($_.kind)) { $kindOrder[$_.kind] } else { 99 } }; Ascending=$true }, `
        @{ Expression={ $_.url }; Ascending=$true }

    # Update link counts.
    $sortedArray = @($mergedSorted)
    $e.links = $sortedArray
    if (-not $e.linkCounts) {
        $e | Add-Member -NotePropertyName linkCounts -NotePropertyValue ([pscustomobject][ordered]@{ }) -Force
    }
    $lc = [ordered]@{
        total      = $sortedArray.Count
        transcript = (@($sortedArray | Where-Object source -eq 'transcript')).Count
        manual     = (@($sortedArray | Where-Object source -eq 'manual')).Count
        search     = (@($sortedArray | Where-Object source -eq 'search')).Count
        model      = (@($sortedArray | Where-Object source -eq 'model')).Count
        github     = (@($sortedArray | Where-Object kind   -eq 'github')).Count
        nuget      = (@($sortedArray | Where-Object kind   -eq 'nuget')).Count
        docs       = (@($sortedArray | Where-Object kind   -eq 'docs')).Count
    }
    $e.linkCounts = [pscustomobject]$lc
    } catch {
        Write-Host "MERGE-FAIL entity=$($e.id) $($_.Exception.GetType().FullName): $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Update the source summary in the doc header.
if (-not $doc.sourceSummary) {
    $doc | Add-Member -NotePropertyName sourceSummary -NotePropertyValue ([pscustomobject][ordered]@{ }) -Force
}
$searchLinkTotal = 0
foreach ($e in $entities) { $searchLinkTotal += (@($e.links | Where-Object source -eq 'search')).Count }
$doc.sourceSummary = [pscustomobject][ordered]@{
    transcriptLinks = ($doc.sourceSummary.transcriptLinks ?? 0)
    manualLinks     = ($doc.sourceSummary.manualLinks ?? 0)
    searchLinks     = $searchLinkTotal
    modelLinks      = 0
}

$doc | ConvertTo-Json -Depth 30 | Set-Content -LiteralPath $entitiesPath -Encoding utf8

# --------------------------------------------------------------------------
# write run report
# --------------------------------------------------------------------------

$reportSummary = [ordered]@{
    schemaVersion    = 1
    conference       = $Conference
    eventId          = $EventId
    generatedAt      = $nowIso
    elapsedSeconds   = [Math]::Round($sw.Elapsed.TotalSeconds, 1)
    provider         = $Provider
    concurrency      = $SearchConcurrency
    entityCount      = $entities.Count
    queriedThisRun   = $searched.Count
    skippedFromCache = $skippedCache.Count
    failed           = $failed.Count
    searchLinksTotal = $searchLinkTotal
    perEntity        = $reportRows.ToArray()
}
$reportSummary | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $reportPath -Encoding utf8

Write-Host ''
Write-Host ("Updated $entitiesPath with $searchLinkTotal search-derived link(s).") -ForegroundColor Green
Write-Host ("Report: $reportPath") -ForegroundColor Cyan
Write-Host ''
Write-Host "Next: scripts/Build-Book.ps1 -Conference $Conference -EventId $EventId" -ForegroundColor Cyan
