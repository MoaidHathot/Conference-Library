<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP383\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP383\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:42.8121046+00:00
-->
# Summary

## Overview
A live demo from Fireworks AI showing how open-source model inference is integrated as a first-party provider on Microsoft Foundry. The session walks through the full lifecycle of taking an open-source model from testing and evaluation to a production-ready agent, including deployment options, model comparison, evaluation harnesses, and bring-your-own-weights workflows.

## Key announcements
- **Fireworks AI as a first-party Azure/Foundry provider** — Open-source models are accessible day-zero on Foundry with optimized, workload-aware inference served through the Fireworks stack (00:01:08).
- **Multi-tenant serverless and dedicated deployment tiers** — Data Zone Standard offers a shared serverless endpoint for testing, while Global/Data Zone Provisioned Throughput provides single-tenant deployments sized via a PTU calculator (00:04:43).
- **Model comparison playground** — Two models can be run side-by-side on identical input to weigh latency, quality, and token count before saving the winner as an agent (00:07:34).
- **Agent evaluation harness** — Saved agents can be evaluated against custom datasets or open-source benchmarks across metrics like relevance, groundedness, coherence, and task completion, using a judge model (00:08:55).
- **Bring your own weights** — Post-trained or fine-tuned custom models can be registered in Foundry and served through the Fireworks serving stack (00:12:56).

## Topics covered
- High-performance open-source inference at scale (~30 trillion tokens/day, 180,000 requests/second)
- The Fireworks serving stack: workload-aware optimization, adaptive caching, quantization, and hardware selection for latency vs. throughput
- Deploying models on Foundry via the Discover/models catalog
- PTU (provisioned throughput unit) sizing for production workloads
- Testing models in the playground for a code-review use case (catching SQL injection and hard-coded secrets)
- Running evaluations against custom datasets with ground-truth comparison and field mapping
- Publishing agents via web app preview or code snippets (project endpoint with API key for Python workflows)
- Fine-tuning via SFT/RFT frameworks and uploading weights for inference

## Notable quotes
> "We serve around 30 trillion tokens per day and 180,000 requests per second."

> "I want to run the evaluation not against just the model, but my entire agent harness. It might include multiple tool calls or you might have a very detailed system prompt that you've already created the agent with."

> "This is how intuitive and easy it would be to use open source models."

## Products and tools mentioned
- Microsoft Foundry
- Fireworks AI
- FireAttention inference engine [inferred]
- Kimi K2.5 / Kimi K2.6
- MiniMax
- GLM 5.1
- GPT-4o mini (judge model) [inferred]
- Azure
- Python
- PyTorch
- Vertex AI [inferred]

## Speakers featured
- Vignesh Sridhar — Applied AI team, Fireworks AI
