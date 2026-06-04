<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM364\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM364\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:01.3608935+00:00
-->
# Summary

## Overview
A 25-minute demo showing how Azure HorizonDB, Microsoft's newly announced cloud-native PostgreSQL database, embeds AI models, pipelines, and search directly in the database. The session builds key components of a "Zava" room-designer agent entirely with built-in HorizonDB features, demonstrating embedding generation, hybrid vector search, semantic re-ranking, and knowledge graphs using only SQL and no external services.

## Key announcements
- **Azure HorizonDB public preview** (00:00:42) — Announced the prior day by Satya [inferred Nadella], HorizonDB pairs the open-source PostgreSQL engine with a cloud-optimized scalable storage backend for higher resiliency, scale, and performance.
- **Performance and scale gains** (00:01:10) — HorizonDB claims 3x higher transaction throughput, 3x faster vector search, and support for up to 15 read-only replicas.
- **Bundled AI models at provisioning** (00:04:06) — A single checkbox during cluster creation activates model management plus pgvector and DiskANN vector search extensions, provisioning three managed models (chat completion, text embedding, and a semantic ranker) with the database.
- **AI pipelines with change triggers** (00:08:05) — A SQL-defined pipeline chunks source rows, generates embeddings via the Microsoft Foundry embedding model, and attaches a trigger that incrementally and asynchronously processes new data without blocking inserts.
- **PGFTS full-text search extension** (00:14:59) — A new extension bringing Lucene-type full-text search to Postgres, combined with a DiskANN vector index to enable hybrid search.

## Topics covered
- Provisioning HorizonDB clusters via a Postgres VS Code extension with model bundling
- Inspecting the in-database model registry and bring-your-own-model support
- Building embedding pipelines: chunking, vectorization, incremental trigger-based updates
- Hybrid search combining full-text (BM25/keyword) and vector results via reciprocal rank fusion
- Semantic re-ranking with a managed ranker model to improve relevance
- Query plan visualization to inspect the internals of the simplified search function
- Knowledge graphs in Postgres using the Apache AGE extension and Cypher queries
- Modeling style relationships ("similar to") to broaden furniture recommendations

## Notable quotes
> "Horizon DB is designed for this new era of AI agents. So it comes with built in AI models, AI pipelines and AI functions."

> "All of this complexity is taken away."

> "All of that functionality we were able to achieve just using built in Horizon DB AI features. So no external services, no complexity, and very few lines of SQL if you prefer that."

## Products and tools mentioned
- Azure HorizonDB
- PostgreSQL
- pgvector
- DiskANN vector search
- PGFTS (full-text search extension)
- Apache AGE extension
- Microsoft Foundry [inferred] (embedding model)
- Postgres extension for VS Code [inferred]

## Speakers featured
- Maxim Lukiyanov — presenter
