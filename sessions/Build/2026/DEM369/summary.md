<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM369\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM369\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:29.4673631+00:00
-->
# Summary

## Overview
A live, demo-driven walkthrough of how Microsoft's tooling now closes the gap between Responsible AI principles and production engineering, framed around moving AI agents out of proof-of-concept "black box" status into governed, observable production systems. The session traces a single workflow across Microsoft Fabric, Microsoft 365 Copilot, Microsoft Purview, and Azure AI Foundry, showing assessment, safety filtering, monitoring, red teaming, and policy enforcement.

## Key announcements
- **Fabric data agents publishable to Microsoft 365 Copilot** *(~00:06)* — A data agent built on a Fabric ontology/lakehouse can be exposed to Copilot with a single click and queried in natural language alongside other agents.
- **Agent ownership and sharing controls** *(~00:10)* — An agent created in the tenant remains private to its owner until explicitly published to a user or group, giving creators accountability over visibility.
- **Microsoft Purview for AI agent governance** *(~00:10)* — Purview (renamed from compliance tooling because it now covers more than compliance) surfaces agent activity, sensitive data, and DSPM views, with AI interaction logs retained for 30 days.
- **Azure AI Foundry tracing and monitoring** *(~00:15)* — Foundry exposes per-interaction tracing, application insights integration, scheduled evaluations, and scheduled red teaming, addressing earlier "black box" feedback.
- **Built-in red teaming via PyRIT** *(~00:16)* [inferred] — Foundry includes red-teaming capabilities (the open-source PyRIT framework is referenced as reusable in projects).
- **Guardrails with custom block lists** *(~00:22)* — Default Microsoft guardrails can be extended with regex-based block lists (e.g., credit card patterns) and attached to an agent to block flagged queries directly.
- **AI Gateway via API Management** *(~00:24)* — Models, tools, and agents can be placed behind an API Management gateway to enforce per-user daily and monthly token quotas, securing cost and blocking volumetric attacks.

## Topics covered
- Evolution of AI agents from non-production PoCs to governed production systems
- Mapping AI development onto the software engineering lifecycle (design, code, test, production)
- "Shadow AI" as a successor concern to shadow IT
- Querying company data through Fabric ontology and data agents
- Monitoring agent activity, sensitive info types, and AI interactions in Purview and DSPM
- Advanced hunting over agent logs using Kusto Query Language in a Log Analytics workspace
- Prompt-injection and jailbreak resistance ("ignore previous instructions")
- Evaluation metrics: coherence, groundedness, relevance, token usage, error/pass-fail rates
- Building evaluation datasets from existing traces
- Reverse-engineering red-teaming results to author guardrails and compliance policies
- Tenant security as the customer's responsibility versus Microsoft-managed defaults

## Notable quotes
> "It was black box. We created agents and the customers were saying, oh, that's great, but do I put my critical data inside? Because I don't know what's happening."

> "Your users, your data, your endpoints that you publish... makes this tenant somehow insecure because you need to control this one. So it's your responsibility, not Microsoft."

> "Ten years ago, I would kill somebody for this one, because every single day we were evaluating if our chatbot is working or not."

## Products and tools mentioned
- Microsoft Fabric (data agents, ontology, lakehouse)
- Microsoft 365 Copilot
- Microsoft Purview (Activity Explorer, DSPM)
- Azure AI Foundry
- Microsoft Defender (advanced hunting)
- Azure Monitor / Log Analytics workspace
- Kusto Query Language (KQL)
- PyRIT [inferred]
- Azure API Management (AI Gateway)
- Work IQ
- Microsoft Security Copilot Studio agents [inferred]

## Speakers featured
- Alexander Wachtel — Microsoft MVP and Trainer [inferred], C# developer; presenter (demo personas "Hannah" for Fabric and "Rafael" for Microsoft 365 / compliance were referenced as role illustrations)

## Follow-up resources
- A public repository where the demo materials and screenshots will be made available after the session (named but not linked in the transcript)
- The presenter invited attendees to connect with him on LinkedIn
