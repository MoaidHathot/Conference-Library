<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM333\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM333\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:39.5882657+00:00
-->
# Summary

## Overview
This demo session shows how to build a general-purpose OpenClaw-style agent entirely with open-source frameworks and then operationalize it in Microsoft Foundry without rewriting code. The presenters incrementally add tools, skills, browser automation, observability, and agent-to-agent composition, emphasizing that open standards let each component be swapped or composed independently.

## Key announcements
- **Foundry hosts LangGraph agents via an OpenAI-compatible Responses API** ([00:09:28]) — the same `build_agent` code runs locally or as a Foundry-hosted agent through a thin adapter layer, making the move to production a configuration change rather than a rewrite.
- **Foundry-hosted agents expose an A2A endpoint** ([00:13:19]) — any agent-to-agent-compatible client can discover the agent card and send it messages, demonstrated by Copilot CLI invoking the hosted agent.
- **Built-in observability through Application Insights and OpenTelemetry** ([00:11:02]) — Foundry uses the Microsoft OpenTelemetry distro and GenAI semantic conventions to capture spans, latencies, token usage, and trace replays.

## Topics covered
- The minimal agent architecture: a model plus an agent loop, built with LangChain's chat model and `create_deep_agent` (LangGraph-style code).
- Pointing LangChain at Foundry models using the OpenAI-compatible protocol so changing model targets is configuration only.
- Model Context Protocol (MCP) for tool discovery, using the Work IQ Mail server to reach Microsoft 365 mail capabilities.
- Skills as reusable Markdown "playbooks" (e.g. inbox triage) that change agent behavior without bloating the system prompt.
- Browser automation via the Playwright CLI as a token-efficient alternative to a large MCP tool surface.
- Tracing token spend and tool actions per span to find cost and latency hot spots.
- Composing isolated components (Copilot CLI → A2A → Foundry-hosted LangGraph agent → Work IQ MCP) where none of the parts know about each other.

## Notable quotes
> "Changing the model target is configuration, not a rewrite." — Nagkumar Arkalgud

> "Skills are a lightweight way to make agent behavior repeatable without turning every instruction into a massive system prompt." — Nagkumar Arkalgud

> "The beauty of this is like none of these components knew about each other... so they will be in isolation, which is composing all of them." — Facundo Santiago

## Products and tools mentioned
- Microsoft Foundry
- LangChain
- LangGraph
- Model Context Protocol (MCP)
- Work IQ Mail (MCP server)
- Microsoft 365
- Playwright CLI
- OpenAI-compatible Responses API
- A2A (agent-to-agent) protocol
- OpenTelemetry / Microsoft OpenTelemetry distro
- OpenTelemetry GenAI semantic conventions
- Application Insights
- Copilot CLI
- Grafana [inferred]

## Speakers featured
- Facundo Santiago — Principal Product Manager, Microsoft
- Nagkumar Arkalgud — Senior Software Engineer, Microsoft

## Follow-up resources
- The demo repository referenced at the close of the session, containing the staged versions of the agent (no URL stated in the transcript).
