<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK209\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK209\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:33.6144370+00:00
-->
# Summary

## Overview
A Japanese-language recap of Microsoft Build 2026, delivered to roughly 2,500 in-person attendees and a large livestream audience in Japan. Four Microsoft Japan presenters walk through the conference's central theme—building an ecosystem around frontier AI and agents—across infrastructure, models and context, agentic developer tools, security, and data platform layers.

## Key announcements
- **Maia 200 and Cobalt 200 silicon** — Next-generation in-house chips for AI processing (Maia) and Arm-based agent workloads (Cobalt), extending the line first announced three years prior. [00:05:32]
- **Azure HorizonDB [inferred] public preview** — A managed, PostgreSQL-compatible open-source database supporting large-scale OLTP, alongside Cosmos DB on the backend. [00:06:45]
- **GPU-accelerated Fabric Data Warehouse** — Using NVIDIA accelerated computing to deliver up to 7x query performance with no application changes. [00:07:03]
- **Web IQ and Work IQ API GA** — Adds web grounding optimized for agents to the existing Work/Public/Foundry IQ family, with the Work IQ API reaching general availability. [00:07:55]
- **Microsoft Execution Container (MXC)** — A sandboxed runtime for safely executing agent actions (e.g., the OpenClaw [inferred] computer-use agent), with native binaries and a TypeScript SDK published on GitHub. [00:09:43][00:34:59]
- **Host agent** — A server-side foundation for scaling and securely running agents. [00:10:02]
- **Microsoft Scout** — An autonomous "Autopilot" agent demoed in Japanese performing expense reimbursement across M365 cloud and local data, with the final decision left to a human. [00:12:04]
- **Microsoft AI models** — Seven models presented by Mustafa Suleyman [inferred], including image (MAI Image 2.5 [inferred]) and a reasoning model (MAI Thinking [inferred]); plus frontier tuning for domain-specific optimization. [00:15:39]
- **Agent 365 Local Agent and SDK** — Management of locally running agents as corporate assets, plus an SDK for building governed agents in any environment. [00:19:22]
- **Microsoft Discovery (GA) and Majorana 2 [inferred]** — Research-exploration services for drug/chemical discovery and quantum computing progress targeting 2029. [00:20:00][00:21:59]
- **GitHub Copilot desktop app and Copilot SDK GA** — Enterprise agentic development with a Canvas extension, daily automation running in the cloud, and SDK support for six languages (Java and another newly added). [00:29:00][00:32:26]
- **Foundry IQ serverless** — Serverless AI search in public preview, scaling to zero, with a developer tier. [00:34:21]
- **Foundry observability and optimization** — New multi-turn Evaluation and continuous evaluation (public preview); Rubric Evaluator, Agent Optimizer, and ROI for Agents (private preview). [00:36:43]
- **Fairwater AI data center and Project Leyfin [inferred]** — A dedicated AI data center built on sustainability principles, and a Fabric-powered service (public preview) for taking AI apps to production including backend. [00:41:00][00:44:18]
- **GitHub Copilot app modernization** — Expanded scenarios including mainframe migration, validated with partners Hitachi and NTT Data. [00:41:55]

## Topics covered
- Token efficiency and cost-performance balance ("performance equals tokens")
- Edge AI: GPU/NPU optimization, Windows ML, Foundry Local, Windows AI APIs, WebNN
- Database and data-warehouse architecture for agent access
- Safe, sandboxed agent execution and isolation layers
- Frontier model competition and harness/evaluation systems
- AI-powered security and vulnerability detection (CyberGym benchmark)
- Agent governance as agent populations grow
- Cloud development environments (Windows 365 dev, WSL containers, Dev Configurations)
- Sustainable AI data center expansion and full-stack silicon-to-tools strategy

## Notable quotes
> "Performance equals tokens."
— Okazaki, paraphrasing Satya Nadella

> "While we take the lead, the final decision is made by the human body, so we designed it to ensure safety and security."
— Okazaki, on Microsoft Scout

> "AI agents are development teams that collaborate and work together to pursue a single outcome."
— Okawa, on GitHub Copilot

## Products and tools mentioned
- Maia 200 / Cobalt 200
- Azure HorizonDB [inferred]
- Azure Cosmos DB
- Microsoft Fabric (GPU-accelerated Data Warehouse)
- Microsoft IQ (Work IQ, Public IQ, Foundry IQ, Web IQ), Foundry IQ serverless
- Microsoft Execution Container (MXC)
- Microsoft Scout
- Microsoft Foundry; Anthropic Claude, Fireworks AI
- Microsoft AI models (MAI Image 2.5 [inferred], MAI reasoning model [inferred])
- Agent 365, Agent 365 Local Agent, Agent 365 SDK
- Microsoft Discovery; Majorana 2 [inferred] quantum
- GitHub Copilot desktop app, Copilot CLI, Copilot SDK
- Windows AI APIs, Foundry Local, Windows ML, WebNN
- WSL containers, Winget, Dev Configurations, Windows 365 developer cloud PC, Windows Terminal
- GitHub Copilot app modernization
- Fairwater data center; Project Leyfin [inferred]

## Speakers featured
- Tadashi Okazaki — Executive Officer and General Manager, Cloud and AI Solutions Business Division, Microsoft Japan (Build overview, models, security, frontier)
- Okawa — Microsoft Japan (Windows and developer tools)
- Nitta [inferred] — Microsoft Japan solution engineer (agent context, MXC, observability)
- Yamamoto — Microsoft Japan (AI data center, Copilot modernization, Project Leyfin)
