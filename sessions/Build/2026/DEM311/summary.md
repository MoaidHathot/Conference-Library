<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM311\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM311\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:14.9646143+00:00
-->
# Summary

## Overview
Azure Linux is Microsoft's purpose-built, Fedora-derived Linux distribution optimized for Azure cloud-native and AI workloads, delivering a consistent platform across WSL, VMs, and Kubernetes. The session walks through the distribution's strategy of "declarative deviations" from Fedora, demonstrates the same application running identically across three platforms, and announces the general availability of Azure Container Linux alongside the Azure Linux 4.0 VM public preview.

## Key announcements
- **Azure Container Linux is generally available** [00:07:09] — Microsoft's hardened, immutable Azure Linux image for AKS reached GA at Build, derived from the Flatcar Container Linux distribution.
- **Azure Linux 4.0 VM image enters public preview** [00:17:51] — The VM image is now available to test, validate, and provide feedback on.
- **Azure Linux 4.0 on WSL** [00:05:21] — Demonstrated running live, with WSL preview noted as a fast follow.
- **Kernel 6.18 maintained for the distribution lifetime** [00:08:28] — Azure Linux 4.0 ships the latest upstream kernel, to be maintained across the distribution's life.

## Topics covered
- Fedora as the upstream innovation distribution and Microsoft's close partnership with the Fedora community.
- "Declarative deviations": publicly documented, GitHub-tracked divergences from Fedora to produce a leaner, smaller image.
- Programmatic reliability layered on open-source speed: FIPS compliance, FedRAMP compliance, and Patch Tuesday-style release cadence.
- Shared sources and binaries across Azure Linux and Azure Container Linux for full compatibility.
- Security out-of-the-box: SELinux enabled in enforcing mode, firewalld preconfigured to allow only SSH, Secure Boot, and dm-verity read-only file system verification.
- Removal of the graphical/desktop stack to reduce package bloat and attack surface.
- DNF 5 package management, demonstrated by installing the Azure CLI.
- One-OS-everywhere consistency: identical Python, kernel, and libraries across WSL, VM, and AKS for a smooth developer-to-production workflow.
- Relationship between Azure Container Linux and Flatcar, including clarification that Flatcar is not being deprecated.
- Migration consideration: AppArmor to SELinux conversion for AKS users.

## Notable quotes
> "You get a lot of that upstream open source innovation and that upstream open source speed, but with the programmatic reliability that customers want for Azure." — Jim Perrin

> "If you validate your application on one, you can have confidence that it will work across all of them." — Jim Perrin

> "I've heard some rumors that, you know, we're deprecating Flatcar in favor of. That is not true. They serve different purposes." — Jim Perrin

## Products and tools mentioned
- Azure Linux 4.0
- Azure Container Linux
- Flatcar Container Linux
- Windows Subsystem for Linux (WSL)
- Azure Kubernetes Service (AKS)
- Azure CLI
- Azure Update Manager
- DNF 5
- SELinux
- firewalld
- Secure Boot
- dm-verity
- Fedora Linux
- Red Hat Enterprise Linux
- CNCF
- GitHub

## Speakers featured
- Jim Perrin — Program Manager, Azure Linux team
- Poorvi Narang — Program Manager, Azure Linux team

## Follow-up resources
- Azure Linux on GitHub (source code, declarative deviations documentation, and community call)
