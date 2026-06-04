<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK207\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK207\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:05.0260926+00:00
-->
# Summary

## Overview
A demo-heavy walkthrough of GitHub Copilot's agentic capabilities in Visual Studio, positioned as the premier tool for professional C# and C++ developers who treat code as a long-lived asset. The session shows specialized agents—debugger, profiler, and test authoring—root-causing a real bug and nearly doubling performance in the Visual Studio Profiler's own codebase, followed by a roadmap of upcoming Copilot features.

## Key announcements
- **Migration to the GitHub Copilot CLI SDK** [00:39:50] — Starting next week in Visual Studio Insiders, Visual Studio moves onto the same Copilot CLI SDK shared with VS Code and the CLI, so features arrive at the same time across tools while still using Visual Studio's warm MSBuild and Roslyn for builds.
- **Bring any model, including local and on-prem** [00:41:30] — Soon any model can be used in Visual Studio whether running locally, on-prem, or in any cloud, with an organizational security layer to mandate or restrict which models are allowed.
- **Web Forms to Blazor app modernization** [00:34:07] — A modernization agent can convert legacy Web Forms apps, including user controls and server controls, into Blazor, optionally layering in Aspire and cloud readiness.
- **Automatically applied agent skills** [00:34:46] — Visual Studio detects project type and auto-includes trusted, team-authored skills (e.g., from the WinForms and Azure teams) into agent context.
- **AI-assisted merge conflict resolution** [00:37:53] — A forthcoming button lets the agent analyze and resolve merge conflicts, escalating only the conflicts that genuinely need human input.
- **Build-speed optimization** [00:36:14] — Agents will inspect the error list and other indicators before kicking off a build, avoiding wasted multi-minute builds destined to fail.
- **Git worktree and submodule support** [00:33:09] — Full worktree and git submodule support is shipping next week in Visual Studio.

## Topics covered
- Code-as-asset versus code-as-artifact, and why quality gates, compliance, governance, and IT administration matter for professional developers.
- Using MCP servers (notably an Azure DevOps connector) to pull work items and CI artifacts directly into Copilot chat under user-confirmed, credential-scoped control.
- Test-driven debugging: writing a failing unit test to reproduce a bug before letting the agent author the fix.
- The debugger agent setting breakpoints, evaluating expressions, inspecting memory, and identifying an off-by-one error.
- The profiler agent using real instrumentation traces (CPU and allocation data) rather than guessing from source.
- The VS Test Performance Collector NuGet package capturing diag-session profiling traces automatically in Azure DevOps CI runs.
- Cross-codebase results: ~50 MB / 800,000 allocations trimmed from Visual Studio startup, Azure App Service cost reduction, and a Roslyn switch-case optimization contribution.
- The non-deterministic nature of agents and how developer expertise guides them.

## Notable quotes
> "If you're not using data, you're not actually profiling or improving performance, you're just refactoring."

> "I never actually believed in test driven development until copilot came along."

> "The better you are at your job as a developer you, the better you are at managing your agent too."

## Products and tools mentioned
- Visual Studio (2026 Insiders)
- GitHub Copilot in Visual Studio
- GitHub Copilot CLI SDK
- Visual Studio Code
- Visual Studio Profiler (Diagnostics Hub)
- VS Test Performance Collector (NuGet package)
- MCP servers / Azure DevOps MCP connector
- Test Explorer
- MSBuild
- Roslyn compiler
- Blazor
- .NET Aspire
- Azure App Service
- Windows Forms / Web Forms
- Models: Claude Opus, Claude Sonnet, GPT, Gemini, xAI

## Speakers featured
- Mads Kristensen, Visual Studio team (captioned as "Matt"/"Mads") [inferred]
- Nik Karpinsky, Visual Studio team; former dev lead for the profiler
- Anisha Pindoria (listed in session metadata)
