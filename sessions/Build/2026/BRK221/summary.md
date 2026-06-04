<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK221\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK221\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:30.4171596+00:00
-->
# Summary

## Overview
This session argues that most failures of agentic applications stem from the runtime, not the model, and positions Azure Container Apps sandboxes as an AI-native execution layer addressing isolation, cold starts, state persistence, and cost control. Through a live multi-agent voice demo and a customer story from Auger, it shows how to move from idea to production-ready agents in seconds.

## Key announcements
- **Azure Container Apps Sandboxes enter public preview** — Fast, isolated, stateful on-demand compute that executes untrusted workloads securely by default and resumes near-instantly while preserving disk and memory state (~00:16:17, ~00:40:59).
- **Sub-second cold start and resume** — Sandboxes wake from sleep in roughly a second or two, retaining running scripts and context to avoid the environment setup tax (~00:17:38).
- **Sandbox groups with inherited connectors, volumes, snapshots, and disk images** — Settings such as credentials and connectors propagate automatically to sandboxes created within a group (~00:16:54).
- **Layer 7 firewall and network isolation per sandbox** — Operators can control which hosts and routes are allowed or denied for each agent (~00:20:21).
- **Snapshotting and instant restore** — An entire sandbox disk can be snapshotted and used to spin up an exact new instance (~00:22:22).
- **Serverless GPUs for custom model inference** — T4 and A100 GPUs scale to zero across 15 regions, used in the demo to run speech-to-text and text-to-speech models (~00:14:42).
- **Azure Container Apps Express** — An environment-less, fast deployment target for web apps and APIs, built on the same sandbox foundation, launched roughly a month prior (~00:26:52, ~00:43:33).

## Topics covered
- Why agentic workloads fail in production: budget burn from runaway loops, untrusted code on dev machines, cold-start throttling, lost workspace state, and brittle glue code between runtimes.
- Five runtime requirements: fast start/resume, native tool-calling execution, persistent state, strong per-task isolation, and runtime-level governance.
- Architecture of a multi-agent voice application: a multi-agent broker, proxy bridges, and a Twilio call gateway on Azure Container Apps.
- Sandbox lifecycle operations: sleep/resume with memory capture, template-based creation, port exposure, and snapshot-based cloning.
- Six emerging sandbox patterns: multi-tenancy, platform-for-execution, agent workflows, AI code execution, platform building, and interactive user sessions.
- Auger's autonomous supply chain: agentic data integration, the OSCO world model, the connecting "bus," and real-time what-if simulation pipelines.

## Notable quotes
> "It's not because of the models, it's because of what you're running, where you're running, how you're running." — Devanshi Joshi

> "It is an agent first platform for agents to use." — Simon Jakesch

> "We basically have like closed on like publicly to customers today... we have 40 plus services that are literally running on Azure Container Apps and we have thousands of agents that are running on top of it." — Gopi Prashanth

## Products and tools mentioned
- Azure Container Apps
- Azure Container Apps Sandboxes
- Azure Container Apps Express
- Azure Serverless GPUs (T4, A100)
- Azure SRE Agent
- Azure AI Foundry (Foundry Hosted Agent service)
- GitHub Copilot CLI
- GitHub Copilot Cloud Sandboxes
- Whisper (speech-to-text) [inferred]
- Twilio
- Voice Live API
- Azure Container Registry
- Azure Log Analytics
- Snowflake
- Hugging Face
- vLLM [inferred]

## Speakers featured
- Devanshi Joshi — Product Marketing Manager, Azure Container Apps
- Simon Jakesch — Microsoft product team
- Gopi Prashanth — Auger (customer)

## Follow-up resources
- Azure Container Apps product blog (with samples)
- Demo code repository (released by the team)
- Sandboxes portal: aka.ms/ACA-sandboxes [inferred]
