<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK225\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK225\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:35.6903879+00:00
-->
# Summary

## Overview
Rayfin is a backend platform for the AI coding era that lets developers and agents define an entire application backend—database, functions, storage, and access policies—in code, then deploy it to Microsoft Fabric with a single CLI command. The session demonstrates building both an operational delivery app and an analytics dashboard, and shows how Fabric provides enterprise-grade security, compliance, and unified data access through OneLake.

## Key announcements
- **Rayfin, the backend for the AI coding era** *(00:02:34)* — An SDK and CLI for authoring a full backend (database, functions, storage, access policies) in code, deployable to Fabric with one command for out-of-the-box enterprise security and compliance.
- **App as a new Fabric artifact type** *(00:18:51)* — Apps can be created directly from the Fabric portal via "new item," generating a deployed app artifact with a child SQL database in the workspace.
- **Data app template with Power BI** *(00:15:45)* — A template co-built with the Power BI team for building applications directly on the semantic layer, comprising a data package, a React/Vega-Lite visual package, and agent skills.
- **Connectors for existing Fabric data** *(00:12:36)* — Declarative connectors let apps read from and write back to databases, warehouses, and semantic models in OneLake, with agent instructions that pull schemas into typed classes.
- **Replit partnership** *(00:25:50)* — Replit's browser-based agentic IDE can build and deploy apps into a Rayfin environment for non-technical users, announced on stage with Satya Nadella the prior day [inferred] and currently in private beta.
- **Roadmap commitments** *(00:29:10)* — Upcoming support for functions, RBAC, additional OneLake and Blob storage connectors, OIDC and social login, real-time services, a perpetual free tier, and open-sourcing part of the Rayfin runtime for self-hosting.

## Topics covered
- Defining database tables, column constraints, and relationships using TypeScript decorators (`@entity`, property decorators)
- Code-defined security via role decorators and policy functions (e.g., authenticated users seeing only their own records)
- Automatic schema migration when the data model changes
- YAML configuration: SQL dialect selection (Microsoft SQL now, Postgres planned), front-end/back-end separation, shared backends, and per-app scopes
- Backend TypeScript functions deployed as sandboxed Fabric functions for secure credential injection and external service calls
- Templates for organizational standardization, including tools, MCP servers, sample code, and libraries
- Fabric advantages: OneLake as the "OneDrive for data," SaaS provisioning, unified capacity billing, and a dev-to-staging-to-production workspace workflow
- Local development against remote or Docker-based (experimental) services

## Notable quotes
> "Rayfin is the back end for this new AI coding era." — Ben Zulauf

> "For years, applications and analytics lived in separate worlds... But Rayfin brings that together, and now our data app template does something really unique because it's allowing you to build applications directly on your semantic layer." — Sujata

> "With Rayfin, we finally have both fast development and the tools we prefer and the confidence that our applications were on top of our enterprise data platform." — Carl, quoting test user Leatherman

## Products and tools mentioned
- Rayfin
- Microsoft Fabric
- OneLake
- Fabric SQL database
- Power BI
- Semantic models
- Vega-Lite
- React
- VS Code
- GitHub Copilot coding agent
- Replit
- Microsoft SQL Server
- PostgreSQL
- Azure
- Docker
- Blob storage
- MCP servers

## Speakers featured
- Ben Zulauf — presenter, Rayfin team
- Sachin Patney — presenter, Rayfin team
- Sujata — Power BI team [inferred]
- Carl — Technical Lead at Replit, leading the Rayfin and Fabric integration
- Chris Anderson — Rayfin team (referenced as leading a later 3:00 session)

## Follow-up resources
- github.com/Microsoft/Rayfin — to try Rayfin and provide feedback
- Replit private preview sign-up
- Additional Rayfin session with Chris Anderson, same day at 3:00
