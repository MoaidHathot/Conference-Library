# Build-Book.ps1
#
# Render the static Conference Library HTML site from the ingested artifacts.
# Walks sessions/<Conference>/<EventId>/<CODE>/ and produces
# docs/<Conference>/<EventId>/ with:
#   index.html                — searchable/filterable session catalog
#   sessions/<CODE>.html      — per-session page (summary, frames, transcript)
#   assets/                   — vendored CSS / JS / Lunr.js (copy of templates/)
#   catalog.json              — slim per-session metadata for the index page JS
#   search-index.json         — pre-built Lunr index (Lunr 2.x JSON format)
#   frames/<CODE>/*.jpg       — copies of session frames (page is self-contained)
#
# Also (re)writes two landing pages so the GitHub Pages root URL works as a
# multi-conference / multi-year directory:
#   docs/index.html                  — lists every conference under docs/<Conf>/
#   docs/<Conference>/index.html     — lists every year under docs/<Conf>/<year>/
#
# No build step. Pure PowerShell + string-template substitution. Re-runnable;
# overwrites docs/<Conference>/<EventId>/ on each invocation. Idempotent w.r.t.
# content.
[CmdletBinding()]
param(
    # Conference identifier used as the first-level directory under catalog/,
    # sessions/, and docs/. Defaults to 'Build' (Microsoft Build) since that's
    # the only conference with an adapter today.
    [Parameter()][string]$Conference = 'Build',

    [Parameter()][string]$EventId = '2026',

    # Where the generated per-event site lands. Defaults to
    # <RepoRoot>/docs/<Conference>/<EventId>. Override for ad-hoc previews.
    [Parameter()][string]$OutputRoot,

    # Skip the per-frame copy step (useful when iterating on styles; the
    # session pages will 404 on frame images but build much faster).
    [Parameter()][switch]$NoFrames,

    [Parameter()][string]$RepoRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

if (-not $OutputRoot) {
    $OutputRoot = Join-Path $RepoRoot "docs\$Conference\$EventId"
}
$docsRoot       = Join-Path $RepoRoot 'docs'
$conferenceRoot = Join-Path $docsRoot $Conference

$sessionsRoot   = Join-Path $RepoRoot "sessions\$Conference\$EventId"
$templatesRoot  = Join-Path $RepoRoot 'templates\site'
if (-not (Test-Path -LiteralPath $sessionsRoot))  { throw "Sessions root missing: $sessionsRoot" }
if (-not (Test-Path -LiteralPath $templatesRoot)) { throw "Templates root missing: $templatesRoot" }

# ---- read templates ----

$layoutTpl       = Get-Content -Raw -LiteralPath (Join-Path $templatesRoot 'layout.html')
$indexBody       = Get-Content -Raw -LiteralPath (Join-Path $templatesRoot 'index.body.html')
$sessionBody     = Get-Content -Raw -LiteralPath (Join-Path $templatesRoot 'session.body.html')
$annLandingBody  = if (Test-Path -LiteralPath (Join-Path $templatesRoot 'announcements.body.html')) {
    Get-Content -Raw -LiteralPath (Join-Path $templatesRoot 'announcements.body.html')
} else { $null }
$entityBody      = if (Test-Path -LiteralPath (Join-Path $templatesRoot 'entity.body.html')) {
    Get-Content -Raw -LiteralPath (Join-Path $templatesRoot 'entity.body.html')
} else { $null }

# ---- helpers ----

function HtmlEncode {
    param([string]$Text)
    if ($null -eq $Text) { return '' }
    return [System.Net.WebUtility]::HtmlEncode($Text)
}

function Render-Template {
    # Simple {{TOKEN}} replacement. Tokens are case-sensitive; missing values
    # become empty strings rather than literal "{{TOKEN}}".
    param([string]$Template, [hashtable]$Values)
    $rendered = $Template
    # Replace known tokens first.
    foreach ($k in $Values.Keys) {
        $needle = '{{' + $k + '}}'
        $rendered = $rendered.Replace($needle, [string]$Values[$k])
    }
    # Then strip any unmatched tokens so the page doesn't show "{{FOO}}".
    $rendered = [regex]::Replace($rendered, '\{\{[A-Z_]+\}\}', '')
    return $rendered
}

function Tag-Cloud {
    param([string[]]$Tags, [int]$Max = 99)
    if (-not $Tags -or $Tags.Count -eq 0) { return '' }
    $sb = [System.Text.StringBuilder]::new()
    $i = 0
    foreach ($t in $Tags) {
        if ([string]::IsNullOrWhiteSpace($t)) { continue }
        if (++$i -gt $Max) { break }
        [void]$sb.Append('<span class="tag">' + (HtmlEncode $t) + '</span> ')
    }
    return $sb.ToString().TrimEnd()
}

function Render-MarkdownLite {
    # Strict-format summary from Copilot uses a small Markdown subset; render
    # it inline. We DO NOT use a full Markdown library to keep this script
    # dependency-free. Coverage:
    #   - ATX headings (# .. ######)
    #   - blockquotes (>)
    #   - bullet lists (- or *)
    #   - bold (**...**), italic (*...*), inline code (`...`)
    #   - links [text](url) — bare URLs are NOT auto-linked
    # Anything more exotic in the summary falls through as a <p> with inline
    # rules applied. Good enough for our strict-format summaries.
    param([string]$Markdown)
    if ([string]::IsNullOrWhiteSpace($Markdown)) { return '' }
    # Strip leading HTML comments (we put a provenance header at the top).
    $md = [regex]::Replace($Markdown, '(?s)^<!--.*?-->\s*', '')

    $lines  = $md -split "`r?`n"
    $html   = [System.Text.StringBuilder]::new()
    $inList = $false
    $inQuote = $false

    foreach ($raw in $lines) {
        $line = $raw.TrimEnd()
        if ([string]::IsNullOrWhiteSpace($line)) {
            if ($inList)  { [void]$html.AppendLine('</ul>'); $inList  = $false }
            if ($inQuote) { [void]$html.AppendLine('</blockquote>'); $inQuote = $false }
            continue
        }
        if ($line -match '^(#{1,6})\s+(.*)$') {
            if ($inList)  { [void]$html.AppendLine('</ul>'); $inList  = $false }
            if ($inQuote) { [void]$html.AppendLine('</blockquote>'); $inQuote = $false }
            $level = $Matches[1].Length
            $text  = Render-MarkdownInline $Matches[2]
            [void]$html.AppendLine("<h$level>$text</h$level>")
            continue
        }
        if ($line -match '^\s*[-*]\s+(.*)$') {
            if ($inQuote) { [void]$html.AppendLine('</blockquote>'); $inQuote = $false }
            if (-not $inList) { [void]$html.AppendLine('<ul>'); $inList = $true }
            [void]$html.AppendLine('<li>' + (Render-MarkdownInline $Matches[1]) + '</li>')
            continue
        }
        if ($line -match '^\s*>\s?(.*)$') {
            if ($inList) { [void]$html.AppendLine('</ul>'); $inList = $false }
            if (-not $inQuote) { [void]$html.AppendLine('<blockquote>'); $inQuote = $true }
            [void]$html.AppendLine('<p>' + (Render-MarkdownInline $Matches[1]) + '</p>')
            continue
        }
        if ($inList)  { [void]$html.AppendLine('</ul>'); $inList  = $false }
        if ($inQuote) { [void]$html.AppendLine('</blockquote>'); $inQuote = $false }
        [void]$html.AppendLine('<p>' + (Render-MarkdownInline $line) + '</p>')
    }
    if ($inList)  { [void]$html.AppendLine('</ul>') }
    if ($inQuote) { [void]$html.AppendLine('</blockquote>') }
    return $html.ToString()
}

function Render-MarkdownInline {
    param([string]$Text)
    $t = HtmlEncode $Text
    # Code spans first so other rules don't touch their contents.
    $t = [regex]::Replace($t, '`([^`]+)`', '<code>$1</code>')
    # Links [label](url) — only http/https/anchor/relative.
    $t = [regex]::Replace($t, '\[([^\]]+)\]\(([^)\s]+)\)',
        { param($m) '<a href="' + $m.Groups[2].Value + '">' + $m.Groups[1].Value + '</a>' })
    # Bold then italic (order matters; ** before *).
    $t = [regex]::Replace($t, '\*\*([^*]+)\*\*', '<strong>$1</strong>')
    $t = [regex]::Replace($t, '(?<!\*)\*([^*]+)\*(?!\*)', '<em>$1</em>')
    return $t
}

function Inject-AnnouncementFrames {
    # Post-process rendered summary HTML to insert a frame strip after each
    # HH:MM:SS timestamp marker. Matches bare timestamps regardless of
    # surrounding punctuation - summaries use a mix of [HH:MM:SS],
    # (HH:MM:SS), (~HH:MM:SS), and bare-in-prose forms; we wrap just the
    # digits and preserve the original brackets/parens unchanged.
    #
    # In addition to the existing hover/click-to-toggle frames strip, each
    # timestamp now also gets a small inline play button (.ts-play) bearing
    # the timestamp as data-ts. session.js binds this to: scroll the session
    # video into view, seek it to ts - 5s, then call .play(). Works for both
    # the MP4 and hls.js video paths (same <video class="session-video">
    # element across both). The button shows for ALL sessions including ones
    # without a video; the JS handler no-ops gracefully when no <video> is
    # present (it logs an aria-live hint instead).
    #
    # When $EntityByTimestamp has a record for this timestamp (i.e. this
    # bullet was extracted as a key announcement that resolved to a canonical
    # entity), a third inline control - .ts-open-entity - is appended after
    # the play button. It's a real <a> (no JS) that links to the per-entity
    # announcement page; right-click / middle-click open in a new tab as
    # expected. Renders only when the lookup hits, so non-announcement
    # timestamps elsewhere in the summary stay untouched.
    #
    # The strip shows whatever frames the Get-AnnouncementFrames.ps1 helper
    # has captured in
    #   <sessionDir>/announcement-frames/<HH-MM-SS>/frame-<offset>s.jpg
    # Missing frames are silently omitted; missing timestamps render
    # unchanged.
    param(
        [string]$Html,
        [string]$SessionDir,
        [string]$Code,
        # Optional: timestamp ("HH:MM:SS") -> pscustomobject @{ Slug, Name, Category }.
        # When a key match exists, the inline jump-to-entity link is emitted
        # after the play button. Pass $null or @{} to disable.
        $EntityByTimestamp = $null
    )
    if (-not $Html) { return $Html }
    $afRoot = Join-Path $SessionDir 'announcement-frames'
    return [regex]::Replace($Html, '(?<![\d:])(\d{2}:\d{2}:\d{2})(?![\d:])', {
        param($m)
        $ts = $m.Groups[1].Value
        # The play button always appears, even when no frames are on disk for
        # this timestamp - it's wired to the player, not the frames strip.
        $playBtn = "<button type=`"button`" class=`"ts-play`" data-ts=`"$ts`" " +
                   "title=`"Watch from $ts (-5s)`" aria-label=`"Watch the video from $ts minus 5 seconds`">" +
                   "<span aria-hidden=`"true`">&#9654;</span></button>"
        # Entity-jump link: appears only when this timestamp resolves to a
        # canonical entity for the current session. Catalog comes pre-joined
        # from mentions.json by the caller.
        $jumpLink = ''
        if ($EntityByTimestamp -and $EntityByTimestamp.ContainsKey($ts)) {
            $ent = $EntityByTimestamp[$ts]
            $hrefRel = "../announcements/$([System.Net.WebUtility]::HtmlEncode($ent.Slug)).html"
            $titleAttr = "Open announcement page: $([System.Net.WebUtility]::HtmlEncode($ent.Name))"
            $aria = "Open the announcement page for $([System.Net.WebUtility]::HtmlEncode($ent.Name))"
            $jumpLink = "<a class=`"ts-open-entity`" href=`"$hrefRel`" title=`"$titleAttr`" aria-label=`"$aria`">" +
                        "<span aria-hidden=`"true`">&#x2197;</span></a>"
        }
        $folder = $ts -replace ':', '-'
        $folderPath = Join-Path $afRoot $folder
        # No frames on disk for this timestamp - just emit the timestamp + play button (+ optional jump),
        # no anchor wrapper or strip.
        if (-not (Test-Path -LiteralPath $folderPath)) {
            return "<span class=`"ts`">$($m.Value)$playBtn$jumpLink</span>"
        }
        $imgs = Get-ChildItem -LiteralPath $folderPath -File -Filter '*.jpg' -ErrorAction SilentlyContinue |
                Sort-Object Name
        if ($imgs.Count -eq 0) {
            return "<span class=`"ts`">$($m.Value)$playBtn$jumpLink</span>"
        }
        $cells = foreach ($img in $imgs) {
            $rel = "../frames/$Code/announcement-frames/$folder/$($img.Name)"
            $offset = if ($img.BaseName -match 'frame-(.+)$') { $Matches[1] } else { '' }
            "<a class=`"af-cell`" href=`"$rel`" data-zoom=`"1`" title=`"$ts $offset`">" +
                "<img loading=`"lazy`" src=`"$rel`" alt=`"Frame at $ts $offset`">" +
                "<span class=`"af-cap`">$offset</span>" +
            "</a>"
        }
        $body = $cells -join ''
        # Wrap timestamp in a span; CSS makes the strip pop out below via
        # position:absolute, so it visually attaches to the timestamp
        # without breaking the surrounding <li>/<p>. role=button + tabindex
        # make it keyboard-focusable; session.js binds Enter/Space to toggle.
        # The play button + jump link sit OUTSIDE the anchor so their click
        # events don't bubble through the anchor's strip-toggle handler.
        return "<span class=`"anchor`" role=`"button`" tabindex=`"0`" aria-haspopup=`"true`">$($m.Value)" +
               "<span class=`"af-strip`">$body</span>" +
               "</span>" + $playBtn + $jumpLink
    })
}

function Build-LunrIndex {
    # Build a Lunr 2.x serialized index. Lunr.js is a JS library; we invoke
    # `node` if it's on PATH and feed it the prebuild snippet. If node is
    # missing we fall back to writing a "documents only" placeholder that
    # the page-side JS detects and degrades to substring search.
    #
    # $Fields is an ordered hashtable mapping field-name -> boost (or $null
    # for the default boost of 1). The default value matches the original
    # session search-index schema for backward compatibility.
    param(
        $Documents,          # array/list whose objects have at least the keys in $Fields plus 'ref'
        [string]$OutputPath,
        $Fields = [ordered]@{
            title    = 12
            code     = 10
            speakers = 6
            tags     = 4
            topics   = 4
            body     = $null
        }
    )

    $node = (Get-Command node -ErrorAction SilentlyContinue)?.Source
    $vendorLunr = Join-Path $templatesRoot 'assets\lunr.min.js'
    if (-not $node) {
        Write-Warning "node not found on PATH; writing a fallback search index (the page falls back to substring match)."
        @{
            __fallback = $true
            documents = $Documents
        } | ConvertTo-Json -Depth 6 -Compress | Set-Content -LiteralPath $OutputPath -Encoding utf8
        return
    }

    # Stage the inputs in a temp dir so node sees them via file paths.
    $stage = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'book-of-build-' + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $stage -Force | Out-Null
    try {
        $docsPath = Join-Path $stage 'docs.json'
        $script   = Join-Path $stage 'build.js'
        # IMPORTANT: -InputObject + a List/array already serializes as a JSON
        # array. Combining it with -AsArray double-wraps to [[...]] and the
        # node script iterates exactly once with d = (the inner array), so
        # every document's ref/title/etc. read as undefined and Lunr ends up
        # with a useless "field/undefined" index. Pipe through a single
        # ConvertTo-Json without -AsArray.
        ConvertTo-Json -InputObject $Documents -Depth 6 -Compress |
            Set-Content -LiteralPath $docsPath -Encoding utf8

        # Build the per-field this.field(...) lines from the Fields hashtable.
        $fieldLines = foreach ($k in $Fields.Keys) {
            $boost = $Fields[$k]
            if ($null -ne $boost) {
                "  this.field('$k', { boost: $boost });"
            } else {
                "  this.field('$k');"
            }
        }
        $fieldBlock = $fieldLines -join "`n"

        # Inline node build script. Loads vendored Lunr from the absolute
        # path, ingests docs.json, writes the serialised index DIRECTLY to
        # OutputPath via fs.writeFileSync.
        #
        # IMPORTANT: we deliberately do NOT pipe node's stdout back through
        # PowerShell. On Windows, [Console]::OutputEncoding defaults to the
        # OEM code page (CP437/CP850), which mis-decodes UTF-8 multi-byte
        # sequences in JSON values (e.g. U+2011 'NON-BREAKING HYPHEN' becomes
        # 'Γ Ç æ' = bytes CE 93 C3 87 C3 A6 after the round trip). The
        # corrupted output then breaks Lunr's "tokens must be sorted"
        # invariant on load, throwing "Out of order word insertion" in the
        # browser. Writing the file from node keeps the bytes intact.
        $js = @"
const lunr = require('$($vendorLunr.Replace('\','\\'))');
const fs = require('fs');
const docs = JSON.parse(fs.readFileSync('$($docsPath.Replace('\','\\'))', 'utf8'));
const idx = lunr(function () {
  this.ref('ref');
$fieldBlock
  docs.forEach(d => this.add(d));
});
fs.writeFileSync('$($OutputPath.Replace('\','\\'))', JSON.stringify(idx), 'utf8');
"@
        Set-Content -LiteralPath $script -Value $js -Encoding utf8
        $stderr = & $node $script 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Lunr build via node failed (exit $LASTEXITCODE); writing fallback index. stderr:`n$stderr"
            @{ __fallback = $true; documents = $Documents } | ConvertTo-Json -Depth 6 -Compress |
                Set-Content -LiteralPath $OutputPath -Encoding utf8
            return
        }
    }
    finally {
        Remove-Item -LiteralPath $stage -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# --------------------------------------------------------------------------
# Announcements: load + helpers (Step 3 output: entities-enriched.json,
# Step 2 output: mentions.json). All three are optional - if they aren't
# present the renderer silently skips the announcements landing, per-entity
# pages, and the per-session sidebar. Existing per-session render keeps
# working unchanged.
# --------------------------------------------------------------------------

$annCatalogRoot     = Join-Path $RepoRoot "catalog\$Conference\$EventId\announcements"
$entitiesEnrichedPath = Join-Path $annCatalogRoot 'entities-enriched.json'
$mentionsJsonPath     = Join-Path $annCatalogRoot 'mentions.json'

$annEntities         = @()
$annMentions         = @()
$annMentionsBySession = @{}
$annMentionsByEntity  = @{}
$annEnabled = $false
if ((Test-Path -LiteralPath $entitiesEnrichedPath) -and
    (Test-Path -LiteralPath $mentionsJsonPath) -and
    $annLandingBody -and $entityBody) {
    try {
        $annEntities = @((Get-Content -Raw -LiteralPath $entitiesEnrichedPath | ConvertFrom-Json -Depth 20).entities)
        $annMentions = @((Get-Content -Raw -LiteralPath $mentionsJsonPath     | ConvertFrom-Json -Depth 20).mentions)
        foreach ($m in $annMentions) {
            if (-not $annMentionsBySession.ContainsKey($m.sessionCode)) {
                $annMentionsBySession[$m.sessionCode] = New-Object 'System.Collections.Generic.List[object]'
            }
            $annMentionsBySession[$m.sessionCode].Add($m) | Out-Null
            if (-not $annMentionsByEntity.ContainsKey($m.entityId)) {
                $annMentionsByEntity[$m.entityId] = New-Object 'System.Collections.Generic.List[object]'
            }
            $annMentionsByEntity[$m.entityId].Add($m) | Out-Null
        }
        $annEnabled = ($annEntities.Count -gt 0)
        Write-Host "Announcements view enabled: $($annEntities.Count) entit(ies), $($annMentions.Count) mention(s)." -ForegroundColor DarkGray
    } catch {
        Write-Warning "Failed to load announcements artifacts ($_); skipping announcements view."
        $annEnabled = $false
    }
} else {
    Write-Host "Announcements view disabled (missing entities-enriched.json/mentions.json/templates)." -ForegroundColor DarkGray
}

# CategorySlug: the fixed taxonomy uses lowercase except for 'SDK'. The CSS
# selector .entity-cat-<slug> matches this exact form.
function CategorySlug { param([string]$c) if ($c -eq 'SDK') { 'SDK' } else { ($c ?? '').ToLowerInvariant() } }

# CategoryLabel: human-readable category name for chips and headers.
function CategoryLabel {
    param([string]$c)
    if ([string]::IsNullOrWhiteSpace($c)) { return '' }
    if ($c -eq 'SDK') { return 'SDK' }
    return ([char]::ToUpperInvariant($c[0]) + $c.Substring(1).ToLowerInvariant())
}

# EntitySlug: filename portion (post-colon) of an entity id like
# 'build-2026:horizon-db'. URLs use this so we don't need colon-encoding.
function EntitySlug {
    param([string]$id)
    if ([string]::IsNullOrWhiteSpace($id)) { return 'unnamed' }
    $i = $id.LastIndexOf(':')
    if ($i -lt 0) { return $id }
    return $id.Substring($i + 1)
}

function Render-MentionFrames {
    # Produces a small horizontal strip of thumbnails for a mention. Frame
    # paths are stored relative to the session dir; we map to the docs/
    # mirrored path (frames/<code>/announcement-frames/<ts>/<file>.jpg).
    param([object]$Mention)
    if (-not $Mention.frames -or @($Mention.frames).Count -eq 0) { return '' }
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.Append('<div class="mention-frames">')
    foreach ($rel in @($Mention.frames)) {
        $clean = $rel -replace '\\', '/'
        $url = "../frames/$($Mention.sessionCode)/$clean"
        [void]$sb.Append('<a href="' + (HtmlEncode $url) + '" data-zoom="1"><img loading="lazy" src="' + (HtmlEncode $url) + '" alt="Frame at ' + (HtmlEncode $Mention.timestamp) + '"></a>')
    }
    [void]$sb.Append('</div>')
    return $sb.ToString()
}

# --------------------------------------------------------------------------
# Discover sessions.
# --------------------------------------------------------------------------

$sessionDirs = Get-ChildItem -LiteralPath $sessionsRoot -Directory
if (-not $sessionDirs -or $sessionDirs.Count -eq 0) {
    throw "No sessions found under $sessionsRoot. Run Invoke-BuildIngestion.ps1 first."
}

Write-Host "Rendering docs/$Conference/$EventId from $($sessionDirs.Count) ingested session(s)" -ForegroundColor Cyan
Write-Host "  Conference:    $Conference"
Write-Host "  Sessions root: $sessionsRoot"
Write-Host "  Output root:   $OutputRoot"
Write-Host ''

# Wipe + recreate the output. Keeps stale per-session pages from lingering
# when sessions are removed from the catalog.
if (Test-Path -LiteralPath $OutputRoot) {
    Remove-Item -LiteralPath $OutputRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $OutputRoot -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $OutputRoot 'sessions') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $OutputRoot 'assets')   -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $OutputRoot 'frames')   -Force | Out-Null

# Copy asset bundle wholesale. Use -Path (not -LiteralPath) so the wildcard expands.
Copy-Item -Path (Join-Path $templatesRoot 'assets\*') -Destination (Join-Path $OutputRoot 'assets') -Recurse -Force

# --------------------------------------------------------------------------
# Per-session render + index doc collection.
# --------------------------------------------------------------------------

$indexCatalog = New-Object System.Collections.Generic.List[object]
$lunrDocs     = New-Object System.Collections.Generic.List[object]
$generatedAt  = (Get-Date).ToUniversalTime().ToString('o')

$rendered = 0
$skipped  = 0
foreach ($dir in $sessionDirs) {
    $manifestPath = Join-Path $dir.FullName 'rich-manifest.json'
    if (-not (Test-Path -LiteralPath $manifestPath)) {
        $skipped++
        continue
    }
    $m = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json -Depth 12
    $code = $m.code

    # ---- per-session HTML ----
    $speakers = if ($m.speakerNames) { HtmlEncode $m.speakerNames } else { '' }

    $metaParts = @()
    if ($m.durationMinutes)   { $metaParts += "<span>{0} min</span>" -f ([int]$m.durationMinutes) }
    if ($m.sessionType)       { $metaParts += "<span>{0}</span>"     -f (HtmlEncode $m.sessionType) }
    if ($m.level -and @($m.level).Count -gt 0) {
        $levelText = if ($m.level -is [string]) { $m.level } else { ($m.level -join ', ') }
        $metaParts += "<span>{0}</span>" -f (HtmlEncode $levelText)
    }
    if ($m.location)          { $metaParts += "<span>{0}</span>"     -f (HtmlEncode $m.location) }
    if ($m.startDateTime) {
        # ConvertFrom-Json gives us a DateTime; format ISO-ish in UTC so the
        # page is locale-independent and doesn't surprise readers with mm/dd/yyyy.
        $dt = $m.startDateTime
        $iso = if ($dt -is [datetime]) {
            $dt.ToUniversalTime().ToString("yyyy-MM-dd HH:mm 'UTC'")
        } else { "$dt" }
        $metaParts += "<span>{0}</span>" -f (HtmlEncode $iso)
    }

    $tagSources = @()
    if ($m.tags)   { $tagSources += @($m.tags) }
    if ($m.topics) { $tagSources += @($m.topics) }
    $tagsHtml = Tag-Cloud -Tags ($tagSources | Where-Object { $_ } | Select-Object -Unique)

    $actions = @()
    if ($m.sessionUrl)       { $actions += "<a href=`"$(HtmlEncode $m.sessionUrl)`" class=`"primary`" target=`"_blank`" rel=`"noopener`">Open on build.microsoft.com</a>" }
    if ($m.onDemandUrl)      { $actions += "<a href=`"$(HtmlEncode $m.onDemandUrl)`" target=`"_blank`" rel=`"noopener`">Medius player</a>" }
    if ($m.downloadVideoUrl) { $actions += "<a href=`"$(HtmlEncode $m.downloadVideoUrl)`" target=`"_blank`" rel=`"noopener`">Download MP4</a>" }
    if ($m.slideDeckUrl)     { $actions += "<a href=`"$(HtmlEncode $m.slideDeckUrl)`" target=`"_blank`" rel=`"noopener`">Slide deck</a>" }
    $actionsHtml = $actions -join "`n"

    # Recording notice. Four cases that visitors otherwise can't tell apart
    # on a thinly-populated page:
    #   A) "Will not be recorded" + no video URLs: in-person-only by design
    #      (Table Talks, Labs, Lightning Talks). Bare page is correct.
    #   B) "Will be recorded" + no video URLs: upload pending; re-ingest later.
    #   C) onDemandUrl present but ingestion couldn't extract a transcript
    #      (Medius embed has no captionsConfiguration, or the player is on
    #      mediastream.microsoft.com which isn't supported yet). Visitor
    #      gets a working iframe but no transcript/summary/frames.
    #   D) Catalog has no viewingOptions value at all and no video.
    # Sessions with full artifacts get no notice.
    $hasAnyVideo  = $m.onDemandUrl -or $m.downloadVideoUrl -or $m.hlsUrl
    # Probe transcript existence early - the notice logic below needs it,
    # and the later transcript section reuses the same path.
    $transcriptPath = Join-Path $dir.FullName 'transcript.md'
    $hasTranscript = Test-Path -LiteralPath $transcriptPath
    $viewingStr   = if ($m.viewingOptions) { ($m.viewingOptions -join ',') } else { '' }
    $wontRecord   = $viewingStr -match '(?i)not\s*be\s*recorded'
    $willRecord   = $viewingStr -match '(?i)will\s*be\s*recorded'
    $noticeHtml   = ''
    $stype = if ($m.sessionType) { HtmlEncode $m.sessionType } else { 'session' }
    if (-not $hasAnyVideo) {
        if ($wontRecord) {
            $noticeHtml = @"
<aside class="notice notice-info" role="note">
    <strong>No recording &mdash; in-person $stype.</strong>
    Microsoft Build does not record this session format on purpose
    (it keeps the discussion candid for the small group present).
    The information above is everything available in the public catalog;
    visit the canonical session page for any post-event notes.
</aside>
"@
        }
        elseif ($willRecord) {
            $noticeHtml = @"
<aside class="notice notice-warning" role="note">
    <strong>Recording not yet published.</strong>
    The catalog says this session will be recorded, but Microsoft hasn't
    released the on-demand video yet. Transcripts, summary, frames, and the
    embedded player will appear once the recording is uploaded and this
    repo is re-ingested.
</aside>
"@
        }
        else {
            $noticeHtml = @"
<aside class="notice notice-info" role="note">
    <strong>No recording available.</strong>
    The public catalog does not expose a video for this session. If you
    expected one, check the canonical session page on
    <code>build.microsoft.com</code>.
</aside>
"@
        }
    }
    elseif (-not $hasTranscript) {
        # Case C: player exists but we couldn't pull a transcript. Tell the
        # visitor what they have and don't have, so the missing summary /
        # frames don't look like a bug.
        $noticeHtml = @"
<aside class="notice notice-warning" role="note">
    <strong>Player only &mdash; transcript not available.</strong>
    The video player below works, but Microsoft's on-demand surface for
    this session didn't expose machine-readable captions in a format we
    recognise (likely a non-Medius player), so there's no transcript,
    no AI summary, and no per-announcement frame strips on this page.
    Play the video to follow along.
</aside>
"@
    }

    # Description block (Microsoft's official). Render as a separate section.
    $descriptionHtml = ''
    if ($m.description) {
        $descriptionHtml = @"
<section class="section">
    <h2>Official description</h2>
    <p>$(HtmlEncode $m.description)</p>
</section>
"@
    }

    # Cover frame: pick the middle frame from the gallery (or first if there
    # are fewer than 3). Hidden when no frames exist (lab/table-talk sessions).
    $coverHtml = ''
    $framesArr = @($m.artifacts.frames)
    if ($framesArr.Count -gt 0) {
        $coverIdx = [Math]::Floor($framesArr.Count / 2)
        if ($coverIdx -ge $framesArr.Count) { $coverIdx = $framesArr.Count - 1 }
        $coverName = Split-Path $framesArr[$coverIdx] -Leaf
        $coverHtml = @"
<section class="cover">
    <a class="cover-link" href="../frames/$code/$(HtmlEncode $coverName)" data-zoom="1">
        <img src="../frames/$code/$(HtmlEncode $coverName)" alt="Cover frame for $(HtmlEncode $code)">
    </a>
</section>
"@
    }

    # Embedded player. Three-way fallback chain:
    #   1. downloadVideoUrl set -> HTML5 <video> + MP4 (HTTP range requests, instant seek).
    #   2. hlsUrl set           -> HTML5 <video> + hls.js (native on Safari; library elsewhere).
    #                              Same <video> element as case 1, just sourced via JS, so the
    #                              "click an announcement timestamp to seek the player" feature
    #                              (see Inject-AnnouncementFrames + session.js) works uniformly
    #                              across both cases. Empirically all 59 'iframe-only-today'
    #                              sessions in the catalog have an hlsUrl, so this swap takes
    #                              the iframe path from 59 sessions down to 0.
    #   3. onDemandUrl set      -> opaque iframe embed. Last resort; transcripts/frames work
    #                              but the click-to-seek feature can't reach inside the iframe
    #                              and degrades to "open canonical session URL in a new tab".
    #   4. None of the above    -> no player block (labs, in-person-only sessions, etc.).
    # Sessions with neither (labs, no recording yet) get no player block.
    $playerHtml = ''
    if ($m.downloadVideoUrl) {
        $playerHtml = @"
<section class="player">
    <video class="session-video" controls preload="metadata" playsinline>
        <source src="$(HtmlEncode $m.downloadVideoUrl)" type="video/mp4">
        Your browser doesn't support inline MP4 playback. <a href="$(HtmlEncode $m.downloadVideoUrl)">Download the MP4</a>.
    </video>
</section>
"@
    }
    elseif ($m.hlsUrl) {
        # session.js sees the data-hls-src attribute and either:
        #   - attaches hls.js (Chrome/Edge/Firefox),
        #   - or sets src directly (Safari has native HLS support).
        # Fallback inner <a> guarantees something useful when JS is disabled.
        $playerHtml = @"
<section class="player">
    <video class="session-video" controls preload="metadata" playsinline
           data-hls-src="$(HtmlEncode $m.hlsUrl)">
        Your browser doesn't support HLS playback. <a href="$(HtmlEncode $m.onDemandUrl)" target="_blank" rel="noopener">Open in Microsoft player</a>.
    </video>
</section>
"@
    }
    elseif ($m.onDemandUrl) {
        $playerHtml = @"
<section class="player">
    <iframe src="$(HtmlEncode $m.onDemandUrl)" loading="lazy" allowfullscreen
            referrerpolicy="no-referrer-when-downgrade"
            sandbox="allow-scripts allow-same-origin allow-presentation"></iframe>
</section>
"@
    }

    # Summary: prefer summary.md (Copilot-generated), fall back to ai-description.html (Microsoft's).
    $summaryHtml = ''
    $summaryPath = Join-Path $dir.FullName 'summary.md'
    $aiPath      = Join-Path $dir.FullName 'ai-description.html'
    if (Test-Path -LiteralPath $summaryPath) {
        $summaryMd = Get-Content -Raw -LiteralPath $summaryPath
        $summaryRendered = Render-MarkdownLite $summaryMd
        # Inject announcement-frame strips next to each [HH:MM:SS] timestamp.
        # Frames are produced by scripts/Get-AnnouncementFrames.ps1 (4 frames
        # per timestamp: T-10s, T-5s, T+5s, T+10s). The renderer only emits
        # markup for timestamps where the frame files actually exist on disk,
        # so old artifacts and freshly-summarized sessions both render
        # cleanly even when Get-AnnouncementFrames hasn't run yet.
        #
        # Build a per-session timestamp -> entity lookup so each key-
        # announcement bullet gets a small "jump to entity page" link
        # rendered next to its play button. The lookup uses the per-session
        # mentions index ($annMentionsBySession) joined with the canonical
        # entity table ($annEntities); when annEnabled is false the table
        # is empty and no jump links are emitted.
        $entityByTs = @{}
        if ($annEnabled -and $annMentionsBySession.ContainsKey($code)) {
            $entityIxLocal = @{}
            foreach ($eRow in $annEntities) { $entityIxLocal[$eRow.id] = $eRow }
            foreach ($mn in $annMentionsBySession[$code].ToArray()) {
                $eRow = $entityIxLocal[$mn.entityId]
                if (-not $eRow) { continue }
                # Multiple mentions can share a timestamp (rare; defensive).
                # Last one wins - they all link to the same entity anyway.
                $entityByTs[$mn.timestamp] = [pscustomobject]@{
                    Slug     = EntitySlug $eRow.id
                    Name     = $eRow.canonicalName
                    Category = $eRow.category
                }
            }
        }
        $summaryRendered = Inject-AnnouncementFrames -Html $summaryRendered -SessionDir $dir.FullName -Code $code -EntityByTimestamp $entityByTs
        $summaryHtml = @"
<section class="section">
    <div class="summary">
$summaryRendered
    </div>
</section>
"@
    }
    elseif (Test-Path -LiteralPath $aiPath) {
        $aiHtml = Get-Content -Raw -LiteralPath $aiPath
        # The API's aiDescription is already HTML — embed as-is in a section.
        $summaryHtml = @"
<section class="section">
    <h2>Summary (Microsoft AI)</h2>
    <div class="summary">$aiHtml</div>
    <p><small>Generated by Microsoft; will be replaced by a richer summary once <code>scripts/Get-SessionSummaries.ps1</code> runs.</small></p>
</section>
"@
    }

    # Frames gallery. Two flavours that can both contribute, in this order:
    #   1) Evenly-spaced "scenic" frames (15 per session) sampled by
    #      Invoke-BuildIngestion.ps1 - the main visual TOC.
    #   2) Announcement-context frames (4 per timestamp) sampled by
    #      Get-AnnouncementFrames.ps1 - grouped by HH:MM:SS within an
    #      <h3>-headed sub-grid so the reader can see them at a glance
    #      (otherwise they're only accessible via the hover-popup strip
    #      next to each timestamp in the summary).
    # Every <img> is wrapped in <a data-zoom="1"> so session.js's lightbox
    # handler picks it up.
    $framesHtml = ''
    $mainFigs = @()
    if ($m.artifacts.frames -and @($m.artifacts.frames).Count -gt 0) {
        $mainFigs = foreach ($rel in @($m.artifacts.frames)) {
            $name = Split-Path $rel -Leaf
            $label = if ($name -match 'frame-\d+-(.+?)\.jpg$') {
                ($Matches[1] -replace '-', ':')
            } else { '' }
            "<figure><a href=`"../frames/$code/$(HtmlEncode $name)`" data-zoom=`"1`"><img loading=`"lazy`" src=`"../frames/$code/$(HtmlEncode $name)`" alt=`"Frame at $label`"></a><figcaption>$(HtmlEncode $label)</figcaption></figure>"
        }
    }

    $annGroupsHtml = ''
    $afSrcRoot = Join-Path $dir.FullName 'announcement-frames'
    if (Test-Path -LiteralPath $afSrcRoot) {
        $annDirs = Get-ChildItem -LiteralPath $afSrcRoot -Directory | Sort-Object Name
        if ($annDirs.Count -gt 0) {
            $groupBlocks = foreach ($adir in $annDirs) {
                $tsLabel = $adir.Name -replace '-', ':'
                $imgs = Get-ChildItem -LiteralPath $adir.FullName -File -Filter '*.jpg' | Sort-Object Name
                if ($imgs.Count -eq 0) { continue }
                $cells = foreach ($img in $imgs) {
                    $rel = "../frames/$code/announcement-frames/$($adir.Name)/$($img.Name)"
                    $offset = if ($img.BaseName -match 'frame-(.+)$') { $Matches[1] } else { '' }
                    "<figure><a href=`"$rel`" data-zoom=`"1`"><img loading=`"lazy`" src=`"$rel`" alt=`"$tsLabel $offset`"></a><figcaption>$(HtmlEncode $offset)</figcaption></figure>"
                }
                @"
<div class="ann-group">
    <h3 class="ann-ts">$(HtmlEncode $tsLabel)</h3>
    <div class="frames-grid frames-grid-tight">
$($cells -join "`n")
    </div>
</div>
"@
            }
            $annGroupsHtml = @"
<div class="ann-frames">
    <h3 class="section-subhead">Frames around each announcement</h3>
$($groupBlocks -join "`n")
</div>
"@
        }
    }

    if ($mainFigs.Count -gt 0 -or $annGroupsHtml) {
        $mainGridHtml = if ($mainFigs.Count -gt 0) {
            @"
<div class="frames-grid">
$($mainFigs -join "`n")
</div>
"@
        } else { '' }
        $framesHtml = @"
<section class="section">
    <h2>Frames</h2>
    $mainGridHtml
    $annGroupsHtml
</section>
"@
    }

    # References.
    $referencesHtml = ''
    $allLinks = @()
    if ($m.sessionLinks) {
        foreach ($l in @($m.sessionLinks)) {
            $url = $l.url ?? $l.Url ?? $l
            $label = $l.label ?? $l.Label ?? $l.linkType ?? $url
            if ($url) { $allLinks += [pscustomobject]@{ url = "$url"; label = "$label" } }
        }
    }
    if ($m.relatedResources) {
        foreach ($l in @($m.relatedResources)) {
            $url = $l.url ?? $l.Url ?? $l
            $label = $l.label ?? $l.Label ?? $url
            if ($url) { $allLinks += [pscustomobject]@{ url = "$url"; label = "$label" } }
        }
    }
    if ($allLinks.Count -gt 0) {
        $items = $allLinks | ForEach-Object {
            "<li><a href=`"$(HtmlEncode $_.url)`" target=`"_blank`" rel=`"noopener`">$(HtmlEncode $_.label)</a></li>"
        }
        $referencesHtml = @"
<section class="section">
    <h2>References</h2>
    <ul class="refs-list">
$($items -join "`n")
    </ul>
</section>
"@
    }

    # Transcript (collapsed). $transcriptPath / $hasTranscript were computed
    # earlier so the notice block could use them.
    $transcriptHtml = ''
    if ($hasTranscript) {
        $transcript = Get-Content -Raw -LiteralPath $transcriptPath
        # Strip markdown emphasis (the **[ts]** wrapper from our converter) so
        # the collapsed body reads as plain text; preserve cue order + spacing.
        $stripped = [regex]::Replace($transcript, '\*\*(\[[^\]]+\])\*\*', '$1')
        $transcriptHtml = @"
<section class="section">
    <h2>Transcript</h2>
    <details class="transcript">
        <summary>Show / hide transcript ($($transcript.Length.ToString('N0')) chars)</summary>
        <pre class="transcript-body">$(HtmlEncode $stripped)</pre>
    </details>
</section>
"@
    }

    # Derive ISO datetimes for the client-side status JS (data-attributes
    # on .status-line). Empty string when missing - the JS hides the badge.
    $startIso = if ($m.startDateTime -is [datetime]) {
        $m.startDateTime.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    } elseif ($m.startDateTime) { "$($m.startDateTime)" } else { '' }
    $endIso = if ($m.endDateTime -is [datetime]) {
        $m.endDateTime.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    } elseif ($m.endDateTime) { "$($m.endDateTime)" } else { '' }

    # Per-session sidebar listing the entities this session announced
    # (rendered on the session page between SUMMARY and FRAMES). Each chip
    # links to the corresponding entity page so the reader can pivot from
    # the session view to the cross-session entity view.
    $announcementsSidebarHtml = ''
    if ($annEnabled -and $annMentionsBySession.ContainsKey($code)) {
        $sessionMentions = $annMentionsBySession[$code].ToArray() | Sort-Object timestampSeconds
        $entityIndex = @{}; foreach ($e in $annEntities) { $entityIndex[$e.id] = $e }
        $chips = foreach ($sm in $sessionMentions) {
            $e = $entityIndex[$sm.entityId]
            if (-not $e) { continue }
            $slug = EntitySlug $e.id
            $catSlug = CategorySlug $e.category
            "<li><a href=`"../announcements/$(HtmlEncode $slug).html`"><span class=`"entity-cat entity-cat-$(HtmlEncode $catSlug)`">$(HtmlEncode (CategoryLabel $e.category))</span><span>$(HtmlEncode $e.canonicalName)</span><small>$(HtmlEncode $sm.timestamp)</small></a></li>"
        }
        if ($chips) {
            $announcementsSidebarHtml = @"
<aside class="session-ann-sidebar" aria-label="Announcements introduced in this session">
    <h2>Announcements introduced here</h2>
    <ul>
$($chips -join "`n")
    </ul>
</aside>
"@
        }
    }

    $pageBody = Render-Template $sessionBody @{
        CODE             = HtmlEncode $code
        SESSION_TYPE     = HtmlEncode ($m.sessionType ?? '')
        TITLE            = HtmlEncode ($m.title ?? $code)
        SPEAKERS_HTML    = $speakers
        META_FIELDS_HTML = ($metaParts -join "`n")
        START_DT_ISO     = HtmlEncode $startIso
        END_DT_ISO       = HtmlEncode $endIso
        TAGS_HTML        = $tagsHtml
        NOTICE_HTML      = $noticeHtml
        COVER_HTML       = $coverHtml
        PLAYER_HTML      = $playerHtml
        ACTIONS_HTML     = $actionsHtml
        DESCRIPTION_HTML = $descriptionHtml
        SUMMARY_HTML     = $summaryHtml
        ANNOUNCEMENTS_SIDEBAR_HTML = $announcementsSidebarHtml
        FRAMES_HTML      = $framesHtml
        REFERENCES_HTML  = $referencesHtml
        TRANSCRIPT_HTML  = $transcriptHtml
    }

    # hls.js is only needed on session pages that use the HLS player path
    # (i.e. no downloadVideoUrl but has hlsUrl). Conditionally include it to
    # avoid wasting ~290 KB of JS on the ~108 MP4 sessions + 276 sessions
    # with no player at all. The "defer" attribute keeps it from blocking
    # parse; session.js's attachHls() runs at DOMContentLoaded after this
    # finishes loading.
    $extraBodyScripts = ''
    if (-not $m.downloadVideoUrl -and $m.hlsUrl) {
        $extraBodyScripts = '<script defer src="../assets/hls.min.js"></script>'
    }

    $pageHtml = Render-Template $layoutTpl @{
        TITLE             = (HtmlEncode "$code - $($m.title)")
        ASSETS_PREFIX     = '../'
        BREADCRUMB        = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                            "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                            "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; " +
                            "$(HtmlEncode $code)</nav>"
        HEADER_TITLE      = "$(HtmlEncode $code) &mdash; $(HtmlEncode $m.title)"
        NAV_HTML          = '<nav><a href="../index.html">All sessions in ' + (HtmlEncode "$Conference $EventId") + '</a>' +
                            $(if ($annEnabled) { '<a href="../announcements/index.html">Announcements</a>' } else { '' }) +
                            '</nav>'
        SOURCE_NOTE       = " from <code>sessions/$(HtmlEncode $Conference)/$(HtmlEncode $EventId)/&lt;CODE&gt;/rich-manifest.json</code>"
        EXTRA_HEAD        = ''
        EXTRA_BODY_SCRIPTS = $extraBodyScripts
        BODY              = $pageBody
        GENERATED_AT      = HtmlEncode $generatedAt
    }
    $pageOut = Join-Path $OutputRoot ("sessions\$code.html")
    Set-Content -LiteralPath $pageOut -Value $pageHtml -Encoding utf8

    # ---- per-session frame copies ----
    if (-not $NoFrames -and $m.artifacts.frames -and @($m.artifacts.frames).Count -gt 0) {
        $codeFramesDir = Join-Path $OutputRoot ("frames\$code")
        New-Item -ItemType Directory -Path $codeFramesDir -Force | Out-Null
        foreach ($rel in @($m.artifacts.frames)) {
            $src = Join-Path $dir.FullName $rel
            if (Test-Path -LiteralPath $src) {
                Copy-Item -LiteralPath $src -Destination $codeFramesDir -Force
            }
        }
    }
    # ---- announcement frames (per [HH:MM:SS] in the summary) ----
    # Mirror sessions/<conf>/<event>/<code>/announcement-frames/<ts>/*.jpg to
    # docs/<conf>/<event>/frames/<code>/announcement-frames/<ts>/*.jpg so the
    # summary-injected <img src="../frames/<code>/announcement-frames/..."> refs
    # resolve. Quiet no-op when the directory doesn't exist yet (most sessions
    # before Get-AnnouncementFrames.ps1 runs).
    $afSrc = Join-Path $dir.FullName 'announcement-frames'
    if (-not $NoFrames -and (Test-Path -LiteralPath $afSrc)) {
        $afDst = Join-Path $OutputRoot ("frames\$code\announcement-frames")
        if (Test-Path -LiteralPath $afDst) {
            Remove-Item -LiteralPath $afDst -Recurse -Force -ErrorAction SilentlyContinue
        }
        Copy-Item -LiteralPath $afSrc -Destination $afDst -Recurse -Force
    }

    # ---- catalog + lunr docs for the index page ----
    # IMPORTANT: PowerShell's `if` expression unwraps single-element collections
    # when assigned to a variable. Wrap the WHOLE if-expression in @() (not the
    # if-branch) so a single-tag session still serializes to ["Tag"] instead of
    # the JSON scalar "Tag" - the page-side app.js expects an array.
    $tagsArr   = @(if ($m.tags)   { $m.tags   | ForEach-Object { "$_" } | Where-Object { $_ } })
    $topicsArr = @(if ($m.topics) { $m.topics | ForEach-Object { "$_" } | Where-Object { $_ } })

    $indexCatalog.Add([pscustomobject]@{
        code          = $code
        title         = $m.title
        sessionType   = $m.sessionType
        speakerNames  = $m.speakerNames
        tags          = $tagsArr
        topics        = $topicsArr
        startDateTime = $startIso
        endDateTime   = $endIso
        durationMins  = $m.durationMinutes
        # True when the session has any kind of playable artifact: a video
        # URL the iframe/<video> can load, OR captured frames, OR a
        # transcript. Drives the "Recorded only" toggle on the index page,
        # which hides ~233 by-design unrecorded sessions (Table Talks, Labs,
        # Lightning Talks) from the default view.
        hasVideo      = [bool]($hasAnyVideo -or $hasTranscript -or $framesArr.Count -gt 0)
        # Cover thumbnail for the index card; null when the session has no
        # frames (Table Talks, Labs, sessions still missing duration). The
        # path is relative to docs/<Conference>/<EventId>/index.html.
        coverFrame    = if ($framesArr.Count -gt 0) {
                            $coverName = Split-Path $framesArr[[Math]::Floor($framesArr.Count / 2)] -Leaf
                            "frames/$code/$coverName"
                        } else { $null }
    }) | Out-Null

    # Lunr search body: title + summary + first slice of transcript (limit so
    # the index stays under a few hundred KB even for hundreds of sessions).
    $summaryBody = if (Test-Path -LiteralPath $summaryPath) {
        Get-Content -Raw -LiteralPath $summaryPath
    } elseif ($m.description) { "$($m.description)" } else { '' }
    $transcriptSlice = ''
    if (Test-Path -LiteralPath $transcriptPath) {
        $tx = Get-Content -Raw -LiteralPath $transcriptPath
        $transcriptSlice = if ($tx.Length -gt 4096) { $tx.Substring(0, 4096) } else { $tx }
    }
    $lunrDocs.Add([pscustomobject]@{
        ref      = $code
        title    = "$($m.title)"
        code     = $code
        speakers = "$($m.speakerNames)"
        tags     = ($tagsArr -join ' ')
        topics   = ($topicsArr -join ' ')
        body     = "$summaryBody`n$transcriptSlice"
    }) | Out-Null

    $rendered++
}

# --------------------------------------------------------------------------
# Index page + search index.
# --------------------------------------------------------------------------

$catalogJson = [pscustomobject]@{
    schemaVersion = 1
    eventId       = $EventId
    generatedAt   = $generatedAt
    total         = $indexCatalog.Count
    sessions      = @($indexCatalog | Sort-Object code)
}
$catalogJson | ConvertTo-Json -Depth 6 -Compress | Set-Content -LiteralPath (Join-Path $OutputRoot 'catalog.json') -Encoding utf8

Build-LunrIndex -Documents $lunrDocs.ToArray() -OutputPath (Join-Path $OutputRoot 'search-index.json')

$indexPageBody = Render-Template $indexBody @{
    HERO_HEADING = (HtmlEncode "$Conference $EventId sessions")
    TOTAL_COUNT  = if ($indexCatalog.Count -eq 1) { '1 session' } else { "$($indexCatalog.Count) sessions" }
}
$indexHtml = Render-Template $layoutTpl @{
    TITLE          = "$Conference $EventId - Conference Library"
    ASSETS_PREFIX  = ''
    BREADCRUMB     = '<nav class="breadcrumb"><a href="../../index.html">Conference Library</a> &raquo; ' +
                     "<a href=`"../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                     "$(HtmlEncode $EventId)</nav>"
    HEADER_TITLE   = "$(HtmlEncode $Conference) $(HtmlEncode $EventId)"
    NAV_HTML       = if ($annEnabled) { '<nav><a href="announcements/index.html">Announcements</a></nav>' } else { '' }
    SOURCE_NOTE    = " from <code>sessions/$(HtmlEncode $Conference)/$(HtmlEncode $EventId)/&lt;CODE&gt;/rich-manifest.json</code>"
    EXTRA_HEAD     = ''
    BODY           = $indexPageBody
    GENERATED_AT   = HtmlEncode $generatedAt
}
Set-Content -LiteralPath (Join-Path $OutputRoot 'index.html') -Value $indexHtml -Encoding utf8

# --------------------------------------------------------------------------
# Announcements view: landing page + one page per canonical entity +
# search index + slim runtime catalog. Skipped silently when the Step 3
# artifacts aren't present (see annEnabled guard near the top).
# --------------------------------------------------------------------------

if ($annEnabled) {
    $annRoot = Join-Path $OutputRoot 'announcements'
    New-Item -ItemType Directory -Path $annRoot -Force | Out-Null

    # Slim runtime catalog the JS reads. Strip the heavy fields the card
    # grid doesn't need (longDescription, full mentions[], full link arrays)
    # to keep this load fast; the per-entity page is server-rendered with
    # everything.
    $annCatalog = $annEntities | ForEach-Object {
        $catCounts = $_.linkCounts
        [pscustomobject]@{
            id            = $_.id
            slug          = (EntitySlug $_.id)
            canonicalName = $_.canonicalName
            category      = $_.category
            tagline       = $_.tagline
            aliases       = @($_.aliases)
            mentionCount  = $_.mentionCount
            sessionCount  = $_.sessionCount
            firstMention  = $_.firstMention
            linkCounts    = $catCounts
            anyInferred   = [bool]$_.anyInferred
        }
    }
    $annCatalogDoc = [pscustomobject]@{
        schemaVersion = 1
        conference    = $Conference
        eventId       = $EventId
        generatedAt   = $generatedAt
        entityCount   = $annCatalog.Count
        entities      = @($annCatalog)
    }
    $annCatalogDoc | ConvertTo-Json -Depth 8 -Compress |
        Set-Content -LiteralPath (Join-Path $OutputRoot 'announcement-catalog.json') -Encoding utf8

    # Per-entity Lunr docs: index name + tagline + aliases + long description
    # so search matches on either the canonical name OR a fragment of the
    # description ("PostgreSQL" finds Horizon DB even when the canonical
    # name doesn't contain the word).
    $annLunrDocs = New-Object 'System.Collections.Generic.List[object]'
    foreach ($e in $annEntities) {
        $aliasText = if ($e.aliases) { (@($e.aliases) -join ' ') } else { '' }
        $annLunrDocs.Add([pscustomobject]@{
            ref      = $e.id
            name     = "$($e.canonicalName)"
            category = "$($e.category)"
            tagline  = "$($e.tagline)"
            aliases  = $aliasText
            body     = "$($e.longDescription)"
        }) | Out-Null
    }
    Build-LunrIndex `
        -Documents $annLunrDocs.ToArray() `
        -OutputPath (Join-Path $OutputRoot 'announcement-search-index.json') `
        -Fields ([ordered]@{
            name     = 12
            aliases  = 8
            tagline  = 4
            category = 4
            body     = $null
        })

    # Sessions index, used by per-entity render to link mention -> session.
    # Built from the in-memory $indexCatalog we already populated during the
    # session loop above (slim object with code + title + speakerNames + ...).
    $sessionByCode = @{}
    foreach ($s in $indexCatalog) { $sessionByCode[$s.code] = $s }

    # ---- landing page ----
    $annSessionsCovered = ($annMentions | Select-Object -ExpandProperty sessionCode -Unique).Count
    $annLandingHtml = Render-Template $annLandingBody @{
        HERO_HEADING  = (HtmlEncode "$Conference $EventId announcements")
        TOTAL_COUNT   = if ($annEntities.Count -eq 1) { '1 announcement' } else { "$($annEntities.Count) announcements" }
        SESSION_COUNT = $annSessionsCovered
    }
    $annLandingPage = Render-Template $layoutTpl @{
        TITLE          = "Announcements - $Conference $EventId"
        ASSETS_PREFIX  = '../'
        BREADCRUMB     = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                         "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                         "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; Announcements</nav>"
        HEADER_TITLE   = "$(HtmlEncode $Conference) $(HtmlEncode $EventId) &mdash; Announcements"
        NAV_HTML       = '<nav><a href="../index.html">All sessions in ' + (HtmlEncode "$Conference $EventId") + '</a></nav>'
        SOURCE_NOTE    = " from <code>catalog/$(HtmlEncode $Conference)/$(HtmlEncode $EventId)/announcements/entities-enriched.json</code>"
        EXTRA_HEAD     = ''
        BODY           = $annLandingHtml
        GENERATED_AT   = HtmlEncode $generatedAt
    }
    Set-Content -LiteralPath (Join-Path $annRoot 'index.html') -Value $annLandingPage -Encoding utf8

    # ---- per-entity pages ----
    foreach ($e in $annEntities) {
        $slug    = EntitySlug $e.id
        $catSlug = CategorySlug $e.category
        $catLbl  = CategoryLabel $e.category

        # Header badges: SDK-suggested-only / has-some-inferred / etc.
        $headerBadges = @()
        if ($e.anyInferred)   { $headerBadges += '<span class="source-badge" title="At least one mention was tagged [inferred] by the summarizer">inferred</span>' }
        if ($e.aliasFolded)   { $headerBadges += '<span class="source-badge" title="Merged via aliases.json">alias-folded</span>' }
        $headerBadgesHtml = if ($headerBadges) { $headerBadges -join ' ' } else { '' }

        # Stats line.
        $stats = @()
        $stats += "<span><strong>$($e.mentionCount)</strong> mention(s)</span>"
        $stats += "<span><strong>$($e.sessionCount)</strong> session(s)</span>"
        if ($e.firstMention -and $e.firstMention.sessionCode) {
            $fmSession = $e.firstMention.sessionCode
            $fmTs      = $e.firstMention.timestamp
            $fmHref    = "../sessions/$(HtmlEncode $fmSession).html"
            $stats += "<span>First in <a href=`"$fmHref`"><strong>$(HtmlEncode $fmSession)</strong></a>$(if ($fmTs) { ' @ ' + (HtmlEncode $fmTs) } else { '' })</span>"
        }
        $linkTotal = if ($e.linkCounts) { [int]$e.linkCounts.total } else { 0 }
        $stats += "<span><strong>$linkTotal</strong> external link(s)</span>"

        # Aliases line (only when there are any).
        $aliasesHtml = ''
        if (@($e.aliases) -and @($e.aliases).Count -gt 0) {
            $aliasItems = @($e.aliases) | ForEach-Object { '<code>' + (HtmlEncode $_) + '</code>' }
            $aliasesHtml = '<div class="entity-aliases"><strong>Also called:</strong> ' + ($aliasItems -join ', ') + '</div>'
        }

        # ---- sections: long description, get-started, code snippets, sessions ----
        $sectionsHtml = [System.Text.StringBuilder]::new()

        # Long description (only when meaningfully different from tagline).
        if ($e.longDescription -and $e.longDescription -ne $e.tagline) {
            [void]$sectionsHtml.AppendLine('<section class="entity-section"><h2>About</h2><p>' + (HtmlEncode $e.longDescription) + '</p></section>')
        }

        # "Get started" panel: links grouped by kind, each badged by source.
        $linksArr = @($e.links)
        if ($linksArr.Count -gt 0) {
            [void]$sectionsHtml.AppendLine('<section class="entity-section"><h2>Get started</h2>')
            $byKind = $linksArr | Group-Object kind
            # Stable presentation order: github, nuget, npm, pypi, docs, samples, marketplace, blog, other.
            $kindOrder = @('github','nuget','npm','pypi','crates','huggingface','docs','samples','marketplace','blog','other')
            $byKindSorted = $byKind | Sort-Object @{ Expression = { $i = $kindOrder.IndexOf($_.Name); if ($i -lt 0) { 99 } else { $i } } }, Name
            foreach ($kg in $byKindSorted) {
                [void]$sectionsHtml.AppendLine('<h3>' + (HtmlEncode $kg.Name) + '</h3><ul class="link-group">')
                foreach ($l in $kg.Group) {
                    $label = if ($l.label) { $l.label } else { $l.url }
                    $srcLabel = switch ($l.source) {
                        'manual'     { 'manual' }
                        'transcript' { 'transcript' }
                        'search'     { 'search-suggested' }
                        'model'      { 'model-suggested' }
                        default      { $l.source }
                    }
                    $srcDetail = ''
                    if ($l.source -eq 'transcript' -and $l.sourceSession) {
                        $srcDetail = " <span class=`"source-detail`">via <a href=`"../sessions/$(HtmlEncode $l.sourceSession).html`">$(HtmlEncode $l.sourceSession)</a>$(if ($l.sourceTime) { ' @ ' + (HtmlEncode $l.sourceTime) } else { '' })</span>"
                    }
                    elseif ($l.source -eq 'search' -and $l.sourceProvider) {
                        # Attribution: name the tool (Zakira.Recall) AND the
                        # underlying search provider it routed through. The
                        # tool name links to the repo so visitors know how
                        # to reproduce a search themselves.
                        $srcDetail = " <span class=`"source-detail`">via <a href=`"https://github.com/MoaidHathot/Zakira.Recall`" target=`"_blank`" rel=`"noopener`">Zakira.Recall</a> &middot; $(HtmlEncode $l.sourceProvider)$(if ($l.sourceConfidence) { ' &middot; ' + (HtmlEncode $l.sourceConfidence) + ' confidence' } else { '' })</span>"
                    }
                    [void]$sectionsHtml.AppendLine(
                        '<li><span class="link-kind">' + (HtmlEncode $kg.Name) + '</span>' +
                        '<a href="' + (HtmlEncode $l.url) + '" target="_blank" rel="noopener">' + (HtmlEncode $label) + '</a>' +
                        '<span class="source-badge" data-src="' + (HtmlEncode $l.source) + '">' + (HtmlEncode $srcLabel) + '</span>' +
                        $srcDetail + '</li>')
                }
                [void]$sectionsHtml.AppendLine('</ul>')
            }
            [void]$sectionsHtml.AppendLine('</section>')
        }

        # Code snippets section (only when at least one snippet exists).
        $snippets = @($e.codeSnippets)
        if ($snippets.Count -gt 0) {
            [void]$sectionsHtml.AppendLine('<section class="entity-section"><h2>Code snippets (from transcripts)</h2>')
            foreach ($s in $snippets) {
                $lang = if ($s.language) { $s.language } else { 'plaintext' }
                $cap  = if ($s.sourceSession) {
                    "$(HtmlEncode $s.sourceSession)$(if ($s.sourceTime) { ' @ ' + (HtmlEncode $s.sourceTime) } else { '' }) - <em>" + (HtmlEncode $lang) + '</em>'
                } else {
                    '<em>' + (HtmlEncode $lang) + '</em>'
                }
                [void]$sectionsHtml.AppendLine(
                    '<figure class="entity-snippet"><figcaption>' + $cap + '</figcaption><pre><code>' + (HtmlEncode $s.code) + '</code></pre></figure>')
            }
            [void]$sectionsHtml.AppendLine('</section>')
        }

        # Sessions section: per-mention card.
        $entityMentions = if ($annMentionsByEntity.ContainsKey($e.id)) { $annMentionsByEntity[$e.id].ToArray() } else { @() }
        if ($entityMentions.Count -gt 0) {
            [void]$sectionsHtml.AppendLine('<section class="entity-section"><h2>Sessions (' + $entityMentions.Count + ')</h2><ul class="mention-list">')
            foreach ($mn in ($entityMentions | Sort-Object sessionCode, timestampSeconds)) {
                $sObj = $sessionByCode[$mn.sessionCode]
                $sessTitle = if ($sObj) { $sObj.title } else { $mn.sessionTitle }
                $sessSpeakers = if ($sObj -and $sObj.speakerNames) { $sObj.speakerNames } else { ($mn.speakers -join ', ') }
                $tsSec = [int]$mn.timestampSeconds
                # Deep-link to the session page; session.js's video player
                # supports #t=<seconds> for click-to-seek (commit 313aabe8).
                $watchHref = "../sessions/$(HtmlEncode $mn.sessionCode).html#t=$tsSec"
                $sessHref  = "../sessions/$(HtmlEncode $mn.sessionCode).html"
                $framesHtml = Render-MentionFrames $mn

                $cardSb = [System.Text.StringBuilder]::new()
                [void]$cardSb.AppendLine('<li class="mention-card">')
                [void]$cardSb.AppendLine('  <div class="mention-card-head"><a href="' + $sessHref + '"><strong>' + (HtmlEncode $mn.sessionCode) + '</strong></a><span class="mention-ts">' + (HtmlEncode $mn.timestamp) + '</span></div>')
                [void]$cardSb.AppendLine('  <a href="' + $sessHref + '" class="mention-title">' + (HtmlEncode $sessTitle) + '</a>')
                if ($sessSpeakers) {
                    [void]$cardSb.AppendLine('  <div class="mention-speakers">' + (HtmlEncode $sessSpeakers) + '</div>')
                }
                if ($framesHtml) { [void]$cardSb.AppendLine('  ' + $framesHtml) }
                $descBody = if ($mn.longDescription) { $mn.longDescription } else { $mn.shortDescription }
                if ($descBody) {
                    [void]$cardSb.AppendLine('  <p class="mention-desc">' + (HtmlEncode $descBody) + '</p>')
                }
                [void]$cardSb.AppendLine('  <div class="mention-actions">')
                [void]$cardSb.AppendLine('    <a href="' + $watchHref + '" title="Open the session and seek the video to ' + (HtmlEncode $mn.timestamp) + '">Watch from ' + (HtmlEncode $mn.timestamp) + '</a>')
                [void]$cardSb.AppendLine('    <a href="' + $sessHref + '">Open session</a>')
                [void]$cardSb.AppendLine('  </div>')
                [void]$cardSb.AppendLine('</li>')
                [void]$sectionsHtml.AppendLine($cardSb.ToString())
            }
            [void]$sectionsHtml.AppendLine('</ul></section>')
        }

        # If we ended up with no sections (no description, links, snippets,
        # mentions) - still render an empty placeholder so the page is valid.
        if ($sectionsHtml.Length -eq 0) {
            [void]$sectionsHtml.AppendLine('<section class="entity-section"><p>No additional details captured for this announcement yet.</p></section>')
        }

        $entityPageBody = Render-Template $entityBody @{
            CATEGORY            = HtmlEncode $catLbl
            CATEGORY_SLUG       = HtmlEncode $catSlug
            CANONICAL_NAME      = HtmlEncode $e.canonicalName
            TAGLINE_HTML        = HtmlEncode $e.tagline
            HEADER_BADGES_HTML  = $headerBadgesHtml
            STATS_HTML          = ($stats -join "`n")
            ALIASES_HTML        = $aliasesHtml
            SECTIONS_HTML       = $sectionsHtml.ToString()
        }
        $entityPageHtml = Render-Template $layoutTpl @{
            TITLE          = (HtmlEncode "$($e.canonicalName) - $Conference $EventId announcements")
            ASSETS_PREFIX  = '../'
            BREADCRUMB     = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                             "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                             "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; " +
                             "<a href=`"index.html`">Announcements</a> &raquo; " +
                             (HtmlEncode $e.canonicalName) + "</nav>"
            HEADER_TITLE   = (HtmlEncode $e.canonicalName)
            NAV_HTML       = '<nav><a href="index.html">All announcements</a><a href="../index.html">All sessions</a></nav>'
            SOURCE_NOTE    = " from <code>catalog/$(HtmlEncode $Conference)/$(HtmlEncode $EventId)/announcements/entities-enriched.json</code>"
            EXTRA_HEAD     = ''
            BODY           = $entityPageBody
            GENERATED_AT   = HtmlEncode $generatedAt
        }
        Set-Content -LiteralPath (Join-Path $annRoot ($slug + '.html')) -Value $entityPageHtml -Encoding utf8
    }

    Write-Host "Wrote announcements view:" -ForegroundColor Cyan
    Write-Host "  landing:     $(Join-Path $annRoot 'index.html')"
    Write-Host "  entities:    $($annEntities.Count) under $annRoot\<slug>.html"
    Write-Host "  catalog:     $(Join-Path $OutputRoot 'announcement-catalog.json')"
    Write-Host "  search idx:  $(Join-Path $OutputRoot 'announcement-search-index.json')"
}

# --------------------------------------------------------------------------
# Per-conference landing page at docs/<Conference>/index.html.
#
# Scans every docs/<Conference>/<year>/ that looks like a built event and
# renders a year list. Always (re)written whenever Build-Book.ps1 runs;
# pulling stale years out of the catalog requires manually deleting the
# corresponding docs/<Conference>/<year>/ folder before re-running.
# --------------------------------------------------------------------------

$years = Get-ChildItem -LiteralPath $conferenceRoot -Directory -ErrorAction SilentlyContinue |
    Where-Object {
        (Test-Path -LiteralPath (Join-Path $_.FullName 'index.html')) -and
        (Test-Path -LiteralPath (Join-Path $_.FullName 'catalog.json'))
    } |
    Sort-Object Name -Descending

$yearCards = foreach ($yd in $years) {
    $cat = try { Get-Content -Raw -LiteralPath (Join-Path $yd.FullName 'catalog.json') | ConvertFrom-Json } catch { $null }
    $count = if ($cat -and $cat.total) { $cat.total } else { '?' }
    $genAtRaw = if ($cat -and $cat.generatedAt) { $cat.generatedAt } else { $null }
    $genAt = if ($genAtRaw -is [datetime]) {
        $genAtRaw.ToUniversalTime().ToString("yyyy-MM-dd HH:mm 'UTC'")
    } elseif ($genAtRaw) { "$genAtRaw" } else { '' }
    @"
<li class="year-card">
    <a href="$(HtmlEncode $yd.Name)/index.html">
        <strong>$(HtmlEncode $Conference) $(HtmlEncode $yd.Name)</strong>
        <span>$count session(s)</span>
        <small>Rendered $(HtmlEncode $genAt)</small>
    </a>
</li>
"@
}

$conferenceBody = @"
<section class="hero">
    <h2>$(HtmlEncode $Conference) sessions</h2>
    <p>A community-maintained reference of $(HtmlEncode $Conference) conference sessions: transcripts, AI summaries, sampled frames, speakers, and links back to the canonical session page. Pick an event year to browse.</p>
</section>

<ul class="year-list">
$($yearCards -join "`n")
</ul>
"@

$conferenceHtml = Render-Template $layoutTpl @{
    TITLE          = "$Conference - Conference Library"
    # Reuse the newest year's assets (vendored Lunr/CSS/JS are identical).
    ASSETS_PREFIX  = if ($years.Count -gt 0) { "$($years[0].Name)/" } else { "$EventId/" }
    BREADCRUMB     = '<nav class="breadcrumb"><a href="../index.html">Conference Library</a> &raquo; ' +
                     "$(HtmlEncode $Conference)</nav>"
    HEADER_TITLE   = "$(HtmlEncode $Conference)"
    NAV_HTML       = ''
    SOURCE_NOTE    = ''
    EXTRA_HEAD     = ''
    BODY           = $conferenceBody
    GENERATED_AT   = HtmlEncode $generatedAt
}
Set-Content -LiteralPath (Join-Path $conferenceRoot 'index.html') -Value $conferenceHtml -Encoding utf8

# --------------------------------------------------------------------------
# Multi-conference landing page at docs/index.html.
#
# Scans every docs/<Conference>/ that has its own index.html and renders a
# top-level card per conference. Multi-year totals across each conference are
# summed for the card subtitle.
# --------------------------------------------------------------------------

$confDirs = Get-ChildItem -LiteralPath $docsRoot -Directory -ErrorAction SilentlyContinue |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'index.html') } |
    Sort-Object Name

$confCards = foreach ($cd in $confDirs) {
    $confYears = Get-ChildItem -LiteralPath $cd.FullName -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'catalog.json') }
    $totalSessions = 0
    foreach ($yd in $confYears) {
        $cat = try { Get-Content -Raw -LiteralPath (Join-Path $yd.FullName 'catalog.json') | ConvertFrom-Json } catch { $null }
        if ($cat -and $cat.total) { $totalSessions += [int]$cat.total }
    }
    $yearsLabel = if ($confYears.Count -eq 1) {
        "$($confYears.Count) year"
    } else { "$($confYears.Count) years" }
    @"
<li class="year-card">
    <a href="$(HtmlEncode $cd.Name)/index.html">
        <strong>$(HtmlEncode $cd.Name)</strong>
        <span>$yearsLabel &middot; $totalSessions session(s) total</span>
        <small>$($confYears | ForEach-Object { HtmlEncode $_.Name } | Sort-Object -Descending | Select-Object -First 3 | Join-String -Separator ', ')</small>
    </a>
</li>
"@
}

$rootBody = @"
<section class="hero">
    <h2>Conference Library</h2>
    <p>A community-maintained reference of conference sessions: transcripts, AI summaries, sampled frames, and speakers. Pick a conference to browse.</p>
</section>

<ul class="year-list">
$($confCards -join "`n")
</ul>
"@

$rootHtml = Render-Template $layoutTpl @{
    TITLE          = 'Conference Library'
    ASSETS_PREFIX  = if ($confDirs.Count -gt 0 -and $years.Count -gt 0) {
                         # The styles are identical across all rendered events;
                         # pick whatever per-event assets folder is most recent.
                         "$($confDirs[0].Name)/$($years[0].Name)/"
                     } else { "$Conference/$EventId/" }
    BREADCRUMB     = ''
    HEADER_TITLE   = 'Conference Library'
    NAV_HTML       = ''
    SOURCE_NOTE    = ''
    EXTRA_HEAD     = ''
    BODY           = $rootBody
    GENERATED_AT   = HtmlEncode $generatedAt
}
Set-Content -LiteralPath (Join-Path $docsRoot 'index.html') -Value $rootHtml -Encoding utf8

# --------------------------------------------------------------------------
# Done.
# --------------------------------------------------------------------------

Write-Host ''
Write-Host "Rendered $rendered session page(s) (skipped $skipped without rich-manifest.json)." -ForegroundColor Green
Write-Host "  per-event index:    $(Join-Path $OutputRoot 'index.html')"
Write-Host "  search-index.json:  $(Join-Path $OutputRoot 'search-index.json')"
Write-Host "  per-session pages:  $(Join-Path $OutputRoot 'sessions')"
Write-Host "  conference landing: $(Join-Path $conferenceRoot 'index.html') ($($years.Count) year(s) listed)"
Write-Host "  library root:       $(Join-Path $docsRoot 'index.html') ($($confDirs.Count) conference(s) listed)"
Write-Host ''
Write-Host "To preview locally:" -ForegroundColor Cyan
Write-Host "  python -m http.server 8080 -d `"$docsRoot`""
Write-Host "  then open http://localhost:8080/"
