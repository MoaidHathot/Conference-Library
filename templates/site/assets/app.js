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
    const topicPills  = $('#filter-topic-pills');
    const tagPills    = $('#filter-tag-pills');
    const statusBtns  = document.querySelectorAll('#filter-status [data-status]');
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

    // Multi-select pill renderer used for both topic + tag filters. Each pill
    // toggles via click; selection set is held in `chosen` (Set<string>).
    // Pills also display a count of currently-visible sessions matching them.
    function buildPills(container, label, values, getValues, chosen, onChange) {
        container.innerHTML = '';
        const labelEl = document.createElement('span');
        labelEl.className = 'pill-label';
        labelEl.textContent = label;
        container.appendChild(labelEl);

        const pillById = new Map();
        values.forEach(v => {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'filter-pill';
            btn.dataset.value = v;
            btn.innerHTML = `${escapeText(v)} <span class="pill-count"></span>`;
            btn.addEventListener('click', () => {
                if (chosen.has(v)) chosen.delete(v); else chosen.add(v);
                btn.classList.toggle('is-on', chosen.has(v));
                onChange();
            });
            container.appendChild(btn);
            pillById.set(v, btn);
        });

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

        // Updater for the counts displayed in each pill - called from update().
        return function updateCounts(visibleSessions) {
            pillById.forEach((btn, val) => {
                const n = visibleSessions.filter(s => toArray(getValues(s)).includes(val)).length;
                btn.querySelector('.pill-count').textContent = n ? `(${n})` : '';
                btn.style.display = (n > 0 || chosen.has(val)) ? '' : 'none';
            });
        };
    }

    const chosenTopics = new Set();
    const chosenTags   = new Set();
    const updateTopicCounts = buildPills(topicPills, 'Topics',
        unique(catalog.sessions.map(s => s.topics)), s => s.topics, chosenTopics, () => update());
    const updateTagCounts = buildPills(tagPills, 'Tags',
        unique(catalog.sessions.map(s => s.tags)), s => s.tags, chosenTags, () => update());

    let statusFilter = 'all';
    statusBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            statusFilter = btn.dataset.status;
            statusBtns.forEach(b => b.classList.toggle('is-on', b === btn));
            update();
        });
    });
    // Default "All" selected.
    statusBtns.forEach(b => { if (b.dataset.status === 'all') b.classList.add('is-on'); });

    // ---- filtering + render ----
    function applyFilters(sessions) {
        const now = new Date();
        return sessions.filter(s => {
            if (filterTy.value && s.sessionType !== filterTy.value) return false;
            if (chosenTopics.size > 0) {
                const topics = toArray(s.topics);
                for (const t of chosenTopics) { if (!topics.includes(t)) return false; }
            }
            if (chosenTags.size > 0) {
                const tags = toArray(s.tags);
                for (const t of chosenTags) { if (!tags.includes(t)) return false; }
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
            const tags = toArray(s.tags).slice(0, 4).map(t =>
                `<span class="tag">${escapeText(t)}</span>`).join('');
            const speakers = s.speakerNames || '';
            const st = sessionStatus(s, now);
            const badgeCls = st.kind === 'live' ? 'is-live'
                          : st.kind === 'upcoming' ? 'is-upcoming'
                          : st.kind === 'ended' ? 'is-ended' : '';
            const statusHtml = st.label
                ? `<span class="status-badge ${badgeCls}">${escapeText(st.label)}</span> <span class="status-detail">${escapeText(st.detail || '')}</span>`
                : '';
            return `
              <li class="session-card">
                <span class="code">${escapeText(s.code)} &middot; ${escapeText(s.sessionType ?? '')}</span>
                <h3><a href="sessions/${encodeURIComponent(s.code)}.html">${escapeText(s.title)}</a></h3>
                <div class="speakers">${escapeText(speakers)}</div>
                <div class="status-line">${statusHtml}</div>
                <div class="meta">${tags}</div>
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
    }

    [search, filterTy].forEach(el => el.addEventListener('input', update));
    update();

    // Refresh status badges every 30 s so "Live"/"Upcoming"/"Ended" stays
    // accurate on tabs left open across session boundaries.
    setInterval(update, 30000);
})();
