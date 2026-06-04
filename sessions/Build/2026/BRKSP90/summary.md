<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRKSP90\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRKSP90\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:52.3282087+00:00
-->
# Summary

## Overview
Alberto Martinez of Qualcomm argues that the economics of agentic AI coding are breaking because developers route trivial tasks—like generating docstrings—to large cloud models. The session proposes a three-tier inference routing architecture (on-device, on-prem, cloud) anchored by the Snapdragon X2 Elite NPU and a custom "classifier," claiming token-cost and latency reductions while keeping most code local with no quality loss.

## Key announcements
- **Three-tier routing architecture** [00:10:50]: Route simple/medium prompts to an on-device model (≤13B), medium-to-high tasks to an on-prem workstation (14B–34B, with up to ~100–120B on larger boxes), and only complex/security work to the cloud (70B+).
- **Snapdragon X2 Elite positioning** [00:11:18]: An 80 TOPS NPU offering roughly 43% greater compute than the prior generation, up to ~128 GB memory [inferred], and high memory bandwidth supporting multiple data types.
- **Hybrid-vs-cloud demo** [00:19:08]: A recreated Computex demonstration races Claude Opus 4.7 against a hybrid split (one hard task to cloud Opus, others to local models), producing identical output at roughly one-quarter the cost ($0.21 vs ~5.5 cents).
- **Classifier as developer IP** [00:29:08]: Qualcomm is researching but not yet shipping a routing classifier; Martinez encourages developers to build their own as a competitive advantage, living inside the orchestrator.
- **Forthcoming research paper** [00:41:50]: The underlying entropy, quantization, and routing research has not been published yet but is promised.

## Topics covered
- Token economics of AI coding and per-developer monthly cost escalation (cited figures up to $35,000–$36,000/developer/month, multiplying 10x–100x with agents).
- Per-task token costs: docstring ~180 tokens, lint fix 210, CRUD route 460, security audit ~3,800, cross-repo refactor ~3,900.
- Workload distribution across complexity scores, claiming ~73% of requests are locally resolvable and up to ~1.6 billion tokens/day processed on local hardware.
- Integer quantization trade-offs: ~50% weight-size reduction with roughly a 5% quality gap, recommended only below complexity score 7, where activation precision matters less.
- Classifier signal design: prompt token count, abstract syntax tree depth, cross-file reference count, and security flags, with sub-20ms / sub-50-token budgets.
- Confidence fallback (the "fifth leg"): monitoring entropy growth during execution to abort and re-route to the cloud, analogous to CPU branch prediction and prefetching.
- Latency and sustainability gains: ~200ms on-device response targets, reduced cloud GPU cycles, lower power and bandwidth.

## Notable quotes
> "Stop routing your duck strings to a 7 billion parameter model." — Alberto Martinez

> "You can replace your hardware every month and you're still saving money." — Alberto Martinez

> "Don't send everything to the cloud. Send what matters to the cloud." — Alberto Martinez

## Products and tools mentioned
- Qualcomm Snapdragon X2 Elite (and Stream edition)
- Claude Opus 4.7
- Claude Sonnet 4.6
- Cline [inferred]
- Claude (Anthropic) [inferred]
- Stack Overflow Developer Survey 2024

## Speakers featured
- Alberto Martinez — Qualcomm, software strategy lead for the compute business
- Morris Novello — listed co-presenter (per session metadata)

Audience questioners identified in the transcript: Nathan (Lockheed); Bridget (engineer, Vision); Malika (Qualcomm product management).

## Follow-up resources
- qualcomm.com (referenced as a demo link target)
