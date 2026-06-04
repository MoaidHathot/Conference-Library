<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP395\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP395\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:33:05.8886526+00:00
-->
# Summary

## Overview
This session presents Elastic's Agent Builder, introduced in Elasticsearch 9.4, as a way for AI agents to manage their own context and bridge data silos across enterprise systems. Microsoft and Elastic representatives demonstrate how the tool runs natively in Azure, reduces token usage, and unifies data from sources like Elasticsearch, SharePoint, GitHub, and Slack into a single conversational interface.

## Key announcements
- **Elastic Agent Builder available on Azure** — The Agent Builder, along with Elastic's hosted and serverless cloud offerings, runs in Azure across roughly 15 regions with more being added.
- **Context engine for token-optimized retrieval (00:08:21)** — Elastic's context engine maps and defines data so it need not be recomputed, reducing token usage by roughly 20 to 34%.
- **Microsoft Foundry LLM reuse (00:03:11)** — Agents in Elastic can be powered by Microsoft Foundry models, including Anthropic and OpenAI [inferred] models, via existing MACC agreements and PTUs.
- **Custom skills, tools, and connectors** — Users can build domain-specific skills, create custom tools via the ES|QL query language, indexes, workflows, or MCP, and connect external systems through Federated search connectors.
- **Elastic credits offer** — Up to $1,000 in Elastic credits are available at the Elastic booth.

## Topics covered
- The context gap created by siloed data across disparate enterprise systems
- Procurement of Elastic through Azure commitment dollars (MACC), Elastic Cloud, and the Microsoft Marketplace for a single Azure bill
- Enterprise integration: Microsoft Entra ID sign-in, private link connectivity, V-net integration, and compliance requirements
- Metadata-based classification of sensitive data (e.g. recognizing personal information fields) to govern agent responses
- Transparent agent reasoning that exposes which tools and skills were called, removing black-box behavior
- AI-generated summaries and saveable dashboards from agent queries
- Skills as building blocks that keep agents in a "swim lane" with specific instructions and associated tools
- Federated search connectors for SharePoint, SharePoint Server, Slack, and GitHub
- Human-in-the-loop approval for risky write operations (e.g. posting to a Slack channel)
- A bank customer-support demo unifying case data, policy documents, and engineering issues

## Notable quotes
> "What we are trying to do in Elastic is bridge that context gap by not just bringing in data into Elastic, but also creating the data that sits outside Elastic in these different systems." — Deepti Dheer

> "That removes that black box tendency that some agents have and really gives you a transparent reasoning throughout the sessions when you're running these agents." — Deepti Dheer

> "I can't think of a better partner for that partnership than Elastic." — Mike Richter

## Products and tools mentioned
- Elastic Agent Builder
- Elasticsearch 9.4
- Elastic Cloud (hosted and serverless)
- Microsoft Azure
- Microsoft Foundry
- Microsoft Copilot Studio
- Microsoft Entra ID
- Microsoft Marketplace
- ES|QL (Elasticsearch query language)
- MCP (Model Context Protocol)
- SharePoint / SharePoint Server
- Slack
- GitHub
- Microsoft Teams
- Salesforce

## Speakers featured
- Mike Richter — Principal Partner Solution Architect, Microsoft
- Deepti Dheer — Product Manager for Elastic, focused on Agent Builder

## Follow-up resources
- Apps and agents booths ("yellow booths") staffed by Mike Richter after the session
- Elastic booth offering up to $1,000 in Elastic credits
