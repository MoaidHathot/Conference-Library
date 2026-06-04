# Improvements — known caveats and how to fix them

A running list of known limitations and rough-edged behavior in the Conference Library pipeline, with concrete recipes for fixing each one.

Items are roughly ordered by **impact × ease-of-fix**: the first few would visibly improve session pages for ~30 sessions with maybe a day of work; later items are nice-to-haves.

---

## 1. OD/ODSP on-demand sessions have no main-gallery frames

**Symptom.** Sessions whose code begins with `OD…` or `ODSP…` (roughly 30 sessions, e.g. `OD800`, `ODSP934`, `OD870`) render a session page with no cover, no Frames gallery, and `ingestion-report.json` lists them as `partial` with the error:

```
no durationInMinutes; cannot space frames
```

**Why.** `scripts/Invoke-BuildIngestion.ps1` computes the frame timestamps from `durationInMinutes` in the catalog record (see `Get-EvenlySpacedTimestamps`). The Build catalog API returns `durationInMinutes: 0` (or null) for on-demand-only sessions because those weren't scheduled into a fixed slot, so the static catalog has no duration metadata.

The on-demand video itself does have a real duration — it's right there in the MP4/HLS manifest — but we never ask the file.

**Fix.** Probe the video for its actual duration before computing frame timestamps. ffprobe (ships with ffmpeg) does this in <1 s for an MP4 (header read via HTTP range) or 1–3 s for HLS (master playlist + first variant playlist).

In the worker block of `Invoke-BuildIngestion.ps1`, right after the `$videoSource` is picked but before the `if (-not $videoSource) {...}` branch:

```powershell
# If the catalog didn't tell us how long the video is, ask ffprobe.
# Costs ~1-3 s per session for the one HTTP read; only runs when needed.
if ($durationSeconds -le 0 -and $videoSource) {
    $ffprobePath = $FfmpegPath -replace 'ffmpeg(\.exe)?$', 'ffprobe$1'
    if (Test-Path -LiteralPath $ffprobePath) {
        $probeOut = & $ffprobePath -v error -show_entries format=duration `
            -of csv=p=0 $videoSource.Url 2>$null
        if ($probeOut -and ([double]::TryParse($probeOut.Trim(),
                [System.Globalization.NumberStyles]::Float,
                [System.Globalization.CultureInfo]::InvariantCulture, [ref]$null))) {
            $durationSeconds = [double]::Parse(
                $probeOut.Trim(),
                [System.Globalization.CultureInfo]::InvariantCulture)
        }
    }
}
```

Then the existing `if ($durationSeconds -le 0)` branch shrinks to truly-impossible cases (no video at all).

**Cost.** ~30 sessions × 1–3 s ffprobe = ~1 min added to ingestion. ~30 × 15 frames = 450 new frame captures, ~5 min serial / ~1 min at concurrency 10. Plus an extra ~50 MB on disk.

---

## 2. A few BRK/DEM sessions get only 13/14 frames instead of 15

**Symptom.** `ingestion-report.json` shows entries like:

```
[partial] BRK252
  - ffmpeg failed at 36-33 (exit -22, source=mp4)
  - ffmpeg failed at 39-22 (exit -22, source=mp4)
  - ffmpeg failed at 42-11 (exit -22, source=mp4)
```

The session page renders with 12 frames instead of 15. The "missing" frames are always the tail-end of the gallery.

**Why.** Same root cause as above, in mirror image. The catalog's `durationInMinutes` overstates the actual video by ~1–3 minutes (the session ran short, or the catalog rounded up to the scheduled slot length). `Get-EvenlySpacedTimestamps` produces timestamps based on the inflated duration, and the last few seeks land past the actual video end. ffmpeg returns exit `-22` (EINVAL).

**Fix.** Same as #1 — ffprobe the actual duration and use *that* for spacing instead of `durationInMinutes`. The fix above handles both over- and under-stated durations.

**Cost.** Same ffprobe call as #1; the savings is "no more `[partial]` rows for these ~10–15 sessions".

---

## 3. Partial announcement-frame strips when the AI summary cites a timestamp past the video end

**Symptom.** For some session pages, hovering an `[HH:MM:SS]` marker shows fewer than 4 frames in the popup strip, or no strip at all. Example: BRK260 hover of `[00:43:45]` may show only `-10s` and `-5s` frames because `+5s` and `+10s` were past the video's real ending.

**Why.** The AI summary cites timestamps based on transcript cue times. If the transcript was generated from a slightly-longer source than the on-demand MP4 we have access to (e.g. the conference encoded a shorter "highlight" cut), the late-session timestamps point past the file's runtime, and ffmpeg fails the seek.

The renderer's `Inject-AnnouncementFrames` only emits a frame when the file exists on disk, so the affected strips just silently show fewer thumbnails.

**Fix.** Two options:

**(a) Clamp to video duration during capture.** In `Get-AnnouncementFrames.ps1`, ffprobe the video duration once per session (cache the result), then skip any timestamp where `tsSeconds + offset >= duration`. Cleaner reports and slightly less ffmpeg work:

```powershell
# Cached per-session probe at the top of the worker:
$probeOut = & $ffprobePath -v error -show_entries format=duration `
    -of csv=p=0 $session.VideoUrl 2>$null
$videoDurationSec = if ($probeOut) { [double]$probeOut.Trim() } else { [int]::MaxValue }

# Then in the per-offset loop:
if ($target -lt 0 -or $target -ge $videoDurationSec) {
    $skipped++; continue
}
```

**(b) Leave it alone.** Current behaviour is graceful: missing frames are silently omitted, the page still renders, the summary text is intact. Cost of accepting this is some `[partial]` entries in the run report.

**Recommended.** (a) — combine the ffprobe call with the one added for #1/#2 so we pay the cost once per session.

---

## 4. Sessions with no captions and no HLS — totally bare pages

**Symptom.** A handful of sessions (BRK201, BRK247, LIVE101 today) show in `ingestion-report.json` as:

```
[failed] BRK201
  - Medius embed has no parseable captionsConfiguration
  - no downloadVideoLink and no HLS URL on Medius embed
```

Their session pages have title + description + speakers but no transcript, no summary, no frames, no player. Mostly metadata.

**Why.** These sessions exist in the catalog but their Medius embed page is incomplete — sometimes because the recording is genuinely private/restricted, sometimes because the session hasn't been encoded yet but a placeholder embed exists.

**Fix.** Two layers:

**(a) Re-run ingestion after the conference fully wraps up.** Re-run `scripts/Get-BuildCatalog.ps1` followed by `Invoke-BuildIngestion.ps1` — the latest catalog plus a fresh Medius fetch will often catch sessions that have since been published. The idempotency in `Invoke-BuildIngestion.ps1` uses `catalogFetchedAt` as the fingerprint, so a fresh catalog crawl triggers re-ingestion of every session.

**(b) Surface "no recording yet" explicitly on the page.** In `Build-Book.ps1`'s session render block, when the manifest has `ingestion.errors` containing "no captionsConfiguration" or "no downloadVideoLink and no HLS", render a banner above the (empty) description:

```html
<div class="banner banner-warning">
    This session's recording isn't published yet. The text below comes from
    the catalog only; check back after the conference if you'd like the
    transcript, summary, frames, and embedded player to appear.
</div>
```

Worth doing for visitor clarity even if the underlying data never materializes.

**Cost.** Nothing — both fixes are reactive (re-run when content lands, or display a placeholder).

---

## 5. Re-ingestion can leave stale frame files of mixed counts

**Status.** Mitigated but not eliminated.

**Symptom.** If you re-run `Invoke-BuildIngestion.ps1` with a *different* `-FrameCount` than a previous run (or after the script's filename convention changes), some session directories end up with leftover frames from earlier runs alongside the new ones. The website only renders what's in the manifest, so visually nothing is wrong, but disk usage grows and `Get-ChildItem sessions/.../frames` returns confusing numbers.

**Current mitigation.** `Invoke-BuildIngestion.ps1`'s worker now wipes `frames/frame-*.jpg` files (preserving any subdirectories like `announcement-frames/`) before re-capturing. This handles the homogenous case.

**Remaining gap.** If you ever change the frame filename pattern (e.g. drop the trailing `-HH-MM` timestamp tag), the wipe filter (`frame-*.jpg`) still catches them, so this is mostly future-proof. But if you ever add a *non*-`frame-` filename for new artifact types in the same directory, you'd need to add it to the wipe.

**Fix (only if you start producing other artifact filenames).** Replace the wipe filter with a directory-recreate:

```powershell
if (Test-Path -LiteralPath $framesDir) {
    # Wipe everything that is not a known subdirectory before re-capturing.
    Get-ChildItem -LiteralPath $framesDir | Where-Object {
        -not $_.PSIsContainer -or $_.Name -ne 'announcement-frames'
    } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}
```

---

## 6. HLS frame capture is ~10× slower than MP4

**Symptom.** For ingestion runs covering HLS-only sessions, each frame takes ~9 s vs ~0.8 s for MP4-backed sessions. A 15-frame HLS session takes ~2.3 min; at concurrency 10 that bottlenecks the batch.

**Why.** ffmpeg's `-ss BEFORE -i` on an HLS master playlist still requires reading the variant playlist, picking a segment, and decoding from the segment start to the target time. Even with the playlist seek hint, HLS has more handshakes than a single HTTP-range read into an MP4.

**Fix.** Three approaches in order of effort:

**(a) Sample fewer frames for HLS-only sessions.** Halve `-FrameCount` for sources that don't have a direct MP4. Sub-15 frames still gives a usable gallery and ~50% time savings on those sessions.

**(b) Run a "warm-up" ffprobe that caches the segment list, then issue all 15 frame requests against the variant playlist URL directly.** ffmpeg accepts the variant playlist (not just the master) and avoids re-discovering it per call.

**(c) For sessions known to fall back to HLS, download the full video locally once (with `ffmpeg -i master.m3u8 -c copy temp.mp4`) and seek 15 times against the local file. Costs disk + bandwidth (~500 MB per session) but eliminates the per-frame overhead. Only worth it for very-long sessions.**

**Recommended.** (a) for a quick win; (b) for the right long-term fix.

---

## 7. Some announcement frames duplicate (e.g. T-5s and T+5s are identical)

**Symptom.** Rare. Hovering a `[00:14:10]` marker shows 4 thumbnails but two look identical (especially around static slide content).

**Why.** Talks linger on individual slides for 30–60 s. If the announcement timestamp lands in the middle of a static slide, all four offset frames (`-10s, -5s, +5s, +10s`) capture the same image.

**Fix.** Two options:

**(a) Accept it.** The redundancy is mild and the visual context (slide-while-this-was-discussed) is still right.

**(b) Hash-deduplicate after capture.** In `Get-AnnouncementFrames.ps1`, after writing all 4 frames per timestamp, compute their SHA-256 (or a perceptual hash) and delete duplicates, leaving just one. Saves disk + visual clutter.

```powershell
# After the 4-frame capture loop for one timestamp:
$captured = Get-ChildItem -LiteralPath $folderPath -File -Filter '*.jpg'
$byHash = $captured | Group-Object {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    [BitConverter]::ToString($sha.ComputeHash([System.IO.File]::ReadAllBytes($_.FullName)))
}
foreach ($g in $byHash | Where-Object { $_.Count -gt 1 }) {
    $g.Group | Select-Object -Skip 1 | Remove-Item -Force
}
```

**Recommended.** (a) for now; revisit if a future audit shows a meaningful disk waste.

---

## 8. Status badge ("Live now" / "Upcoming") depends on visitor's clock

**Symptom.** A visitor whose laptop clock is wrong sees inaccurate "Live now" / "Ended" labels.

**Why.** `templates/site/assets/session.js` uses `new Date()` against the `data-start` / `data-end` ISO datetime attributes — both interpreted as UTC. The visitor's wall clock skew becomes the page's skew.

**Fix.** For most users (NTP-synced laptops, phones), this is invisible. If we ever care, request a known-good time once per page load:

```javascript
const serverTimeOffset = await fetch('https://worldtimeapi.org/api/timezone/Etc/UTC')
    .then(r => r.json())
    .then(d => new Date(d.utc_datetime).getTime() - Date.now())
    .catch(() => 0);
function now() { return new Date(Date.now() + serverTimeOffset); }
```

Then use `now()` instead of `new Date()` throughout. Adds one external dependency.

**Recommended.** Don't bother unless someone reports a visible problem.

---

## 9. Lunr query strips `:`, `+`, `-`, `~`, `^` which loses literal punctuation searches

**Symptom.** Searching for `C++`, `.NET`, or `Web3` in the index page filter box returns results based on the cleaned terms (e.g. `c`, `net`, `web3`) rather than the literal punctuated forms.

**Why.** `templates/site/assets/app.js`'s search routine strips Lunr's own query operators (`:+-~^`) before building the wildcard query, so `C++` becomes `c  `.

**Fix.** Two options:

**(a) Escape rather than strip.** Lunr's grammar doesn't accept escaping for these characters in its standard parser, so this requires a custom tokenization step. Probably not worth the code.

**(b) Pre-index synonyms during the Lunr build.** In `Build-LunrIndex`, normalize common punctuated tokens to alphanumeric form (`C++` → `cpp`, `.NET` → `dotnet`, `C#` → `csharp`) and store both forms. Users still type `C++` and get hits because the normalized form was indexed.

**Recommended.** (b) when it actually becomes a problem; current behavior is "search returns slightly broader matches", which is rarely user-visible because session titles also contain the plain English forms.

---

## 10. The repo grows linearly with each event year

**Symptom.** Build 2026 alone is ~250 MB of `sessions/` artifacts + 195 MB of `docs/`. Add 2027 and you're past 1 GB; multi-year and you'll cross GitHub's repo-size soft limit and Pages's 1 GB site limit.

**Why.** Frames, transcripts, .docx archives, and rendered HTML all sit committed in main. Multi-year ambition + comprehensive artifacts = unavoidable growth.

**Fix.** Three escalating options:

**(a) Move frames + .docx to Git LFS.** Keeps repo small from Git's perspective but you'll consume LFS bandwidth quotas. Pages still serves the actual files normally.

**(b) Split `docs/` to a `gh-pages` branch via GitHub Actions.** `main` keeps source + `sessions/` + `catalog/` only; `docs/` is force-pushed from CI to `gh-pages`. Each branch stays clean and repo overall grows more slowly.

**(c) Per-year sub-repositories.** `Conference-Library` becomes a meta-repo with a tiny landing page; each year (`Conference-Library-Build-2026`, `-2027`, …) is its own repo with its own Pages deployment. URL pattern stays consistent if you set up CNAMEs or a static redirector.

**Recommended.** (b) once a second year is added — clean separation, no LFS quotas, no multi-repo overhead.

---

## 11. No GitHub Actions automation — every refresh is manual

**Symptom.** When new sessions land on the catalog after the conference ends, the 4-step pipeline has to be re-run on a local machine that has Copilot + ffmpeg + node installed.

**Why.** Stage 3 (summaries) uses the locally signed-in Copilot identity (`UseLoggedInUser=true` in `Get-SessionSummary.cs`), which doesn't translate to a headless CI runner.

**Fix.** Two scopes:

**(a) Automate Stage 4 (render) only.** A GitHub Actions workflow on push that runs `pwsh scripts/Build-Book.ps1 -Conference Build -EventId 2026` and force-pushes `docs/` to `gh-pages`. Useful if you frequently tweak templates or styles.

**(b) Replace Copilot with a PAT-authenticated model call** (Anthropic API directly, or OpenAI, or GitHub Models if it ever exposes stable PAT-auth) so Stage 3 can run in CI too. Then a scheduled workflow (daily during the conference, weekly after) can fully refresh the site without local hands.

**Recommended.** (a) is a 30-line workflow file; do it when you start iterating on the templates a lot. (b) is a bigger lift and changes the cost model from "free with Copilot Pro" to "paid API tokens"; only do it if hands-free updates become a pain point.

---

## 12. The catalog APIs and Medius URL shapes are Microsoft-Build-specific

**Symptom.** Adding a second conference (e.g. KubeCon, NDC, .NET Conf, re:Invent) requires writing a brand-new `Get-<Conf>Catalog.ps1` and possibly extending `Invoke-BuildIngestion.ps1` to recognise the new conference's video service URL patterns.

**Why.** `Get-BuildCatalog.ps1` is hard-coded against `api-v2.build.microsoft.com`, and `Invoke-BuildIngestion.ps1` knows specifically how to scrape the Medius embed for VTT captions and HLS URLs.

**Fix.** When a second conference shows up:

1. Create `scripts/Get-<NewConf>Catalog.ps1` that produces `catalog/<NewConf>/<year>/catalog.json` in the same shape as Build (must have `sessionCode`, `title`, `onDemand` URL or `downloadVideoLink`, `durationInMinutes`, `topic[]`, `tags[]`, etc.).
2. Refactor the Medius-specific code in `Invoke-BuildIngestion.ps1` into a per-conference adapter:
   - Extract `Get-MediusEmbedInfo` into `scripts/adapters/Medius.ps1`.
   - Add a router at the top of the ingestion worker that picks the adapter by conference name (or by URL pattern in the catalog).
3. Everything else (`Get-SessionSummary.cs`, `Get-SessionSummaries.ps1`, `Build-Book.ps1`, templates) is already conference-agnostic — it consumes `rich-manifest.json` which has a stable schema.

**Cost.** Maybe a day per new conference, mostly for the catalog crawler. Pre-existing templates and CSS handle the new content automatically.

---

## Quick-win priorities

If you ever decide to chip away at this list, the highest-value sequence is:

1. **#1 + #2 + #3 (ffprobe duration probing)** — one ~10-line change unlocks gallery frames for ~30 OD sessions, eliminates the `[partial]` reports for over-stated durations, and trims the announcement-frame failure rate to zero. Probably 30 min of work.
2. **#4(b) "no recording yet" banner** — small CSS + template change; visible improvement for the ~3 truly-broken sessions.
3. **#11(a) Actions workflow for render-only** — automates the post-push refresh you do today with a manual `Build-Book.ps1 && git push`.

The rest are real but smaller-impact polish.
