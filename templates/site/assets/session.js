/* session.js - per-session-page features that run on every layout:
 *   1. Lightbox: any <a data-zoom="1"> intercepts the click and shows the
 *      target image in a modal overlay. Escape / click-outside closes.
 *   2. Announcement-frame strips: click the [HH:MM:SS] timestamp to toggle a
 *      sticky strip of context frames (replacing the older hover-only
 *      behaviour which had a hover-gap bug + didn't work on touch devices).
 *      The strip stays open until you click outside it or press Escape.
 *   3. Click-to-seek: every [HH:MM:SS] is followed by a .ts-play button
 *      (rendered by Build-Book.ps1's Inject-AnnouncementFrames). Clicking it
 *      scrolls the session video into view, seeks it to (ts - 5s), and calls
 *      .play(). Works uniformly for both the MP4 <video> and the HLS
 *      <video data-hls-src="..."> path (see #4 below). When the page has no
 *      <video.session-video> element (iframe-only sessions, in-person labs),
 *      the click opens the canonical session URL in a new tab with a #t=
 *      fragment so the destination player can self-seek if it supports the
 *      W3C Media Fragments URI spec.
 *   4. HLS playback: any <video data-hls-src="...m3u8"> auto-attaches hls.js
 *      on browsers without native HLS support (Chrome / Edge / Firefox); on
 *      Safari we just set src directly because Safari has native HLS.
 *   5. Live status badge: any .status-line[data-start][data-end] gets its
 *      .status-badge populated based on the current wall-clock time
 *      ("Upcoming - starts in 2h 15m" / "Live - started 30m ago" / "Ended
 *      3h ago"). Refreshes every 30 s so the badge stays fresh on an open
 *      tab during the conference.
 *
 * No build step. Plain ES module-friendly syntax, runs as a classic script.
 * hls.js, when present, is loaded as a global from assets/hls.min.js.
 */

(function () {
    'use strict';

    // ---------- Constants ----------
    // Offset applied when seeking the video from a [HH:MM:SS] click. The
    // user almost always wants to see the *context* leading up to the
    // announcement, not the announcement-completed moment, so we land
    // a few seconds earlier. 5s is the sweet spot empirically: enough
    // run-up to catch the lead-in sentence without making the user
    // wait through long preamble.
    const SEEK_OFFSET_SECONDS = 5;

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

    // ---------- HLS playback ----------
    // Attach hls.js to every <video data-hls-src="..."> on the page. Runs
    // once at DOMContentLoaded; the page only ever has one video, but the
    // selector handles multiples just fine. Safari (which has native HLS
    // support via Apple's MSE-on-the-side) gets src set directly; everywhere
    // else hls.js takes over the buffering.
    function attachHls() {
        const videos = document.querySelectorAll('video[data-hls-src]');
        videos.forEach(video => {
            const src = video.getAttribute('data-hls-src');
            if (!src) return;
            // Native HLS support (Safari, iOS, some smart-TV browsers).
            if (video.canPlayType('application/vnd.apple.mpegurl')) {
                video.src = src;
                return;
            }
            // hls.js path. Library is loaded as a global from assets/hls.min.js.
            if (typeof window.Hls === 'undefined' || !window.Hls.isSupported()) {
                // Last-resort fallback: try setting the src anyway. Some browsers
                // may load it via a polyfill; otherwise the user gets a clear
                // playback error rather than a silent black box.
                video.src = src;
                return;
            }
            const hls = new window.Hls({
                // Conservative defaults: small buffer keeps the seek-and-play
                // response snappy, autoStartLoad=false lets us defer the actual
                // playlist fetch until the user hits play.
                maxBufferLength: 30,
                maxMaxBufferLength: 60,
                autoStartLoad: true,
                startPosition: -1
            });
            hls.loadSource(src);
            hls.attachMedia(video);
            // Stash on the element so the seek logic can drive hls.js directly
            // when seeking past the currently-buffered region.
            video._hls = hls;
            // Surface fatal errors in a debuggable way without spamming the user.
            hls.on(window.Hls.Events.ERROR, (_event, data) => {
                if (!data.fatal) return;
                console.warn('hls.js fatal error:', data.type, data.details);
            });
        });
    }
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', attachHls);
    } else {
        attachHls();
    }

    // ---------- Click-to-seek ----------
    // Parse "HH:MM:SS" / "MM:SS" into seconds. Returns NaN for unparseable
    // input so the caller can skip the seek gracefully.
    function parseTimestamp(ts) {
        if (!ts) return NaN;
        const parts = ts.split(':').map(p => Number.parseInt(p, 10));
        if (parts.some(n => Number.isNaN(n))) return NaN;
        if (parts.length === 3) return parts[0] * 3600 + parts[1] * 60 + parts[2];
        if (parts.length === 2) return parts[0] * 60 + parts[1];
        if (parts.length === 1) return parts[0];
        return NaN;
    }

    // Seek the page's <video class="session-video"> to (ts - offset),
    // scroll it into view, and start playback. Returns true when the seek
    // landed on a video, false when the page has no video (iframe-only or
    // no-recording sessions) so the caller can fall back to opening the
    // canonical session URL in a new tab.
    function seekVideoTo(seconds) {
        const video = document.querySelector('video.session-video');
        if (!video) return false;
        const target = Math.max(0, seconds - SEEK_OFFSET_SECONDS);
        // Bring the player into view BEFORE seeking so the seek-induced
        // initial render lands in the visible viewport. Smooth scroll
        // because instant scrolls on long pages feel teleporty.
        const playerSection = video.closest('section.player') || video;
        playerSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
        // The seek itself. Use a tiny delay so the scroll animation has a
        // chance to register before the seek causes a frame redraw at the
        // target time; without this users perceive a "double jump" on
        // long pages.
        setTimeout(() => {
            try {
                video.currentTime = target;
            } catch (_) {
                // currentTime can throw on a not-yet-loaded HLS source; hls.js
                // will pick it up on its first metadata frame. As a safety net,
                // re-attempt the seek once metadata is available.
                video.addEventListener('loadedmetadata', () => {
                    try { video.currentTime = target; } catch (_) { /* give up */ }
                }, { once: true });
            }
            // Some browsers (mobile Safari, Firefox-with-strict-autoplay) gate
            // .play() behind a user gesture; the originating click IS that
            // gesture, so this call should succeed. We swallow the rejection
            // to keep the console clean when it doesn't.
            const playPromise = video.play();
            if (playPromise && typeof playPromise.catch === 'function') {
                playPromise.catch(() => { /* autoplay blocked; user can click play manually */ });
            }
        }, 80);
        return true;
    }

    // Fallback for sessions with an opaque iframe player (no .session-video):
    // open the canonical session URL in a new tab with a Media-Fragments
    // hash so a player honouring the spec self-seeks to the right moment.
    // Microsoft Medius / mediastream wrappers may or may not honour this;
    // either way the user lands on a working player.
    function openCanonicalSessionAt(seconds) {
        const target = Math.max(0, seconds - SEEK_OFFSET_SECONDS);
        const iframe = document.querySelector('section.player iframe');
        if (!iframe) return;
        const src = iframe.getAttribute('src');
        if (!src) return;
        // Reuse the URL's existing query string; append #t=NN to the fragment.
        const sep = src.includes('#') ? '&' : '#';
        const seekUrl = `${src}${sep}t=${Math.floor(target)}`;
        window.open(seekUrl, '_blank', 'noopener');
    }

    // ---------- Announcement-frame strip toggle ----------
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

        // 2) Play button (.ts-play) next to a timestamp -> seek the video.
        //    Checked BEFORE the strip-toggle handler so clicking the button
        //    doesn't ALSO toggle the strip (the button sits OUTSIDE .anchor,
        //    so it wouldn't, but defence in depth).
        const playBtn = e.target.closest('.ts-play');
        if (playBtn) {
            e.preventDefault();
            e.stopPropagation();
            const ts = playBtn.getAttribute('data-ts');
            const seconds = parseTimestamp(ts);
            if (Number.isNaN(seconds)) return;
            const seeked = seekVideoTo(seconds);
            if (!seeked) {
                // No in-page video; fall back to opening the iframe URL in a
                // new tab with a #t= fragment.
                openCanonicalSessionAt(seconds);
            }
            return;
        }

        // 3) Anchor (timestamp) click toggles the strip open/closed.
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

        // 4) Click anywhere else closes any open strip.
        closeAllStrips();
    });

    // Escape closes any open strip too (in addition to closing the lightbox).
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') closeAllStrips();
        // Enter or Space on a focused .anchor toggles the strip (same as click).
        // The browser handles Enter/Space on a focused <button class="ts-play">
        // natively via the click event we delegate above, so no extra wiring
        // needed for the seek button.
        if (e.key === 'Enter' || e.key === ' ') {
            const a = document.activeElement?.closest?.('.anchor');
            if (a && !document.activeElement?.matches?.('.ts-play')) {
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
