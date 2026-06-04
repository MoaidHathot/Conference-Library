<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP907\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP907\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:31.3937994+00:00
-->
# Summary

## Overview
The session argues that the traditional golden signals of monitoring—latency, errors, traffic, and saturation (LETS)—remain foundational but are insufficient for generative AI applications because they miss non-deterministic behavior, variable cost, new attack vectors, and subjective quality. It proposes extending observability with three new dimensions—cost, safety/security, and quality—and demonstrates how Datadog LLM Observability unifies them.

## Key announcements
- **Datadog LLM Observability** ([00:11:25]) — A central platform extending standard golden signals with cost, security, and quality monitoring for GenAI applications, automatically capturing metrics like latency, errors, tokens per second, and API rate limit usage directly from LLM calls.

## Topics covered
- Four fundamental shifts that make GenAI different: non-deterministic behavior, variable cost structure, new attack vectors, and subjective quality.
- Applying the golden signals (LETS) to GenAI: stage-level latency instrumentation across RAG retrieval, LLM calls, and total request time.
- Segmenting errors beyond HTTP status codes to capture LLM model errors such as exceeded context length, triggered safety filters, and overloaded models.
- Traffic segmentation by feature, user type, and model to optimize capacity and manage model-specific rate limits.
- Saturation's shifted bottlenecks: GPU utilization and API rate limits.
- Cost monitoring and the three drivers of runaway spend: token creep, model drift, and uncached calls.
- Cost attribution strategy through mandatory tagging at the feature, user, model, and endpoint levels.
- The GenAI threat landscape ranked by risk: PII leakage and data exfiltration (critical); prompt injection and jailbreaking (high); denial of wallet and model extraction (medium).
- Four security metrics: prompt injection rate, PII detection rate, content moderation score, and jailbreak attempts.
- Why quality is hard to measure: no ground truth, context dependence, hallucinations, and subjective satisfaction.
- Six quality metrics: hallucination rate, relevance score, user satisfaction, answer completeness, retrieval quality (RAG), and response coherence.

## Notable quotes
> "A perfect 200 OK means nothing if your model is hallucinating, leaking PII, or burning through your budget one token at a time."

> "In GenAI, the same query can hit the API repeatedly if you haven't implemented an effective caching layer."

> "We've moved on from a binary world where it either works or it doesn't to a spectrum."

## Products and tools mentioned
- Datadog LLM Observability (Datadog Large Language Model Observability)

## Speakers featured
- Speaker 1 — presenter (Datadog); role/title not stated in transcript.
