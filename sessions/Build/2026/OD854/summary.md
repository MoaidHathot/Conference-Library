<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD854\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD854\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:06.4797581+00:00
-->
# Summary

## Overview
WinUI is being recommitted to as the production Windows UI platform, with investments in performance, quality, open-sourcing, and feature-gap closure rather than a replacement framework. The session pairs this stability message with the announcement of Microsoft UI Reactor, an experimental open-source project exploring C#-first, reactive UI patterns suited to AI-assisted coding workflows.

## Key announcements
- **WinUI drops its version number, signaling long-term commitment** (00:02:37) — WinUI 3 will now be referred to simply as "WinUI" to convey there is no intention of building yet another new framework or a massive breaking change.
- **Performance and quality investments shipped to the public Git repo** (00:00:59) — Improved memory usage and a switch to a system compositor are available to try today, with WinApp SDK experimental preview branches incorporating the changes shortly.
- **New DataGrid and Charting controls coming to core WinUI** (00:01:15) — These data-oriented controls are due relatively soon and will ship in the core WinUI bits.
- **Open-source Phase 4 underway** (00:01:51) — The team is moving to work primarily and almost exclusively in public repos, landing pull requests publicly so the community can see and contribute to the work; Phase 3 (running tests in public) is already complete.
- **C# elevated to a first-class way to target WinUI** (00:05:54) — The goal is to lift C# from XAML code-behind to a means of writing entire applications with full access to controls and templates currently locked behind XAML.
- **Microsoft UI Reactor experimental framework released** (00:06:25) — A new open-source, high-churn project for experimenting with new programming styles, controls, and app models, with proven ideas later pushed down into production WinUI.

## Topics covered
- Performance fundamentals: memory usage and system compositor migration
- WinUI's open-source maturation phases and public-repo development
- Migration and interop strategy for WinForms and WPF
- Impact of AI-assisted and CLI-based coding tools on development style
- Industry trend toward dynamic UI (SwiftUI, Jetpack Compose, React) and code-first development
- Reactor's C# projection / domain-specific language for WinUI controls
- Reactive state management: UseState, UseReducer, and render diffing/reconciliation
- Component construction via method extraction and full component classes with lifecycle
- DevTools features such as highlighting reconciler changes
- Asynchronous resources with loading, error, and success states
- Live demo of hot reload via .NET watch, including instability caveats

## Notable quotes
> "We're dropping the number, and we're referring to WinUI as just WinUI because we have no intention of really making a massive shift, breaking change on it." — Chris Anderson

> "I rarely type semicolons anymore. I'm almost always using AI to drive most of the code that I'm writing." — Chris Anderson

> "This is a place where we are likely to change every line of code in this project. We are very early. We want to do the development out in the open." — Chris Anderson

## Products and tools mentioned
- WinUI
- WinApp SDK
- Microsoft UI Reactor
- WinForms
- WPF
- WinRT
- C#
- C++
- XAML
- .NET watch
- Visual Studio Code
- Claude Code
- GitHub Copilot
- SwiftUI
- Jetpack Compose [inferred]
- React
- DataGrid
- Charting / PieChart control

## Speakers featured
- Chris Anderson — Engineer, Windows UI team (working on experimental frameworks features)
