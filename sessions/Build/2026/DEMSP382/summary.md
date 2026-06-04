<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP382\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP382\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:45.2718611+00:00
-->
# Summary

## Overview
This advanced session demonstrates building a secure, multi-cloud AI workflow by combining Oracle AI Database@Azure, Microsoft Fabric, and GitHub Copilot through Oracle and Fabric MCP servers. Across two connected demos, the presenters show how natural-language prompts can provision databases, generate synthetic data, move it into Fabric, and build ETL pipelines, ML forecasts, and business-facing analytics without heavy custom integration.

## Key announcements
- **Oracle MCP servers now available** — [00:02:42] The Oracle MCP servers are accessible through the OCI portal and, as announced in a blog released the same day, also through the Microsoft AI Catalog.
- **Fabric MCP server for Copilot orchestration** — [00:03:04] A Microsoft Fabric MCP server lets developers connect to Fabric and stitch Oracle and Fabric workflows together via GitHub Copilot.
- **Oracle AI Database@Azure offering spectrum** — [00:11:42] Beyond Autonomous Database, the offering spans Base DB, Exadata, and Exascale for running Oracle workloads natively on Azure.
- **Two paths for Oracle data into Fabric** — [00:12:10] Customers can replicate data using OCI GoldenGate in real time or use Fabric mirroring to bring Oracle data natively into Fabric in near real time.

## Topics covered
- Multi-cloud data access challenges: manual connectivity wiring, schema discovery, data silos, and app scaffolding.
- Provisioning an Oracle Autonomous AI Database (ADB-S) through the Azure Marketplace.
- Using GitHub Copilot to debug and troubleshoot a non-working local application setup.
- Generating synthetic customer and account tables (2,100 rows each) via natural-language prompts translated to SQL through SQLcl.
- Database validation: row sampling, optimizer statistics, index and constraint checks.
- Exporting Oracle data to the Fabric OneLake (CSV and enterprise GoldenGate options).
- Building a medallion architecture (bronze to gold) with Fabric notebooks and PySpark.
- Entity-relationship modeling, ETL pipeline construction, and deployment from VS Code into Fabric.
- Building a viewership prediction model using the Prophet forecasting model, run per channel with ML metrics.
- Creating semantic models, Power BI dashboards, and a Fabric data agent with role-based access control.
- Connecting transactional Oracle data to the unified IQ layers (Fabric IQ, Foundry IQ, Work IQ).

## Notable quotes
> "The MCP server is able to go and then translate the natural language commands to a SQL query and that is how it gets the data." — Partha Srinivasan

> "As an ML engineer, you're spending a lot of days and weeks to build all of these experiments and with the help of Fabric MCP Server... you are able to do all of this with just a few prompts in a few hours." — Rajya Laxmi Yellajosyula

> "A unified IQ layer makes your Oracle transactional data more actionable." — Rajya Laxmi Yellajosyula

## Products and tools mentioned
- Oracle AI Database@Azure (Autonomous Database / ADB-S, Base DB, Exadata, Exascale)
- Oracle MCP Server
- Microsoft Fabric MCP Server
- GitHub Copilot
- Microsoft Fabric (OneLake, Lakehouse, notebooks, data pipelines, semantic models, data agents)
- Visual Studio Code
- Oracle SQLcl
- OCI GoldenGate
- Fabric Mirroring
- Apache Spark / PySpark (Delta tables)
- Prophet (forecasting model)
- Power BI
- Microsoft AI Catalog
- Azure Marketplace
- Fabric IQ, Foundry IQ, Work IQ
- Fabric REST APIs

## Speakers featured
- Partha Srinivasan — presenter (first demo: database provisioning and data export to Fabric)
- Rajya Laxmi Yellajosyula — Oracle AI Database@Azure / Microsoft team (second demo: Fabric pipelines, ML, and analytics)
- Daniel [inferred], a colleague from Sweden credited with the initial demo environment setup

## Follow-up resources
- Blog posts published the same day (referenced in-session).
- An on-demand session available in the Microsoft Build catalog.
- The presenters' booth for additional demos and Q&A.
