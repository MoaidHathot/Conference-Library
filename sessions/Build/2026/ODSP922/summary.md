<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP922\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP922\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:59.3414437+00:00
-->
# Summary

## Overview
This on-demand demo shows how Elastic Agent Builder can layer LLM-powered conversational and agentic search onto an existing production e-commerce application without a full rebuild. Using a fictitious camping-gear retailer called Wayfinder Supply Company, the session demonstrates connecting an LLM hosted on Microsoft Foundry, building workflows and tools, assembling an agent, and integrating it back into a live web app.

## Key announcements
- **Elastic Agent Builder is now generally available** (00:04:51) — previously in technical preview, it can now be used for production workloads.
- **Elastic is natively available on the Azure Marketplace** (00:00:49) — deployable through the Microsoft Marketplace without separate procurement or additional vendor relationships.
- **Every tool built in Agent Builder is exposed as an MCP tool and accessible via API** (00:14:42) — agents and tools can be called from any application with an API key.

## Topics covered
- Grounding LLM responses in proprietary data versus relying on model training data alone.
- Elastic's three solutions: Search, Observability, and Security.
- Lexical, semantic/vector, hybrid, and agentic search compared (e.g. "coats" returning "jackets" via vector similarity).
- Deploying a base model (Mistral Large) in Microsoft Foundry and wiring it into Agent Builder via a custom Azure connector using a target URI and API key.
- Building an Agent Builder workflow with manual triggers, steps, on-failure retry handlers with delays, and logging.
- Creating tools (ESQL, index search, workflow, and MCP tool types) and assembling them into a Trip Planner agent with custom instructions.
- Agent reasoning transparency, including weather/road-alert checks, clickstream affinity queries, and product-catalog searches.
- Generating example Python API integration code by prompting the agent itself.
- End-to-end architecture: React front end, Python FastAPI backend, Elastic stack, and four agent tools (Product Search, Get User Affinity, Check Trip Safety, Get Customer Profile) backed by MCP servers and a CRM service.

## Notable quotes
> "A model without the right context, without the right data is just a very expensive autocomplete." — Greg Crist

> "We went from an e-commerce site that had chat, hybrid and lexical search to using Agent Builder to build an agent that powered a concierge type trip planner with product recommendations." — Jonathan Simon

## Products and tools mentioned
- Elastic Agent Builder
- Elasticsearch
- Elastic Observability
- Elastic Security
- Elastic Serverless
- Elastic Inference Service
- Microsoft Foundry
- Azure OpenAI
- Foundry IQ
- Azure Marketplace / Microsoft Marketplace
- Mistral Large
- Anthropic [inferred] (default preconfigured LLM)
- Model Context Protocol (MCP)
- ES|QL (Elasticsearch Query Language)
- React
- Python / FastAPI
- Visual Studio Code

## Speakers featured
- Greg Crist — Cloud Ecosystem Architect, Elastic
- Jonathan Simon — Senior Product Marketing Engineer, Elastic

## Follow-up resources
- Elastic Agent Builder documentation (referenced at 00:24:07)
- GitHub repository with the Wayfinder Supply web app code and readme (referenced at 00:24:12)
- Free hands-on workshop requiring no installation (referenced at 00:24:31)
- QR code for a seven-day free trial of Elastic on Azure (referenced at 00:24:39)
