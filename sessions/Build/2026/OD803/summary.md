<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD803\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD803\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:42:51.6781490+00:00
-->
# Summary

## Overview
Gerald Versluis surveys the state of .NET MAUI in .NET 10, previews .NET 11, and demonstrates how the team has rebuilt its engineering workflow around Copilot and agentic tooling. The session pairs framework improvements (XAML source generation, SafeAreas, CoreCLR) with a push toward on-device AI through new libraries and developer tools.

## Key announcements
- **Copilot-authored merged PRs rose from 7% to 62% in under a year** — The team embedded AI end-to-end across reproduction, testing, fixing, MAUI-aware code review, and documentation, with data published per-PR (~07:54).
- **XAML source generation** — Opt-in feature compiling XAML to readable, debuggable C# with cited gains of ~1,000% faster inflation, 99% less debug memory, and reduced app memory; default in .NET 11 (~18:25).
- **Global XAML namespaces and implicit namespaces** — Reduce or eliminate XMLNS declarations, with editor/language-service support now available (~16:53).
- **Unified SafeArea edges API** — A new property (none, soft input, etc.) settable per page or layout to handle notches, dynamic island, and Android camera cutouts on iOS and Android (~21:44).
- **Android Material 3** — Opt-in via `UseMaterial3`, rolling out through .NET 10 service releases with fuller coverage in .NET 11 (~23:41).
- **CoreCLR becomes the default runtime in .NET 11** — Replaces Mono on iOS, Android, and Mac Catalyst, unifying with the broader .NET runtime and enabling tools like dotnet-trace and dotnet-counters (~27:06).
- **`dotnet run` and `dotnet watch` support** — Interactive target-framework/device prompts and terminal hot reload, designed to be agent-friendly CLI tooling (~29:07).
- **Map control enhancements for .NET MAUI 11** — Pin clustering, custom image-source pins, map interactions, and Android JSON styling (~31:10).
- **MAUI Labs initiative** — A vehicle for faster experimental releases including DevFlow, Essentials.AI, AI extensions, and new Linux/macOS AppKit/WPF backends (~34:31).
- **Microsoft.Maui.Essentials.AI** — Builds on Microsoft.Extensions.AI to add on-device providers Apple Intelligence, Gemini Nano, and Windows Copilot Runtime via Phi Silica [inferred] (~39:53).

## Topics covered
- Cross-platform app building with .NET MAUI, Blazor Hybrid, and the HybridWebView for JavaScript frameworks
- Agentic software development lifecycle: reproduction, targeted UI test selection, MAUI-aware review, and auto-drafted docs/blog PRs
- Partner collaborations: Syncfusion toolkit, Uno on SkiaSharp, Avalonia embedding MAUI for Linux and browser
- .NET 10 focus areas: stability/quality, performance, simplicity, modern platform APIs
- Service releases (SR6 with 242 commits, SR7), collection view/carousel fixes, modern media picker
- DevFlow agent injecting a debug-time HTTP server for visual-tree inspection, screenshots, and automated UI interaction, wrapped in an MCP server
- Intent-based app navigation using LLMs and `[AITool]`-style method attributes
- .NET MAUI release/support schedule (18-month support, 12-month major cadence)

## Notable quotes
> "We have gone from 7% to 62% Copilot-authored merged PRs in under a year, right? It's crazy."

> "MAUI has always been 50% AI, right? The letters are right there. So you know, we were ahead of the game."

> "This has everything you need with MAUI, by MAUI, through MAUI, MAUI everywhere."

## Products and tools mentioned
- .NET MAUI
- .NET 10 / .NET 11
- Blazor Hybrid / HybridWebView
- GitHub Copilot
- Microsoft.Extensions.AI
- Microsoft.Maui.Essentials.AI
- Apple Intelligence
- Gemini Nano
- Windows Copilot Runtime / Phi Silica [inferred]
- ONNX
- Azure OpenAI / Azure AI Foundry [inferred]
- CoreCLR / Mono
- XAML source generation, x:Code [inferred]
- dotnet run / dotnet watch / dotnet-trace / dotnet-counters
- DevFlow
- MAUI Sherpa
- MCP server
- Visual Studio / VS Code (.NET MAUI extension)
- Syncfusion .NET MAUI Toolkit (v1.0.10)
- SkiaSharp (Uno)
- Avalonia
- Apple Maps / Google Maps
- macOS AppKit, Linux (GTK4 [inferred]), WPF backends

## Speakers featured
- Gerald Versluis — Microsoft, .NET MAUI team

## Follow-up resources
- aka.ms/MAUIDevFlow
- MAUIverse.net (community Discord)
- The .NET MAUI customer stories website (Moti Me [inferred] pediatric physiotherapy case study)
- Agentic engineering metrics site referenced as "agenticengineers.net" [inferred]
- .NET MAUI community standup, first Thursday monthly, on the .NET YouTube channel
