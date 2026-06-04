<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM313\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM313\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:27.8646427+00:00
-->
# Summary

## Overview
A live demo of Rayfin, a code-first, agent-friendly backend-as-a-service that deploys as an item inside Microsoft Fabric. The presenters show how a coding agent can scaffold and iteratively extend a full-stack field-operations app—complete with managed database, Fabric single sign-on, and backend services—while keeping development local before pushing to a Fabric workspace.

## Key announcements
- **Rayfin code-first SDK and CLI** — Provides a TypeScript SDK for defining data models, roles, and permissions in code, plus a CLI that streamlines local development and deployment to Fabric (00:01:05).
- **Template-based scaffolding via `npm create`** — A single command picks a starter template that pre-bakes dependencies and the agent "skills" needed to work seamlessly with coding agents (00:01:42).
- **One-command deploy with `rayfin up`** — Deploying provisions a managed database, static content hosting, and a Fabric single sign-on auth service without custom configuration (00:02:50).
- **Deployment as a Fabric item** — Rayfin apps are Fabric workspace items that inherit the workspace's capacity, CU billing model, and permission/sharing model (00:18:09).
- **Embedded Fabric portal view** — Beyond the browser, apps render inside the Fabric portal for internal/line-of-business scenarios (00:10:14).
- **Awesome Rayfin community template repo** — The demo's "field engineer" template is checked in and open to community contributions; any GitHub URL containing a Rayfin template (including private ones) can be passed to `npm create` (00:23:00).

## Topics covered
- Defining data models and relationships in TypeScript instead of T-SQL schema.
- CRUD operations through the SDK's data client (create, read, update, query multiple rows).
- Local development with a Docker Compose setup that spins up the database and Rayfin service locally.
- Local username/password testing versus Fabric single sign-on in production.
- Iterative feature development with a coding agent (adding title editing, an assignment dropdown).
- GraphQL used under the hood for data access and write-back operations.
- The GitHub Copilot desktop app's embedded editor view manipulating the app UI and console (including Playwright for external browsers).
- Fabric permission and sharing model for organization-wide discoverability and access control.

## Notable quotes
> "One good advantage of using like Rayfin with coding agents is because everything is code first. It has a lot of context and understands and they do a pretty good job to stay within the boundaries defined by the SDK." — Sunitha Muthukrishna

> "What's fun is that before this GitHub Copilot desktop app, this demo ran a little bit longer, so we usually have a couple of extra bugs to go shoot out." — Chris Anderson

> "You don't have to figure out how do I connect to a database. You don't have to figure out how do I set up the auth service because it's using Fabric single sign on." — Sunitha Muthukrishna

## Products and tools mentioned
- Rayfin
- Microsoft Fabric
- Fabric SQL database
- Fabric single sign-on
- GitHub Copilot (desktop app)
- VS Code
- Docker / Docker Compose
- GraphQL
- Playwright
- npm
- TypeScript

## Speakers featured
- Sunitha Muthukrishna — APM, Fabric app dev team
- Chris Anderson — Fabric app dev team; leads the accompanying hands-on labs

## Follow-up resources
- Rayfin documentation and GitHub repository (referenced on the resources slide).
- "Awesome Rayfin" repository, accepting community template contributions, including the field engineer demo template.
- Accompanying session GitHub repo containing the demo source code.
- Four hands-on labs driven by Chris and team.
- Expert booth meetup with Sunitha at 2:30 the day of the session.
