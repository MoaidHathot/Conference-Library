<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK244\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK244\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:21.4446195+00:00
-->
# Summary

## Overview
swyx (Shawn Wang) argues that as coding agents converge on a shared "command centre" form factor, the scarce skill is no longer writing code but supervising fleets of agents—scoping their work, writing strong specs, and validating outputs. The talk traces how multi-agent orchestration, faster inference hardware, and the shift from human-reviewed to "dark factory" workflows are reshaping the software development lifecycle, and previews the research directions that come next.

## Key announcements
- **Cognition shipped an agent command centre** [00:01:18] — Announced "yesterday," it features local-to-cloud handoff and follows the same multi-agent "conductor" form factor as Cursor, Windsurf, Codex, and GitHub Copilot.
- **OpenAI is merging Codex into ChatGPT** [00:16:05] — Presented as evidence that coding-world workflows are bleeding into general knowledge work.
- **GitHub commit growth cited at 14,000x year-on-year** [00:06:59] — Attributed to a podcast conversation with the GitHub CEO; Claude Code attribution on GitHub is described as rising from ~4-5% in February toward a projected 50% by year end.
- **Cerebras collaboration on high-speed inference** [00:22:41] — Cognition is working with Cerebras on models delivering thousands of tokens per second.

## Topics covered
- Convergence of agent tooling on a single "conductor"/command-centre UI and the "everything becomes a crab" analogy.
- The shift from "big model religion" to a model-plus-harness paradigm, where the moat lies in neither the model nor the harness.
- Evolution of the SDLC: from pull requests to "prompt requests," goal/Ralph loops, and self-verifying agents.
- The "dark factory" (no human code review) versus the "light factory," and mitigations: strong specs, test suites, online evals, feature flags, progressive rollouts (the "Swiss cheese" model).
- Spec-driven development using large markdown specifications focused on API contracts, types, and the program's "narrow waist."
- Infrastructure shifts: demand for sandboxes/forkable environments, the GPU-to-CPU ratio moving from 8:1 toward 1:1, and a coming CPU shortage.
- Inference hardware acceleration and chip economics (extended chip amortization, weights etched on silicon).
- Growing model sizes and the research agenda: real-time/low-latency interaction, memory and continual learning, video agents, and world models.

## Notable quotes
> "You don't tell the agent how to do it. You tell the agent how you're about to evaluate it and when it should stop." — swyx [00:17:16]

> "We have superhuman coders, but we don't have superhuman reviewers yet." — swyx [00:14:21]

> "AI engineering is the last job because you are the ones to automate all the other jobs away." — swyx [00:35:25]

## Products and tools mentioned
- GitHub Copilot
- Claude Code (Anthropic)
- OpenAI Codex
- ChatGPT
- Cursor
- Windsurf
- Cognition
- OpenAI Symphony
- Kimi K2 [inferred]
- Cerebras
- Groq [inferred]
- NVIDIA H200 / B200
- Thinking Machines
- Mistral (24B "small" model)
- GPT-4.1, Llama 3
- xAI [inferred]
- Steve Yegge's Gastown / "Gas City" orchestrator [inferred]

## Speakers featured
- swyx (Shawn Wang) — advisor to Cognition; organizer of the Latent Space podcast and the AI Engineer community/conferences.

## Follow-up resources
- "WTF Happened in 1971?" — economics history site referenced [00:05:30].
- Steve Yegge's post on Gastown and the "8 levels" of LLM-driven development [00:20:01].
- OpenAI Symphony (open-sourced harness/spec example) [00:17:40].
- Article on "harness engineering" describing shipping ~1 billion tokens/day [00:13:48].
- The "agent labs versus model labs" writeup [00:19:45].
- The "semi-async valley of death" article [00:31:15].
