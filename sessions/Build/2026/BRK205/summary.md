<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK205\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK205\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:07.8172775+00:00
-->
# Summary

## Overview
Aspire is presented as an open-source, code-first toolchain for composing, debugging, and deploying distributed applications, with a focus on making both human developers and coding agents productive across the full software lifecycle. The session demonstrates a meeting-booking app with an AI agent backend, showing local orchestration, observability via the dashboard, and deployment to Azure, while emphasizing that Aspire's app host serves as a single source of truth for both development and deployment.

## Key announcements
- **TypeScript app host support (00:12:48)** — Aspire now lets you author the app host/app model in TypeScript in addition to C#, with Python, Java, and Go orchestration noted as coming.
- **`aspire start` background command (00:08:18, 00:12:22)** — A new non-blocking command runs the app host in the background, complementing the blocking `aspire run`, which suits coding agents that struggle with long-running processes.
- **Aspire CLI in Winget (00:11:56)** — As of the day before, the CLI is installable via `winget install Aspire.CLI`, with Homebrew and npm distribution planned.
- **Dashboard fully exposed to agents in 13.0+ (00:23:19)** — Everything visible in the dashboard is now backed by an API available to both the CLI and agents, so agents can fetch logs, traces, and telemetry the same way humans do.
- **Browser logs integration (00:21:57, 00:35:33)** — A `withBrowserLogs` method launches a tracked, debuggable browser that pipes F-12 console and network logs back into the dashboard and CLI.
- **Aspire agent skills (00:38:56)** — `aspire agent init` installs Aspire skills (monitoring the app, wielding custom commands, waiting for healthy states) usable directly via the CLI without requiring an MCP server.
- **Postgres MCP wiring in the app host (00:28:33)** — Integrations can now define and wire up an MCP server for resources like Postgres directly in the app host.

## Topics covered
- Orchestrating multi-component apps (front end, back end, background agent worker, database, container sandbox)
- The app host as a single source of truth eliminating config drift between dev and deploy
- Integrations encapsulating build/debug/dev/deploy behavior per language (dev certs, OpenTelemetry injection, port management)
- Port randomization and per-worktree isolation for running parallel agent sessions
- OpenTelemetry-based dashboard: traces, structured logs, metrics, and end-to-end request profiling
- Custom resource commands for database seeding and admin tasks (clear/generate calendar)
- Strongly-typed parameters and secrets stored in the user profile to prevent accidental commits
- Azure Foundry integration with on-demand resource provisioning, role assignment, and per-developer sandbox subscriptions
- Deployment via `aspire publish`/`aspire deploy` to Azure Container Apps, with escape hatches exposing the full Bicep object model
- Distributing a system across Azure Container Apps and Foundry hosted agent sandboxes

## Notable quotes
> "Aspire is an agent ready code first tool to compose, debug and deploy any distributed app." — David Fowler

> "We made a big change in 13 [point] zero where we said everything in the dashboard must be visible to agents." — David Fowler

> "Once you use it, you're never going to be able to go back, I promise you." — Maddy Montaquila

## Products and tools mentioned
- Aspire (CLI, app host, dashboard, integrations)
- Aspire dashboard (OpenTelemetry viewer)
- OpenTelemetry
- C# / .NET
- TypeScript / Node.js
- Python (uvicorn)
- Vite
- Postgres (with PG web and Postgres MCP)
- Redis
- Docker Compose, Podman, Rancher
- Kubernetes
- Microsoft Foundry [inferred] (agent platform)
- Azure Container Apps
- Azure CLI, AZD, VS Code
- Bicep
- GPT-5 mini [inferred]
- GitHub coding agent app
- Winget, Homebrew, npm
- Grafana [inferred], Prometheus, Honeycomb, Seq [inferred]
- Swagger / Scalar
- AWS (integration)

## Speakers featured
- David Fowler — engineering lead on the Aspire team ("the boss")
- Maddy Montaquila — Associate Product Manager [inferred], Aspire
- PJ Meyer — listed speaker

## Follow-up resources
- aspire.dev — documentation, CLI download, and release information
- Aspire Discord
- Aspire YouTube live streams (most Fridays)
- VS Code YouTube channel — demo of using the Aspire dashboard as a standalone OpenTelemetry viewer
- Sample code for the demo app, to be uploaded the night of the session
