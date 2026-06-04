/* session.js - per-session-page features that run on every layout:
 *   1. Lightbox: any <a data-zoom="1"> intercepts the click and shows the
 *      target image in a modal overlay. Escape / click-outside closes.
 *   2. Announcement-frame strips: click the [HH:MM:SS] timestamp to toggle a
 *      sticky strip of context frames (replacing the older hover-only
 *      behaviour which had a hover-gap bug + didn't work on touch devices).
 *      The strip stays open until you click outside it or press Escape.
 *   3. Live status badge: any .status-line[data-start][data-end] gets its
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

    // ---------- Announcement-frame strip toggle ----------
    // The strip is hidden by default. Clicking the .anchor (the [HH:MM:SS]
    // text) toggles an .is-open class on it; CSS then promotes the strip to
    // display:flex. A second click anywhere outside the open anchor closes
    // it. Hovering still works as a transient peek for desktop users.

    function closeAllStrips() {
        document.querySelectorAll('.anchor.is-open').forEach(a => a.classList.remove('is-open'));
    }

    // ---------- Global click handler ----------
    // Single delegated handler so dynamically-injected content also works.
    document.addEventListener('click', e => {
        // 1) Zoom-trigger: any <a data-zoom="1"> opens the lightbox.
        //    Checked BEFORE the strip-close logic so clicking a frame inside
        //    an open strip enlarges instead of just closing the strip.
        const zoomTrigger = e.target.closest('a[data-zoom="1"]');
        if (zoomTrigger) {
            e.preventDefault();
            e.stopPropagation();
            const href = zoomTrigger.getAttribute('href');
            const alt  = zoomTrigger.querySelector('img')?.getAttribute('alt') ?? '';
            openLightbox(href, alt);
            return;
        }

        // 2) Anchor (timestamp) click toggles the strip open/closed.
        //    Use e.target directly so a click on a CHILD of .anchor (e.g.
        //    when the strip itself is rendered inside it) doesn't re-toggle.
        //    closest('.anchor') with === current check is the trick.
        const anchorClicked = e.target.closest('.anchor');
        if (anchorClicked) {
            // Only the anchor's own text should toggle. Clicks inside the
            // strip (which is a child of .anchor) shouldn't close it.
            const insideStrip = e.target.closest('.af-strip');
            if (!insideStrip) {
                const willOpen = !anchorClicked.classList.contains('is-open');
                closeAllStrips();
                if (willOpen) anchorClicked.classList.add('is-open');
                e.preventDefault();
                e.stopPropagation();
            }
            return;
        }

        // 3) Click anywhere else closes any open strip.
        closeAllStrips();
    });

    // Escape closes any open strip too (in addition to closing the lightbox).
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') closeAllStrips();
        // Enter or Space on a focused .anchor toggles the strip (same as click).
        if (e.key === 'Enter' || e.key === ' ') {
            const a = document.activeElement?.closest?.('.anchor');
            if (a) {
                e.preventDefault();
                const willOpen = !a.classList.contains('is-open');
                closeAllStrips();
                if (willOpen) a.classList.add('is-open');
            }
        }
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
