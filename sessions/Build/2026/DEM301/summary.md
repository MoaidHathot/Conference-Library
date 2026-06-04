<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM301\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM301\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:05.2939511+00:00
-->
# Summary

## Overview
GitHub product managers Salil Subbakrishna and Denizhan Yigitbas demonstrate two approaches to breaking the "commit-fail-commit" cycle in CI: agentic workflows that automatically diagnose failures and produce root-cause issues, and a sneak-peek Actions debugger that lets developers connect directly to a running runner. The session positions GitHub Actions as the execution layer for AI agents across the development lifecycle, with usage scaling rapidly.

## Key announcements
- **Agentic workflows entering public preview** *(00:20:35)* — Markdown-authored workflows that infuse agent logic into Actions will be generally available in public preview the week following the talk.
- **CI Doctor / CI Failure Doctor template** *(00:01:47)* — A prebuilt agentic workflow that auto-triggers when a target workflow fails, analyzes the failure, and files an issue with root-cause analysis and suggested fixes.
- **Actions debugger sneak peek** *(00:02:00)* — An unreleased internal tool that connects an IDE directly to a live Actions runner using the Debug Adapter Protocol, allowing inspection of variables, contexts, and secrets (redacted) and running commands on the runner.
- **GitHub AW CLI extension** *(00:06:05)* — A GitHub CLI extension (`gh aw compile`) compiles Markdown agentic workflow files into a `.lock.yml` Actions YAML file.

## Topics covered
- Growth of Actions usage, cited as rising from 550 million to 850 million jobs per week within months (a near-60% increase).
- The "commit-fail-commit" debugging loop and why it slows developers.
- Authoring agentic workflows in Markdown and compiling them to Actions YAML.
- Customizing agent prompts (e.g. adding a slash-command protocol) with help from Copilot.
- Sharing and reusing agentic workflow files across repositories and teammates.
- Assigning generated issues to an AI agent or a human collaborator for resolution.
- Debugging workflows that succeed but produce unexpected output, using live runner inspection.
- Diagnosing an incorrect base SHA vs. head SHA comparison in a `git diff` step.
- Debug Adapter Protocol as a client-agnostic standard (VS Code, Neovim).
- Security and abuse concerns around granting direct runner access.

## Notable quotes
> "They are a way that you can create an actions workflow but infuse agent logic in it. And the way that you're basically building them is you are creating Markdown files and expressing what you want to do in Markdown, and then we turn it into actions YAML." — Salil Subbakrishna

> "Given that this is allowing direct access to your runners, we are very concerned about security and abuse, which is why we're spending a lot of extra time to make sure that we've given this the appropriate level of protection."

> "The debugger has told me exactly where I was looking for and I didn't have to commit a bunch of stuff, do a whole bunch of print statements, add in extra steps to try and figure stuff out."

## Products and tools mentioned
- GitHub Actions
- GitHub Agentic Workflows (CI Doctor / CI Failure Doctor template)
- GitHub CLI (GitHub AW extension, `gh aw compile`)
- GitHub Copilot
- Visual Studio Code (GitHub Actions extension)
- Debug Adapter Protocol (DAP)
- Neovim
- Python

## Speakers featured
- Salil Subbakrishna — Product Manager, GitHub
- Denizhan Yigitbas — Product Manager, GitHub

## Follow-up resources
- GitHub Agentic Workflows preview site (referenced as findable by searching "GitHub agentic workflows" online)
- Public GitHub forums for submitting feedback on agentic workflows and the debugger
