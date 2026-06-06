<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK201\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK201\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-06T08:20:40.7423466+00:00
-->
# Summary

## Overview
A live "vibe coding" competition recorded at Microsoft Build, in which five practitioners race for roughly 36 minutes to build a cloud-based collaborative markdown editor, each using a different agentic surface in VS Code and GitHub Copilot. The session demonstrates multi-agent workflow patterns—planning, sub-agents, parallel work trees, and design iteration—through live building rather than slides, while the hosts simultaneously build a real-time voting app in a GitHub Codespace.

## Topics covered
- Decomposing a build into committable increments versus one-shotting the whole feature with a high-reasoning model
- Using plan mode and an exploratory "conversation" with the agent before saying "go," contrasted with skipping planning entirely
- Running agents in a GitHub Codespace as a sandbox to safely let agents execute, run a server, and expose it publicly
- Multi-agent orchestration: a powerful model as planner delegating implementation to a separate model, sub-agents, and parallel git work trees
- Mixing model providers for the same task to compare output quality (GPT, Opus, Codex)
- Reusable design systems and skills (a "poster board" aesthetic) to generate and iterate on multiple UI mockups via parallelized sub-agents
- Persistence and real-time sync choices: JSON file versus SQLite, a server-side module, and WebSockets for live vote updates
- Vanilla HTML/CSS/JavaScript for small apps, pulling libraries from a CDN (unpkg) and debugging via view-source and dev tools
- Practical prompting habits: not correcting typos, using voice mode, and the idea that verbose English is inefficient for agent communication
- Using AGENTS.md to steer agents

## Notable quotes
> "The only way to be productive with an agent is to put it into [a sandbox] and let it do its thing. But a lot of [agents are] inherently unsafe."

> "I actually don't plan... the conversation is [the plan] and you iterate on that to get to the ultimate end [result]." — Kent C. Dodds

> "This is the era we're in where we just watch agents cook."

## Products and tools mentioned
- Visual Studio Code
- GitHub Copilot
- GitHub Copilot CLI
- GitHub Copilot app
- Agent app
- GitHub Codespaces
- VS Code Live Share
- Monaco editor
- CodeMirror
- Next.js
- Node.js
- SQLite
- WebSockets
- unpkg
- Copilot SDK
- AGENTS.md
- Cursor
- GPT-5.5
- GPT-5.4
- Claude Opus 4.6
- Claude Opus 4.7
- Codex
- Cursor Composer 2.5
- Kimi [inferred]

## Speakers featured
- Pierce Boggan — Product Manager, VS Code team; competed using the GitHub Copilot app
- Kent C. Dodds — software developer and full-time educator (JavaScript and the web); co-host building the voting app
- Burke Holland — co-host building the voting app in the Codespace [inferred]
- Julia Kasper — VS Code team; competed using agent mode and the local agent in VS Code
- Harald Kirschner — competed using the Agent app, running multiple agents across parallel work trees
- Chris Reddington — based in the UK; competed using the GitHub Copilot CLI

Note: contestant approaches—Julia (local agent mode, GPT-5.5 high reasoning, later Opus 4.6 for UI), Chris (CLI with a planner plus sub-agents, Opus planning and Codex implementing), Pierce (Copilot app, plan mode, Monaco-based editor), and Harald (research session plus three parallel prototype explorations merged into one)—illustrate distinct multi-agent strategies. The hosts' voting app used vanilla HTML/CSS/JavaScript in a public Codespace, debugging a broken QR-code CDN dependency by switching to unpkg, then persisting votes to a JSON file with a WebSocket for live updates, and finally generating ten UI mockups via parallel sub-agents using a custom "poster board" skill.
