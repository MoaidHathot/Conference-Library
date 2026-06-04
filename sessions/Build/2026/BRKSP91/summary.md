<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRKSP91\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRKSP91\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:52.8836952+00:00
-->
# Summary

## Overview
This session makes the case that open-weight models have closed the quality gap with frontier closed models for most enterprise tasks, and that real differentiation comes from fine-tuning on proprietary data. Fireworks AI presents its training-and-inference platform and announces general availability of Fireworks within Microsoft Foundry, illustrated with a Harvey AI case study on legal agents.

## Key announcements
- **General availability of Fireworks AI in Microsoft Foundry [00:15:47]** — Announced during Satya Nadella's keynote the prior day, bringing Fireworks inference deployment to Foundry through one endpoint, one contract, and one platform.
- **Three Foundry integration modes** — Serverless/pay-as-you-go per token, provisioned throughput (PTU) for production workloads, and bring-your-own-weights for custom-trained open-weight models.
- **Fireworks training agent** — A natural-language agent that reformats data, writes evals, selects models, runs hyperparameter grid search, and reports cost upfront; also available headless via a skill file for coding harnesses like GitHub Copilot, Claude, or Cursor.
- **Harvey advisor-agent research published [00:31:26]** — Harvey reported a hybrid system pairing open-weight worker agents (GLM 5.1) with heavier closed advisor models (Claude Opus 4.7) that was roughly 2.4x cheaper and about 30% better on its "all pass" metric.

## Topics covered
- Collapse of the quality gap between open-weight and frontier closed models for enterprise use cases.
- Fine-tuning as the source of competitive differentiation and the continuous training "flywheel."
- LLM inference as a combinatorial optimization problem (speculative decoding, quantization, CUDA kernels, parallelization) with tens of thousands of permutations per model.
- Tiered platform surfaces: training agent (app builders/PMs), managed training (ML engineers), and training API (advanced researchers).
- Training methods: supervised fine-tuning, preference optimization/DPO, reinforcement fine-tuning with graders, and compound/chained training.
- Numerical fidelity between training and serving, GPU orchestration, autoscaling, and custom model "shapes" via the Fire Optimizer.
- Legal Agent Benchmark (LAB): client-matter environments, partner-level instructions, real work-product output, and expert rubric grading across 24 practice areas, 1,200+ tasks, and up to 75,000 rubric criteria.
- Jagged intelligence, inference-time routing across cost/quality Pareto frontier, and security/governance via in-VPC open-weight deployment.

## Notable quotes
> "It's like having an aircraft carrier to point at a bunker as well as to point at an Ant. You don't need that." — Vivek Chauhan

> "A model might be really strong at transactional work like corporate M&A, financial due diligence, but poor at litigation work like case law, research, writing intensive tasks." — Nico Grupin

> "I can't tell you how relieving it is to me now and how much better I sleep at night knowing that we don't have to go figure this all out ourselves." — Nico Grupin

## Products and tools mentioned
- Microsoft Foundry (Azure Foundry)
- Fireworks AI platform (inference engine, Fire Optimizer, training agent, managed training, training API)
- GLM 5.1
- Kimi [inferred]
- GPT 120B
- DeepSeek V4 [inferred]
- Claude Opus 4.7
- Claude Sonnet 4.6
- Weights & Biases
- GitHub Copilot, Claude, Cursor (coding harnesses)
- Harvey AI / Legal Agent Benchmark (LAB)

## Speakers featured
- Vivek Chauhan — Fireworks AI presenter
- Jetashree Ravi ("Jed") — co-presenter (Fireworks/Foundry integration)
- Nico Grupin — Head of Applied Research, Harvey AI (guest)
