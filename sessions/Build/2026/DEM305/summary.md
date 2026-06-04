<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM305\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM305\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:09.5114689+00:00
-->
# Summary

## Overview
This session demonstrates how GitHub Copilot can operate across multiple environments and devices, introducing two complementary execution models: remote control sessions that extend a local Copilot session to mobile and web, and cloud sandboxes that give Copilot its own isolated, persistent cloud machine. Through a live World Cup simulation app, the presenters show steering, iterating, and continuing Copilot work without losing context.

## Key announcements
- **Cloud Sandboxing for GitHub Copilot in public preview** (~00:10:38) — Every Copilot session using a cloud sandbox runs in its own isolated cloud environment, with the host machine becoming optional and work persisting even if the local laptop disconnects or shuts down.
- **Remote control sessions for Copilot** (~00:02:00) — Lets users take a local Copilot session on the go via github.com or the GitHub mobile app, steering and monitoring it in real time across the CLI, the new Copilot desktop app, VS Code, and JetBrains.
- **Chronicle session history feature** (~00:19:46) — Indexes all of a user's Copilot sessions across clients to provide queryable, actionable guidance such as tips, stand-up reports, custom instruction improvements, and cost/token usage reduction.

## Topics covered
- Enabling and using remote control: `remote on`, `remote off`, `remote show`, QR-code/link handoff (Control+E), and `keep alive on`.
- Permission and visibility model for remote sessions (private to the user by default, optionally shareable with repo collaborators).
- Default-on configuration via settings (`remote sessions true`) and enterprise admin policies (remote control set to "view and control").
- Compatibility with GitHub repos, Azure DevOps (ADO) repos, and CLI sessions without a repository.
- Launching a cloud sandbox with the `--cloud` flag and provisioning an isolated environment.
- Cloud agent policies: firewall rules, recommended allowances, and custom allowances scoped to a repository.
- Sandbox lifecycle: implicit snapshots of process and disk, compute scaling to zero when idle, and resuming from snapshot on follow-up.
- Comparison of remote control (local resources, host required) versus cloud sandbox (isolated environment, host optional, persistent workspace).
- Running Chronicle via `/chronicle` across CLI, desktop app, VS Code, JetBrains, and github.com.

## Notable quotes
> "If I throw my laptop off the balcony, it will still work. Copilot still gets to go." — Denizhan Yigitbas

> "Some of us are ultra agent maxors, right? We want thirty of our agents working at the same time, but our apps might be heavy and our local resources just might not be enough." — Denizhan Yigitbas

> "Every session that you run with Copilot builds a history that you can query." — Ellie Bennett

## Products and tools mentioned
- GitHub Copilot
- GitHub Copilot CLI
- GitHub Copilot desktop app
- Copilot in VS Code
- Copilot in JetBrains
- GitHub Copilot Cloud Agent
- GitHub Copilot code review
- GitHub mobile app
- github.com
- Azure DevOps (ADO)
- Cloud Sandboxes
- Chronicle

## Speakers featured
- Ellie Bennett — presenter, GitHub Copilot
- Denizhan Yigitbas — presenter, GitHub Copilot
