<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD849\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD849\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:50.8803893+00:00
-->
# Summary

## Overview
This advanced session demonstrates the Dataverse plugin (also called the Dataverse Skills plugin) for coding agents, which embeds governed Dataverse operations directly into the coding tools teams already use. Through three personas—a builder, a CRM analyst, and a platform admin—the presenters show how plain-English prompts drive schema creation, data import, CRM queries, and security configuration without portals, FetchXML, or GUIDs. The unifying thesis: one install and one pattern lets different roles turn business intent into validated, solution-packaged Dataverse work.

## Key announcements
- **Dataverse plugin for coding agents** *(00:00:37)* — A single capability embedded in existing coding tools that turns business intent into governed Dataverse operations across schemas, data, queries, security, and admin tasks.
- **Identity-based environment discovery** *(00:01:51)* — The agent discovers the user's Dataverse environment from their Microsoft sign-in and configures the MCP server, requiring no org URL, config files, or setup docs.
- **Skill-based execution with on-demand tooling** *(00:04:37)* — Plugin skills such as DBQuery and DVData encode best-practice knowledge and generate tools on the fly, using the Python SDK behind the scenes to parse Excel files and run generated scripts.
- **Inline security simulation** *(00:15:52)* — The agent validates a security model by simulating each user's access and returning a pass/fail table, replacing manual private-browser impersonation.

## Topics covered
- One-prompt data model creation including choices, lookups, self-referential lookups, and many-to-many relationships, packaged into a solution.
- Importing real Excel reference data using business keys (not GUIDs) to resolve lookups, with failure reporting.
- Row-count and relationship validation as a post-import sanity check.
- Natural-language CRM analysis: scoped opportunity queries, named-user scoping via the system user table, and reorder-gap analysis joining account and opportunity tables.
- Logging activities and notes, completing tasks, and inferring activity type, regarding object, owner, and participants from a single sentence.
- Security administration: business units, custom roles, field-level security, access team templates, user assignments, and pre-flight privilege checks.
- Multi-layer auditing (org, table, column) and controlled record sharing via principal object access.

## Notable quotes
> "What if your developer, your operations analyst, and your admin could all describe what they need in plain English and get it done?" — Suyash Kshirsagar

> "And notice she said Carlos by name. The agent looked him up in the system user table automatically and scoped the query to his records." — Kent Weare

> "45 minutes of Thursday afternoon collapsed into 5 minutes of intent. Same plugin Maya used, different operator, different job, same pattern." — Suyash Kshirsagar

## Products and tools mentioned
- Microsoft Dataverse
- Dataverse plugin for coding agents (Dataverse Skills plugin)
- MCP server
- DBQuery skill
- DVData skill
- Python SDK
- Maker Portal
- Microsoft sign-in / Microsoft identity

## Speakers featured
- Kent Weare — Product Manager, Microsoft
- Suyash Kshirsagar — Software Engineering Manager, Microsoft
