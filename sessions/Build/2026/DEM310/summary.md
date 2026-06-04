<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM310\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM310\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:15.2776359+00:00
-->
# Summary

## Overview
A demo-driven session showing how to apply AI-assisted tooling to NoSQL schema design on Azure Cosmos DB. Using the new Azure Cosmos DB Agent Kit (a packaged set of Copilot skills and best-practice rules) together with GitHub Copilot and the local emulator, the presenters iterate an e-commerce data model from a naive table-to-container mapping to an optimized, access-pattern-driven design and quantify the request-unit and cost savings.

## Key announcements
- **Azure Cosmos DB Agent Kit** — A public, installable package of Copilot skills and over 100 indexed Cosmos DB best-practice rules, deployable into VS Code or any Copilot agent that supports skills, installed via `npx skills @azure-cosmos-db cosmos-agent-kit` [inferred command spelling]. **[00:04:53]**
- **Cosmos DB emulator vNext for Linux** — The new Linux version of the Azure Cosmos DB emulator became generally available "as of today," running locally on Mac, Windows, or Linux for fast iteration. **[00:22:07]**

## Topics covered
- Why developers choose Azure Cosmos DB for NoSQL: JSON-based schema evolution, low latency, global distribution, and AI-native workloads storing operational and vector data in one place.
- Built-in intelligent features: integrated vector search, full-text search, and hybrid search with semantic re-ranking, plus integration with Microsoft Foundry.
- Documenting access patterns and volumetrics (dev vs. production targets) as structured context so the agent can reason about scale.
- The container-per-table "naive" anti-pattern and its high request-unit cost.
- The over-embedding anti-pattern, where growing embedded arrays cause write amplification and escalating RU charges.
- Agent-guided optimization: collapsing domains, choosing partition keys, indexing policies, type discriminators, and embedding line items.
- Using the emulator to create containers, migrate/convert CSV-to-JSON data (decimal parsing, ISO date formatting), and validate document shapes.
- Measuring before/after RU consumption across access patterns and projecting monthly cost savings.

## Notable quotes
> "This is the beauty of Cosmos DB. While Cosmos DB is no SQL database in Azure, only cloud. We also have the very nice emulator which install local in my VM and runs locally and iterating on the emulator is really really fast and easy." — Sergiy Smyrnov

> "Every mistake you do early actually going to penalize you later." — Sergiy Smyrnov

> "I'll save about $980,000 per month by optimizing my schema. But this is a true overhead we see customers losing on the table by not optimizing and doing lazy conversions." — Sergiy Smyrnov

## Products and tools mentioned
- Azure Cosmos DB
- Azure Cosmos DB Agent Kit
- Azure Cosmos DB emulator (vNext, Linux)
- GitHub Copilot
- Visual Studio Code
- Microsoft Foundry
- Model Context Protocol (MCP)
- MongoDB
- Amazon DynamoDB
- Python
- ServiceNow
- OpenAI / ChatGPT

## Speakers featured
- Marko Hotti — presenter (introduced Cosmos DB capabilities and AI tooling context)
- Sergiy Smyrnov — presenter (led the live demo)

## Follow-up resources
- The Azure Cosmos DB Agent Kit public repository, described as downloadable and installable via `npx` (no explicit URL given in the transcript).
