<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP388\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP388\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:33:00.4759286+00:00
-->
# Summary

## Overview
A live demonstration of long-running agentic coding with Claude Code and Claude models inside Microsoft Foundry, framed around four "frontiers" that currently limit how independently coding agents can operate. The session shows how features like auto mode, separate evaluator agents, visual perception, and dynamic workflows let agents run for extended periods with reduced human bottlenecking while keeping humans focused on high-value and risky decisions.

## Key announcements
- **Opus 4.8 release (00:02:10)** — Anthropic's most capable Frontier model, released roughly a week prior, positioned for long-horizon and accuracy-critical tasks.
- **Auto mode in Claude Code (00:06:35)** — A classifier sitting between requests and the model that auto-approves low-risk actions (reading files, running tests) while still flagging potentially destructive ones, cited with a 0.4% false-positive rate, currently in research preview.
- **Dynamic workflows (00:04:54, 00:18:08)** — A new Opus 4.8 capability for orchestrating sub-agents, demonstrated by spinning up multiple design, picker, and testing agents to build an arcade game autonomously.
- **High-resolution image support in Opus 4.8 (00:14:01)** — Improved visual acuity that the security firm Expo used to raise agentic penetration-testing success from about 58% (Opus 4.6) to about 98%.

## Topics covered
- The four frontiers of agentic coding: what agents may touch, how agents verify correctness, what agents can perceive, and when/where agents run.
- SWE-bench verified progress across six model generations, from 49 to 87.6, and a recorded 14.5-hour autonomous coding session.
- Model selection strategy across Opus 4.8, Sonnet 4.6, and Haiku to balance capability, cost, and latency.
- The planner / generator / evaluator pattern, illustrated by a failed 16-agent C-compiler case study and the "Oracle" reviewer agent.
- Building a reliable evaluator (tests, adversarial review) before generating code.
- Agent perception via Claude in Chrome (real browser) and computer use, including a screenshot-based security review.
- Surfaces for running agents: terminal, phone approvals, scheduled tasks, loops, parallel execution, ultra plan, and voice.
- Enterprise governance, privacy, compliance, and Constitutional AI safety available through Foundry.

## Notable quotes
> "14 1/2 hours of being able to let your agentic code run. So not just 30 minutes, not just 5 minutes that we've all seen, but actually letting it run for hours or even days."

> "We needed to have an agent that could judge, not the agent that wrote the code."

> "We don't want to remove humans entirely. That's never going to be the goal here. But the goal is to have humans that are evaluating and looking at the things that are most important."

## Products and tools mentioned
- Microsoft Foundry (Azure Foundry)
- Claude Code
- Claude Opus 4.8
- Claude Sonnet 4.6
- Claude Haiku
- Auto mode
- Dynamic workflows
- The Oracle (evaluator agent)
- Claude in Chrome
- Computer use
- FastAPI [inferred]
- GCC
- Microsoft stack

## Speakers featured
- Caroline Matthews — Applied AI Architect, Anthropic
- Ryan Whitehead — listed in session metadata; not identified speaking in the transcript
