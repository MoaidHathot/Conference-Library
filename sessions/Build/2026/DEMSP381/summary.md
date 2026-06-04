<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP381\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP381\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:40.3109566+00:00
-->
# Summary

## Overview
Arm and Microsoft present the newly previewed Azure Cobalt 200 VMs as a cost-efficient, CPU-based platform for agentic AI and cloud-native workloads. The session pairs an architectural overview of the Cobalt processor line with a live AKS demo running LLM inference entirely on-cluster, without external GPU services or third-party LLM calls.

## Key announcements
- **Azure Cobalt 200 VMs in preview** — Announced by Satya Nadella in the morning keynote, the Cobalt 200 processor is custom-built by Microsoft for server workloads and natively supports Azure Boost (00:03:31).
- **At least 50% better per-core performance over Cobalt 100** — Cobalt 200 is built on 3nm technology on the latest Arm architecture and delivers roughly 50% better per-core VM performance than the prior generation (00:03:57).
- **Expanded VM family** — Beyond the D, DP, and ECDS series carried over from Cobalt 100, new memory-optimized VMs offer about 16 GB of memory per core, plus dense local-storage-optimized LCDS VMs aimed at agentic AI and cloud-native workloads (00:04:27).
- **Preview region availability** — Cobalt 200 is currently previewed in eight regions, with expansion planned at general availability (00:06:30).
- **Live on-cluster agentic inference demo** — A polyglot microservices shopping-cart application runs across mixed Cobalt 100 and Cobalt 200 nodes, with CPU-based LLM inference and a shopping agent executing entirely inside the AKS cluster (00:09:58).

## Topics covered
- Arm–Microsoft partnership across silicon innovation and software enablement
- Cobalt 100 production adoption by first-party services (Microsoft Teams, Defender) and third-party customers
- Industry (SPEC) and Microsoft internal benchmarks comparing Cobalt 200 to the previous generation
- Transition from fixed cloud-native workflows to AI-first, agentic application architectures
- Distributed microservices scaling across many nodes on Cobalt VMs
- CPU-based local LLM inferencing with KV cache for preserved conversational context
- Arm Cloud Migration program for moving workloads to Arm64

## Notable quotes
> "We have Defender which says Cobalt is their default processor to drive all their workloads."
— Gova Babu, Arm product team, Microsoft

> "Your data is not going outside, you're not talking to a third party LLM, and everything is local."
— Pranay Bakre

> "The context was carried over because we are using the KV cache."
— Pranay Bakre

## Products and tools mentioned
- Azure Cobalt 200 VMs
- Azure Cobalt 100 VMs
- Azure Boost
- Azure Kubernetes Service (AKS)
- Microsoft Teams
- Microsoft Defender
- Phi-4-mini model [inferred]
- ONNX Runtime [inferred]
- Arm64 (Arm Cloud Migration program)
- CNCF projects

## Speakers featured
- Sameer Nori — Software and ecosystem team, Arm
- Gova Babu — Arm product team, Microsoft
- Pranay Bakre — Arm (live demo presenter)

## Follow-up resources
- Hands-on labs scheduled for 6:30, 9:00, and 3:00 the following day (sign-up referenced in-session)
- Arm Cloud Migration program (contact via the "migrate" reach-out referenced in-session) for migration resources and engineering expertise
