<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM362-R1\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM362-R1\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:12.4856882+00:00
-->
# Summary

## Overview
A live, demo-driven walkthrough of how Microsoft Fabric's data agents combine with the "three IQs" (Work IQ, Fabric IQ, and Foundry IQ) to build multi-agent workflows spanning retrieval, summarization, and execution. Alexander Wachtel role-plays three personas—a Foundry builder, a Fabric data owner, and a compliance/governance owner—to show how agents collaborate across knowledge bases while remaining observable and governable rather than "black boxes."

## Key announcements
- **Fabric IQ ontologies on top of semantic models** — Introduced around Ignite, ontologies add nodes, properties, and named relationships so agents understand data context beyond raw one-to-many SQL table relations [00:12:19].
- **Work IQ exposed as MCP servers** — Specialized Work IQ endpoints (mail, Teams, calendar, Word, Copilot) wake up based on the user's natural-language query, callable from Copilot, Foundry, and Copilot Studio [00:06:11].
- **Foundry IQ as a permission-aware knowledge layer** — A single identity/knowledge layer where queries are checked against permissions, labels, and policies before returning data [00:02:28].
- **Fabric data agent publishing to Foundry and Microsoft 365 Copilot** — Agents publish via workspace ID and data agent (artifact) ID, then connect as a tool in Foundry or appear directly in M365 Copilot [00:14:47].
- **Data Agent SDK with evaluation** — The SDK enables configuration and evaluation runs (inline questions or CSV datasets against expected answers) that the portal alone cannot provide [00:19:37].
- **Agent 365 governance view** — A consolidated console showing all agents (here, 202) regardless of origin, with Purview activity explorer surfacing queries, sensitive-data access, and AI instructions over time [00:23:55].

## Topics covered
- The three IQs (Work IQ, Fabric IQ, Foundry IQ) and how each supplies different knowledge and permission scopes.
- Ontologies vs. semantic models, and why graph relationships matter for agent reasoning.
- Medallion data flow (bronze/silver/gold) for AI readiness, citing a Swiss Airlines migration from on-premise SQL Server to Fabric [inferred].
- Human-in-the-loop tool approval when external (Foundry) agents access mailbox data.
- Multi-agent orchestration using Fabric pipelines and notebooks (no native agent orchestration yet; Microsoft Agent Framework as an alternative).
- Compliance and governance: blocking non-compliant queries (e.g., invoices) and auditing sensitive-data interactions.

## Notable quotes
> "The problem was on this agents, this agent were like a black box. So I cannot see what's happening right now." — Alexander Wachtel

> "For the agent, it's the best case to go somehow to answer the data... I have one table, I have another table with the data and that I have a relation 1 to north. That's nothing for the agent."

> "If Hana was creating on fabric, Raphael will see as a governance that we are then not talking about black boxes anymore."

## Products and tools mentioned
- Microsoft Fabric
- Work IQ, Fabric IQ, Foundry IQ
- Microsoft Foundry (formerly Azure OpenAI Studio [inferred])
- Microsoft Copilot Studio
- Microsoft 365 Copilot
- Fabric data agents / Data Agent SDK
- Microsoft Agent Framework
- Agent 365
- Microsoft Purview (activity explorer)
- Model Context Protocol (MCP) servers
- Fabric Lakehouse, semantic models, pipelines, notebooks
- SharePoint Online, Azure Blob Storage
- matplotlib

## Speakers featured
- Alexander Wachtel — Microsoft MVP and trainer, based in Germany.

(The demo also references illustrative personas "Hana" working in Fabric and "Rafael" handling Copilot compliance and Agent 365; these are role-play roles, not session presenters.)

## Follow-up resources
- A GitHub repository for session 362 (DEM362), described as available as a reusable template after the conference; no URL was provided in the session.
