<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP394\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP394\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:33:04.4882307+00:00
-->
# Summary

## Overview
Uno Platform and enterprise customer Kahua demonstrate an AI-assisted, cross-platform .NET development workflow that spans web, desktop, and mobile from a single shared codebase. The session centers on the launch of Uno Platform Studio 3.0, positioning AI agents and traditional engineering fundamentals as complementary across a spectrum of development styles, with live tooling that lets AI inspect and interact with running app UI.

## Key announcements
- **Uno Platform Studio 3.0** [00:05:14] — The evolution of Uno's AI and design tooling into an agentic workflow with skills, plugins, MCP tools, previews, and snippets.
- **Specialized Uno Platform agent backed by 60+ skills** [00:14:10] — A purpose-built agent, grounded by skills and MCP tools, that knows how to build Uno Platform apps and validate UI in a loop; skills cover areas like navigation and Material toolkit theming.
- **Uno Platform Studio browser app** [00:06:01] — A zero-install app running on desktop, web, and mobile that spins up a full cross-platform .NET app from a prompt, with visual editing and export to an IDE, GitHub, or local environment.
- **Previews shipping in 3.0** [00:17:54] — Build and validate UI components in isolation across responsive breakpoints, data context states, and themes.
- **Skills and plugins for external agents** [00:18:12] — Usable from GitHub Copilot, Codex, and Claude Code, so any agent can be grounded in Uno best practices.

## Topics covered
- The spectrum of development approaches, from code-centric to visual to fully agentic orchestration.
- Cross-platform .NET from a single codebase targeting iOS, Android, web (WebAssembly), Windows, macOS, and Linux.
- Hot Design (runtime visual designer) and Hot Reload syncing changes back to source code.
- MCP tools giving AI "eyes and hands" to inspect the visual tree, take screenshots, and click UI elements — analogous to Playwright for .NET apps.
- AI-driven UI and integration testing automation.
- The human-and-AI verification loop: plan, generate, verify, iterate.
- Enterprise use cases at Kahua including LiDAR 3D mesh modeling, building/safety inspections, and 360 photo capture for construction projects.
- Preserved artifacts: output remains standard XAML and C#, with GitHub pull request review retained.

## Notable quotes
> "We've gone from writing code by hand. Six months ago we actually were still all traditional development. We now zero code written by humans. It's all AI driven. We're orchestrators." — Colin Whitlatch

> "So AI has eyes and hands. So we can have the agents look at your app, interact with it, click on things, type in text." — Sam Basu

> "The fundamentals matter, you know, more than it ever has... AI increases our speed. But the context about how you build and verify what you're building absolutely matters." — Sam Basu

## Products and tools mentioned
- Uno Platform
- Uno Platform Studio 3.0
- Hot Design
- Hot Reload
- Visual Studio Code
- Visual Studio
- GitHub Copilot
- GitHub
- Claude Code
- Codex
- Figma
- .NET 10
- SkiaSharp [inferred]
- GPT-5 mini [inferred]
- WebAssembly
- MVUX
- MVVM

## Speakers featured
- Sam Basu — Developer Advocate, Uno Platform
- Colin Whitlatch — CTO, Kahua

## Follow-up resources
- platform.uno — Uno Platform website where the browser-based app builder is accessible.
