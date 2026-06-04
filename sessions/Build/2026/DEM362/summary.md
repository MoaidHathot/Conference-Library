<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM362\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM362\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:11.1397715+00:00
-->
# Summary

## Overview
A demo-driven walkthrough of building context-aware, multi-agent workflows in Microsoft Fabric using the three "IQs" — Work IQ, Fabric IQ, and Foundry IQ — to give agents grounded, governed access to enterprise data. The session frames each IQ as a distinct persona (Foundry/orchestration, Fabric/data, and compliance/governance) and demonstrates connecting data agents, MCP servers, ontologies, and evaluation notebooks into production-ready pipelines.

## Key announcements
- **The three-IQ model for agent grounding** — Work IQ surfaces daily-business data (emails, meetings, files, chats), Fabric IQ exposes business/ontology data, and Foundry IQ unifies a knowledge base across multiple resources **[00:01:16]**.
- **Work IQ exposed as MCP servers** — beyond powering Microsoft 365 Copilot internally, Work IQ MCP servers (mail, Teams, calendar, Word, database) can be called from external surfaces like Foundry **[00:02:06]**.
- **Human-in-the-loop approval for external agents** — a Foundry agent calling Work IQ mail requires explicit user approval, unlike inside-M365 Copilot which is pre-authorized **[00:07:02]**.
- **Fabric ontology / graph (preview)** — ontologies generated from semantic models act as a graph knowledge source for agents, replacing slower SQL translation; requires enabling ontology items and graph preview in the admin portal **[00:13:09, 00:19:50]**.
- **Publishing Fabric data agents externally** — data agents can be published to M365 Copilot or consumed in Foundry via workspace ID and artifact/agent ID **[00:16:45, 00:19:01]**.
- **Data agent evaluation via SDK** — agents can be queried and evaluated programmatically in notebooks against critical prompts, since portal-created agents cannot be tested or evaluated in place **[00:21:28]**.
- **Governance through Microsoft Purview and Agent 365** — agent interactions, sensitive info types, and policy violations (e.g., unauthorized invoice queries) are visible for auditing and hunting **[00:26:11, 00:27:00]**.

## Topics covered
- The three-persona framing of Work IQ, Fabric IQ, and Foundry IQ
- Trust and the "black box" problem that blocked earlier Azure AI/Azure OpenAI Studio agents from reaching production
- MCP-based external connectivity versus native in-Fabric connections
- Multi-source orchestration in Copilot Studio (combining Work IQ mail with a Fabric data agent to draft email)
- Medallion architecture (bronze/silver/gold) feeding semantic models and ontologies
- Ontologies as graphs versus SQL translation for agent retrieval
- Chatting with data in M365 Copilot, including Python/matplotlib visualization generation
- Data agent evaluation, telemetry, and grounded query completion
- Multi-agent orchestration via Microsoft Agent Framework, Copilot Studio, and Fabric pipelines/notebooks
- Governance, compliance, and sensitive-data monitoring

## Notable quotes
> "The trust was not there because the agents who created three years ago, somehow it was like a black box. Nobody knows what's happening."

> "What I like most is now I can chat with my data."

> "In production you want to know what your data agent is doing. You cannot just deploy and then see... the end users are going to say, oh, it does not work."

## Products and tools mentioned
- Microsoft Fabric
- Work IQ
- Fabric IQ
- Foundry IQ
- Microsoft Foundry
- Microsoft 365 Copilot
- Copilot Studio
- Microsoft Agent 365
- Microsoft Agent Framework
- Microsoft Purview
- Azure OpenAI
- Azure AI Studio / Azure OpenAI Studio (earlier generation) [inferred]
- Azure AI Search
- Azure Blob Storage
- SharePoint Online
- Model Context Protocol (MCP)
- Fabric Lakehouse
- Apache Iceberg [inferred]
- Semantic models and ontologies (graph preview)
- GPT-5.4 [inferred]
- Python / matplotlib

## Speakers featured
- Alexander Wachtel — Microsoft MVP; session presenter (also self-identified as the Foundry/orchestration persona in the demo narrative)

Note: "Hannah" (Fabric/data persona) and "Rafael" (compliance/Copilot governance persona) are referenced as illustrative roles within the demo, not as additional session speakers.
