<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP386\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP386\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:58.2225837+00:00
-->
# Summary

## Overview
AMD's developer acceleration team presents a workflow for AI-assisted coding that lets developers shift work fluidly between local AI PCs and the cloud. The session centers on "Playbooks" (open-source setup recipes) and Lemonade, a ROCm-stack routing tool that abstracts hardware backends and routes inference by quality, locality, cost, and modality.

## Key announcements
- **Lemonade "launch" feature for agentic tools** [00:09:01] — Lemonade can directly launch agentic frameworks such as Codex, Claude, Gaia, or Open Claude and pair them with locally-runnable models.
- **Omni-modal routing in Lemonade** [00:14:20] — A demo showing Lemonade pulling together collections of models and intelligently routing queries to image generation, speech, or text models based on query context.
- **AMD Playbooks** [00:11:52] — A full-stack, open-source suite of setup recipes (kernel development, ComfyUI image generation, Lemonade integration, a clustering playbook for large models) launched a few weeks prior on client and Radeon GPU platforms.
- **Strix Halo "Halo box" appliance** [00:23:23] — A headless always-on PC using the same processor as the demo laptops, designed to run background agent teams overnight; available to order in June.
- **Semantic filtering with vLLM router** [00:18:44] — Demonstrated keeping personal data (e.g. a Social Security number query) local while routing trivial or low-value queries off enterprise servers to cut cost.

## Topics covered
- Three modalities of developer choice: quality (model size), locality (CPU/GPU/NPU, client vs. cloud), and modality (speech, vision, image generation).
- Dynamic versus static routing decisions based on resource availability or workflow state.
- Offline mobile coding: running planning and debugging jobs on a local Strix Halo GPU with Wi-Fi disabled.
- Agentic coding workflow splitting architecture/planning (large or cloud models) from iteration and debugging (local models).
- Lemonade architecture as an embeddable DLL built on the OpenAI standard inference API, with model management and routing utilities.
- Backend device fragmentation (ROCm, Vulkan, llama.cpp, Vitis, Stable Diffusion, Whisper, Kokoro) and the case for unifying it.
- Open-source community governance via a biweekly maintainers meeting, with community-added Mac and NVIDIA support.
- Cost as a driver for local inference and the role of memory cost in hardware decisions.

## Notable quotes
> "I mean, coding isn't even a use case. It's just a foundational layer."

> "The Wi-Fi is silent. I could turn off the Wi-Fi. It's not talking to the cloud, and it's doing that initial planning phase locally on the Strix Halo GPU."

> "What the community is building when you give them these tools, it blows my mind."

## Products and tools mentioned
- AMD Ryzen AI
- AMD Strix Halo
- ROCm
- Lemonade
- AMD Playbooks
- vLLM router
- OpenRouter
- Codex
- Claude
- Gaia
- ComfyUI
- Vitis
- AMD Radeon
- AMD Instinct
- AMD EPYC
- Vulkan
- llama.cpp
- Stable Diffusion
- whisper.cpp
- Kokoro [inferred]
- Azure
- Fireworks AI [inferred]
- Notion
- HIP
- OpenAI inference API

## Speakers featured
- Adrian Macias — Developer acceleration team, AMD (focused on client-side AI, working with ISVs and OEM partners)

## Follow-up resources
- developer.amd.com — AMD developer portal with playbooks, Halo announcements, Lemonade and ROCm workshops, and cloud credits for Instinct development.
- Public GitHub project hosting the open-source playbooks (including unreleased ones such as the clustering playbook).
