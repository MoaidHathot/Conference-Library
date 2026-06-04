<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK260\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK260\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:43.6029861+00:00
-->
# Summary

## Overview
This session demonstrates how to build production-ready local AI applications across the Windows device ecosystem using Microsoft Foundry on Windows, without cloud setup, token costs, or network dependency. Through a running "Unmetered Token Cafe" scenario, the speakers walk through three layers of the stack—Windows AI APIs, Foundry Local, and Windows ML—running live demos across five devices spanning AMD, Intel, NVIDIA, and Qualcomm silicon.

## Key announcements
- **Windows AI APIs expanded beyond NPUs to CPUs and GPUs** *(00:08:15)* — Many of the task-specific APIs now run across a broader hardware spectrum in response to customer feedback, reaching non-Copilot+ devices.
- **Phi Silica running on GPU** *(00:08:36)* — The small language model now runs on GPU and already powers production features such as Outlook's summarize capability.
- **Ion [inferred] as successor to Phi Silica** *(00:14:38)* — A next-generation in-box model promising larger context windows, better quality, and faster tokens per second, already powering the Prompt API in Edge Canary.
- **Foundry Local reaches general availability** *(00:16:18)* — Running common open-source models locally across CPU, GPU, and NPU, with new catalog additions including a Qwen 3.5 vision-language model and new speech models.
- **Windows ML CLI in preview** *(00:21:31)* — A one-stop toolchain for model conversion, optimization, and benchmarking, with agent skills, available at ak.ms/winmlcli.
- **Windows ML 2.0 in preview** *(00:39:07)* — Includes ONNX Runtime improvements, new hardware-vendor plug-in execution providers, and up to 2.6x throughput for generative AI workloads.
- **WebNN in preview** *(00:29:52)* — Brings native Windows ML hardware acceleration to web apps in Chromium-based browsers via experimental flags.

## Topics covered
- The "unmetered intelligence" thesis: shifting AI workloads from cloud to local for privacy, lower latency, offline capability, and cost reduction.
- The three-layer Foundry on Windows stack and when to use each: turnkey AI APIs, Foundry Local for open-source models, and Windows ML for custom models.
- Speech recognition API converting spoken drive-through orders to text on a Qualcomm Snapdragon NPU.
- Structured JSON output from Phi Silica for parsing unstructured order text.
- Video super resolution in Clipchamp for upscaling low-resolution footage.
- Model optimization pipeline: inspect, export to ONNX, analyze operator support, optimize, and benchmark performance.
- Windows ML as a cross-silicon abstraction layer with system-wide runtime dependencies and a vendor certification program.
- Real-time speech-to-speech voice transformation with sub-45ms latency (Voicemod).

## Notable quotes
> "Today we'll be talking about how you can build local AI powered apps for the over 1 billion Windows devices out there. No need for a cloud setup, no token costs, and no network needed." — Anastasiya

> "Our AI models can operate at ultra low latency below 45 milliseconds so that any voice interaction feel instantaneous and natural." — Jordi Janer, Head of Research and Innovation, Voicemod

> "We built it once and then we could deploy across our silicon partners, Qualcomm, NVIDIA, AMD and Intel." — Jordi Janer, Voicemod

## Products and tools mentioned
- Microsoft Foundry on Windows
- Windows AI APIs
- Phi Silica
- Ion [inferred]
- Foundry Local (SDK and CLI)
- Windows ML / Windows ML 2.0
- Windows ML CLI
- Foundry Toolkit extension for VS Code
- WebNN
- ONNX Runtime / ONNX Runtime Web
- Prompt API (Edge Canary)
- Qwen 3.5 (vision-language and 9B variants)
- Cardiff NLP sentiment model
- LoRA adapters
- Microsoft Clipchamp
- Voicemod
- Windows 365

## Speakers featured
- Anastasiya Tarnouskaya — Product Manager, Windows ML, Microsoft
- Aditi Narvekar — Product Manager, AI APIs, Microsoft
- Jordi Janer — Head of Research and Innovation, Voicemod
- Alfred — Microsoft Clipchamp (guest demo)
- Flex — Content creator and Voicemod ambassador (guest demo)
- Tucker Burns — listed speaker (not individually identified in transcript)

## Follow-up resources
- ak.ms/winmlcli — Windows ML CLI on GitHub
