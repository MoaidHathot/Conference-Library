/* hub.js - per-event hub page federated search.
 *
 * Loads hub-catalog.json (slim merged catalog: 443 sessions + 583
 * announcements for Build 2026) and wires the search box to a live inline
 * drop-down panel with up to N mixed results. Each result is a clickable
 * link with a `Session` or `Announcement` category badge. Drop-down also
 * shows two footer links "See all N matches in Sessions / Announcements"
 * that navigate to the deeper catalog pages.
 *
 * No Lunr: at ~1,026 items a substring/token match against pre-built
 * lowercase haystacks is sub-millisecond per keystroke. Avoids loading
 * the heavier sessions + announcements Lunr indexes on the hub.
 *
 * No build step. Plain ES2020 syntax that works as-is on GitHub Pages.
 */

(async function () {
    'use strict';

    const $ = (sel) => document.querySelector(sel);

    const search     = $('#hub-search');
    const resultsBox = $('#hub-search-results');
    if (!search || !resultsBox) return; // hub template missing; nothing to do

    function escapeAttr(s) { return String(s == null ? '' : s).replace(/[&"<>]/g, c => ({'&':'&amp;','"':'&quot;','<':'&lt;','>':'&gt;'}[c])); }
    function escapeText(s) { return String(s == null ? '' : s).replace(/[&<>]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;'}[c])); }

    // ---- fetch the merged catalog ----
    let catalog;
    try {
        const res = await fetch('hub-catalog.json');
        catalog   = await res.json();
    } catch (e) {
        resultsBox.hidden = false;
        resultsBox.innerHTML = '<div class="hub-search-error">Failed to load hub catalog: ' + escapeText(String(e)) + '</div>';
        return;
    }
    const items = Array.isArray(catalog && catalog.items) ? catalog.items : [];
    if (items.length === 0) {
        // Empty catalog (e.g., new event without ingestion run); leave the
        // search box in place but show a hint when the user focuses.
        search.placeholder = 'No items in catalog yet';
        return;
    }

    // Pre-build a lowercase haystack per item for fast substring filter.
    // The catalog already includes a flattened `searchableText`; we just
    // lowercase it once here so per-keystroke filtering is O(N) with no
    // re-allocation.
    for (const it of items) {
        it.__hay = (it.searchableText || '').toLowerCase();
    }

    const MAX_RESULTS = 10;

    function tokenize(q) {
        return q.toLowerCase().split(/\s+/).filter(Boolean);
    }

    function score(item, tokens) {
        // Sum of token-occurrence weights. Title matches outweigh body
        // matches via a per-token bonus on title hits. Returns 0 when the
        // item misses any token (AND semantics across all typed words).
        let s = 0;
        const titleL = (item.title || '').toLowerCase();
        for (const t of tokens) {
            if (!item.__hay.includes(t)) return 0;
            // Title hit gets a boost; rough position bonus too.
            const ti = titleL.indexOf(t);
            if (ti >= 0) {
                s += 5;
                if (ti === 0) s += 2; // exact prefix match on title
            } else {
                s += 1;
            }
        }
        // Mild bias toward shorter titles when scores tie - lets you find
        // "Web IQ" ahead of "Web IQ and Microsoft IQ" when typing 'web iq'.
        s -= Math.min(titleL.length / 200, 0.5);
        return s;
    }

    function runQuery(q) {
        const tokens = tokenize(q);
        if (tokens.length === 0) return { all: [], byType: { session: 0, announcement: 0 } };
        const scored = [];
        let nSession = 0, nAnnouncement = 0;
        for (const it of items) {
            const s = score(it, tokens);
            if (s <= 0) continue;
            scored.push({ item: it, score: s });
            if (it.type === 'session')      nSession++;
            else if (it.type === 'announcement') nAnnouncement++;
        }
        scored.sort((a, b) => b.score - a.score || a.item.title.localeCompare(b.item.title));
        return { all: scored, byType: { session: nSession, announcement: nAnnouncement } };
    }

    function renderResults(q) {
        if (!q.trim()) {
            resultsBox.hidden = true;
            resultsBox.innerHTML = '';
            return;
        }
        const { all, byType } = runQuery(q);
        if (all.length === 0) {
            resultsBox.hidden = false;
            resultsBox.innerHTML =
                '<div class="hub-search-empty">No matches for <strong>' + escapeText(q) + '</strong>. ' +
                'Try the dedicated <a href="sessions/index.html">Sessions search</a> or ' +
                '<a href="announcements/index.html">Announcements search</a> &rarr;.</div>';
            return;
        }
        const top = all.slice(0, MAX_RESULTS);
        const itemsHtml = top.map(s => {
            const it = s.item;
            const badge = it.type === 'session' ? 'Session' : 'Announcement';
            const badgeClass = it.type === 'session' ? 'hub-result-badge-session' : 'hub-result-badge-announcement';
            const subtitle = it.subtitle ? '<small>' + escapeText(it.subtitle) + '</small>' : '';
            return `
<li class="hub-result">
    <a href="${escapeAttr(it.url)}">
        <span class="hub-result-badge ${badgeClass}">${badge}</span>
        <strong>${escapeText(it.title)}</strong>
        ${subtitle}
    </a>
</li>`;
        }).join('');

        const footerLinks = [];
        if (byType.session > 0) {
            footerLinks.push('<a href="sessions/index.html">See all ' + byType.session + ' session match' + (byType.session === 1 ? '' : 'es') + ' &rarr;</a>');
        }
        if (byType.announcement > 0) {
            footerLinks.push('<a href="announcements/index.html">See all ' + byType.announcement + ' announcement match' + (byType.announcement === 1 ? '' : 'es') + ' &rarr;</a>');
        }
        const footer = footerLinks.length > 0
            ? '<div class="hub-search-footer">' + footerLinks.join(' &middot; ') + '</div>'
            : '';

        resultsBox.hidden = false;
        resultsBox.innerHTML =
            '<div class="hub-search-meta">Showing ' + Math.min(top.length, MAX_RESULTS) +
            ' of ' + all.length + ' match' + (all.length === 1 ? '' : 'es') + '</div>' +
            '<ul class="hub-result-list">' + itemsHtml + '</ul>' +
            footer;
    }

    let debounce;
    search.addEventListener('input', () => {
        clearTimeout(debounce);
        debounce = setTimeout(() => renderResults(search.value), 60);
    });

    // Close the drop-down on Escape; restore focus to the input.
    search.addEventListener('keydown', (ev) => {
        if (ev.key === 'Escape') {
            search.value = '';
            renderResults('');
        }
    });

    // Click-outside dismissal (but keep open if user clicks inside the panel
    // or on the search box itself).
    document.addEventListener('click', (ev) => {
        if (resultsBox.hidden) return;
        if (ev.target === search || resultsBox.contains(ev.target)) return;
        resultsBox.hidden = true;
    });
})();
