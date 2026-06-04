<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP393\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP393\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:33:02.8586592+00:00
-->
# Summary

## Overview
A product-focused walkthrough of the native integration between Microsoft Foundry and Twilio Agent Connect, aimed at building omnichannel AI agents that retain customer context across voice, SMS, and chat. The session frames the problem of cross-channel "memory loss" in customer experiences and demonstrates a serverless deployment pattern using Foundry hosted agents, culminating in a live airline-support demo that carries context from a voice call into an SMS conversation.

## Key announcements
- **Twilio Agent Connect (TAC)** *(~03:17)*: A newly launched open-source SDK with two connectors—one to Twilio, one to Foundry—that handles real-time conversation management, persistent memory, and multi-channel orchestration to create a single agent across all channels.
- **Hosted agents deployment option** *(~06:18)*: Following Microsoft's public preview of hosted agents with WebSocket support and the Invocations API, TAC switched to a fully serverless deployment that gives each session its own dedicated sandbox, with scale-to-zero and no idle cost.
- **Cross-channel shared memory demo** *(~13:48)*: A live demonstration showing an agent remembering a seat change made on a voice call when the same customer later texts via SMS, resolved through profile resolution on the phone number.

## Topics covered
- The gap between surging AI spend and weak measured returns in customer experience.
- Cross-channel "amnesia" as the root cause of disjointed customer support interactions.
- Complementary division of labor: Twilio handles channels, regions, and shared memory; Foundry provides models, Voice Live API, and the agent framework.
- Why traditional stateless compute (container apps) is ill-suited to long-lived, stateful, per-user agent sessions, including security and isolation concerns.
- The six benefits of hosted agents: per-session sandboxing, predictable cold starts, scale-to-zero, state persistence, unique agent identity, and built-in observability/evals/policies.
- Simplified architecture: HTTP events through an API Management Gateway that validates Twilio signatures, adds auth, and maps each Twilio conversation ID to a hosted agent session ID.
- TAC's two components: the agent framework connector (session persistence via Cosmos DB, contextual memory injection) and the Voice Live connector (streaming inference over WebSockets).
- Deployment via the `azd up` command, which provisions API Management plus a hosted agent running TAC.
- Webhook configuration in Twilio for voice and SMS, and the distinction between the public API Management URL and the non-public hosted agent URL.
- Out-of-the-box traces, monitoring, evals, and a playground; customization of prompts, knowledge sources, tools, and models.
- Relationship between the new integration and Twilio's existing Conversation Relay product.

## Notable quotes
> "The traditional customer experience actually suffers amnesia across channels and that leads to a very disjointed end customer experience." — Rachel Baskin

> "Traditional compute was designed for stateless web services and APIs where multiple users can share the same instance, but agents need long lived stateful per user sessions." — Rachel Baskin

> "It's really not hard now to get an agent. The hard part is actually making it enterprise ready." — Rachel Baskin

## Products and tools mentioned
- Microsoft Foundry (Azure AI Foundry)
- Twilio Agent Connect (TAC)
- Foundry hosted agents
- Microsoft agent framework
- Foundry Voice Live API
- Twilio Conversation Relay
- Azure Container Apps
- Azure Cosmos DB
- Azure API Management
- Azure Developer CLI (`azd up`)
- GPT-5 mini [inferred]
- Python / pip

## Speakers featured
- Rachel Baskin — Product Manager, Twilio

## Follow-up resources
- The open-source Twilio Agent Connect for Microsoft repository on GitHub (presented via on-screen QR code and link; specific URL not stated in the transcript).
