<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK232\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK232\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:01.5184064+00:00
-->
# Summary

## Overview
This advanced session demonstrates how Microsoft Foundry closes the loop between deployment and continuous improvement for open-source reasoning models in agentic workflows. The presenters walk through capturing production traces, curating datasets, and post-training smaller open-source models with supervised fine-tuning (SFT) and reinforcement fine-tuning (RFT) to match frontier-model quality at roughly a tenth of the cost, then redeploying them without managing infrastructure.

## Key announcements
- **Code-first post-training in Foundry [00:23:58]** — A new capability providing a managed workbench/compute instance with VS Code, GPU clusters, and a Ray-based distributed engine so data scientists can bring their own training code for SFT and RFT.
- **Lower-level training API, codenamed "Loom" [00:32:40]** — A higher-level/lower-GPU-construct interface that lets users run RL logic from a laptop CPU while the server manages GPU clusters, images, and networking, exposing four core GPU primitives (forward pass, backward pass, and loss optimization).
- **Foundry Managed Compute [00:36:55]** — A serverless, auto-scaling deployment offering for open-source and custom models that lets users bring their own weights regardless of where they were trained, with support for custom containers, speculative decoding, and draft models.
- **Private preview sign-up** — The new code-first and lower-level API capabilities are entering private preview, with a sign-up link provided at the end of the session.

## Topics covered
- The three stages of model training: pre-training, mid-training, and post-training, and how they differ in data, compute, and parameter scope.
- Token consumption and cost growth in agentic workloads versus chatbots, and using post-training to keep costs flat while maintaining or improving quality.
- Defining success criteria upfront with built-in and custom evaluators rather than only monitoring post-deployment; limitations of published benchmarks.
- Distilling production traces into datasets for fine-tuning.
- Supervised fine-tuning (mimicking expert demonstrations via a loss function) versus reinforcement fine-tuning (rewarding verifiable multi-step trajectories).
- RFT sampling, rollouts, and trajectory grading, with side-by-side inspection of why individual rollouts score higher or lower based on tool-call sequences.
- Ray cluster and node-level observability for training jobs.
- Deploying base and fine-tuned models via provisioned throughput units or managed compute, including GPU-count/context-length tradeoffs.
- Importing externally trained models by specifying the base model architecture (full weight or adapter).
- Adding deployed models to agents for tool calling and state management; post-deployment cost and token monitoring.

## Notable quotes
> "Deploying a model into production is just the beginning." — Chris Lauren

> "Benchmarks are only information that someone else has decided they should publish. It is a good starting point to learn from, but you have to test the models on your own scenarios on your own data." — Chris Lauren

> "Clearly, training models without deploying them is a waste of time." — Chris Lauren

## Products and tools mentioned
- Microsoft Foundry
- Foundry Managed Compute
- Loom (lower-level training API codename)
- GPT-5.2 [inferred]
- Qwen 14B / Qwen 32B (open-source models) [inferred]
- slime [inferred]
- verl [inferred]
- TRL
- Ray
- Fireworks models
- VS Code
- Provisioned Throughput Units

## Speakers featured
- Chris Lauren — product manager (Microsoft Foundry)
- Vijay Aski
- Manoj Bableshwar

## Follow-up resources
- Repository samples published for getting started (referenced in closing; exact URL not stated in transcript).
- Private preview sign-up link for code-first and lower-level API capabilities (referenced at end of session; URL not stated in transcript).
- Session slides available from the standard Build session location.
