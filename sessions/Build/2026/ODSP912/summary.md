<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP912\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP912\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:47.7667212+00:00
-->
# Summary

## Overview
The session argues that while AI agents can now write, run, and patch code at high speed, they cannot yet validate it in a trustworthy way, creating a reliability gap for agent-generated software. It introduces Kane CLI [inferred], a command-line validation layer from TestMu AI [inferred] that lets humans and agents run natural-language, browser-based end-to-end tests, with a live demo of an interactive run and an agent-driven run.

## Key announcements
- **Launch of Kane CLI [inferred], a command-line validation layer** ([00:01:55]) — A tool that tests any feature or application in a local browser and can be driven directly by humans or AI agents.
- **Native integration with coding agents** ([00:02:13]) — Kane CLI connects to agents such as Claude [inferred], Codex, Gemini, and Copilot via an agent.md file so they can author and run end-to-end tests.
- **Automatic Playwright code generation from natural language** ([00:03:29]) — Plain-language objectives produce reusable Playwright test cases as output.
- **Test.md framework with auto-heal** ([00:03:41]) — Markdown-stored test cases can be replayed, triggered from CI/CD, and self-heal when the UI changes, returning updated test code.
- **Shareable evidence and agent-native output** ([00:04:08]) — Each run produces video logs, trace recordings, a shareable replay link, and structured NDJSON output consumable by agents.

## Topics covered
- The validation gap between fast AI code generation and trustworthy testing.
- Adding a deterministic validation layer between development and shipping.
- Intent-based control: describing objectives in natural language without selectors, locators, or XPaths.
- Resilient test runs across complex multi-step user journeys.
- Vision-based waiting on rendered pages instead of arbitrary time delays.
- Automatic bug discovery and flagging during execution.
- Three usage modes: direct CLI, an importable SDK for CI pipelines, and agent integration via an agent.md file.
- Headless execution for agents versus interactive TUI mode for humans.
- Live demo: a checkout flow plus extracting an order ID and pasting it into a second browser session.
- Cross-browser, cross-device, and cross-environment validation in the cloud.

## Notable quotes
> "Agents can write code now. They can also run it, break it and patch it. What they haven't been really able to do is test it not in the way that you would trust before shipping an application to production."

> "Everyone is focused on how fast we are building, but very few of our are asking the real question, how fast we are validating."

> "KNCLI will provide them hands and eyes to perform those end to end workflows."

## Products and tools mentioned
- Kane CLI [inferred]
- TestMu AI [inferred] (testmuai.com)
- Playwright
- NDJSON
- npm
- Claude [inferred]
- OpenAI Codex
- Google Gemini
- GitHub Copilot
- Google Search

## Speakers featured
- Spurs KC [inferred], Developer Relations Manager at TestMu AI [inferred]

## Follow-up resources
- testmuai.com
