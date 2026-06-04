<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK245\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK245\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:27.1158319+00:00
-->
# Summary

## Overview
Peter Steinberger walks through the sprawling ecosystem of small, "vibe-coded" tools he built to maintain the fast-growing open-source project OpenClaw with a tiny team. The central thesis: in the agent era, a developer's job shifts from building software faster to building the tools that help agents build, verify, and ship software faster — and personal annoyance is the best signal for what to automate next.

## Key announcements
- **Clause Reaper, an automated issue/PR triage system** [00:05:54] — Spins up a Codex session via GitHub Action on every issue or pull request, guided by a `vision.md` file, to comment on or close items; credited with closing roughly 15,000 issues.
- **Weekly re-runs of triage across all issues** [00:07:20] — Re-evaluates every open issue and PR at least weekly, notifying original reporters via Discord when their problem was already fixed on main.
- **A Discord crawler ("disk crawl") feeding a maintainer dashboard** [00:08:52] — Aggregates GitHub and Discord activity, serializing the data into GitHub as a backup/distribution channel so maintainers without a bot token can access it.
- **Release Bar dashboard** [00:15:42] — Tracks days since last release across many projects to flag which need a new release or attention.
- **Octopus, a GitHub token proxy** [00:17:49] — Routes read-only, non-mutating calls through a GitHub App (raising the rate limit from 5,000 to 15,000 requests/hour) via Cloudflare, reserving the personal token for mutating actions.
- **Crab Box, a cloud test-sandbox wrapper** [00:22:00] — rsyncs changes to beefy cloud VMs to run heavy or parallel tests, with fallback across ~20 providers; later extended with cross-platform OS testing, VNC, and screenshot/click/type computer-vision automation.
- **Mantis, visual PR verification** [00:25:43] — Spins up boxes to record video of a bug and its fix, verifying the change so the maintainer only watches the video and merges.
- **Auto Review** [00:27:45] — Has the agent recursively call itself with fresh context to run multiple automated review rounds before committing or landing a PR, driven by one line in `agents.md`.
- **Core Patch** [00:34:56] — Splits a large codebase into ~50 sections for separate agent review, useful for cleaning up legacy code.
- **Crab Fleet, multiplayer Codex** [00:36:35] — Runs Codex inside Crab Box so maintainers can view, talk to, and take over a shared agent session.
- **Prompt-attachment contributor skill** [00:32:27] — Asks contributors' agents to attach a privacy-filtered transcript to PRs, giving maintainers a signal of effort invested.

## Topics covered
- Treating issues and pull requests as interchangeable "prompt requests" signaling user dissatisfaction
- Managing open-source "slop" at scale rather than fighting it
- Closing the loop so agents can self-verify (screenshots, video, end-to-end tests)
- Using a `vision.md` to encode what the project does and does not want
- Writing project invariants into agent instruction files, and having the agent author its own instructions
- Optimizing for autonomous agent work versus reserving human focus time
- Compounding value of small composable tools
- Annoyance and laziness as automation signals

## Notable quotes
> "It's still called pull request. I call it prompt request because... it's just a signal that somebody's not happy with what you built."

> "Oftentimes we're not limited anymore by intelligence. The models are good enough now. Everything that we are limited off is our own imagination."

> "Listen when you're annoyed. Annoyance is an amazing signal for we can automate this, and then anytime you automate something, it compounds."

## Products and tools mentioned
- OpenClaw
- Codex
- Claude
- Cloudflare
- GitHub / GitHub Actions / GitHub Apps
- Discord
- CodeRabbit [inferred]
- Blacksmith [inferred]
- Wispr Flow [inferred]
- Go
- AWS
- Clause Reaper, Octopus, Crab Box, Mantis, Auto Review, Core Patch, Crab Fleet, Click Clock, Release Bar, GOG (Google CLI), disk crawl (Discord crawler) — speaker's own tools

## Speakers featured
- Peter Steinberger — speaker, maintainer of OpenClaw
