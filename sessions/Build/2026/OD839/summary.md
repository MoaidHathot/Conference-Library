<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD839\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD839\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:49.4082516+00:00
-->
# Summary

## Overview
Foundry Local on Azure Local extends Microsoft's agentic AI stack to enterprise, industrial, and sovereign environments that require low latency, local data control, and the ability to run fully disconnected. The session details how organizations can deploy models, knowledge (RAG), agents, and tools on Azure Local infrastructure while preserving a consistent developer and governance experience through Azure Arc.

## Key announcements
- **Foundry Local on Azure Local in public preview** — Foundry Local now runs on Azure Local infrastructure for both connected and disconnected, single-node and multi-node scenarios across Azure Local form factors (00:08:42).
- **Multi-node model catalog and inferencing** — Building on the February single-node ONNX catalog, customers can now run the Foundry Local model catalog and inferencing across multi-node deployments (00:09:09).
- **Refreshed local RAG with agentic action-taking** — A local RAG offering that manages organizational knowledge can now, for the first time, take action as agentic RAG (00:09:40, 00:21:11).
- **Custom and out-of-the-box MCP tools** — Developers can connect custom MCPs or use catalog MCPs to link local data sources alongside chosen models and RAG (00:09:56).
- **Two model consumption options** — Model-as-a-platform (customer-managed open-source/community models) and model-as-a-service (Microsoft-managed access to frontier proprietary models for eligible sovereign customers) (00:11:44, 00:12:46).
- **Solution templates for chat and video agents** — Foundry solution templates provide downloadable code samples for a local chat UI and a video analysis agent using Video Indexer on Azure Local (00:20:01, 00:25:22).

## Topics covered
- Platform shift from applications to agentic AI as the operating layer, with adoption projections (1.3 billion AI agents by 2028; 82% of organizations adopting agents within three years).
- Sovereign and disconnected use cases: public safety command centers, energy and utilities, critical infrastructure operating through outages.
- Azure Local as AI-optimized, pre-validated CPU/NPU/GPU hardware running Arc-enabled Kubernetes, with Foundry Local installed as an Arc extension.
- Connected vs. fully disconnected (air-gapped) operation, with cloud-synced model catalogs versus locally cached models.
- Security and governance via Microsoft Entra ID, JWT validation, TLS, and API key/token authentication.
- Inference runtimes: ONNX Runtime for single-node generative and predictive AI; vLLM for multi-node high-performance serving; OpenAI-compatible REST endpoints.
- Bring-your-own-model packaging via OCI registry (e.g., models from Hugging Face such as YOLO).
- Agentic RAG knowledge pipeline: query planning, source selection, iterative retrieval, grounded and traceable answers.
- Connecting local data through SharePoint and Exchange Server as part of Microsoft 365 Local.
- Model and agent deployment via SDK, CLI, API, and PowerShell.

## Notable quotes
> "We're in a once-in-a-generation platform shift from applications to agentic AI as the operating layer." — Inbal Sagiv

> "AI strategy has to work when actually things are break. This is not just when everything is running smoothly on cloud." — Inbal Sagiv

> "All of this runs locally. No cloud calls. Every response is traceable back to the source document." — Inbal Sagiv

## Products and tools mentioned
- Microsoft Foundry
- Foundry Local
- Azure Local
- Azure Arc / Arc-enabled Kubernetes
- ONNX Runtime
- vLLM
- Microsoft Entra ID
- Video Indexer
- Microsoft 365 Local
- SharePoint
- Exchange Server
- Hugging Face
- YOLO [inferred]
- Mistral / Ministral
- gpt-oss-20b (open-source model)
- Model Context Protocol (MCP)

## Speakers featured
- Inbal Sagiv — Principal Product Manager, Microsoft (focused on locally running AI)

## Follow-up resources
- Registration form for model-as-a-platform or model-as-a-service access and product group support (mentioned in transcript).
- Preview registration link covering the model offering, RAG, local chat, and video agent capabilities.
- Blog post explaining technical details and code samples.
- Foundry solution templates with downloadable code samples for chat and video analysis.
- Product documentation on available models and recommended scenarios.
