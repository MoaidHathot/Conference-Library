<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM350\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM350\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:54.0847649+00:00
-->
# Summary

## Overview

GitHub Agentic Workflows let developers define repository automation in natural-language Markdown rather than rigid YAML, with GitHub Actions compiling those files into runnable agentic pipelines. The session demonstrates a live, end-to-end build of a workflow that keeps a sample website updated with the latest GitHub blog and changelog content, emphasizing a security model that keeps humans in control of merges.

## Key announcements

- **GitHub Agentic Workflows enters public preview** *(00:01:58)* — The capability ships in public preview the week after the session, with a companion website and ecosystem of existing workflow templates.
- **Markdown-defined workflows replace hand-written YAML** *(00:00:29)* — Workflows are authored as Markdown files (optionally generated with Copilot) and compiled into a YAML "lock file" that GitHub Actions runs.
- **Model-agnostic agent backing** *(00:01:30)* — Workflows can run on Copilot, Claude [inferred], Codex, or Gemini to diagnose test failures, open pull requests, and recommend stack updates.
- **"Safe outputs" security model** *(00:08:32)* — The agent receives only read access to the repository; a separate post-run workflow step holds the permissions to create issues or pull requests, segregating responsibilities.
- **Hands-on GitHub Skills exercise** *(00:02:05)* — An accompanying Skills exercise built around a fictitious "Mona" website lets attendees reproduce the demo using their own GitHub handle.

## Topics covered

- Authoring agentic workflows as Markdown with front matter instead of YAML
- Compiling Markdown into a YAML lock file that defines the runnable Actions workflow
- Scaffolding via an installed agent file, skill, and MCP server under the `.github` directory
- Triaging test failures, auto-fixing CI/CD, generating daily repo reports, and updating documentation
- The safe-outputs pattern for restricting agent permissions to read-only access
- Scheduling workflows on a frequency or running them on demand, like standard GitHub Actions
- Iterating on workflows by editing the agent and front matter (e.g., correcting `contents: read`/`write` permissions)
- Human-in-the-loop review before merging agent-generated pull requests

## Notable quotes

> "If you're familiar with GitHub Actions, this is just GitHub Actions kind of on steroids with the agentic workflows." — Ari LiVigni

> "We are not actually giving the agent any permissions besides read access to the repository, but instead we use something called safe output." — Alejandro Menocal

> "We can't hallucinate or delete your code base or remove files from your repository. It's always going to be where you're in control." — Ari LiVigni

## Products and tools mentioned

- GitHub Agentic Workflows
- GitHub Actions
- GitHub Copilot
- GitHub Skills
- GitHub Copilot CLI
- MCP server
- Astro
- Claude [inferred]
- Codex
- Gemini

## Speakers featured

- Ari LiVigni — Senior Learning Advocate, GitHub
- Alejandro Menocal — Senior Service Delivery Engineer, GitHub

## Follow-up resources

- GitHub Skills exercise — accessible via the QR code/link shown on the closing slide (00:17:00). The public preview website was referenced but no specific URL was provided in the transcript.
