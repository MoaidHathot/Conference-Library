<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD811\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD811\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:42:47.0088751+00:00
-->
# Summary

## Overview
Amir Netz, CTO of Microsoft Fabric, frames the platform's evolution around equipping AI agents with the same knowledge and context given to human employees. The session walks through a four-step journey—unifying data, harmonizing it, curating semantics, and empowering agents—centered on the new Fabric IQ workload and a series of GA and preview announcements.

## Key announcements
- **SharePoint and OneDrive shortcuts GA in OneLake** [00:07:23] — These join recently announced SAP and Oracle support, extending zero-ETL data access.
- **New OneLake source previews** [00:07:29] — Public preview for Dremio and Azure Database for MySQL, with Azure Monitor and AWS Glue coming soon to bring observability data alongside business data.
- **GPU query acceleration for Fabric Data Warehouse (limited preview)** [00:08:10] — Demonstrated up to 8x faster single queries and over 100x at 64 concurrent queries, enabled via a one-click workspace setting.
- **Agent skills for Fabric expanded** [00:13:01] — Beyond analytical engines, agents can now generate Power BI reports and provision full medallion architectures from a prompt.
- **Custom live pools** [00:15:07] — Reduces Spark pool startup from 3–5 minutes to 3–5 seconds via pre-warming.
- **Fabric ontology integrations** [00:19:30] — New connections across Foundry, Copilot Studio, and Agent 365 [inferred], still in preview ahead of GA later this year.
- **Planning in Fabric now GA** [00:22:00] — An end-to-end enterprise planning workload for budgets, forecasts, and scenarios, rolling out to remaining regions over the coming weeks.
- **Apps in Fabric (preview)** [00:27:06] — Production-grade line-of-business apps on governed data, built on the Rayfin SDK [inferred], a type-safe, decorator-based optimizer for agentic development.
- **Agent-driven BI apps** [00:30:43] — Custom web dashboards built against semantic models using the same Rayfin SDK.
- **Operations agents now GA** [00:33:01] — Autonomous virtual team members that monitor signals and act in the background, with new chat-based authoring, root cause analysis, and Microsoft Teams integration.

## Topics covered
- Fabric adoption metrics: 35,000 customers, over 90% of the Fortune 500, $2B+ ARR with 60% YoY growth.
- Microsoft IQ structure: Work IQ (how people work), Foundry IQ (institutional knowledge), Fabric IQ (real-time business state).
- The four-step Fabric IQ journey: unify, process/harmonize, curate semantics, empower agents.
- OneLake as a single pane of glass across multiple clouds, databases, and on-premises sources.
- TPC-H benchmark results comparing CPU vs. GPU-accelerated Data Warehouse performance.
- AI functions for sentiment and classification in notebooks and warehouses (PySpark/T-SQL).
- Semantic models versus ontologies for business and operational intelligence.
- Modeling entities, properties, and actions (e.g., retail shipments, rerouting, inspection).
- Planning's write-back to Fabric SQL and integration into ontologies for forward-looking context.

## Notable quotes
> "When we say, joining the workforce, means that they're really going to move from being just chat bots or applications on your desktop to real full-fledged employees." — Amir Netz

> "For the AI when the data is shorted it's like looking at the world through a broken mirror, it's just hard to understand what's going on." — Amir Netz

> "They're virtual team members that monitor signals and react autonomously in the background. They don't wait for you to ask them questions." — Amir Netz

## Products and tools mentioned
- Microsoft Fabric
- Fabric IQ, Work IQ, Foundry IQ, Microsoft IQ
- OneLake
- Fabric Data Warehouse
- Power BI
- Apache Spark 4.0, Delta 4.0
- Fabric SQL database
- Activator
- Rayfin SDK [inferred]
- GitHub Copilot / Copilot Studio
- Azure Foundry [inferred]
- Agent 365 [inferred]
- Planning in Fabric
- Operations agents
- SAP, Oracle, Dremio, Azure Database for MySQL, Azure Monitor, AWS Glue
- SharePoint, OneDrive
- Microsoft Teams

## Speakers featured
- Amir Netz — Technical Fellow at Microsoft and CTO of Microsoft Fabric
- Eren Orbey — listed speaker (not separately identified in transcript)
