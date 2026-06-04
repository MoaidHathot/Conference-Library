<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP937\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP937\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:45:21.2611081+00:00
-->
# Summary

## Overview
A technical walkthrough of building real-time multimodal voice agents using LiveKit's open-source media infrastructure paired with Azure's speech-to-text, LLM, and text-to-speech models. Jesse Hall frames the core challenge as the engineering around the model—latency, network resilience, turn detection, and scale—rather than the model itself, then demonstrates a working agent that answers questions about Microsoft Build.

## Key announcements
- **End-to-end voice agent built on Azure plus LiveKit** *(00:05:30)* — Azure can serve all three pipeline stages: Azure STT, OpenAI through Azure for the LLM, and Azure TTS.
- **Live demo of a completed Build assistant** *(00:09:01)* — A customized agent greets the user and correctly answers that Microsoft Build 2026 runs June 2–3 in San Francisco at Fort Mason, with an online experience.
- **LiveKit MCP docs server and skill** *(00:05:47)* — Recommended as the most important tooling so coding agents build against up-to-date LiveKit context, given near-weekly feature shipping.

## Topics covered
- Why real-time agents differ from text agents: latency tolerance versus a few-hundred-millisecond budget.
- Real-time media challenges: network conditions, echo and noise cancellation, turn detection, and handling interruptions versus back-channeling (coughs, sneezes, "hmm").
- WebRTC as the foundation for real-time transport and why building infrastructure around it is non-trivial.
- LiveKit architecture: open-source media transport layer (transport, jitter-buffering, codecs, SIP, fan-out) versus the orchestration/application layer where the Agents SDK and custom logic live.
- The cascaded voice pipeline: VAD, speech-to-text, LLM, text-to-speech.
- Model-agnostic, swappable components (one line of code to change a model) and mixing/matching STT, LLM, and TTS providers.
- Self-hosting versus LiveKit Cloud deployment.
- Scaling concurrency to hundreds of thousands of users.
- Hands-on setup: scaffolding the agent and React front end, the Agent.py structure, environment variables, VAD model download, and running agent plus front end.

## Notable quotes
> "Real-time, it is built different." — Jesse Hall

> "Models, they are the easy part now. Everything around it is the hard part." — Jesse Hall

> "WebRTC gets users to your agent reliably, and the agent's SDK gets your custom business logic to your users reliably." — Jesse Hall

## Products and tools mentioned
- LiveKit
- LiveKit Cloud
- LiveKit Agents SDK (Python and TypeScript)
- LiveKit MCP docs server
- Azure STT
- Azure TTS
- Azure OpenAI
- WebRTC
- Silero VAD [inferred]
- ChatGPT voice mode
- React
- SIP / telephony
- UV
- pnpm

## Speakers featured
- Jesse Hall — Developer Advocate, LiveKit
