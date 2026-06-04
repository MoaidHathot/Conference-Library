<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD815\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD815\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:42:47.3552326+00:00
-->
# Summary

## Overview
OneLake, the foundational data lake for Microsoft Fabric, is positioned as the "OneDrive for data," unifying data across clouds, on-premises systems, and third-party platforms into a single logical lake without ETL or duplication. The session walks through four pillars—a unified data estate, open access, AI readiness, and unified security and governance—with new announcements spanning storage, mirroring, Table APIs, and Foundry integration.

## Key announcements
- **Azure Databricks native storage in OneLake (preview)** [00:09:01] — Azure Databricks can now natively store its data in OneLake, joining Microsoft Fabric and Snowflake's Iceberg tables.
- **Customer-managed key encryption at rest (GA)** [00:09:30] — Data encryption with customer-managed keys is generally available, alongside immutable diagnostic logs and stronger network security (workspace private links, outbound access protection, workspace firewall, resource instance rules).
- **OneLake File Explorer and OneLake MCP (GA)** [00:12:53] — Both are now generally available.
- **Item size reporting (preview) and lifecycle management with data tiering** [00:13:01] — New storage reporting plus the ability to move infrequently-used data into cool or cold tiers to lower storage costs.
- **New shortcut and mirroring sources** [00:15:01] — DreamView [inferred], Azure Monitor in public preview, with AWS support coming soon; recently added SharePoint and OneDrive shortcut/mirroring.
- **Mirroring support for Workspace Private Link (preview)** [00:15:40] — Routes mirrored database traffic through Microsoft's private network for Azure Cosmos DB, Azure SQL Managed Instance, and SQL Server 2025.
- **Shortcut transformation enhancements (GA)** [00:16:13] — Native AI enrichment with new schema preview/definition and detailed monitoring logs.
- **SharePoint list mirroring and Excel shortcuts in OneLake** [00:18:37] — Mirror SharePoint lists and turn Excel sheets into first-class lakehouse tables without pipelines.
- **OneLake Table API metadata write support** [00:24:16] — Beyond reading metadata (already GA), users can now write metadata, create tables and schemas, and publish transactions via the Table API.
- **OneLake catalog natively integrated into Foundry** [00:27:04] — Trusted enterprise data, including sensitivity labels and endorsements, is discoverable and usable directly in Foundry knowledge and agents.
- **OneLake security GA, plus preview for Eventhouse** [00:30:08][00:33:47] — Engine-agnostic security definitions (row-level, column-level) enforced across all engines.

## Topics covered
- Unifying data via shortcuts (zero-copy) and mirroring (change data capture)
- Native versus catalog-federation integration (Iceberg REST catalogs)
- Physical storage in OneLake versus connecting an existing data estate
- Storage tiering, lifecycle management, and cost reporting
- Open formats (Delta Lake and Iceberg) and the "one copy" principle
- Unifying structured and unstructured data for AI grounding
- Microsoft IQ and Fabric IQ for distributing data context, semantic models, and ontologies
- OneLake security: role-level and column-level security enforced at the lake layer

## Notable quotes
> "OneLake really came in like a wrecking ball and busted open these silos, freed the data, and unified it all into a single, logical lake." — Josh Caplan

> "With OneLake, there's always one lake per organization. You can never have more than one. You can never have less than one." — Josh Caplan

> "Secure your data once and have it be enforced everywhere." — Josh Caplan

## Products and tools mentioned
- Microsoft OneLake
- Microsoft Fabric
- Microsoft AI Foundry
- OneLake File Explorer
- OneLake MCP
- OneLake catalog
- OneLake Table API
- OneLake security
- Microsoft IQ / Fabric IQ
- Power BI
- Excel / Microsoft Office
- SharePoint / OneDrive
- Microsoft Teams
- Microsoft Copilot / Copilot Studio
- Azure Data Lake Storage (ADLS)
- Azure Blob Storage
- Azure Monitor
- Azure Cosmos DB
- Azure SQL Managed Instance
- SQL Server 2025
- Azure Databricks
- Snowflake
- Oracle Database
- SAP Datasphere
- Salesforce
- ServiceNow
- ClickHouse
- DuckDB
- Informatica
- Fivetran
- Amazon S3 / NetApp Files
- Google Cloud Platform (GCP)
- Delta Lake / Apache Iceberg
- Apache Spark

## Speakers featured
- Dipti Borkar — OneLake and Fabric teams
- Josh Caplan
- Wee Hyong Tok
- Miquella de Boer

## Follow-up resources
- Fabric Security White Paper
- Fabric Featured Customer list
- OneLake catalog session by Kim Manis
