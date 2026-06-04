<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK231\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK231\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:54.5757845+00:00
-->
# Summary

## Overview
A demonstration of how Microsoft Foundry's model customization tools — distillation, supervised fine-tuning, reinforcement fine-tuning, and a new low-level training API — let teams turn production agent traces into cheaper, faster, and smarter models. Using a retail refund-processing customer service agent as a running example, the presenters climb an evaluation leaderboard from base models through to a fine-tuned open-source model that beats a frontier teacher.

## Key announcements
- **Interactive low-level training API (preview)** — Described as "PyTorch as a service" [00:01:26], it exposes training primitives (forward/backward pass, sampling, loss computation, grader and algorithm control) while Foundry manages the GPU compute.
- **Developer tier training** — A spot/low-priority SKU offering training at 50% off standard-tier cost, with the median supervised fine-tuning job costing about a dollar [00:18:21].
- **Data zone SKU** — Introduced at Build for residency guarantees in the US [00:18:37].
- **Developer tier hosting** — Hosting with no hosting fee to make experimentation cheaper [00:46:47].
- **Fine-tuning skill for coding agents** — A skill, available in GitHub Copilot for Azure or as a standalone download, that lets users describe fine-tuning goals in natural language and runs an autopilot flow that picks models, graders, and hyperparameters [00:41:16].

## Topics covered
- The cost pressure of agents, which consume 20–30x more tokens per turn than chat interactions.
- Fine-tuning as a shortcut into the foundation-model build process (pre-training, instruction tuning, alignment tuning).
- Distillation: capturing a large model's traces to train a smaller, cheaper model.
- Building evaluation graders in Foundry — out-of-the-box LLM graders (task/intent resolution) and custom Python graders with weighted scoring.
- Converting raw agent traces into datasets with deduplication and PII redaction.
- Reinforcement fine-tuning: rollouts, grader-driven rewards, and tool invocation during training.
- Reward hacking detection via telemetry (tool-calls-per-rollout, KL divergence, entropy, grad norm).
- The contrast between managed fine-tuning and the new interactive training API, including GRPO, curriculum learning, and alternatives like PPO/DPO.

## Notable quotes
> "Fine tuning is really just your cheat code to building a foundation model." — Alicia Frame

> "You're really never going to get smarter than your teacher... that's where reinforcement learning comes in." — Alicia Frame

> "The more effort you put in, the more value you get." — Omkar More

## Products and tools mentioned
- Microsoft Foundry
- GPT-5.4 [inferred]
- GPT-4.1 mini and GPT-4.1 nano
- o4-mini
- GPT-3.5 Turbo
- Qwen3 32B [inferred]
- Semantic Kernel
- LangGraph [inferred]
- Azure Functions / function app
- MCP servers
- GitHub Copilot for Azure
- Copilot CLI / Claude
- vLLM [inferred]
- Azure Virtual Machines

## Speakers featured
- Alicia Frame — Product lead, model customization
- Omkar More — Engineering counterpart, model customization
- Long Chen

## Follow-up resources
- Sample notebooks repository for the demos shown (referenced on the closing resources slide [00:47:13]).
- Sign-up for the preview of the training API (referenced on the closing resources slide).
- Three hands-on labs running the following day covering the demo example and reinforcement learning.
