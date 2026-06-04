<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD820\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD820\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:21.1249044+00:00
-->
# Summary

## Overview
A 300-level walkthrough of building a production-grade, multi-tenant travel assistant using Azure Cosmos DB as the backbone for agent memory, retrieval, and coordination. Justine Cocchi and Aayush Kataria contrast single-agent and multi-agent patterns, introduce agentic memory versus traditional RAG, and demonstrate several newly announced Cosmos DB capabilities for memory, reliability, and query optimization.

## Key announcements
- **Agent memory toolkit for Azure Cosmos DB (public preview)** — A background runtime that handles fact extraction, auto-summarization, conflict resolution, and four memory types, backed by Cosmos DB [00:27:21].
- **LangChain Azure Cosmos DB integration (generally available)** — Packages the Cosmos DB vector store and LangGraph checkpointer store used to build the demo multi-agent app [00:27:43].
- **Cosmos DB agent kit (generally available)** — An installable repo of skills usable by agent-skills-compatible coding agents (GitHub Copilot, Claude Code, Gemini CLI) to enforce partitioning, indexing, and RU best practices, droppable into CI/PR reviews [00:31:18].
- **Per-partition automatic failover (generally available)** — Enables single-writer active-active failover at the partition level for five-nines availability with zero downtime, data loss, and touch [00:35:44].
- **Distributed transactions (public preview)** — Atomic execution of writes across partitions and containers, so multi-container operations succeed or fail together [00:37:00].
- **Integrated embeddings** — Generates embeddings asynchronously at write time via Microsoft Foundry integration, removing brittle synchronous calls to OpenAI [00:38:25].
- **Global secondary indexes (generally available)** — Auto-syncing secondary containers partitioned for different access patterns, converting cross-partition queries into single-partition lookups [00:42:11].

## Topics covered
- Multi-agent architecture with an orchestrator routing to specialist agents (hotel, dining, activity) over an MCP server.
- Limitations of single-agent designs: context window limits, lack of separation of concerns, poor scalability.
- Agentic memory versus RAG: dynamic, user-specific, salience-scored, time-aware, and self-learning.
- Memory taxonomy: state, short-term memory, and long-term memory (facts/semantic, procedural, episodic, user summary), including TTL policies (e.g., 90-day episodic expiry).
- Intelligent memory operations: threshold-driven extraction, conflict resolution with superseded audit trails, rolling thread and user summaries, and memory-conditioned search.
- Reliability metrics (SLO, RPO, RTO) and the active-active pattern via multi-writer versus single-writer setups.
- Hierarchical partition keys for multi-tenancy and query cost optimization (a Paris-trips query dropping from ~30 RUs to ~3 RUs, roughly 90% savings).

## Notable quotes
> "In Cosmos DB that gap is paved with decisions that you make on day one and pay for on day 90." — Aayush Kataria

> "That's how 'Show me hotels in Tokyo' becomes 'Show me luxury hotels in Tokyo.' So the personalization isn't bolted on at the end. It's baked into the query itself." — Aayush Kataria

> "For distributed cloud applications, it's not a matter of if a disaster will strike, but when." — Justine Cocchi

## Products and tools mentioned
- Azure Cosmos DB
- Azure OpenAI
- Microsoft Foundry
- Agent memory toolkit for Azure Cosmos DB
- Cosmos DB agent kit
- LangChain / LangGraph (Azure Cosmos DB integration, checkpointer store)
- GitHub Copilot
- Claude Code
- Gemini CLI

## Speakers featured
- Justine Cocchi — Program Manager, Azure Cosmos DB team
- Aayush Kataria — Software Engineer, Azure Cosmos DB

## Follow-up resources
- Cosmos DB Travel Multi-Agent — demo code and a workshop for building the application, referenced as the session's first link [00:45:46].
