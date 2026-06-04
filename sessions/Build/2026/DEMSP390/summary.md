<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP390\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP390\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:33:17.6886556+00:00
-->
# Summary

## Overview
Napster CTPO Edo Segal presents the Napster Omni Agent API, a single multimodal interface for building AI agents that appear as lifelike video avatars across web, app, kiosk, phone, and messaging surfaces while retaining persistent memory of each user. The session pairs a live development walkthrough with the announcement of Napster's availability on Azure, positioning the product as an "experience layer" sitting atop Azure AI Foundry as the underlying intelligence layer.

## Key announcements
- **Public preview of Napster on Azure** *(approx. [00:04:38])* — Delivered through Azure Native Integrations with unified marketplace billing, Azure portal provisioning, and single sign-on into the Napster portal.
- **Omni Agent API** *([00:03:38])* — A single API that exposes one agent across video, audio, text, WhatsApp, and phone calls, with persistent memory so the agent recognizes returning users.
- **Edge MCP architecture** *([00:07:19])* — A "vibe coding" prompt analyzes a site's source code and generates an MCP server embedded in the page's JavaScript, letting the agent act and perceive locally via the DOM instead of through a slower vision-language model loop.
- **Video avatars at one cent per minute** *([00:11:26])* — Engineering work cuts avatar cost from roughly $0.20 to $0.01 per minute, a claimed 20x reduction intended to make production rollouts viable.
- **New Foundry deployment skills** *([00:09:33])* — Prompt-driven skills deploy an agent to Azure AI Foundry and generate the Napster visual layer, requiring only the Cognitive Services User and Azure AI Foundry User roles in Entra ID.

## Topics covered
- Three-layer agent architecture: the app as source of truth, the Edge MCP "agent bridge" in the browser, and the avatar agent on top.
- "Hands" (capabilities) and "eyes" (state providers) exposed by the Edge MCP, avoiding per-frame VLM screenshot analysis by front-loading cognitive work at authoring time.
- Using an existing Foundry agent (memory, knowledge, tools) as the "brain" and layering the Napster avatar as the "face."
- Real-world scenarios: retail associates, airport seat booking, and hospital triage where an agent operates the same systems a human employee would.
- Persona generation, where the avatar's appearance is inferred from the website's domain and content.
- Hardware form factors, including a holographic desktop display called The View and an in-store kiosk.

## Notable quotes
> "The next surface is relationship. It's all about creating relationships for our users with the agents." — Edo Segal

> "We could not have done this three months ago. This is only possible because of the frontier models we have now."

> "We put the cognitive load of teaching the agent how to use the site at authoring time, once, on your computer as a developer."

## Products and tools mentioned
- Napster Omni Agent API
- Azure AI Foundry
- Azure Native Integrations
- Azure Marketplace
- Azure portal
- Microsoft Entra ID
- The View (Napster holographic display)
- Napster kiosk hardware
- Edge MCP (HMCP) server
- Claude Code
- Visual Studio
- OpenAI frontier models
- Claude Opus 4.8 [inferred]
- Heygen [inferred]
- Synthesia

## Speakers featured
- Edo Segal — CTPO, Napster
- Igor — Lead Engineer, Napster
- Mary (Marius) — Product Manager, Napster
- Microsoft partner representative (name unclear in transcript) — announced the Napster on Azure public preview
- Tenil — runs the Napster hackathon

## Follow-up resources
- QR codes shown in-session for an API key, free token offer, and the setup prompt.
- QR code for Edo Segal's book on AI and "human emulators."
- Napster booth down the hall, with a live hackathon offering over $2,000 in prizes.
