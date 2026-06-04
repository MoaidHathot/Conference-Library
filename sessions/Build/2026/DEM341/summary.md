<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM341\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM341\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:49.6427681+00:00
-->
# Summary

## Overview
Foundry observability unifies agent telemetry across frameworks, programming languages, and cloud providers by standardizing on OpenTelemetry's GenAI semantic conventions. The session demonstrates how heterogeneous agents—Foundry prompt agents, Google ADK on GCP, LangGraph on AWS—can be stitched into a single end-to-end trace and debugged, monitored, evaluated, and optimized from one plane.

## Key announcements
- **Unified cross-cloud tracing in Microsoft Foundry observability** — Agents running on Azure, GCP, and AWS that emit OpenTelemetry traces are stitched into one uniform trace, making a multi-cloud system feel like a single system **[00:13:02]**.
- **Microsoft OpenTelemetry Distro for auto-instrumentation** — A unified SDK that instruments most agent frameworks across multiple languages; Foundry native agents have it built in, while external agents need only a few lines of initialization code **[00:15:51]**.
- **Foundry hosted (pro-code) agents for enterprise** — Submit code or a container to Foundry for managed execution with enterprise-grade VM isolation, Entra-based agent identity, and long-running operation support **[00:14:09]** [inferred: "Ontree" is Entra ID].
- **Trace-based evaluation loop** — Evaluators (e.g., intent resolution, task adherence) can be attached to traces via the Foundry project client, with failures linking directly back to the trace view **[00:20:11]**.
- **Monitor and Operate tabs for fleet-level visibility** — Live traffic patterns, latency distribution, estimated cost, scheduled evals and red teams, plus active security alerts for malicious URLs and jailbreak attempts **[00:18:19]**.

## Topics covered
- Fragmented telemetry across heterogeneous enterprise agent stacks (different frameworks, clouds, languages, dashboards)
- OpenTelemetry GenAI semantic conventions as a common telemetry schema
- Trace tree views: invoke-agent spans, executed-tool spans, metadata tabs, and replay/user views
- Classic RAG pattern debugging for hallucination and groundedness issues
- Orchestrator routing to city-specialist sub-agents with a fallback agent
- Azure Monitor and Application Insights as the storage and observability backbone
- Production operational metrics: error rate, tool-call success, token usage, cost
- Scheduled evaluations, red teaming, and human evaluator results
- Support for alternative trace formats (OpenInference and OpenTelemetry) to meet customers where they are
- Rubric evaluators and agent optimization (prompt tuning, model swaps, tooling)

## Notable quotes
> "Not by rewriting your agents into one agent framework, but by adopting open telemetry instrumentation with a few lines of code and without changing your existing agent logic."

> "Because all of them are emitting open telemetry traces, Foundry observability was able to stitch together the end to end execution and put everything in one uniform unified trace."

> "Build what you want, run it where you need, and observe it all in one place. Any agent, any cloud, one observability plane." — Hanchi Wang

## Products and tools mentioned
- Microsoft Foundry (portal, playground, Prompt agents, hosted agents)
- Microsoft Agent Framework
- Microsoft OpenTelemetry Distro
- OpenTelemetry (GenAI semantic conventions)
- Google ADK (Agent Development Kit)
- LangGraph [inferred: captioned "land graph"]
- Copilot SDK
- Azure Monitor
- Azure Application Insights
- Google Cloud Platform (GCP) / Cloud Run
- AWS
- Microsoft 365 [inferred: captioned "M-65" / "865"]
- GitHub
- Microsoft Entra ID [inferred: captioned "Ontree"]
- VS Code
- OpenInference

## Speakers featured
- Hanchi Wang — Software engineering manager, Foundry observability team
- Nagkumar Arkalgud — Engineer, Foundry observability team; built the GCP/ADK Bangalore travel agent

## Follow-up resources
- Foundry public documentation
- GitHub repository with the demo agents (shared via on-screen QR code)
- Recordings of other Foundry Build sessions
