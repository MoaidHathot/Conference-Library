<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM321-R1\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM321-R1\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:33.9883283+00:00
-->
# Summary

## Overview

This intermediate demo session shows how Microsoft Foundry supports post-training open source reasoning models—via supervised fine-tuning (SFT) and reinforcement fine-tuning (RFT)—to run agents at a fraction of frontier-model cost. The presenters argue that defining evaluations upfront and customizing smaller open source models on business-specific data yields better token efficiency, tool-calling accuracy, and lower latency than relying on prompt-tuned frontier models. A planned live demo was largely cut short by equipment problems, leaving much of the walkthrough delivered via slides.

## Key announcements

- **Foundry now supports customizing agents with any open source framework or model** [00:03:04] — Beyond creating and deploying agents, Foundry enables fine-tuning open source models to reach production-quality bars.
- **Automatic trace capture and observability** [00:05:38] — Every session and interaction is automatically captured, including cost and reproducibility data, viewable at the level of individual session traces.
- **Converting production traces into training datasets** [00:06:30] — Traces from models and agents in production can be automatically converted into datasets for subsequent reinforcement learning runs.
- **Native Ray dashboard integration and a rollout browser** [00:09:47] — Foundry offers an AAD-authenticated endpoint to manage an entire Ray cluster (CPU and GPU nodes), monitor jobs, and inspect RFT trajectories and rollouts.

## Topics covered

- Cost and token-consumption differences between agentic and chat workloads at production scale.
- Evaluation-first development ("test-driven development for the age of agents") to define quality bars independent of the underlying model.
- Tool-calling order, policy adherence, and call rate as drivers of agent quality and latency.
- Post-training as an umbrella covering data preparation (custom data, agent traces, distillation, synthetic data), SFT, and RFT.
- The distinction between SFT (imitating provided examples) and RFT (rewarding verifiable steps with a zero-to-one reward signal).
- Using GRPO with custom code and bring-your-own-model on managed Ray clusters.
- Inspecting RFT trajectories to reward or penalize specific tool calls per sample.

## Notable quotes

> "By defining your evals, you can specify what is good, what your policies are, how the agent should behave, which tools should be called when, and all of this can be done in a consistent and repeatable way regardless of which models you're using." — Chris Lauren

> "RFT is the one that's saying here are the verifiable steps. As long as you make sure that every single one of the steps that you follow and you get the task done... that's what you reward." — Vijay Aski

> "This model can operate at one tenth the cost of GPT 5.2. It's a small, very efficient model." — Chris Lauren

## Products and tools mentioned

- Microsoft Foundry
- GPT-5.2
- Qwen3 14B [inferred]
- Ray (dashboards, cluster management)
- GRPO
- Microsoft Entra ID (AAD) authentication

## Speakers featured

- Vijay Aski
- Chris Lauren
