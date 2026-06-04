<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP918\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP918\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:54.9923130+00:00
-->
# Summary

## Overview
A solutions engineer from PingCAP demonstrates how TiDB consolidates agent memory into a single distributed SQL database, replacing the common three-database-plus-ETL stack used for AI agents. The session argues that agentic workloads—bursty, massively concurrent, and dependent on constant context recall—break traditional memory architectures, and shows through a live demo how vector search, full-text search, SQL, and ACID transactions coexist in one table.

## Key announcements
- **Auto-embeddings on insert via `embed_text`** — A SQL function calls the configured Azure OpenAI deployment to generate and store vectors automatically when rows are inserted, eliminating external Python pipelines (demonstrated ~00:06:52, 00:09:09).
- **Hybrid retrieval with RRF in one query** — Vector and keyword searches run against the same table and are combined with Reciprocal Rank Fusion, so rows ranking high in both lists win (00:12:04).
- **Native Azure OpenAI integration** — TiDB connects directly to an Azure OpenAI deployment for embedding generation (00:16:16).
- **Scale-to-zero and database branching** — Idle agents incur no cost, and an isolated database can be spun up per agent in milliseconds (00:07:39).
- **Python SDK `pytidb`** — Installable via `pip install pytidb`, providing hybrid search and RRF in a few lines (00:16:33).
- **MCP server and agent rules for AI coding tools** — Published for Cursor and Claude users to integrate TiDB into coding workflows (00:16:46).

## Topics covered
- Why agent database workloads differ: burstiness, massive concurrency, constant context recall.
- Failure modes of the multi-database memory stack: stale vector indexes, read-after-write inconsistency, partial writes ("ghost refunds"), and connection fan-out.
- TiDB as a distributed, MySQL-compatible SQL database with HTAP and AI engine.
- Vector columns with HNSW [inferred] indexing for semantic recall.
- Full-text keyword search with a multilingual parser on the same table.
- ACID transactions spanning multiple tables (memories plus user facts).
- Compute/storage separation enabling fast scale-out and resource control.
- Production adoption case studies and their scale metrics.

## Notable quotes
> "I'm going to show you how to build agent memory for your AI agents using just SQL." — Ravish Patel

> "One query, one database, no separate engines to keep everything in sync." — Ravish Patel

> "Go build something cool with TiDB and stop running three databases when you only need one." — Ravish Patel

## Products and tools mentioned
- TiDB
- PingCAP
- Azure OpenAI
- pytidb (Python SDK)
- TiDB MCP server
- MySQL
- Manus
- Dify
- Pinterest

## Speakers featured
- Ravish Patel — Solutions Engineer, PingCAP (TiDB)

## Follow-up resources
- TiDB.com — sign up for a free TiDB starter cluster (no credit card)
- pingcap.com/ai/agenticai [inferred] — agent patterns and customer stories
- github.com/pingcap/agentrules [inferred] — MCP server and agent rules for AI coding workflows
- `pip install pytidb` — Python SDK for hybrid search and RRF
