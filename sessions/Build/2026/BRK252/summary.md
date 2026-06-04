<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK252\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK252\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:37.2947135+00:00
-->
# Summary

## Overview
Microsoft Foundry Observability is presented as an end-to-end, framework-agnostic system for tracing, evaluating, monitoring, and optimizing nondeterministic AI agents. Using a data center "vendor history analyst" agent as a running example, the session walks through the agent DevOps lifecycle from inner-loop development to outer-loop production monitoring, culminating in a new agent ROI capability that ties agent behavior to measurable business value.

## Key announcements
- **Open ecosystem support for tracing and evals** [00:09:46] — Foundry can trace and evaluate both Foundry and non-Foundry agents built with frameworks including LangChain, LangGraph, OpenAI SDK [inferred], and Microsoft Agent Framework.
- **Rubric Evaluator in public preview** [00:11:10] — Auto-generates a multi-dimensional (e.g. 8-dimension, weighted) evaluator from a system prompt and agent, usable for both offline testing and online evaluation, even with no existing data.
- **Foundry Toolkit with MCP server and skill** [00:12:16] — A VS Code extension providing code-first observability that bundles the Foundry MCP server and an opinionated Foundry skill to analyze evals and recommend client- or server-side fixes.
- **Multi-turn evaluation in public preview** [00:17:48] — Extends evaluation from single-turn to entire sessions, accounting for factors like session duration, not just final success.
- **User simulation** [00:18:22] — Automatically generates realistic multi-turn conversations to bootstrap evaluation when multi-turn data is unavailable.
- **Traces to data sets with smart filtering** [00:19:04] — Selected production traces can be fed back into data sets to expand inner-loop test coverage and enable regression testing.
- **Agent Optimizer in private preview (public preview soon)** [00:21:01] — Iteratively creates new agent versions, optimizing system prompt, tool/parameter descriptions, skills, and model selection against rubrics; a demo run improved baseline rubric score from 0.577 to 0.7 with 40/40 tasks passing in 25 minutes.
- **Agent ROI in private preview (public preview soon)** [00:27:51] — Calculates net agent value by combining an assigned business value per successful invocation with automatically pulled token costs and user-specified tool costs, with drill-down into low-ROI traces.

## Topics covered
- The four pillars of Foundry Observability: tracing, evaluation, monitoring, optimization.
- Inner-loop versus outer-loop agent DevOps and feeding signals between them.
- Continuous online evaluation pulling production traces from Application Insights.
- Diagnosing low evaluation scores and identifying agent hallucination via trace analysis.
- Full-stack observability through Foundry's partnership with Azure Monitor.
- Rubric, LLM-as-a-judge, and code-based evaluators, including when to avoid an LLM judge.
- OpenTelemetry as the open standard underpinning tracing and evaluation, including new memory semantics.
- Computing agent cost (token plus tool cost) against business value to prove ROI.

## Notable quotes
> "We all know that agents are non deterministic, creating new reliability and consistency challenges for developers and operators. This is where observability comes in." — Sebastian Kohlmeier

> "It's pretending to say, hey, this vendor's performing well, but it's not actually giving the correct response with the context that the user was requesting." — Sebastian Kohlmeier

> "It is figuring out the right thing to change, trying it out, learning from that and then iterating and then suggesting the new things." — Vivek Bhadauria

## Products and tools mentioned
- Microsoft Foundry (Foundry Observability)
- Foundry Rubric Evaluator
- Foundry Toolkit (VS Code extension)
- Foundry MCP server and Foundry skill
- Foundry Agent Optimizer
- Foundry Agent ROI
- Azure Monitor
- Azure Application Insights
- OpenTelemetry
- VS Code
- GitHub Copilot Chat
- LangChain
- LangGraph
- OpenAI SDK [inferred]
- Microsoft Agent Framework
- Microsoft 365 Copilot
- Microsoft Teams

## Speakers featured
- Sebastian Kohlmeier — presenter, Foundry Observability
- Filisha Shah — presenter, live demos (referred to as "Felicia" in the auto-captions)
- Vivek Bhadauria — presenter, Agent Optimizer demo

## Follow-up resources
- Companion session BRK241 on developing production agents.
- A hands-on lab covering these capabilities, available online and takeable by attendees.
- Upcoming sessions: a Microsoft 365 breakout on Foundry observability alignment with Microsoft 365 [inferred], a demo session on interoperability, and a lightning talk on Azure Monitor.
