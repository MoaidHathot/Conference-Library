<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD817\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD817\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:09.5459877+00:00
-->
# Summary

## Overview
This intermediate session demonstrates how AI agents, skills, and MCP servers are being integrated across Power BI and Microsoft Fabric to accelerate analytics development. Emily Lisa covers end-to-end agentic creation of semantic models and reports, while Sujata Narayana introduces the newly released Fabric apps for building enterprise-grade custom web applications on analytics data.

## Key announcements
- **Power BI report authoring skill shipped at Build** ([00:04:56]) — A new skill in the Fabric Skills repository that creates net-new reports and edits existing ones via the PBIP file in Power BI Desktop using natural language.
- **Power BI modeling MCP server from web modeling view** ([00:04:07]) — A "Copilot" button in web model view opens a side chat for natural-language changes to DAX measures, relationships, and column properties, described as coming soon.
- **Fabric apps for enterprise-grade applications** ([00:12:39]) — A Fabric backend (project name Rayfin) offering a CLI/NPM-based, AI-friendly experience for building production-ready custom web apps backed by Fabric.
- **Data app template** ([00:14:17]) — A Fabric apps template combining a secure data package, a Vega-Lite/React visual package, and agent skills, selectable via the NPM create command or directly in Fabric.

## Topics covered
- Greenfield versus brownfield analytics scenarios (building from scratch versus enhancing existing models and reports).
- The Skills for Fabric GitHub repository spanning lakehouses, notebooks, reports, and semantic models.
- Natural-language semantic model authoring, including applying organizational best practices from a shared markdown file.
- AI-assisted report theming and styling from reference images and company logos.
- Plan mode in GitHub Copilot CLI for reviewing layout options before applying changes.
- Limitations of "vibe-coded" apps that miss enterprise security, governance, and reliability.
- Building custom web apps on semantic models with live data, optimized queries, and Vega-Lite visuals.
- Spec-driven (markdown) app generation and iterative customization (personas, dark mode, calendar tabs, Outlook integration).
- Roadmap: additional data sources (SQL DB, lakehouse, warehouse), out-of-the-box signal detection, custom actions, and embedded scenarios.

## Notable quotes
> "It really helps you a lot of the heavy lifting of all those operations that traditionally take a long time with doing draggy, clicky, clicky, draggy, droppy operations. Now you can use natural language for all of them." — Emily Lisa

> "Even though AI helps you get 80% of the way, that additional 20% of making it ready for production, if it's not there, it's just not enough to have to your customers or your end users." — Sujata Narayana

> "It's really about bringing your data alive and really customizing your app however you want, and doing so in a prompt-based way." — Sujata Narayana

## Products and tools mentioned
- Power BI
- Microsoft Fabric
- Power BI Desktop
- Skills for Fabric (Fabric Skills repository)
- Power BI modeling MCP server
- Power BI model authoring skill
- Power BI report authoring skill
- PBIP file format
- GitHub Copilot CLI
- VS Code
- Fabric apps (project name Rayfin)
- Data app template
- Vega-Lite
- React
- DAX
- Lovable
- Streamlit
- Microsoft Outlook

## Speakers featured
- Emily Lisa — Principal Group Product Manager, Microsoft
- Sujata Narayana — Principal Group Product Manager, Microsoft
- Injae Park — Microsoft MVP [inferred], cited as building enterprise analytics web apps
- Reid Havens — Microsoft MVP [inferred], cited as building enterprise analytics web apps

## Follow-up resources
- Blog: aka.ms/Azure-Data-Build26
