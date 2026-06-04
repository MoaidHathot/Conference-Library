<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK242\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK242\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:12.5092872+00:00
-->
# Summary

## Overview
A demo-heavy session introducing Foundry Tools and the new "toolbox" concept, which bundles disparate tool types (MCP, OpenAPI, A2A, connectors, skills, CLIs) behind a single governed, MCP-compatible endpoint to reduce integration overhead and context-window bloat. The second half covers Content Understanding, a pipeline that converts messy multimodal documents into clean, structured, agent-ready output.

## Key announcements
- **Toolbox (Foundry Tools)** [00:09:01] — A reusable, Foundry-managed bundle of tools that agents consume through one consistent interface and a single unified MCP-compatible endpoint, regardless of underlying tool type.
- **Tool search** [00:14:19] — A protocol/tool inside a toolbox that searches tool metadata at runtime and loads only the tool required for a task, conserving tokens instead of loading everything into the context window.
- **Browser automation tool, available today** [00:16:51] — A new tool built on Playwright that lets agents scrape information and fill in forms (demonstrated auto-filling a Microsoft form).
- **Tools catalog** [00:06:27] — Shipped in 2025, a single place for custom and ecosystem tools, with the option of a private registry via Azure API Center and Azure API Management.
- **Content Understanding GPT-5 family integration** [00:26:35] — Added as an engine for extraction and classification, alongside broader file-type coverage and integrations for Logic Apps, Agent Framework, LangChain, and Markitdown.
- **Agentic extraction, coming July** [00:30:30] — A mode that builds answers step-by-step by reasoning across file content for cases where values must be derived rather than simply found.
- **Section-boundary classification splitting, coming July** [00:28:46] — Documents can be split on logical section boundaries, not just page boundaries.
- **Knowledge-source training for Extract, coming July** [00:29:52] — Customers can provide example documents so Content Understanding trains on and improves extraction for their specific forms.

## Topics covered
- The three unsolved problems in the agentic tool ecosystem: tool creation, tool discovery, and tool governance.
- Token efficiency and context-window management through runtime tool selection.
- The integration burden of giving each agent many tools, each with its own identity, protocol, and credential management.
- Role-based tool governance, centralized authentication, and observability of tool calls.
- The Content Understanding pipeline: parse, classify, extract.
- Grounded extraction with bounding boxes, confidence scores, and human-review routing.
- Using Content Understanding for Foundry IQ ingestion and as an agent context provider for unsupported file types (e.g., DOCX, PDF).
- Encoding business rules via classify-and-extract analyzers (e.g., correctly identifying a field technician).

## Notable quotes
> "Tool discovery is choosing the best tool to complete the task while using the limited amount of tokens." — Maria Naggaga

> "Your agent shouldn't have to care what the underlining tool type is... We give you one unified endpoint with one oauth and one experience that you can integrate into any single agent." — Maria Naggaga

> "Those cases are when an answer needs to be built, not found, built step by step by reasoning across content in the file." — Joe Filcik

## Products and tools mentioned
- Microsoft Foundry
- Foundry Tools / Toolbox
- Tool search
- Foundry IQ
- Content Understanding
- Content Understanding Studio
- Azure API Center
- Azure API Management
- Azure Container Apps
- Browser automation tool (built on Playwright)
- Microsoft 365 Copilot
- Microsoft Copilot Studio
- GitHub / GitHub Copilot CLI and SDK
- Agent Framework
- LangChain / LangGraph [inferred]
- Markitdown
- GPT-5 model family
- Wolters Kluwer CCH Axcess Tax [inferred]
- DataSnipper [inferred]

## Speakers featured
- Maria Naggaga — Product Manager, Microsoft Foundry tools
- Joe Filcik — works on Content Understanding

## Follow-up resources
- azureai.azure.com (Foundry portal)
- aka.ms/fibi — live FIBI fiber-optic agent demo and demo code (available through the end of the week)
- aka.ms (build session demo content)
- Foundry Discord community
