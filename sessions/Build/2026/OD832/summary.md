<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD832\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD832\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:39.7469155+00:00
-->
# Summary

## Overview
Azure Logic Apps is repositioned from an enterprise integration platform into an AI automation platform, with a new offering—Logic Apps Automation—designed to preserve enterprise rigor while removing infrastructure and Azure-portal friction. The session demonstrates three capabilities: the Logic Apps Automation platform, knowledge-as-a-service for managed RAG, and deep integration between Azure AI Foundry agents and Logic Apps orchestration.

## Key announcements
- **Azure Logic Apps Automation (public preview)** — [00:06:08] An enterprise-ready automation platform hosted outside Azure at auto.azure.com, accessible with Microsoft Entra ID and requiring no Azure portal access or expertise, while still running on Azure with isolated compute, RBAC, auditability, and VNet support.
- **Knowledge as a service (public preview)** — [00:13:10] Managed RAG built directly into workflows where uploaded files are automatically ingested, chunked, and vectorized, with retrieval available as a native workflow step and no pipeline to configure.
- **Azure AI Foundry and Logic Apps integration** — [00:17:47] Foundry agents can be created, invoked, and kept in sync from within Logic Apps, with Logic Apps connectors, APIs, and workflows usable as agent tools, and execution correlated across both portals by run ID.

## Topics covered
- Distinction between AI agent demos (happy path) and production agents requiring retries, error handling, logging, and governance.
- Friction points of the existing platform: procurement, provisioning overhead, and manually wiring together separate Azure services.
- The governance model: projects (Azure resources governed by ARM RBAC, managed by admins) versus apps (built by developers without Azure access).
- Combining deterministic steps with AI reasoning in single workflows (invoice processing, contract validation, auto loan approval).
- Sandboxes as isolated agent compute built on the GitHub Copilot SDK, supporting skills and MCPs.
- Copilot-assisted workflow scaffolding from natural language, scoped to workflow or individual action.
- Knowledge groups as the unit of reference for grounding agents, built on Cosmos DB and Azure OpenAI.
- Human-in-the-loop, long-running approval processes routed through Microsoft Teams.
- Observability: run history with inputs, outputs, execution time, status, and token utilization.

## Notable quotes
> "Most companies at this point have built an AI agent demo, but very few have one running in production." — Divya Swarnkar

> "The goal was simple here. We wanted to remove the friction, but not the rigor." — Divya Swarnkar

> "Same execution, two lenses, correlated by run ID across both portals, so you get the right view in the right place without losing the thread between them."

## Products and tools mentioned
- Azure Logic Apps
- Azure Logic Apps Automation
- Azure AI Foundry (Microsoft Foundry)
- Azure OpenAI
- Azure Cosmos DB
- GitHub Copilot
- GitHub Copilot SDK
- Microsoft Entra ID
- ServiceNow
- Salesforce
- Microsoft Teams
- Azure DevOps
- Azure RBAC / ARM

## Speakers featured
- Divya Swarnkar — Product Manager, Azure Logic Apps
- Speaker 1 — demo presenter (unnamed in transcript)

## Follow-up resources
- auto.azure.com — landing page and sign-in for Logic Apps Automation public preview
