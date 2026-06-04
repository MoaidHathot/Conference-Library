<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK243\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK243\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:14.1039098+00:00
-->
# Summary

## Overview
A deep-dive into deploying advanced, long-running "claw"-style agents and agent harnesses on Microsoft Foundry. The session defines what an agent harness is, demonstrates running the Hermes harness on Foundry hosted agents, building custom harnesses with Microsoft Agent Framework, and publishing agents into Teams and Microsoft 365 Copilot.

## Key announcements
- **Agent harness support in Microsoft Agent Framework** — Any agent can have a harness attached via `AsAgentHarness`, gaining built-in tools (file system, code/shell execution), context compaction, planning, and middleware for free (~00:25:00–00:27:00).
- **Routines (preview) in Foundry** — A trigger feature letting agents react to external stimuli or schedule recurring work, including agents creating their own routines to spin a shut-down sandbox back up for self-maintenance (~00:13:44).
- **Autopilot agents** — A new third agent type that acts on its own behalf and has a real user account (email alias, ability to send Teams messages and create Word documents), demoed briefly in the prior day's keynote (~00:39:46).
- **One-click publish to Teams and M365 Copilot** — From the Foundry portal, deployed agents can be scoped to the creator or submitted to the Microsoft Admin Center for organization-wide approval, yielding both Teams and Copilot UIs out of the box (~00:35:35).
- **Hermes on Foundry hosted agents** — A claw-like harness demonstrated running with a stateless, auto-shutdown back end (15-minute idle timeout) that uses Foundry models and Entra/Azure default credentials (~00:09:57).
- **AGUI plus Copilot Kit integration** — Enabling an AGUI endpoint with a few lines of code gives agents a web UI, including built-in chart controls, without extra code (~00:31:31).

## Topics covered
- Foundry's layered architecture: intelligence (models), runtime, and human-agent collaboration, wrapped in trust, observability, and evaluations.
- Definition and core components of an agent harness: the agent loop, context management and compaction, skills and tools, giving an agent a computer (file system, code execution), orchestration, memory/session persistence, lifecycle hooks, and human-in-the-loop.
- The "claw"-like pattern popularized by OpenClaw: agents that own their environment, run long, communicate over messaging platforms, and self-improve.
- State management trade-offs: per-session unique file systems, snapshots, BLOB-storage backups, and Foundry's ~30-day sandbox retention after inactivity.
- Microsoft Agent Framework's three parts: agent loop, workflows (sequential, handoff, author-critic, Magentic), and harnesses; cross-ecosystem connectors (OpenAI, Anthropic, Gemini, Bedrock, Ollama, A2A).
- Assistive, autonomous, and Autopilot agent identity models; group-chat behaviors and access control for a work stream manager agent.

## Notable quotes
> "If you think of your agent as the motor, as the engine, then the harness is the car." — Shawn Henry

> "They are the most pet-like thing we perhaps have invented since the beginning of cloud computing." — Glenn Condron, on claw-style agents

> "The agent state creates these unique environments... that uniqueness causes pain when it comes to recovering and resuming from errors." — Glenn Condron

## Products and tools mentioned
- Microsoft Foundry / Foundry hosted agents
- Microsoft Agent Framework
- Hermes
- OpenClaw
- GitHub Copilot (CLI and SDK)
- Claude Code / Claude Agent SDK
- Cursor
- Copilot Studio
- Microsoft 365 Copilot
- Microsoft Teams
- Microsoft Admin Center
- Work IQ (MCP/SharePoint connector)
- AGUI
- Copilot Kit
- Foundry Toolkit Agent Inspector
- Azure Functions, Azure Container Apps
- Scout in Foundry
- MCP, OpenAPI, A2A protocol

## Speakers featured
- Shawn Henry — Microsoft Foundry team
- Glenn Condron — Microsoft Foundry team; contributing PRs to the Hermes repo
- Amanda Foster — Microsoft Foundry team

## Follow-up resources
- Session code and resources on GitHub (link referenced on closing slides).
- Agent League Hackathon (QR code on closing slide), running until the 14th.
