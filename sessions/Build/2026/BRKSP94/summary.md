<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRKSP94\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRKSP94\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:03.0672644+00:00
-->
# Summary

## Overview
NVIDIA's Nemotron team presents a tiered "system-of-models" approach to enterprise agentic AI, anchored by the newly announced Nemotron 3 Ultra open reasoning model and the Hermes agent harness. The session pairs an overview of NVIDIA's open-model strategy with a live demonstration of running these agents inside Microsoft Foundry hosted agents, governed through Microsoft Entra ID.

## Key announcements
- **Nemotron 3 Ultra, NVIDIA's largest and most capable open model** — Announced Sunday with 550 billion total / 55 billion active parameters, targeting frontier reasoning and orchestration; general availability stated for Tuesday (08:07).
- **Multi-teacher on-policy distillation** — Knowledge from multiple task-specialized teacher models is distilled into Nemotron 3 Ultra to consolidate capabilities (00:09:11).
- **Unified NVFP4 [inferred] checkpoint** — A single downloadable checkpoint runs in NVFP4 on Blackwell and falls back to run on Hopper, eliminating separate per-precision files (00:10:00).
- **Roughly 5x faster inference at frontier accuracy** — Per third-party artificial analysis benchmarks, Nemotron 3 Ultra reaches frontier-level accuracy with about 5x faster inference speed versus the March release (00:14:05).
- **Foundry hosted agents demo** — Hermes Agent on Nemotron 3 Super completes a real email-to-pull-request task and retains a learned skill across separate sessions and services (00:22:07).

## Topics covered
- The progression from large language models to reasoning models to agents, and the reason-act agent loop (context, plan, act, memory, orchestration).
- The "system of models" thesis: enterprises need multiple specialized models of varying sizes, modalities, and deployment locations.
- The Nemotron family pillars: reasoning, vision, information retrieval (embedding and re-ranking), safety/content moderation, and speech.
- The three reasoning model sizes mapped to GPU footprint: Nano (MoE, ~30B/3B active), Super, and Ultra.
- Architectural features: hybrid MoE, latent MoE for long context, multi-token prediction, and 1,000,000-token context length.
- Agentic benchmarks including tool-use productivity, long-horizon planning (ServiceNow Enterprise Ops Gym), coding, instruction following, and knowledge work.
- A cost-per-task Pareto "cost-efficient frontier" using CoreWeave and DeepInfra pricing.
- Foundry hosted agents: bring-your-own-container/harness, isolated sessions, agent identity via Entra ID, the Foundry managed toolbox, observability/audit traces, OAuth pass-through, and publishing agents to Microsoft 365 (Teams).
- Hermes self-learning skills: corrections captured as reusable skills, curated and generalized across a company.

## Notable quotes
> "Every method captured by 1 lifts the rest of the team across the company. Every colleague's improvement makes everyone's work better. That's the power of Hermes."

> "I'm talking to this agent in the same way that I might talk to a colleague." — Stephen McCullough

> "The agent now has an identity that can be retrieved and managed and governed across your company." — Stephen McCullough

## Products and tools mentioned
- NVIDIA Nemotron 3 Ultra
- NVIDIA Nemotron 3 Super
- NVIDIA Nemotron Nano
- Hermes Agent (Nous Research)
- Microsoft Foundry hosted agents / Foundry Agent Service
- Foundry managed compute endpoints
- Foundry managed toolbox
- Microsoft Entra ID
- Microsoft 365 / Microsoft Teams
- Microsoft Outlook
- GitHub
- NVIDIA CUDA
- NVIDIA Blackwell, Hopper, and Ampere GPUs; B200, H100 [inferred]
- NVFP4 precision format [inferred]
- Nemo Gym [inferred] (RL environments and skills)
- OpenCode and other open agent harnesses [inferred]
- Artificial Analysis (third-party benchmarking)
- CoreWeave, DeepInfra (pricing references)
- ServiceNow Enterprise Ops Gym
- Azure Blob Storage, MongoDB, Cosmos DB
- Comparison models: GLM [inferred], Kimi K2 [inferred], Qwen [inferred]

## Speakers featured
- Joey Conway — NVIDIA (Nemotron open model family)
- Stephen McCullough — AI Solutions Architect, NVIDIA
- AYSEN Ilkbahar — listed in session metadata

## Follow-up resources
- In-person demo and experts at the NVIDIA booth in the 308 space.
- NVIDIA open models, Nemo skills, and research available online.
- Session survey via on-screen QR code.
