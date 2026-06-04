<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD831\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD831\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:40.2336667+00:00
-->
# Summary

## Overview
Azure API Management's AI Gateway extends the platform's long-standing API governance capabilities into a universal gateway that mediates models, tools, and agents across providers and clouds. The session demonstrates how enterprises can apply consistent governance, security, observability, scalability, and developer velocity to AI workloads moving from pilot into production, and announces several general availability and preview releases.

## Key announcements
- **GA of LLM policies for Anthropic and Vertex models [00:12:57]** — Starting June, token limits, token metrics, content safety, and semantic caching can be applied to Anthropic Messages API and Google Vertex models, with log/metric collection and Claude operations importable via Microsoft Foundry.
- **GA of additional token metrics [00:13:36]** — The `llm-emit-token-metric` policy forwards all token types (including thinking, reasoning, and cache tokens) to Application Insights for dashboards and alerts.
- **Preview of Unified Model API [00:14:11]** — A single API in API Management fronts multiple backend providers (Anthropic Messages API and OpenAI-compatible Chat Completions API), with aliases that decouple client model names from backends and enable cross-provider failover.
- **GA of Bring Your Own Model in Microsoft Foundry [00:16:01]** — Any Chat Completions–compatible model proxied through an AI Gateway can be used to build prompt agents in the Foundry Agent Service.
- **New MCP capabilities in API Management [00:21:03]** — MCP servers can be added to products with subscriptions, quotas, and approval workflows; MCP versioning supports A/B testing and blue-green deployments; finer-grained OpenTelemetry observability; and MCP as a first-class element in the management REST API.
- **GA of Agent-to-Agent (A2A) support [00:37:36]** — A2A agents come under the same governance, security, and observability as REST APIs, exposing agent cards and runtime operations with GenAI semantic-convention OpenTelemetry traces.

## Topics covered
- Universal gateway strategy combining traditional API Gateway and AI Gateway capabilities
- Model governance: token rate limits, quotas, content safety, semantic caching, routing, and model fallback
- Multi-provider model backends (Microsoft Foundry, OpenAI, Vertex AI, Bedrock, Hugging Face, Anthropic)
- Tool governance: converting REST APIs to MCP servers, proxying first- and third-party MCP servers
- Securing MCP endpoints via credential manager, OAuth, API keys, and policies
- Agent tool discovery and code generation at design time via GitHub Copilot and AI Gateway
- API Center as the enterprise catalog for REST APIs, MCP tools/skills/plugins, models, and agents
- Git-based synchronization and LLM-as-a-judge skill quality assessment
- A2A agent governance and observability

## Notable quotes
> "We are evolving API Management into more of a universal gateway." — Anish Tallapureddy

> "AI is no longer a pilot. Most enterprises are starting to deploy AI in production." — Anish Tallapureddy

> "A2A is becoming the backbone of multi-agent architectures." — Sreekanth Thirthala

## Products and tools mentioned
- Azure API Management
- Azure API Center
- AI Gateway
- Microsoft Foundry / Foundry Agent Service
- OpenAI
- Anthropic (Claude, Messages API)
- Google Vertex AI
- AWS Bedrock
- Hugging Face
- Mistral
- GitHub Copilot / Copilot CLI / Copilot SDK
- Claude Code
- Application Insights
- Model Context Protocol (MCP) servers and MCP Inspector
- Stripe, Atlassian/Jira, Box, Neon (third-party MCP servers)
- Azure Logic Apps, Functions, Container Apps
- VS Code extension for API Management
- OpenTelemetry

## Speakers featured
- Anish Tallapureddy — API Management team
- Mike Budzynski — API Management team
- Sreekanth Thirthala — API Management team

## Follow-up resources
- aka.ms/apim/blog
