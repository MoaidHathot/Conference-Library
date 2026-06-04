<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM367\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM367\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:18.7421387+00:00
-->
# Summary

## Overview
This demo session argues that AI agents deliver the most onboarding value not by generating code but by explaining an unfamiliar codebase, surfacing undocumented decisions, and identifying who and what matters. Using a fictional new developer named Sara and the open-source PostHog repository, the speaker walks through a four-act workflow that compresses weeks of ramp-up into days, culminating in a first pull request shipped on day one.

## Key announcements
This was a demonstration rather than a product-launch session; no new products were announced. The structure was framed as four "acts" of an AI-assisted onboarding workflow:
- **Act 1 — Understand the codebase (00:02:42):** The agent loads actual code, recent commits, and inferred boundaries to produce an architectural map and an auto-generated class diagram in about three minutes instead of a two-hour whiteboard session.
- **Act 2 — Surface hidden context (00:09:20):** Connected to GitHub, the agent reads PR descriptions, commit messages, and issue threads to reconstruct a module's full history and the reasoning behind major refactors.
- **Act 3 — Identify what and who matters (00:15:06):** The agent ranks the five files to read first and uses commit/PR history to name the main contributors and module owners to contact.
- **Act 4 — Ship the first PR (00:17:09):** Working from a real issue (#58757), the agent proposes a plan, implements the fix, runs and debugs tests, and drafts a PR description matching the team's existing conventions.

## Topics covered
- The cost of onboarding: 3–9 months to full productivity, ~40% of week one spent reading code, and one in three questions never asked aloud.
- Distinguishing AI as a "context engine" versus a code generator.
- Reconstructing architecture and data flow across a polyglot codebase (Python, React, .NET, SQL, Node.js) with Kafka topics.
- Identifying active versus legacy code by recent commit activity.
- Recovering the rationale behind a database migration from Postgres to ClickHouse [inferred] through PR and issue history.
- Extracting unwritten conventions for logging, error handling, and naming from active code rather than stale docs.
- Shifting documentation strategy toward readable code and good comments over maintained pages.
- Measuring "time to first PR" as the key onboarding metric, before and after AI adoption.

## Notable quotes
> "Onboarding used to be a test of patience. With AI, it can become a test of curiosity."

> "Don't judge an agent by how well it writes. Judge it by how well it explains the codebase."

> "It's not a replacement of the human, it's like an assistant or a pair programmer that will help you to understand and to resolve the different issue."

## Products and tools mentioned
- GitHub Copilot
- Claude Sonnet 4.6 [inferred]
- GitHub
- PostHog (open-source project used as the demo codebase)
- ClickHouse [inferred] (referenced as the captioned "Krikaus/Kekaus/Cacaos")
- PostgreSQL
- Kafka
- React
- Node.js
- .NET
- Python
- structlog [inferred] (captioned "import structured")

## Speakers featured
- Michel Hubert — Microsoft MVP (17 years), developer at Avanade, France.

## Follow-up resources
- The speaker invited attendees to contact him via LinkedIn (no specific link provided in the transcript).
