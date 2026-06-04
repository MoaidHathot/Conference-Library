/* app.js — index page search/filter logic.
 *
 * Loads catalog.json (slim per-session metadata) and search-index.json (a
 * pre-built Lunr index that already has the per-session text indexed). The
 * page has a free-text search box plus three optional <select> filters
 * (sessionType, topic, tag). The Lunr query is intersected with the active
 * filter values before rendering.
 *
 * No build step. Plain ES module syntax (script type=module) -> works as-is
 * in modern browsers and on GitHub Pages.
 */

(async function () {
    'use strict';

    const $ = (sel) => document.querySelector(sel);
    const $$ = (sel) => Array.from(document.querySelectorAll(sel));

    const list      = $('#session-list');
    const meta      = $('#results-meta');
    const search    = $('#filter-search');
    const filterTy  = $('#filter-type');
    const filterTo  = $('#filter-topic');
    const filterTa  = $('#filter-tag');
    const noResults = $('#no-results');

    // ---- load data ----
    const [catalog, indexJson] = await Promise.all([
        fetch('catalog.json').then(r => r.json()),
        fetch('search-index.json').then(r => r.json())
    ]);

    // Lunr's serialized index needs Index.load(). If the build host had no
    // node available, the index is a fallback shape ({__fallback:true,documents:[...]})
    // and we degrade to a substring scan instead of a Lunr query.
    const isFallback = indexJson && indexJson.__fallback === true;
    const lunrIndex = isFallback ? null : lunr.Index.load(indexJson);
    const fallbackDocs = isFallback ? indexJson.documents : null;
    const byCode = new Map(catalog.sessions.map(s => [s.code, s]));

    // ---- populate dropdowns from observed values ----
    function unique(values) {
        return [...new Set(values.flatMap(v => Array.isArray(v) ? v : (v ? [v] : [])))].sort();
    }
    function fillSelect(el, values, label) {
        el.innerHTML = `<option value="">All ${label}</option>` +
            values.map(v => `<option value="${escapeAttr(v)}">${escapeText(v)}</option>`).join('');
    }
    fillSelect(filterTy, unique(catalog.sessions.map(s => s.sessionType)), 'types');
    fillSelect(filterTo, unique(catalog.sessions.map(s => s.topics)),      'topics');
    fillSelect(filterTa, unique(catalog.sessions.map(s => s.tags)),        'tags');

    // ---- render ----
    function escapeAttr(s) { return String(s).replace(/[&"<>]/g, c => ({'&':'&amp;','"':'&quot;','<':'&lt;','>':'&gt;'}[c])); }
    function escapeText(s) { return String(s).replace(/[&<>]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;'}[c])); }

    function render(matches) {
        meta.textContent = matches.length
            ? `${matches.length} of ${catalog.sessions.length} sessions`
            : '';
        if (matches.length === 0) {
            list.innerHTML = '';
            noResults.hidden = false;
            return;
        }
        noResults.hidden = true;
        list.innerHTML = matches.map(s => {
            const tags = (s.tags ?? []).slice(0, 4).map(t =>
                `<span class="tag">${escapeText(t)}</span>`).join('');
            const speakers = s.speakerNames || '';
            return `
              <li class="session-card">
                <span class="code">${escapeText(s.code)} &middot; ${escapeText(s.sessionType ?? '')}</span>
                <h3><a href="sessions/${encodeURIComponent(s.code)}.html">${escapeText(s.title)}</a></h3>
                <div class="speakers">${escapeText(speakers)}</div>
                <div class="meta">${tags}</div>
              </li>`;
        }).join('');
    }

    function activeFilters() {
        return {
            q:    search.value.trim(),
            type: filterTy.value,
            topic: filterTo.value,
            tag:  filterTa.value
        };
    }

    function applyFilters(sessions, f) {
        return sessions.filter(s => {
            if (f.type  && s.sessionType !== f.type)             return false;
            if (f.topic && !(s.topics ?? []).includes(f.topic))  return false;
            if (f.tag   && !(s.tags   ?? []).includes(f.tag))    return false;
            return true;
        });
    }

    function update() {
        const f = activeFilters();

        let candidates;
        if (f.q) {
            if (lunrIndex) {
                // For each whitespace-separated user term, query Lunr with
                // BOTH the plain term and a wildcard variant:
                //   - plain term runs through the Porter stemmer pipeline so
                //     "keynote" matches the indexed stem "keynot"
                //   - "term*" bypasses the pipeline and matches the literal
                //     prefix in the token set, so "keyn*" still works
                // Lunr OR-combines the terms by default, maximising recall.
                // Strip Lunr's own query operators (':', '+', '-', '~', '^')
                // to keep the parser happy on punctuation-heavy free text.
                let hits = [];
                const clean = f.q.toLowerCase().replace(/[:+\-~^]/g, ' ');
                const terms = clean.split(/\s+/).filter(Boolean);
                const query = terms.map(t => `${t} ${t}*`).join(' ');
                try {
                    hits = lunrIndex.search(query);
                } catch {
                    // Fall back to literal-term query (no wildcards) when the
                    // parser still rejects something odd.
                    try { hits = lunrIndex.search(terms.join(' ')); } catch { hits = []; }
                }
                candidates = hits
                    .map(h => byCode.get(h.ref))
                    .filter(Boolean);
            } else {
                // No-Lunr fallback: substring scan across the pre-extracted
                // document bodies, matching any of the whitespace-split terms.
                const terms = f.q.toLowerCase().split(/\s+/).filter(Boolean);
                const hits = (fallbackDocs ?? []).filter(d => {
                    const hay = `${d.title} ${d.code} ${d.speakers} ${d.tags} ${d.topics} ${d.body}`.toLowerCase();
                    return terms.every(t => hay.includes(t));
                });
                candidates = hits.map(h => byCode.get(h.ref)).filter(Boolean);
            }
        } else {
            candidates = catalog.sessions;
        }

        render(applyFilters(candidates, f));
    }

    [search, filterTy, filterTo, filterTa].forEach(el => el.addEventListener('input', update));
    update();
})();
