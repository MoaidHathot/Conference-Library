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

    # Absolute base URL of the deployed site. Used to build canonical
    # og:url and og:image attributes (social sharing previews need absolute
    # URLs; relative paths don't render in Twitter / Slack / Discord cards).
    # Override for staging deployments or custom domains.
    [Parameter()][string]$SiteBaseUrl = 'https://moaidhathot.github.io/Conference-Library',

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
$eventHubBody    = if (Test-Path -LiteralPath (Join-Path $templatesRoot 'event-hub.body.html')) {
    Get-Content -Raw -LiteralPath (Join-Path $templatesRoot 'event-hub.body.html')
} else { $null }
# Speakers view templates (optional - silently skipped when missing, the
# Resolve-Speakers.ps1 step is a sibling-of-announcements opt-in).
$speakersIndexBody = if (Test-Path -LiteralPath (Join-Path $templatesRoot 'speakers-index.body.html')) {
    Get-Content -Raw -LiteralPath (Join-Path $templatesRoot 'speakers-index.body.html')
} else { $null }
$speakerBody       = if (Test-Path -LiteralPath (Join-Path $templatesRoot 'speaker.body.html')) {
    Get-Content -Raw -LiteralPath (Join-Path $templatesRoot 'speaker.body.html')
} else { $null }
# Themes view templates (optional, mirrors the speakers shape; Resolve-
# Themes.ps1 generates the data, opt-in per event).
$themesIndexBody = if (Test-Path -LiteralPath (Join-Path $templatesRoot 'themes-index.body.html')) {
    Get-Content -Raw -LiteralPath (Join-Path $templatesRoot 'themes-index.body.html')
} else { $null }
$themeBody       = if (Test-Path -LiteralPath (Join-Path $templatesRoot 'theme.body.html')) {
    Get-Content -Raw -LiteralPath (Join-Path $templatesRoot 'theme.body.html')
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

function Build-HeadMeta {
    # Produce the <meta> block of OpenGraph + Twitter card tags. All four
    # values (Title, Description, Url, ImageUrl) are mandatory; Type defaults
    # to 'website' for landing pages and 'article' for content pages.
    # Returns a single rendered HTML string suitable for layout.html's
    # {{HEAD_META_HTML}} slot.
    param(
        [string]$Title,
        [string]$Description,
        [string]$Url,
        [string]$ImageUrl,
        [string]$Type = 'website',
        [string]$SiteName = 'Conference Library'
    )
    # Trim and clamp the description so card renderers don't truncate
    # mid-word. ~200 chars is the safe sweet spot for X, Slack, Discord, FB.
    if ($Description -and $Description.Length -gt 200) {
        $cut = $Description.Substring(0, 197)
        $lastSpace = $cut.LastIndexOf(' ')
        if ($lastSpace -gt 150) { $cut = $cut.Substring(0, $lastSpace) }
        $Description = $cut.Trim() + '...'
    }
    $t = HtmlEncode $Title
    $d = HtmlEncode $Description
    $u = HtmlEncode $Url
    $i = HtmlEncode $ImageUrl
    $s = HtmlEncode $SiteName
    $ty = HtmlEncode $Type
    return @"
    <meta name="description" content="$d">
    <meta property="og:type" content="$ty">
    <meta property="og:site_name" content="$s">
    <meta property="og:title" content="$t">
    <meta property="og:description" content="$d">
    <meta property="og:url" content="$u">
    <meta property="og:image" content="$i">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="$t">
    <meta name="twitter:description" content="$d">
    <meta name="twitter:image" content="$i">
"@
}

function Make-AbsoluteUrl {
    # Join the base URL with a forward-slash path inside docs/. Idempotent
    # on trailing slashes; tolerant of either leading-slash or no-slash
    # input paths.
    param([string]$BaseUrl, [string]$RelPath)
    $b = $BaseUrl.TrimEnd('/')
    $r = $RelPath -replace '\\', '/'
    if ($r.StartsWith('/')) { return "$b$r" }
    return "$b/$r"
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

# --------------------------------------------------------------------------
# Speakers: load Resolve-Speakers.ps1 output. Optional - if missing, the
# speakers landing page + per-speaker pages are silently skipped and per-
# session speaker names render as plain text (the legacy path). When
# present, per-session speaker names become links to their speaker page.
# --------------------------------------------------------------------------

$speakersJsonPath = Join-Path $RepoRoot "catalog\$Conference\$EventId\speakers\speakers.json"
$speakersData       = @()
$speakerById        = @{}
$speakersBySession  = @{}  # sessionCode -> List[{id, name, slug}]
$speakersEnabled    = $false
if ((Test-Path -LiteralPath $speakersJsonPath) -and $speakersIndexBody -and $speakerBody) {
    try {
        $speakersData = @((Get-Content -Raw -LiteralPath $speakersJsonPath | ConvertFrom-Json -Depth 20).speakers)
        foreach ($sp in $speakersData) {
            $speakerById[$sp.id] = $sp
            foreach ($sess in @($sp.sessions)) {
                if (-not $speakersBySession.ContainsKey($sess.code)) {
                    $speakersBySession[$sess.code] = New-Object 'System.Collections.Generic.List[object]'
                }
                $speakersBySession[$sess.code].Add([pscustomobject]@{
                    id   = $sp.id
                    name = $sp.name
                    slug = $sp.slug
                }) | Out-Null
            }
        }
        $speakersEnabled = ($speakersData.Count -gt 0)
        Write-Host "Speakers view enabled: $($speakersData.Count) speaker(s) across $(($speakersBySession.Keys | Measure-Object).Count) attributed session(s)." -ForegroundColor DarkGray
    } catch {
        Write-Warning "Failed to load speakers artifacts ($_); skipping speakers view."
        $speakersEnabled = $false
    }
} else {
    Write-Host "Speakers view disabled (missing speakers.json/templates)." -ForegroundColor DarkGray
}

# --------------------------------------------------------------------------
# Themes: load Resolve-Themes.ps1 output. Optional - if missing, the themes
# landing + per-theme pages are silently skipped and per-session pages render
# without a Themes chip line. When present, each session shows its 1-3 theme
# chips linking to the per-theme page.
# --------------------------------------------------------------------------

$themesJsonPath        = Join-Path $RepoRoot "catalog\$Conference\$EventId\themes\themes.json"
$themeAssignmentsPath  = Join-Path $RepoRoot "catalog\$Conference\$EventId\themes\theme-assignments.json"
$themesData            = @()
$themeBySlug           = @{}
$themesBySession       = @{}   # sessionCode -> List[{slug, name}]
$sessionsByTheme       = @{}   # themeSlug   -> List[{code, title, sessionType, ...}]
$themesEnabled         = $false
if ((Test-Path -LiteralPath $themesJsonPath) -and (Test-Path -LiteralPath $themeAssignmentsPath) -and
    $themesIndexBody -and $themeBody) {
    try {
        $themesData = @((Get-Content -Raw -LiteralPath $themesJsonPath | ConvertFrom-Json -Depth 10).themes)
        foreach ($t in $themesData) { $themeBySlug[$t.slug] = $t }

        $assignments = @((Get-Content -Raw -LiteralPath $themeAssignmentsPath | ConvertFrom-Json -Depth 10).assignments)
        foreach ($a in $assignments) {
            $perSession = New-Object 'System.Collections.Generic.List[object]'
            foreach ($slug in @($a.themes)) {
                $th = $themeBySlug[$slug]
                if (-not $th) { continue }
                $perSession.Add([pscustomobject]@{ slug = $slug; name = $th.name }) | Out-Null

                if (-not $sessionsByTheme.ContainsKey($slug)) {
                    $sessionsByTheme[$slug] = New-Object 'System.Collections.Generic.List[string]'
                }
                $sessionsByTheme[$slug].Add($a.code) | Out-Null
            }
            $themesBySession[$a.code] = $perSession
        }
        $themesEnabled = ($themesData.Count -gt 0)
        $attribSessionCount = ($themesBySession.Keys | Measure-Object).Count
        Write-Host "Themes view enabled: $($themesData.Count) theme(s) across $attribSessionCount attributed session(s)." -ForegroundColor DarkGray
    } catch {
        Write-Warning "Failed to load themes artifacts ($_); skipping themes view."
        $themesEnabled = $false
    }
} else {
    Write-Host "Themes view disabled (missing themes.json/theme-assignments.json/templates)." -ForegroundColor DarkGray
}

# --------------------------------------------------------------------------
# Demo repos: load Resolve-DemoRepos.ps1 output. Optional - per-session
# pages gain a "Session repo" button in their actions row when present.
# The data is keyed by session code; we filter out aka.ms entries that
# bounced through bing.com (Microsoft's shortlink fallthrough for unset
# aka.ms keys) since those aren't real demo repos.
# --------------------------------------------------------------------------

$demoReposJsonPath = Join-Path $RepoRoot "catalog\$Conference\$EventId\demo-repos\demo-repos.json"
$demoRepoBySession = @{}
$demoReposEnabled  = $false
if (Test-Path -LiteralPath $demoReposJsonPath) {
    try {
        $demoRepos = @((Get-Content -Raw -LiteralPath $demoReposJsonPath | ConvertFrom-Json -Depth 10).repos)
        foreach ($d in $demoRepos) {
            $url = if ($d.finalUrl) { $d.finalUrl } else { $d.akaUrl }
            # Skip bing.com fallthroughs (aka.ms shortlinks that aren't set)
            if ($url -match '://www\.bing\.com/?(?:\?|$)') { continue }
            $demoRepoBySession[$d.code] = [pscustomobject]@{
                url         = $url
                akaUrl      = $d.akaUrl
                title       = $d.title
                sourceTopic = $d.sourceTopic
            }
        }
        $demoReposEnabled = ($demoRepoBySession.Count -gt 0)
        Write-Host "Demo-repos enabled: $($demoRepoBySession.Count) session(s) with a curated repo link." -ForegroundColor DarkGray
    } catch {
        Write-Warning "Failed to load demo-repos artifacts ($_); skipping demo-repo links."
        $demoReposEnabled = $false
    }
} else {
    Write-Host "Demo-repos disabled (missing demo-repos.json; run scripts/Resolve-DemoRepos.ps1)." -ForegroundColor DarkGray
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

# Site-level default og:image URL used when a page doesn't have a more
# specific image to surface. We point at the keynote's first sampled
# frame; KEY01 reliably has frames for every Build event and is the most
# visually-identifiable shot in the catalog. Falls back to an empty
# string if the file doesn't exist - social cards then render text-only.
$keynoteCoverPath = Join-Path $sessionsRoot 'KEY01\frames'
$siteDefaultOgImage = ''
if (Test-Path -LiteralPath $keynoteCoverPath) {
    $firstFrame = Get-ChildItem -LiteralPath $keynoteCoverPath -Filter '*.jpg' -ErrorAction SilentlyContinue | Sort-Object Name | Select-Object -First 1
    if ($firstFrame) {
        $siteDefaultOgImage = Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/frames/KEY01/$($firstFrame.Name)"
    }
}

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
    # Speakers list: when the speakers view is enabled, link each speaker
    # name to its per-speaker page. Order matches the rich-manifest
    # speakerNames left-to-right; unknown names (no matching id) fall
    # through to plain text so the surface degrades gracefully.
    if ($speakersEnabled -and $speakersBySession.ContainsKey($code)) {
        $sessSpeakerObjs = $speakersBySession[$code]
        $speakerParts = foreach ($sp in $sessSpeakerObjs) {
            '<a href="../speakers/' + (HtmlEncode $sp.slug) + '.html">' + (HtmlEncode $sp.name) + '</a>'
        }
        $speakers = $speakerParts -join ', '
    }
    else {
        $speakers = if ($m.speakerNames) { HtmlEncode $m.speakerNames } else { '' }
    }

    # Theme chips: 1-3 theme tags rendered as accent pills, each linking to
    # the per-theme page. Empty <div> emitted when the themes view is on
    # but the session got no assignment (rare; the C# sanity check warns
    # about these). When the themes view is off, the whole block is empty
    # so the template slot collapses without a stray border or margin.
    $themesHtml = ''
    if ($themesEnabled -and $themesBySession.ContainsKey($code)) {
        $themeChips = foreach ($th in $themesBySession[$code]) {
            '<a class="tag tag-theme" href="../themes/' + (HtmlEncode $th.slug) + '.html">' + (HtmlEncode $th.name) + '</a>'
        }
        if ($themeChips.Count -gt 0) {
            $themesHtml = '<div class="session-themes"><span class="session-themes-label">Themes:</span> ' + ($themeChips -join ' ') + '</div>'
        }
    }

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
    if ($demoReposEnabled -and $demoRepoBySession.ContainsKey($code)) {
        # Surface the curated demo repo from microsoft/build26-next-steps as
        # a prominent action button. Goes second so it sits between the
        # canonical session link and the player/transcript actions.
        $repo = $demoRepoBySession[$code]
        $actions += "<a href=`"$(HtmlEncode $repo.url)`" class=`"primary`" target=`"_blank`" rel=`"noopener`" title=`"Demo / lab repo curated by Microsoft (aka.ms/build26/$(HtmlEncode $code))`">Session repo</a>"
    }
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

    # Chapter strip rendered right below the player. Cross-origin <track>
    # files would never load (video hosted on medius.microsoft.com, page on
    # github.io; Medius doesn't send the CORS headers needed for HTML5
    # text-track loading). Instead we emit a custom clickable strip that
    # reuses the .ts-play button class - session.js already wires those to
    # seek the embedded video to the timestamp. Works for both the MP4 and
    # HLS player paths; degrades to a static list when no <video> is in
    # the page (iframe-only sessions still get the list as a jump-to-
    # canonical-player aid).
    $chaptersHtml = ''
    if ($annEnabled -and $annMentionsBySession.ContainsKey($code) -and $playerHtml) {
        $sessionMentions = $annMentionsBySession[$code].ToArray() |
            Sort-Object @{ Expression = { [int]$_.timestampSeconds } }
        $chapterItems = foreach ($mn in $sessionMentions) {
            # Prefer the raw (session-spoken) name over the canonical entity
            # name; chapters are about what the speaker said in the moment.
            $label = if ($mn.rawName) { $mn.rawName } else { $mn.shortDescription }
            # title= carries both the seek hint AND the full label, so a
            # long mention name that overflows the 2-line CSS clamp on
            # desktop (or wraps awkwardly on mobile) can still be read in
            # the native hover tooltip without leaving the chapters strip.
            $tooltip = "Watch from $($mn.timestamp) (-5s): $label"
            "<li><button type=`"button`" class=`"ts-play chapter-jump`" data-ts=`"$(HtmlEncode $mn.timestamp)`" title=`"$(HtmlEncode $tooltip)`"><span class=`"chapter-ts`">$(HtmlEncode $mn.timestamp)</span><span class=`"chapter-title`">$(HtmlEncode $label)</span></button></li>"
        }
        if ($chapterItems) {
            $chaptersHtml = @"
<section class="chapters" aria-label="Chapter markers">
    <h3>Chapters</h3>
    <ol class="chapter-list">
$($chapterItems -join "`n")
    </ol>
</section>
"@
        }
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
        THEMES_HTML      = $themesHtml
        NOTICE_HTML      = $noticeHtml
        COVER_HTML       = $coverHtml
        PLAYER_HTML      = $playerHtml
        CHAPTERS_HTML    = $chaptersHtml
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

    # OG/Twitter meta values. Title = code + title; description trimmed from
    # the upstream catalog description (best signal we have without re-
    # parsing the summary); image = cover frame if any, else site default;
    # url = absolute deployed URL of this very page.
    $sessionOgUrl   = Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/sessions/$code.html"
    $sessionOgImage = if ($coverName) {
        Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/frames/$code/$coverName"
    } else { $siteDefaultOgImage }
    $sessionOgDesc = if ($m.description) {
        ($m.description -replace '\s+', ' ').Trim()
    } else {
        "$Conference $EventId session $code"
    }

    $pageHtml = Render-Template $layoutTpl @{
        TITLE             = (HtmlEncode "$code - $($m.title)")
        ASSETS_PREFIX     = '../'
        HEAD_META_HTML    = Build-HeadMeta -Title "$code - $($m.title)" -Description $sessionOgDesc -Url $sessionOgUrl -ImageUrl $sessionOgImage -Type 'article'
        # After the hub redesign the per-event root is the hub, and the
        # sessions catalog lives at sessions/index.html alongside the
        # per-session pages. Breadcrumb adds a Sessions level so visitors
        # can step back to either the catalog or the hub.
        BREADCRUMB        = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                            "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                            "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; " +
                            "<a href=`"index.html`">Sessions</a> &raquo; " +
                            "$(HtmlEncode $code)</nav>"
        HEADER_TITLE      = "$(HtmlEncode $code) &mdash; $(HtmlEncode $m.title)"
        NAV_HTML          = '<nav><a href="index.html">All sessions</a>' +
                            $(if ($annEnabled) { '<a href="../announcements/index.html">Announcements</a>' } else { '' }) +
                            $(if ($speakersEnabled) { '<a href="../speakers/index.html">Speakers</a>' } else { '' }) +
                            $(if ($themesEnabled) { '<a href="../themes/index.html">Themes</a>' } else { '' }) +
                            '<a href="../index.html">Event hub</a>' +
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
    # Themes attached to this session by Resolve-Themes (1-3 names per
    # session). Surfaces in the catalog so app.js can render a Themes pill
    # group and let users filter the catalog without leaving for the
    # per-theme landings.
    $themesArr = @(if ($themesEnabled -and $themesBySession.ContainsKey($code)) {
                       $themesBySession[$code] | ForEach-Object { "$($_.name)" }
                   })
    # Demo-repo signal: drives the "Repo" badge on the session card and
    # (eventually) a "Has demo repo" filter pill. demoRepoUrl is null when
    # the session isn't in the curated microsoft/build26-next-steps list.
    $sessionDemoRepoUrl = if ($demoReposEnabled -and $demoRepoBySession.ContainsKey($code)) {
                              $demoRepoBySession[$code].url
                          } else { $null }

    $indexCatalog.Add([pscustomobject]@{
        code          = $code
        title         = $m.title
        sessionType   = $m.sessionType
        speakerNames  = $m.speakerNames
        tags          = $tagsArr
        topics        = $topicsArr
        themes        = $themesArr
        startDateTime = $startIso
        endDateTime   = $endIso
        durationMins  = $m.durationMinutes
        # True when the session has any kind of playable artifact: a video
        # URL the iframe/<video> can load, OR captured frames, OR a
        # transcript. Drives the "Recorded only" toggle on the index page,
        # which hides ~233 by-design unrecorded sessions (Table Talks, Labs,
        # Lightning Talks) from the default view.
        hasVideo      = [bool]($hasAnyVideo -or $hasTranscript -or $framesArr.Count -gt 0)
        hasDemoRepo   = [bool]$sessionDemoRepoUrl
        demoRepoUrl   = $sessionDemoRepoUrl
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
# Sessions catalog (the page that lists every session card, with filter
# pills + Lunr-powered search). After the hub redesign this lives at
# /Build/2026/sessions/index.html alongside the per-session pages, NOT at
# /Build/2026/index.html - the per-event root is now the hub (see further
# below).
# --------------------------------------------------------------------------

$sessionsCatalogDir = Join-Path $OutputRoot 'sessions'
New-Item -ItemType Directory -Path $sessionsCatalogDir -Force | Out-Null

$catalogJson = [pscustomobject]@{
    schemaVersion = 1
    eventId       = $EventId
    generatedAt   = $generatedAt
    total         = $indexCatalog.Count
    sessions      = @($indexCatalog | Sort-Object code)
}
$catalogJson | ConvertTo-Json -Depth 6 -Compress | Set-Content -LiteralPath (Join-Path $sessionsCatalogDir 'catalog.json') -Encoding utf8

Build-LunrIndex -Documents $lunrDocs.ToArray() -OutputPath (Join-Path $sessionsCatalogDir 'search-index.json')

# View-switcher: shared tab strip emitted at the top of both catalog
# landings (sessions/index.html and announcements/index.html). Active tab
# highlighted; the other navigates with one click. The hub link returns
# to the per-event root.
$annCount = if ($annEnabled) { $annEntities.Count } else { 0 }
$speakersCount = if ($speakersEnabled) { $speakersData.Count } else { 0 }
$themesCount = if ($themesEnabled) { $themesData.Count } else { 0 }
function Render-ViewSwitcher {
    param([string]$Active)   # 'sessions' | 'announcements' | 'speakers' | 'themes'
    $sCount = $script:indexCatalog.Count
    $aCount = $script:annCount
    $pCount = $script:speakersCount
    $tCount = $script:themesCount
    $sActive = if ($Active -eq 'sessions')      { ' is-active' } else { '' }
    $aActive = if ($Active -eq 'announcements') { ' is-active' } else { '' }
    $pActive = if ($Active -eq 'speakers')      { ' is-active' } else { '' }
    $tActive = if ($Active -eq 'themes')        { ' is-active' } else { '' }
    $aTab = if ($script:annEnabled) {
        "<a href=`"../announcements/index.html`" class=`"view-switcher-tab$aActive`">Announcements <span class=`"view-switcher-count`">$aCount</span></a>"
    } else { '' }
    $pTab = if ($script:speakersEnabled) {
        "<a href=`"../speakers/index.html`" class=`"view-switcher-tab$pActive`">Speakers <span class=`"view-switcher-count`">$pCount</span></a>"
    } else { '' }
    $tTab = if ($script:themesEnabled) {
        "<a href=`"../themes/index.html`" class=`"view-switcher-tab$tActive`">Themes <span class=`"view-switcher-count`">$tCount</span></a>"
    } else { '' }
    return @"
<nav class="view-switcher" aria-label="Browse mode">
    <a href="../index.html" class="view-switcher-home">&larr; Event hub</a>
    <a href="../sessions/index.html" class="view-switcher-tab$sActive">Sessions <span class="view-switcher-count">$sCount</span></a>
    $aTab
    $pTab
    $tTab
</nav>
"@
}

$sessionsIndexBody = Render-Template $indexBody @{
    HERO_HEADING        = (HtmlEncode "$Conference $EventId sessions")
    TOTAL_COUNT         = if ($indexCatalog.Count -eq 1) { '1 session' } else { "$($indexCatalog.Count) sessions" }
    VIEW_SWITCHER_HTML  = Render-ViewSwitcher -Active 'sessions'
}
$sessionsIndexHtml = Render-Template $layoutTpl @{
    TITLE          = "Sessions - $Conference $EventId - Conference Library"
    ASSETS_PREFIX  = '../'
    HEAD_META_HTML = Build-HeadMeta `
        -Title "Sessions - $Conference $EventId" `
        -Description "All $($indexCatalog.Count) $Conference $EventId sessions with full transcripts, AI summaries, sampled frames, and click-to-seek video. Filter by type, status, tags, topics. Lunr full-text search." `
        -Url (Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/sessions/") `
        -ImageUrl $siteDefaultOgImage
    BREADCRUMB     = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                     "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                     "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; Sessions</nav>"
    HEADER_TITLE   = "$(HtmlEncode $Conference) $(HtmlEncode $EventId) &mdash; Sessions"
    NAV_HTML       = '<nav>' + $(if ($annEnabled) { '<a href="../announcements/index.html">Announcements</a>' } else { '' }) +
                     $(if ($speakersEnabled) { '<a href="../speakers/index.html">Speakers</a>' } else { '' }) +
                     $(if ($themesEnabled) { '<a href="../themes/index.html">Themes</a>' } else { '' }) +
                     '<a href="../index.html">Event hub</a></nav>'
    SOURCE_NOTE    = " from <code>sessions/$(HtmlEncode $Conference)/$(HtmlEncode $EventId)/&lt;CODE&gt;/rich-manifest.json</code>"
    EXTRA_HEAD     = ''
    BODY           = $sessionsIndexBody
    GENERATED_AT   = HtmlEncode $generatedAt
}
Set-Content -LiteralPath (Join-Path $sessionsCatalogDir 'index.html') -Value $sessionsIndexHtml -Encoding utf8

# --------------------------------------------------------------------------
# Per-event HUB page at /<Conf>/<Event>/index.html. Two co-equal entry
# points (Sessions, Announcements) plus a federated search box that
# queries a slim merged catalog (hub-catalog.json) of all sessions +
# all canonical entities. The hub-catalog is generated below from the
# in-memory $indexCatalog + $annEntities, so it always reflects the
# current event state without a separate pass.
# --------------------------------------------------------------------------

if ($eventHubBody) {
    # Build a slim merged catalog for the hub-level federated search. We
    # include the minimal fields needed to render a result card and a
    # flattened searchableText blob the JS can substring-filter against.
    $hubItems = New-Object 'System.Collections.Generic.List[object]'

    foreach ($s in ($indexCatalog | Sort-Object code)) {
        $tagsStr   = if ($s.tags)   { (@($s.tags)   -join ' ') } else { '' }
        $topicsStr = if ($s.topics) { (@($s.topics) -join ' ') } else { '' }
        $hubItems.Add([pscustomobject][ordered]@{
            id             = "session:$($s.code)"
            type           = 'session'
            url            = "sessions/$($s.code).html"
            title          = "$($s.code) - $($s.title)"
            subtitle       = if ($s.speakerNames) { "$($s.speakerNames)" } else { '' }
            searchableText = "$($s.code) $($s.title) $($s.speakerNames) $tagsStr $topicsStr $($s.sessionType)"
        }) | Out-Null
    }

    if ($annEnabled) {
        foreach ($e in $annEntities) {
            $slug = EntitySlug $e.id
            $aliasesStr = if ($e.aliases) { (@($e.aliases) -join ' ') } else { '' }
            $hubItems.Add([pscustomobject][ordered]@{
                id             = $e.id
                type           = 'announcement'
                url            = "announcements/$slug.html"
                title          = "$($e.canonicalName)"
                subtitle       = "$(CategoryLabel $e.category) &middot; $($e.mentionCount) mention$(if ($e.mentionCount -eq 1) { '' } else { 's' })"
                searchableText = "$($e.canonicalName) $aliasesStr $($e.category) $($e.tagline)"
            }) | Out-Null
        }
    }

    if ($speakersEnabled) {
        foreach ($sp in $speakersData) {
            $variantsStr = if ($sp.nameVariants) { (@($sp.nameVariants) -join ' ') } else { '' }
            $tagsStr     = if ($sp.tags)         { (@($sp.tags)         -join ' ') } else { '' }
            $sessionsPlural = if ($sp.sessionCount -eq 1) { '' } else { 's' }
            $hubItems.Add([pscustomobject][ordered]@{
                id             = $sp.id
                type           = 'speaker'
                url            = "speakers/$($sp.slug).html"
                title          = "$($sp.name)"
                subtitle       = "Speaker &middot; $($sp.sessionCount) session$sessionsPlural"
                searchableText = "$($sp.name) $variantsStr $tagsStr"
            }) | Out-Null
        }
    }

    if ($themesEnabled) {
        foreach ($t in $themesData) {
            $themePlural = if ($t.sessionCount -eq 1) { '' } else { 's' }
            $hubItems.Add([pscustomobject][ordered]@{
                id             = "theme:$($t.slug)"
                type           = 'theme'
                url            = "themes/$($t.slug).html"
                title          = "$($t.name)"
                subtitle       = "Theme &middot; $($t.sessionCount) session$themePlural"
                searchableText = "$($t.name) $($t.description)"
            }) | Out-Null
        }
    }

    $hubCatalogDoc = [pscustomobject]@{
        schemaVersion = 1
        conference    = $Conference
        eventId       = $EventId
        generatedAt   = $generatedAt
        sessionCount  = $indexCatalog.Count
        annCount      = $annCount
        items         = $hubItems.ToArray()
    }
    $hubCatalogDoc | ConvertTo-Json -Depth 6 -Compress |
        Set-Content -LiteralPath (Join-Path $OutputRoot 'hub-catalog.json') -Encoding utf8

    # Hero context paragraph: tweak the wording here without re-rendering
    # the entire template every time.
    $hubContext = "A community-maintained reference of $(HtmlEncode $Conference) $(HtmlEncode $EventId): full transcripts, AI-generated summaries, sampled frames, click-to-seek video for every session, and a cross-session catalog of every product / SDK / framework / service / model announced, with curated GitHub, learn.microsoft.com, NuGet, and blog links. Two views into the same source data &mdash; browse session-by-session, or by announcement."

    # Card descriptions (HTML, rendered into the body). The hub cards used
    # to also carry a 5-bullet feature list per card, but on medium-small
    # laptops (~1280-1440px) the 4-up grid + tall feature list made each
    # card narrow and visually squeezed. The description paragraph already
    # explains what each landing contains, so we just emit `label + stat +
    # desc + CTA` and let the breakpoint changes in style.css keep the
    # 4th card on its own full-width row below 1500px.

    $sessionWith    = ($annMentionsBySession.Keys | Measure-Object).Count
    $sessionDesc    = "Every $Conference $EventId session, indexed end-to-end. Browse $($indexCatalog.Count) sessions, of which $sessionWith have at least one extracted key announcement. Each session page links to its canonical source on $Conference.microsoft.com."
    $announcementDesc = if ($annEnabled) {
        "Every standalone announcement extracted from the $sessionWith sessions that surfaced product/SDK/service news. $annCount canonical entities (after alias-folding $($annEntities.Count) raw entries) with curated external links, source-session deep-links, and category filters."
    } else {
        "The announcements pipeline hasn't been run for this event yet."
    }

    # Speakers card HTML: only emitted when the speakers view is enabled,
    # so the hub-card-grid-secondary stays clean (no empty slot) on events
    # that haven't been resolved yet. The card carries the hub-card-secondary
    # modifier so it picks up the compact horizontal layout + muted treatment
    # defined in style.css; no description paragraph (the muted compact
    # tile only carries label + stat + arrow CTA).
    $speakerCardHtml = ''
    if ($speakersEnabled) {
        $speakerCardHtml = @"
<li class="hub-card hub-card-secondary hub-card-speakers">
    <a href="speakers/index.html">
        <div class="hub-card-head">
            <span class="hub-card-label">Speakers</span>
            <span class="hub-card-stat">$($speakersData.Count)</span>
        </div>
        <span class="hub-card-cta">Browse &rarr;</span>
    </a>
</li>
"@
    }

    # Themes card HTML: only emitted when themes have been resolved. Same
    # secondary-tile treatment as speakers above.
    $themeCardHtml = ''
    if ($themesEnabled) {
        $themeCardHtml = @"
<li class="hub-card hub-card-secondary hub-card-themes">
    <a href="themes/index.html">
        <div class="hub-card-head">
            <span class="hub-card-label">Themes</span>
            <span class="hub-card-stat">$($themesData.Count)</span>
        </div>
        <span class="hub-card-cta">Browse &rarr;</span>
    </a>
</li>
"@
    }

    # Build the hub search placeholder dynamically based on which views
    # are enabled, so an event without one or more of {announcements,
    # speakers, themes} doesn't read awkwardly ("Search ... and 0 X...").
    $hubSearchParts = @("$($indexCatalog.Count) sessions")
    if ($annEnabled)      { $hubSearchParts += "$annCount announcements" }
    if ($speakersEnabled) { $hubSearchParts += "$($speakersData.Count) speakers" }
    if ($themesEnabled)   { $hubSearchParts += "$($themesData.Count) themes" }
    $hubSearchPlaceholder = if ($hubSearchParts.Count -gt 1) {
        $last = $hubSearchParts[-1]
        $rest = $hubSearchParts[0..($hubSearchParts.Count - 2)] -join ', '
        "Search $rest, and $last..."
    } else {
        "Search $($hubSearchParts[0])..."
    }

    $hubBody = Render-Template $eventHubBody @{
        HERO_HEADING            = (HtmlEncode "$Conference $EventId")
        HUB_CONTEXT_HTML        = $hubContext
        HUB_SEARCH_PLACEHOLDER  = (HtmlEncode $hubSearchPlaceholder)
        SESSION_COUNT           = "$($indexCatalog.Count)"
        SESSION_CARD_DESC       = (HtmlEncode $sessionDesc)
        ANNOUNCEMENT_COUNT      = "$annCount"
        ANNOUNCEMENT_CARD_DESC  = (HtmlEncode $announcementDesc)
        SPEAKER_CARD_HTML       = $speakerCardHtml
        THEME_CARD_HTML         = $themeCardHtml
    }

    $hubHtml = Render-Template $layoutTpl @{
        TITLE          = "$Conference $EventId - Conference Library"
        ASSETS_PREFIX  = ''
        HEAD_META_HTML = Build-HeadMeta `
            -Title "$Conference $EventId" `
            -Description "$($indexCatalog.Count) sessions + $annCount announcements from $Conference $EventId. Full transcripts, AI summaries, sampled frames, click-to-seek video, and a cross-session catalog of every product, SDK, framework, service, and model announced with curated GitHub, docs, and NuGet links." `
            -Url (Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/") `
            -ImageUrl $siteDefaultOgImage
        BREADCRUMB     = '<nav class="breadcrumb"><a href="../../index.html">Conference Library</a> &raquo; ' +
                         "<a href=`"../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                         "$(HtmlEncode $EventId)</nav>"
        HEADER_TITLE   = "$(HtmlEncode $Conference) $(HtmlEncode $EventId)"
        NAV_HTML       = '<nav><a href="sessions/index.html">Sessions</a>' +
                         $(if ($annEnabled) { '<a href="announcements/index.html">Announcements</a>' } else { '' }) +
                         $(if ($speakersEnabled) { '<a href="speakers/index.html">Speakers</a>' } else { '' }) +
                         $(if ($themesEnabled) { '<a href="themes/index.html">Themes</a>' } else { '' }) +
                         '</nav>'
        SOURCE_NOTE    = ''
        EXTRA_HEAD     = ''
        BODY           = $hubBody
        GENERATED_AT   = HtmlEncode $generatedAt
    }
    Set-Content -LiteralPath (Join-Path $OutputRoot 'index.html') -Value $hubHtml -Encoding utf8
} else {
    # Hub template missing - fall back to the old behaviour: per-event root
    # IS the sessions catalog. Keeps the renderer functional during partial
    # template upgrades.
    Copy-Item -LiteralPath (Join-Path $sessionsCatalogDir 'index.html') -Destination (Join-Path $OutputRoot 'index.html') -Force
}

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
        HERO_HEADING        = (HtmlEncode "$Conference $EventId announcements")
        TOTAL_COUNT         = if ($annEntities.Count -eq 1) { '1 announcement' } else { "$($annEntities.Count) announcements" }
        SESSION_COUNT       = $annSessionsCovered
        VIEW_SWITCHER_HTML  = Render-ViewSwitcher -Active 'announcements'
    }
    $annLandingPage = Render-Template $layoutTpl @{
        TITLE          = "Announcements - $Conference $EventId"
        ASSETS_PREFIX  = '../'
        HEAD_META_HTML = Build-HeadMeta `
            -Title "Announcements - $Conference $EventId" `
            -Description "$annCount canonical announcements (products, services, SDKs, frameworks, models, hardware, tools, runtimes, features, platforms, and concepts) extracted from $annSessionsCovered $Conference $EventId sessions. Filter by category, search by name, find official GitHub / docs / NuGet links." `
            -Url (Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/announcements/") `
            -ImageUrl $siteDefaultOgImage
        BREADCRUMB     = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                         "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                         "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; Announcements</nav>"
        HEADER_TITLE   = "$(HtmlEncode $Conference) $(HtmlEncode $EventId) &mdash; Announcements"
        NAV_HTML       = '<nav><a href="../sessions/index.html">Sessions</a>' +
                         $(if ($speakersEnabled) { '<a href="../speakers/index.html">Speakers</a>' } else { '' }) +
                         $(if ($themesEnabled) { '<a href="../themes/index.html">Themes</a>' } else { '' }) +
                         '<a href="../index.html">Event hub</a></nav>'
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
        # OG/Twitter image: first announcement-frame from the first
        # session that mentioned this entity. Falls back to the site
        # default keynote frame when the entity has no frames anywhere.
        $entityOgImage = $siteDefaultOgImage
        if ($annMentionsByEntity.ContainsKey($e.id)) {
            $firstMn = $annMentionsByEntity[$e.id].ToArray() |
                Sort-Object @{ Expression = { [int]$_.timestampSeconds } } |
                Where-Object { $_.frames -and @($_.frames).Count -gt 0 } |
                Select-Object -First 1
            if ($firstMn) {
                $framePath = (@($firstMn.frames)[0] -replace '\\', '/')
                $entityOgImage = Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/frames/$($firstMn.sessionCode)/$framePath"
            }
        }

        $entityPageHtml = Render-Template $layoutTpl @{
            TITLE          = (HtmlEncode "$($e.canonicalName) - $Conference $EventId announcements")
            ASSETS_PREFIX  = '../'
            HEAD_META_HTML = Build-HeadMeta `
                -Title "$($e.canonicalName) - $Conference $EventId" `
                -Description ("$($e.tagline)") `
                -Url (Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/announcements/$slug.html") `
                -ImageUrl $entityOgImage `
                -Type 'article'
            BREADCRUMB     = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                             "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                             "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; " +
                             "<a href=`"index.html`">Announcements</a> &raquo; " +
                             (HtmlEncode $e.canonicalName) + "</nav>"
            HEADER_TITLE   = (HtmlEncode $e.canonicalName)
            NAV_HTML       = '<nav><a href="index.html">All announcements</a><a href="../sessions/index.html">All sessions</a>' +
                             $(if ($speakersEnabled) { '<a href="../speakers/index.html">Speakers</a>' } else { '' }) +
                             $(if ($themesEnabled) { '<a href="../themes/index.html">Themes</a>' } else { '' }) +
                             '<a href="../index.html">Event hub</a></nav>'
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
# Speakers view: landing page + one page per resolved speaker +
# speakers-catalog.json + Lunr search index. Mirrors the announcements
# section pattern (slim catalog feeds the index; per-entity render loop
# writes one HTML per speaker). Skipped silently when the Resolve-
# Speakers.ps1 step hasn't been run (see speakersEnabled guard near
# the top).
# --------------------------------------------------------------------------

if ($speakersEnabled) {
    $speakersRoot = Join-Path $OutputRoot 'speakers'
    New-Item -ItemType Directory -Path $speakersRoot -Force | Out-Null

    # ---- slim per-speaker catalog (drives speakers/index.html) ----
    $speakerCatalogItems = foreach ($sp in $speakersData) {
        # Count how many of this speaker's sessions have a real video URL.
        # Drives the "Recorded only" toggle on the speakers index, which
        # hides ~150 speakers whose every session is a by-design unrecorded
        # Table Talk / Lab / Lightning Talk and surfaces the ones with at
        # least one watchable session. Mirrors the same toggle on the
        # sessions catalog. Uses the stricter Resolve-Speakers.ps1 hasVideo
        # (URL-only) rather than the catalog version (which also counts a
        # transcript or sampled frames) - if you can't press play, it
        # shouldn't count as "recorded" here.
        $recordedCount = @($sp.sessions | Where-Object { $_.hasVideo }).Count
        [pscustomobject][ordered]@{
            id                   = $sp.id
            name                 = $sp.name
            slug                 = $sp.slug
            sessionCount         = $sp.sessionCount
            recordedSessionCount = $recordedCount
            hasRecordedSession   = [bool]($recordedCount -gt 0)
            tags                 = $sp.tags
            topics               = $sp.topics
            nameVariants         = $sp.nameVariants
        }
    }
    $speakerCatalogDoc = [pscustomobject]@{
        schemaVersion = 1
        generatedAt   = $generatedAt
        conference    = $Conference
        eventId       = $EventId
        totalSpeakers = $speakersData.Count
        speakers      = @($speakerCatalogItems)
    }
    $speakerCatalogDoc | ConvertTo-Json -Depth 6 -Compress |
        Set-Content -LiteralPath (Join-Path $OutputRoot 'speakers-catalog.json') -Encoding utf8

    # ---- Lunr index over name + name variants + tags ----
    $speakerLunrDocs = New-Object 'System.Collections.Generic.List[object]'
    foreach ($sp in $speakersData) {
        $variantsStr = if ($sp.nameVariants) { (@($sp.nameVariants) -join ' ') } else { '' }
        $tagsStr     = if ($sp.tags)         { (@($sp.tags)         -join ' ') } else { '' }
        $topicsStr   = if ($sp.topics)       { (@($sp.topics)       -join ' ') } else { '' }
        $speakerLunrDocs.Add([pscustomobject]@{
            ref      = $sp.id
            name     = $sp.name
            variants = $variantsStr
            tags     = $tagsStr
            topics   = $topicsStr
        }) | Out-Null
    }
    Build-LunrIndex `
        -Documents $speakerLunrDocs.ToArray() `
        -OutputPath (Join-Path $OutputRoot 'speakers-search-index.json') `
        -Fields ([ordered]@{ name = 12; variants = 8; tags = 4; topics = 4 })

    # ---- landing page (speakers/index.html) ----
    $speakersIndexPage = Render-Template $speakersIndexBody @{
        HERO_HEADING       = (HtmlEncode "$Conference $EventId speakers")
        TOTAL_COUNT        = "$($speakersData.Count)"
        SESSION_COUNT      = "$($indexCatalog.Count)"
        VIEW_SWITCHER_HTML = Render-ViewSwitcher -Active 'speakers'
    }
    $speakersLandingNav = '<nav><a href="../sessions/index.html">Sessions</a>' +
                          $(if ($annEnabled) { '<a href="../announcements/index.html">Announcements</a>' } else { '' }) +
                          $(if ($themesEnabled) { '<a href="../themes/index.html">Themes</a>' } else { '' }) +
                          '<a href="../index.html">Event hub</a></nav>'
    $speakersIndexHtml = Render-Template $layoutTpl @{
        TITLE          = "Speakers - $Conference $EventId - Conference Library"
        ASSETS_PREFIX  = '../'
        HEAD_META_HTML = Build-HeadMeta `
            -Title "Speakers - $Conference $EventId" `
            -Description "$($speakersData.Count) speakers across $($indexCatalog.Count) $Conference $EventId sessions. Search by name, filter by activity (1, 2, 3-4, 5+ sessions) or by tag. Each card links to a per-speaker page with the full session list and a co-presenter graph." `
            -Url (Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/speakers/") `
            -ImageUrl $siteDefaultOgImage
        BREADCRUMB     = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                         "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                         "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; Speakers</nav>"
        HEADER_TITLE   = "$(HtmlEncode $Conference) $(HtmlEncode $EventId) &mdash; Speakers"
        NAV_HTML       = $speakersLandingNav
        SOURCE_NOTE    = " from <code>catalog/$(HtmlEncode $Conference)/$(HtmlEncode $EventId)/speakers/speakers.json</code>"
        EXTRA_HEAD     = ''
        BODY           = $speakersIndexPage
        GENERATED_AT   = HtmlEncode $generatedAt
    }
    Set-Content -LiteralPath (Join-Path $speakersRoot 'index.html') -Value $speakersIndexHtml -Encoding utf8

    # ---- per-speaker pages ----
    # Per-speaker NAV is shared across the whole render loop.
    $speakerPageNav = '<nav><a href="index.html">All speakers</a><a href="../sessions/index.html">All sessions</a>' +
                      $(if ($annEnabled) { '<a href="../announcements/index.html">Announcements</a>' } else { '' }) +
                      $(if ($themesEnabled) { '<a href="../themes/index.html">Themes</a>' } else { '' }) +
                      '<a href="../index.html">Event hub</a></nav>'

    foreach ($sp in $speakersData) {
        # Compose the page sections (sessions list with co-presenters,
        # frequent co-presenters block, tag/topic rollup) into a single
        # SECTIONS_HTML blob. The template itself stays trivial - all
        # variability lives here so we can iterate the page shape without
        # touching speaker.body.html.
        $sectionsSb = [System.Text.StringBuilder]::new()

        # Sessions section: server-rendered card list with per-session
        # co-presenter links inline. Each session links to the per-session
        # page; each co-presenter links to their own per-speaker page.
        # NB: coSpeakers in speakers.json carries {id, name} only -
        # resolve the slug through the in-memory $speakerById registry so
        # the link target is always correct even when a co-presenter has
        # a slug-collision suffix.
        [void]$sectionsSb.AppendLine('<section class="entity-section"><h2>Sessions (' + $sp.sessionCount + ')</h2><ul class="mention-list">')
        foreach ($sess in @($sp.sessions)) {
            $coLinks = @(@($sess.coSpeakers) | ForEach-Object {
                $coSp = $speakerById[$_.id]
                $coSlug = if ($coSp) { $coSp.slug } else { '' }
                if ($coSlug) {
                    '<a href="' + (HtmlEncode $coSlug) + '.html">' + (HtmlEncode $_.name) + '</a>'
                } else {
                    HtmlEncode $_.name
                }
            })
            $coLine = if ($coLinks.Count -gt 0) { 'with ' + ($coLinks -join ', ') } else { 'solo' }
            $whenStr = ''
            if ($sess.startDateTime) {
                try { $whenStr = ([datetime]$sess.startDateTime).ToString('ddd MMM d, HH:mm') } catch { $whenStr = '' }
            }
            $smallParts = @()
            if ($whenStr) { $smallParts += (HtmlEncode $whenStr) }
            if ($sess.sessionType) { $smallParts += (HtmlEncode $sess.sessionType) }
            if ($sess.durationMinutes) { $smallParts += "$($sess.durationMinutes) min" }
            $smallLine = if ($smallParts.Count -gt 0) { '<small>' + ($smallParts -join ' &middot; ') + '</small>' } else { '' }

            [void]$sectionsSb.AppendLine(
                '<li class="mention-card">' +
                  '<div class="mention-card-head"><strong><a href="../sessions/' + (HtmlEncode $sess.code) + '.html">' + (HtmlEncode $sess.code) + ' &mdash; ' + (HtmlEncode $sess.title) + '</a></strong></div>' +
                  '<div class="mention-speakers">' + $coLine + '</div>' +
                  $smallLine +
                '</li>')
        }
        [void]$sectionsSb.AppendLine('</ul></section>')

        # Frequent co-presenters section. ConvertFrom-Json turns the
        # coSpeakerCounts hashtable into a PSCustomObject whose properties
        # carry the per-coId tallies; iterate via PSObject.Properties.
        $coCountsObj = $sp.coSpeakerCounts
        if ($coCountsObj) {
            $coRows = foreach ($p in $coCountsObj.PSObject.Properties) {
                if ($speakerById.ContainsKey($p.Name)) {
                    [pscustomobject]@{ co = $speakerById[$p.Name]; count = [int]$p.Value }
                }
            }
            $coRows = @($coRows) | Sort-Object @{Expression='count'; Descending=$true}, @{Expression={ $_.co.name }}
            if ($coRows.Count -gt 0) {
                [void]$sectionsSb.AppendLine('<section class="entity-section"><h2>Co-presenters (' + $coRows.Count + ')</h2><ul class="link-group">')
                foreach ($r in $coRows) {
                    $countLbl = if ($r.count -eq 1) { '1 joint session' } else { "$($r.count) joint sessions" }
                    [void]$sectionsSb.AppendLine(
                        '<li><span class="link-kind">co</span><a href="' + (HtmlEncode $r.co.slug) + '.html">' + (HtmlEncode $r.co.name) + '</a><span class="source-badge">' + (HtmlEncode $countLbl) + '</span></li>')
                }
                [void]$sectionsSb.AppendLine('</ul></section>')
            }
        }

        # Tag and topic rollup (just labels - the per-speaker page is not
        # itself filterable, but the rollup gives a quick sense of focus).
        $tagsArr   = @($sp.tags)
        $topicsArr = @($sp.topics)
        if ($tagsArr.Count -gt 0 -or $topicsArr.Count -gt 0) {
            [void]$sectionsSb.AppendLine('<section class="entity-section"><h2>Tags &amp; topics</h2>')
            if ($tagsArr.Count -gt 0) {
                $tagPills = ($tagsArr | ForEach-Object { '<span class="tag">' + (HtmlEncode $_) + '</span>' }) -join ' '
                [void]$sectionsSb.AppendLine('<p><strong>Tags:</strong> ' + $tagPills + '</p>')
            }
            if ($topicsArr.Count -gt 0) {
                $topicPills = ($topicsArr | ForEach-Object { '<span class="tag">' + (HtmlEncode $_) + '</span>' }) -join ' '
                [void]$sectionsSb.AppendLine('<p><strong>Topics:</strong> ' + $topicPills + '</p>')
            }
            [void]$sectionsSb.AppendLine('</section>')
        }

        # Header bits: name variants paragraph (only when 2+ spellings)
        # and the stats line above the tagline.
        $variantsArr = @($sp.nameVariants)
        $variantsHtml = ''
        if ($variantsArr.Count -gt 1) {
            $others = @($variantsArr | Where-Object { $_ -ne $sp.name } | ForEach-Object { HtmlEncode $_ })
            if ($others.Count -gt 0) {
                $variantsHtml = '<p class="entity-aliases"><strong>Also seen as:</strong> ' + ($others -join ', ') + '</p>'
            }
        }
        $sessionPlural = if ($sp.sessionCount -eq 1) { '' } else { 's' }
        $statsHtml   = '<span><strong>' + $sp.sessionCount + '</strong> session' + $sessionPlural + '</span>'
        $taglineText = "Presented at $($sp.sessionCount) $Conference $EventId session$sessionPlural."

        $speakerPageBody = Render-Template $speakerBody @{
            CATEGORY_SLUG       = 'speaker'
            CATEGORY            = 'Speaker'
            SPEAKER_NAME        = HtmlEncode $sp.name
            TAGLINE_HTML        = HtmlEncode $taglineText
            STATS_HTML          = $statsHtml
            HEADER_BADGES_HTML  = ''
            NAME_VARIANTS_HTML  = $variantsHtml
            SECTIONS_HTML       = $sectionsSb.ToString()
        }
        $speakerPageHtml = Render-Template $layoutTpl @{
            TITLE          = "$($sp.name) - $Conference $EventId - Conference Library"
            ASSETS_PREFIX  = '../'
            HEAD_META_HTML = Build-HeadMeta `
                -Title "$($sp.name) - $Conference $EventId" `
                -Description "$($sp.name) presented at $($sp.sessionCount) $Conference $EventId session(s). Click any session to watch with full transcript, AI summary, and click-to-seek video." `
                -Url (Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/speakers/$($sp.slug).html") `
                -ImageUrl $siteDefaultOgImage
            BREADCRUMB     = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                             "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                             "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; " +
                             "<a href=`"index.html`">Speakers</a> &raquo; " +
                             (HtmlEncode $sp.name) + "</nav>"
            HEADER_TITLE   = (HtmlEncode $sp.name)
            NAV_HTML       = $speakerPageNav
            SOURCE_NOTE    = " from <code>catalog/$(HtmlEncode $Conference)/$(HtmlEncode $EventId)/speakers/speakers.json</code>"
            EXTRA_HEAD     = ''
            BODY           = $speakerPageBody
            GENERATED_AT   = HtmlEncode $generatedAt
        }
        Set-Content -LiteralPath (Join-Path $speakersRoot ($sp.slug + '.html')) -Value $speakerPageHtml -Encoding utf8
    }

    Write-Host "Wrote speakers view:" -ForegroundColor Cyan
    Write-Host "  landing:     $(Join-Path $speakersRoot 'index.html')"
    Write-Host "  speakers:    $($speakersData.Count) under $speakersRoot\<slug>.html"
    Write-Host "  catalog:     $(Join-Path $OutputRoot 'speakers-catalog.json')"
    Write-Host "  search idx:  $(Join-Path $OutputRoot 'speakers-search-index.json')"
}

# --------------------------------------------------------------------------
# Themes view: landing page + one page per theme + themes-catalog.json +
# Lunr search index. Same shape as the speakers section. Skipped silently
# when Resolve-Themes.ps1 hasn't been run.
# --------------------------------------------------------------------------

if ($themesEnabled) {
    $themesRoot = Join-Path $OutputRoot 'themes'
    New-Item -ItemType Directory -Path $themesRoot -Force | Out-Null

    # ---- slim per-theme catalog (drives themes/index.html) ----
    $themeCatalogItems = foreach ($t in $themesData) {
        [pscustomobject][ordered]@{
            slug         = $t.slug
            name         = $t.name
            description  = $t.description
            sessionCount = $t.sessionCount
        }
    }
    $themeCatalogDoc = [pscustomobject]@{
        schemaVersion = 1
        generatedAt   = $generatedAt
        conference    = $Conference
        eventId       = $EventId
        totalThemes   = $themesData.Count
        themes        = @($themeCatalogItems)
    }
    $themeCatalogDoc | ConvertTo-Json -Depth 5 -Compress |
        Set-Content -LiteralPath (Join-Path $OutputRoot 'themes-catalog.json') -Encoding utf8

    # ---- Lunr index over name + description ----
    $themeLunrDocs = New-Object 'System.Collections.Generic.List[object]'
    foreach ($t in $themesData) {
        $themeLunrDocs.Add([pscustomobject]@{
            ref         = $t.slug
            name        = $t.name
            description = $t.description
        }) | Out-Null
    }
    Build-LunrIndex `
        -Documents $themeLunrDocs.ToArray() `
        -OutputPath (Join-Path $OutputRoot 'themes-search-index.json') `
        -Fields ([ordered]@{ name = 12; description = 4 })

    # ---- landing page (themes/index.html) ----
    $themesIndexPage = Render-Template $themesIndexBody @{
        HERO_HEADING       = (HtmlEncode "$Conference $EventId themes")
        TOTAL_COUNT        = "$($themesData.Count)"
        SESSION_COUNT      = "$($indexCatalog.Count)"
        VIEW_SWITCHER_HTML = Render-ViewSwitcher -Active 'themes'
    }
    $themesLandingNav = '<nav><a href="../sessions/index.html">Sessions</a>' +
                        $(if ($annEnabled) { '<a href="../announcements/index.html">Announcements</a>' } else { '' }) +
                        $(if ($speakersEnabled) { '<a href="../speakers/index.html">Speakers</a>' } else { '' }) +
                        '<a href="../index.html">Event hub</a></nav>'
    $themesIndexHtml = Render-Template $layoutTpl @{
        TITLE          = "Themes - $Conference $EventId - Conference Library"
        ASSETS_PREFIX  = '../'
        HEAD_META_HTML = Build-HeadMeta `
            -Title "Themes - $Conference $EventId" `
            -Description "$($themesData.Count) cross-cutting themes across $($indexCatalog.Count) $Conference $EventId sessions. Topical organisation discovered by Claude Opus in a two-pass aggregation over every session's AI-generated summary." `
            -Url (Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/themes/") `
            -ImageUrl $siteDefaultOgImage
        BREADCRUMB     = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                         "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                         "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; Themes</nav>"
        HEADER_TITLE   = "$(HtmlEncode $Conference) $(HtmlEncode $EventId) &mdash; Themes"
        NAV_HTML       = $themesLandingNav
        SOURCE_NOTE    = " from <code>catalog/$(HtmlEncode $Conference)/$(HtmlEncode $EventId)/themes/themes.json</code>"
        EXTRA_HEAD     = ''
        BODY           = $themesIndexPage
        GENERATED_AT   = HtmlEncode $generatedAt
    }
    Set-Content -LiteralPath (Join-Path $themesRoot 'index.html') -Value $themesIndexHtml -Encoding utf8

    # ---- per-theme pages ----
    # NAV shared across the loop.
    $themePageNav = '<nav><a href="index.html">All themes</a><a href="../sessions/index.html">All sessions</a>' +
                    $(if ($annEnabled) { '<a href="../announcements/index.html">Announcements</a>' } else { '' }) +
                    $(if ($speakersEnabled) { '<a href="../speakers/index.html">Speakers</a>' } else { '' }) +
                    '<a href="../index.html">Event hub</a></nav>'

    # Build a lookup for the slim per-session shape we already collected
    # in $indexCatalog so the per-theme render can show title + speakers +
    # session type without re-reading each rich-manifest.
    $sessionByCode = @{}
    foreach ($s in $indexCatalog) { $sessionByCode[$s.code] = $s }

    foreach ($t in $themesData) {
        $codes = if ($sessionsByTheme.ContainsKey($t.slug)) { $sessionsByTheme[$t.slug].ToArray() } else { @() }
        $sectionsSb = [System.Text.StringBuilder]::new()
        [void]$sectionsSb.AppendLine('<section class="entity-section"><h2>Sessions in this theme (' + $codes.Count + ')</h2><ul class="mention-list">')

        # Sort sessions by tier (keynotes first, then breakouts, demos,
        # live, lightning talks, labs, others), then by code within each
        # tier. Puts the headline content at the top of the list.
        $tierOf = {
            param($c)
            if ($c -like 'KEY*')   { 0 }
            elseif ($c -like 'BRK*')   { 1 }
            elseif ($c -like 'DEM*')   { 2 }
            elseif ($c -like 'LIVE*')  { 3 }
            elseif ($c -like 'LTG*')   { 4 }
            elseif ($c -like 'LAB*')   { 5 }
            else { 6 }
        }
        $sortedCodes = $codes | Sort-Object @{Expression = { & $tierOf $_ }}, @{Expression = { $_ }}

        foreach ($c in $sortedCodes) {
            $s = $sessionByCode[$c]
            if (-not $s) { continue }
            $sessSpeakers = if ($speakersEnabled -and $speakersBySession.ContainsKey($c)) {
                ($speakersBySession[$c].ToArray() | ForEach-Object { '<a href="../speakers/' + (HtmlEncode $_.slug) + '.html">' + (HtmlEncode $_.name) + '</a>' }) -join ', '
            } else {
                HtmlEncode ($s.speakerNames ?? '')
            }
            $smallParts = @()
            if ($s.sessionType)  { $smallParts += (HtmlEncode $s.sessionType) }
            if ($s.durationMins) { $smallParts += "$($s.durationMins) min" }
            $smallLine = if ($smallParts.Count -gt 0) { '<small>' + ($smallParts -join ' &middot; ') + '</small>' } else { '' }

            [void]$sectionsSb.AppendLine(
                '<li class="mention-card">' +
                  '<div class="mention-card-head"><strong><a href="../sessions/' + (HtmlEncode $c) + '.html">' + (HtmlEncode $c) + ' &mdash; ' + (HtmlEncode $s.title) + '</a></strong></div>' +
                  '<div class="mention-speakers">' + $sessSpeakers + '</div>' +
                  $smallLine +
                '</li>')
        }
        [void]$sectionsSb.AppendLine('</ul></section>')

        $sessionPlural = if ($t.sessionCount -eq 1) { '' } else { 's' }
        $statsHtml     = '<span><strong>' + $t.sessionCount + '</strong> session' + $sessionPlural + '</span>'

        $themePageBody = Render-Template $themeBody @{
            CATEGORY_SLUG       = 'theme'
            CATEGORY            = 'Theme'
            THEME_NAME          = HtmlEncode $t.name
            DESCRIPTION_HTML    = HtmlEncode $t.description
            STATS_HTML          = $statsHtml
            HEADER_BADGES_HTML  = ''
            SECTIONS_HTML       = $sectionsSb.ToString()
        }
        $themePageHtml = Render-Template $layoutTpl @{
            TITLE          = "$($t.name) - $Conference $EventId themes"
            ASSETS_PREFIX  = '../'
            HEAD_META_HTML = Build-HeadMeta `
                -Title "$($t.name) - $Conference $EventId themes" `
                -Description "$($t.description) $($t.sessionCount) $Conference $EventId session$sessionPlural under this theme." `
                -Url (Make-AbsoluteUrl $SiteBaseUrl "$Conference/$EventId/themes/$($t.slug).html") `
                -ImageUrl $siteDefaultOgImage
            BREADCRUMB     = '<nav class="breadcrumb"><a href="../../../index.html">Conference Library</a> &raquo; ' +
                             "<a href=`"../../index.html`">$(HtmlEncode $Conference)</a> &raquo; " +
                             "<a href=`"../index.html`">$(HtmlEncode $EventId)</a> &raquo; " +
                             "<a href=`"index.html`">Themes</a> &raquo; " +
                             (HtmlEncode $t.name) + "</nav>"
            HEADER_TITLE   = (HtmlEncode $t.name)
            NAV_HTML       = $themePageNav
            SOURCE_NOTE    = " from <code>catalog/$(HtmlEncode $Conference)/$(HtmlEncode $EventId)/themes/themes.json</code>"
            EXTRA_HEAD     = ''
            BODY           = $themePageBody
            GENERATED_AT   = HtmlEncode $generatedAt
        }
        Set-Content -LiteralPath (Join-Path $themesRoot ($t.slug + '.html')) -Value $themePageHtml -Encoding utf8
    }

    Write-Host "Wrote themes view:" -ForegroundColor Cyan
    Write-Host "  landing:     $(Join-Path $themesRoot 'index.html')"
    Write-Host "  themes:      $($themesData.Count) under $themesRoot\<slug>.html"
    Write-Host "  catalog:     $(Join-Path $OutputRoot 'themes-catalog.json')"
    Write-Host "  search idx:  $(Join-Path $OutputRoot 'themes-search-index.json')"
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
        # After the hub redesign the catalog.json file lives in the
        # sessions/ subfolder, not at the year root. The year root holds
        # the new hub page (index.html). Treat a year folder as valid
        # whenever the hub is present AND either the new sessions catalog
        # OR the legacy /catalog.json is on disk (backward-compatible).
        (Test-Path -LiteralPath (Join-Path $_.FullName 'index.html')) -and
        ((Test-Path -LiteralPath (Join-Path $_.FullName 'sessions\catalog.json')) -or
         (Test-Path -LiteralPath (Join-Path $_.FullName 'catalog.json')))
    } |
    Sort-Object Name -Descending

$yearCards = foreach ($yd in $years) {
    # Prefer the new location; fall back to the legacy one.
    $catPath = Join-Path $yd.FullName 'sessions\catalog.json'
    if (-not (Test-Path -LiteralPath $catPath)) {
        $catPath = Join-Path $yd.FullName 'catalog.json'
    }
    $cat = try { Get-Content -Raw -LiteralPath $catPath | ConvertFrom-Json } catch { $null }
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
    HEAD_META_HTML = Build-HeadMeta `
        -Title "$Conference - Conference Library" `
        -Description "$Conference conference sessions: full transcripts, AI summaries, sampled frames, click-to-seek video, and a cross-session catalog of announced products, SDKs, frameworks, services, and models. Pick a year to browse." `
        -Url (Make-AbsoluteUrl $SiteBaseUrl "$Conference/") `
        -ImageUrl $siteDefaultOgImage
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
        Where-Object {
            (Test-Path -LiteralPath (Join-Path $_.FullName 'sessions\catalog.json')) -or
            (Test-Path -LiteralPath (Join-Path $_.FullName 'catalog.json'))
        }
    $totalSessions = 0
    foreach ($yd in $confYears) {
        $cp = Join-Path $yd.FullName 'sessions\catalog.json'
        if (-not (Test-Path -LiteralPath $cp)) { $cp = Join-Path $yd.FullName 'catalog.json' }
        $cat = try { Get-Content -Raw -LiteralPath $cp | ConvertFrom-Json } catch { $null }
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
    <p>A community-maintained reference of conference sessions: full transcripts, AI-generated summaries, sampled frames, click-to-seek video, and a cross-session catalog of every product, SDK, framework, service, and model announced &mdash; with curated GitHub, docs, and NuGet links. Built from public catalogs; all rights remain with the original speakers and conferences. Pick a conference to browse.</p>
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
    HEAD_META_HTML = Build-HeadMeta `
        -Title 'Conference Library' `
        -Description 'A community-maintained reference of conference sessions: full transcripts, AI-generated summaries, sampled frames, click-to-seek video, and a cross-session catalog of every product, SDK, framework, service, and model announced - with curated GitHub, docs, and NuGet links.' `
        -Url $SiteBaseUrl `
        -ImageUrl $siteDefaultOgImage
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
# Sitemap.xml + robots.txt at the docs/ root. The sitemap aggregates every
# .html under docs/ across all conferences and events (Build-Book runs
# per-event but the sitemap reflects the current cross-event state of the
# docs/ tree). robots.txt points crawlers at the sitemap. Both files live
# at the GitHub Pages root URL, which is what Google + Bing expect.
# --------------------------------------------------------------------------

$sitemapPath = Join-Path $docsRoot 'sitemap.xml'
$robotsPath  = Join-Path $docsRoot 'robots.txt'

$siteBase = $SiteBaseUrl.TrimEnd('/')
$sitemapSb = [System.Text.StringBuilder]::new()
[void]$sitemapSb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
[void]$sitemapSb.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')

# Walk every .html under docs/, skip nothing - include the root, conference
# landings, event hubs, sessions catalog, per-session pages, announcements
# landing, per-entity pages.
$htmlFiles = Get-ChildItem -LiteralPath $docsRoot -Recurse -Filter '*.html' -ErrorAction SilentlyContinue
foreach ($f in ($htmlFiles | Sort-Object FullName)) {
    $rel = [System.IO.Path]::GetRelativePath($docsRoot, $f.FullName) -replace '\\', '/'
    # Index pages: prefer the directory URL form (cleaner for sharing) -
    # 'sessions/' instead of 'sessions/index.html'.
    if ($rel -eq 'index.html') {
        $loc = "$siteBase/"
    } elseif ($rel.EndsWith('/index.html')) {
        $loc = "$siteBase/$($rel.Substring(0, $rel.Length - 'index.html'.Length))"
    } else {
        $loc = "$siteBase/$rel"
    }
    $lastmod = $f.LastWriteTimeUtc.ToString('yyyy-MM-ddTHH:mm:ssZ')
    [void]$sitemapSb.AppendLine('  <url>')
    [void]$sitemapSb.AppendLine("    <loc>$([System.Net.WebUtility]::HtmlEncode($loc))</loc>")
    [void]$sitemapSb.AppendLine("    <lastmod>$lastmod</lastmod>")
    [void]$sitemapSb.AppendLine('  </url>')
}
[void]$sitemapSb.AppendLine('</urlset>')
Set-Content -LiteralPath $sitemapPath -Value $sitemapSb.ToString() -Encoding utf8

$robotsBody = @"
User-agent: *
Allow: /

Sitemap: $siteBase/sitemap.xml
"@
Set-Content -LiteralPath $robotsPath -Value $robotsBody -Encoding utf8

# --------------------------------------------------------------------------
# Done.
# --------------------------------------------------------------------------

Write-Host ''
Write-Host "Rendered $rendered session page(s) (skipped $skipped without rich-manifest.json)." -ForegroundColor Green
Write-Host "  per-event hub:      $(Join-Path $OutputRoot 'index.html')"
Write-Host "  sessions catalog:   $(Join-Path $OutputRoot 'sessions\index.html')"
Write-Host "  sessions catalog json+index: $(Join-Path $OutputRoot 'sessions')\{catalog,search-index}.json"
Write-Host "  hub-catalog.json:   $(Join-Path $OutputRoot 'hub-catalog.json')"
Write-Host "  per-session pages:  $(Join-Path $OutputRoot 'sessions')"
Write-Host "  conference landing: $(Join-Path $conferenceRoot 'index.html') ($($years.Count) year(s) listed)"
Write-Host "  library root:       $(Join-Path $docsRoot 'index.html') ($($confDirs.Count) conference(s) listed)"
Write-Host "  sitemap.xml:        $sitemapPath ($($htmlFiles.Count) URL(s))"
Write-Host "  robots.txt:         $robotsPath"
Write-Host ''
Write-Host "To preview locally:" -ForegroundColor Cyan
Write-Host "  python -m http.server 8080 -d `"$docsRoot`""
Write-Host "  then open http://localhost:8080/"
