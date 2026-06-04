<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK251\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK251\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:37.4938257+00:00
-->
# Summary

## Overview
Agent 365 is positioned as a control plane that brings observability, identity, threat protection, data security, and governance to every agent in an organization—Microsoft-built, third-party, and custom agents alike. The session pairs conceptual framing of the "observe, govern, secure" pillars with a live demo onboarding a LangChain travel agent via the Agent 365 SDK, an admin walkthrough of the Microsoft 365 Admin Center, and a partner integration story from Genspark.

## Key announcements
- **Agent 365 control plane** *(00:02:27)* — A platform for discovering, governing, and securing agents across all platforms, built on Entra (identity), Defender (threat detection), Purview (data governance), and Intune (shadow AI detection).
- **Agent 365 SDK** *(00:06:10)* — A wrapper SDK (not an agent-building or hosting SDK) that makes external agents discoverable, assigns an agent ID, and enables observability, security policies, and the Tools gateway.
- **Registry Sync** *(00:10:28)* — Ingests agents from connected third-party platforms such as Amazon Bedrock and Google Vertex AI into the registry for visibility, carrying over existing permissions like deletion.
- **Agent 365 skills for coding agents** *(00:15:05)* — Roughly six (and growing) skills invokable from VS Code, GitHub Copilot, or Claude Code that instrument an agent for Agent 365 in about ten minutes.
- **Templates** *(00:33:46)* — A "hero" feature aggregating custom policies across Entra, Defender, Purview, and SharePoint into reusable templates applied during agent approval.
- **Rules** *(00:32:58)* — Automation for lifecycle actions such as reassigning ownerless agents to a manager or auto-blocking agents when risk is identified.

## Topics covered
- Projected scale of agents (IDC: 1.3 billion agents in organizations by 2028) and agent types (SaaS, endpoint, cloud).
- Agent identity concepts: agent blueprints (reusable recipes), upleveling service principals to user-level identities, and on-behalf-of vs. autonomous agent user identities.
- Onboarding a LangChain/Node.js/TypeScript agent and configuring observability via OpenTelemetry.
- Work IQ / MCP servers enabling agents to act on productivity surfaces (Word, OneDrive) and respond to Teams messages and @-mentions in document comments.
- Admin Center observability: adoption trends, runtime hours, exceptions, agents without owners, risk drill-down into Purview/Entra, and blast-radius analysis for blocking agents.
- Multi-agent and cross-platform dependency visualization.
- Genspark's integration architecture using federated identity, per-message authentication, MCP-based document generation, and Purview logging/sensitivity-label enforcement.

## Notable quotes
> "You cannot govern what you cannot see." — Kendra Springer

> "Agents are unique, they are essentially apps. They're built like apps, but the caveat here is they function like users." — Kendra Springer

> "With Agent 365 we did not need to build another authentication layer. We just use all of the capability provided by Microsoft." — Ray Zhong

## Products and tools mentioned
- Microsoft Agent 365
- Agent 365 SDK (including Python SDK)
- Agent 365 CLI
- Microsoft Entra
- Microsoft Defender
- Microsoft Purview
- Microsoft Intune
- Microsoft 365 Admin Center
- Microsoft Teams, Outlook, Word, OneDrive, PowerPoint
- Copilot Studio
- Microsoft Foundry [inferred]
- LangChain
- Node.js / TypeScript
- VS Code, GitHub Copilot, Claude Code [inferred]
- Amazon Bedrock, Google Vertex AI, AWS, GCP, Google Gemini [inferred]
- Workday
- Genspark
- OpenTelemetry
- Model Context Protocol (MCP)

## Speakers featured
- Neta Haiby — opened and closed the session (introduced as "Neda")
- Kendra Springer — presented the Agent 365 value pillars, SDK, and admin demo
- Aarthi [inferred] — delivered the end-to-end developer onboarding demo
- Ray Zhong — Co-Founder of Genspark, presented the partner integration
