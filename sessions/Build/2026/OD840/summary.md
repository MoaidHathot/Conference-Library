<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD840\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD840\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:48.5004395+00:00
-->
# Summary

## Overview
This session makes the case that enterprise-ready agents must be treated as managed actors—with scoped identity, least-privilege access, and full auditability—rather than as features inside an app. It introduces the Agent 365 SDK as the means by which developers on any framework can layer observability, governance, and security onto agents so they integrate with Microsoft's Agent 365 control plane.

## Key announcements
- **Agent 365 and the Agent 365 SDK reached general availability on May 1st** (**[00:09:45]**): The control plane and its developer SDK are positioned to let enterprises observe, govern, and secure every agent in their environment.
- **Agent 365 SDK works incrementally across frameworks** (**[00:12:13]**): Developers using OpenAI's SDK, LangChain, Claude, LlamaIndex, the Microsoft Agent Framework, or custom code can add observability, governance, and security without a rewrite.
- **Native, out-of-the-box integration with Microsoft AI platforms** (**[00:10:37]**): Agents built in Agent Builder, Copilot Studio, or Foundry appear in Agent 365 automatically with identity, observability, governance, and security wired in.
- **Connected platform integration for third-party platforms** (**[00:11:17]**): Agents built on Vertex AI and AWS Bedrock can be registered in the Agent 365 registry, with more platforms on the way.
- **AI-guided setup for coding agents** (**[00:13:44]**): The SDK can auto-wire registration and telemetry so developers reach their first trace without reading extensive docs.

## Topics covered
- Four enterprise concerns: agent sprawl and resource access, data oversharing, indirect prompt injection, and regulatory uncertainty.
- The "agent as an actor" mental model—provisioning agents like new hires with scoped identity, least privilege, and audit trails.
- Data flow risk versus per-action permissions (e.g., read-from-CRM plus send-email combining into an exfiltration path).
- OpenTelemetry-based tracing via the Microsoft OpenTelemetry Distro or direct injection to an OTel endpoint.
- Governed tool access to Microsoft 365 data (mail, calendar, OneDrive, SharePoint, Teams) through MCPs, plus bring-your-own MCP registration.
- Entra Agent ID for verifiable agent identity, conditional access, and identity governance.
- Purview enforcement of sensitivity labels, DLP, and data lifecycle policies at the platform layer.
- Defender-based threat hunting, anomaly detection, and prompt injection blocking.
- Live demo using a Genspark agent showing admin visibility, audit/sign-in logs, label and DLP enforcement, and a blocked prompt injection alert.

## Notable quotes
> "An agent is not an app, it's an actor with its own brain. Give it a scoped identity, least privilege access, and an audit trail from day one." — Sunil Garg

> "The bar for an enterprise-ready agent isn't whether it works, it's whether it could pass an onboarding review at a Fortune 500." — Sunil Garg

> "The developers who win here aren't the ones shipping the flashiest agents, they are the ones building agents that CISOs will actually approve." — Sunil Garg

## Products and tools mentioned
- Agent 365
- Agent 365 SDK and CLI
- Microsoft Entra / Entra Agent ID
- Microsoft Purview (and Purview APIs)
- Microsoft Defender
- Microsoft 365 Admin Center
- Microsoft OpenTelemetry Distro
- Microsoft Agent Framework
- Agent Builder, Copilot Studio, Microsoft Foundry [inferred]
- OpenAI SDK, LangChain, Claude, LlamaIndex
- Google Vertex AI, AWS Bedrock
- Model Context Protocol (MCP)
- Genspark agent

## Speakers featured
- Jeremiah Follis — Product Marketing Manager, Microsoft Security for AI team
- Sunil Garg — Product Manager, Agent 365 team; leads the Agent 365 SDK and CLI and serves as a deployed PM driving partner adoption

## Follow-up resources
- Three resources to get started building with the Agent 365 SDK were referenced on screen at the close (**[00:23:44]**), but no specific URLs were stated in the transcript.
