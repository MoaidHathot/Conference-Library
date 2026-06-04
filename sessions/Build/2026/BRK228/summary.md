<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK228\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK228\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:37.6098370+00:00
-->
# Summary

## Overview
This advanced session reframes Azure resiliency as an agent-first practice spanning the full lifecycle—start resilient, get resilient, and stay resilient—across infrastructure, data, and cyber pillars. Through live demos, the presenters show how the resiliency agent in Azure Copilot and Azure Advisor tooling via the Azure MCP server identify and remediate resiliency gaps from the IDE to the Azure portal. The throughline is shifting business continuity planning from individual resources to whole applications using service groups.

## Key announcements
- **Public preview of Azure Infrastructure Resiliency Manager** *(~00:07:08)*: Lets customers manage zonal resiliency through application-level goals, Advisor-powered recommendations, resiliency drills, and recovery plans.
- **Resiliency drills powered by Chaos Studio** *(~00:07:53)*: Simulate failures such as an availability-zone outage to test an application's resiliency posture.
- **Recovery plans** *(~00:08:25)*: Define an ordered workflow capturing interdependencies for failing over resources like databases and VMs during an actual outage.
- **Azure Advisor AI-powered prioritization experience enters limited preview** *(~00:42:53)*: Collapses hundreds of recommendations into a top-five prioritized, exportable action plan ranked by blast radius, criticality, deadlines, and cost; sign-ups offered after the session.
- **AI-powered resource-level prioritization (landing soon)** *(~00:34:25)*: Will rank individual resources within a recommendation using live signals such as active service health events and prod/non-prod distinctions.
- **Chaos Studio Workspaces public preview on June 11** *(~00:43:54)*: An application-centric reimagining with new scenarios and a new agentic service for rehearsing feared outages.

## Topics covered
- Three pillars of resiliency: infrastructure, data, and cyber resiliency
- The resiliency lifecycle: start resilient, get resilient, stay resilient
- Azure resiliency primitives: availability zones, region pairs, geo-replication, backup, RPO/RTO targets
- Generating zonally resilient infrastructure-as-code (Bicep) from natural-language intent
- Scanning Terraform/ARM templates against Advisor's recommendation catalog in the IDE and auto-fixing drift, including retiring SKUs
- Service groups for application-level (vs. resource-level) business continuity planning
- Assigning zonal resiliency goals, posture checks, prerequisite checks, and enabling HA on brownfield apps
- Configuring vaulted, immutable backups for cyber resiliency against ransomware with long-term retention
- AI-driven recommendation prioritization with short/mid/long-term action plans and planned Jira/ServiceNow work-item integration

## Notable quotes
> "Resiliency is not a one time setup, it's an ongoing exercise."

> "Every Azure customer believes that they are resilient until and unless an availability zone goes down, your AI workload silently degrade, or a throttling cascades down to take out checkout during Black Friday."

> "You can go from gaps identified to fix committed in a matter of minutes. Your code and your infrastructure is resilient even before it touches Azure."

## Products and tools mentioned
- Azure Resiliency (in Azure Business Continuity Center)
- Azure Infrastructure Resiliency Manager
- Resiliency agent in Azure Copilot
- Azure Copilot
- GitHub Copilot
- Azure MCP server
- Azure Advisor (AI-powered experience)
- Azure Backup
- Azure Chaos Studio / Chaos Studio Workspaces
- Azure Site Recovery [inferred] (referenced as "ASR")
- Service groups
- Resiliency drills and recovery plans
- Azure portal, PowerShell, Azure CLI
- VS Code
- Bicep, ARM templates, Terraform
- Azure PostgreSQL Flexible Server, Virtual Machine Scale Sets (VMSS), Azure Key Vault, Cosmos DB, Azure Container Registry, Redis Cache, App Service, Storage accounts

## Speakers featured
- Rochak Mittal
- Adity Agarwal
- Shobhit Garg

(Note: the transcript audio identifies the presenters as "Abhimanyu," "Aditi," and "Shobhit"; the session metadata lists the names above.)
