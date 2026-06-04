<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK226\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK226\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:42.3896164+00:00
-->
# Summary

## Overview
A deep technical tour of Azure's full-stack infrastructure innovations, spanning AI data center design, server offload hardware, networking protocols, serverless containers, inference optimization, confidential computing, and experimental optical interconnects. Mark Russinovich emphasizes that much of the work is co-designed around AI workloads and that several demos show pre-production or research-stage technology.

## Key announcements
- **Latest-generation Azure Boost offload card** — Now deployed across 30%+ of the fleet, reaching 400 Gbps networking (up from 200), 20 GB/s remote storage, 1M remote IOPS, and 6.6M local NVMe IOPS [00:03:34].
- **Bare metal instances** — Currently in limited access for OpenAI's use of the Fairwater data center, with a general-purpose ND144V6 offering planned for the near future [00:05:36].
- **MRC (Multi-Path Reliable Connection)** — A new Ethernet-based networking protocol co-developed with OpenAI that packet-sprays across independent "planes" to survive congestion and link failures during massive training jobs [00:07:00].
- **Guest VM-to-VM RDMA over Azure Boost** — Demonstrated nearly doubling inference token throughput (3,400 to 7,637) and cutting median time-to-first-token from ~123k to ~47k ms in a disaggregated prefill/decode setup [00:11:00].
- **Direct virtualization for Azure Container Instances** — Places Hyper-V-isolated containers directly on servers as peers to the management VM, removing virtualization overhead; full fleet migration expected to take one to two years [00:15:34].
- **First public demo of container live migration** — Containers moved between server pools with no gap in output [00:17:03].
- **Azure Context Cache (preview)** — A storage-account-backed pooled KV cache that raised prompt cache hit rate to ~96% across servers regardless of where a request lands [00:23:42].
- **Memory-snapshotting for container sandboxes** — Launched 10,000 sandboxes with a ~2-second average launch time [00:27:33].
- **First-ever confidential VM live migration** — Achieved with Intel using a migration TD enforcing policy across servers; not yet in production [00:33:46].
- **Azure Integrated HSM (Manacor)** — A FIPS 140-3 Level 3 HSM in every server; releasing an AKV key locally raised signing throughput from ~640 to 18,800 operations/second with no loss of security [00:36:06].

## Topics covered
- Co-design of AI data centers (Fairwater Wisconsin and Atlanta), liquid cooling, and cabling
- DPU/FPGA/ARM-core data-plane offload and agent relocation off the host CPU
- Ethernet vs. InfiniBand and RoCE for GPU back-end fabrics
- Disaggregated inference: prefill/decode pool separation and KV cache mechanics
- Manifold: unified GPU/ASIC/FPGA/CPU pool scheduling with topology awareness
- Hyper-V vs. process isolation as a security boundary
- Confidential computing: hardware enclaves, attestation, and key release policies
- Hardware roots of trust (Caliptra) and in-server key management
- Project Mosaic: micro-LED optical interconnects over imaging fiber

## Notable quotes
> "We've developed with Open AI and now a growing consortium of partners... a new networking protocol called Multi Multi Path Reliable Connection or MRC."

> "We don't consider a process or user mode kernel as a security boundary in Azure. We only consider virtualization... to be a security boundary in Azure."

> "That right there, first time ever and it's not in production yet. But you can see that we just literally achieved this in the last few weeks. The first confidential virtual machine live migration anywhere."

## Products and tools mentioned
- Azure Boost
- Fairwater data centers (Wisconsin, Atlanta)
- MRC (Multi-Path Reliable Connection)
- MANA (Microsoft Accelerated Network Adapter)
- Azure Container Instances
- Azure Context Cache
- Manifold
- Llama 4 Maverick
- Azure AI Foundry
- Intel SGX; AMD and Intel confidential VMs
- Confidential Containers on ACI
- Caliptra [inferred]
- Azure Integrated HSM (Manacor); Azure Managed HSM; Azure Key Vault
- Project Mosaic
- GitHub Actions, Python in Excel, Horizon DB (running on ACI)

## Speakers featured
- Mark Russinovich — CTO, Deputy CISO, and Technical Fellow, Microsoft Azure
- Darby Kosten [inferred] — Microsoft Research Cambridge, presenting the Project Mosaic micro-LED demo remotely
