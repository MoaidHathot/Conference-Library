<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\KEY01\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\KEY01\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T11:27:18.9716648+00:00
-->
# Summary

## Overview
Satya Nadella frames Microsoft Build around a single thesis: the opportunity is not any one model or platform but full participation in a "Frontier intelligence ecosystem" that spans edge devices, cloud infrastructure, an intelligence/context layer, agent runtimes, tooling, and security. The keynote walks the full AI stack—from on-device "unmetered intelligence" on Windows through Azure's AI super-factories, Foundry, agent governance, and new MAI models—closing with scientific discovery and quantum progress.

## Key announcements
- **Expanded Windows ML and two new local models** [00:04:40] — Aion Instruct (an efficient reasoning SLM) and Aion Plan (a local agentic planning loop) run inbox on Windows across the full GPU install base, enabling onboard agents without cloud round trips.
- **Surface RTX Spark Dev Box** [00:08:06] — A developer "dream machine" with one petaflop of AI compute, 20 CPU cores, and 128 GB unified memory, available on a waitlist in the fall; Windows is also coming to NVIDIA's DGX station [inferred].
- **Windows developer experience updates** [00:10:49] — Intelligent Terminal with GitHub Copilot, 75+ Linux command-line utilities (grep, curl, tar, sudo), Homebrew/Starship/Zsh support, vertical taskbar, and first-class WSL containers.
- **Azure infrastructure at scale** [00:20:28] — 500+ data centers across 80 regions; the Fairwater AI super-factory (Georgia and Wisconsin) runs near-zero-water cooling and the largest Grace Blackwell deployment; Maia 200 (live in Iowa and Arizona) delivers 30% better tokens per dollar; Cobalt 200 VMs enter preview.
- **Horizon DB** [00:54:18] — A fully managed, zone-redundant PostgreSQL service with 128 TB per cluster, 15 read replicas, and ~3x throughput over self-managed Postgres.
- **Web IQ and Microsoft IQ** [00:56:50] — Model-agnostic, MCP-native web grounding plus a unified IQ layer (Web IQ, Fabric IQ, Work IQ, Foundry IQ) for grounding agents in enterprise context.
- **Microsoft Execution Containers (MXC)** [01:05:12] — OS-native isolation/containment policy for agents; OpenClaw runs natively on Windows via MXC with a WinUI 3 companion app.
- **GitHub Copilot app and Rayfin SDK** [01:19:06] — A new app managing parallel agent sessions via git worktrees, with Rayfin providing an enterprise backend-as-a-service (partnered with Replit, hosted on Microsoft Fabric).
- **Agent 365 and MDASH** [01:33:36] — Agent control plane (Entra, Defender, Purview extensions) with Agent 365 SDK GA, plus MDASH, a 100+ agent security harness that topped the CyberGym benchmark.
- **Autopilots and Scout** [01:44:21] — Enterprise-grade autonomous agents with identity and compliance; Scout is the first, available on Copilot Frontier.
- **Seven new MAI models and Frontier Tuning** [01:50:10] — MAI Image-2.5, Transcribe-1.5, Voice-2, Thinking-1, and Code-1-Flash, with a Mayo Clinic partnership to co-develop a healthcare frontier model.
- **Majorana 2** [02:19:04] — Next-generation topological qubit with a 20-second-to-one-minute mean lifetime (~1,000x Majorana 1) and one-microsecond operations.

## Topics covered
- On-device versus cloud inference and "unmetered intelligence" at the edge
- End-to-end data center systems optimization (tokens per dollar per watt), power delivery, and liquid cooling
- Silicon co-design across NVIDIA, AMD, Qualcomm, Intel, and Microsoft's own Maia/Cobalt
- Agent-first device form factors (Project Solara: stationary desk device and wearable badge)
- Grounding agents in web, operational, and organizational context
- Agent containment, identity, governance, and observability
- Reinforcement learning environments and "hill-climbing machines" for enterprise model tuning
- Agentic scientific discovery and quantum computing

## Notable quotes
> "The next computer is not one device. It is all these devices working together as one system, with agents showing up closer to where and when you need them." — Steven Bathiche

> "With MAI, you don't rent intelligence from a shared model that learns from everybody. Only you keep the benefits of your hard-earned workflows... Only you get to control the resulting model." — Mustafa Suleyman

> "The question is not whether you can build the next-grade model... The question is, how do we build this Frontier ecosystem together?" — Satya Nadella

## Products and tools mentioned
- Windows ML / Windows AI; Aion Instruct; Aion Plan
- Surface RTX Spark Dev Box; Surface Laptop Ultra; NVIDIA DGX station / GB300 [inferred]
- NVIDIA Vera Rubin, Grace Blackwell, NVFP4, OpenShell; AMD Ryzen and MI300; Intel Panther Lake; Qualcomm Snapdragon X2 Elite and Snapdragon C
- Azure; Fairwater; Maia 200; Cobalt 200; Windows 365
- Intelligent Terminal; WSL containers; PowerToys; Winget Configure
- Microsoft Foundry; Horizon DB; Cosmos DB; Azure Search; Fabric (Fabric IQ, real-time intelligence)
- Web IQ; Work IQ; Foundry IQ; Microsoft IQ
- Microsoft Execution Containers (MXC); OpenClaw; Rayfin SDK; Replit; GitHub Copilot app
- Agent 365 (Entra, Defender, Purview); MDASH; Copilot Studio; Teams; Microsoft 365 Copilot; Cowork; Scout
- MAI Image-2.5 / Flash; MAI Transcribe-1.5; MAI Voice-2 / Flash; MAI Thinking-1; MAI Code-1-Flash; Fireworks AI; Open Router; BaseTen
- Microsoft Discovery; Majorana 2

## Speakers featured
- Satya Nadella — Chairman and CEO, Microsoft
- Kayla Cinnamon — Windows developer experience team
- Jensen Huang — CEO and founder, NVIDIA (live from Taipei)
- Steven Bathiche — Microsoft (Project Solara)
- Cristiano Amon — CEO, Qualcomm
- Elijah Straight — Microsoft IQ demo
- Scott Hanselman and Samantha Song — Microsoft (OpenClaw on Windows)
- Peter Steinberger — founder, OpenClaw Foundation
- Cassidy Williams — GitHub Copilot app demo
- Amanda Foster — Foundry / Agent 365 demo
- Sarah Young — MDASH security demo
- Alex Pall and Drew Taggart — The Chainsmokers, general partners, Mantis VC
- Mustafa Suleyman — Microsoft AI (MAI)
- Dr. Gianrico Farrugia — President and CEO, Mayo Clinic
- Tanaya Yadav — Frontier Tuning demo
- David Carmona — Microsoft Discovery and Quantum team
- David Shaw and Sabrina Maniscalco — quantum closing video
