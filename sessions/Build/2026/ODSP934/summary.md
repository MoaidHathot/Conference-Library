<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP934\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP934\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:45:25.3283235+00:00
-->
# Summary

## Overview
A foundational walkthrough of how Anthropic's Claude models are now deployed within Microsoft Foundry to build enterprise-grade agentic applications. Microsoft and Anthropic experts cover the agent lifecycle, the Claude model family, the Claude Agent SDK, and Foundry's governance, hosting, and evaluation capabilities, anchored by two live demos.

## Key announcements
- **Claude model family available in Microsoft Foundry** [00:11:11] — Claude Opus, Claude Sonnet, and Claude Haiku are deployable in Foundry with shared safety, prompting strategies, API patterns, and identical environment across the three models.
- **Claude Agent SDK as a supported harness** [00:25:13] — The same agent loop, tools, and context management behind Claude Code is programmable in Python and TypeScript and can run inside Foundry.
- **Foundry hosted agents** [00:23:28] — Custom-code agents (built with the Claude Agent SDK, GitHub Copilot SDK, LangChain, or LangGraph) can be moved from a local machine into an automatically secured cloud sandbox in Foundry Agent Service.
- **Claude availability through GitHub Copilot** [00:10:14] — Claude is reachable through GitHub Copilot and Azure AI Foundry, working with existing M365 identity and data without changing developer environments.
- **Built-in evaluation and observability** [00:30:00] — Foundry records agent sessions, traces, tool calls, and offers evaluators (groundedness, coherence, relevance, task adherence, code vulnerability) plus custom evaluators, accessible via UI and programmatically.

## Topics covered
- The agentic application model: long-running, goal-driven loops that gather context, act, verify, and repeat.
- The agent AI lifecycle: build, deploy, operate, evaluate, mitigate, and optimize under secure governance.
- Model selection guidance: prototype on Sonnet, escalate to Opus for hard reasoning and long-horizon tasks, drop to Haiku for high-volume, well-defined work like classification, extraction, and routing.
- Anthropic's constitutional AI approach and safety trained into the model rather than added afterward.
- MCP (Model Context Protocol) for connecting agents to internal and external systems, including public and authenticated private MCP servers.
- Foundry governance via Microsoft Entra, Microsoft Purview, and Microsoft Defender.
- The Claude Agent SDK's built-in infrastructure: context management, sessions/memory, permissions, lifecycle hooks, sub-agents, and observability.
- Evaluation pillars: quality, risk and safety, and agent-specific metrics, with emphasis on setting up evals early.
- Two demos: the "Sparkles" cupcake-ordering agent (Sonnet 4.6 via VS Code and an MCP server) and a customer support/live-site triage agent running a weekly ops workflow.

## Notable quotes
> "Safety is part of how Claude is actually built. The models are trained with it... It's not just a layer that's added at the end." — Caroline Matthews

> "Most teams are really surprised by how far Sonnet alone takes them. So treat them as your baseline and reach for something else when the task truly needs it." — Caroline Matthews

> "Reasoning quality is doing real production work, not demo work." — Caroline Matthews

## Products and tools mentioned
- Microsoft Foundry
- Foundry Agent Service
- Foundry IQ
- Claude Opus
- Claude Sonnet (Claude Sonnet 4.6)
- Claude Haiku
- Claude Code
- Claude Agent SDK
- Agent Framework Foundry SDK
- Model Context Protocol (MCP)
- VS Code
- GitHub Copilot / GitHub Copilot CLI / GitHub Copilot SDK
- Microsoft Entra
- Microsoft Purview
- Microsoft Defender
- Microsoft 365 / Microsoft 365 Graph
- Agent 365
- Azure AI Foundry
- LangChain
- LangGraph
- Constitutional AI

## Speakers featured
- Keiji Kanazawa — Principal Product Manager, Microsoft Foundry
- Caroline Matthews — Applied AI Architect, Anthropic
