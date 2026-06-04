<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK261\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK261\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:45.8487999+00:00
-->
# Summary

## Overview
A fast-paced, demo-heavy walkthrough of Windows developer tooling, split into "building on Windows" (developer setup, WSL, PowerToys, terminal) and "building for Windows" (Win UI apps, container APIs, compilation performance). The session emphasizes that nearly all of the tooling shown is open source and freshly published, and demonstrates repeatable workflows for environment setup, agentic terminals, Linux containers, and profile-guided performance optimization.

## Key announcements
- **WSL Containers** — A new container capability built into WSL with a `wsl` CLI binary (`wslc`, aliased as `container`) for running and building Linux containers directly from the Windows terminal, announced that morning ([00:06:05]).
- **Windows developer config repo** — A public, idempotent winget configuration file ("Windows developer config") that installs Ubuntu, WSL, Git, GitHub CLI, Copilot CLI, and VS Code in one step ([00:01:33]).
- **Intelligent Terminal** — An experimental, open-source agentic companion pane that assists in the terminal without taking over the whole window, supporting GitHub Copilot, Claude [inferred], Codex, and Open Code ([00:03:10]).
- **New Run dialog and movable taskbar** — A streamlined Run dialog rebuilt on the PowerToys Command Palette architecture, plus a movable (vertical) taskbar, both in the Insider program ([00:02:33], [00:03:00]).
- **Core Utils** — A release bringing roughly 75–165 Linux core utilities (grep, env.exe, tail.exe, etc.) natively to Windows ([00:07:16]).
- **Win App CLI** — A single open-source CLI for managing Windows SDKs, packaging, app identity manifests, certificates, and build tools ([00:14:13]).
- **WinDev / Win UI Dev skills plugin** — An agent plugin bundling skills, MCP servers, and a custom agent for building Win UI 3 and Windows App SDK apps with up-to-date context ([00:15:20]).
- **WSL Containers NuGet package / API** — An API letting developers embed Linux containers inside Windows apps via .NET build/run, with cold start benchmarked around 2.5 seconds ([00:33:09]).
- **Sample-based Profile Guided Optimization (SPGO)** — A lightweight optimization using hardware counters instead of code instrumentation, shown delivering a ~33% demo improvement and up to 20% for Adobe Photoshop [inferred] ([00:20:56]).

## Topics covered
- Idempotent developer environment provisioning via winget configuration files
- Taskbar personalization and the Command Palette-based Run dialog
- Agentic assistance inside the terminal workflow
- Building, running, and port-forwarding Linux containers with WSL Containers
- Comfort Shell: a preconfigured Ubuntu setup with Homebrew, ZSH, Starship, and btop
- Building Win UI 3 apps with Copilot CLI, autopilot mode, and automated UI testing
- Embedding Linux container code inside Win UI apps through a containers API and NuGet package
- Per-app WSL VM isolation, volume mounting, and GPU access for containers
- End-to-end SPGO compilation workflow (build, profile with Xperf, convert SPT to SPD, rebuild)
- Iterative re-profiling as code and usage patterns evolve
- Open-source community contributions across Terminal, WSL, Win UI, and PowerToys

## Notable quotes
> "If I didn't tell you that this was running Linux in the back end, you would not know." — Craig Loewen

> "This is not just a demo, it's reshaping how you think about optimization." — performance speaker [inferred: Jinya]

> "We've had over 16,000 open source contributors on all of our projects, which is huge." — Kayla Cinnamon

## Products and tools mentioned
- Windows Subsystem for Linux (WSL)
- WSL Containers (`wslc` / `container`)
- PowerToys (Command Palette, PowerToys Run, Grab and Move)
- Windows Terminal
- Windows Package Manager (winget)
- Core Utils
- Comfort Shell
- Win App CLI
- WinDev / Win UI Dev skills plugin
- GitHub Copilot CLI
- Win UI 3 / Windows App SDK
- WSL Containers NuGet package
- Profile Guided Optimization (PGO) and Sample-based PGO (SPGO)
- Xperf
- Edit (command-line editor)
- Lazy WSLC (TUI)
- Dev Containers / VS Code
- Docker Desktop, Podman Desktop, Rancher Desktop
- MoonRay rendering engine
- Adobe Photoshop [inferred]
- Ubuntu, Debian, Homebrew, ZSH, Starship, btop

## Speakers featured
- Kayla Cinnamon — Windows utilities product team
- Craig Loewen — Product manager, Windows Subsystem for Linux and AI tools on Windows
- Clint Rutkas — Windows utilities team
- Jinya [inferred] — Windows performance (presented the SPGO segment)

## Follow-up resources
- Windows developer config GitHub repo (config file, Comfort Shell)
- Core Utils GitHub repo
- Intelligent Terminal GitHub repo
- Win App CLI and Win App skills GitHub repos
- PowerToys GitHub repo
- SPGO documentation/tutorial link (shown on the closing links slide)
