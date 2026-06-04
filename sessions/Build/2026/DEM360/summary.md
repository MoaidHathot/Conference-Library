<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM360\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM360\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:59.9064188+00:00
-->
# Summary

## Overview
This intermediate demo session shows how Power Apps and Dataverse data can be made discoverable and actionable inside Microsoft 365 Copilot through the Power Apps Model Context Protocol (MCP), now in public preview. Christine Flora walks through enabling the MCP on a Power App, using its out-of-the-box CRUD tools, and building custom tools with rich Fluent UI generated via VS Code and Claude.

## Key announcements
- **Power Apps MCP is in public preview** [00:01:31] — Available now through the preview Maker portal so developers can expose app data to M365 Copilot.
- **Enabling the MCP yields four standard CRUD tools** [00:14:40] — Turning on the Copilot MCP setting automatically provides create, read/review, edit/update, and query tools against the app's Dataverse data.
- **Custom MCP tools with targeted Dataverse fields** [00:10:54] — Developers can build custom tools that pass specific selected fields (rather than whole tables) to produce focused data insights at a prompt.
- **Fluent UI generation via Claude/GitHub Copilot skill** [00:18:46] — Microsoft provides a Power Platform skill for Claude and GitHub Copilot that turns a tool's JSON structure into a Fluent UI HTML file, with local preview against sample data.
- **Declarative agent packaging for M365** [00:23:36] — Each set of tools can be downloaded as a declarative agent zip file and uploaded into Microsoft 365 (e.g., Teams) for end users.

## Topics covered
- Power Platform as a suite for business makers and pro developers to build apps, automate processes, and create AI-driven solutions
- MCP described as a "universal translator" exposing app data to agentic experiences, including autopilots and Work IQ
- Accessing an app's agent in Copilot via the agent picker or by @-mentioning it so every prompt routes to the app
- Real-time, fully interactive UI surfaced in Copilot for viewing and editing live app records without leaving context, with the option to jump into the app at the current record
- Building custom tools in the Maker portal: writing instructions, selecting Dataverse fields, choosing manual vs. agent-decided filters, and generating a JSON structure via Test
- Generating and iterating on Fluent UI (charts, card dashboards, interactive timelines) using natural-language prompts in VS Code with Claude
- Publishing tools and the requirement to download/upload a new declarative agent each time a tool is added
- Permission and admin considerations for uploading agents into M365 and Teams

## Notable quotes
> "It's like a universal translator for your application and its data that is geared for the agentic world that we're in right now." — Christine Flora

> "I can go straight in and see this live data from my application and edit and look and modify it without even leaving this context that I'm in." — Christine Flora

> "You tell it what data from your app you want to pass, and you do that by saying add content." — Christine Flora

## Products and tools mentioned
- Microsoft Power Apps
- Microsoft Power Platform
- Dataverse
- Power Apps Model Context Protocol (MCP)
- Power Platform Maker Portal (preview.powerapps.com)
- Microsoft 365 Copilot
- Copilot Studio
- VS Code
- Claude
- GitHub Copilot
- Fluent UI
- AI Builder
- Microsoft Teams
- Word, Outlook, Excel
- Work IQ [inferred]
- Git

## Speakers featured
- Christine Flora — Microsoft MVP in Business Applications; 15 years working in Power Apps and Power Platform; based in San Diego, CA

## Follow-up resources
- preview.powerapps.com (preview Maker portal for the public preview MCP)
