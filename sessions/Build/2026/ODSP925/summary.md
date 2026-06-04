<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP925\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP925\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:45:00.2282179+00:00
-->
# Summary

## Overview
A foundational walkthrough of retrieval augmented generation (RAG), framing it within the broader category of context augmented generation and explaining why production RAG is harder than prototyping. The session culminates in a demonstration of Progress Agentic RAG, a RAG-as-a-service platform, integrated with .NET and Blazor via its C# SDK.

## Key announcements
- **Progress Agentic RAG platform (00:06:46)** — A RAG-as-a-service offering that ingests video, audio, chat logs, and documents, with built-in document providers and agents for extracting tags, entities, and embeddings.
- **Hybrid search with agentic reranking (00:07:22)** — Combines keyword, semantic, and graph search, with results reranked by an AI agent.
- **REMi evaluation agent (00:07:34)** — An embedded AI quality-and-evaluation metric that assesses the system's stability as data is ingested and retrieved.
- **HTML widget builder and multi-language SDKs (00:07:57)** — Administrators can deploy search widgets with citations, or use .NET, TypeScript/JavaScript, and Python SDKs plus REST APIs for custom builds.

## Topics covered
- The distinction between context augmented generation (loading data into the context window) and retrieval augmented generation (vector database storage and retrieval).
- Cache augmented generation, exemplified by Copilot in Visual Studio Code holding project files as vector data.
- Vector embedding, semantic similarity search versus keyword search, and document chunking for ingestion.
- Citations as a means of grounding answers and proving they were not hallucinated.
- The complexity of end-to-end RAG architecture: user interfaces, embedding and chat models, document providers, text translation, and evaluation, requiring software engineering, data science, and AI expertise.
- Enterprises moving away from in-house RAG stacks toward agentic RAG.
- A demo building a financial dashboard that ingests PDF SEC filings and renders charts and conversational answers using the C# SDK and Blazor Server.

## Notable quotes
> "Citations are an important feature for tracing answers back to their origin and providing that the answer is grounded in real knowledge. In other words, the system can show receipts that prove the answer was not hallucinated." — Ed Charbeneau

> "It's not humanly possible to make use of all that data we collect without using some sort of AI." — Ed Charbeneau

## Products and tools mentioned
- Progress Agentic RAG
- REMi (evaluation agent)
- Telerik UI for Blazor
- Blazor Server
- C# / .NET SDK
- TypeScript/JavaScript SDK
- Python SDK
- Visual Studio
- GitHub Copilot in Visual Studio Code
- Google Gemini (YouTube transcript feature)

## Speakers featured
- Ed Charbeneau — Principal Developer Advocate at Progress Software, 10-time Microsoft MVP

## Follow-up resources
- progress.com (referenced for more information on Progress Agentic RAG, alongside an on-screen QR code linking to presentation resources including the financial services C# SDK and Blazor application)
