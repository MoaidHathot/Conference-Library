<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD824\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD824\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:18.7497631+00:00
-->
# Summary

## Overview
Azure SQL argues that "polyglot persistence" — stitching together separate relational, document, graph, vector, and analytics databases — imposes an avoidable tax in latency, security surface, operational overhead, and developer cognitive load. The session makes the case that the Microsoft SQL core engine now consolidates these workloads natively, and that Azure SQL Hyperscale supplies the cloud-native scale, elasticity, and economics to run them, with particular emphasis on why ACID guarantees matter in agentic scenarios.

## Key announcements
- **Native JSON type and path-specific JSON indexes** *(00:05:45)* — SQL stores JSON as a pre-parsed binary (ANSI JSON type, no longer NVARCHAR(MAX)), cutting JSON storage by 30–50% and allowing indexing of a specific JSON path rather than the whole document.
- **Native vector type with DiskANN and HNSW indexes** *(00:09:18)* — Vectors moved from varbinary to a native type, with vector indexes built on Microsoft Research's DiskANN, including recently introduced updatable DiskANN indexes.
- **Operational-data pre-filtering for vector search** *(00:10:52)* — Relational context (e.g. locating "person Bob") narrows the vector search space, reducing cost versus a standalone vector database.
- **Hyperscale named replicas with isolated working sets** *(00:17:02)* — Each named replica gets its own connection string, buffer pool, and RBPEX (Resilient Buffer Pool Extension) L2 cache, isolating read workloads from primary writes over the same up-to-128 TB dataset.
- **Snapshot-based backups** *(00:16:11)* — Because page servers write to Azure storage, backups use storage snapshots without consuming compute to read pages, unlike traditional BACKUP DATABASE operations.
- **SQL MCP server via Data API Builder** *(00:20:04)* — A REST endpoint from Data API Builder can be exposed as an MCP server, enabling natural-language interaction with Hyperscale data.

## Topics covered
- Defining "polyglot tax": network latency, fragmented auth and security surfaces, separate backups, and developer cognitive load
- A real-time fraud-detection app as the recurring example spanning order history, device fingerprints, graph relations, similar transactions, and statistical baselines
- Native graph support with MATCH syntax and query-optimizer integration
- Clustered columnstore for OLAP-friendly compression and HTAP within a single engine
- Single-transaction-boundary stored procedures combining relational, JSON, graph, and vector operations
- Why ACID semantics and idempotency are critical for agents that write and may rewrite
- Hyperscale architecture: dedicated log service, page servers with SSDs, asynchronous redo, and Azure storage as durable tier
- Serverless scaling of named replicas (e.g. 2 to 128 vCores), provisioned primary with serverless replicas, Geo-DR and built-in high availability
- Security features: ledger, dynamic data masking, Always Encrypted, tenant-based execution
- Economics: eliminating sidecar databases, pay-for-use serverless, storage from 10 GB to 128 TB, reduced staffing, and a licensing-free model

## Notable quotes
> "When I say polyglot tax, I mean having the tax that you pay for choosing multiple databases." — Aditya Badramraju

> "After we switched to Hyperscale, I can really sleep peacefully in the night." — customer, as recounted by Aditya Badramraju

> "ACID semantics are so important in agentic world than a normal world." — Aditya Badramraju

## Products and tools mentioned
- Azure SQL Database Hyperscale
- Microsoft SQL (core engine)
- DiskANN [inferred]
- HNSW
- Clustered columnstore
- RBPEX (Resilient Buffer Pool Extension)
- Data API Builder
- SQL MCP server
- Azure Storage

## Speakers featured
- Aditya Badramraju — Product Manager, Azure SQL
