/* speakers.js - per-event speakers landing page
 * (docs/<Conf>/<Event>/speakers/index.html).
 *
 * Loads speakers-catalog.json (slim per-speaker metadata) and
 * speakers-search-index.json (pre-built Lunr index, identical format to
 * the session search index). Wires up:
 *   - free-text search (Lunr; OR-of-terms with stemming + wildcard fallback)
 *   - sort dropdown (most sessions / name A-Z / name Z-A)
 *   - sessionCount bucket pills (5+, 3-4, 2, 1; multi-select)
 *   - tag rollup pills (multi-select, AND-combined)
 *
 * Mirrors announcements.js's coding conventions so the three index pages
 * (sessions, announcements, speakers) read alike.
 *
 * No build step. Plain ES2020 syntax that works as-is on GitHub Pages.
 */

(async function () {
    'use strict';

    const $  = (sel) => document.querySelector(sel);

    const list         = $('#spk-list');
    const meta         = $('#spk-results-meta');
    const search       = $('#spk-filter-search');
    const sortSel      = $('#spk-filter-sort');
    const tagPills     = $('#spk-filter-tag-pills');
    const bucketPills  = document.querySelectorAll('#spk-filter-activity [data-bucket]');
    const noResults    = $('#spk-no-results');

    function escapeAttr(s) { return String(s == null ? '' : s).replace(/[&"<>]/g, c => ({'&':'&amp;','"':'&quot;','<':'&lt;','>':'&gt;'}[c])); }
    function escapeText(s) { return String(s == null ? '' : s).replace(/[&<>]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;'}[c])); }

    function toArray(v) {
        if (Array.isArray(v)) return v;
        if (v === null || v === undefined || v === '') return [];
        return [v];
    }

    // Map a sessionCount onto its bucket key. Must match the data-bucket
    // values used by the activity pills in the template.
    function bucketOf(n) {
        if (n >= 5) return '5';
        if (n >= 3) return '3';
        if (n === 2) return '2';
        return '1';
    }

    // ---- fetch data ----
    let catalog;
    let lunr_index_raw;
    try {
        const [catRes, idxRes] = await Promise.all([
            fetch('../speakers-catalog.json'),
            fetch('../speakers-search-index.json')
        ]);
        catalog        = await catRes.json();
        lunr_index_raw = await idxRes.json();
    } catch (e) {
        list.innerHTML = '<li class="error">Failed to load speaker data: ' + escapeText(String(e)) + '</li>';
        return;
    }

    const speakers = toArray(catalog && catalog.speakers);
    if (speakers.length === 0) {
        list.innerHTML = '<li class="error">No speakers have been resolved yet. Run scripts/Resolve-Speakers.ps1, then re-render.</li>';
        return;
    }

    // Build the Lunr instance with a string-match fallback; same dance as
    // app.js / announcements.js.
    let lunrIdx = null;
    if (!lunr_index_raw.__fallback && typeof lunr !== 'undefined') {
        try { lunrIdx = lunr.Index.load(lunr_index_raw); } catch (e) { lunrIdx = null; }
    }

    function runSearch(query) {
        const q = (query || '').trim().toLowerCase();
        if (!q) return null; // null = no search filter, show everything
        if (lunrIdx) {
            const terms = q.split(/\s+/).filter(Boolean);
            const lunrQ = terms.map(t => {
                t = t.replace(/[:^~*+?\\(){}\[\]"]/g, '');
                if (!t) return '';
                return `${t}^2 ${t}* *${t}*`;
            }).join(' ');
            try {
                const hits = lunrIdx.search(lunrQ);
                return new Set(hits.map(h => h.ref));
            } catch (e) {
                // fall through to substring
            }
        }
        return new Set(speakers
            .filter(s => {
                const variants = toArray(s.nameVariants).join(' ');
                const hay = [s.name, variants].join(' ').toLowerCase();
                return hay.includes(q);
            })
            .map(s => s.id));
    }

    // ---- URL state helpers ----
    function parseUrlState() {
        const u = new URL(window.location.href);
        const v = (k) => u.searchParams.get(k);
        const splitCsv = (s) => (s == null || s === '') ? [] : s.split(',').filter(Boolean);
        return {
            search:  v('q')    ?? '',
            sortBy:  v('sort') ?? 'sessions',
            buckets: new Set(splitCsv(v('bucket'))),
            tags:    new Set(splitCsv(v('tag')))
        };
    }
    function writeUrlState() {
        const u = new URL(window.location.href);
        const set = (k, val) => {
            if (val == null || val === '' || val === false) u.searchParams.delete(k);
            else u.searchParams.set(k, val);
        };
        set('q',      state.search.trim());
        set('sort',   state.sortBy === 'sessions' ? '' : state.sortBy); // omit default
        set('bucket', state.buckets.size ? Array.from(state.buckets).join(',') : '');
        set('tag',    state.tags.size    ? Array.from(state.tags).join(',')    : '');
        window.history.replaceState(null, '', u.toString());
    }

    // ---- state ----
    const state = parseUrlState();
    search.value  = state.search;
    sortSel.value = state.sortBy;

    // ---- tag pills (rolled up from per-speaker tags[]) ----
    const tagCounts = {};
    for (const s of speakers) {
        for (const t of toArray(s.tags)) {
            tagCounts[t] = (tagCounts[t] || 0) + 1;
        }
    }
    const tagList = Object.keys(tagCounts).sort((a, b) => (tagCounts[b] - tagCounts[a]) || a.localeCompare(b));
    tagPills.innerHTML =
        '<span class="pill-label">Tag</span>' +
        tagList.map(t => {
            const on = state.tags.has(t) ? ' is-on' : '';
            return `<button type="button" class="filter-pill${on}" data-tag="${escapeAttr(t)}">${escapeText(t)} <span class="pill-count">(${tagCounts[t]})</span></button>`;
        }).join('');

    tagPills.addEventListener('click', (ev) => {
        const btn = ev.target.closest('[data-tag]');
        if (!btn) return;
        const t = btn.dataset.tag;
        if (state.tags.has(t)) state.tags.delete(t);
        else                    state.tags.add(t);
        btn.classList.toggle('is-on', state.tags.has(t));
        render();
    });

    // ---- bucket pills ----
    bucketPills.forEach(btn => {
        if (state.buckets.has(btn.dataset.bucket)) btn.classList.add('is-on');
        btn.addEventListener('click', () => {
            const b = btn.dataset.bucket;
            if (state.buckets.has(b)) state.buckets.delete(b);
            else                       state.buckets.add(b);
            btn.classList.toggle('is-on');
            render();
        });
    });

    // ---- search + sort ----
    let searchDebounce;
    search.addEventListener('input', () => {
        clearTimeout(searchDebounce);
        searchDebounce = setTimeout(() => { state.search = search.value; render(); }, 80);
    });
    sortSel.addEventListener('change', () => { state.sortBy = sortSel.value; render(); });

    // ---- render ----
    function render() {
        writeUrlState();
        const searchSet = runSearch(state.search);
        let rows = speakers.filter(s => {
            if (searchSet && !searchSet.has(s.id)) return false;
            if (state.buckets.size > 0) {
                if (!state.buckets.has(bucketOf(s.sessionCount))) return false;
            }
            if (state.tags.size > 0) {
                const sTags = toArray(s.tags);
                for (const t of state.tags) {
                    if (!sTags.includes(t)) return false;
                }
            }
            return true;
        });

        switch (state.sortBy) {
            case 'name':
                rows.sort((a, b) => a.name.localeCompare(b.name, undefined, { sensitivity: 'base' }));
                break;
            case 'nameDesc':
                rows.sort((a, b) => b.name.localeCompare(a.name, undefined, { sensitivity: 'base' }));
                break;
            case 'sessions':
            default:
                rows.sort((a, b) => {
                    const d = b.sessionCount - a.sessionCount;
                    if (d !== 0) return d;
                    return a.name.localeCompare(b.name, undefined, { sensitivity: 'base' });
                });
                break;
        }

        if (rows.length === 0) {
            list.innerHTML = '';
            noResults.hidden = false;
            meta.textContent = '0 of ' + speakers.length + ' speakers';
            return;
        }
        noResults.hidden = true;
        meta.textContent = rows.length === speakers.length
            ? `${speakers.length} speaker(s)`
            : `${rows.length} of ${speakers.length} speaker(s)`;

        list.innerHTML = rows.map(renderCard).join('');
    }

    function renderCard(s) {
        const sessionsLine = s.sessionCount > 1
            ? `<small>${s.sessionCount} sessions</small>`
            : `<small>1 session</small>`;

        // Show the top 3 tags as small chips for quick scanning.
        const tagsHtml = toArray(s.tags).slice(0, 3).map(t =>
            `<span class="tag tag-tiny">${escapeText(t)}</span>`).join('');

        return `
<li class="entity-card">
    <a href="${escapeAttr(s.slug)}.html">
        <div class="entity-card-head">
            <span class="entity-cat entity-cat-speaker">Speaker</span>
        </div>
        <strong>${escapeText(s.name)}</strong>
        ${sessionsLine}
        <div class="card-tags">${tagsHtml}</div>
    </a>
</li>`;
    }

    render();
})();
