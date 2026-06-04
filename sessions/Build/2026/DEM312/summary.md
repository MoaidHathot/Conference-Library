<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM312\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM312\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:23.2520806+00:00
-->
# Summary

## Overview
A 25-minute live demo from the Azure Container Apps team showing an autonomous multi-agent "Content Factory" built from three agents, each on a different framework, running on Azure Container Apps. The session centers on announcing Azure Container Apps Sandboxes—fast, isolated, stateful, on-demand infrastructure for safely executing AI-generated code—demonstrated through a Mexico-vs-Czechia soccer match simulator.

## Key announcements
- **Azure Container Apps Sandboxes (private preview)** *(00:02:49)* — Fast, isolated, and stateful on-demand infrastructure for securely executing agent-generated code, available to try at sandboxes.azure.com.
- **Memory and disk snapshots with sub-second resume** *(00:03:15)* — Idle sandboxes are snapshotted (file system and memory), stop incurring compute cost, and resume in under a second.
- **Egress policies including transform** *(00:15:51)* — A platform-level egress gateway outside the sandbox can allow/deny destinations and inject secrets (such as an API key header) into outbound calls, so agent code never holds the secret.
- **Azure Container Apps Express** *(00:03:43)* — An agent-first technology that provisions in seconds and scales from zero to one in about a second.
- **Foundry registration and management for heterogeneous agents** *(00:19:12)* — Agents built on different frameworks can be registered, observed, and continuously evaluated in Microsoft Foundry as long as they share an agent-to-agent contract.

## Topics covered
- Risks of production agentic runtimes: unattended budgets, ungoverned resources, untrusted code execution, cold starts, and state preservation.
- Composing three agents (researcher/simulator, content creator, narration) across LangGraph (Python), Microsoft Agent Framework (C#), and the GitHub Copilot SDK.
- Bring-your-own-model usage: driving the GitHub Copilot SDK agent with a Foundry model rather than the default Copilot model.
- Dynamic, agent-driven creation of sandbox infrastructure at runtime (one GUID per sandbox per task).
- Secure LLM access patterns: avoiding API keys in environment variables, using managed identity, and egress secret injection.
- End-to-end observability via OpenTelemetry, an OTel collector, Application Insights, and Foundry.

## Notable quotes
> "These sandboxes were not provisioned during the deployment... The simulator agent dynamically creates these resources, it dynamically creates this infrastructure and keeps it up for as long as it's needed."

> "When the sandbox goes idle, there's a snapshot of the sandbox that is persisted... it's memory and file system of the sandbox."

> "The piece of the platform that has the final say on your outbound calls is a different piece of the platform than the part that runs your code."

## Products and tools mentioned
- Azure Container Apps
- Azure Container Apps Sandboxes
- Azure Container Apps Express
- LangGraph
- Microsoft Agent Framework
- GitHub Copilot SDK
- GitHub Sandboxes
- Microsoft Foundry
- Application Insights
- OpenTelemetry (OTel collector)
- Azure OpenAI
- Azure Cosmos DB
- Managed Identity

## Speakers featured
- Jan Kalis — Azure Container Apps team
- Vini Soto — Azure Container Apps team

## Follow-up resources
- sandboxes.azure.com — create and run a sandbox
- aka.ms/ACAbuild2026demo312 — GitHub repo for the demo
- aka.ms/ACAbuild — summary of all Azure Container Apps announcements at Build
