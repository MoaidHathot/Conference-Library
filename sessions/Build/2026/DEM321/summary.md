<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM321\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM321\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:32.1355373+00:00
-->
# Summary

## Overview
A demo-driven walkthrough of using Microsoft Foundry to post-train smaller open source reasoning models as a cost-efficient alternative to frontier models in production agents. The session emphasizes defining evaluations upfront, capturing production traces as training data, and applying supervised and reinforcement fine-tuning to improve tool-calling accuracy and token efficiency. Technical difficulties prevented the live demo, so portions were presented via slides.

## Key announcements
- **Foundry now supports customizing agents with any open source framework and model** *(00:03:04)* — Beyond creating and deploying agents, Foundry enables fine-tuning open source models to reach a production-ready quality bar.
- **Automatic trace capture and conversion to training datasets** *(00:05:38)* — Every session and interaction is captured with observability into cost and reproducibility, and these production traces can be converted directly into datasets for subsequent reinforcement learning.
- **Native integration with Ray dashboards and a rollout browser** *(00:09:47)* — Fine-tuning jobs integrate with Ray clusters managed in Foundry through an AAD-authenticated endpoint, allowing monitoring of CPU/GPU nodes, jobs, and RFT rollouts.

## Topics covered
- Cost and token-consumption differences between agentic and chat scenarios, and why scaling agents increases cost and latency.
- Eval-first development as "test-driven development for the age of agents," defining quality bars independent of the underlying model.
- Tool-calling order, policy adherence, and call rate as factors affecting agent quality and latency.
- Post-training as an umbrella term spanning data preparation (custom data, agent traces, distillation from larger models, synthetic data), with data prep consuming up to 80% of effort.
- The distinction between supervised fine-tuning (SFT), which teaches a model to imitate provided data, and reinforcement fine-tuning (RFT), which rewards verifiable steps on a zero-to-one scale.
- A distillation → SFT → RFT workflow using GRPO and custom code.
- Inspecting RFT trajectories to reward or penalize specific tool calls per sample.

## Notable quotes
> "By defining your evals, you can specify what is good, what your policies are, how the agent should behave, which tools should be called when, and all of this can be done in a consistent and repeatable way regardless of which models you're using in the agent." — Chris Lauren

> "RFT is the one that's saying here are the verifiable steps. As long as you make sure that every single one of the steps that you follow and you get the task done... that's what you reward." — Vijay Aski

> "This model can operate at [one-tenth] the cost of GPT 5.2. It's a small, very efficient model." — Chris Lauren

## Products and tools mentioned
- Microsoft Foundry
- GPT-5.2
- Qwen3-14B [inferred]
- Ray (dashboards and clusters)
- GRPO
- Microsoft Entra ID / AAD authentication

## Speakers featured
- Chris Lauren
- Vijay Aski
