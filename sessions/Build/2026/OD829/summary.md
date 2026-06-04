<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD829\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD829\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:36.0497692+00:00
-->
# Summary

## Overview
Microsoft Purview can serve as an embedded trust layer across the entire AI app and agent development lifecycle, letting developers build quickly while data security and compliance are handled centrally. The session demonstrates how Purview discovers AI risks, protects sensitive data, and governs usage across Microsoft-built, third-party, cloud, and local agents.

## Key announcements
- **Real-time (inline) Data Loss Prevention for Foundry** *(00:11:04)* — Security admins can configure DLP policies in Purview that block prompts containing sensitive information from reaching the LLM, using out-of-box or custom-defined sensitive data sets.
- **Foundry–Purview integration toggle with non-PII insights** *(00:12:30)* — Enabling the toggle in the Foundry control plane lets admins set up inline DLP and surfaces Foundry-specific, non-PII data security posture insights for a subscription.
- **Purview SDK integrated into the Microsoft Agent Framework SDK** *(00:14:45)* — Developers can embed Purview compliance and data protection middleware directly into a custom agent's runtime with roughly 15-20 lines of code.
- **Insider Risk Management support for agent-driven activity** *(00:09:00)* — IRM now tracks agent-triggered policy matches, generating alerts with full context just as it has for user-driven activity.
- **Azure AI Foundry evaluation results synced into Compliance Manager** *(00:10:11)* — Eval results and agent test status are automatically synced into Purview for associated agents.
- **Data Security for Local Agents** *(00:17:40)* — Discover, Protect, and Investigate pillars extend DSPM, DLP, and IRM to agents running on developer machines and endpoints, introduced at Build for managed agents with Claude Code and GitHub Copilot.

## Topics covered
- Enterprise anxiety around generative AI data leakage and compliance, supported by adoption and concern statistics.
- The "FSI min-bar" minimum standard for AI security developed with Financial Services Industry customers deploying Microsoft 365 Copilot.
- DSPM for AI: AI observability, activity explorer, DLP rule matches, and reporting.
- Two integration paths: native Microsoft platforms (Foundry, Copilot Studio) versus third-party, open-source, and multi-cloud architectures.
- API and SDK integration for RAG-based Gen-AI apps with custom LLMs and vector databases.
- Purview policy middleware intercepting prompts and responses in agent pipelines.
- Extending governance to local and unmanaged agents accessing files, credentials, and source code.

## Notable quotes
> "The hard part of AI is not building it, it's shipping it safely."

> "A few lines of code that relate to Purview, and your agent inherits the full enterprise trust layer."

> "One framework gives you consistent visibility protection and risk control no matter where your AI lives."

## Products and tools mentioned
- Microsoft Purview
- Microsoft 365 Copilot
- Azure AI Foundry
- Copilot Studio
- Purview SDK
- Microsoft Agent Framework SDK
- Data Security Posture Management (DSPM) for AI
- Insider Risk Management (IRM)
- Compliance Manager
- Communication Compliance
- Data Loss Prevention (DLP)
- LangChain
- OpenAI
- Semantic Kernel
- Claude Code
- GitHub Copilot
- GitHub

## Speakers featured
- Arpitha Dhanapathi — Principal Product Manager, Microsoft Purview organization

## Follow-up resources
- Code samples on GitHub in C#, Python, and Node.js for integrating the Purview SDK via the Microsoft Agent Framework SDK.
