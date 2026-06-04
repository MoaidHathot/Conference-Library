<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP914\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP914\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:45.9223212+00:00
-->
# Summary

## Overview
This session presents Anyscale on Azure, a managed AI platform built on the open-source Ray framework and Azure Kubernetes Service (AKS), aimed at teams that want to own rather than rent their AI stack. Through a recommendation-engine use case, it demonstrates an end-to-end workflow of multimodal data processing, distributed fine-tuning, batch embedding, and model serving inside a customer's own Azure subscription.

## Key announcements
- **Anyscale on Azure, from the creators of Ray and powered by Ray on AKS** ([00:02:43]) — a production-ready platform offering a unified runtime for multimodal data curation, distributed training, and multimodal online serving.
- **Azure-native deployment in your own subscription** ([00:03:15]) — runs on AKS within the customer's subscription, integrates with Microsoft Entra ID for RBAC, and is available through the Azure portal so data and IP stay inside existing security boundaries.
- **One-line AKS cluster creation** ([00:04:46]) — users can deploy into an existing Kubernetes cluster or have Anyscale provision one automatically without managing infrastructure.
- **Anyscale Skills for AI code assistants** ([00:20:05]) — CLI-distributed skills that set up infrastructure and platform and generate Ray Data, Serve, Train, and RL post-training workloads, with the agents able to read metrics and observability data.

## Topics covered
- The rent-versus-own spectrum for AI models and when ownership makes sense (control, data differentiation, cost and latency).
- Scaling challenges as data becomes multimodal and grows from gigabytes to petabytes, and as parameter counts grow.
- Ray as a distributed compute framework, cited at over 12 million downloads per week.
- Anyscale console structure: workspaces (interactive development), jobs (production runs), and services (always-on serving).
- Ray cluster scaling, including adding GPU worker nodes such as A100s.
- Fine-tuning an open-source model with PyTorch wrapped by Ray Train, including checkpointing and mid-epoch failure recovery.
- Ray Data streaming to keep GPUs fully fed and avoid low GPU utilization.
- Batch embeddings and comparing base versus fine-tuned model embedding similarity/clustering.
- Multimodal serving with Ray Serve, composing an image-to-text model with the fine-tuned model behind a single endpoint, with zero-downtime versioning, independent scaling, and prefix-aware caching.
- Metrics and observability tabs for diagnosing bottlenecks across Ray workloads.

## Notable quotes
> "Owning is not binary. It's a spectrum that includes deploying open-source models, customizing open-source models with your own data, and training your own models." — Katarina Stanley

> "What is special about Ray is that it doesn't take that stuff away. All it does, is it wraps a lot of the open source regular frameworks that you use and creates an orchestration layer around all of it." — Daniel Arrizza

> "You're not getting those 20, 30 % GPU utilization, which is such a shame because we have such little availability of GPUs and if you're not keeping them fed, you're wasting money." — Daniel Arrizza

## Products and tools mentioned
- Anyscale on Azure
- Ray (Ray Train, Ray Data, Ray Serve)
- Azure Kubernetes Service (AKS)
- Azure portal / Azure console
- Microsoft Entra ID
- Azure Container Registry
- PyTorch
- VS Code / VS Code Desktop
- Anyscale CLI and Anyscale Skills
- Python / pip

## Speakers featured
- Katarina Stanley — Product Marketing Manager, Anyscale
- Daniel Arrizza — Field Engineer, Anyscale

## Follow-up resources
- QR code to the Anyscale Build conference webpage with scheduled table talks (including Daniel's talk on building multimodal data pipelines) and meeting requests.
- QR code to get started with Anyscale on Azure.
- In-person booth G201 at Microsoft Build.
