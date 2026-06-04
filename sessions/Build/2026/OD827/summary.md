<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD827\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD827\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:16.7168299+00:00
-->
# Summary

## Overview
Azure Linux is Microsoft's purpose-built, secure-by-default Linux distribution that now spans VMs, AKS, and containers from a single foundation. The session traces Microsoft's Linux journey, introduces Azure Linux 4.0 (built on Fedora) in preview for VMs, and announces the general availability of Azure Container Linux as an immutable, hardened container host for AKS.

## Key announcements
- **Azure Linux 4.0 preview for VMs and VMSS** ([00:01:57]) — A general-purpose distribution built on a Fedora foundation with SELinux enforcing by default, shipping with the 6.18 LTS kernel.
- **Azure Container Linux (ACL) generally available on AKS** ([00:11:41]) — An immutable, container-optimized host that combines Flatcar's vendor-neutral immutable design with Azure Linux's hardened security and trusted supply chain.
- **Azure Linux container images entering preview** ([00:05:05]) — Pre-installed with Azure tooling and ready to pull from the Microsoft Container Registry.

## Topics covered
- Microsoft's history of Linux contributions, from the 2009 kernel contribution through CBL-Mariner and WSL.
- The three-layer Azure Linux architecture: hardened Hyper-V-optimized kernel, minimal-footprint core RPM packages, and Microsoft-managed servicing.
- Rationale for an in-house distribution: supply-chain security, performance, quality gating, and single-vendor support.
- Azure Linux 4.0 features: Fedora upstream base, declarative deviations, RHEL-ecosystem familiarity, DNF5 package management, firewalld, and SELinux by default.
- Security and compliance posture: FIPS validation, CIS Level 1/2 benchmarks, Secure Boot, CVE SLAs (critical within five days), and signed kernel modules.
- Azure Container Linux internals: dm-verity-backed read-only /usr, unified kernel image, Trusted Launch with vTPM attestation, and A/B update agent.
- Choosing between Azure Linux and Azure Container Linux node pools, including running both side-by-side in one AKS cluster.
- Resiliency through release-blocking validation, performance gains in node/pod startup, and ecosystem integration with partner and open-source tooling.

## Notable quotes
> "When you adopt Azure Linux, you're running the same OS that powers Microsoft's most critical infrastructure. We trust it, and so can you." — Poorvi Narang

> "Even if an attacker gets root access inside a container, the host stays protected." — Flora Taagen

> "Because we ship fewer packages, there are simply fewer CVEs to begin with." — Flora Taagen

## Products and tools mentioned
- Azure Linux
- Azure Linux 4.0
- Azure Container Linux (ACL)
- Azure Kubernetes Service (AKS)
- Azure VMs and VMSS
- CBL-Mariner
- Fedora
- Flatcar Container Linux
- DNF5
- SELinux
- firewalld
- dm-verity
- Microsoft Container Registry
- Microsoft Defender for Cloud
- Azure Monitor
- Azure Image Builder and Image Customizer
- Azure CLI
- .NET
- OpenJDK
- Kata Containers
- containerd
- systemd
- Azure Arc
- MSRC
- Trusted Launch / vTPM

## Speakers featured
- Poorvi Narang — Senior Product Manager, Azure Linux
- Flora Taagen — Azure Linux team

## Follow-up resources
- Azure Linux GitHub repository for filing issues and submitting PRs (referenced verbally, link on session slide).
- Enterprise offering documentation (referenced verbally, links on session slide).
- Bimonthly Azure Linux community call for roadmap updates and live feedback.
