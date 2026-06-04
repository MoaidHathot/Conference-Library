<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD801\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD801\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:33:24.7504168+00:00
-->
# Summary

## Overview
Azure App Service product managers present a modernization path for legacy .NET applications that avoids full rewrites: Managed Instance on Azure App Service brings Windows dependencies into a PaaS foundation, while new Built-in MCP support turns existing REST APIs into AI-consumable tools. The session pairs platform capabilities with GitHub Copilot app modernization tooling and ends with a full demo migrating an ASP.NET Framework web app.

## Key announcements
- **Built-in MCP for Azure App Service (public preview)** — Announced at Build [00:13:01], it detects an application's APIs and exposes them as MCP tools secured via managed identity, OAuth, and RBAC, supporting .NET, Java, Node.js, and Python.
- **Agent observability in App Service** — A new capability surfacing agent counts, call volume, token usage, and error rates over the last 30 days, with drill-through into Application Insights logs [00:45:01].
- **Managed Instance on Azure App Service (public preview)** — Recapped from Ignite in November [00:05:06], it preserves Windows and third-party dependencies, supports registry access, drive-letter storage mounts, and custom install scripts, and runs on the Premium v4 SKU.
- **Secure RDP access via Azure Bastion** — For the first time in Azure App Service, instances can be reached through Azure Bastion for troubleshooting with familiar tools like Event Viewer, Registry Editor, and IIS Manager [00:11:24].

## Topics covered
- Modernization challenges: legacy OS dependencies (MSMQ, GDI), stateful vs. stateless design, scattered configuration and secret management, and lengthy migration timelines.
- Preserving Windows dependencies with zero or minimal code changes using PowerShell install scripts (`install.ps1`) packaged with MSIs.
- Cloud-native benefits: horizontal and vertical scaling, availability zones, managed identity, Key Vault-backed secrets, and operational offloading of patching and maintenance.
- Incremental modernization as a pathway versus full rewrites.
- Storage mounting to Azure Files, UNC shares, or local (non-persistent) drives, and registry values stored as Key Vault secrets.
- Agentic application patterns: domain-specialized agents with an orchestrator selecting execution sequences.
- Converting an inventory REST API into an MCP server via an OpenAPI-compliant JSON spec, then consuming it from GitHub Copilot.
- Using GitHub Copilot app modernization tooling in Visual Studio to run assessments comparing migration targets (Managed Instance shows zero mandatory blockers vs. two for App Service Windows sandbox).

## Notable quotes
> "To be honest, we're aiming for zero code changes as well." — Andrew Westgarth

> "So that's how easy we are making it for you to go ahead and reuse your REST APIs as MCP servers." — Gaurav Seth

> "Remember, local mounts are the formally nature, meaning for any reason if this instance gets restarted, any content which is on this local file share will get lost." — Gaurav Seth

## Products and tools mentioned
- Azure App Service
- Managed Instance on Azure App Service
- Azure App Service Built-in MCP
- GitHub Copilot app modernization tooling
- Visual Studio
- Azure Bastion
- Azure Key Vault
- Azure Files
- Application Insights
- Premium v4 (Pv4) SKU
- Azure SQL
- Hyper-V
- ASP.NET Framework
- .NET Core
- log4net [inferred]
- OpenAPI

## Speakers featured
- Andrew Westgarth — Product Manager, Azure App Service
- Gaurav Seth — Product Manager, Azure App Service

## Follow-up resources
- App Service @ Build 2026 blog (App Service announcements)
- A three-article series on agentic app development with .NET
- Documentation overviews for Managed Instance on Azure App Service
- Documentation on the GitHub Copilot app modernization tooling
- Gaurav Seth's blog article on an agentic IIS migration pathway to Managed Instance (source code downloadable from GitHub)
