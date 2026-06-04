<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK224\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK224\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:35.1782367+00:00
-->
# Summary

## Overview
A Microsoft–PepsiCo session demonstrating how PepsiCo modernized its data foundation to build a production multi-agent system for key account managers (KAMs). Bob Ward frames the data-readiness prerequisites for AI, then PepsiCo and Microsoft engineers walk through the "CAM 360" agentic system that turns a KAM's Monday-morning meeting prep from hours of fragmented work into minutes.

## Key announcements
- **Horizon DB public preview** — Announced the day before the session (00:06:48), a scalable, Postgres-compatible database built for the cloud within Azure.
- **Cosmos DB semantic re-ranking** — Among several Cosmos DB announcements that week, highlighted as popular with the community (00:06:28).
- **Azure SQL Database / Hyperscale GitHub Copilot integration** — Deeper integration with GitHub Copilot in Visual Studio Code to improve the Azure SQL developer experience (00:06:36).
- **CAM 360 agentic system** — PepsiCo's six-agent system (orchestrator, data analyst, tactic, tracking, best-practices, and debrief agents) that prepares KAMs for customer meetings (00:17:49).

## Topics covered
- Data sprawl and vendor sprawl as barriers to successful AI projects, versus a unified lakehouse "finish line."
- Making data "AI ready": real-time, unified, meaningful, contextual, and trusted.
- The Enterprise Data Foundation (EDF) as a metadata-first layer enabling agents, and the shift from "data for dashboards" to "data for agents."
- Architecture of the data analyst ("nerd") agent: authentication with JWT-to-OIDC token federation, Genie text-to-SQL, and an enrichment/persistence layer with session memory.
- Use of LangGraph/LangSmith for orchestration tracing and Databricks Genie configuration (tables, definitions, Unity Catalog access control, high- vs. low-confidence query paths, golden datasets).
- The tracking agent's learning loop: configurable signals, an enterprise knowledge layer, a fact-builder agent producing confidence-scored facts stored in Cosmos DB, and a fact ledger.
- Foundry IQ for agentic RAG/retrieval, with configurable retrieval instructions, planning models, and reasoning effort.
- Compounding intelligence: debriefs and prior meetings becoming institutional memory for future KAMs.
- Lessons learned: keep scope small, the risk of confident hallucination, the need for domain experts, and the payoff of a strong data foundation.

## Notable quotes
> "Just like we cannot build a skyscraper on sand, it's very difficult to build agents if your data is inconsistent, if your data is not governed properly, or if your data is just not meaningful enough." — Rishab Saha

> "The agents are very good with confidently hallucinating, especially if part of your answer is wrong and part of your answer is right." — Rishab Saha

> "It's not really to replace people... It's really to give time back to people so they can really focus on what's the most important for them." — Rishab Saha

## Products and tools mentioned
- Azure SQL Database / Hyperscale
- Azure Database for PostgreSQL
- Azure Cosmos DB
- Azure Databricks (Genie, Unity Catalog)
- Microsoft Fabric
- Horizon DB
- Azure MySQL
- Azure AI Foundry / Foundry IQ / Foundry Local
- Copilot Studio
- GitHub Copilot
- Visual Studio / Visual Studio Code
- Azure Kubernetes Service / Azure Container services / static web apps
- LangGraph / LangSmith
- OpenTelemetry (OTLP)
- Responses API

## Speakers featured
- Bob Ward — Principal Architect, Azure Data team, Microsoft
- Rishab Saha [inferred: Rishabh Saha] — Chief Architect, Microsoft Office of the CTO
- Krunal Patel — Senior Manager, PepsiCo AI Solutions and Platforms team

## Follow-up resources
- Azure free resources (trial/getting started)
- Azure Accelerate program
- Cloud Accelerate Factory
- Session survey and presentation slides made available post-Build
