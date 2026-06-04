/* session.js - per-session-page features that run on every layout:
 *   1. Lightbox: any <a data-zoom="1"> intercepts the click and shows the
 *      target image in a modal overlay. Escape / click-outside closes.
 *   2. Live status badge: any .status-line[data-start][data-end] gets its
 *      .status-badge populated based on the current wall-clock time
 *      ("Upcoming - starts in 2h 15m" / "Live - started 30m ago" / "Ended
 *      3h ago"). Refreshes every 30 s so the badge stays fresh on an open
 *      tab during the conference.
 *
 * No build step. Plain ES module-friendly syntax, runs as a classic script.
 */

(function () {
    'use strict';

    // ---------- Lightbox ----------
    function openLightbox(src, alt) {
        const back = document.createElement('div');
        back.className = 'lightbox-backdrop';
        back.setAttribute('role', 'dialog');
        back.setAttribute('aria-modal', 'true');

        const close = document.createElement('button');
        close.className = 'lightbox-close';
        close.setAttribute('aria-label', 'Close');
        close.textContent = '\u00d7';

        const img = document.createElement('img');
        img.src = src;
        img.alt = alt || '';

        back.appendChild(img);
        back.appendChild(close);
        document.body.appendChild(back);
        document.body.style.overflow = 'hidden';

        function dismiss() {
            back.remove();
            document.body.style.overflow = '';
            document.removeEventListener('keydown', onKey);
        }
        function onKey(e) { if (e.key === 'Escape') dismiss(); }
        back.addEventListener('click', e => {
            // Clicking the image itself shouldn't close; only the backdrop / close button.
            if (e.target === back || e.target === close) dismiss();
        });
        document.addEventListener('keydown', onKey);
    }

    document.addEventListener('click', e => {
        const trigger = e.target.closest('a[data-zoom="1"]');
        if (!trigger) return;
        e.preventDefault();
        const href = trigger.getAttribute('href');
        const alt = trigger.querySelector('img')?.getAttribute('alt') ?? '';
        openLightbox(href, alt);
    });

    // ---------- Live status badge ----------
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

    function refreshStatus() {
        document.querySelectorAll('.status-line[data-start]').forEach(line => {
            const startStr = line.getAttribute('data-start');
            const endStr   = line.getAttribute('data-end');
            if (!startStr) return;
            const start = new Date(startStr);
            const end   = endStr ? new Date(endStr) : null;
            const now   = new Date();
            const badge  = line.querySelector('.status-badge');
            const detail = line.querySelector('.status-detail');
            if (!badge || !detail) return;

            badge.className = 'status-badge';
            if (now < start) {
                badge.classList.add('is-upcoming');
                badge.textContent = 'Upcoming';
                detail.textContent = `Starts in ${fmtDuration(start - now)} (${start.toLocaleString()})`;
            }
            else if (end && now < end) {
                badge.classList.add('is-live');
                badge.textContent = 'Live now';
                const startedAgo = fmtDuration(now - start);
                const remaining  = fmtDuration(end - now);
                detail.textContent = `Started ${startedAgo} ago; ${remaining} remaining`;
            }
            else if (end) {
                badge.classList.add('is-ended');
                badge.textContent = 'Ended';
                detail.textContent = `Ended ${fmtDuration(now - end)} ago (${end.toLocaleString()})`;
            }
            else {
                badge.classList.add('is-ended');
                badge.textContent = 'Past';
                detail.textContent = `Started ${fmtDuration(now - start)} ago`;
            }
        });
    }

    refreshStatus();
    setInterval(refreshStatus, 30000);
})();
