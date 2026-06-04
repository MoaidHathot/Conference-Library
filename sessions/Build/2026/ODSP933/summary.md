<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP933\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP933\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:45:18.1775783+00:00
-->
# Summary

## Overview
This session argues that traditional observability—logs, traces, dashboards, and alerts built for human investigators—is breaking down now that AI agents generate, operate, and debug software. Jimmy Herbert of groundcover frames it as a systems-level diagnosis rather than a product pitch, contending that observability must shift from human-readable summaries to complete-context, agent-driven analysis. He maps three structural failures and proposes a new architecture where the LLM orchestrates investigation while a deterministic backend handles analysis close to the data.

## Key announcements
This session is a conceptual diagnosis rather than a product launch; no dated product announcements are present. The architectural positioning described:

- **groundcover's complete-state model** — Agents reason over full system state rather than a curated slice, reducing hallucinated diagnoses (~08:44).
- **Bring Your Own Cloud (BYOC)** — Telemetry stays inside the customer's own cloud for control, governance, and sensitive-data handling (~09:13).
- **Zero instrumentation, zero friction** — The observability layer instruments automatically because humans cannot keep instrumentation current in AI-generated systems (~09:25).
- **"Move the LLM up; push the analysis down"** — The model handles intent and investigation strategy while the backend does deterministic analytical work close to the data (~09:50).

## Topics covered
- Why logs designed for discrete events fail against agent "reasoning trails" and decision breadcrumbs.
- Non-deterministic agent flows breaking head-based and tail-based sampling (e.g., 50,000 spans per session).
- Why a 200 OK status code is meaningless when infrastructure succeeds but the agent outcome is wrong.
- Telemetry volume explosion and the cost-versus-visibility trade-off in vendor ingestion economics.
- Telemetry now containing sensitive data—prompts, PII, financial and business logic—shifting cost discussions into liability discussions.
- Collapse of manual instrumentation under AI development velocity.
- Observability historically optimized for human cognitive limits rather than agent capabilities.
- Context quality mattering as much as or more than model quality.
- The limits of MCP-style external agents operating on partial context as "guests."
- Investigation starting from intent rather than dashboard navigation; agents returning answers and next actions.
- Autonomy, guardrails, validation, and accountability questions for self-remediating systems.

## Notable quotes
> "200 OK means nothing. In traditional systems, a successful status code usually meant the system behaved correctly. In agent systems, it only means nothing crashed." — Jimmy Herbert

> "We're feeding agents a summary and expecting them to understand the entire book. That's not a model problem; it's a data completeness problem." — Jimmy Herbert

> "AI can't fix what AI can't see. The agentic infrastructure needs agentic observability." — Jimmy Herbert

## Products and tools mentioned
- groundcover
- Claude
- MCP (Model Context Protocol) [inferred]
- OpenTelemetry / APM tooling (head-based and tail-based sampling)
- CI/CD systems

## Speakers featured
- Jimmy Herbert — Lead, Solutions Engineering team, groundcover
