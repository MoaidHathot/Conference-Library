/* app.js - per-event session catalog page (index.html).
 *
 * Loads catalog.json (slim per-session metadata) and search-index.json (a
 * pre-built Lunr index that already has the per-session text indexed).
 *
 * Filters:
 *   - free-text search (Lunr; OR-of-terms with stemming + wildcard fallback)
 *   - session-type dropdown (single-select)
 *   - topic pills (multi-select, AND-combined)
 *   - tag pills (multi-select, AND-combined)
 *   - "Hide ended", "Live only", "Upcoming only" status filters
 *
 * No build step. Plain ES5+/ES2020 syntax that works as-is on GitHub Pages.
 */

(async function () {
    'use strict';

    const $  = (sel) => document.querySelector(sel);

    const list        = $('#session-list');
    const meta        = $('#results-meta');
    const search      = $('#filter-search');
    const filterTy    = $('#filter-type');
    const themePills  = $('#filter-theme-pills');
    const topicPills  = $('#filter-topic-pills');
    const tagPills    = $('#filter-tag-pills');
    const statusBtns  = document.querySelectorAll('#filter-status [data-status]');
    const recordedBtn = $('#recorded-toggle');
    const demoRepoBtn = $('#demo-repo-toggle');
    const noResults   = $('#no-results');

    // ---- helpers ----
    function escapeAttr(s) { return String(s).replace(/[&"<>]/g, c => ({'&':'&amp;','"':'&quot;','<':'&lt;','>':'&gt;'}[c])); }
    function escapeText(s) { return String(s).replace(/[&<>]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;'}[c])); }

    // PowerShell's ConvertTo-Json unwraps single-element collections to
    // scalars, so catalog.json may contain `tags: "AI"` for a single-tag
    // session and `tags: ["AI", "Windows"]` for a multi-tag one. Normalize.
    function toArray(v) {
        if (Array.isArray(v)) return v;
        if (v === null || v === undefined || v === '') return [];
        return [v];
    }

    function fmtDuration(ms) {
        const abs = Math.abs(ms);
        const d = Math.floor(abs / 86400000);
        const h = Math.floor((abs % 86400000) / 3600000);
        const m = Math.floor((abs % 3600000) / 60000);
        if (d > 0)  return `${d}d ${h}h`;
        if (h > 0)  return `${h}h ${m}m`;
        if (m > 0)  return `${m}m`;
        return `${Math.floor(abs / 1000)}s`;
    }

    function sessionStatus(s, now) {
        if (!s.startDateTime) return { kind: 'unknown' };
        const start = new Date(s.startDateTime);
        const end   = s.endDateTime ? new Date(s.endDateTime) : null;
        if (now < start) return { kind: 'upcoming', label: 'Upcoming', detail: `starts in ${fmtDuration(start - now)}` };
        if (end && now < end) return { kind: 'live', label: 'Live now', detail: `${fmtDuration(end - now)} remaining` };
        if (end) return { kind: 'ended', label: 'Ended', detail: `${fmtDuration(now - end)} ago` };
        return { kind: 'ended', label: 'Past', detail: '' };
    }

    // ---- load data ----
    const [catalog, indexJson] = await Promise.all([
        fetch('catalog.json').then(r => r.json()),
        fetch('search-index.json').then(r => r.json())
    ]);

    const isFallback   = indexJson && indexJson.__fallback === true;
    const lunrIndex    = isFallback ? null : lunr.Index.load(indexJson);
    const fallbackDocs = isFallback ? indexJson.documents : null;
    const byCode       = new Map(catalog.sessions.map(s => [s.code, s]));

    // ---- URL state helpers ----
    // Read filter state from the page's URL query string on load, write it
    // back via history.replaceState() on every filter change. Keys are
    // intentionally short for shareable URLs:
    //   q=...   search text
    //   type=...  sessionType (single value)
    //   topic=...,...   chosenTopics (comma-separated)
    //   tag=...,...     chosenTags
    //   theme=...,...   chosenThemes
    //   status=...      statusFilter ('all'|'upcoming'|'live'|'ended')
    //   recorded=0|1    recordedOnly (default 1)
    //   repo=1          hasDemoRepoOnly (default 0)
    function parseUrlState() {
        const u = new URL(window.location.href);
        const v = (k) => u.searchParams.get(k);
        const splitCsv = (s) => (s == null || s === '') ? [] : s.split(',').filter(Boolean);
        return {
            q:        v('q')        ?? '',
            type:     v('type')     ?? '',
            topics:   splitCsv(v('topic')),
            tags:     splitCsv(v('tag')),
            themes:   splitCsv(v('theme')),
            status:   v('status')   ?? 'all',
            recorded: v('recorded') !== '0', // default on
            demoRepo: v('repo')     === '1'  // default off
        };
    }
    function writeUrlState() {
        const u = new URL(window.location.href);
        const set = (k, v) => {
            if (v == null || v === '' || v === false) u.searchParams.delete(k);
            else u.searchParams.set(k, v);
        };
        set('q',      search.value.trim());
        set('type',   filterTy.value);
        set('topic',  chosenTopics.size ? Array.from(chosenTopics).join(',') : '');
        set('tag',    chosenTags.size   ? Array.from(chosenTags).join(',')   : '');
        set('theme',  chosenThemes.size ? Array.from(chosenThemes).join(',') : '');
        set('status', statusFilter === 'all' ? '' : statusFilter);
        set('recorded', recordedOnly ? '' : '0'); // omit when default
        set('repo',     demoRepoOnly ? '1' : ''); // omit when default
        // replaceState avoids polluting browser history with every keystroke;
        // back-button still works to leave the page.
        window.history.replaceState(null, '', u.toString());
    }
    const initial = parseUrlState();

    // ---- populate filters ----
    function unique(values) {
        return [...new Set(values.flatMap(v => toArray(v)))].sort();
    }

    // sessionType: single-select dropdown (only ~9 values, rarely combined).
    function fillSelect(el, values, label) {
        el.innerHTML = `<option value="">All ${label}</option>` +
            values.map(v => `<option value="${escapeAttr(v)}">${escapeText(v)}</option>`).join('');
    }
    fillSelect(filterTy, unique(catalog.sessions.map(s => s.sessionType)), 'types');
    // Hydrate the simple controls from the URL so a shared link lands the
    // visitor on the same filtered view. Pill sets are hydrated below where
    // they're constructed.
    search.value   = initial.q;
    filterTy.value = initial.type;

    // Multi-select pill renderer used for both topic + tag filters. Each pill
    // toggles via click; selection set is held in `chosen` (Set<string>).
    // Pills also display a count of currently-visible sessions matching them.
    // When the value-set is large (tags: ~150) only the top-N most common
    // pills are shown by default, with a "Show all" toggle to reveal the
    // rest - keeps the filter area from dominating the page.
    function buildPills(container, label, values, getValues, chosen, onChange, opts) {
        opts = opts ?? {};
        const collapseAfter = opts.collapseAfter ?? Infinity;

        container.innerHTML = '';
        const labelEl = document.createElement('span');
        labelEl.className = 'pill-label';
        labelEl.textContent = label;
        container.appendChild(labelEl);

        // Pre-compute initial frequency (total sessions matching each value)
        // so we can sort pills by popularity and decide which to hide.
        const freq = new Map();
        values.forEach(v => {
            freq.set(v, catalog.sessions.filter(s => toArray(getValues(s)).includes(v)).length);
        });
        const sorted = [...values].sort((a, b) => (freq.get(b) ?? 0) - (freq.get(a) ?? 0) || a.localeCompare(b));

        const pillById = new Map();
        sorted.forEach((v, i) => {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'filter-pill';
            // Reflect pre-selected state (e.g. hydrated from URL params) so
            // visitors see their selection highlighted on first render.
            if (chosen.has(v)) btn.classList.add('is-on');
            btn.dataset.value = v;
            btn.dataset.rank  = i;
            btn.innerHTML = `${escapeText(v)} <span class="pill-count"></span>`;
            btn.addEventListener('click', () => {
                if (chosen.has(v)) chosen.delete(v); else chosen.add(v);
                btn.classList.toggle('is-on', chosen.has(v));
                onChange();
            });
            container.appendChild(btn);
            pillById.set(v, btn);
        });

        // "Show all (N)" / "Show less" toggle when the list is long.
        let expanded = false;
        let expandBtn = null;
        if (sorted.length > collapseAfter) {
            expandBtn = document.createElement('button');
            expandBtn.type = 'button';
            expandBtn.className = 'pills-toggle';
            const hiddenCount = sorted.length - collapseAfter;
            expandBtn.textContent = `Show all (+${hiddenCount})`;
            expandBtn.addEventListener('click', () => {
                expanded = !expanded;
                expandBtn.textContent = expanded ? 'Show fewer' : `Show all (+${hiddenCount})`;
                applyVisibility();
            });
            container.appendChild(expandBtn);
        }

        // "Clear" affordance to wipe the active selection from this pill group.
        const clear = document.createElement('button');
        clear.type = 'button';
        clear.className = 'pills-toggle';
        clear.textContent = 'Clear';
        clear.addEventListener('click', () => {
            chosen.clear();
            container.querySelectorAll('.filter-pill').forEach(b => b.classList.remove('is-on'));
            onChange();
        });
        container.appendChild(clear);

        function applyVisibility(visibleSessions) {
            const subset = visibleSessions ?? catalog.sessions;
            pillById.forEach((btn, val) => {
                const n = subset.filter(s => toArray(getValues(s)).includes(val)).length;
                btn.querySelector('.pill-count').textContent = n ? `(${n})` : '';
                const rank = +btn.dataset.rank;
                const overFlowed = !expanded && rank >= collapseAfter;
                // Always show selected pills and pills with a positive count
                // within the visible band; hide overflow when collapsed.
                const visible = (chosen.has(val))
                    || (n > 0 && !overFlowed);
                btn.style.display = visible ? '' : 'none';
            });
        }

        // Updater called from update() to reflect current filter state.
        return function updateCounts(visibleSessions) {
            applyVisibility(visibleSessions);
        };
    }

    const chosenTopics = new Set(initial.topics);
    const chosenTags   = new Set(initial.tags);
    const chosenThemes = new Set(initial.themes);
    // Themes pill group is only emitted when at least one session in the
    // catalog has a non-empty themes array. Events without the themes
    // pipeline (Resolve-Themes hasn't been run) silently get no pill bar
    // instead of an empty "Themes" label with zero pills.
    const allThemes = unique(catalog.sessions.map(s => s.themes));
    let updateThemeCounts = () => {};
    if (themePills && allThemes.length > 0) {
        updateThemeCounts = buildPills(themePills, 'Themes',
            allThemes, s => s.themes, chosenThemes, () => update());
    }
    const updateTopicCounts = buildPills(topicPills, 'Topics',
        unique(catalog.sessions.map(s => s.topics)), s => s.topics, chosenTopics, () => update());
    const updateTagCounts = buildPills(tagPills, 'Tags',
        unique(catalog.sessions.map(s => s.tags)),   s => s.tags,   chosenTags,   () => update(),
        { collapseAfter: 15 });

    let statusFilter = initial.status;
    statusBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            statusFilter = btn.dataset.status;
            statusBtns.forEach(b => b.classList.toggle('is-on', b === btn));
            update();
        });
    });
    // Highlight the status button matching the hydrated state (defaults to 'all').
    statusBtns.forEach(b => { if (b.dataset.status === statusFilter) b.classList.add('is-on'); });

    // "Recorded only" toggle - defaults on so the index shows only sessions
    // with playable artifacts (~210 of 443 on Build 2026). Clicking it off
    // surfaces the ~233 by-design unrecorded sessions (Table Talks, Labs,
    // Lightning Talks) for visitors who want to browse the full catalog.
    let recordedOnly = initial.recorded;
    if (recordedBtn) {
        // Reflect hydrated state on the toggle button.
        recordedBtn.classList.toggle('is-on', recordedOnly);
        recordedBtn.addEventListener('click', () => {
            recordedOnly = !recordedOnly;
            recordedBtn.classList.toggle('is-on', recordedOnly);
            update();
        });
    }

    // "Has repo" toggle - defaults off. Filters down to the ~60 sessions
    // that have a curated demo / lab repo from microsoft/build26-next-steps.
    // The toggle is hidden when no session in the catalog carries a
    // demoRepoUrl, so events without the demo-repos pipeline don't show
    // a dead button.
    let demoRepoOnly = initial.demoRepo;
    const anyDemoRepos = catalog.sessions.some(s => s.hasDemoRepo === true);
    if (demoRepoBtn) {
        if (!anyDemoRepos) {
            demoRepoBtn.hidden = true;
            demoRepoOnly = false;
        } else {
            demoRepoBtn.classList.toggle('is-on', demoRepoOnly);
            demoRepoBtn.addEventListener('click', () => {
                demoRepoOnly = !demoRepoOnly;
                demoRepoBtn.classList.toggle('is-on', demoRepoOnly);
                update();
            });
        }
    }

    // ---- filtering + render ----
    function applyFilters(sessions) {
        const now = new Date();
        return sessions.filter(s => {
            // "Recorded only" filter: drop sessions with no playable artifact
            // (no video URL, no captured frames, no transcript). Defaults on
            // so the index doesn't bury keynotes/breakouts under ~233
            // metadata-only Table Talks / Labs / Lightning Talks.
            if (recordedOnly && s.hasVideo === false) return false;
            if (demoRepoOnly && s.hasDemoRepo !== true) return false;
            if (filterTy.value && s.sessionType !== filterTy.value) return false;
            if (chosenTopics.size > 0) {
                const topics = toArray(s.topics);
                for (const t of chosenTopics) { if (!topics.includes(t)) return false; }
            }
            if (chosenTags.size > 0) {
                const tags = toArray(s.tags);
                for (const t of chosenTags) { if (!tags.includes(t)) return false; }
            }
            if (chosenThemes.size > 0) {
                const themes = toArray(s.themes);
                for (const t of chosenThemes) { if (!themes.includes(t)) return false; }
            }
            if (statusFilter !== 'all') {
                const st = sessionStatus(s, now);
                if (st.kind !== statusFilter) return false;
            }
            return true;
        });
    }

    function render(matches) {
        const now = new Date();
        // Clarify counts when "Recorded only" is on - otherwise visitors
        // see "211 of 443" and wonder where the rest went.
        if (matches.length) {
            if (recordedOnly) {
                const recordedTotal = catalog.sessions.filter(x => x.hasVideo !== false).length;
                meta.textContent = `${matches.length} of ${recordedTotal} recorded sessions (${catalog.sessions.length} total in catalog)`;
            } else {
                meta.textContent = `${matches.length} of ${catalog.sessions.length} sessions`;
            }
        } else {
            meta.textContent = '';
        }
        if (matches.length === 0) {
            list.innerHTML = '';
            noResults.hidden = false;
            return;
        }
        noResults.hidden = true;
        list.innerHTML = matches.map(s => {
            // Only the two most-specific tags survive on the card; the rest
            // would dominate vertically and the per-session page has them all.
            const tags = toArray(s.tags).slice(0, 2).map(t =>
                `<span class="tag tag-tiny">${escapeText(t)}</span>`).join('');
            const speakers = s.speakerNames || '';
            const st = sessionStatus(s, now);
            const badgeCls = st.kind === 'live' ? 'is-live'
                          : st.kind === 'upcoming' ? 'is-upcoming'
                          : st.kind === 'ended' ? 'is-ended' : '';
            const badgeHtml = st.label
                ? `<span class="status-badge ${badgeCls}">${escapeText(st.label)}</span>`
                : '';
            // Demo-repo badge: links straight to the curated repo so visitors
            // can jump to lab code without opening the session page. Sits
            // beside the status badge; .stopPropagation isn't needed because
            // the wrapping <a> uses the card-thumb-link selector, not the
            // entire <li>. Empty string when the session has no curated repo.
            const repoBadgeHtml = s.hasDemoRepo && s.demoRepoUrl
                ? `<a class="status-badge is-demo-repo" href="${escapeAttr(s.demoRepoUrl)}" target="_blank" rel="noopener" title="Open the session demo / lab repository on GitHub">Repo</a>`
                : '';
            // Time-and-duration line: prefer the precise wall-clock start
            // when the session has a real schedule, fall back to the
            // duration on its own for ad-hoc on-demand uploads.
            let whenHtml = '';
            if (s.startDateTime) {
                const start = new Date(s.startDateTime);
                const dateStr = start.toLocaleString(undefined,
                    { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });
                whenHtml = `<span class="when-start">${escapeText(dateStr)}</span>`;
            }
            if (s.durationMins) {
                whenHtml += `<span class="when-dur">${s.durationMins} min</span>`;
            }
            if (st.detail) {
                whenHtml += `<span class="when-rel">${escapeText(st.detail)}</span>`;
            }
            // Thumbnail: lazy-loaded so 443 cards don't request 443 JPGs up
            // front. Placeholder block keeps the grid aligned when missing.
            // catalog.json's coverFrame is "frames/<code>/<file>.jpg"
            // relative to the event root; this page lives at
            // sessions/index.html so prefix "../" to climb out before
            // joining. Same applies to the per-session HTML link below.
            const thumb = s.coverFrame
                ? `<img class="card-thumb" loading="lazy" src="../${escapeAttr(s.coverFrame)}" alt="">`
                : `<div class="card-thumb card-thumb-empty" aria-hidden="true"></div>`;

            return `
              <li class="session-card">
                <a class="card-thumb-link" href="${encodeURIComponent(s.code)}.html">${thumb}</a>
                <div class="card-body">
                  <div class="card-row-top">
                    <span class="code">${escapeText(s.code)} &middot; ${escapeText(s.sessionType ?? '')}</span>
                    <span class="card-badges">
                      ${repoBadgeHtml}
                      ${badgeHtml}
                    </span>
                  </div>
                  <h3><a href="${encodeURIComponent(s.code)}.html">${escapeText(s.title)}</a></h3>
                  <div class="speakers">${escapeText(speakers)}</div>
                  <div class="when">${whenHtml}</div>
                  <div class="card-tags">${tags}</div>
                </div>
              </li>`;
        }).join('');
    }

    function lunrSearch(q) {
        if (!q) return null;
        if (lunrIndex) {
            const clean = q.toLowerCase().replace(/[:+\-~^]/g, ' ');
            const terms = clean.split(/\s+/).filter(Boolean);
            const query = terms.map(t => `${t} ${t}*`).join(' ');
            try { return lunrIndex.search(query).map(h => byCode.get(h.ref)).filter(Boolean); }
            catch {
                try { return lunrIndex.search(terms.join(' ')).map(h => byCode.get(h.ref)).filter(Boolean); }
                catch { return []; }
            }
        }
        const terms = q.toLowerCase().split(/\s+/).filter(Boolean);
        return (fallbackDocs ?? []).filter(d => {
            const hay = `${d.title} ${d.code} ${d.speakers} ${d.tags} ${d.topics} ${d.body}`.toLowerCase();
            return terms.every(t => hay.includes(t));
        }).map(d => byCode.get(d.ref)).filter(Boolean);
    }

    function update() {
        const q = search.value.trim();
        const candidates = q ? lunrSearch(q) : catalog.sessions;
        const filtered = applyFilters(candidates ?? []);
        render(filtered);
        updateTopicCounts(filtered);
        updateTagCounts(filtered);
        updateThemeCounts(filtered);
        // Persist the current filter state into the URL so a refresh or
        // shared link reproduces the same view.
        writeUrlState();
    }

    [search, filterTy].forEach(el => el.addEventListener('input', update));
    update();

    // Refresh status badges every 30 s so "Live"/"Upcoming"/"Ended" stays
    // accurate on tabs left open across session boundaries.
    setInterval(update, 30000);
})();
