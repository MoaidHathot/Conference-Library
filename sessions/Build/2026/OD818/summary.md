<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD818\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD818\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:13.2044716+00:00
-->
# Summary

## Overview
The session reframes data engineering as an "AI-native" discipline in which engineers retain ownership of architecture and quality while delegating implementation to agentic Copilot across Fabric Web, VS Code, and the CLI. Through two demos, it shows how grounding AI in well-structured code, skills, and deterministic tooling lets a single engineer parallelize medallion-architecture pipeline work on Microsoft Fabric.

## Key announcements
- **Enhanced Copilot Chat in Fabric notebooks** (00:05:02) — An upgraded conversational experience that helps users work directly in the Fabric portal.
- **Fabric Data Engineering extension for VS Code with MCP support** (00:05:06) — Now enhanced with the Fabric notebook MCP server and tools that make the GitHub Copilot agent aware of Fabric context, including lakehouse targets.
- **Fabric-aware notebook agent mode** (00:05:50) — Lets Copilot read a Spark notebook, discover skills in built-in folders (E2E medallion architecture, eventhouse authoring), propose a phased plan, and execute selected cells.

## Topics covered
- Evolution of the data engineer role from manual ETL toward AI-accelerated implementation while retaining architectural control.
- Matching the AI interaction model (conversational vs. delegated execution) to the task and surface (Fabric web portal, VS Code IDE, CLI/terminal).
- Microsoft Fabric as a unified platform with OneLake as the common data foundation for governance and security.
- Medallion architecture (bronze/silver/gold), schema-on-read, Delta Lake, checkpointing, and eventhouse optimization.
- Streaming ingestion from a Fabric event stream as a Kafka source into Delta tables via a Spark notebook.
- The "Ralph loop" concept: placing AI in a context-bounded box with a well-defined task and visual stop cues.
- Mounting OneLake locally via the BlobFuse driver in a Linux VS Code dev container to run local Fabric Spark against production data.
- Authoring Copilot skills (YAML front matter plus markdown) and deterministic CLI tools for repeatable AI behavior.
- Writing AI-friendly code: shared interfaces/traits (a `DataTransformer` trait taking a DataFrame and returning a DataFrame), reusing loader/transformer/driver classes, and gold-standard unit tests.
- Scaling out: parallelizing Copilot CLI across multiple GitHub Actions machines or dev boxes, testing on production data before merging, then running the same Spark code at scale in Fabric.

## Notable quotes
> "This is not a different person. It is evolution of the same job. The engineer still owns the architecture, the quality, and the end results but uses AI to accelerate the implementation." — Piero Morano

> "All you need to do with AI is basically go ahead and ground it in context, put it inside of a box, and let Ralph Wiggum do what he does best, which is essentially just keep trying until what you ask for succeeds." — Raki Rahman

> "The quality of the code would be as good. Honestly, it is as good as if I sat here and wrote it myself." — Raki Rahman

## Products and tools mentioned
- Microsoft Fabric
- OneLake
- Power BI
- Fabric Real-Time Intelligence
- Fabric Data Engineering extension for VS Code
- Visual Studio Code (dev containers)
- GitHub Copilot / Copilot CLI
- Claude Opus [inferred]
- Apache Spark / Fabric Spark (PySpark, Scala)
- Apache Livy
- Delta Lake
- Apache Kafka
- Fabric Eventstream / Eventhouse
- Model Context Protocol (MCP)
- BlobFuse (ADLS driver)
- dbt (Data Build Tool)
- Hive API
- GitHub Actions
- Azure DevOps

## Speakers featured
- Piero Morano — Product Management lead for the Developer Experience for Data Engineering and Data Science, Microsoft Fabric.
- Raki Rahman — Principal Software Engineer, SQL Server Telemetry and Intelligence team.

## Follow-up resources
- Two GitHub repositories shared on screen (a reproducible VS Code dev container and sample code demonstrating Copilot skills and patterns) under the presenter's GitHub handle.
- Microsoft Fabric documentation, tutorials, and YouTube channel referenced in the closing remarks.
