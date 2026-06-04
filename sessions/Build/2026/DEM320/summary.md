<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM320\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM320\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:41.0693302+00:00
-->
# Summary

## Overview
Microsoft Foundry and Hugging Face presented Foundry Managed Compute, a managed platform-as-a-service for deploying open-source and custom models on dedicated GPUs without handling the underlying infrastructure. The session combined a platform overview, the rationale for building on open models, and a live end-to-end demo covering discovery, deployment, playground testing, code integration, and agent creation.

## Key announcements
- **Foundry Managed Compute (preview)** — A new construct within the Foundry resource that lets developers deploy open-source and custom models by selecting GPUs while Foundry handles topology, runtimes, patching, and maintenance, announced in the keynote the prior day **[00:01:40]**.
- **Day-0 access to Hugging Face models** — Trending models from providers such as Qwen, MiniMax, and NVIDIA Nemotron [inferred] become available in Microsoft Foundry the same day they land on Hugging Face **[00:03:04]**.
- **11,000 models in Microsoft Foundry** — Over 10,000 of the models cited in the keynote originate from Hugging Face, screened for commercial licensing and security **[00:02:58]**.
- **Open-model agent integration** — Deployed open models can now be attached to Foundry agents with tools like web search, described as available for the first time **[00:20:52]**.
- **Multiple accelerator options** — H100 GPUs, A100 GPUs, and AMD Instinct GPUs (coming) selectable via a simple dropdown, with preconfigured deployment templates for context-window or latency priorities **[00:16:32]**.

## Topics covered
- Form factors for accessing models: pay-as-you-go and PTUs for proprietary models versus Managed Compute for open/custom models.
- Five arguments for open models: frontier-comparable performance, customization (fine-tuning, post-training, distillation), owning the weights and experience, lower running costs, and version control.
- The curation and security pipeline: license screening for commercial use, remote-code filtering, security scanning, and weights uploaded to Foundry for supply-chain security.
- Guarantee that deployed Hugging Face models make no network calls outside the customer's secure tenant.
- Optimized runtimes per model type: vLLM, SGLang, Text Embeddings Inference, llama.cpp, NVIDIA NIM (TensorRT-LLM), and HF Serve for speech and vision tasks.
- Live demo: filtering the catalog, deploying a Qwen3-32B [inferred] model via templates, Playground and VS Code calls, agent creation, web search, and agentic RAG with multi-turn context.
- Built-in enterprise security: role-based access control, identities, and permissions inherited from Foundry.

## Notable quotes
> "The Frontier open models are on par with the Frontier close models, been the case for over a year." — Jeff Boudier

> "We will only give you models that are commercially permissible." — Jeff Boudier

> "You don't have to go and fetch like in the console. Do I have the quota for the right accelerator type? Like it's really simple." — Vaidya Sambasivam

## Products and tools mentioned
- Microsoft Foundry (Azure AI Foundry)
- Foundry Managed Compute
- Hugging Face (Hub, inference endpoints, Transformers)
- HF Serve
- vLLM
- SGLang
- Text Embeddings Inference
- llama.cpp
- NVIDIA NIM / TensorRT-LLM
- Qwen3-32B [inferred]
- NVIDIA Nemotron
- Microsoft Phi-2
- IBM Docling Granite
- Azure Machine Learning
- VS Code
- NVIDIA H100, A100, and AMD Instinct GPUs

## Speakers featured
- Vaidya Sambasivam — Microsoft Foundry team
- Jeff Boudier — Hugging Face
- Osi Otugo ("OC") — Product Manager, Microsoft Foundry
