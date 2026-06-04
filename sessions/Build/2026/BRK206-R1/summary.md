<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK206-R1\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK206-R1\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:36.4780499+00:00
-->
# Summary

## Overview
GitHub Copilot SDK reached general availability (1.0), packaging the same agent runtime harness used by Copilot CLI and GitHub's cloud agents so developers can embed agents into their own applications, servers, and devices. The session pairs a product overview of the GA release with a live coding demo of multi-agent orchestration, isolation/sandboxing models, and session portability, then previews remote cloud environments and a forthcoming Rust runtime rewrite.

## Key announcements
- **Copilot SDK is now GA (1.0)** — Technical-previewed in January and now generally available, built on the same runtime harness as Copilot CLI and the Copilot cloud agent products. **[00:00:35]**
- **Rust language support added at GA** — Joins TypeScript, Python, .NET, Go, and Java, broadening the SDK to a fuller range of platforms. **[00:02:58]**
- **M365 adoption underway** — Office Excel and Copilot Studio are rolling out on the SDK, with Cowork [inferred] beginning its cutover. **[00:03:57]**
- **OS-managed sandboxing (preview)** — A new cross-platform sandboxing capability for Windows, macOS, and Linux that lets the OS restrict file-system and network access even if an agent is prompt-injected. **[00:16:32]**
- **Per-session virtual file systems** — A `session FS` abstraction isolates each session cheaply (versus container/VM per session) and enables backup, migration, and resilience; this approach is being used to rewrite github.com chat. **[00:21:19]**
- **Remote cloud environments (preview)** — Agents can run in ephemeral cloud sessions, be detached from the originating app, and steered across devices (phone, browser) via Mission Control. **[00:31:37]**
- **Runtime rewrite to Rust (underway)** — Targets greater-than-10x gains in startup, memory footprint, and bundle size; a WASM build compiles to ~500KB and runs as a Chrome add-on inside a V8 sandbox. **[00:35:24]**

## Topics covered
- Shared agent harness unifying Copilot CLI, github.com, VS Code, and Visual Studio
- Deployment targets including local machines, containers, private VNets, multi-tenant services, air-gapped and government clouds
- Bring-your-own-key inference versus GitHub Copilot subscription setups
- Building multi-agent orchestration in C# with `CopilotClient`, sessions, and parallel agents
- Customizing the system prompt by replacing individual sections rather than the whole message
- Defining custom tools, empty tool sets, and selectively enabling built-in tools (e.g., web fetch)
- Isolation models: direct execution, container/VM per session, OS sandboxing, and virtual file systems
- Prompt-injection defense via OS-level controls rather than prompts alone
- Session portability, resilience, and storage synchronization to blob stores or other servers
- Open plugins standard, shared catalogs, citations, MCP, compliance, and cross-surface memory/personalization

## Notable quotes
> "It actually is the same exact runtime harness that sits in our Copilot Cloud Agent products. It's the same harness that sits in the Copilot CLI." — Patrick Nikoletich

> "You can't just rely on prompts alone because some hostile, malicious user might be very creative and they might find some way of phrasing their input that persuades the agent to do something bad." — Steve Sanderson

> "As you use one product, it'll start feeling like another product. One Copilot will feel like another Copilot." — Patrick Nikoletich

## Products and tools mentioned
- GitHub Copilot SDK
- GitHub Copilot CLI
- GitHub Copilot cloud agent
- github.com
- Copilot Studio
- Office Excel
- Microsoft 365 / Windows 365
- Visual Studio and VS Code
- Cross-platform sandboxing library (MXC) [inferred]
- jsbash virtual bash library [inferred]
- Node.js
- Rust / WebAssembly (WASM)
- V8 sandbox (Chrome add-on)
- Copilot SDK Server Sample

## Speakers featured
- Patrick Nikoletich — APM, Copilot CLI and SDK team
- Steve Sanderson — Engineering, coding agent runtime / CLI / SDK

## Follow-up resources
- Copilot SDK repository (referenced via an aka.ms link)
- Getting-started guide, best practices, and docs on the GitHub website and in the repo
