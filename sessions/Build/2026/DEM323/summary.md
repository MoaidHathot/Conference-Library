<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM323\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM323\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:40.5673602+00:00
-->
# Summary

## Overview
A 25-minute technical deep dive from Microsoft AI (MAI) into the seven models announced earlier the same day at the keynote, spanning image, transcription, voice, coding, and reasoning. The session centers on MAI Thinking 1, the lab's first frontier reasoning model, walking through its architecture, training data, and reinforcement learning system, and closes with Microsoft Frontier Tuning for customizing models inside a customer's own environment.

## Key announcements
- **Seven new MAI models across image, transcription, voice, coding, and thinking** — Announced at the morning keynote and detailed here model by model (00:01:04).
- **Image 2.5** — Image generation and editing model ranked #2 for image-to-image on the LMArena [inferred] leaderboard, surpassing Nano Banana, with a Flash variant delivering production quality at roughly a third of the cost (00:04:15).
- **Transcribe 1.5** — Described as the world's most accurate transcription model across 43 languages and up to 5x faster than rival models (00:07:33).
- **Voice 2** — Most natural-sounding speech model yet, preferred in 72% of blind listening tests, with fine-grained emotional control, voice cloning from a few seconds of audio, and a sub-150ms Flash variant for voice agents (00:05:25).
- **Code 1 Flash** — Efficient agentic coding model with ~5 billion active parameters, scoring 71.6 on SWE-bench Verified and 51.2 on SWE-bench Pro, shipping as default in GitHub Copilot inside VS Code (00:01:59).
- **MAI Thinking 1** — First Microsoft reasoning model: mixture-of-experts, 35 billion active parameters, ~1 trillion total, 256K context, hill-climbed from scratch with no distillation (00:09:09).
- **100+ page technical report** — Published on the MAI website detailing how Thinking 1 was built (00:09:53).
- **Microsoft Frontier Tuning** — Lets developers and organizations tune models on their own data inside their secure tenant, deploying through Foundry or Copilot (00:14:19).

## Topics covered
- Humanist Superintelligence philosophy and its three implications: no distillation, hill climbing from scratch, full transparency and control over data lineage.
- Thinking 1 data strategy: 30 trillion in-house tokens plus 3.55 trillion mid-training STEM/math/coding tokens; no open-source training sets, no synthetic data, decontaminated benchmarks.
- Reinforcement learning climb using GRPO with binary rewards for math and code, plus five stability innovations across thousands of steps.
- Training three specialist models (STEM, agentic, helpfulness/safety) and merging them.
- Dedicated safety RL climb, 15 rounds of red teaming, and 2,100+ adversarial scenarios.
- Benchmark results: AIME 2025 at 97, AIME 2026 at 94.5, LiveCodeBench 87.7, SWE-bench Pro 52.8, GPQA Diamond 84.2.
- Frontier Tuning workflow and the Land O'Lakes [inferred] tasting-panel quality-report case study (89.3% quality, 10x more cost efficient).

## Notable quotes
> "The most important: we don't distill. Distillation can produce fast gains... but it makes the teacher's capability the practical ceiling for the student." — Dave Citron

> "Safety isn't a filter bolted on at the end for this model. It's an entire dedicated RL climb with a reward model trained on human preference data. You cannot trade safety for helpfulness." — Dave Citron

> "That's a tuned model beating the best generalists on a real business workflow at a fraction of the cost." — Dave Citron

## Products and tools mentioned
- MAI Image 2.5 (and Image 2.5 Flash)
- MAI Transcribe 1.5
- MAI Voice 2 (and Voice 2 Flash)
- MAI Code 1 Flash
- MAI Thinking 1 (and Thinking 1 Flash)
- Microsoft Frontier Tuning
- Microsoft Foundry
- MAI Playground
- GitHub Copilot
- VS Code
- Microsoft 365
- Azure
- Microsoft Fabric
- Baseten [inferred], OpenRouter, Fireworks

## Speakers featured
- Dave Citron — Corporate Vice President of Products, Microsoft AI

## Follow-up resources
- MAI Playground website (also accessible on mobile)
- Microsoft Foundry website (model access and Thinking 1 private preview sign-up)
- Microsoft.AI (model cards, API documentation, pricing)
- MAI technical report (100+ pages, on the MAI website)
