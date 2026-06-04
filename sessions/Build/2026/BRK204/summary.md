<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK204\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK204\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:05.4435648+00:00
-->
# Summary

## Overview
The VS Code team describes how moving from monthly to weekly releases—driven by AI adoption and competitive pressure—forced a re-architecture of their inner loop, engineering systems, and planning model. Shipping faster generated roughly 3x more issues and pull requests since January, which the team manages through agentic tooling for UI validation, automated triage, self-healing error pipelines, and temporary planning work streams.

## Key announcements
- **Move from monthly to weekly stable releases (February)** — Adopted to keep pace with the rapidly turning AI space and to land smaller, lower-risk batches rather than large monthly drops [00:04:37].
- **Component browser for agent-driven UI validation** — Extracts VS Code components so agents can render, screenshot, and compare changes with-and-without a diff directly in a PR without a full product build [00:07:30].
- **VSC bench, a purpose-built offline evaluation stack** — Runs many daily evaluations of models and prompts against custom cases, plotting total tokens against resolution rate to inform reasoning-effort and shipping decisions [00:23:16].
- **Automated issue triage and AI duplicate detection** — Agentic workflows infer owners, classify issues as bugs or feature requests, and semantically dedupe issues hourly via an internal Chrome extension [00:31:43].
- **Self-healing error pipeline** — An agent scans telemetry for unhandled errors, identifies root causes across processes, opens issues, and proposes fixes for human review [00:34:52].
- **Staged/incremental rollouts with freeze capability** — Replaces the previous all-at-once deployment, letting the team freeze a build after catching a problem at 8% rollout [00:38:56].

## Topics covered
- Code-survival (committed-code) as a model-quality proxy, rising from ~55% with GPT-4.1 to 86% with Opus 4.6 [inferred]
- The hidden cost of AI success: growth in issues, pull requests, and on-call risk
- Prototyping in place of written specs; PRs functioning as the spec
- Encoding expert knowledge (e.g. chat performance benchmarks) into reusable skills
- The pre- and post-launch model onboarding process via Copilot API, including prompt tuning and AB experiments
- Prompt-improvement experiments run as online AB tests on telemetry-enabled instances
- Reasoning-effort and token-cost trade-offs in model shipping decisions
- Prompt-injection and untrusted-input concerns when running AI on community issues
- Replacing durable code-ownership areas with temporary, DRI-led work streams

## Notable quotes
> "Using AI successfully does create more challenges for you." — Pierce Boggan

> "The point is not necessarily that you merge our PR, but that almost becomes actually the spec." — Pierce Boggan

> "We're like 40-ish people. I think people assume we're a thousand-person org. We're not." — Josh Spicer

## Products and tools mentioned
- Visual Studio Code
- VS Code Insiders
- GitHub Copilot
- Copilot API
- VSC bench
- Component browser
- GitHub / GitHub Actions
- GitHub mobile app
- Internal Chrome/Edge extension for triage and dedupe
- GPT-4.1
- GPT-5.5 [inferred]
- Claude Opus 4.6 [inferred]
- MAI coding model [inferred]

## Speakers featured
- Pierce Boggan — Lead of the PM team, VS Code
- Josh Spicer — Engineer on the VS Code team (agent integrations, customizations, UI)
- Anna Soracco — Listed speaker (does not appear in the transcript)
