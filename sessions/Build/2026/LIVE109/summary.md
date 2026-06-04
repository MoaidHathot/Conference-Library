<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\LIVE109\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\LIVE109\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:33:07.5348293+00:00
-->
# Summary

## Overview
A fireside chat where Scott Guthrie, who runs Azure and Microsoft's cloud infrastructure, frames what matters for developers in the agentic era: AI-ready infrastructure built from silicon up, data services that scale linearly, and context layers that surface organizational data. The throughline is that agents impose order-of-magnitude higher load on apps, and the database layer is usually the first thing to buckle.

## Key announcements
- **Horizon DB public preview (00:08:26)** — A cloud-native, Postgres-compatible service designed for horizontal scale-out, enabling far larger Postgres databases than Azure's previous scale-limited Postgres offering.
- **Fabric IQ now generally available (00:09:44)** — Takes Power BI semantic models and data from Fabric, Databricks, and Snowflake and surfaces it in Microsoft 365 Copilot for better grounded answers.
- **Azure Maia and Azure Cobalt first-party silicon (00:01:05)** — Microsoft's in-house chips aimed at taking a large percentage of cost out of AI solutions; Cobalt is an ARM64 processor optimized for fast machine startup and short-lived agentic workloads.
- **Over a gigawatt of data center capacity added in 90 days (00:01:55)** — Cited from the earnings report, with data centers described as zero-water-waste and operating across 80-plus locations.

## Topics covered
- The physical buildout of AI infrastructure: land, power, permitting, construction tradecraft, and safety records.
- Architecting software for capacity that doubles roughly every two years, requiring continuous re-architecture of network and storage.
- Scaling agent memory, chat history, and authentication without a single database bottleneck, using per-region Cosmos DB instances with eventual consistency.
- Offloading attachments from databases to BLOB storage at archival cost while retaining queryability and global replication.
- The three families of Azure operational data services: SQL (including SQL Hyperscale with elastic pools), Cosmos DB (NoSQL), and Postgres/Horizon DB.
- Microsoft Fabric's OneLake analytic stack with zero-copy mounting of Databricks and Snowflake tables.
- How agentic traffic drives request volumes from thousands to millions per second, stressing relational databases first.
- Infrastructure for ephemeral, sandboxed agent workloads: fast VM start times and silicon-level memory optimization.

## Notable quotes
> "You kind of need to keep the plane running in the air while you swap out the engines, and that's part of the fun of running a live service." — Scott Guthrie

> "AI is only really good if you have got good data. AI with bad data kind of sucks or has bad decisions." — Scott Guthrie

> "With agents, you know you will get to millions of requests per second." — Scott Guthrie

## Products and tools mentioned
- Microsoft Azure
- Azure Maia [inferred]
- Azure Cobalt
- Azure Cosmos DB
- Azure SQL / SQL Hyperscale
- Horizon DB
- Microsoft Fabric / OneLake
- Fabric IQ
- Power BI
- Microsoft 365 Copilot
- GitHub Copilot
- Databricks
- Snowflake
- Azure Blob Storage
- ChatGPT
- Claude
- Windows

## Speakers featured
- Scott Guthrie — leads Azure and Microsoft's overall cloud infrastructure, data platform, and several higher-level services.
- Seth Juarez — host/interviewer.
