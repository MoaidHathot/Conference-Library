<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP384\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP384\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:55.2335382+00:00
-->
# Summary

## Overview
A live, advanced-level demo from Intel engineers on profiling and optimizing agentic AI workflows running locally on Intel-powered Windows PCs. The session demonstrates how correlated hardware and software telemetry exposes bottlenecks across CPU, GPU, and NPU, and how simple offloading and model-tuning decisions improve responsiveness and power efficiency on AI PCs.

## Key announcements
- **First preview of Intel Unified Telemetry** *(starting this week)* — A framework that decouples telemetry collection from the tool chain and merges driver-level platform data (CPU, GPU, NPU, power) with software traces into a single time-synchronized output.
- **Time-correlated platform telemetry across IP blocks** *(~00:05:13)* — Data from multiple drivers operating in different time domains is unified into one time domain, removing the burden of manual correlation previously required of tooling.
- **OpenVINO runtime fully instrumented for tracing** *(~00:14:14)* — The OpenVINO runtime is fully instrumented with ITT markers, with additional layers such as Windows ML being added on top.
- **JSON-based, AI-queryable trace output** *(~00:12:07)* — Software traces are organized into structured domains (for example "OV phases") so AI models can be queried to generate breakdowns and reports.

## Topics covered
- Why iteration speed on local prompts determines productivity on AI PCs.
- Anatomy of an agentic workflow: reasoning, planning, tool calling, and conversation summarization.
- Two telemetry streams: structured low-overhead platform metrics versus unstructured higher-overhead application/middleware traces.
- Correlating physical hardware performance with software execution layers across different time domains.
- Offloading the stylizer and summarization models from GPU to NPU to overlap work and shorten user-perceived turn time.
- Instrumenting custom applications with the ITT API (C and Python) using domains and tasks (for example "session creation" and "inference").
- Reading trace files: model compilation time, inference kernels, time-to-first-token, and decode rate.
- Comparative profiling across data types (FP16, INT8) and devices (GPU vs NPU) to weigh latency against energy efficiency.

## Notable quotes
> "You cannot optimize what you cannot see." — Vasanth Tovinkere

> "The productivity is really going to be measured based on the iterations that you can do with your prompts." — Freddy Chiu

> "If you are looking at speed that is more important for your application, then consider the GPU. If you want more energy efficiency... then the NPU is better." — Freddy Chiu

## Products and tools mentioned
- Intel Unified Telemetry framework
- Intel Instrumentation and Tracing Technology (ITT) API
- OpenVINO and OpenVINO GenAI
- Windows ML
- Windows ML CLI
- ONNX [inferred]
- oneDNN [inferred]
- ETW (Event Tracing for Windows)
- OpenSCAD [inferred]
- LCM Dreamshaper diffuser model [inferred]
- Qwen 3 models [inferred]
- ConvNeXt V2 [inferred]
- YOLOv11 [inferred]
- Intel Core Ultra Series 3 [inferred]

## Speakers featured
- Freddy Chiu — AI Frameworks Engineer, Intel
- Vasanth Tovinkere — Principal Engineer, Intel
