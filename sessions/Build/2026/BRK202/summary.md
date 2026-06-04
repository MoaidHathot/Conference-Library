<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK202\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK202\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:06.8968186+00:00
-->
# Summary

## Overview
Azure DevOps and GitHub are positioned as complementary platforms, with the integration between them serving as the on-ramp to an agentic software development lifecycle. The demo-heavy session shows how teams invested in Azure Boards, Pipelines, and Test Plans can harness GitHub Copilot's agentic capabilities, and previews new AI-powered features—code reviews, auto-fix, and a live migration tool—coming to Azure DevOps itself.

## Key announcements
- **Azure DevOps remote MCP server** *(~00:17:48)*: Two MCP servers (local and remote) now expose work items, repos, wiki, test plans, and pipelines; the remote server supports service principals, managed identities, and Microsoft Foundry agent creation, with Copilot Studio integration in progress.
- **Model selection for the Copilot cloud agent** *(~00:21:31)*: Rolling out the ability to pick the model used by the work-item-assigned coding agent, with the choice persisted ("sticky") per repository.
- **Enterprise Live Migrator (ELM)** *(~00:22:18)*: A public-preview, full-fidelity migration tool that moves Azure Repos to GitHub—including history, pull requests, and commits—with roughly 30 minutes of downtime and automatic reconnection of pipelines and boards.
- **Copilot code review for Azure Repos** *(~00:28:17)*: Brings GitHub Copilot code reviews to Azure Git repos without requiring a Copilot license or GitHub account, billed to the user's Azure subscription via a dynamic background pipeline.
- **Copilot Auto-fix for GitHub Advanced Security (Azure DevOps)** *(~00:34:34)*: Generates fixes for CodeQL alerts and opens a pull request automatically, with plans to expand to all alert types, third-party tools, and security campaigns.
- **Scale improvements** *(~00:19:55)*: Repos connectable per project per connection increased from 500 to 2,000, addressing customers wanting to connect tens of thousands of repos.
- **Apple Mac / pay-per-minute hosted agents** *(~00:43:46)*: Microsoft-hosted agents in Azure Pipelines with pay-per-minute billing are available for preview sign-up.

## Topics covered
- Hybrid patterns connecting GitHub repos with Azure Boards and Azure Pipelines
- Using the GitHub Copilot app as a low-barrier entry point for project managers living in Azure Boards
- Converting Azure DevOps wiki pages into Copilot custom agents and custom instructions
- Refining backlog work items with a custom "backlog manager" agent
- Linking GitHub Advanced Security campaigns and alerts to Azure Boards features and user stories
- Copilot CLI sharing the same MCP configuration as the Copilot app
- Work-item-to-commit/PR/branch traceability and licensing (GitHub Enterprise license includes a basic Azure DevOps license)
- Migration mechanics: validation, synchronization, and read-only cutover
- Billing visibility through Azure cost management for AI features
- Microsoft internal dogfooding of the migration path

## Notable quotes
> "We had a customer from last week who have 80,000 repos they want to connect to a project. That's 1.5 repo per every person in the company." — Dan Hellem

> "You don't even have to have a GitHub account whatsoever. It just magically kind of works on the back end... and as you use it, you get billed to your Azure subscription." — Dan Hellem

> "We want to fully harness GitHub Copilot's agentic power while continuing to leverage the investments you've made in Azure Boards, Azure Pipelines, test plans and more." — Dave Burnison

## Products and tools mentioned
- Azure DevOps (Azure Boards, Azure Repos, Azure Pipelines, Azure Test Plans, Azure Wiki)
- GitHub
- GitHub Copilot (app, cloud agent, CLI)
- GitHub Advanced Security (Copilot Autofix, security campaigns)
- CodeQL
- GitHub Copilot code review
- Azure DevOps MCP server (local and remote)
- Enterprise Live Migrator (ELM)
- GitHub Enterprise Importer
- GitHub Enterprise Cloud with data residency
- Microsoft Foundry
- Copilot Studio
- Visual Studio Code
- GitHub Codespaces
- Microsoft-hosted agents (Apple Mac, pay-per-minute)

## Speakers featured
- Dave Burnison — Senior DevOps Advocate at GitHub, formerly an advocate on the Azure DevOps team at Microsoft
- Dan Hellem — Program/Project Manager on Azure DevOps (Azure Repos, Boards, Wiki, and AI features)
- Lan Kaim — listed speaker (no spoken contribution in transcript)

## Follow-up resources
- Microsoft blog post (published the day before the session) covering the overall strategy plus sign-up for ELM, Copilot code reviews, and GitHub Advanced Security auto-fix
- GitHub blog post (published the day before) on Copilot apps and sandboxes
- Session demo repository containing all demo videos, slides, the blog post links, and a direct link to Enterprise Live Migrations
- Technical preview sign-up link for the three preview features (shown on slide)
