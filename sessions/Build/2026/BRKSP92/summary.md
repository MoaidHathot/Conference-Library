<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRKSP92\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRKSP92\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:08.7928626+00:00
-->
# Summary

## Overview
An Intel-hosted session demonstrating that agentic AI now spans client, edge, and cloud rather than living in a single hosted model. Through three live demos, the presenters show on-device inference on an Intel NPU, a pooled cluster of mini PCs serving large models offline, and a CPU-based multi-agent orchestration running on an Azure VM with Xeon processors.

## Key announcements
- **On-device model running on Intel Panther Lake NPU (00:02:16)** — A newly released "Ion 1.0 Instant" [inferred] small model, referenced by Satya Nadella in the keynote, runs entirely on the Core Ultra Series 3 NPU (rated ~50 TOPS) using under 20% of throughput.
- **Resource pooling across three Asus NUC Pro systems** — Colin Helms networked three Intel Core Ultra Series 3 (X7) mini PCs over point-to-point Thunderbolt 4 (20 Gbit) links using llama.cpp RPC to pool roughly 150 GB of VRAM and run models up to ~180 billion parameters.
- **Shared GPU memory override in the Intel graphics driver** — A driver slider allows allocating up to 93% of system RAM as VRAM, yielding 51.3 GB of VRAM on a single 64 GB machine with Arc B390 graphics.
- **Microsoft agent execution containers (announced 00:13:17)** — "MXC" [inferred] sandboxing for Copilot CLI agents, configurable via policy to restrict file-system, network, and MCP server access.
- **CPU-based agentic orchestration on Azure (00:18:08)** — A 96-vCPU, ~200 GB RAM Azure VM on Xeon 6 (with built-in AMX) serves a Qwen3 mixture-of-experts model to an auto-scaling, Kubernetes-hosted coding harness.

## Topics covered
- Cost and latency of cloud token generation versus free local inference
- Aggressive quantization on NPUs to get smaller and faster models simultaneously
- OS-level AI APIs (Windows ML over OpenVINO) removing the need to write NPU code
- Sharding a single model across networked machines via llama.cpp RPC and Vulkan backend
- Pointing Copilot CLI in Visual Studio at local model endpoints through environment variables
- Sandboxing agents with execution containers governed by enterprise policy
- Mixture-of-experts models activating only a fraction of parameters, suiting Xeon AMX matrix multiplication
- Prefill time and time-to-first-token on CPU inference
- Throughput tuning via torch.compile and speculative decoding (draft models) in SGLang and vLLM
- Auto-scaling agent replicas for multi-persona, end-to-end coding workflows against private GitHub repos

## Notable quotes
> "This would run in a hospital on an airplane anywhere where the data does not get to get out of the network and it runs for free for the 10 thousandth time." — Jayneel Vora

> "It's almost cheap enough to put one on every developer's desk and let them work with the larger models before they move on to more enterprise capable solutions." — Colin Helms

> "One of the biggest complaints we hear from a lot of people is my company gives me 5000 tokens a month and I use those in an hour. This is your answer." — Colin Helms

## Products and tools mentioned
- Intel Panther Lake / Intel Core Ultra Series 3 (X7)
- Intel NPU
- Intel Arc B390 graphics
- Intel Xeon 6 with Intel AMX
- Asus NUC Pro
- "Ion 1.0 Instant" on-device model [inferred]
- Windows ML
- OpenVINO
- llama.cpp (RPC, Vulkan backend)
- Copilot CLI / Visual Studio
- Microsoft agent execution containers ("MXC") [inferred]
- MCP servers
- SGLang
- vLLM
- Qwen3 (235B-class MoE and Qwen3 Next 80B A3B) [inferred]
- OpenClaw coding harness [inferred]
- Azure Virtual Machines / Azure Kubernetes Service
- Thunderbolt 4 / USB-4
- LPDDR5X memory
- GitHub CLI

## Speakers featured
- Eddie — Engineer at Intel, session host
- Jayneel Vora — presenter, on-device AI client demo
- Colin Helms — presenter, edge resource-pooling demo
- Imran Sheik Mohamed — presenter, data center and cloud demo

## Follow-up resources
- intel.com — source for the free Intel graphics driver with the shared GPU memory override
