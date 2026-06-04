<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP929\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP929\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:45:08.2018461+00:00
-->
# Summary

## Overview
A demo-driven walkthrough of building cross-platform .NET applications with Uno Platform, emphasizing AI-assisted and visual tooling. Sam Basu shows how a single C# and XAML codebase targets mobile, web, and desktop, then demonstrates Uno Platform Studio's runtime visual designer and MCP-grounded AI agents that generate and validate UI.

## Key announcements
- **Uno Platform Studio AI and design tools** *(00:01:25)* — A collection of productivity tools layered on the Uno Platform foundation, including the Hot Design runtime visual designer and a custom AI agent.
- **Two built-in MCP servers** *(00:10:33)* — Uno MCP grounds AI agents in current documentation, while Uno App MCP gives agents "eyes and hands" to screenshot, click, and validate running app UI.
- **Teased Build theater session with partner Kahua** *(00:18:40)* — A live joint session promising a "very big announcement and a surprise," plus an Expo booth presence.

## Topics covered
- Single shared C#/XAML codebase targeting iOS, Android, WebAssembly, Windows, macOS, Linux, and embedded systems
- Choice of UI rendering stack, themes, extensions, and toolkits
- Project scaffolding via the Visual Studio Uno Platform extension wizard and the Uno Check dependency installer
- Hot Design runtime visual designer with live design canvas, toolbox, visual tree drilldown, and data binding against real runtime data
- Hot Reload keeping running app, design surface, and IDE code in sync
- AI-agent-driven UI generation across GitHub Copilot, Claude Code, Codex, Gemini, and Cursor, configured through mcp.json
- MCP-based UI validation (described as "Playwright for cross-platform .NET apps") — screenshots, clicks, key presses, visual tree snapshots
- Bringing design systems from Figma or Pencil [inferred], or starting from a screenshot
- Responsive layouts adapting from desktop to mobile form factors
- MVVM versus MVU/MVUX design patterns for Uno Platform apps

## Notable quotes
> "This is what we like saying gives the AI agents eyes and hands so that the agent is not guessing anymore."

> "Your AI agents are always grounded in factual docs, no hallucinations, and what we are trying to offer is more context so the AI agents can test app interactive features while your app is running."

> "If you give it the right specs, if you give it the right requirements document, and you can also test out the UI with the help of MCPs, the world is your oyster."

## Products and tools mentioned
- Uno Platform
- Uno Platform Studio
- Hot Design
- Hot Reload
- Uno Check
- Uno MCP
- Uno App MCP
- Uno Chefs (sample app)
- Visual Studio
- Visual Studio Code
- GitHub Copilot
- Claude Code
- Codex
- Gemini
- Cursor
- SkiaSharp
- WebAssembly
- Figma
- Pencil
- Playwright
- .NET
- C# and XAML
- MVVM / MVU / MVUX patterns

## Speakers featured
- Sam Basu — Developer Advocate, Uno Platform

## Follow-up resources
- platform.uno — Uno Platform website, documentation, setup guide, and AI gallery of showcase apps
