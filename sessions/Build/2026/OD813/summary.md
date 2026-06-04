<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD813\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD813\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:42:49.8958134+00:00
-->
# Summary

## Overview
Microsoft Fabric Data Warehouse is introduced as a serverless, lakehouse-based analytics engine being retooled for AI-driven and agentic workloads. The session centers on a new GPU-accelerated query engine ("Query Acceleration") plus a broad slate of developer experience, T-SQL, SQL analytics endpoint, enterprise readiness, and billing enhancements that aim to deliver faster, more predictable performance without re-architecting existing stacks.

## Key announcements
- **GPU-accelerated data warehouse / Query Acceleration (limited preview)** [00:03:59] — A new engine executes queries or query portions directly on GPUs, requiring no query rewrites and applying to every SQL endpoint and warehouse in a workspace once enabled.
- **ALTER COLUMN in place** [00:10:57] — Data type changes no longer require rebuilding tables.
- **ALTER TABLE inside a transaction** [00:11:16] — Multiple schema changes can be grouped as a single unit with automatic rollback on failure.
- **New T-SQL functions** [00:11:59] — Fuzzy string matching (Levenshtein, Jaro-Winkler), new concatenation operations, UNISTR, DATE_BUCKET, and the ANY_VALUE aggregate.
- **Enhanced scalar UDFs** [00:12:25] — Procedural constructs including loops, multipath execution, and if/then/else branches.
- **Lakehouse table health checks** [00:12:50] — A diagnostic stored procedure (`sp_get_table_health_metrics` [inferred]) pinpoints root causes like fragmentation, small files, excessive deletes, or delayed checkpoints.
- **Configurable retention** [00:15:03] — Default 30-day retention is now adjustable from 1 to 120 days for time travel, point-in-time restore, and table clones.
- **Distributed bitmap filters (coming soon)** [00:15:21] — Compact filters from smaller tables are pushed down to large fact-table scans to eliminate non-matching rows early.
- **Inline Copilot in the SQL editor** [00:17:46] — AI assistance embedded directly in the query flow for joins, optimization, and natural-language-to-SQL.
- **Metadata sync (public preview)** [00:20:31] — Re-architected sync makes lakehouse data queryable in seconds rather than minutes.
- **Time travel on SQL analytics endpoint** [00:22:12] — Query data as it appeared at any prior point, governed by the lakehouse retention period.
- **CI/CD for SQL analytics endpoint plus pre/post-deployment scripts (coming soon)** [00:23:02] — Git-based version control via DacFX projects, Fabric pipeline integration, and scripted prep/cleanup steps.
- **Migration assistant GA** [00:25:04] — Live connectivity GA (no DACPAC extraction) and .SQL file input (public preview) supporting Azure Synapse, SQL Server, and any T-SQL source.
- **Custom SQL pools** [00:26:43] — Adjustable allocation of the default 50/50 split between select and non-select workloads.
- **Node-based billing model** [00:27:39] — Per-compute billing with a one-minute minimum then per-second granularity.
- **Cache cooldown** [00:28:43] — Configurable window to keep compute warm and avoid cold starts.

## Topics covered
- Fabric's serverless, decoupled compute/storage lakehouse architecture and SQL Server-derived query optimizer
- The shift from reporting to cloud analytics to AI/agentic workloads and its impact on data platforms
- GPU query execution mechanics through the SQL frontend and distribution engine
- Transactional and in-place schema evolution
- Lakehouse data health diagnostics and proactive maintenance
- Join optimization via distributed bitmap filters
- SQL editor productivity, cross-engine analytics, and Fabric ecosystem integration (Eventhouse, notebooks, Power BI Direct Lake, Fabric ontologies)
- Enterprise readiness: object explorer scaling, CI/CD, migration, workload management, and billing

## Notable quotes
> "We built a GPU-accelerated data warehouse in Fabric, specifically built for the modern AI workloads." — Maraki Ketema

> "ALTER COLUMN is pretty much table stakes. Up until now, making data type changes meant rebuilding tables. Now you can just alter columns in place, no rewrites, no disruption, no drama." — Joanna Podgoetsky

> "Your data, once it lands on the lakehouse, will be available in seconds, not minutes for query." — Rakesh Krishnan

## Products and tools mentioned
- Microsoft Fabric
- Fabric Data Warehouse
- SQL analytics endpoint
- Microsoft Fabric Lakehouse / OneLake
- Power BI (Direct Lake over OneLake)
- Eventhouse / KQL
- Spark notebooks
- Fabric ontologies
- Copilot
- SQL Server
- Azure Synapse
- DacFX / DACPAC
- Fabric pipelines
- Migration assistant

## Speakers featured
- Maraki Ketema — Product lead, Fabric Data Warehousing
- Joanna Podgoetsky — Product lead, Fabric Data Warehousing
- Rakesh Krishnan — Product lead, Fabric Data Warehousing

## Follow-up resources
- Customer references cited: Epic, UNC Health (reporting 5x query speed improvements), Benjamin Moore. No explicit URLs were provided in the transcript.
