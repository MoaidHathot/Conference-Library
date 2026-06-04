<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM346\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM346\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:56.3789504+00:00
-->
# Summary

## Overview
WSL is gaining the ability to run Linux containers locally on Windows through a new feature called WSL containers, accessible via both a command-line tool (WSLC) and a NuGet-based API (WSLCSDK). The feature ships as part of an existing WSL update, targets container developers, app builders/ISVs, and enterprise IT admins, and integrates with standard Windows management and security tooling.

## Key announcements
- **WSL containers for running Linux containers locally on Windows [00:00:20]** — A new WSL feature lets users run Linux containers directly via a CLI or embed them in Windows applications through an API.
- **WSLC command-line tool [00:02:06]** — A CLI (also aliased to `container`) whose subcommands, options, and switches closely track standard Linux container tooling, delivered via a simple WSL update with no third-party tools or daemons.
- **GPU access from within containers [00:07:07]** — Containers can tap the Windows host GPU using `--gpus all` for AI and graphical workloads, demonstrated by fine-tuning a GPT-2 [inferred] model and torch-compiling fused Triton kernels.
- **WSLCSDK API as a NuGet package [00:17:44]** — A library exposing the WSL containers API lets Windows apps build, create, and manage containers, integrated into the .csproj build so containers build on F5.
- **Per-app utility VM architecture [00:16:41]** — Each Windows application and the CLI flow receives its own dedicated lightweight utility VM, providing a hypervisor boundary, resource separation, and isolated names, volumes, and networks per app.
- **Azure Linux 4.0 general availability [00:21:52]** — Microsoft's Linux distro, the same one running AKS, is now available for general use on VMs, with a container-optimized WSL distro coming soon.
- **Public preview by end of June [00:22:54]** — WSL containers is planned to reach public preview by the end of June, with progress tracked in the open-source Microsoft WSL repository.

## Topics covered
- Running, attaching to, and terminating Debian Linux containers via WSLC
- Building custom container images from a container file, including port mapping to the Windows host
- Volume mounts (e.g., mounting the Hugging Face cache directory) and exposing services on localhost
- GPU-accelerated AI workloads inside containers, including torch compilation and Triton kernels
- The two entry points: CLI for direct access versus API for embedding in Windows apps, both powered by the same WSL VM
- Open-source approach and shared VM improvements benefiting Docker Desktop, Rancher Desktop, and Podman Desktop
- Target customer profiles: container developers, app builders/ISVs, and enterprise IT admins
- Enterprise manageability with Intune and MDE, and minimizing blast radius via scoped file/port access
- Architecture: WSL service, inter-process communication, HV sockets, the Moby container runtime, per-app VHD storage, and virtio-fs file sharing
- Azure Linux 4.0 as a single-vendor, supply-chain-attested distro

## Notable quotes
> "It's basically two different doors for the same engine. It's all powered by the same WSL VM that actually powers WSL distributions." — Craig Loewen

> "If I did not include these debug messages, it would just look like a Windows app. I would actually be none the wiser that this was running Linux in the back end." — Craig Loewen

> "Virtio-fs is about twice as fast as it stands today in this environment. And we're investing more in this area and looking at various alternatives as well to make this even faster." — Pooja Trivedi

## Products and tools mentioned
- Windows Subsystem for Linux (WSL)
- WSLC (Linux container CLI)
- WSLCSDK (WSL containers API / NuGet package)
- WSL service
- Moby
- virtio-fs
- Plan 9 (9P)
- HV socket / Winsock
- Microsoft Intune
- Microsoft Defender for Endpoint (MDE)
- Docker Desktop
- Rancher Desktop
- Podman Desktop
- Azure Linux 4.0
- Azure Kubernetes Service (AKS)
- Moonray
- Hugging Face
- Jupyter
- Python 3.12
- PyTorch / Triton
- GPT-2 [inferred]
- Visual Studio / .NET (NuGet, .csproj)

## Speakers featured
- Pooja Trivedi — Architect leading developer experiences in AI for Linux on Windows
- Craig Loewen — Product Manager working on the Windows Subsystem for Linux and AI tools on Windows

## Follow-up resources
- The CLI blog (announcement to be posted when the feature goes live)
- Microsoft WSL open-source repository
