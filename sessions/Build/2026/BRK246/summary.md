<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK246\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK246\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:23.4465655+00:00
-->
# Summary

## Overview
Foundry IQ is Microsoft's context engineering platform for connecting agents to enterprise knowledge using agentic retrieval built on Azure AI Search. The session walks through the full lifecycle—provisioning, ingesting knowledge sources, and retrieving—while emphasizing ease of onboarding, layered versatility, and state-of-the-art ranking quality, all with enterprise-grade security.

## Key announcements
- **Serverless Foundry IQ (public preview)** — A no-friction tier that provisions in 10–20 seconds, scales to zero, charges only for storage and usage, and is production-ready for dynamic workloads including agents that create and delete services on the fly [00:09:00].
- **Every knowledge base is exposed as an MCP server out of the box** — Created knowledge bases are immediately consumable via an MCP endpoint (`/MCP`) or API with no extra setup [00:03:16].
- **Second-generation agentic retrieval** — The retrieval stack was revamped to exploit newer language models' tool-calling, showing material gains in recall, answer correctness, and completeness over BM25, hybrid search, and minimal mode [00:32:08].
- **New semantic ranker model** — A newly trained ranker continues the team's multi-year ranking work, contributing to improved relevance [00:34:08].
- **Web IQ** — Announced the prior day, providing web search grounding that can be added to a knowledge base as an MCP knowledge source [00:20:55].
- **Azure Content Understanding integration** — Powers OCR, document layout, reading-order preservation, table extraction, and image verbalization during ingestion [00:16:50].

## Topics covered
- The three-layer Foundry IQ architecture: Foundry integration, agentic knowledge retrieval, and the core retrieval engine (vector + lexical with ranking models).
- Serverless versus dedicated capacity trade-offs (usage-based and dynamic versus predictable, isolated, confidential-computing-capable).
- Knowledge bases as a scope-and-policy abstraction (retrieval effort, steering instructions, answer synthesis) over multiple knowledge sources.
- Knowledge source spectrum: loose files, file knowledge source with full processing, blob storage / OneLake ingestion with chunking and vectorization, Work IQ (M365), Fabric IQ (OneLake catalog, data agents, natural-language-to-SQL), and MCP-based extensibility.
- Incremental, change-tracking ingestion that keeps indexes fresh.
- Document-level security: propagating access control from SharePoint and blob storage, Entra group membership, delegated user tokens, and Purview sensitivity-label integration.
- Agentic retrieval pipeline: query planning, iterative search, answer synthesis, and references/activity for debugging.
- Token efficiency and prefix/token caching to reduce cost and latency.
- Index-level control: vector compression (default 8-bit quantization), re-ranking policies, and schema customization.
- Retrieval speed demonstrated on an English Wikipedia index of roughly 22 million chunks.

## Notable quotes
> "Foundry IQ is the thing you use to connect agents to knowledge." — Pablo Castro

> "Document level security is not the kind of thing you just want to improvise real quick while you're building the rest of the stack." — Pablo Castro

> "This thing searches at the speed that I can type... So this is searching on every keystroke and I still can't keep up." — Pablo Castro

## Products and tools mentioned
- Foundry IQ
- Microsoft Foundry
- Azure AI Search
- Serverless Foundry IQ
- Work IQ
- Fabric IQ
- Web IQ
- Microsoft Fabric
- OneLake
- Azure Content Understanding
- Azure Blob Storage
- GitHub Copilot
- Model Context Protocol (MCP)
- GitHub MCP server
- Microsoft Entra
- Microsoft Purview
- Microsoft 365
- Azure portal
- GPT-4.1 mini [inferred]
- BM25

## Speakers featured
- Pablo Castro — Foundry IQ team, Microsoft (presenter)
- Allison Sparrow — listed co-speaker (does not appear in the transcript)
