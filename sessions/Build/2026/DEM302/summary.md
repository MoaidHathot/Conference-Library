<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM302\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM302\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:05.2915316+00:00
-->
# Summary

## Overview
A live, 25-minute demonstration of building and deploying a multi-agent Azure AI application entirely through GitHub Copilot agents and Foundry tooling, without manually writing code. Rong Lu builds a "Zava" customer-insights agent team in VS Code while Brady Gaster adds a React front end and deploys to Azure using a multi-agent Copilot framework called Squad.

## Key announcements
- **Zava customer-insights multi-agent system** *(00:01:12)* — A team of four agents (classifier, enrichment, triage, aggregate) that analyzes customer feedback sentiment and triggers actions such as drafting replacement emails.
- **Foundry skill in the Foundry Toolkit VS Code extension** *(00:05:06)* — Supplies Copilot with up-to-date knowledge of the new Microsoft Agent Framework and Microsoft Foundry service so it can scaffold agents correctly.
- **Foundry toolbox with unified endpoint and authentication** *(00:08:09)* — Packages multiple tools (Azure AI Search over a product catalog and a Fabric IQ connector to customer/order data) behind a single endpoint, attached only to the enrichment agent.
- **Agent Inspector tool** *(00:10:22)* — Part of the Foundry Toolkit VS Code extension; visualizes agent workflows live, acts as a playground, captures runtime events, and supports normal debugging.
- **Copilot-generated evaluations via Foundry MCP server** *(00:13:09)* — Copilot generated a 10-row test dataset and evaluators and submitted the evaluation directly to the Foundry service.
- **Deploy hosted agent command** *(00:14:55)* — A wizard pushes the locally running agent to the Foundry service as a fully managed, observable hosted agent, with log streaming that Copilot can read to fix errors.
- **Squad multi-agent framework for GitHub Copilot** *(00:16:41)* — An open-source tool Gaster built with Tamir [inferred] that spins up a team of specialized Copilot agents, each with a distinct job, to reach results faster than single-threaded conversation.

## Topics covered
- Plan mode in Copilot to discuss architecture before implementation to reduce cost
- Orchestrating four agents with conditional flows in a single workflow function (Microsoft Agent Framework)
- Connecting Foundry-hosted agents to Microsoft Fabric data via the Foundry toolbox
- Running agents locally against cloud Foundry models and tools before deployment
- Scaling from prototype to production through formal evaluations
- Azure MCP server and Azure skills (markdown files instructing Copilot how to combine MCP tools)
- Provisioning Azure Foundry and Azure Container Apps infrastructure (IaC) authored by Squad agents
- Deploying front end and back end with AZD, including a post-deployment hook for Foundry-specific steps
- Reusing one Foundry model instance across two compute hosts authenticated via managed identity
- Auto-generated reports documenting agent work, tools, and skills consulted

## Notable quotes
> "I did not write a single line of code here, but I will show you real quick the code that Copilot generated." — Rong Lu

> "If you just send all the agents the same instructions, they're going to fight over work like Hungry Hungry Hippos." — Brady Gaster

> "Squad wrote that infra in the hotel room last night because I'm too lazy to do it myself." — Brady Gaster

## Products and tools mentioned
- GitHub Copilot (app and CLI)
- Squad (multi-agent framework for GitHub Copilot)
- VS Code
- Microsoft Agent Framework
- Microsoft Foundry service
- Foundry Toolkit VS Code extension
- Foundry skill / Foundry MCP server
- Agent Inspector
- Foundry toolbox
- Azure AI Search
- Microsoft Fabric / Fabric IQ connector
- Azure MCP server
- Azure Container Apps
- Azure Developer CLI (AZD)
- Azure Log Analytics
- React
- Managed identity (Azure)

## Speakers featured
- Brady Gaster — GitHub (joined a couple weeks prior); co-creator of Squad
- Rong Lu — Program Manager, Microsoft
