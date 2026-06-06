/* announcements.js - per-event announcements landing page
 * (docs/<Conf>/<Event>/announcements/index.html).
 *
 * Loads announcement-catalog.json (slim per-entity metadata) and
 * announcement-search-index.json (pre-built Lunr index, identical format to
 * the session search index). Wires up:
 *   - free-text search (Lunr; OR-of-terms with stemming + wildcard fallback)
 *   - category pills (multi-select, OR-combined - 12-bucket fixed taxonomy)
 *   - "Has GitHub", "Has NuGet", "Has Docs", "Any link" toggle pills
 *   - sort dropdown (most mentioned / name / first announced / category)
 *
 * No build step. Plain ES2020 syntax that works as-is on GitHub Pages,
 * mirroring app.js's coding conventions so the two scripts read alike.
 */

(async function () {
    'use strict';

    const $  = (sel) => document.querySelector(sel);

    const list         = $('#ent-list');
    const meta         = $('#ent-results-meta');
    const search       = $('#ent-filter-search');
    const sortSel      = $('#ent-filter-sort');
    const catPills     = $('#ent-filter-cat-pills');
    const linkPills    = document.querySelectorAll('#ent-filter-haslink [data-haslink]');
    const noResults    = $('#ent-no-results');

    function escapeAttr(s) { return String(s == null ? '' : s).replace(/[&"<>]/g, c => ({'&':'&amp;','"':'&quot;','<':'&lt;','>':'&gt;'}[c])); }
    function escapeText(s) { return String(s == null ? '' : s).replace(/[&<>]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;'}[c])); }

    function toArray(v) {
        if (Array.isArray(v)) return v;
        if (v === null || v === undefined || v === '') return [];
        return [v];
    }

    // Map fixed-taxonomy slug labels (must match Build-Book.ps1's CategorySlug
    // helper). Used for the chip label and CSS modifier suffix.
    const CAT_LABEL = {
        model:     'Model',
        service:   'Service',
        SDK:       'SDK',
        framework: 'Framework',
        library:   'Library',
        tool:      'Tool',
        runtime:   'Runtime',
        hardware:  'Hardware',
        spec:      'Spec',
        feature:   'Feature',
        platform:  'Platform',
        concept:   'Concept'
    };

    // ---- fetch data ----
    let catalog;
    let lunr_index_raw;
    try {
        const [catRes, idxRes] = await Promise.all([
            fetch('../announcement-catalog.json'),
            fetch('../announcement-search-index.json')
        ]);
        catalog        = await catRes.json();
        lunr_index_raw = await idxRes.json();
    } catch (e) {
        list.innerHTML = '<li class="error">Failed to load announcement data: ' + escapeText(String(e)) + '</li>';
        return;
    }

    const entities = toArray(catalog && catalog.entities);
    if (entities.length === 0) {
        list.innerHTML = '<li class="error">No announcements have been resolved yet. Run scripts/Get-SessionAnnouncements.ps1 + Resolve-AnnouncementEntities.ps1 + Enrich-AnnouncementLinks.ps1, then re-render.</li>';
        return;
    }

    // Build Lunr instance from the prebuilt index, with a string-match
    // fallback for environments where the build pipeline emitted the
    // fallback shape (catalog only, no real index). app.js uses the same
    // dance for session search.
    let lunrIdx = null;
    if (!lunr_index_raw.__fallback && typeof lunr !== 'undefined') {
        try { lunrIdx = lunr.Index.load(lunr_index_raw); } catch (e) { lunrIdx = null; }
    }

    function runSearch(query) {
        const q = (query || '').trim().toLowerCase();
        if (!q) return null; // null = no search filter, show everything
        if (lunrIdx) {
            // OR-combine bare terms with a wildcard fallback so partial typing
            // still finds results ("foun" matches "Foundry"). Identical to
            // app.js's strategy.
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
                // Lunr can throw on malformed input; fall through to substring.
            }
        }
        // Substring fallback.
        return new Set(entities
            .filter(e => {
                const hay = [e.canonicalName, e.tagline, e.category, ...(toArray(e.aliases))].join(' ').toLowerCase();
                return hay.includes(q);
            })
            .map(e => e.id));
    }

    // ---- state ----
    const state = {
        search: '',
        sortBy: 'mentions',
        cats:   new Set(),  // selected categories (empty = all)
        links:  new Set()   // selected has-link kinds: 'github','nuget','docs','any'
    };

    // ---- category chips ----
    const cats = Array.from(new Set(entities.map(e => e.category))).filter(Boolean);
    // Sort by frequency desc.
    const catCounts = {};
    for (const e of entities) catCounts[e.category] = (catCounts[e.category] || 0) + 1;
    cats.sort((a, b) => (catCounts[b] || 0) - (catCounts[a] || 0));
    catPills.innerHTML =
        '<span class="pill-label">Category</span>' +
        '<button type="button" class="filter-pill" data-cat="">All</button>' +
        cats.map(c => `<button type="button" class="filter-pill" data-cat="${escapeAttr(c)}">${escapeText(CAT_LABEL[c] || c)} <span class="pill-count">(${catCounts[c]})</span></button>`).join('');

    catPills.addEventListener('click', (ev) => {
        const btn = ev.target.closest('[data-cat]');
        if (!btn) return;
        const c = btn.dataset.cat;
        if (c === '') {
            state.cats.clear();
        } else {
            if (state.cats.has(c)) state.cats.delete(c);
            else                    state.cats.add(c);
        }
        catPills.querySelectorAll('[data-cat]').forEach(b => {
            const v = b.dataset.cat;
            const on = v === '' ? state.cats.size === 0 : state.cats.has(v);
            b.classList.toggle('is-on', on);
        });
        render();
    });
    // Initial "All" highlight.
    catPills.querySelector('[data-cat=""]').classList.add('is-on');

    // ---- has-link pills ----
    linkPills.forEach(btn => {
        btn.addEventListener('click', () => {
            const k = btn.dataset.haslink;
            if (state.links.has(k)) state.links.delete(k);
            else                     state.links.add(k);
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
        const searchSet = runSearch(state.search);
        let rows = entities.filter(e => {
            if (searchSet && !searchSet.has(e.id)) return false;
            if (state.cats.size > 0 && !state.cats.has(e.category)) return false;
            if (state.links.size > 0) {
                const counts = e.linkCounts || {};
                let pass = false;
                if (state.links.has('any')    && counts.total  > 0)    pass = true;
                if (state.links.has('github') && counts.github > 0)    pass = true;
                if (state.links.has('nuget')  && counts.nuget  > 0)    pass = true;
                if (state.links.has('docs')   && counts.docs   > 0)    pass = true;
                if (!pass) return false;
            }
            return true;
        });

        switch (state.sortBy) {
            case 'name':
                rows.sort((a, b) => a.canonicalName.localeCompare(b.canonicalName, undefined, { sensitivity: 'base' }));
                break;
            case 'firstSeen':
                rows.sort((a, b) => {
                    const aa = (a.firstMention && a.firstMention.sessionCode) || '';
                    const bb = (b.firstMention && b.firstMention.sessionCode) || '';
                    if (aa !== bb) return aa.localeCompare(bb);
                    return (a.firstMention?.timestampSeconds || 0) - (b.firstMention?.timestampSeconds || 0);
                });
                break;
            case 'category':
                rows.sort((a, b) => {
                    const c = a.category.localeCompare(b.category);
                    if (c !== 0) return c;
                    return b.mentionCount - a.mentionCount;
                });
                break;
            case 'mentions':
            default:
                rows.sort((a, b) => {
                    const d = b.mentionCount - a.mentionCount;
                    if (d !== 0) return d;
                    return a.canonicalName.localeCompare(b.canonicalName, undefined, { sensitivity: 'base' });
                });
                break;
        }

        if (rows.length === 0) {
            list.innerHTML = '';
            noResults.hidden = false;
            meta.textContent = '0 of ' + entities.length + ' announcements';
            return;
        }
        noResults.hidden = true;
        meta.textContent = rows.length === entities.length
            ? `${entities.length} announcement(s)`
            : `${rows.length} of ${entities.length} announcement(s)`;

        list.innerHTML = rows.map(renderCard).join('');
    }

    function renderCard(e) {
        const counts = e.linkCounts || {};
        const linkBadges = [];
        if (counts.github > 0) linkBadges.push('<span class="link-badge" title="Has a known GitHub link">GH</span>');
        if (counts.nuget  > 0) linkBadges.push('<span class="link-badge" title="Has a known NuGet link">NuGet</span>');
        if (counts.docs   > 0) linkBadges.push('<span class="link-badge" title="Has a known docs link">Docs</span>');

        const firstSession = (e.firstMention && e.firstMention.sessionCode) || '';
        const firstTs      = (e.firstMention && e.firstMention.timestamp)   || '';
        const firstLine    = firstSession
            ? `<small>First in <a href="../sessions/${escapeAttr(firstSession)}.html">${escapeText(firstSession)}</a>${firstTs ? ' @ ' + escapeText(firstTs) : ''}</small>`
            : '';

        const sessionsLine = e.sessionCount > 1
            ? `<small>${e.mentionCount} mention(s) across ${e.sessionCount} session(s)</small>`
            : `<small>${e.mentionCount} mention(s)</small>`;

        return `
<li class="entity-card">
    <a href="${escapeAttr(e.slug)}.html">
        <div class="entity-card-head">
            <span class="entity-cat entity-cat-${escapeAttr(e.category)}">${escapeText(CAT_LABEL[e.category] || e.category)}</span>
            ${linkBadges.length ? '<span class="entity-card-badges">' + linkBadges.join('') + '</span>' : ''}
        </div>
        <strong>${escapeText(e.canonicalName)}</strong>
        <span class="entity-tagline-card">${escapeText(e.tagline || '')}</span>
        ${sessionsLine}
        ${firstLine}
    </a>
</li>`;
    }

    render();
})();
