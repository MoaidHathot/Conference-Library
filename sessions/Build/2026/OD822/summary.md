<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD822\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD822\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:17.7174133+00:00
-->
# Summary

## Overview
A product-focused walkthrough of why teams are consolidating database workloads onto PostgreSQL and why Azure Database for PostgreSQL Flexible Server is positioned as the migration target. The session covers recent performance, scale, and operational features, the one-step Postgres-to-Postgres migration service, and a new AI-assisted Oracle-to-Postgres migration toolset built into the VS Code Postgres extension.

## Key announcements
- **Premium SSD v2 generally available** — Recently made GA, it enables up to 80K IOPS and 1.2 GiB/s throughput with incremental, pay-for-what-you-need storage growth ([00:06:44]).
- **UltraDisk high-performance storage coming soon** — A higher-IOPS storage option that, paired with v6 compute, reaches up to 400K IOPS ([00:07:45]).
- **Intel and AMD v6 compute SKUs generally available** — Offer up to triple the memory and double the vCores of v5, based on 5th Gen Intel Xeon and 4th Gen AMD EPYC 9004 ([00:07:58]).
- **Cascading read replicas generally available** — A primary can replicate through layered replicas, up to 30 from one primary, including cross-region for disaster recovery ([00:08:49]).
- **Postgres 18 and major version upgrade support added** — Includes an extended pre-upgrade validation check to simulate upgrades and fix issues beforehand ([00:10:23]).
- **AI-assisted Oracle-to-Postgres migration tool** — Available now in the VS Code Postgres extension, it converts Oracle schema, database code, and application code ([00:17:41]).
- **Azure Migrate Postgres discovery** — Added Postgres server discovery to assist the assessment phase ([00:10:53]).
- **Maintenance controls** — Defer maintenance updates up to two weeks or apply on demand ([00:11:08]).
- **Grafana dashboards and Defender security assessments** — New Postgres monitoring dashboards in the Azure portal and security posture auditing ([00:11:59]).
- **EDB and Huawei added as migration sources** ([00:14:03]).

## Topics covered
- Industry trend toward consolidating workloads on open-source PostgreSQL
- Total cost of ownership: managed service versus self-hosting on VM or Kubernetes
- Microsoft's upstream Postgres committer contributions (query execution, async I/O, observability in Postgres 18)
- Scale-up (storage and compute) versus scale-out (read replicas, elastic cluster sharding via Citus)
- Microsoft Fabric mirroring of Postgres data
- One-step Postgres-to-Postgres migration service (online and offline)
- Oracle-to-Postgres migration phases: discovery, schema, database code, application, data
- Agentic, multi-agent schema conversion with self-correction against a scratch Postgres database
- Application code conversion using GitHub Copilot Agent Mode, a Claude model, and language model tools (LMTs)

## Notable quotes
> "We take opensource Postgres, just as is, no changes, and run it as a managed service with all of the enterprise features needed to run critical workloads." — Guy Bowerman

> "This endpoint is used in combination with Agent Mode to scale migration to thousands of objects, something Copilot Agent Mode cannot do out of the box." — Jonathon Frost

> "This test conversion only processed 34 objects. We have had customers successfully test this on a scale of over 2,000 objects." — Jonathon Frost

## Products and tools mentioned
- Azure Database for PostgreSQL Flexible Server
- VS Code PostgreSQL extension
- Azure AI extension / Microsoft Foundry integration
- Premium SSD v2 / UltraDisk storage
- Elastic cluster (Citus extension)
- Cascading read replicas
- Azure Migrate
- Microsoft Fabric
- Grafana dashboards (Azure portal)
- Microsoft Defender
- Azure CLI
- PG dump / restore
- pgbench
- GitHub Copilot Agent Mode
- Azure OpenAI
- Claude model [inferred]
- Java App Mod extension
- HorizonDB (preview)
- Oracle Database 19c

## Speakers featured
- Guy Bowerman — Product Manager, Azure Database for PostgreSQL Flexible Server
- Jonathon Frost — Program Manager, Azure Postgres team (recorded demos)

## Follow-up resources
- aka.ms/postgresonazurebuild2026 — links to related Build 2026 sessions
- Microsoft Blog for Postgres (tech community blog with monthly feature recaps)
- Azure Postgres migration documentation and migration tools docs (referenced at session close)
