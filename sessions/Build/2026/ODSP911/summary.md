<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP911\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP911\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:35.0034011+00:00
-->
# Summary

## Overview
A DevExpress-focused demonstration of embedding AI directly into a Blazor business application rather than bolting a chatbot onto an existing app. Using a .NET command center backed by Azure OpenAI, the session shows AI driving grid interactions through tool calling, built-in report translation, and AI-derived contract risk visualization, with the recurring thesis that AI handles intent while DevExpress controls handle interaction.

## Key announcements
- **AI-driven DevExpress grid via tool calling (00:00:41)**: Natural-language prompts trigger registered C# methods that filter, group, sort, and export against the live grid through the standard DevExpress API.
- **Built-in translation in the DevExpress Report Viewer (00:00:46)**: A French quarterly memo is translated to English by the report viewer itself, with no custom chat UI on the page.
- **AI contract review with visualized risk (00:00:51)**: Azure OpenAI identifies risky clauses and a DevExpress report renders them with warning tags, red borders, and conditional band coloring.

## Topics covered
- Connecting AI to controls, data, and workflows instead of adding a standalone chatbot
- Tool-calling architecture: registering approved, screen-scoped capabilities via an AI tools context builder
- Function metadata and descriptions guiding model tool selection
- Configuring keyed chat clients and function invocation in program.cs using .NET user secrets
- Dependency injection of the live grid instance at runtime rather than from the model
- Report viewer AI integration: enabling translation and inline translation for multiple languages
- Custom workflows that inject IChatClient directly, using a system prompt and full document text
- Parsing AI responses to drive conditional report formatting (is-risky state)
- Application structure that keeps the AI layer from "swallowing" the app

## Notable quotes
> "Think in terms of the AI handles the intent. DevExpress handles the interaction."

> "The AI does not get the whole application, simply the approved capabilities that we register here."

> "AI creates the state. DevExpress presents the state."

## Products and tools mentioned
- DevExpress Blazor controls (DX Grid, DX Chart, DX AI Chat)
- DevExpress Reporting / Report Viewer
- Azure OpenAI
- IChatClient
- Visual Studio
- .NET
- Blazor
- .NET user secrets
- Microsoft Excel (XLSX export)

## Speakers featured
- Paul Usher — DevExpress
