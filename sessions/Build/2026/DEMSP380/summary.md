<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP380\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP380\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:37.9520742+00:00
-->
# Summary

## Overview
A demo-driven session showing how to build automated, scheduled agentic AI workflows that run entirely locally on Snapdragon X Series PCs using small language models optimized for the Qualcomm Hexagon NPU and distributed through Microsoft Foundry Local. The presenters use LLMware's Model HQ to build a no-code Jira summarization agent, then extend it programmatically via an SDK and demonstrate sharing it as a portable file.

## Key announcements
- **No-code agent builder on local hardware (Model HQ)** — **[00:03:04]** LLMware's Model HQ offers a drag-and-drop interface that integrates Microsoft Foundry Local and other model repositories, usable even by non-technical staff.
- **NPU-accelerated local inference via Windows ML API** — **[00:04:00]** The back end runs through the Windows ML API or ONNX Runtime APIs, using Qualcomm Execution Providers to run models on the NPU for best local performance.
- **Live Jira agentic workflow** — **[00:07:09]** A demo integrates a Jira API, Windows Foundry Local, and an email client to pull, filter, summarize, and email the most critical Jira issues with a per-row AI summary.
- **Programmatic access via Windows service and SDK** — **[00:13:37]** Flipping a switch exposes all Model HQ functionality as a back-end Windows service over local host, callable through SDK methods such as `call_agent` and `run_agent`.
- **Portable agent sharing** — **[00:19:08]** A built agent distills to JSON configuration plus custom data assets, wrapped in a ZIP file shareable like a PowerPoint, with no credentials passed.
- **Snapdragon X2 with 80 TOPS NPU** — **[00:22:04]** The latest-generation Snapdragon X2 [inferred] offers 80 TOPS, enabling larger models to run faster on-device.

## Topics covered
- Local versus cloud execution of enterprise AI workflows, and the security/privacy rationale for running locally
- Scheduled, automated agent runs that operate without prompting and without token charges
- Consolidating siloed Jira databases (user stories, feature requests, bug reports) into a usable knowledge base
- No-code drag-and-drop process composition: data pull, filtering, summarization, output, email
- Output generation in consumable formats (CSV, Excel, PowerPoint)
- Asynchronous agent execution with receipt/execution IDs and later output retrieval
- Moving from prototype to production: exposing agents as endpoints on a server for scalable deployment
- Hybrid model strategy: combining local small models with cloud models (e.g., Gemini) for complex reasoning steps
- Mixing and matching different models across stages of a single workflow

## Notable quotes
> "This really is the secret sauce of running AI locally is the accelerators that are increasingly built into the kit that every single person in this room is carrying around." — Darren Oberst

> "You can have a business domain expert, an SME... they can go build that agent and then that agent is exposed and available programmatically." — Darren Oberst

> "Unlike some demos, this actually is a commercial product." — Darren Oberst

## Products and tools mentioned
- Snapdragon X Series / Snapdragon X2 [inferred]
- Qualcomm Hexagon NPU
- Qualcomm Execution Providers
- Microsoft Foundry / Foundry Local
- Windows ML API
- ONNX Runtime
- LLMware Model HQ
- Jira
- Microsoft Teams
- Slack
- SharePoint
- Gemini

## Speakers featured
- Darren Oberst — presenter, demonstrating Model HQ (LLMware)
- Meghana Rao — presenter, session framing and enterprise context
- Morris Novello — presenter
