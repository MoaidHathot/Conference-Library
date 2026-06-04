<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD851\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD851\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:01.8881815+00:00
-->
# Summary

## Overview
Windows ML enables developers to run custom or open-source ONNX models locally on Windows across CPU, GPU, and NPU without shipping hardware-specific SDKs. Through a live demo building a customer-support sentiment-analysis dashboard, the session shows how a single ONNX model converted with the Windows ML CLI can run in a web app via WebNN and in a native WinUI 3 app, with hardware acceleration delivering local privacy, lower latency, offline support, and reduced cloud cost.

## Key announcements
- **Windows ML CLI (new tool)** [00:17:51] — A new command-line tool for converting and optimizing models to run locally on Windows across CPUs, GPUs, and NPUs, including `hub`, `export`, and optimization commands.
- **Windows ML 2.0** [00:18:13] — Updated to bring ONNX Runtime 1.24 with performance and stability improvements plus newly updated plugin-based execution providers usable across different runtime versions.
- **WebNN now backed by Windows ML** [00:18:36] — On Windows, WebNN uses Windows ML for faster hardware-accelerated inferencing in Edge or Chrome browsers (currently in developer preview).
- **ORT Gen AI library performance updates** [00:18:03] — The Windows ML ORT Gen AI library received updates leading to faster local LLM inferencing on Windows.
- **Dynamic execution provider acquisition** [00:13:09] — Apps can dynamically acquire vendor execution providers (e.g. QNN) via Windows Update rather than bundling roughly 80 MB of providers, reducing app size.

## Topics covered
- Converting Hugging Face and PyTorch models to ONNX using the Windows ML CLI
- Running a sentiment-analysis model in a web app with ONNX Runtime Web and WebNN
- Creating inference sessions and selecting device type (CPU vs. NPU)
- Tokenizing, tensorizing input, and applying Softmax to map logits to sentiment categories
- Building a native WinUI 3 app with WinApp SDK ML and runtime packages (framework-dependent deployment saving ~40 MB)
- Discovering, readying, and registering execution providers (FindAllProviders, EnsureReadyAsync, TryRegister)
- Session options for targeting a specific EP/device, disabling CPU fallback, and setting execution policy
- Broad compatibility: Windows 10 support, packaged/unpackaged apps, and C, C++, C#, and Python
- Positioning of Windows ML within Microsoft Foundry on Windows alongside Windows AI APIs and Foundry Local

## Notable quotes
> "What if we could run the same model locally using the hardware the user already has and still build the same amazing features that users love without the bill at the end of the day?" — Andrew Leader

> "Windows ML works with ONNX models, meaning you can choose from over 40,000 ONNX models from Hugging Face, or you could choose from 229,000 PyTorch models and use the WinML CLI or PyTorch to convert them to ONNX." — Maha Bayana

> "WinML allows us to dynamically acquire these providers, meaning that our app doesn't need to carry 80 MB of providers, further reducing our app size and simplifying our distribution." — Maha Bayana

## Products and tools mentioned
- Windows ML (version 2.0)
- Windows ML CLI (WinML CLI)
- ONNX Runtime (1.24)
- ONNX Runtime Web
- WebNN
- Windows ML ORT Gen AI library
- Windows App SDK (WinApp SDK ML, WinApp SDK runtime packages)
- WinUI 3
- AI Dev Gallery
- AI Toolkit for VS Code
- Microsoft Foundry on Windows
- Foundry Local
- Windows AI APIs
- Hugging Face
- PyTorch
- QNN execution provider
- Microsoft Edge / Google Chrome
- Copilot
- Execution providers from AMD, Intel, NVIDIA, and Qualcomm

## Speakers featured
- Andrew Leader — Product Manager, Windows ML team
- Maha Bayana — Software Engineer, Windows ML team

## Follow-up resources
- aka.ms/WindowsML — Windows ML documentation
- AI Dev Gallery app — samples and code for running AI models locally via Windows ML
- Breakout 260 — session covering Microsoft Foundry on Windows
