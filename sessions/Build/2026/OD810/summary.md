<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD810\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD810\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:42:43.1971526+00:00
-->
# Summary

## Overview
The session addresses the gap between AI-generated prototypes and production-ready applications, arguing that 80-90% of vibe-coded prototypes never ship because the bar for production-grade auth, data integrity, governance, and deployment hasn't lowered. It demonstrates RayFin, a managed backend-as-a-service built on Microsoft Fabric, by building and deploying a recipe-sharing app ("Contoso Chef") end-to-end with a coding agent.

## Key announcements
- **RayFin, a Fabric-native managed backend-as-a-service (00:02:48)** — A complete platform for web apps providing a managed database, authentication, hosting, functions, storage, and real-time services, built to be enterprise-ready from day one.
- **Agent-first bootstrapping via the RayFin CLI (00:08:05)** — Projects scaffolded with the CLI ship with a built-in RayFin skill and MCP server that teach coding agents how to use the SDK and load documentation.
- **TC39 standard decorators for type-safe schemas (00:12:42)** — Entity schemas are defined as TypeScript classes using standard upcoming-JavaScript decorators rather than framework-specific ones, for future-proofing.
- **One-command deploy to production via `npx rayfin up` (00:27:21)** — The same command that provisions the backend, API endpoints, and Fabric database also puts the app in production, so dev and prod share one foundation.
- **Automated schema migrations with `rayfin db apply` (00:24:15)** — RayFin analyzes entities against the live database, generates a migration, and applies it (versioning the schema), or redeploys backend and migrates in one step.
- **Analytics app template for Fabric (00:30:10)** — A new (early preview) template lets the app's data flow into dashboards via semantic models, with an AI design skill for polished visuals.

## Topics covered
- The prototype-to-production gap and why vibe-coded apps fail (outages, security, data leaks).
- Identity and access control implemented as backend read/write policies on entities (private, unlisted/shared-by-link, public visibility).
- Type-safe entity modeling, entity relations (recipes, likes, comments), and the generated `schema.ts`.
- Safe schema evolution and migrations as apps change after launch.
- Fabric-native data estate enabling governance, analytics, and AI access from day one.
- "Vibe coding with guardrails" — agents focused on app experience while the platform supplies primitives (auth, database, GraphQL APIs).

## Notable quotes
> "What used to take months to build a prototype now takes minutes. The risk, though, is treating the first working demo as the production foundation."

> "While the development speed for apps is now faster than ever, the bar for production-grade apps still hasn't changed."

> "The fastest path to production starts with the right foundation."

## Products and tools mentioned
- RayFin
- Microsoft Fabric
- GitHub Copilot CLI
- Visual Studio Code
- Microsoft SQL database (Fabric)
- MCP server (RayFin)
- npm / npx
- TypeScript
- GraphQL
- Power BI semantic models [inferred]

## Speakers featured
- Yohan Lasorsa — Principal Developer Advocate, Microsoft

## Follow-up resources
- RayFin documentation (referenced verbally at 00:33:23; no URL provided in the transcript).
