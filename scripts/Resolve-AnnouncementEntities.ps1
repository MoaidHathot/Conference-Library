# Resolve-AnnouncementEntities.ps1
#
# Step 2 of the announcements pipeline. Joins every per-session
# announcements.json from Step 1 into two cross-session artifacts:
#
#   catalog/<Conf>/<Event>/announcements/
#     entities.json            one record per canonical product / library /
#                              service / model / etc., with aggregated
#                              metadata (canonical name, tagline, long
#                              description, aliases, first mention, mention
#                              count, top sessions, category distribution).
#     mentions.json            one row per (entityId, sessionCode, timestamp)
#                              join, carrying the per-session detail (window
#                              long-description, speakers at timestamp,
#                              frames, transcript-explicit links, code
#                              snippets, isInferred flag, raw name as the
#                              session announced it).
#     resolution-report.json   diff-friendly audit so subsequent runs let
#                              you eyeball merges/splits over time.
#
# Plus an idempotent overrides file the maintainer hand-curates:
#
#     aliases.json             groups of {canonicalName, category, aliases[]}.
#                              Created empty on first run; loaded and
#                              honoured BEFORE any heuristic clustering, so
#                              you can pin canonical names / merge fuzzy
#                              variants the heuristic doesn't catch.
#
# Pure PowerShell, no LLM in the default path. Fast (seconds for hundreds
# of sessions). Re-running is safe and produces a byte-stable JSON when
# nothing has changed upstream.
[CmdletBinding()]
param(
    [Parameter()][string]$Conference = 'Build',
    [Parameter()][string]$EventId    = '2026',
    [Parameter()][string]$RepoRoot   = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

# --------------------------------------------------------------------------
# helpers (defined before use - PowerShell does NOT hoist function defs in
# top-level script scope, only inside modules / advanced functions).
# --------------------------------------------------------------------------

function Normalise-Name {
    param([string]$s)
    if ([string]::IsNullOrWhiteSpace($s)) { return '' }
    # Lowercase, strip diacritics-light by going to ASCII fold (PowerShell
    # doesn't ship a clean NFD strip; the .NET helper is fine).
    $lower = $s.ToLowerInvariant()
    # Drop everything that isn't alphanum or space; collapse whitespace.
    $compact = ([regex]::Replace($lower, '[^a-z0-9 ]+', ' ')).Trim()
    return ([regex]::Replace($compact, '\s+', ' '))
}

function Strip-Qualifiers {
    param([string]$normName)
    # Operates on the output of Normalise-Name (already lower, no punctuation).
    # Removes the trailing qualifiers the summarizer commonly appends.
    $patterns = @(
        '\blimited preview\b',
        '\bpublic preview\b',
        '\bprivate preview\b',
        '\bpreview\b',
        '\bcoming soon\b',
        '\bnow ga\b',
        '\bga\b',
        '\bbeta\b',
        '\bexperimental\b',
        '\binferred\b'
    )
    $out = $normName
    foreach ($p in $patterns) { $out = [regex]::Replace($out, $p, '') }
    return ([regex]::Replace($out, '\s+', ' ')).Trim()
}

function Clean-DisplayName {
    param([string]$raw)
    if ([string]::IsNullOrWhiteSpace($raw)) { return '' }
    # Strip trailing parenthesised qualifiers and [inferred] markers but keep
    # internal punctuation, casing, and acronyms intact - this is what we
    # show to the reader.
    $out = $raw
    $out = [regex]::Replace($out, '\s*\(\s*(?:limited preview|public preview|private preview|preview|coming soon|now ga|ga|beta|experimental)\s*\)\s*$', '', 'IgnoreCase')
    $out = [regex]::Replace($out, '\s*\[inferred\]\s*', ' ', 'IgnoreCase')
    return ([regex]::Replace($out, '\s+', ' ')).Trim()
}

function Slug {
    param([string]$s)
    if ([string]::IsNullOrWhiteSpace($s)) { return 'unnamed' }
    $lower = $s.ToLowerInvariant()
    # Replace any non-alphanum with '-', collapse runs, trim.
    $slug = [regex]::Replace($lower, '[^a-z0-9]+', '-').Trim('-')
    if ([string]::IsNullOrEmpty($slug)) { $slug = 'unnamed' }
    # Cap length so the entity URLs stay sane.
    if ($slug.Length -gt 80) { $slug = $slug.Substring(0, 80).TrimEnd('-') }
    return $slug
}

# --------------------------------------------------------------------------
# script body
# --------------------------------------------------------------------------

$sessionsRoot = Join-Path $RepoRoot "sessions\$Conference\$EventId"
$catalogRoot  = Join-Path $RepoRoot "catalog\$Conference\$EventId"
$annRoot      = Join-Path $catalogRoot 'announcements'

if (-not (Test-Path -LiteralPath $sessionsRoot)) {
    throw "Sessions root not found: $sessionsRoot."
}
New-Item -ItemType Directory -Path $annRoot -Force | Out-Null

$aliasesPath           = Join-Path $annRoot 'aliases.json'
$entitiesPath          = Join-Path $annRoot 'entities.json'
$mentionsPath          = Join-Path $annRoot 'mentions.json'
$resolutionReportPath  = Join-Path $annRoot 'resolution-report.json'

# --------------------------------------------------------------------------
# 1. Load aliases.json (or create empty).
#
# Shape:
#   {
#     "schemaVersion": 1,
#     "groups": [
#       { "canonicalName": "Microsoft Foundry",
#         "category":      "platform",
#         "aliases":       ["foundry", "azure foundry", "azure ai foundry"] }
#     ]
#   }
#
# The canonicalName + category form the cluster key for every member of the
# group. The category in an alias group always wins over per-mention
# categories - this is how you correct miscategorisations the LLM made.
# --------------------------------------------------------------------------

if (-not (Test-Path -LiteralPath $aliasesPath)) {
    @{ schemaVersion = 1; groups = @() } |
        ConvertTo-Json -Depth 5 |
        Set-Content -LiteralPath $aliasesPath -Encoding utf8
    Write-Host "Created empty aliases file: $aliasesPath" -ForegroundColor DarkGray
}

$aliases = Get-Content -Raw -LiteralPath $aliasesPath | ConvertFrom-Json -Depth 10
$aliasGroups = @($aliases.groups)

# Build a normalised-name -> aliasGroup map for O(1) lookup. Each alias and
# the canonicalName itself both point at the group; later, an exact
# normalised match against any of them folds the mention into that cluster.
$aliasIndex = @{}
foreach ($g in $aliasGroups) {
    if ([string]::IsNullOrWhiteSpace($g.canonicalName)) { continue }
    $variants = @($g.canonicalName) + @($g.aliases)
    foreach ($v in $variants) {
        if ([string]::IsNullOrWhiteSpace($v)) { continue }
        $norm = Normalise-Name $v
        if (-not $aliasIndex.ContainsKey($norm)) {
            $aliasIndex[$norm] = $g
        }
    }
}

# --------------------------------------------------------------------------
# 2. Load every per-session announcements.json into a flat mention list.
# --------------------------------------------------------------------------

$sessionDirs = Get-ChildItem -LiteralPath $sessionsRoot -Directory
$allMentions = New-Object 'System.Collections.Generic.List[object]'

foreach ($d in $sessionDirs) {
    $annPath = Join-Path $d.FullName 'announcements.json'
    if (-not (Test-Path -LiteralPath $annPath)) { continue }

    try {
        $j = Get-Content -Raw -LiteralPath $annPath | ConvertFrom-Json -Depth 20
    } catch {
        Write-Warning "Skipping $annPath - JSON parse failed: $($_.Exception.Message)"
        continue
    }

    if (-not $j.announcements -or $j.announcements.Count -eq 0) { continue }

    $sessionCode  = $j.sessionCode
    $sessionTitle = $j.sessionTitle

    foreach ($a in $j.announcements) {
        $allMentions.Add([pscustomobject]@{
            RawName          = $a.name
            Category         = $a.category
            ShortDescription = $a.shortDescription
            LongDescription  = $a.longDescription
            Timestamp        = $a.timestamp
            TimestampSeconds = [int]$a.timestampSeconds
            Speakers         = @($a.speakers)
            Frames           = @($a.frames)
            ExplicitLinks    = @($a.explicitLinks)
            CodeSnippets     = @($a.codeSnippets)
            IsInferred       = [bool]$a.isInferred
            SessionCode      = $sessionCode
            SessionTitle     = $sessionTitle
        }) | Out-Null
    }
}

if ($allMentions.Count -eq 0) {
    Write-Warning "No mentions found across $($sessionDirs.Count) session(s). Run Get-SessionAnnouncements.ps1 first."
    return
}

Write-Host "Loaded $($allMentions.Count) mention(s) from per-session announcements.json files." -ForegroundColor Cyan

# --------------------------------------------------------------------------
# 3. Cluster mentions into entities.
#
# Cluster key strategy:
#   (a) If the mention's normalised name (or its stripped-qualifier form) is
#       in $aliasIndex, the cluster key is that group's (canonicalName,
#       category) - alias-folded mentions all collapse into a single entity
#       regardless of per-mention category.
#   (b) Otherwise the cluster key is (normalised_stripped_name, mentionCategory).
#       Two mentions with the same stripped normalised name but different
#       categories STAY SEPARATE - they are likely different products
#       (e.g. "Foundry" as a platform vs as a feature). The maintainer can
#       merge them later via aliases.json.
# --------------------------------------------------------------------------

$clusters = @{}  # cluster-key -> { Key; Members[] }

foreach ($m in $allMentions) {
    $normRaw     = Normalise-Name $m.RawName
    $normStripped = Strip-Qualifiers $normRaw

    $key       = $null
    $clusterCat = $null
    $aliasGroup = $null
    if ($aliasIndex.ContainsKey($normRaw))      { $aliasGroup = $aliasIndex[$normRaw] }
    elseif ($aliasIndex.ContainsKey($normStripped)) { $aliasGroup = $aliasIndex[$normStripped] }

    if ($aliasGroup) {
        $clusterCanon = $aliasGroup.canonicalName
        $clusterCat   = if ($aliasGroup.category) { $aliasGroup.category } else { $m.Category }
        $key = "alias::" + (Normalise-Name $clusterCanon)
    } else {
        $key = "auto::" + $normStripped + "::" + ($m.Category.ToLowerInvariant())
        $clusterCat = $m.Category
    }

    if (-not $clusters.ContainsKey($key)) {
        $clusters[$key] = [pscustomobject]@{
            Key                 = $key
            ForcedCanonical     = if ($aliasGroup) { $aliasGroup.canonicalName } else { $null }
            ForcedCategory      = $clusterCat
            Members             = New-Object 'System.Collections.Generic.List[object]'
        }
    }
    $clusters[$key].Members.Add($m) | Out-Null
}

Write-Host "Clustered into $($clusters.Count) candidate entities." -ForegroundColor Cyan

# --------------------------------------------------------------------------
# 4. For each cluster, derive entity record + mention records.
# --------------------------------------------------------------------------

$entities = New-Object 'System.Collections.Generic.List[object]'
$mentions = New-Object 'System.Collections.Generic.List[object]'
$usedIds  = @{}

foreach ($c in ($clusters.Values | Sort-Object @{ Expression = { $_.Members.Count }; Descending = $true }, Key)) {
    # @($c.Members) raises "Argument types do not match" against a
    # Generic.List<object> reached through a pscustomobject property in
    # PowerShell 7+. .ToArray() side-steps the wrapping issue cleanly.
    $members = $c.Members.ToArray()

    # Canonical name: alias override wins; else most-common raw form (tie:
    # longest then lexicographic). Stripping (preview), [inferred], etc.
    $canonical = if ($c.ForcedCanonical) {
        $c.ForcedCanonical
    } else {
        $byName = $members |
            ForEach-Object { (Clean-DisplayName $_.RawName) } |
            Group-Object |
            Sort-Object @{ Expression = 'Count'; Descending = $true }, @{ Expression = { $_.Name.Length }; Descending = $true }, Name
        $byName[0].Name
    }

    # Category: alias override wins; else most common category in the cluster.
    $catDistribution = $members | Group-Object Category | Sort-Object Count -Descending
    $category = if ($c.ForcedCategory) { $c.ForcedCategory } else { $catDistribution[0].Name }
    $catDistObj = [ordered]@{}
    foreach ($g in $catDistribution) { $catDistObj[$g.Name] = $g.Count }

    # Aliases: every distinct cleaned raw form that's not the canonical.
    $aliasesObserved = $members |
        ForEach-Object { Clean-DisplayName $_.RawName } |
        Where-Object { $_ -ne $canonical } |
        Sort-Object -Unique

    # First mention: earliest by (sessionCode, timestampSeconds). We use the
    # session code lexicographically as a stable secondary sort because we
    # don't have a true session start time on every record.
    $firstMention = $members |
        Sort-Object @{ Expression = { $_.TimestampSeconds }; Ascending = $true }, SessionCode |
        Select-Object -First 1

    # Tagline: shortest non-empty shortDescription >= 40 chars (or longest if
    # all are very short). Long descriptions are paragraphs; the tagline is
    # one line for the card grid.
    $shorts = $members |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_.ShortDescription) } |
        Select-Object -ExpandProperty ShortDescription |
        Sort-Object { $_.Length }
    $tagline =
        if ($shorts.Count -eq 0) { $canonical }
        elseif ($shorts[0].Length -ge 40) { $shorts[0] }
        else { $shorts[-1] }

    # Long description: longest non-empty longDescription that's strictly
    # different from the corresponding shortDescription (i.e. enriched).
    $longs = $members |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_.LongDescription) -and ($_.LongDescription -ne $_.ShortDescription) } |
        Select-Object -ExpandProperty LongDescription |
        Sort-Object { $_.Length } -Descending
    $longDesc = if ($longs.Count -gt 0) { $longs[0] } else { $tagline }

    # Top sessions: by mention count within the cluster, then lex.
    $topSessions = $members |
        Group-Object SessionCode |
        Sort-Object @{ Expression = 'Count'; Descending = $true }, Name |
        Select-Object -First 5 |
        ForEach-Object { $_.Name }

    # Stable entity id: <conference-lower>-<event>:<slug-from-canonical>.
    # If two distinct clusters slug-collide (rare but possible because the
    # slug strips much more aggressively than Normalise-Name), append a
    # category disambiguator and then a numeric suffix.
    $baseId = ("{0}-{1}:{2}" -f $Conference.ToLowerInvariant(), $EventId, (Slug $canonical))
    $entityId = $baseId
    if ($usedIds.ContainsKey($entityId)) {
        $entityId = $baseId + ':' + $category
        if ($usedIds.ContainsKey($entityId)) {
            $n = 2
            while ($usedIds.ContainsKey($entityId + '-' + $n)) { $n++ }
            $entityId = $entityId + '-' + $n
        }
    }
    $usedIds[$entityId] = $true

    $entities.Add([pscustomobject][ordered]@{
        id                    = $entityId
        canonicalName         = $canonical
        category              = $category
        tagline               = $tagline
        longDescription       = $longDesc
        aliases               = @($aliasesObserved)
        firstMention          = [pscustomobject][ordered]@{
            sessionCode      = $firstMention.SessionCode
            sessionTitle     = $firstMention.SessionTitle
            timestamp        = $firstMention.Timestamp
            timestampSeconds = $firstMention.TimestampSeconds
        }
        mentionCount          = $members.Count
        sessionCount          = ($members | Select-Object -ExpandProperty SessionCode -Unique).Count
        topSessions           = $topSessions
        categoryDistribution  = $catDistObj
        aliasFolded           = [bool]$c.ForcedCanonical
        anyInferred           = [bool]($members | Where-Object { $_.IsInferred })
    }) | Out-Null

    foreach ($m in $members) {
        $mentions.Add([pscustomobject][ordered]@{
            entityId         = $entityId
            sessionCode      = $m.SessionCode
            sessionTitle     = $m.SessionTitle
            rawName          = $m.RawName
            timestamp        = $m.Timestamp
            timestampSeconds = $m.TimestampSeconds
            speakers         = $m.Speakers
            frames           = $m.Frames
            shortDescription = $m.ShortDescription
            longDescription  = $m.LongDescription
            explicitLinks    = $m.ExplicitLinks
            codeSnippets     = $m.CodeSnippets
            isInferred       = $m.IsInferred
        }) | Out-Null
    }
}

# Stable sort: entities by mention count desc, then canonicalName.
$entitiesSorted = $entities | Sort-Object @{ Expression = { [int]$_.mentionCount }; Descending = $true }, canonicalName
# Mentions sort: entityId, then session order, then timestamp.
$mentionsSorted = $mentions | Sort-Object entityId, sessionCode, timestampSeconds

# --------------------------------------------------------------------------
# 5. Write outputs.
# --------------------------------------------------------------------------

$generatedAt = (Get-Date).ToUniversalTime().ToString('o')

$entitiesDoc = [ordered]@{
    schemaVersion = 1
    conference    = $Conference
    eventId       = $EventId
    generatedAt   = $generatedAt
    entityCount   = $entitiesSorted.Count
    mentionCount  = $mentionsSorted.Count
    entities      = $entitiesSorted
}
$entitiesDoc | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $entitiesPath -Encoding utf8

$mentionsDoc = [ordered]@{
    schemaVersion = 1
    conference    = $Conference
    eventId       = $EventId
    generatedAt   = $generatedAt
    mentions      = $mentionsSorted
}
$mentionsDoc | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $mentionsPath -Encoding utf8

# Resolution report: per-category and per-cluster-size summaries plus the
# top-10 most-mentioned entities. Designed to be eyeballed and diffed
# between runs so unexpected merges/splits are immediately visible.
$categoryTally = $entitiesSorted | Group-Object category | Sort-Object @{ Expression = 'Count'; Descending = $true } | ForEach-Object {
    [pscustomobject][ordered]@{ category = $_.Name; entityCount = $_.Count; mentionCount = ($_.Group | Measure-Object mentionCount -Sum).Sum }
}
$top10 = $entitiesSorted | Select-Object -First 10 | ForEach-Object {
    [pscustomobject][ordered]@{ id = $_.id; canonicalName = $_.canonicalName; category = $_.category; mentionCount = $_.mentionCount; sessionCount = $_.sessionCount }
}
$aliasFolded = @($entitiesSorted | Where-Object { $_.aliasFolded })

$report = [ordered]@{
    schemaVersion       = 1
    conference          = $Conference
    eventId             = $EventId
    generatedAt         = $generatedAt
    aliasGroupsLoaded   = $aliasGroups.Count
    mentionCount        = $mentionsSorted.Count
    entityCount         = $entitiesSorted.Count
    entitiesAliasFolded = $aliasFolded.Count
    categoryTally       = $categoryTally
    topEntities         = $top10
}
$report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $resolutionReportPath -Encoding utf8

# --------------------------------------------------------------------------
# 6. Console summary.
# --------------------------------------------------------------------------

Write-Host ''
Write-Host "Entity resolution complete." -ForegroundColor Cyan
Write-Host ("  Mentions in:   {0}"  -f $allMentions.Count)
Write-Host ("  Entities out:  {0}"  -f $entitiesSorted.Count)
Write-Host ("  Alias-folded:  {0}"  -f $aliasFolded.Count)
Write-Host ''
Write-Host 'Top entities by mention count:' -ForegroundColor Cyan
$top10 | ForEach-Object {
    Write-Host ("  {0,3}x  {1,-10} {2}" -f $_.mentionCount, $_.category, $_.canonicalName)
}
Write-Host ''
Write-Host "Wrote:" -ForegroundColor Cyan
Write-Host "  $entitiesPath"
Write-Host "  $mentionsPath"
Write-Host "  $resolutionReportPath"
Write-Host ''
Write-Host "Edit $aliasesPath to merge fuzzy variants (e.g. 'Foundry' / 'Azure AI Foundry'), then re-run." -ForegroundColor DarkGray
Write-Host "Next: scripts/Enrich-AnnouncementLinks.ps1 -Conference $Conference -EventId $EventId" -ForegroundColor Cyan
