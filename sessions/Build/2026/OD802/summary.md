<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD802\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD802\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:42:45.7106883+00:00
-->
# Summary

## Overview
Daniel Roth walks through the .NET 11 roadmap for ASP.NET Core and Blazor, organized around six themes spanning foundational improvements, the modern web stack, Aspire integration, agentic capabilities, and AI-assisted development. The session demonstrates shipped preview features and previews in-progress work to make ASP.NET Core and Blazor the best platform for building agentic web apps.

## Key announcements
- **Foundational upgrades require no code changes (00:02:55)** — Performance gains (reduced TLS handshake overhead in Kestrel, Zstandard compression, runtime async), security hardening (fetch metadata-based CSRF, auth token refresh for long-lived connections), and native OpenTelemetry semantic convention tags arrive simply by upgrading.
- **Blazor static server-side rendering parity with MVC (00:09:05)** — New EnvironmentBoundary, Label, and DisplayName components, TempData support, virtualization with variable item heights, and JavaScript-based client validation that works without interactivity (no jQuery dependency, with localization).
- **Async validation for minimal APIs and Blazor (00:05:25)** — Validation logic can perform long-running operations like database or external service checks without blocking, with new ValidateAsync APIs on EditContext.
- **WebAssembly runtime consolidation from Mono to CoreCLR (00:06:30)** — Previewing in .NET 11, stable in .NET 12, so Wasm 3.0 features like multi-threading and 64-bit memory land on a single runtime.
- **Blazor Web Worker project template (00:06:55)** — Move CPU-intensive work off the UI thread via message passing using the existing runtime.
- **New Blazor gateway service for Aspire (00:22:20)** — A production-grade replacement for the Blazor dev server that serves standalone WebAssembly apps with MapStaticAssets, proxies API calls, flows service discovery config, and collects OpenTelemetry.
- **AGUI protocol support in Microsoft Agent Framework (00:28:50)** — MapAGUI endpoints, an AGUIChatClient implementing IChatClient, frontend tools, human-in-the-loop flows, and prototype Blazor AI components.
- **.NET Skills repo and marketplace (00:36:44)** — Curated ASP.NET Core and Blazor coding-agent skills, custom agents, CLI/MCP tools, and eval test suites, demonstrated with a "plan UI change" skill that produces better-factored components.
- **OpenAPI 3.2 support (00:05:37)** — Structured tags, binary file responses, and better representation of streaming responses and auth flows.
- **C# unions across the ASP.NET Core stack (00:07:05)** — Richer API contracts, more expressive component parameters, and better type safety.

## Topics covered
- TLS, compression, malformed request handling, and runtime async performance work
- Kestrel security hardening, fetch-metadata CSRF, and SignalR/Blazor Server auth token refresh
- Native OpenTelemetry tracing and Blazor WebAssembly browser telemetry
- Modern stack focus (minimal APIs, SignalR, Blazor) versus maintenance of MVC/Razor Pages
- Blazor SSR components, TempData, QuickGrid OnRowClick, and variable-height virtualization
- Localized data-annotation validation and asynchronous uniqueness checks
- Blazor Web Workers and the Mono-to-CoreCLR WebAssembly transition
- Aspire orchestration, service discovery, and the Blazor gateway hosting model
- Agentic protocols: OpenAI responses, agent-to-agent (A2A), and AGUI
- MCP C# SDK for exposing and consuming tools and resources
- AI-assisted development via skills, custom agent personas, tools, and eval suites

## Notable quotes
> "The end result is that when you upgrade to .NET 11, your apps run faster, safer, and are more observable. No code changes required." — Daniel Roth

> "We want ASP.NET Core and Blazor to be the best way to build agentic web apps." — Daniel Roth

> "If we can't measure it, we don't really know if it works. The eval suite helps keep us honest." — Daniel Roth [inferred]

## Products and tools mentioned
- .NET 11
- ASP.NET Core
- Blazor (Server, WebAssembly, Web Workers)
- Kestrel
- SignalR
- Minimal APIs
- .NET Aspire
- Blazor gateway
- Microsoft Agent Framework
- Microsoft.Extensions.AI
- Microsoft Foundry
- MCP C# SDK
- AGUI (Agent User Interaction protocol)
- CopilotKit
- GitHub Copilot
- OpenAPI 3.2
- OpenTelemetry
- Zstandard compression
- C# LSP
- .NET Inspect
- Playwright
- .NET MAUI
- QuickGrid
- Visual Studio

## Speakers featured
- Daniel Roth — Principal Product Manager for ASP.NET Core and Blazor, .NET team

## Follow-up resources
- ASP.NET Core .NET 11 roadmap: aka.ms/aspnet/roadmap
- .NET 11 previews: get.dot.net/11
- .NET AI: dot.net/ai
- Aspire: aspire.dev
- .NET Skills repo: dotnet/skills (dotnet/skills)
- AGUI specification: agui.com
