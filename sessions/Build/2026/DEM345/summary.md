<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM345\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM345\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:03.7712155+00:00
-->
# Summary

## Overview
A demo-driven, terminal-only session showing how to build a high-performance, fully offline AI media application for Windows using GitHub Copilot CLI, Win UI skills, and the Windows AI stack. The presenters demonstrate agent-oriented CLI tooling that lets Copilot scaffold, run, inspect, and test Win UI apps, then walk through preparing a Hugging Face model to run locally with the newly announced Win ML CLI.

## Key announcements
- **Win ML CLI** ([00:09:44], announced "today") — A toolchain that streamlines converting, analyzing, optimizing, quantizing, compiling, and benchmarking models so they run with high performance on local Windows hardware (CPU, GPU, and NPU).
- **Win UI Awesome Copilot plugin and skills** ([00:03:20]) — Installable via `plugin install winui`, bundling skills for design, workflow, packaging, code review, and setup that teach agents how to build Win UI applications.
- **New `dotnet new` Win UI templates** ([00:04:43], released "a few weeks ago") — Let agents scaffold manifest, XAML, and C# files via CLI rather than Visual Studio.
- **WinApp CLI** ([00:06:01]) — Installable via WinGet; runs packaged Win UI apps from the command line (a CLI equivalent of F5) and grants package identity so apps can call identity-dependent APIs like notifications.
- **Agent CLI tooling for context efficiency** ([00:07:39]) — `winui search` (samples), `winmd` API search, and `winapp ui inspect/invoke` (visual-tree inspection, clicking, screenshots) reportedly save over 70% of agent token usage versus shipping all context up front.

## Topics covered
- Building Win UI desktop apps entirely through Copilot agents without hand-editing code
- The Windows AI stack: Microsoft Foundry, Foundry Local, and Windows AI APIs
- Running local models offline: Whisper for transcription, Qwen3 14B via Foundry Local, Phi Silica as a built-in language model
- Converting PyTorch models from Hugging Face to ONNX and optimizing for ONNX Runtime
- Operator fusion (e.g. MatMul + Add fused into Gemm), quantization, and hardware compilation
- Execution provider targeting across CPU, GPU, and NPU (OpenVINO EP, TensorRT RTX EP)
- Splitting workloads across hardware (NPU for embeddings, GPU for video processing)
- Building a CLIP vision-transformer-powered "Find Frames" semantic video search feature

## Notable quotes
> "We have not looked at the code for this application at all. It's only be done with Copilot 100%."

> "What we found is by providing these type of tools to agents is that we're able to save over 70% of token usage for for agents."

> "Everything a human requires to learn there is a matching agent skill. By making it easier for agents, we also make it easier for humans to build to build applications."

## Products and tools mentioned
- GitHub Copilot CLI
- Win UI
- Win UI Awesome Copilot plugin
- WinApp CLI
- Win ML CLI
- WinMD (API search tool)
- `dotnet new` Win UI templates
- Microsoft Foundry / Foundry Local
- Windows AI APIs / Windows SDK
- Phi Silica
- Whisper
- Qwen3 14B [inferred]
- ONNX / ONNX Runtime
- OpenVINO Execution Provider
- TensorRT RTX Execution Provider [inferred]
- Hugging Face
- CLIP vision transformer model
- Visual Studio
- VS Code
- Razer Blade laptop (with NVIDIA GeForce RTX 5080 GPU and Intel NPU) [inferred]
- Win UI Gallery, AI Dev Gallery, Community Toolkit Gallery

## Speakers featured
- Nikola Metulev — Microsoft, presenter (Windows AI platforms / skills and agents)
- Lei Xu — Microsoft, presenter (Windows AI platforms / skills and agents)

(The transcript's "Elaine" appears to be a mishearing of the co-presenter's name [inferred]; the two presenters describe themselves as a developer working on skills and agents and a PM working on Windows AI platforms, but the transcript does not clearly map these roles to specific names.)
