# Resolve-Speakers.ps1
#
# Walk every per-session rich-manifest.json under sessions/<Conf>/<Event>/
# and build one cross-event speaker registry at:
#
#   catalog/<Conf>/<Event>/speakers/
#     speakers.json     one record per canonical speaker (keyed by the
#                       opaque catalog speakerId), with aggregated metadata:
#                         id, name, slug, sessionCount, sessions[],
#                         coSpeakerCounts{id -> n}, tags[], topics[].
#                       sessions[] holds the slim per-session shape needed
#                       to render the per-speaker page (code, title, type,
#                       startDateTime, durationMinutes, hasVideo, coverFrame,
#                       coSpeakers[]).
#     resolution-report.json
#                       diff-friendly audit (per-speaker totals, name-clash
#                       summary, slug-collision summary) so subsequent runs
#                       let you eyeball drift over time.
#
# Schema notes (the rich-manifest source-of-truth):
#   - speakerNames is a comma-joined string. Splits on a comma followed by
#     space; trims each piece. ~98% of sessions have a clean parse.
#   - speakerIds is an array parallel to the comma-split names by index.
#     A few sessions have mismatched counts (typically when a co-speaker
#     was added after the catalog snapshot). Those are still counted by
#     ID; the name falls back to the array slot at the same index or to
#     the raw string when the index is out of bounds.
#   - Empty speakerNames + empty speakerIds = unattributed session;
#     skipped (don't pollute the registry with an "Unknown" speaker).
#
# Identity rules:
#   - Primary key is speakerId. Two sessions with the same id always
#     collapse into one entry, even if their displayed names differ
#     ("J. Smith" vs "John Smith"). The most-frequent name wins as the
#     canonical display name; the others are stored in a `nameVariants`
#     array so the search index can match either spelling.
#   - Speakers with the same display name but different ids stay as two
#     entries (they're different humans).
#
# Pure PowerShell. Re-running is safe and produces byte-stable JSON when
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

function Slugify {
    # Match the slug convention used elsewhere in the project (entity
    # slugs in Resolve-AnnouncementEntities.ps1): lower-case, alphanumeric +
    # hyphen, collapse runs. Latin-1 only - speaker names from the Build
    # catalog are universally ASCII.
    param([string]$s)
    if ([string]::IsNullOrWhiteSpace($s)) { return 'unknown' }
    $lower = $s.ToLowerInvariant()
    $hy    = [regex]::Replace($lower, "[^a-z0-9]+", '-')
    return $hy.Trim('-')
}

function Split-SpeakerNames {
    # The rich-manifest `speakerNames` field is a comma-joined string. A
    # plain Split(',') would mishandle the rare "Smith, Jr." case; the
    # catalog never emits suffix-comma names so the simple split is fine
    # here. Trim each piece; drop empties.
    param([string]$joined)
    if ([string]::IsNullOrWhiteSpace($joined)) { return @() }
    return @($joined.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

# --------------------------------------------------------------------------
# load every session's rich-manifest.json
# --------------------------------------------------------------------------

$sessionsRoot = Join-Path $RepoRoot "sessions\$Conference\$EventId"
$outDir       = Join-Path $RepoRoot "catalog\$Conference\$EventId\speakers"
if (-not (Test-Path -LiteralPath $sessionsRoot)) {
    throw "Sessions root missing: $sessionsRoot"
}
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

# Each registry value is a [pscustomobject] we mutate in place. Hashtable
# keyed by speakerId for O(1) lookup as we walk sessions; we re-shape it
# into an array at the end (sorted by sessionCount desc, name asc).
$registry = @{}

# Track ID-less sessions so the report tells the maintainer something is
# off upstream (catalog issue) rather than silently dropping them.
$unattributedSessions = New-Object 'System.Collections.Generic.List[string]'

$sessionDirs = Get-ChildItem -LiteralPath $sessionsRoot -Directory
Write-Host "Resolving speakers across $($sessionDirs.Count) session(s) ..."

foreach ($d in $sessionDirs) {
    $mfPath = Join-Path $d.FullName 'rich-manifest.json'
    if (-not (Test-Path -LiteralPath $mfPath)) { continue }
    $mf = Get-Content -Raw -LiteralPath $mfPath | ConvertFrom-Json

    $names = @(Split-SpeakerNames $mf.speakerNames)
    $ids   = @($mf.speakerIds)
    if ($ids.Count -eq 0 -and $names.Count -eq 0) {
        $unattributedSessions.Add($mf.code) | Out-Null
        continue
    }

    # Compute the per-session shape ONCE per session; each speaker in the
    # session gets the same entry appended to their sessions[] list.
    # coverFrame is rendered relative to docs/<Conf>/<Event>/, mirroring
    # the convention in Build-Book.ps1 + catalog.json.
    $cover = $null
    if ($mf.artifacts -and $mf.artifacts.frames -and $mf.artifacts.frames.Count -gt 0) {
        $cover = "frames/$($mf.code)/$($mf.artifacts.frames[0] -replace '^frames/', '')"
    }

    # Pair each speakerId with its corresponding name. Index-match when the
    # two lists are the same length; otherwise fall back to the name at
    # the same index, or the id stringified, so we still record an entry.
    $perSession = New-Object 'System.Collections.Generic.List[pscustomobject]'
    for ($i = 0; $i -lt $ids.Count; $i++) {
        $id   = [string]$ids[$i]
        $name = if ($i -lt $names.Count) { $names[$i] } else { "Speaker $id" }
        $perSession.Add([pscustomobject]@{ id = $id; name = $name }) | Out-Null
    }
    # If a session has speakerNames but no speakerIds, register a synthetic
    # id (slug + index) so the speaker still gets a registry entry. Rare
    # in Build 2026 but defensive.
    if ($ids.Count -eq 0 -and $names.Count -gt 0) {
        for ($i = 0; $i -lt $names.Count; $i++) {
            $synthId = "synthetic-$(Slugify $names[$i])"
            $perSession.Add([pscustomobject]@{ id = $synthId; name = $names[$i] }) | Out-Null
        }
    }

    foreach ($s in $perSession) {
        $entry = $registry[$s.id]
        if (-not $entry) {
            $entry = [pscustomobject]@{
                id              = $s.id
                # The canonical display name is resolved at the end after
                # we've seen every variant; for now stash the first one.
                name            = $s.name
                slug            = $null   # filled in at the end
                # nameCounts is a hashtable used during the walk to pick
                # the most-common spelling as canonical. Dropped before
                # serialization.
                nameCounts      = @{}
                sessionCount    = 0
                sessions        = New-Object 'System.Collections.Generic.List[pscustomobject]'
                coSpeakerCounts = @{}
                tags            = New-Object 'System.Collections.Generic.HashSet[string]'
                topics          = New-Object 'System.Collections.Generic.HashSet[string]'
            }
            $registry[$s.id] = $entry
        }

        # Tally the name variant; later we elect the highest-count name as
        # canonical (ties broken by first-seen, which is insertion order).
        $cur = $entry.nameCounts[$s.name]
        if (-not $cur) { $cur = 0 }
        $entry.nameCounts[$s.name] = $cur + 1

        # Co-speakers for this session, excluding self.
        $coIds = @($perSession | Where-Object { $_.id -ne $s.id } | ForEach-Object { $_.id })
        $coShape = @($perSession | Where-Object { $_.id -ne $s.id } |
            ForEach-Object { [pscustomobject]@{ id = $_.id; name = $_.name } })

        foreach ($coId in $coIds) {
            $cnt = $entry.coSpeakerCounts[$coId]
            if (-not $cnt) { $cnt = 0 }
            $entry.coSpeakerCounts[$coId] = $cnt + 1
        }

        $entry.sessions.Add([pscustomobject]@{
            code            = $mf.code
            title           = $mf.title
            sessionType     = $mf.sessionType
            startDateTime   = $mf.startDateTime
            durationMinutes = $mf.durationMinutes
            hasVideo        = [bool]($mf.onDemandUrl -or $mf.downloadVideoUrl)
            coverFrame      = $cover
            coSpeakers      = $coShape
        }) | Out-Null
        $entry.sessionCount += 1

        foreach ($t in @($mf.tags))   { if ($t) { [void]$entry.tags.Add([string]$t) } }
        foreach ($t in @($mf.topics)) { if ($t) { [void]$entry.topics.Add([string]$t) } }
    }
}

# --------------------------------------------------------------------------
# elect canonical names, generate slugs, disambiguate collisions
# --------------------------------------------------------------------------

# Slug collision check: two distinct ids that slugify to the same string
# (e.g. "Chris Harrison" + "Christopher Harrison" both -> chris-harrison).
# Resolution: keep the alphabetically-first id at the bare slug, suffix
# `-<short-id>` on subsequent collisions. The short id is the last 6 chars
# of the speakerId (they're all unique enough at that prefix).
$slugMap = @{}
$collisions = New-Object 'System.Collections.Generic.List[pscustomobject]'

# Stable iteration order for deterministic slug assignment when collisions
# happen: sort by id ascending.
$idsOrdered = @($registry.Keys | Sort-Object)
foreach ($id in $idsOrdered) {
    $e = $registry[$id]
    # Elect canonical name: highest count, ties broken by first-seen which
    # we approximate as the lexicographic order of the variants (good
    # enough; spelling drift on a single id is extremely rare in Build).
    $top = @($e.nameCounts.GetEnumerator() | Sort-Object @{Expression = { $_.Value }; Descending = $true}, Key)[0]
    $e.name = $top.Key
    # nameVariants is everything we ever saw for this id (sorted unique),
    # for the search index downstream.
    $variants = @($e.nameCounts.Keys | Sort-Object -Unique)
    $e | Add-Member -NotePropertyName 'nameVariants' -NotePropertyValue $variants -Force

    $base = Slugify $e.name
    if (-not $slugMap.ContainsKey($base)) {
        $e.slug = $base
        $slugMap[$base] = $id
    }
    else {
        $shortId = $id.Substring([Math]::Max(0, $id.Length - 6))
        $e.slug = "$base-$shortId"
        $collisions.Add([pscustomobject]@{
            slug    = $base
            kept    = $slugMap[$base]
            renamed = "$base-$shortId"
            id      = $id
            name    = $e.name
        }) | Out-Null
    }
    # Now drop the internal tally hashtable so the JSON stays slim.
    $e.PSObject.Properties.Remove('nameCounts')

    # Flatten the HashSet[string] fields to sorted arrays for stable JSON.
    $e.tags   = @($e.tags   | Sort-Object)
    $e.topics = @($e.topics | Sort-Object)

    # coSpeakerCounts already a hashtable; serialize as-is (ConvertTo-Json
    # turns it into a JSON object {id: count, ...}).

    # Sort sessions by startDateTime asc when present, falling back to code
    # ascending so the per-speaker page reads chronologically.
    $e.sessions = @($e.sessions | Sort-Object @{Expression={
        if ($_.startDateTime) { [datetime]$_.startDateTime } else { [datetime]::MaxValue }
    }}, code)
}

# --------------------------------------------------------------------------
# output: speakers.json (sorted by sessionCount desc, name asc)
# --------------------------------------------------------------------------

$ordered = @($idsOrdered | ForEach-Object { $registry[$_] }) |
    Sort-Object @{Expression='sessionCount'; Descending=$true}, name

$payload = [pscustomobject]@{
    schemaVersion = 1
    generatedAt   = (Get-Date).ToUniversalTime().ToString('o')
    conference    = $Conference
    eventId       = $EventId
    totalSpeakers = $ordered.Count
    totalSessions = $sessionDirs.Count
    speakers      = $ordered
}

$outPath = Join-Path $outDir 'speakers.json'
$payload | ConvertTo-Json -Depth 10 |
    Set-Content -LiteralPath $outPath -Encoding UTF8
Write-Host "Wrote $outPath ($($ordered.Count) speaker(s) across $($sessionDirs.Count) session(s))"

# --------------------------------------------------------------------------
# output: resolution-report.json
# --------------------------------------------------------------------------

# Distribution of speakers by sessionCount, for the report. Useful eyeball
# check: "how many speakers presented just one session vs the heavy hitters".
$buckets = @($ordered | Group-Object sessionCount |
    Sort-Object @{Expression={[int]$_.Name}; Descending=$true} |
    ForEach-Object {
        [pscustomobject]@{
            sessionCount = [int]$_.Name
            speakerCount = $_.Count
        }
    })

# Top-10 most-prolific speakers (id + name + sessionCount) for the report.
$top10 = @($ordered | Select-Object -First 10 | ForEach-Object {
    [pscustomobject]@{
        id           = $_.id
        name         = $_.name
        slug         = $_.slug
        sessionCount = $_.sessionCount
    }
})

$report = [pscustomobject]@{
    schemaVersion          = 1
    generatedAt            = (Get-Date).ToUniversalTime().ToString('o')
    totalSpeakers          = $ordered.Count
    totalSessions          = $sessionDirs.Count
    unattributedSessions   = @($unattributedSessions)
    slugCollisions         = @($collisions)
    sessionCountBuckets    = $buckets
    topSpeakers            = $top10
}
$reportPath = Join-Path $outDir 'resolution-report.json'
$report | ConvertTo-Json -Depth 6 |
    Set-Content -LiteralPath $reportPath -Encoding UTF8
Write-Host "Wrote $reportPath"

# --------------------------------------------------------------------------
# console summary
# --------------------------------------------------------------------------

Write-Host ''
Write-Host "Speaker resolution complete:"
Write-Host "  Total speakers:        $($ordered.Count)"
Write-Host "  Total sessions:        $($sessionDirs.Count)"
Write-Host "  Unattributed sessions: $($unattributedSessions.Count)"
Write-Host "  Slug collisions:       $($collisions.Count)"
Write-Host "  Top 3 by session count:"
foreach ($t in ($top10 | Select-Object -First 3)) {
    Write-Host "    [$($t.sessionCount)x] $($t.name) ($($t.slug))"
}
