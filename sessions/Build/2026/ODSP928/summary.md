<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP928\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP928\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:45:06.3414388+00:00
-->
# Summary

## Overview
The session examines why AI SRE (site reliability engineering) agents are expensive to run at scale and presents practical optimizations to bring per-investigation token costs into a viable range. Natan Yellin argues that with the right architecture—cheaper models, persisted context, and LLM-native alert grouping—enterprises can afford to run AI investigations on every production alert rather than a selective subset.

## Key announcements
- **The "naive" cost of AI SREs is roughly $730,000/year for a typical Fortune 500** [00:00:43] — At ~1,000 alerts per day and ~$2 per investigation (a midpoint within a $180k–$1.8M range), the cost often exceeds that of human triage and becomes a non-starter.
- **Underlying investigation cost runs 50 cents to $5, driven almost entirely by input tokens** [00:01:42] — Agents ingest large volumes of logs, metrics, and observability data, while output token costs remain minimal; observability vendors typically mark this up to around $25 per investigation.
- **Cheaper models help less than expected** [00:03:26] — Models such as DeepSeek V4 are roughly three times cheaper than Opus but less accurate, and often pull more (and wrong) data, eroding the per-token savings.
- **Context and runbooks cut cost 20–30%** [00:04:47] — Supplying or auto-learning environment context, memories, and skills spares the agent from rediscovering the customer's observability setup on every alert.
- **LLM-native alert grouping delivers the largest savings** [00:05:56] — Since most alerts during an outage are duplicates of one root cause, letting the LLM generate and persist grouping rules avoids linear per-alert cost while avoiding the pitfalls of deterministic rules.
- **Hot context-window reuse leverages Anthropic's cache** [00:07:25] — Maintaining one context window per root cause lets retriggered investigations reuse a still-cached window (Anthropic's five-minute cache), making them far cheaper than a clean window.

## Topics covered
- Cost modeling of AI SRE investigations at enterprise alert volumes
- Input-token versus output-token cost dynamics in observability workloads
- Vendor markup practices in the observability market
- Trade-offs between premium and lower-cost models on accuracy and total data pulled
- Context injection, memory, and auto-built skills to reduce rediscovery cost
- LLM-native versus deterministic alert grouping and over/under-grouping risks
- One-context-window-per-root-cause architecture and prompt cache reuse
- Operational benefits of running investigations on every alert, including automatic escalation and prediction before incidents become P1s

## Notable quotes
> "It's cheaper to hire an offshore team and to have them triage the alerts."

> "The big, big area where we see the biggest optimization is that most alerts are actually duplicates."

> "When you can get the per-investigation cost down, then it's a no-brainer. You just run it on everything."

## Products and tools mentioned
- Robusta
- Anthropic Claude Opus (4.7 and 4.6) [inferred]
- DeepSeek V4
- Anthropic prompt caching

## Speakers featured
- Natan Yellin — CEO and co-founder of Robusta
