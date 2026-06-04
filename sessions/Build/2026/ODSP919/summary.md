<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP919\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP919\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:57.8537820+00:00
-->
# Summary

## Overview
The session demonstrates how Oracle's managed MCP (Model Context Protocol) servers connect Oracle Database@Azure to Microsoft's IQ intelligence layer—Foundry IQ, Fabric IQ, and Work IQ—to build governed, business-aware enterprise agents. Using an accounts-payable scenario, the presenters show an agent reasoning over live Oracle invoice data, grounding against compliance documents, and drafting an email response without ETL or custom connection code.

## Key announcements
- **Managed, hosted Oracle MCP servers for Oracle Database@Azure** *(00:03:22)* — Oracle offers native, managed MCP servers in both Oracle Cloud Infrastructure and for databases running at Azure, with the MCP server itself provided at no additional cost (customers pay only for database and AI tooling usage).
- **MCP servers for Oracle AI Database since July** *(00:03:17)* — Oracle has shipped MCP server support for its AI Database, extending now into cloud-hosted managed offerings.
- **End-to-end identity propagation via Entra ID and OAuth 2** *(00:06:44)* — A user's Azure Entra ID identity is propagated into the Oracle database itself through an OBO token flow, so the database applies its own security rules to the agent's queries as if the user connected directly.

## Topics covered
- Four-layer architecture: dev surface, intelligence (IQ) layer, Oracle data/Atlas layer, and governance plane.
- Two data-access patterns: Oracle MCP server for live reads versus Fabric Mirroring for historical and cross-source analytics, with the same agent code running either way.
- Configuring an Oracle MCP server: database connection credentials, identity domain, MCP server groups, and MCP tools (including natural-language-to-SQL).
- Registering an agent as an MCP client and the OAuth 2 / OBO authorization workflow.
- Building an accounts-payable analyst agent in Azure AI Foundry and wiring it to Foundry IQ, Work IQ, and Fabric IQ.
- Knowledge bases drawing from compliance reports in Microsoft OneLake and vendor/contract documents in Azure Blob Storage.
- Human-in-the-loop query approval and least-privilege agent identity governance via Entra Agent ID and Agent 365.

## Notable quotes
> "MCP, so Model Context Protocol, really came onto the scene in late 2024 and caught on like wildfire all throughout 2025." — Jeff Smith

> "I like to tell people that you're the actual pilot, not the Copilot." — Jeff Smith

> "The agent is talking to your mission critical enterprise data residing in Oracle databases, so you better be conscious about what the agent is accessing, why is it accessing, and what's the outcome of it?" — Ram Kakani

## Products and tools mentioned
- Oracle Database@Azure
- Oracle managed MCP Server / Oracle Remote MCP Server
- Microsoft IQ (Foundry IQ, Fabric IQ, Work IQ)
- Azure AI Foundry / Foundry Agent Service
- Copilot Studio
- GitHub Copilot
- Microsoft Entra Agent ID
- Agent 365
- Oracle Autonomous AI Database
- Oracle Exadata Database (including Exascale infrastructure)
- Oracle Base Database Service
- Oracle GoldenGate
- Fabric Mirroring
- Microsoft OneLake
- Azure Blob Storage
- Oracle APEX
- Outlook, Teams, Excel

## Speakers featured
- Jeff Smith — Product Manager, Oracle (covers MCP servers for Oracle Database)
- Ram Kakani — Product Manager, Oracle Database@Azure team, Microsoft

## Follow-up resources
- LinkedIn community for Oracle Database@Azure users (referenced via on-screen link/QR code)
- Pricing and technical details link (referenced as the third on-screen link/QR code)
- Invitation to schedule a call with Oracle engineers to set up Oracle Database@Azure and MCP servers
- Jeff Smith online via the handle "ThatJeffSmith"
