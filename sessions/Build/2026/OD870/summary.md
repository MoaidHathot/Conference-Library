<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD870\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD870\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:18.5567534+00:00
-->
# Summary

## Overview
This session details how Azure Storage underpins AI inference at scale, focusing on agentic workloads rather than training. The speakers frame three storage requirements—bringing enterprise data to agents, loading models fast enough to keep GPUs busy, and optimizing infrastructure utilization—and demonstrate concrete blob-backed solutions for prompt caching, model loading, and knowledge grounding.

## Key announcements
- **Azure Blob backend for NVIDIA NIXL** [00:10:43] — A first-class blob backend contributed to NVIDIA's inference transfer library lets any NIXL-speaking framework (vLLM, Dynamo, TensorRT-LLM, Ray) read and write KV blocks to Azure Blob with no custom adapter code.
- **LMCache Azure Blob plugin** [00:11:01] — A plugin offloads KV cache blocks from the open-source LMCache layer directly to durable blob storage for use with vLLM.
- **Azure Container Storage distributed cache (early access)** [00:18:02] — An AKS-native distributed cache where every GPU node acts as both cache and client over local NVMe RAID, delivering roughly 2.5x faster model loading and hitting Blob only once when many pods start together.
- **Azure Files as a data source for Azure AI Search** [00:21:56] — Available via a low-code Logic Apps connector and a native Azure Files Indexer, enabling vector or hybrid indexing of file shares and SMB workloads.
- **Foundry IQ with Blob as a first-class knowledge source** [00:23:04] — Microsoft's unified knowledge layer for agents can ground against an Azure Blob container directly, carrying storage security, lineage, and governance with no glue code.
- **Storage Center limited preview** [00:24:46] — A centralized hub for file, block, and object storage that provides a unified view of the storage estate and launch points into storage-for-AI experiences.

## Topics covered
- The distinction between "storage for AI" and "AI for storage," with this session focused on the former
- Three deployment paths for AI workloads: managed PaaS (Microsoft Foundry), managed Kubernetes (AKS), and direct IaaS
- The two-stage agentic inference data pipeline: data preparation (ingestion, chunking, embedding, indexing) and runtime retrieval/state persistence
- Prompt caching and KV cache reuse to avoid recomputing attention over static prefixes across multi-turn agent loops
- Time to First Token (TTFT) reduction and inference cost savings up to 90%
- Streaming KV cache from durable storage to cut long-context cold starts (demo: 52s to 8s, ~6x faster)
- Parallel chunked model-weight loading with the Run:AI Model Streamer (3-6x faster cold starts)
- Saturating the NIC as the deliberate bottleneck in place of GPU compute
- Native storage client integrations across the AI ecosystem (BlobFuse, ADLFS, PyTorch connector, LangChain loader)

## Notable quotes
> "In most production agents, the static, unchanged portion of the prompt represents more than 60% of inference cost." — Saurabh Sensharma

> "The bottleneck just moved from GPU compute to network bandwidth. Exactly the trade we want." — Vishnu Charan

> "First pod warms the cache, the next 99 read from inside the cluster, two and a half times faster model loading on AKS." — Vishnu Charan

## Products and tools mentioned
- Azure Blob Storage
- Azure Files
- Azure Managed Lustre (AMLFS)
- Azure Container Storage
- Azure Elastic SAN
- BlobFuse
- ADLFS
- AzCopy
- PyTorch connector
- LangChain Azure Blob loader
- Azure Context Cache
- NVIDIA NIXL
- LMCache
- Run:AI Model Streamer
- vLLM
- SGLang
- NVIDIA Dynamo
- NVIDIA TensorRT-LLM
- NVIDIA Triton
- Ray
- TensorFlow
- ONNX
- Microsoft Foundry
- Foundry IQ
- Azure AI Search
- Azure Kubernetes Service (AKS)
- Kubernetes AI Toolchain Operator (KAITO)
- Azure Identity
- Hugging Face loader
- Storage Center
- Llama 3.3 70B [inferred]
- gpt-oss-120b

## Speakers featured
- Saurabh Sensharma — Product Manager, Azure Storage team, focused on AI workloads
- Vishnu Charan TJ — Product Manager, Azure Storage team, focused on AI workloads
