<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK222\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK222\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:38.4746553+00:00
-->
# Summary

## Overview
A practitioner-oriented walkthrough of running agentic AI workloads on Kubernetes and Azure Kubernetes Service (AKS), arguing that inference, training, and agent orchestration are three distinct workload types that Kubernetes can host but only with additional layers on top. The session frames the trade-off between fully managed AI platforms and a composable, self-managed Kubernetes substrate, then walks a four-layer stack with live demos and customer examples.

## Key announcements
- **Anyscale on Azure (managed Ray) public preview** — Around 00:25:11, an Azure-native, Entra ID-integrated managed Ray runtime that runs inside the customer's AKS subscription with unified Azure billing, keeping data and model weights in-tenant.
- **Agent reference stack for Kubernetes ("CARS")** — Around 00:38:19, released the same day; a vertically integrated secure sandbox for agents using workload identity policies and Azure Linux under the hood, deployable with a single `cars up` command.
- **AKS Automatic with managed system node pools (GA)** — Around 00:42:54, Azure now manages and scales the Kubernetes system components so they don't consume GPU nodes reserved for AI workloads.
- **Azure Linux container host (GA)** — Around 00:43:32, a hardened OS with smaller attack surface, fewer CVEs, signed artifacts, and predictable patching, runnable in containers, on VMs, or in WSL.
- **AKS on bare metal (public preview)** — Around 00:44:19, direct hardware access with no hypervisor, avoiding the virtualization tax for GPUs, NICs, and accelerators on-premises.
- **Fleet for Arc-enabled clusters** — Around 00:44:58, progressive rollouts, intelligent workload placement, and consistent policy enforcement across on-prem and edge clusters under one Azure control plane.

## Topics covered
- Trade-offs between managed AI platforms (e.g. Microsoft Foundry) and composable Kubernetes substrates: control, open tooling, data sovereignty, unit economics, and operational complexity.
- The three distinct AI workload profiles—inference (millisecond latency, often single-node), training (throughput-bound, checkpoint-sensitive), and agentic systems (stateful, multimodal, tool-calling).
- Gaps Kubernetes must close for AI: gang scheduling and queuing, heterogeneous hardware and topology awareness, scaling on AI signals (tokens/sec, queue depth, GPU utilization), and durable state.
- Inference and serving with AI Runway (platform layer with model catalog and GPU-fit indicator) and Kaito/KAITO (operations layer with presets and KV-cache-aware routing).
- Training and fine-tuning with Ray, including fractional GPU allocation and a product-catalog embedding fine-tune demo.
- Agentic orchestration with skills, MCP (including the AKS MCP server), and OpenClaw, plus namespace isolation and service mesh for security.
- Day-2 operations encoded as agents (AKS Claw) for on-call support engineers.

## Notable quotes
> "Kubernetes is a big hammer, and with a big hammer, everything looks like a nail. Kubernetes isn't always the right fit, but in some cases it is the right fit."

> "Ralph went through that in 3 minutes. What used to take me 3 weeks to get up and running."

> "So super powerful platform and in only 7 minutes that took me 3 months to do."

## Products and tools mentioned
- Azure Kubernetes Service (AKS)
- Microsoft Foundry
- AI Runway
- Kaito (Kubernetes AI Toolchain Operator)
- vLLM, SGLang, TensorRT, llama.cpp
- NVIDIA Dynamo, KubeRay, llm-d
- Ray / Anyscale on Azure
- Hugging Face
- DeepSeek-R1, Qwen, Phi, Llama [inferred]
- Azure Managed Lustre
- Gateway API inference extension, Istio
- Model Context Protocol (MCP), AKS MCP server
- OpenClaw
- CARS (agent reference stack for Kubernetes)
- Azure Linux
- Headlamp
- AKS Automatic, AKS on bare metal, Fleet for Arc-enabled clusters
- Entra ID, Azure Key Vault, Azure Container Registry (ACR)
- AKS Claw
- Dapr [inferred]

## Speakers featured
- Lachlan "Lachie" Evenson — presenter, longtime Kubernetes practitioner (10+ years)
- Ralph — colleague, narrator of the AI Runway demo (referenced, not presenting live)
- Bob — colleague who assisted with the Anyscale on Azure demo

## Follow-up resources
- The referenced open-source tools (AI Runway, Kaito, CARS, Headlamp) were described as available on GitHub, though no specific URLs were given in the transcript.
