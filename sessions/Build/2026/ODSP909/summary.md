<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP909\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP909\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:35.7971336+00:00
-->
# Summary

## Overview
This foundational session demonstrates how to make multi-agent AI systems observable, reliable, and secure by instrumenting them with OpenTelemetry. Using a fictional travel-planning startup ("Wanda AI") built on the Microsoft Agent Framework, Harry Kimpel walks through tracing agent decisions, correlating logs, enforcing quality gates in CI/CD, and detecting prompt injection—all surfaced in New Relic.

## Key announcements
- **Built-in OpenTelemetry support in the Microsoft Agent Framework** ([00:05:49]) — Initializing the SDK and pointing it at an exporter makes every agent invocation emit traces automatically in about two or three lines of code, without manually wrapping each agent call.
- **End-to-end trace visibility in New Relic** ([00:07:01]) — A real trace shows a top-level span of 48.2 seconds with child spans revealing the itinerary builder (39.29s) as the bottleneck rather than the tool calls.
- **Log-to-trace correlation via trace context** ([00:09:07]) — Trace IDs and span IDs are automatically added to log output, letting an engineer click from an error log straight to the causing span for root cause in under a minute.
- **CI/CD quality gates using LLM-based evaluation tests** ([00:10:34]) — Eval suites score agent outputs and fail the build if quality drops below a threshold, preventing bad outputs from reaching production.
- **Two-layer prompt injection defense** ([00:11:52]) — Microsoft Foundry guardrails at the platform level plus application-level detection in the request handler, with both security controls instrumented and observable.

## Topics covered
- Why AI agents are harder to debug than traditional request/response web services
- Structuring a multi-agent system: web app, primary planning agent, and callable tools (destination search, weather forecast, itinerary builder)
- OpenTelemetry as a vendor-neutral CNCF [inferred] standard for tracing, metrics, and logs
- Adding custom spans for business context (e.g., destination category: beach, city, adventure)
- Custom metrics as counters and histograms for dashboards (itineraries per hour, average quality score, cache hit rate)
- Evaluation tests as "unit tests for AI behavior" wired into CI/CD
- Guardrails for jailbreak attempts, indirect prompt injection, and content safety
- The evaluator catalog of built-in evaluations
- A multilayered security approach for AI-enabled systems

## Notable quotes
> "We're shipping AI systems we can't see inside of. That changes today." — Harry Kimpel

> "Quality gates are not optional for AI in production." — Harry Kimpel

> "If you can't see them firing, you can't trust them." — Harry Kimpel

## Products and tools mentioned
- Microsoft Agent Framework
- OpenTelemetry
- New Relic
- Microsoft Foundry guardrails
- Flask
- GitHub Codespaces
- Microsoft What the Hack repository

## Speakers featured
- Harry Kimpel — works at New Relic

## Follow-up resources
- Microsoft What the Hack repository, challenge "073 New Relic agent observability" — an eight-challenge, hands-on lab in GitHub Codespaces taking roughly three to five hours.
