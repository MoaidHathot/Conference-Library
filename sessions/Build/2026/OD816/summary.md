<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD816\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD816\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:11.1328919+00:00
-->
# Summary

## Overview
Kim Manis, Corporate Vice President of Product for the Microsoft Fabric Platform, frames how Fabric reconciles the tension between fostering a broad data culture and enforcing security and governance as GenAI adoption accelerates. Through a series of role-based demos—tenant admin, capacity admin, workspace admin, and data/AI developer—the session shows governance, capacity management, and security capabilities centered on the OneLake catalog and how they extend into Office, Foundry, and developer tooling.

## Key announcements
- **OneLake catalog "Govern" tab with in-place actions** — Tenant admins get a single view of tenant health, insights across items, workspaces, capacities, and domains, plus recommended actions they can review and fix directly in the catalog (demo at 00:02:57).
- **Copilot in the governance report** — Admins can ask natural-language questions (e.g. which domain has the most unlabeled items) instead of running reports or exporting to Excel (00:04:52).
- **Default sensitivity label policies and tags at the domain level** — Newly created items are automatically protected, with delegation so domain owners fine-tune settings for their context (00:05:23).
- **Capacity surge protection with mission-critical workspaces** — Workspace- and capacity-level surge caps, plus marking workspaces mission-critical to exempt them from throttling (00:08:52).
- **Capacity overage and Real-Time Hub capacity events** — A 24-hour rolling CU limit for spikes and real-time alerts/triggers (e.g. Teams message when interactive delay hits 90%) (00:09:43).
- **Workspace-level security, generally available** — Outbound access protection, trusted workspace access, Azure Private Link, customer-managed keys, and workspace-level IP firewall rules (00:11:42).
- **Automated provisioning via Terraform Fabric provider and Fabric CLI** — A single pipeline run provisions a full medallion-architecture analytics project as code (00:15:53).
- **OneLake catalog integrated into 100+ surfaces, public APIs, and MCP** — Governance and security travel into Excel, Teams, Copilot Studio, and tools like Visual Studio Code via MCP (00:22:54).
- **Fabric in Foundry** — OneLake catalog is natively integrated into Foundry knowledge so agent developers can discover trusted data, with Fabric governance and role-level security carrying over (00:25:49).

## Topics covered
- Reconciling broad data access with governance and security under GenAI adoption
- Federated data mesh: domains, subdomains, workspaces, and delegated administration
- Microsoft Purview information protection labels, DLP, Insider Risk Management, and Data Security Posture Management
- Data residency, regional, and industry-specific certifications
- Layered capacity protection: surge protection, overage, real-time monitoring, chargeback apps
- Identity and network security: Entra Conditional Access, inbound/outbound networking, managed private endpoints
- OneLake security: item, folder, row, and column-level access control
- Data discovery, lineage, endorsement, and certification in the OneLake catalog
- Unifying structured and unstructured data via OneLake shortcuts for AI grounding

## Notable quotes
> "Microsoft Fabric is literally coaching you on how to become a better admin." — Speaker 1 (tenant admin demo)

> "Marketing can still run their reports; they just can't eat the whole buffet." — Speaker 1 (capacity admin demo)

> "This is what it looks like when governance isn't a bottleneck; it's an accelerator." — Speaker 1

## Products and tools mentioned
- Microsoft Fabric
- OneLake and OneLake catalog
- OneLake security
- Fabric IQ
- Fabric CLI
- Fabric MCP
- Microsoft Purview (Information Protection, DLP, Insider Risk Management, Data Security Posture Management)
- Microsoft Entra (Conditional Access)
- Azure Private Link
- Azure Data Lake Storage (ADLS) / Azure Blob Storage
- Amazon S3
- Snowflake
- Terraform (Fabric provider)
- Direct Lake
- Real-Time Hub
- Microsoft AI Foundry (Foundry knowledge)
- Microsoft Copilot / Copilot Studio
- Power BI
- Microsoft Teams, Excel, PowerPoint
- Visual Studio Code
- SharePoint

## Speakers featured
- Kim Manis — Corporate Vice President of Product, Microsoft Fabric Platform
- Speaker 1 — presenter of tenant admin, capacity admin, workspace admin, and data engineer demos (unnamed)
- Speaker 2 — presenter of the automated provisioning demo (unnamed)
- Speaker 3 — presenter of the Fabric in Foundry demo (unnamed)

## Follow-up resources
- Fabric capacity guidance white paper
- Fabric security white paper
