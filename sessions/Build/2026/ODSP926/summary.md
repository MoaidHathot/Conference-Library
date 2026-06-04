<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP926\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP926\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:45:03.6317321+00:00
-->
# Summary

## Overview
Napster's Omniagent API is presented as an Azure-native platform for deploying real-time multimodal video agents into applications across web, mobile, phone, and text channels. The session emphasizes that the long-standing barrier to shipping such agents at scale has been cost, and demonstrates an end-to-end build of a field service agent from provisioning to monitoring.

## Key announcements
- **Omniagent API runs at one cent per render minute** (00:01:05): When bringing your own LLM, pricing is roughly 20 times cheaper than alternatives, making a five-minute call cost five cents and an eight-hour agent under $5 per day.
- **Fully Azure-native architecture** (00:01:31): The browser SDK connects over HTTPS and WebRTC through Azure Front Door, with core pods on Azure Kubernetes Service and rendering on dedicated Azure VM clusters, all on managed services.
- **Single cloud billing and inherited governance** (00:02:12): The service appears as a line item on the existing Azure invoice and works with existing Azure Policy, Defender, and DDoS protection.
- **Multi-provider LLM support** (00:02:31): Swapping LLM providers is a configuration change rather than a rewrite, using the same agent configuration.
- **Cross-channel memory** (00:08:19): When enabled per session, the agent extracts facts and carries context across web, phone, and text so users do not re-explain.
- **Available today on Azure with a sub-15-minute quickstart** (00:09:35): The resource is provisioned from the portal like any other Azure resource.

## Topics covered
- Cost economics of real-time multimodal video agents at scale
- Azure-native network and compute stack (Front Door, AKS, WebRTC, private endpoints)
- The four-part anatomy of an agent: Omniagent, knowledge, FAQs, and tools
- Distinction between fictional Omniagents and digital twins of specific people
- Building and configuring an agent (the field service specialist "Vera")
- Testing in the playground before deployment
- Multichannel deployment: web SDK, native app WebSocket, SIP/VoIP phone, and text
- End-to-end monitoring, audit, transcripts, tool calls, and outcome tracking
- Production deployments at Siemens for field service, customer service, sales onboarding, and training

## Notable quotes
> "Real-time multimodal video agents have been technically possible for a while. What hasn't been possible is shipping them at scale." — Ziv Navoth

> "Every component you see in this stack is running on an Azure managed service." — Ziv Navoth

> "A multimodal AI co-worker, you can spin up in your Azure tenant in minutes, running on your own LLM, deployed across every channel your customers use, and inspectable end-to-end." — Ziv Navoth

## Products and tools mentioned
- Napster Omniagent API
- Microsoft Azure
- Azure OpenAI
- Azure Kubernetes Service
- Azure Front Door
- Azure Policy
- Microsoft Defender
- Azure DDoS Protection
- Azure Cosmos DB
- WebRTC
- WebSocket
- SIP / VoIP

## Speakers featured
- Ziv Navoth — Chief Product Officer, Napster
- Edo Segal — Napster
- Gillian Sheldon (listed in session metadata; not heard in transcript)
