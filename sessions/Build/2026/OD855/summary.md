<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD855\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD855\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:13.1261797+00:00
-->
# Summary

## Overview
Windows 365 is positioned as a cloud-based development platform that delivers pre-configured, ready-to-code Cloud PCs accessible from any device, reducing environment setup friction while preserving enterprise security and centralized IT control. The session also extends this model to AI agents through Windows 365 for Agents, which provisions full Windows environments so agents can operate graphical and legacy applications, all governed through familiar Microsoft management tooling.

## Key announcements
- **Windows 11 developer configuration image in public preview** (00:05:34) — A developer-optimized marketplace image that arrives pre-loaded with Visual Studio, Git, GitHub CLI, Python, Node.js, GitHub Copilot, and WSL with Ubuntu already configured.
- **Windows 365 for Agents is generally available** (00:13:28) — Gives AI agents their own Cloud PCs with full Windows environments so they can see, interact with apps, and operate as a person would.
- **New 32-core SKU with up to 128 GB RAM** (00:08:00) — Expands the diversity of Cloud PC compute options for memory-intensive local AI workloads.
- **MCP tool layer for agents** (00:15:24) — A set of Model Context Protocol tools lets any MCP-speaking agent framework provision, connect to, interact with, and manage the lifecycle of a Cloud PC, managed through the Agent 365 portal.

## Topics covered
- Developer time lost to maintenance, configuration, and cross-platform context switching.
- Accessing a persistent Cloud PC from any device (including macOS) via the Windows App.
- Workload-specific Cloud PCs, including GPU-enabled configurations for heavier compute.
- Project-level customization with SDKs, CLIs, build tools, and automatic repository cloning within enterprise guardrails.
- Running local language models on Cloud PCs to avoid per-token costs, demonstrated with Foundry Local, a Qwen model, and a Local AI Studio using ComfyUI and Stable Diffusion 1.5.
- Remote, device-independent steering of GitHub Copilot CLI sessions that continue running on an always-available Cloud PC.
- The GUI gap, legacy gap, and scale gap that block agent adoption in enterprises.
- IT administration in Intune: provisioning policies, workforce models, networking, marketplace and Azure Compute Gallery images, scope tags, and context-based redirection with conditional access.

## Notable quotes
> "Just as Office 365 brought productivity to the cloud, Windows 365 brings Windows to the cloud." — Roop Kiran Chevuri

> "You need to give your agent a computer. That's what Windows 365 for Agents does." — Phil Gerity

> "Tokens are the digital currency of AI, but developers find themselves hitting budget constraints on how much they can spend running the frontier models online." — Roop Kiran Chevuri

## Products and tools mentioned
- Windows 365
- Windows 365 for Agents
- Azure Virtual Desktop
- Windows App
- Visual Studio
- Git, GitHub CLI, GitHub Copilot, GitHub Copilot CLI
- Python, Node.js
- WSL with Ubuntu
- WinGet, Docker, Postman
- Microsoft Foundry / Foundry Local
- Qwen [inferred]
- ComfyUI
- Stable Diffusion 1.5
- Agent 365 (portal, CLI, toolkit)
- Model Context Protocol (MCP)
- Microsoft Intune
- Microsoft Entra ID
- Azure Compute Gallery
- Windows 365 Enterprise, Windows 365 Flex Dedicated, Windows 365 Flex Shared

## Speakers featured
- Roop Kiran Chevuri — Principal Group Product Manager, Windows 365 and Azure Virtual Desktop
- Phil Gerity — Partner Group Product Manager, Windows 365 and Azure Virtual Desktop

## Follow-up resources
- On-demand deep dive by Joydeep Mukherjee and Sam Shapiro covering the full developer cycle.
- Session OD852 on Windows 365 for Agents.
- Sessions BRK260 and BRK261 on the developer experience on Windows.
