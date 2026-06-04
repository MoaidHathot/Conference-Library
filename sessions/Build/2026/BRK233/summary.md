<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK233\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK233\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:05.4898644+00:00
-->
# Summary

## Overview
Chip Huyen examines whether software retains value when AI drives the cost of building it toward zero, arguing that traditional moats—proprietary data, distribution, trust, expertise—are weaker than assumed because money can acquire most of them. The talk pivots to where durable value remains: long-tail problems frontier labs ignore, human-AI interaction design, and the emerging frontier of physical AI agents and robotics.

## Topics covered
- Why falling software-building costs raise the question of whether software value also approaches zero, and the ease of replicating any shipped product with AI coding tools
- METR's benchmark showing the length of tasks AI can reliably complete (roughly 50% of the time) growing on a log scale toward multi-hour, complex work
- The "Ghibli moment" analogy: shipping software, like an art style, becomes a shorthand that makes replication easier
- Critique of supposed moats—proprietary data (commoditized via data-labeling firms), distribution (acquirable by buying incumbents), trust/branding (eroded by fast model-switching), expertise (must be encoded, then copyable), and momentum (an exhausting treadmill)
- Long-tail problems frontier labs deprioritize: non-English languages (Farsi, Arabic) and voice-chatbot latency across the speech-to-text, LLM, text-to-speech pipeline
- Human preference variation (RLHF assuming universal preference) and cultural differences in conversational response timing (West ~80ms vs. Vietnam ~200ms)
- Human-AI interaction design: terminal vs. IDE tradeoffs, hybrid desktop agents, running agents on cloud/servers, and mobile/Telegram control of coding agents
- Shift from code to specifications as the primary artifact ("specs-driven development") and the mismatch with code-review tooling built around code
- Making the environment AI-friendly: modularizing legacy codebases, API-first over GUI design, and city "street light APIs" for delivery robots
- Irreversibility and safety as design constraints (a deleted database, form submissions, money transfers, robot battery failures in elderly care)
- Physical AI agents as a continuation of digital agents, the gap in world modeling for physical understanding, and a personal "career audit" framework for measuring AI exposure

## Notable quotes
> "If the cost is 0, then the value is 0. So it makes me think about like... what should I be building?"

> "Like money is a Moat, right? If you have money, you can just buy it."

> "I think with the new AI coding, the artifact is no longer the code. Like GitHub was designed around code as the main artifact... but nowadays the main artifact actually is the instructions."

## Products and tools mentioned
- Claude Code
- OpenAI Codex
- ChatGPT
- Anthropic Claude
- DeepSeek
- Qwen
- GitHub
- Salesforce
- QuickBooks
- Oracle
- Airtable
- Scale AI
- Surge AI [inferred]
- Mercor [inferred]
- METR
- Docker
- PostgreSQL
- Telegram
- Unitree G1 robot
- Onewheel
- MacBook

## Speakers featured
- Chip Huyen — builder of AI systems; previously at NVIDIA and Snorkel AI, founder of a sold AI infrastructure startup, currently running a robotics company
