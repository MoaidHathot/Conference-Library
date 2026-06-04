<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM361\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM361\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:59.7868860+00:00
-->
# Summary

## Overview
This advanced session demonstrates how to make Microsoft Agent Framework applications observable and testable, treating agents as black boxes that require instrumentation to understand and validate. Jim Bennett shows how open standards (OpenTelemetry plus OpenInference) expose what an agent does under the hood, and how an LLM-as-a-judge approach enables automated evaluation and a self-improving software loop.

## Key announcements
- **Live demo of a procurement evaluator agent built in ~11 lines** (00:01:00) — A line-of-business agent built on Microsoft Foundry with an OpenAI model, instructions, and tools that approves or denies purchase requests, illustrating how little code Agent Framework requires.
- **OpenInference as the observability standard for agents** (00:04:00) — An open-standard extension to OpenTelemetry aligned with AI semantic conventions, noted as the standard used for Microsoft's new assert framework and agent control specification described in Sarah Bird's prior session.
- **Tracing visualized in Phoenix** (00:05:19) — The free, open-source telemetry backend from Arise [inferred] renders OpenInference data as a trace tree showing system/user prompts, tool calls, token counts, and every decision the agent framework makes.
- **LLM-as-a-judge evals to test non-deterministic output** (00:10:08) — A scored rubric prompt converts non-deterministic agent output into a deterministic supported/unsupported verdict, revealing the demo agent passed only ~50% of cases.
- **Model swap raising effectiveness from ~50% to ~90%** (00:14:21) — Changing only the model from GPT-4.1 to GPT-5.4 [inferred] raised the same agent's eval pass rate to roughly 90% with no other code changes.
- **Self-improving loop via coding agents** (00:15:00) — GitHub Copilot CLI or Claude can use skills to access the dataset and evals, spin up the app in a sandbox, run inputs, and iteratively tweak prompts, models, and tool descriptions to converge on ~90% effectiveness.

## Topics covered
- Anatomy of an agent: LLM, instructions, and tools
- The black-box problem of agent decision-making and tool orchestration
- OpenTelemetry applied to AI applications via OpenInference
- Trace trees, span attributes, token counts, and granular telemetry
- Span processors for stripping PII or customer data from telemetry
- Why unit testing fails for non-deterministic LLM output
- Human evaluation bias and fatigue versus AI evaluators at scale
- Detecting silent tool failures (e.g., empty policy returns causing false approvals)
- Building scored eval rubrics grounded in tool evidence
- Datasets plus evals as a test-driven development pipeline for agents
- Model selection and regression testing across model upgrades
- Coding agents driving an automated self-improving software loop

## Notable quotes
> "Evals is the fancy AI word for testing. We should have called it testing because people know what testing is, but we have to call it evals because we're cool and different."

> "AI is just as good as a human, still makes mistakes, but doesn't get bored. And we can run AI at scale to test whether or not our code is working."

> "Agents will never be 100%. Humans are never 100%, agents will never be 100%, but you want to kind of work towards this 90%."

## Products and tools mentioned
- Microsoft Agent Framework
- Microsoft Foundry
- OpenAI models (GPT-4.1, GPT-5.4 [inferred])
- OpenTelemetry
- OpenInference
- Phoenix (Arise [inferred])
- GitHub Copilot CLI
- Claude
- GitHub

## Speakers featured
- Jim Bennett — Microsoft MVP for Foundry and developer tools

## Follow-up resources
- QR code linking to Jim Bennett's LinkedIn (shown on screen, for post-session questions)
- QR code to get started with Phoenix (free, open source, runnable locally)
- QR code to a GitHub repository containing all the session code
