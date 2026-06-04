<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK208\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK208\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:05.8891169+00:00
-->
# Summary

## Overview
Simon Willison argues that AI coding agents crossed a reliability threshold in late 2025, shifting the developer's job from typing code to verifying it at vastly higher velocity. The talk surveys practical verification patterns—borrowed from large-scale engineering and adapted to run on a single laptop—for shipping trustworthy software when manual review and AI testing alone are insufficient.

## Topics covered
- The "November inflection point" when coding agents (Opus 4.5, GPT-5.1 harnesses [inferred]) became reliable daily drivers, attributed to a year of reinforcement learning on coding tasks.
- "Vibe coding" versus "agentic engineering"—distinguishing throwaway experimentation from professional software shipped to production.
- The collapse of the typing bottleneck and the disappearance of incremental manual QA that used to happen while building features.
- StrongDM's "software/dark factory": rules that code must not be written or reviewed by humans, scenario testing with agent swarms, and a "digital twin universe" cloning Slack, Okta, and Jira as Go binaries to avoid rate limits and simulate bugs.
- Token spending as a cost concern (StrongDM's $1,000/engineer rule versus Uber's reported $1,500/engineer/month cap).
- Active refactoring as a review technique—nitpicking an agent's design without the social cost of critiquing a human.
- Considering stakes and "seams" when reviewing; deep review for authentication flows, light review for low-risk UI.
- Verifying API designs by having agents write throwaway code against them; hoarding interactive prototypes as verified inputs for later production work.
- Agentic documentation: running `diff against main` to keep docs current, with a strict no-opinions, no-rationales rule.
- Continuous deployment and preview environments as low-effort verification, now buildable via prompted GitHub Actions workflows.
- Reducing the "blast radius" of mistakes via Content Security Policy headers, sandboxed iframes, and WebAssembly/WASI server-side sandboxes—stress-tested by asking agents to break out.
- Zero tolerance for flaky tests (including UI tests), using agents and Docker to reproduce environment-specific failures; Playwright and the Chrome DevTools Protocol for browser automation.
- Tools that help humans also help agents: CLAUDE.md onboarding docs, linters, fast-compiling languages with good error messages (Go), and learning new languages/platforms (Rust, Swift UI) through agents.
- Conceptual integrity from "The Mythical Man-Month" applied to 2026 agentic engineering; personal discipline against overly ambitious projects.
- Spec-driven development and planning mode; valuing agent transcripts as durable artifacts archived alongside commit messages.

## Notable quotes
> "The big question I've been thinking about recently is what should we call vibe coding when it's applied by professional software engineers to ship real software?"

> "If we're going to use these tools to build worse software faster, we're missing a trick. We should be using this stuff to build better software faster."

> "You can't be rude to an agent. If you're rude to your agent and it gets upset, you can reboot it and it forgets everything."

## Products and tools mentioned
- GitHub / GitHub Actions / GitHub Gist
- Claude / Claude Code / CLAUDE.md
- Codex / Codex desktop
- GPT-3, GPT-5.1, GPT-5.5
- Opus 4.5
- StrongDM
- Slack, Okta, Jira
- Go, Rust, Python, Swift UI, JavaScript
- WebAssembly / WASI
- Content Security Policy, sandboxed iframes
- Docker
- Playwright, Selenium, Chrome DevTools Protocol
- Fly.io, Cloud Run, Vercel
- Redis
- Superpowers (skills for Claude Code/Codex)
- Mozilla Firefox

## Speakers featured
- Simon Willison — speaker; independent developer and writer using LLMs for coding since 2022; previously an engineer at Eventbrite.
- Jesse Vincent — audience member, creator of the "superpowers" skills set (referenced by the speaker).

## Follow-up resources
- simonwillison.net — the speaker's blog (also reachable via Mastodon, Bluesky, and Twitter).
