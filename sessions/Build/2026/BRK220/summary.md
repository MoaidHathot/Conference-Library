<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK220\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK220\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-06T08:21:04.7787764+00:00
-->
# Summary

## Overview
This advanced session demonstrates how GitHub Copilot Modernization and Azure Copilot combine into an end-to-end agentic system for modernizing legacy application portfolios at scale. The presenters argue modernization is now a continuous, governed lifecycle—spanning assessment, planning, code transformation, and deployment—rather than a one-time per-app project, and show live journeys upgrading mainframe, Java, and .NET workloads.

## Key announcements
- **Modernization Agent in the CLI is generally available** — Orchestrates simultaneous assessments and migration plans across an entire app portfolio, with end-to-end automated Java and .NET framework upgrades (00:09:55).
- **Custom skills generally available** — Lets teams encode their own migration patterns, internal libraries, and Azure best practices once and reuse them across the portfolio (00:10:23).
- **Command Center in Private Preview** — A self-hostable portal giving a portfolio-level dashboard of modernization status, timelines, and comparable assessment reports (00:25:30).
- **Rulebooks in Private Preview** — Centrally encode governance, security, and architecture standards so agents modernize with guardrails and auto-generate compliance reports (00:27:16).
- **Mainframe modernization added to GitHub Copilot Modernization** — Reverse-engineers COBOL, JCL, and BMS into per-program documentation, then reimagines it as native Java with a native SQL data layer, delivered with partner experts (00:12:28).
- **ASP.NET Web Forms and Aspire scenarios in Private Preview** — Converts Web Forms apps to Blazor, adds Aspire orchestration, and deploys to Azure Container Apps (00:33:42).
- **Azure Migrate to GitHub Copilot handoff** — A seamless configuration-file handoff lets IT-led on-prem discovery flow into developer code assessment, with reports returned to Azure Migrate storage (00:22:23).

## Topics covered
- Continuous modernization lifecycle: assess, plan, execute, innovate, observe, troubleshoot, optimize
- Three pillars of enterprise modernization: scale, customization, and governance
- Parallelized cloud coding agents working across tens of thousands of applications
- Reverse-engineering legacy mainframe code into documentation, call graphs, and data lineage
- Struts-to-Spring Boot (Java 21) and Web Forms-to-Blazor transformations
- Security woven throughout: CVE/CWE scanning, deprecated API detection, secrets moved to Key Vault
- Custom skills for internal patterns (Kafka to Azure Event Hubs, PII-safe logging)
- Aspire as a polyglot code-first orchestration and observability layer

## Notable quotes
> "Before agents, this was hand-to-hand combat. A few apps at a time, that's it." — Jeff Fritz

> "Isn't it cool now the agents have rules too?" — Nish Anil

> "GitHub Copilot modernization has completely changed how we think about .NET upgrades. Fully automated, customized, cloud-driven upgrades just work, and they make it the first tool any team should reach for." — Jordan Cleigh [inferred], Staff Platform Engineer at FMG (quoted by Jeff Fritz)

## Products and tools mentioned
- GitHub Copilot Modernization
- Azure Copilot (Preview)
- Modernization Agent (CLI)
- Command Center
- Rulebooks
- Custom skills / Skills Library
- Azure Migrate
- Visual Studio Code, Visual Studio
- .NET Aspire
- Azure Container Apps
- Azure Key Vault
- Azure Event Hubs
- OpenTelemetry
- Blazor (Server)
- Spring Boot, Java 21, .NET 10
- Cloud Adoption Framework landing zones

## Speakers featured
- Jeff Fritz — Principal Program Manager, GitHub Copilot Modernization team
- Nish Anil — GitHub Copilot Modernization team
- Hazem El-Hammamy — GitHub Copilot Modernization team

## Follow-up resources
- aka.ms/ghcp-modernization — entry point for the Microsoft Learn documentation
