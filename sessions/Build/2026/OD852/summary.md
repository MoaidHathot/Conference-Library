<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD852\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD852\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:06.7982472+00:00
-->
# Summary

## Overview
Windows 365 for Agents provides AI agents with their own Cloud PCs—full, secure Windows environments—so they can operate GUI applications, legacy software, and authenticated sessions that lie beyond API and MCP boundaries. The session announces general availability, demonstrates a real customer agent from Simular, and walks through building, configuring, governing, and scaling agent Cloud PCs across the Microsoft stack.

## Key announcements
- **Windows 365 for Agents is generally available** (00:01:18) — the platform giving first- and third-party AI agents their own managed Cloud PCs is now GA.
- **MCP tool layer for Cloud PCs** (00:03:08) — a set of Model Context Protocol tools lets any MCP-speaking agent framework provision, connect to, interact with, and manage the lifecycle of a Cloud PC.
- **Agent 365 integration** (00:03:51) — the MCP tools, observability, and governance for Windows 365-enabled agents surface inside the Agent 365 portal alongside all other enterprise agents.
- **Intune provisioning policies for agents** (00:13:10) — a dedicated experience under Devices > Windows 365 Cloud PCs lets admins create agent-specific pools with billing plans, always-available Cloud PCs, and gallery or custom images.

## Topics covered
- The GUI gap, legacy gap, and scale gap that block agents from doing real enterprise work.
- Core architecture: agent Cloud PCs, the MCP tool layer, and enterprise control via Intune and Entra agentic identity.
- Simular's "Sai" agent running an overnight insurance claims workflow in a Contoso app with no APIs, including catching and fixing a duplicate-digit zip code error.
- On-demand scaling: spinning Cloud PCs up for large workloads and down to minimize cost.
- Building a sample computer-use agent on Azure OpenAI with the screenshot-reason-act loop.
- Wiring MCP servers into an agent's tooling manifest via the Agent 365 CLI (`list available`, `add MCP server`), including adding mail/Outlook tools.
- Local testing in the Agent 365 playground with live tool-call logs.
- Admin blueprint configuration in the Microsoft Admin Center and tenant-wide permissioning.
- Employee self-service: creating agent instances in Teams, registering them in Entra, and assigning provisioning policies.
- A live web-research task: opening Edge to recommend a Windows 365 offering for a 500-person organization across North America and LATAM.
- Windows 365 (the developer offering): ready-to-code Cloud PCs preconfigured with GitHub and developer tools, accessible cross-platform via the Windows App.

## Notable quotes
> "You need to give your agent a computer. That's what Windows 365 for Agents does." — Joydeep Mukherjee

> "Sai sees the screen, moves the mouse, and types on the keyboard, just like a human. It also uses APIs, operates the terminal, and writes code." — Jiachen Yang

> "Wiring it up is genuinely a configuration change, not a code rewrite." — Sam Shapiro

## Products and tools mentioned
- Windows 365 for Agents
- Windows 365
- Agent 365
- Agent 365 CLI
- Agent 365 playground
- Model Context Protocol (MCP)
- Microsoft Intune
- Microsoft Entra ID
- Microsoft Admin Center
- Azure OpenAI
- GPT-5.4 [inferred]
- Simular / Sai
- Microsoft Teams
- Microsoft Outlook
- Windows App
- GitHub Copilot
- Visual Studio Code
- WinGet
- Docker
- Postman
- Windows 32 (Win32)

## Speakers featured
- Joydeep Mukherjee — Principal PM for Windows 365 for Agents, Microsoft
- Sam Shapiro — Senior Product Manager, Microsoft
- Jiachen Yang — Co-founder and CTO, Simular

## Follow-up resources
- Windows 365 for Agents documentation (referenced, no URL given).
- Session OD855, "Windows 365 for Developers," hosted by Roop Kiran Chevuri and Phil Gerity [inferred].
