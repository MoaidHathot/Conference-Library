<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK200\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK200\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:11.0073752+00:00
-->
# Summary

## Overview
A demo-driven session from GitHub showing how AI agents now operate across the entire software development lifecycle — planning, coding, review, CI/CD, and operations — rather than merely autocompleting code. Mario Rodriguez frames a new "agent native engineering system" built on six pillars, and Evan Boyle demonstrates the GitHub Copilot app, emphasizing that the goal is finishing and shipping work, not generating more of it.

## Key announcements
- **GitHub Copilot app** [00:07:32] — A newly launched surface positioned not as a session manager but as a tool to finish work, handling triage, CI, review feedback, merging, and deployment.
- **Canvases** [00:11:10] — Agent-drivable, bidirectional UI surfaces (terminal, browser, triage boards, whiteboards, Kanban) that users or the agent can author dynamically and check into the repo's `.github` folder for team sharing.
- **Canvas marketplace** [00:19:19] — A forthcoming marketplace for first- and third-party canvas extensions, including a Miro integration with agent-driven design boards.
- **Copilot `--cloud` on GitHub sandboxes** [00:21:10] — Stateful, isolated fast micro-VMs with tightly scoped credentials, letting users delegate tasks to run in the cloud overnight without keeping a laptop connected.
- **Chronicle** [00:23:09] — A private, per-user searchable record of every session, prompt, and line of code across all Copilot surfaces, queryable by the agent via a direct SQL API plus full-text search; supports features like `Chronicle stand up`.
- **Agent Merge** [00:25:53] — An agentic automation that monitors a PR, resolves merge conflicts, keeps CI green, and addresses review feedback until the PR is ready, while pushing back on unreasonable requests.
- **Automations** [00:32:01] — Scheduled or event-triggered agent jobs (e.g., a 6 AM local "morning brief," or a cloud automation that reproduces bug reports and writes failing test cases on issue creation).
- **Rubber Duck** [00:37:05] — A multi-mode agent (advisor and critic) available in the Copilot CLI and Copilot app for getting a second opinion on work.
- **Multi-model code and security review** [00:40:28] — Slash commands (`/review`, `/security review`) orchestrate parallel sub-sessions using multiple models (Gemini, GPT, Claude Sonnet 4.6), built with GitHub Advanced Security.

## Topics covered
- Shift from "macro delegate / micro steer" agent workflows and the dissolution of the traditional SDLC into human-agent collaboration.
- The six pillars of the agent native engineering system: surfaces, runtime, automation, quality, intelligence (memory), and enterprise trust/scale.
- Isolated work trees, nested sub-sessions, and agent-as-orchestrator across multiple repos (SDK, core runtime).
- Sandbox security: scoped credentials, local and cloud isolation for safe agent execution.
- Using automations to reduce noise and protect developer focus and attention.
- Composing multi-session, multi-model review workflows with a final critique pass before requiring human attention.

## Notable quotes
> "We have a saying in GitHub: demos, not memos." — Mario Rodriguez

> "It's not about doing more, it's about finishing more. It's about reclaiming your focus and it's about outcomes." — Evan Boyle

> "Everything you're about to see is basically the product of me procrastinating and trying to get out of work." — Evan Boyle

## Products and tools mentioned
- GitHub Copilot app
- GitHub Copilot CLI
- Copilot SDK
- Canvases / Canvas marketplace
- GitHub sandboxes (Copilot `--cloud`)
- Chronicle
- Agent Merge
- Rubber Duck
- Copilot Code Review [inferred]
- GitHub Advanced Security
- Visual Studio / Visual Studio Code
- Gemini, GPT-5.5 [inferred], Claude Sonnet 4.6
- Miro
- Sonar
- Endor [inferred]
- LaunchDarkly

## Speakers featured
- Mario Rodriguez — Head of Product, GitHub
- Evan Boyle — Co-creator and engineering lead for the Copilot CLI, Copilot SDK, and Copilot app
- Jeremy — engineer who created Agent Merge (referenced, not present)
- Enrique — engineer who fixed cloud session support (referenced, not present)
