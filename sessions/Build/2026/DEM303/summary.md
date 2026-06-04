<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM303\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM303\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:10.1462814+00:00
-->
# Summary

## Overview
A demo-driven walkthrough of agentic coding workflows using GitHub Copilot, framed to reassure developers that the field is still early enough to shape. Cassidy Williams and Martin Woodward build apps live from audience-submitted ideas while demonstrating planning, model selection, plan mode, and shipping safeguards across the Copilot app, CLI, and web.

## Key announcements
- **GitHub Copilot app built on the Copilot CLI** *(approx. 00:02:55)* — A desktop app running the same CLI engine and SDKs locally, fully integrated with GitHub so it live-pulls issues without refreshing.
- **Issue-template awareness** *(approx. 00:11:10)* — The Copilot app detected checked-in coding standards and an issue template, prefixing generated issues with the required `IDEA:` format automatically.
- **Rubber duck cross-model review** *(approx. 00:18:53)* — A feature that queries a different model family to vet a plan and find holes, described as producing a statistically significant improvement in results.
- **Auto mode model routing** *(approx. 00:16:53)* — Intelligently picks models by context to avoid burning expensive reasoning models on simple questions.
- **Remote control via phone** *(approx. 00:24:29)* — The `remote on` command pipes back to a local agent so a long-running task can be monitored and controlled from a phone.
- **Chronicle command** *(approx. 00:25:01)* — A newly landed command offering stand-up summaries and cost tips that advise on model choice and token efficiency based on usage.

## Topics covered
- Positioning agentic coding adoption on the innovation-adoption curve and the differing needs of early adopters versus mainstream enterprise users.
- The importance of tool, model, editor, and workflow choice across an organization.
- Writing durable, quality code rather than becoming "slop factories," and building safeguards so less-experienced developers produce good output.
- The risk that AI removes learning-from-failure, and team practices to compensate.
- Plan mode, quick chats (sessions not attached to a repo), interactive vs. autopilot ("Yolo"/allow-all) modes.
- Work trees enabling parallel, non-conflicting builds.
- MCP servers (e.g., Playwright for screenshots and visual vetting), bring-your-own-key, and local models on Foundry.
- Copilot instructions files and Spec Kit for agent-native documentation and constraints.

## Notable quotes
> "Copilot is the number 1, 2 and 3 contributor to the GitHub codebase right now." — Martin Woodward

> "The disadvantage of AI is you don't get to learn from failure like you once did in the past." — Cassidy Williams

> "As developers, you still have to be in control, you still have to steer and you still have to point it in the right ways." — Martin Woodward

## Products and tools mentioned
- GitHub Copilot
- GitHub Copilot app
- GitHub Copilot CLI
- VS Code
- Visual Studio
- GitHub coding agent (github.com/copilot)
- GitHub built-in code review
- Spec Kit
- Playwright (MCP server)
- MediaPipe [inferred] (caption: "media pie pants," for gesture recognition)
- Phaser (game framework)
- Azure AI Foundry [inferred] (caption: "Foundry," for local model hosting)
- GPT-5.5 [inferred] (caption: "GPT 55")
- Claude Opus 4.6 / 4.8 [inferred]
- Claude Haiku
- Chronicle command

## Speakers featured
- Cassidy Williams — GitHub (presenter)
- Martin Woodward — GitHub (presenter)

## Follow-up resources
- gh.io/dem303/idea — audience idea-submission form for the live build.
