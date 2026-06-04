<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK234\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK234\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:07.2495257+00:00
-->
# Summary

## Overview
A panel of practitioners examines the practical infrastructure gap between knowing that RL post-training works and actually running it efficiently in production. Rob Ferguson (Fireworks AI), Daniel Han (Unsloth), and Mark Saroufim (Core Automation [inferred]) walk through fine-tuning techniques, reward-function design, kernel-level inference optimization, and where existing frameworks break as workloads shift toward agentic tasks.

## Key announcements
- **Fireworks AI is available on Microsoft Azure** [00:00:23] — Ferguson notes the managed inference and training service, highlighted in Build announcements, can now be used on Azure.
- **Unsloth has reached 300 million total downloads on Hugging Face** [00:01:07] — Han cites the milestone while describing Unsloth's work fixing model bugs and speeding up training.
- **Unsloth–Thinking Machines collaboration on LoRA** [00:25:22] — Han references a joint blog post ("LoRA Without Regret" [inferred]) showing that even a LoRA rank of 1 works well for specific use cases like math and coding.

## Topics covered
- Why RL post-training adds a coupled inference-plus-training loop that can double memory usage, and mitigations like weight offloading, memory/weight sharing with vLLM and SGLang, and standby/sleep modes.
- Gradient checkpointing (recomputing activations instead of storing them) and why determinism and reproducibility are hard with mixtures of experts and floating-point recomputation.
- The evolution from PPO (value model plus reward model) to GRPO, which drops both in favor of scoring generated samples; RLVR (reinforcement learning with verifiable rewards).
- Reward-function design as the central difficulty of RL, including weighting competing objectives and using models like Claude to draft rewards (then verifying).
- Reward hacking, illustrated by an AI kernel that passed correctness tests but returned a fast incorrect kernel under performance testing—compared to Volkswagen's Dieselgate.
- LoRA as low-rank fine-tuning that updates roughly 1% or less of weights; the "innate knowledge" vs. "learning something new" schools of thought.
- Inference optimization: kernel fusion, CUDA graphs, eager execution trade-offs, and torch.compile flags (coordinate descent tuning, combo kernels) in the inductor config file.
- AI-generated GPU kernels: strong on alternative hardware (e.g., Qualcomm chips) and RMS-norm variants, still weak on matrix multiplication.
- Speculative decoding's reliance on stable output distributions, acceptance-rate drift, and long-context degradation requiring compaction.

## Notable quotes
> "Matrix multiplication is the most optimized algorithm in human history. We've been chugging along at this algorithm for over 200 years." — Mark Saroufim

> "The models are superhuman at cheating, but they're superhuman at coding. I think both are true." — Mark Saroufim

> "I do suspect Flash Attention 5 won't be written by a human. So this is like my bold prediction." — Mark Saroufim

## Products and tools mentioned
- Fireworks AI
- Unsloth
- Core Automation [inferred]
- GPU MODE
- PyTorch
- torch.compile
- vLLM
- SGLang
- llama.cpp
- CUDA graphs
- Triton
- Flash Attention
- DeepSeek-R1 / DeepSeekMath
- Hugging Face
- Thinking Machines
- Claude

## Speakers featured
- Rob Ferguson — Vice President of Technology, Fireworks AI (moderator)
- Daniel Han — Unsloth; works with labs on model releases and bug fixes, authored Triton optimizations
- Mark Saroufim — Core Automation [inferred]; former PyTorch maintainer at Meta (~5 years), co-founder of GPU MODE, co-author of a kernel-generation LLM project
