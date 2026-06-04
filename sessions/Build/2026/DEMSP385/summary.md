<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP385\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP385\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:49.4161021+00:00
-->
# Summary

## Overview

This advanced demo session shows how to give automated code review "memory" of past production incidents by connecting GitHub Copilot, Elastic, and Azure AI Foundry. Elastic's Agent Builder and Workflows review pull requests against open telemetry traces and incident post-mortems stored in Elasticsearch, flagging changes that risk reintroducing known regressions before they merge.

## Key announcements

- **PR review agent backed by incident history (00:03:55)** — A GitHub Actions check calls an Elastic Workflow that invokes Elastic Agent Builder to compare a PR diff against past incidents and OTel traces, posting a review comment when it matches a known failure pattern.
- **Semantic matching over keyword search (00:09:45)** — The agent uses Elastic's ESQL `match` function with Jina AI [inferred] embeddings to perform vector/semantic search across post-mortems rather than literal keyword matching.
- **Direct agent querying in Kibana (00:11:29)** — Developers can ask the agent questions about a prospective change before submitting a PR, using the Agent Builder UI on top of Elasticsearch.
- **Elastic MCP server in VS Code (00:14:17)** — Copilot Agent Mode connects to the Elastic MCP server, exposing the agent's tools (find similar traces, search incidents, latency analysis) so developers can diagnose and fix issues without leaving the editor.

## Topics covered

- Augmenting automated code review with production telemetry and incident post-mortems
- Detecting a reintroduced race condition in an e-commerce inventory checkout flow
- GitHub Actions workflow configuration: gathering PR metadata, diffs, and environment variables to send to Elastic
- Elastic Agent Builder concepts: agents, skills, tools, custom instructions, and workflows
- Using ESQL queries for semantic/vector search over OTel traces and incident data
- Encoding recurring incidents (e.g. race conditions) as reusable agent skills from RCAs
- Fixing flagged code via Copilot Agent Mode and validating with a concurrency test harness

## Notable quotes

> "The PR reintroduces this critical race condition that previously caused production incidents."

> "It's not just saying seems like a bad idea. We're saying, again, production broke probably don't, maybe don't do that."

> "Even just adding in open telemetry information... by being able to call Elasticsearch automatically as part of a GitHub action, you can get ahead of hopefully reoccurring production issues."

## Products and tools mentioned

- GitHub Copilot (Agent Mode)
- GitHub Actions
- Elastic / Elasticsearch
- Elastic Agent Builder
- Elastic Workflows
- Elastic MCP server
- Kibana
- ESQL (Elasticsearch Piped Query Language)
- Visual Studio Code
- Azure AI Foundry
- OpenTelemetry
- Jina AI embeddings [inferred]

## Speakers featured

- Jeff Vestal — presenter (Elastic)

## Follow-up resources

None mentioned in the transcript.
