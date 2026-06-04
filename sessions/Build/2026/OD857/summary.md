<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD857\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD857\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:12.8929621+00:00
-->
# Summary

## Overview
Connected Experience APIs let Windows app developers integrate their apps into native Windows surfaces—taskbar, widgets, and system search—to drive discovery, engagement, and new installs across devices. The session details two capabilities in depth: Windows Resume for cross-device activity continuity, and the People API for surfacing app contacts as first-class citizens in Windows.

## Key announcements
- **People API scale milestone [00:00:40]** — A single People API surface drives over 10 million monthly sessions through ShareSheet people suggestions alone.
- **Resume taskbar performance [00:00:55]** — Three months after release, nearly one in four users who see a Resume taskbar nudge interact with it, making it a top taskbar performer.
- **Combined reach [00:01:12]** — Share, People, and Resume together reach over 50 million devices monthly and have driven over a billion sessions back to partner apps in the past year.
- **Continuity SDK availability [00:05:03]** — The Continuity SDK is now published to Maven and GitHub for Android integration.
- **Resume install funnel [00:03:04]** — When a user lacks the app on their PC, the Resume badge still appears and a single click drives a store install, with Windows handling awareness through engagement.

## Topics covered
- Windows Resume for media, chat, and document continuity across devices
- Two Resume integration paths: Continuity SDK (Android, with install flow) versus Windows Notification Service (WNS, broad platform reach, app must be pre-installed)
- Continuity SDK implementation steps: Gradle dependency, manifest declaration, SDK initialization, AppContext creation, and platform callbacks
- Resiliency patterns—stopping publishing while disconnected and retrying on reconnection
- WNS integration via channel URI registration and push notifications from an app's cloud backend
- People API integration: creating a user data account, storing system-scoped contacts, and enriching contacts
- Contact enrichment through communication URI annotations (message, audio call, video call) and PII-free interaction signals for ranking
- Privacy model: system-surface-only scoping, no app-to-app sharing, removal on uninstall, and user visibility toggles
- Resume as a limited access feature requiring access requests through Microsoft

## Notable quotes
> "Connected Experiences is how your app not just be an app on Windows, but actually become a part of Windows." — Sai Tejaswy Mylavarapu

> "User's phone activity just drove a PC app to install. Neither they browsed nor they looked at the store to download the app. Windows handled the entire funnel." — Sai Tejaswy Mylavarapu

> "You as an app feed the signals and Windows handles the math." — Sai Tejaswy Mylavarapu

## Products and tools mentioned
- Windows Connected Experiences APIs (Share, People, Resume)
- Windows Resume
- Continuity SDK
- Windows Notification Service (WNS)
- Cross-device People API
- Windows People widget
- Windows system search
- Spotify
- WhatsApp
- Google Pixel 8 [inferred]
- Maven
- GitHub
- Android and iOS

## Speakers featured
- Sai Tejaswy Mylavarapu — Product Manager, Windows Connected Experiences
- Avinash Nowduru — Engineer, Windows Connected Experiences

## Follow-up resources
- learn.microsoft.com documentation links referenced for People, Resume, Continuity SDK, and WNS integration (specific URLs shown on-screen but not stated in the transcript)
