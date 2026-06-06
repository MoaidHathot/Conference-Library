# Enrich-AnnouncementLinks.ps1
#
# Step 3 of the announcements pipeline. Joins the canonical entities.json +
# mentions.json (from Step 2) with two link-source layers, in priority order:
#
#   1. transcript  - URLs literally present in any mention's
#                    explicitLinks (already extracted in Step 1).
#   2. manual      - hand-curated entries from manual-links.json. Authoritative;
#                    drawn from human review of demos / on-screen URLs / vendor
#                    docs that the captioned transcript missed.
#
# A third layer (`model`) is planned: a per-entity Copilot lookup that emits
# canonical GitHub / NuGet / docs URLs the model can confirm exist, badged in
# the UI as "model-suggested". Left for a follow-up commit so the first
# end-to-end pipeline lands faster.
#
# Output: catalog/<Conf>/<Event>/announcements/entities-enriched.json. Same
# shape as entities.json, plus a `links` array per entity (each entry tagged
# with `source` so the renderer can show source badges) and a `linkCounts`
# breakdown.
#
# Plus an idempotent maintainer-curated file:
#
#   manual-links.json   { schemaVersion, entities: { "<entity-id>": [
#                         {kind, url, label?}, ... ] } }
#                       Auto-created empty on first run.
#
# Pure PowerShell, no LLM. Fast (sub-second). Re-running after editing
# manual-links.json or aliases.json (Step 2) is the standard maintainer loop:
#   pwsh scripts/Resolve-AnnouncementEntities.ps1 -Conference Build -EventId 2026
#   pwsh scripts/Enrich-AnnouncementLinks.ps1     -Conference Build -EventId 2026
#   pwsh scripts/Build-Book.ps1                   -Conference Build -EventId 2026
[CmdletBinding()]
param(
    [Parameter()][string]$Conference = 'Build',
    [Parameter()][string]$EventId    = '2026',
    [Parameter()][string]$RepoRoot   = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

# --------------------------------------------------------------------------
# helpers
# --------------------------------------------------------------------------

function Normalise-Url {
    # Used for de-duplication: lowercase host + lowercase path; preserves
    # case-sensitive query strings (GitHub doesn't care, but better safe).
    param([string]$u)
    if ([string]::IsNullOrWhiteSpace($u)) { return '' }
    $trimmed = $u.Trim().TrimEnd('/')
    # Add a leading scheme if the transcript captured a bare host (common
    # for `aka.ms/...` style URLs spoken aloud).
    if ($trimmed -notmatch '^https?://' -and $trimmed -notmatch '^mailto:') {
        $trimmed = 'https://' + $trimmed
    }
    try {
        $uri = [Uri]$trimmed
        $host_ = $uri.Host.ToLowerInvariant()
        $path  = $uri.AbsolutePath.ToLowerInvariant().TrimEnd('/')
        $key = "$($uri.Scheme.ToLowerInvariant())://$host_$path"
        if ($uri.Query) { $key += $uri.Query }
        return $key
    } catch {
        return $trimmed.ToLowerInvariant()
    }
}

function Guess-Kind {
    # Best-effort kind inference for transcript-captured URLs that arrived
    # with a generic / unspecified kind. Manual entries override this.
    param([string]$url, [string]$existingKind)
    if ($existingKind -and $existingKind -ne 'other') { return $existingKind }
    $u = $url.ToLowerInvariant()
    if ($u -match 'github\.com/[^/]+/[^/]+') { return 'github' }
    if ($u -match 'nuget\.org/packages')     { return 'nuget' }
    if ($u -match 'npmjs\.com/package')      { return 'npm' }
    if ($u -match 'pypi\.org/project')       { return 'pypi' }
    if ($u -match 'crates\.io')              { return 'crates' }
    if ($u -match 'huggingface\.co')         { return 'huggingface' }
    if ($u -match 'docs\.microsoft\.com|learn\.microsoft\.com|microsoft\.com/.+/docs|aka\.ms/.*-docs') { return 'docs' }
    if ($u -match 'blog|/blog/|techcommunity\.microsoft\.com')  { return 'blog' }
    if ($u -match 'marketplace\.visualstudio\.com|chrome\.google\.com/webstore') { return 'marketplace' }
    if ($u -match 'samples|examples|playground') { return 'samples' }
    if ($u -match 'aka\.ms') { return 'docs' }
    return 'other'
}

function Clean-Url {
    # Light cleanup: trim, add scheme. Does NOT fix garbled URLs (e.g.
    # 'github.com/foo bar baz') - those stay as-is so the maintainer can
    # spot them in manual-links.json review.
    param([string]$u)
    if ([string]::IsNullOrWhiteSpace($u)) { return $u }
    $t = $u.Trim()
    if ($t -notmatch '^https?://' -and $t -notmatch '^mailto:') {
        $t = 'https://' + $t
    }
    return $t
}

# --------------------------------------------------------------------------
# paths
# --------------------------------------------------------------------------

$catalogRoot = Join-Path $RepoRoot "catalog\$Conference\$EventId"
$annRoot     = Join-Path $catalogRoot 'announcements'
$entitiesPath        = Join-Path $annRoot 'entities.json'
$mentionsPath        = Join-Path $annRoot 'mentions.json'
$manualLinksPath     = Join-Path $annRoot 'manual-links.json'
$enrichedPath        = Join-Path $annRoot 'entities-enriched.json'
$enrichmentReportPath = Join-Path $annRoot 'enrichment-report.json'

if (-not (Test-Path -LiteralPath $entitiesPath))  { throw "entities.json not found: $entitiesPath. Run Resolve-AnnouncementEntities.ps1 first." }
if (-not (Test-Path -LiteralPath $mentionsPath))  { throw "mentions.json not found: $mentionsPath. Run Resolve-AnnouncementEntities.ps1 first." }

if (-not (Test-Path -LiteralPath $manualLinksPath)) {
    @{
        schemaVersion = 1
        notes         = 'Hand-curated authoritative links. entities.<entity-id> -> [{kind, url, label?}]. Entries here override transcript-extracted links of the same URL and are always shown first in the UI.'
        entities      = @{}
    } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manualLinksPath -Encoding utf8
    Write-Host "Created empty manual-links file: $manualLinksPath" -ForegroundColor DarkGray
}

# --------------------------------------------------------------------------
# load inputs
# --------------------------------------------------------------------------

$entitiesDoc    = Get-Content -Raw -LiteralPath $entitiesPath    | ConvertFrom-Json -Depth 20
$mentionsDoc    = Get-Content -Raw -LiteralPath $mentionsPath    | ConvertFrom-Json -Depth 20
$manualLinksDoc = Get-Content -Raw -LiteralPath $manualLinksPath | ConvertFrom-Json -Depth 10

# Index mentions by entityId so we can join in O(1).
$mentionsByEntity = @{}
foreach ($m in $mentionsDoc.mentions) {
    if (-not $mentionsByEntity.ContainsKey($m.entityId)) {
        $mentionsByEntity[$m.entityId] = New-Object 'System.Collections.Generic.List[object]'
    }
    $mentionsByEntity[$m.entityId].Add($m) | Out-Null
}

# Project the manual-links section to a hashtable id -> link array.
$manualByEntity = @{}
if ($manualLinksDoc.entities) {
    foreach ($prop in $manualLinksDoc.entities.PSObject.Properties) {
        $manualByEntity[$prop.Name] = @($prop.Value)
    }
}

Write-Host "Loaded $($entitiesDoc.entityCount) entities, $($mentionsDoc.mentions.Count) mentions, $($manualByEntity.Count) entities with manual links." -ForegroundColor Cyan

# --------------------------------------------------------------------------
# enrich each entity
# --------------------------------------------------------------------------

$enrichedEntities = New-Object 'System.Collections.Generic.List[object]'
$totalTranscriptLinks = 0
$totalManualLinks     = 0
$entitiesWithAnyLink  = 0

foreach ($e in $entitiesDoc.entities) {
    $links    = New-Object 'System.Collections.Generic.List[object]'
    $seenKeys = @{}

    # Layer 1: transcript-extracted, drawn from this entity's mentions.
    $entityMentions = if ($mentionsByEntity.ContainsKey($e.id)) { $mentionsByEntity[$e.id].ToArray() } else { @() }
    foreach ($m in $entityMentions) {
        if (-not $m.explicitLinks) { continue }
        foreach ($l in @($m.explicitLinks)) {
            if ([string]::IsNullOrWhiteSpace($l.url)) { continue }
            $clean = Clean-Url $l.url
            $key   = Normalise-Url $clean
            if ($seenKeys.ContainsKey($key)) { continue }
            $seenKeys[$key] = $true
            $kind = Guess-Kind $clean $l.kind
            $links.Add([pscustomobject][ordered]@{
                kind          = $kind
                url           = $clean
                label         = $null
                source        = 'transcript'
                sourceSession = $m.sessionCode
                sourceTime    = $m.timestamp
            }) | Out-Null
            $totalTranscriptLinks++
        }
    }

    # Layer 2: manual overrides. Inserted AFTER transcript in the link list
    # but the UI sorts by source priority so they render first. If a manual
    # URL collides with a transcript URL, the manual entry replaces it (we
    # remove the transcript one and add the manual one in its place).
    if ($manualByEntity.ContainsKey($e.id)) {
        foreach ($l in $manualByEntity[$e.id]) {
            if ([string]::IsNullOrWhiteSpace($l.url)) { continue }
            $clean = Clean-Url $l.url
            $key   = Normalise-Url $clean
            # If a transcript entry already used this URL, replace it - manual is authoritative.
            if ($seenKeys.ContainsKey($key)) {
                $toRemove = $links | Where-Object { (Normalise-Url $_.url) -eq $key } | Select-Object -First 1
                if ($toRemove) { [void]$links.Remove($toRemove) }
            }
            $seenKeys[$key] = $true
            $kind = Guess-Kind $clean $l.kind
            $links.Add([pscustomobject][ordered]@{
                kind          = $kind
                url           = $clean
                label         = $l.label
                source        = 'manual'
                sourceSession = $null
                sourceTime    = $null
            }) | Out-Null
            $totalManualLinks++
        }
    }

    # Stable link ordering: manual first (authoritative), then transcript,
    # then within each layer by kind preference (github, nuget, docs, ...)
    # then alphabetically. The renderer can re-group by kind for display.
    $kindOrder = @{ 'github' = 1; 'nuget' = 2; 'npm' = 3; 'pypi' = 4; 'crates' = 5; 'huggingface' = 6; 'docs' = 7; 'samples' = 8; 'marketplace' = 9; 'blog' = 10; 'other' = 99 }
    $sourceOrder = @{ 'manual' = 1; 'transcript' = 2; 'model' = 3 }
    $linksSorted = $links | Sort-Object `
        @{ Expression = { $sourceOrder[$_.source] } }, `
        @{ Expression = { if ($kindOrder.ContainsKey($_.kind)) { $kindOrder[$_.kind] } else { 99 } } }, `
        url

    $byKind   = $linksSorted | Group-Object kind   | ForEach-Object { @{ ($_.Name) = $_.Count } }
    $bySource = $linksSorted | Group-Object source | ForEach-Object { @{ ($_.Name) = $_.Count } }
    if ($linksSorted.Count -gt 0) { $entitiesWithAnyLink++ }

    # Aggregate code snippets across mentions (deduped by code body).
    $allSnippets = New-Object 'System.Collections.Generic.List[object]'
    $seenSnippetKeys = @{}
    foreach ($m in $entityMentions) {
        if (-not $m.codeSnippets) { continue }
        foreach ($s in @($m.codeSnippets)) {
            if ([string]::IsNullOrWhiteSpace($s.code)) { continue }
            $skey = ($s.code -replace '\s+', ' ').Trim().ToLowerInvariant()
            if ($seenSnippetKeys.ContainsKey($skey)) { continue }
            $seenSnippetKeys[$skey] = $true
            $allSnippets.Add([pscustomobject][ordered]@{
                language      = $s.language
                code          = $s.code
                sourceSession = $m.sessionCode
                sourceTime    = if ($s.timestamp) { $s.timestamp } else { $m.timestamp }
            }) | Out-Null
        }
    }

    # Carry over every property from the input entity, then add the
    # enrichment fields. Using PSObject.Properties keeps the schema
    # forward-compatible if Step 2 grows new fields.
    $copy = [ordered]@{}
    foreach ($prop in $e.PSObject.Properties) { $copy[$prop.Name] = $prop.Value }
    # @(<List<object>>) raises "Argument types do not match" on PS 7+; .ToArray() bypasses.
    $copy['links']        = @($linksSorted)
    $copy['codeSnippets'] = $allSnippets.ToArray()
    $copy['linkCounts']   = [pscustomobject][ordered]@{
        total      = $linksSorted.Count
        transcript = ($linksSorted | Where-Object { $_.source -eq 'transcript' }).Count
        manual     = ($linksSorted | Where-Object { $_.source -eq 'manual' }).Count
        model      = ($linksSorted | Where-Object { $_.source -eq 'model' }).Count
        github     = ($linksSorted | Where-Object { $_.kind   -eq 'github' }).Count
        nuget      = ($linksSorted | Where-Object { $_.kind   -eq 'nuget' }).Count
        docs       = ($linksSorted | Where-Object { $_.kind   -eq 'docs' }).Count
    }

    $enrichedEntities.Add([pscustomobject]$copy) | Out-Null
}

# --------------------------------------------------------------------------
# write outputs
# --------------------------------------------------------------------------

$generatedAt = (Get-Date).ToUniversalTime().ToString('o')

$enrichedDoc = [ordered]@{
    schemaVersion = 1
    conference    = $Conference
    eventId       = $EventId
    generatedAt   = $generatedAt
    entityCount   = $enrichedEntities.Count
    sourceSummary = [ordered]@{
        transcriptLinks = $totalTranscriptLinks
        manualLinks     = $totalManualLinks
        modelLinks      = 0
    }
    entities      = $enrichedEntities.ToArray()
}
$enrichedDoc | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $enrichedPath -Encoding utf8

$report = [ordered]@{
    schemaVersion        = 1
    conference           = $Conference
    eventId              = $EventId
    generatedAt          = $generatedAt
    entityCount          = $enrichedEntities.Count
    entitiesWithAnyLink  = $entitiesWithAnyLink
    transcriptLinks      = $totalTranscriptLinks
    manualLinks          = $totalManualLinks
    modelLinks           = 0
    manualEntitiesLoaded = $manualByEntity.Count
}
$report | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $enrichmentReportPath -Encoding utf8

Write-Host ''
Write-Host "Enrichment complete." -ForegroundColor Cyan
Write-Host ("  Entities:                {0}" -f $enrichedEntities.Count)
Write-Host ("  Transcript-extracted:    {0}" -f $totalTranscriptLinks)
Write-Host ("  Manual:                  {0}" -f $totalManualLinks)
Write-Host ("  Model-suggested:         (not run; opt-in flag forthcoming)")
Write-Host ("  Entities with any link:  {0}" -f $entitiesWithAnyLink)
Write-Host ''
Write-Host "Wrote:" -ForegroundColor Cyan
Write-Host "  $enrichedPath"
Write-Host "  $enrichmentReportPath"
Write-Host ''
Write-Host "Edit $manualLinksPath to add authoritative GitHub/NuGet/docs/etc URLs per entity-id, then re-run." -ForegroundColor DarkGray
Write-Host "Next: scripts/Build-Book.ps1 -Conference $Conference -EventId $EventId" -ForegroundColor Cyan
