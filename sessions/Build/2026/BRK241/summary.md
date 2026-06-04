<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK241\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK241\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:11.6922724+00:00
-->
# Summary

## Overview
Tina Schuchman and Jeff Hollan demonstrate Microsoft Foundry's end-to-end lifecycle for production AI agents, framed around an autonomous fiber-outage response scenario from Azure's networking operations team. The session moves through three developer phases—build, deploy, and operate—showing local prototyping, secure hosted deployment, and a self-improving optimization loop, with the developer retained in control of every change.

## Key announcements
- **Microsoft Agent Framework 1.0 (production ready)** — Now includes a built-in harness integrated with skills, memory, and middleware, plus plug-in integrations for the GitHub Copilot SDK and Claude Agent SDK [inferred] (~00:18:10).
- **Foundry Toolkit for VS Code (generally available)** — A purpose-built developer experience for building Foundry agents without leaving the editor (~00:18:34).
- **Foundry Toolbox (generally available soon)** — A single managed, MCP-compatible endpoint for all agent tools with governance, guardrails, and a tool-search feature to optimize context usage (~00:18:49).
- **Voice Live integration with Foundry Agent Service** — GA for prompt agents and public preview for hosted agents (~00:19:10).
- **Hosted agents in Foundry Agent Service (generally available soon)** — Per-session sandbox isolation, sub-second cold start, zero idle-time cost, framework-agnostic, supporting long-running autonomous agents with durable state and file-system access (~00:19:26).
- **Routines (public preview)** — Event-driven triggers that turn reactive agents into proactive, long-running ones via queued, tracked runs (~00:27:17).
- **Publish to Microsoft 365 Teams and Copilot (GA soon); Autopilot agents (public preview)** — Agents inherit identity, policy, and permissions, and Autopilot agents gain their own IDs, email addresses, and Teams presence, governed in Agent 365 (~00:27:47).
- **Rubric for custom evaluation (public preview)** — Auto-generates context-aware, weighted scoring criteria for evaluation and optimization (~00:38:33).
- **Agent Optimizer for Foundry Agent Service (private preview)** — Turns production traces and evals into ranked candidate agents by tweaking skills, prompts, tool configuration, and models, compared across quality, cost, and latency (~00:38:52).
- **Procedural memory (public preview)** — Lets agents learn a playbook across sessions rather than relearning each conversation (~00:39:39).

## Topics covered
- Building agents locally in VS Code with the Foundry Toolkit and generating agents via GitHub Copilot
- Agent harnesses for secure shell/code execution and dynamic investigation
- Tool integration through Foundry Toolbox, including Foundry IQ, Fabric IQ, Work IQ, web search, and content understanding for converting PDFs to agent-readable formats
- Local F5 debugging with breakpoints and one-click voice enablement
- Long-running, isolated hosted sessions with durable persistent state and human-in-the-loop approval via the Durable Task Scheduler
- Trace replay observability (time and token views, playback)
- Auto-generated eval datasets and custom rubrics; the automated optimization loop producing ranked agent candidates with rollback/lineage

## Notable quotes
> "Building is no longer the hard part." — Tina Schuchman

> "Agents are teammates, not tools. We're no longer building chat bots." — Tina Schuchman

> "This is as live as it gets." — Jeff Hollan

## Products and tools mentioned
- Microsoft Foundry / Foundry Agent Service
- Microsoft Agent Framework
- Foundry Toolkit for VS Code
- Foundry Toolbox
- Foundry IQ, Fabric IQ, Work IQ
- GitHub Copilot, GitHub Copilot CLI, GitHub Copilot SDK
- Claude Code / Claude Agent SDK [inferred]
- Visual Studio Code, Visual Studio, Cursor
- Azure Developer CLI (azd)
- Durable Task Scheduler
- Document Intelligence and Content Understanding
- Microsoft 365 Copilot, Microsoft Teams, Microsoft Graph, Agent 365
- Voice Live
- GPT-5 / GPT-5.5 [inferred], Anthropic Opus 4.8 [inferred]
- Dynamics 365

## Speakers featured
- Tina Schuchman — Corporate Vice President, Microsoft Foundry
- Jeff Hollan — Partner Director, Foundry agent platform

## Follow-up resources
- Referenced upcoming Build sessions on content understanding, Claude-like agents, and observability (no specific links provided in the transcript).
