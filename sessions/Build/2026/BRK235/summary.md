<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK235\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK235\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:09.1768908+00:00
-->
# Summary

## Overview
Ollama co-founder Michael Chiang and agents engineer Parth Sareen make the case that open models running locally or in a hybrid local-cloud configuration are now capable of real agentic work, not just experimentation. The session covers Ollama's tooling for connecting open models to coding and personal agent harnesses, privacy-driven local execution, and the hardware trends (unified memory) making larger context windows viable on consumer machines.

## Key announcements
- **Ollama Launch** (00:00:56) — A command that injects open models directly into existing tools such as Claude Code [inferred], VS Code, and GitHub Copilot, with one-line setup for agent harnesses.
- **Ollama Cloud** (00:02:21) — An optional service introduced this year that runs frontier-grade open models on data-center hardware with zero data retention and no training on user data, for users lacking local compute.
- **Gemma availability on Ollama** (00:02:06) [inferred] — A newly announced Google DeepMind unified model is already available on Ollama for agentic applications the same morning as its release.
- **MLX inference engine** (00:17:40) — A native Apple-device inference path (supporting NVFP4) offering faster performance than the previous engine when pulling MLX models from Ollama's registry.
- **OpenAI and Anthropic API compatibility** (00:01:17) — Compatibility plus Python and JavaScript SDKs for developers building applications on open models.

## Topics covered
- Hybrid local-cloud execution where cloud and local models share a near-identical workflow.
- Evolution of open models from chat to reasoning, tool calling, and long-horizon multi-hour tasks.
- Privacy-sensitive local workflows (processing a credit card statement, financial filings) where data never leaves the machine.
- Real-world deployments at research labs and enterprises, including a routing layer that selects between cloud models and Ollama.
- Hardware constraints: VRAM versus unified memory, quantization, context-window limits, and compaction during local agentic workloads.
- Model selection guidance for coding, scripting, and personal-agent use cases.
- Edge/mobile support status, including Qualcomm Snapdragon chipsets.

## Notable quotes
> "Ollama is really the easiest way for developers to access open models and use it with your own tools." — Michael Chiang

> "So none of this information ever left my computer... local models are actually viable to do real work." — Parth Sareen

> "We're not directly targeting mobile devices yet because we want to target the mainstream use cases for work." — Michael Chiang

## Products and tools mentioned
- Ollama
- Ollama Launch
- Ollama Cloud
- Gemma (Google DeepMind) [inferred]
- Kimi K2 [inferred]
- Qwen 3 [inferred]
- gpt-oss-120b [inferred]
- GitHub Copilot CLI
- Claude Code [inferred]
- Codex [inferred]
- Droid [inferred]
- Pi (minimal harness)
- OpenClaw [inferred]
- Hermes
- MLX inference engine
- llama.cpp
- LangChain [inferred]
- NVFP4 quantization
- Qualcomm Snapdragon
- NVIDIA DGX Spark [inferred]
- AMD Strix Halo platform [inferred]
- Apple Silicon / unified memory

## Speakers featured
- Michael Chiang — Co-founder, Ollama
- Parth Sareen — Agents engineer, Ollama

## Follow-up resources
- Lawrence Berkeley National Laboratory — published work using Ollama with a routing layer between cloud models and Ollama for autonomous X-ray accelerator physics research.
- NASA Glenn Research Center — crew health performance probabilistic risk assessment categorizing Mars mission tasks into 18 human-system task categories.
- US Department of Energy / Brookhaven National Laboratory — Ollama integrated with LangChain [inferred] for natural-language log data analysis and summarization.
