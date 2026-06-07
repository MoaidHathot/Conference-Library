/* themes.js - per-event themes landing page
 * (docs/<Conf>/<Event>/themes/index.html).
 *
 * Loads themes-catalog.json (slim per-theme metadata) and
 * themes-search-index.json (pre-built Lunr index over name + description).
 * Wires up:
 *   - free-text search (Lunr; OR-of-terms with stemming + wildcard fallback)
 *   - sort dropdown (most sessions / name A-Z)
 *
 * No Lunr fallback: themes are a small (15-25) flat list, so a substring
 * scan over name + description is sub-millisecond even on the slowest
 * client. Lunr is still used when available because the lunr.min.js
 * bundle is already loaded by other index pages in this folder.
 *
 * URL state: q=, sort=. Mirrors app.js / announcements.js / speakers.js.
 *
 * No build step. Plain ES2020 syntax that works as-is on GitHub Pages.
 */

(async function () {
    'use strict';

    const $  = (sel) => document.querySelector(sel);

    const list     = $('#thm-list');
    const meta     = $('#thm-results-meta');
    const search   = $('#thm-filter-search');
    const sortSel  = $('#thm-filter-sort');
    const noResults = $('#thm-no-results');

    function escapeAttr(s) { return String(s == null ? '' : s).replace(/[&"<>]/g, c => ({'&':'&amp;','"':'&quot;','<':'&lt;','>':'&gt;'}[c])); }
    function escapeText(s) { return String(s == null ? '' : s).replace(/[&<>]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;'}[c])); }

    function toArray(v) {
        if (Array.isArray(v)) return v;
        if (v === null || v === undefined || v === '') return [];
        return [v];
    }

    // ---- fetch data ----
    let catalog;
    let lunr_index_raw;
    try {
        const [catRes, idxRes] = await Promise.all([
            fetch('../themes-catalog.json'),
            fetch('../themes-search-index.json')
        ]);
        catalog        = await catRes.json();
        lunr_index_raw = await idxRes.json();
    } catch (e) {
        list.innerHTML = '<li class="error">Failed to load theme data: ' + escapeText(String(e)) + '</li>';
        return;
    }

    const themes = toArray(catalog && catalog.themes);
    if (themes.length === 0) {
        list.innerHTML = '<li class="error">No themes have been resolved yet. Run scripts/Resolve-Themes.ps1, then re-render.</li>';
        return;
    }

    let lunrIdx = null;
    if (!lunr_index_raw.__fallback && typeof lunr !== 'undefined') {
        try { lunrIdx = lunr.Index.load(lunr_index_raw); } catch (e) { lunrIdx = null; }
    }

    function runSearch(query) {
        const q = (query || '').trim().toLowerCase();
        if (!q) return null;
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
            } catch (e) { /* fall through */ }
        }
        return new Set(themes
            .filter(t => (t.name + ' ' + t.description).toLowerCase().includes(q))
            .map(t => t.slug));
    }

    // ---- URL state helpers ----
    function parseUrlState() {
        const u = new URL(window.location.href);
        const v = (k) => u.searchParams.get(k);
        return {
            search: v('q')    ?? '',
            sortBy: v('sort') ?? 'sessions'
        };
    }
    function writeUrlState() {
        const u = new URL(window.location.href);
        const set = (k, val) => {
            if (val == null || val === '' || val === false) u.searchParams.delete(k);
            else u.searchParams.set(k, val);
        };
        set('q',    state.search.trim());
        set('sort', state.sortBy === 'sessions' ? '' : state.sortBy);
        window.history.replaceState(null, '', u.toString());
    }

    const state = parseUrlState();
    search.value  = state.search;
    sortSel.value = state.sortBy;

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
        let rows = themes.filter(t => searchSet ? searchSet.has(t.slug) : true);

        if (state.sortBy === 'name') {
            rows.sort((a, b) => a.name.localeCompare(b.name, undefined, { sensitivity: 'base' }));
        } else {
            rows.sort((a, b) => {
                const d = (b.sessionCount || 0) - (a.sessionCount || 0);
                if (d !== 0) return d;
                return a.name.localeCompare(b.name, undefined, { sensitivity: 'base' });
            });
        }

        if (rows.length === 0) {
            list.innerHTML = '';
            noResults.hidden = false;
            meta.textContent = '0 of ' + themes.length + ' themes';
            return;
        }
        noResults.hidden = true;
        meta.textContent = rows.length === themes.length
            ? `${themes.length} theme(s)`
            : `${rows.length} of ${themes.length} theme(s)`;

        list.innerHTML = rows.map(renderCard).join('');
    }

    function renderCard(t) {
        const sessionsLine = (t.sessionCount === 1)
            ? `<small>1 session</small>`
            : `<small>${t.sessionCount} sessions</small>`;
        return `
<li class="entity-card">
    <a href="${escapeAttr(t.slug)}.html">
        <div class="entity-card-head">
            <span class="entity-cat entity-cat-theme">Theme</span>
        </div>
        <strong>${escapeText(t.name)}</strong>
        <span class="entity-tagline-card">${escapeText(t.description || '')}</span>
        ${sessionsLine}
    </a>
</li>`;
    }

    render();
})();
