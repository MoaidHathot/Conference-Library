<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD823\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD823\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:15.6262171+00:00
-->
# Summary

## Overview
Azure Managed Redis is positioned as a first-party, fully managed in-memory data store that extends Redis beyond traditional caching into AI workloads through its Redis Search module. The session demonstrates two flagship AI use cases—semantic caching to cut token cost and latency, and agent memory for personalization—both powered by vector similarity search on embeddings stored in Redis.

## Key announcements
- **Azure Managed Redis as a first-party offering** [00:01:10]: A fully managed in-memory data store built on Redis Enterprise software, described as up to 15 times more performant and offering a more cost-effective TCO than Azure Cache for Redis.
- **Default high availability** [00:01:40]: Zone redundant by default with a four nines SLA, and a five nines SLA available via geo-replication.
- **Redis Search module at no extra cost** [00:05:37]: Enables vector similarity search over stored embeddings, powering both semantic caching and agent memory scenarios.
- **Semantic caching demo** [00:09:54]: Compares a standard LLM workflow against a cached experience, serving similar-intent prompts as cache hits with no new tokens generated.
- **Configurable similarity thresholds** [00:14:26]: Cosine similarity thresholds (demonstrated at 50%, 75%, and 90%) let developers tune how strict a semantic cache hit must be.
- **Agent memory integration with Microsoft Agent Framework** [00:29:35]: AMR's short-term and long-term memory capabilities are natively supported within the Microsoft Agent Framework.

## Topics covered
- Traditional Redis use cases (session store, leaderboards, pub/sub, distributed cache) versus newer AI scenarios.
- Production challenges for AI agents: pace of innovation, unpredictable token cost, and need for context and memory.
- Exact key-value caching versus semantic caching for LLMs, and why intent-based matching saves tokens.
- The under-the-hood flow: exact cache lookup, embedding generation, vector similarity search, and threshold-based cache hits.
- Per-user versus global cache key structures to prevent data leakage (e.g., FAQ bots versus user-scoped memory).
- Cost modeling at scale, including cache hit rate as net savings and a ~1.2% break-even cache hit rate.
- Short-term (conversation, state) versus long-term (durable facts, preferences) agent memory, with TTLs of 30 days and over a year respectively.
- Criteria for deciding whether a fact is permanent and worth saving to long-term memory.

## Notable quotes
> "Exact key-value match caching is not ideal for LLMs. I could ask a query that Shruti could send in a few minutes later in a slightly different variation, but it could be the same underlying intent." — Philip Laussermair

> "At a 1.2% cache hit rate, you only need one out of 100 queries in your setup to be a semantic cache hit for this to ultimately save you any money net after that first query." — Philip Laussermair

> "This travel companion knows that I like Airbnbs and early flights, and I don't need to specify that every single time I'm interacting with it." — Roy de Milde

## Products and tools mentioned
- Azure Managed Redis
- Redis Enterprise
- Azure Cache for Redis
- Redis Search
- Azure OpenAI (text-embedding-3-small model)
- Microsoft Agent Framework
- GPT-5
- GitHub

## Speakers featured
- Shruti Pathak — Product Manager, Azure Managed Redis
- Philip Laussermair — Senior Solutions Architect, Redis (specializing in Azure Managed Redis)
- Roy de Milde — Solutions Architect, Azure Managed Redis (covering EMEA, based in the Netherlands)
