<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD828\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD828\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:41.1249442+00:00
-->
# Summary

## Overview
A four-part Azure Compute session covering Microsoft's Arm-based Cobalt silicon, the Azure Boost offload platform, new Intel and AMD general-compute VMs, and confidential computing security. The throughline is price-performance and efficiency gains for cloud-native, agentic AI, and security-sensitive workloads.

## Key announcements
- **Cobalt 200 unveiled** [00:00:40] — Azure's next Microsoft-designed Arm CPU, delivering up to 50% higher performance over Cobalt 100 and positioned as Azure's leading performance offering.
- **New Cobalt 200 VM families** [00:11:43] — A high-memory MP series (16 GB/vCPU, up to 1.3 TB) and a dense local-storage LP series (up to 23 TB NVMe local storage) join the refreshed DP, DPL, and EP families.
- **Cobalt 200 regional launch** [00:14:10] — Launching in West US 3, East US 2, Central US, and Sweden Central, with more regions to follow.
- **Next-generation Azure Boost GA** [00:15:23] — Generally available with the first VMs (Intel-based V7), delivering up to 400 Gbps networking bandwidth and 1 million remote-storage IOPS.
- **Guest RDMA on Azure Boost** [00:23:48] — Limited preview kicking off June 2026, enabling direct memory-to-memory transfers between VMs via the Microsoft Azure Network Adapter.
- **Intel DSv7/ESv7 GA** [00:24:59] — Built on Intel Xeon 6 Granite Rapids with up to 15% CPU gains, scaling to 372 vCPUs and 2.8 TB memory.
- **AMD DA/EA/FAv7 VMs** [00:27:43] — Powered by 5th-gen AMD EPYC Turin, up to 35% CPU improvement, in 11 regions with broader expansion in 2026.
- **Azure Integrated HSM GA** [00:37:50] — A first-party security ASIC acting as a local key vault meeting FIPS 140-3 Level 3, keeping keys inside the HSM boundary.
- **Confidential VM live migration** [00:36:35] — Coming to Intel TDX, providing near-zero downtime for maintenance on confidential VMs.

## Topics covered
- Cobalt 100 production adoption by first-party services (Teams, Cosmos DB, Azure SQL, Defender) and reported efficiency gains.
- Agentic AI workload density: agent sandbox spin-up time, time-to-interact, and concurrency per VM.
- Arm migration tooling, porting frameworks, and recompile-and-go modernization for Java, Python, .NET, and Go.
- Azure Boost server offload architecture: host isolation, servicing, networking, and storage throughput.
- RDMA versus TCP for disaggregated AI inference (prefill/decode), benchmarked with a Llama 3.1 70B model.
- Intel network-optimized and EBSv6 storage-optimized VMs; AMD LASv5 and LAOSv local-storage VMs.
- Confidential computing via AMD SEV-SNP and Intel TDX trusted execution environments and attestation.

## Notable quotes
> "We run our own business on it before we ever ask a customer to." — Amar Dhamdhere

> "Protecting that data when it is in use in memory has not yet been solved at scale by industry, until now." — Vikas Bhatia

> "With RDMA we can push up to 200 gigabytes per second of throughput on a single connection, while still holding onto very tight predictable latency characteristics." — Niko Pamboukas

## Products and tools mentioned
- Azure Cobalt 100 and Cobalt 200
- Azure Boost
- Guest RDMA / Microsoft Azure Network Adapter
- Azure Kubernetes Service (AKS)
- Intel Xeon 6 Granite Rapids; Intel Emerald Rapids
- AMD EPYC Turin (5th generation)
- Intel DSv7/ESv7, EBSv6; AMD DA/EA/FAv7, LASv5, LAOSv
- Azure ND GB200 v6 cluster
- Llama 3.1 70B Instruct; vLLM (bench serve)
- Azure Integrated HSM; Azure Key Vault; Azure Managed HSM
- AMD SEV-SNP; Intel TDX; Caliptra root of trust
- Microsoft Azure Attestation; Microsoft Entra ID

## Speakers featured
- Amar Dhamdhere — Product Manager, VM Sizes Team, Azure Compute
- Niko Pamboukas — Principal Product Manager, Azure Boost Team
- Vikas Bhatia — Head of Product, Azure Compute Security and Confidential Computing

## Follow-up resources
- Azure blog — Cobalt 100 customer stories and Cobalt 200 announcement
- Arm migration overview and Arm learning paths
- Arm Software Ecosystem Dashboard
- Azure Cobalt VM documentation on Microsoft Learn
- Product availability by region (Azure)
- Guest RDMA preview sign-up form
