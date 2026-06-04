<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD836\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD836\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:50.0407263+00:00
-->
# Summary

## Overview
A demo-driven walkthrough of the Microsoft Foundry portal as a low-code "test kitchen" for AI developers, using a fictitious retailer (Zava) and its shopping assistant agent as the running scenario. The session traces an end-to-end journey from creating a first agent, through model comparison, instruction tuning, knowledge grounding, evaluation, and red teaming, all without leaving the browser, before transitioning to a code-first environment for production.

## Key announcements
- **Foundry portal as a low-code agent test kitchen** — The portal lets developers experiment with models, tools, and instructions for a single agent in a browser-based playground before writing any code (00:06:46).
- **Agent versioning and side-by-side comparison** — Agents can be saved as versions (v1, v2, etc.) and compared in real time against the same prompt to detect improvements or regressions (00:26:03).
- **Model leaderboard and trade-off charts** — A catalog of 11,000+ models can be ranked on quality, safety, throughput, and cost, with a trade-off chart for choosing the best model for the job (00:33:45).
- **Model Router** — An intelligent router that automatically selects the appropriate backend model based on prompt complexity, routing simple queries to cheaper models and complex tasks to higher-performance ones (00:41:24).
- **Built-in tracing and AI-assisted evaluation** — Connecting an Application Insights resource enables trace inspection plus per-response scoring on quality and safety metrics such as coherence, relevance, task adherence, and intent resolution (00:19:11).
- **Custom evaluators (prompt-based and code-based)** — Developers can build LLM-as-a-judge evaluators (e.g., a friendliness evaluator) or deterministic code-based evaluators (e.g., conciseness) (00:54:36).
- **Synthetic data generation for batch evaluation** — The portal can generate synthetic test prompts to run batch and continuous evaluations against an agent (01:00:08).
- **Red teaming scans** — An adversarial evaluation feature that simulates malicious users using attack strategies like flip and tense attacks to probe agent vulnerabilities (01:04:13).
- **Ask AI / agent helper** — An in-portal assistant that explains metrics and project state with links to documentation (00:48:52).

## Topics covered
- Monolithic AI apps versus agentic, microservices-style architectures
- Foundry project, resource group, and agent creation flow via ai.azure.com
- Default model provisioning (GPT-4.1) and text embedding models for RAG
- Built-in tools: web search, Code Interpreter, MCP server tools, file search
- Knowledge grounding via uploaded files, vector indexing, and Foundry IQ
- Agent memory across sessions
- Cost-versus-quality model selection and trade-off analysis
- Instruction tuning and prompt optimization
- Observability: traces, evaluations, and operational monitoring
- The Operate tab for managing a fleet of agents at scale
- Transition to code-first development with the Foundry SDK and VS Code

## Notable quotes
> "Agent AI brings a microservices-based approach where every agent is a single unit of work that can be evolved independently without having to rewrite the entire system." — Nitya Narasimhan

> "So looking at this quality, I could use GPT-5.4 nano and get the same level of quality at a much lesser cost. So why am I using GPT-4.1?" — Nitya Narasimhan

> "It's like getting a Cordon Bleu chef to come in and make the salad. You really want to get a cheaper model to do the simplest stuff." — Nitya Narasimhan

## Products and tools mentioned
- Microsoft Foundry / Microsoft Foundry portal
- Microsoft Azure portal
- Foundry model catalog, leaderboard, and trade-off chart
- Model Router
- GPT-4.1, GPT-4.1 mini, GPT-4o, GPT-5.4, GPT-5.4 mini, GPT-5.4 nano, GPT-5 mini, GPT-5 [inferred], o3, o4 [inferred]
- DeepSeek models
- text-embedding-3-large [inferred]
- Code Interpreter
- MCP servers
- Foundry IQ
- Application Insights and Log Analytics workspace
- Ask AI / agent helper
- File search tool and vector index
- Foundry SDK (Python, JavaScript, Java, .NET)
- Visual Studio Code, Foundry toolkit extension, Foundry skills
- GitHub Copilot for Azure
- Azure Developer CLI

## Speakers featured
- Carlotta Castelluccio — Senior AI Advocate, Microsoft
- Nitya Narasimhan — Senior AI Advocate, Developer Relations team, Microsoft

## Follow-up resources
- Foundry portal workshop GitHub repository (session deck, step-by-step demo instructions, and workshop content) — linked via QR code in the session
- Foundry Discord server (community support and roundtables with advocates and product group members) — linked via QR code in the session
