<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\LIVE101\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\LIVE101\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-06T08:19:55.2233296+00:00
-->
# Summary

## Overview
A live Build showcase in which Scott Hanselman and Mark Russinovich interrogate four community-built, AI-assisted projects to classify each as "AI slop," "vibes," or genuine AI-augmented engineering. The format combines on-stage demos with live code reveals and technical questioning about how much was hand-written versus model-generated. The recurring conclusion is that domain expertise remains essential to steer AI toward production-quality results.

## Key announcements
- **Vibe OS by Steve Sanderson [00:06:02]** — A bootable "operating system" (a ~1.3GB VHDX) whose every application UI is hallucinated in real time by an LLM rather than backed by code, rendered as HTML diffs within Copilot sessions.
- **Cursed CSS query engine by Cassidy Williams [00:21:26]** — A browser-tab tool that loads a real SQLite database via WebAssembly but performs all querying, ordering, and limiting in pure CSS using selectors, checkboxes, and Flexbox; open-sourced on her GitHub [00:30:42].
- **AI E scheduling bot by Sean "swyx" [00:34:34]** — A production conference-scheduling agent for the AI Engineer World's Fair, treating session placement as a bin-packing problem with human-in-the-loop approval across Slack, email, and iMessage, built on Cloudflare Workers and a D1 database.
- **Dataset Agent by Simon Willison [00:48:42]** — An agent plug-in for his Datasette project that answers natural-language questions over his 24-year blog database, runs locally or against hosted models, and includes a newly published MicroPython sandbox plug-in for safely executing agent-written code.

## Topics covered
- Generating live application UIs as model-produced HTML diffs within a single Copilot session
- Using a structured/HTML representation instead of image diffusion to render interactive interfaces
- Running SQLite in the browser via WebAssembly while offloading query logic to CSS
- Human steering versus manual code fixes when an AI resists "wrong" approaches
- Agent design with bounded turn counts and custom loops rather than open-ended autonomy
- Logging, verification, and approve/reject/modify gates for agent actions
- Cost/specialization trade-offs of building bespoke internal tools versus buying SaaS
- Plug-in architecture as a way to compose tools, contrasted with MCP
- Adversarial multi-model review (high/medium/low severity by model agreement) for security
- Sandboxing untrusted, agent-generated Python code
- Trust in software accruing through prolonged personal use rather than expert authorship

## Notable quotes
> "There's no code at all. Everything, in all these [windows], is being hallucinated in real time by the AI." — Steve Sanderson

> "All of the querying being done is in pure CSS... Should you do this? Probably not. But I did." — Cassidy Williams

> "The thing I care most about isn't that an expert wrote the [code]... [it's that] a human being has actually been using it for longer." — Simon Willison

## Products and tools mentioned
- GitHub Copilot (app, CLI, and SDK)
- VS Code
- Cursor
- Claude Code / Codex
- SQLite / WebAssembly
- Cloudflare Workers, D1, and Wrangler CLI
- Datasette
- LLM (Python library)
- db-to-sqlite [inferred]
- MicroPython
- GPT-5.5 [inferred]
- Qwen 3.5 [inferred]
- Claude Opus 4.6
- Swift UI / Xcode
- GitHub Pages

## Speakers featured
- Scott Hanselman — host
- Mark Russinovich — host
- Steve Sanderson — creator of Knockout.js; presented Vibe OS
- Cassidy Williams — presented the CSS query engine
- Sean "swyx" — organizer of the AI Engineer World's Fair; presented the AI E scheduling bot
- Simon Willison — creator of Datasette; presented the Dataset Agent

## Follow-up resources
- Cassidy Williams' CSS query engine, open-sourced on her GitHub [00:30:42]
