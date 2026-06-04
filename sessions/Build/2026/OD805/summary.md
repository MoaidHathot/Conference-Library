<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD805\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD805\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:42:43.6036219+00:00
-->
# Summary

## Overview
A practical walkthrough of the layered AI building blocks available to .NET developers, progressing from basic chat abstractions through retrieval, tools, and multi-agent orchestration. Bruno Capuano deconstructs a working "Zava" support-center application to show how Microsoft.Extensions.AI, vector data, MCP, and the Microsoft Agent Framework combine, using runnable C# samples against both cloud (Foundry) and local model backends.

## Key announcements
- **Microsoft.Extensions.AI as the provider-agnostic foundation** — The `IChatClient` interface lets the same code target cloud models in Foundry or local runtimes, with integrated Entra ID identity recommended over API keys (00:03:41).
- **Local model support across runtimes** — The chat abstraction works identically with Ollama, LM Studio, or Foundry Local, demonstrated swapping models like Phi-4-mini for sentiment analysis (00:08:05).
- **Built-in RAG and data-ingestion pipeline** — Vector store, embeddings, chunking, and enrichment building blocks support a Reader→Chunker→Enrich→Embeddings→Vector store pipeline, shown with in-memory and SQLite stores (00:11:00).
- **First-class C# MCP SDK** — A maintained SDK integrates Model Context Protocol with Microsoft.Extensions.AI, demonstrated connecting to the Microsoft Learn MCP server for live documentation retrieval (00:23:24).
- **Microsoft Agent Framework** — Adds an `IAgent` interface wrapping the chat client, supporting tools, agent orchestration patterns (sequential, round-robin), and workflows (00:33:05).
- **Agent-to-agent (A2A) connectivity** — Enables connecting a Microsoft Agent Framework agent with an NVIDIA NeMo [inferred] agent via agent cards, with A2A configurable as a custom tool in Foundry (00:39:00).
- **DevUI for agents** — A visual tool to inspect agents and workflows in real time, including traces and tool calls (00:38:08).

## Topics covered
- The five-layer .NET AI stack: foundation, data, tools, agents, and agent-to-agent connections.
- Using integrated/CLI credentials instead of API keys when authenticating to Foundry.
- Swapping deployed models (GPT-5 Mini, Kimi K2 [inferred]) with minimal code changes.
- Embeddings concepts, local ONNX/mini models versus multilingual cloud embedding models.
- Vector similarity search, cosine distance, and relevance scoring on a movie dataset.
- Production-style ingestion: markdown reading, semantic chunking, AI summary enrichment, vector store writing.
- MCP transports, tool listing, function invocation, tool filtering for context management, and streaming responses.
- Agent definitions (name, description, instructions), multi-agent orchestration, and workflows as agents.
- Image generation wired as an agent tool using GPT-Image [inferred] models.

## Notable quotes
> "These are the three lines that make the magic. Create the client and then get an IChatClient. That's it."

> "For me, MCP is the way that we have today to connect external tools."

> "An agent can be an LLM... that uses a set of system instructions to define how the agent is going to behave, and then uses tools to provide the agent features like memory, or access to third-party services."

## Products and tools mentioned
- Microsoft.Extensions.AI
- Microsoft Agent Framework
- .NET Aspire
- Blazor
- Azure AI Foundry
- Foundry Local
- Ollama
- LM Studio
- Model Context Protocol (MCP)
- Microsoft Learn MCP server
- NVIDIA NeMo Agent Toolkit
- Agent-to-Agent (A2A) protocol
- DevUI
- ChromaDB
- SQLite vector store
- ONNX models
- GPT-5 Mini
- GPT-Image [inferred]
- Kimi K2 [inferred] (Moonshot AI)
- Grok
- Phi-4-mini, Nemotron, Qwen, Llama, Gemma
- text-embedding-3-small (OpenAI)
- GitHub MCP, Hugging Face MCP, Playwright MCP [inferred]

## Speakers featured
- Bruno Capuano — Dev Project team, GitHub/Microsoft

## Follow-up resources
- AI apps for .NET developers official documentation (learn.microsoft.com)
- Generative AI for Beginners .NET (code samples)
- Microsoft Learn MCP server: learn.microsoft.com/api/mcp
- MCP registry on GitHub
