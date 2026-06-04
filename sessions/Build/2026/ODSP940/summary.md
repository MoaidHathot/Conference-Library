<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP940\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP940\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:45:22.0359953+00:00
-->
# Summary

## Overview
This session demonstrates how Bolt, integrated with Microsoft Azure and Microsoft 365, enables enterprise teams to move from AI-driven prototyping to governed, production-ready applications. The presenters argue that speed alone is insufficient for enterprises, and show how Bolt fits into existing applications, design standards, and security requirements while keeping developers in control of code, foundations, and deployment paths.

## Key announcements
- **Bolt integration with Microsoft Copilot** *(00:03:34)*: Teams can structure a project brief in Microsoft Copilot and tag the Bolt agent directly to send specifications over and trigger a build without losing requirements.
- **Bolt CLI for programmatic interaction** *(00:02:49)*: Developers can bundle a local component library, connect existing repos and workflows, and publish an approved design system into Bolt.
- **Design systems as a shared foundation** *(00:08:00)*: Bolt can ingest code, design artifacts, and documentation to generate a navigable Storybook instance so new projects start from approved components rather than a blank canvas.
- **Plan mode** *(00:12:32)*: An agent mode that previews what will be implemented before building, intended to save time and tokens.
- **Built-in database security scan** *(00:14:44)*: Projects can be scanned for issues before publishing directly to a live site.

## Topics covered
- Limitations of blank-canvas AI app builders for enterprises with existing applications and governance
- Fitting AI-generated code into Azure, GitHub, and Azure DevOps workflows with Microsoft identity and security tooling
- Turning conversations and requirements into a structured project brief via Copilot
- Packaging a local component library (as a tarball or via a private NPM/MPM registry) for reuse across projects
- Real-time team collaboration: shared project URLs, agent chat visibility, and queued comment-driven fixes
- Adding user authentication, email/Google sign-in, user management, and databases to a generated app
- Creating a server function that calls an external model API, with secure secret storage for API keys

## Notable quotes
> "The developer problem is not just, can AI generate an app? It is, can this fit into what we already have?" — Will

> "The core value proposition here is that we're starting to take some of the overall non-deterministic qualities of the agents, remove some of that and give you back the control of actually what's produced." — Joe

> "So Bolt is not just a faster way to generate an app, but it's a controlled path from idea to application." — Will

## Products and tools mentioned
- Bolt (bolt.new)
- Bolt CLI
- Microsoft Azure
- Microsoft 365
- Microsoft Copilot
- GitHub
- Azure DevOps
- Visual Studio Code
- Storybook
- OpenAI GPT-5 [inferred]
- Claude Opus 4.7 [inferred]
- NPM private registry

## Speakers featured
- Will (William Sayer), Bolt
- Joe (Joe Keyes), Bolt — speaking from the developer's perspective

## Follow-up resources
- Bolt YouTube channel (bolt.new)
