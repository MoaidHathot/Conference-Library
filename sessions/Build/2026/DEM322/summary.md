<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM322\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM322\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:33.8204139+00:00
-->
# Summary

## Overview
This foundational demo from the Foundry Fine Tuning team shows how enterprises can distill expensive frontier models into small, task-specific models using supervised fine-tuning on real agent traces. The core argument is that production agents consume enormous token volumes, and distillation turns intelligence from a "luxury" into an affordable utility by teaching a cheap student model to imitate a costly teacher's tool-calling behavior and reasoning trajectory.

## Key announcements
- **End-to-end distillation workflow in Azure AI Foundry** — Foundry automatically collects agent traces, converts them into supervised fine-tuning datasets, and launches tuning jobs from within the portal **[00:14:50]**.
- **One-click "Create dataset" from traces** — Under the trace view, collected production traces (roughly 1,000 in the demo) can be ported directly into a supervised fine-tuning dataset and a tuning run started on GPT-4.1 nano [inferred] **[00:14:54]**.
- **Demonstrated student performance lift** — After fine-tuning on teacher-generated traces, the small student model closed much of the gap to the teacher, sometimes matching it, validated on a 20-task holdout set **[00:11:53]**.

## Topics covered
- Distillation framed as an "apprenticeship" between a large teacher model and a small student model.
- Why agent traces are valuable training data: real user questions, tool-call sequences, argument values, and correct solution trajectories.
- The four wins of distillation: lower cost, faster responses, near-teacher quality on narrow tasks, and more consistent behavior.
- Designing evaluations across four dimensions: decision correctness, tool trajectory, financial accuracy, and communication.
- The pass@k metric for measuring consistency across repeated attempts (teacher, student, fine-tuned student run three times each).
- Real-world failure cases corrected by fine-tuning: approving false refunds under customer pressure, skipping mandatory policy checks, mishandling final-sale defect claims, and acting on out-of-scope requests.

## Notable quotes
> "The question is not just whether my agent works, it is about whether I can afford to run my agent 100 million times."

> "Model distillation is like an apprenticeship between two models. You start with a large capable model... the teacher that solved real tasks. You collect many examples of how the teacher behaved... and use that data to train a smaller, cheaper model."

> "Getting the right answer doesn't usually get you the full score, because you can get the right answer but with the wrong method."

## Products and tools mentioned
- Azure AI Foundry
- Foundry Fine Tuning (supervised fine-tuning)
- GPT-4.1 nano [inferred] (student model)
- GPT-5.5 [inferred] (teacher model)

## Speakers featured
- William Liang — Foundry Fine Tuning team, Microsoft
