<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK230\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK230\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:50.9248723+00:00
-->
# Summary

## Overview
This advanced session demonstrates how to build resilient AI systems in Microsoft Foundry by treating model choice as an ongoing, evaluation-driven systems decision rather than a one-time pick. Using a worked travel-planning agent, the speakers walk through a four-stage loop—selection, evaluation, optimization, and scaling—anchored by the concept of "hill climbing" against defined success criteria.

## Key announcements
- **Claude on Azure** — Anthropic's Claude (including Opus 4.8 [inferred], launched the prior week) is now running natively on Azure on GB300 hardware [00:06:59].
- **Microsoft first-party models live in Foundry** — New MAI models, including MAI-Image 2.5 [inferred], went live during the morning keynote, spanning image, code, and audio for a full multimodal stack [00:07:38].
- **Aurora 1.5** — A geospatial weather-modeling system using satellite imagery and atmospheric data that scales beyond traditional models [00:10:10].
- **Expanded NVIDIA partnership** — Adding Nemotron [inferred] reasoning models, Cosmos for physical AI, and Earth-2 weather models [00:10:30].
- **Model router governance** — The Foundry model router now supports 28 models (GPT-5.4, GPT-5.5 family, Claude Opus) with automatic failover, and as of today supports policy governance over which models it may select [00:18:54].
- **Rubric-based evaluators** — A new evaluator type that auto-generates weighted, multi-dimension scoring rubrics from an agent's definition and trajectories [00:24:50].
- **Explicit prompt caching / Azure context cache** — A customer-owned cache for guaranteed performance and better privacy, in private preview today [00:31:08].
- **Serverless reinforcement fine-tuning API** — Launching at Build, giving control over rewards and hyperparameters while Foundry manages infrastructure [00:38:11].
- **Fireworks general availability** — GA partnership providing zero-day access to optimized frontier models with native Azure integration [00:39:26].

## Topics covered
- Decomposing an agentic workflow into discrete jobs and assigning a right-sized model to each (a "microservices" approach to model selection)
- Establishing a quality/cost/latency baseline and improving iteratively toward a target score
- Model routing via the built-in Foundry router versus building a custom router with a small model (GPT-4.1 nano, Mistral Small)
- Evaluation as product spec and IP: built-in, agentic, risk/safety, custom prompt/code, and rubric-based evaluators
- Custom domain evaluators for policy compliance (company travel policy adherence)
- Cost optimization levers: workload routing, batch inference, async jobs, structured outputs, caching, distillation
- Latency engineering: faster-model routing, PTU reserved capacity, priority processing, streaming, API gateways
- Quality progression from prompt design to grounding, fine-tuning/distillation, and custom model training
- Post-training tiers: managed fine-tuning (SFT, DPO, RL), serverless RL API, and full-control RL with frameworks like slime and veRL [inferred]
- Deploying customized and open models via Foundry managed compute and Hugging Face, with runtimes such as vLLM and SGLang [inferred]
- Production observability: tracing, evaluation, and monitoring through Azure Monitor

## Notable quotes
> "We used a Ferrari for a grocery run."

> "Evaluate on your workload, not the beautiful benchmarks that are out there."

> "Long gone are the days of just prompt engineering. Make sure you're building the system, not just a prompt."

## Products and tools mentioned
- Microsoft Foundry (portal, model catalog, leaderboard, Foundry Labs)
- Foundry IQ, Work IQ, Fabric IQ, Web IQ
- GitHub Copilot CLI
- Foundry model router
- Azure context cache / explicit prompt caching
- Foundry managed compute and developer tier
- Azure Monitor
- Claude / Claude Opus 4.8 [inferred]
- GPT-4.1, GPT-4.1 nano, GPT-5.4, GPT-5.5 family
- MAI-Image 2.5 [inferred]
- Aurora 1.5
- NVIDIA Nemotron [inferred], Cosmos, Earth-2
- Mistral Small
- Hugging Face models, NVIDIA, Microsoft Research models
- Fireworks AI
- vLLM, SGLang [inferred]; slime, veRL [inferred]
- Microsoft 365 (governance)
- Discord community

## Speakers featured
- Yina Arenas — Product lead, Microsoft Foundry
- Naomi Moneypenny — Leads model shipping in Microsoft Foundry
- Sharmila Chockalingam

## Follow-up resources
- foundry.ai.azure.com — start building (referenced as foundryai.azure.com)
- An aka.ms link and GitHub repository with all session demo code (URL not specified in transcript)
- Foundry Discord community
