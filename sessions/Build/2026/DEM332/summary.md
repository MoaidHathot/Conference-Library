<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM332\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM332\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:38.8698783+00:00
-->
# Summary

## Overview
A live, slideware-free demonstration of building a Microsoft Teams agent from an empty terminal to a deployed, identity-bearing teammate in under 25 minutes. The session introduces the consolidated Teams SDK, a new agent-first Teams CLI, and a GitHub Copilot skills plugin, then shows how an agent graduates into an Agents 365 teammate that operates across the Microsoft 365 ecosystem.

## Key announcements
- **Teams SDK consolidation** (00:01:18) — The previously separate Teams AI Library and tooling are unified into a single streamlined Teams SDK developer experience.
- **New Teams CLI** (00:07:47) — A command-line tool built from the ground up for both humans and coding agents, handling app registration, bot creation, secrets, and gluing the pieces together via `teams app create`.
- **Teams dev agent skill for GitHub Copilot** (00:06:54) — A Copilot skill that can call the Teams CLI and read the Teams docs to integrate an existing app into Teams from a single prompt.
- **Progressive disclosure in the CLI** (00:09:16) — Subcommands are revealed incrementally so an agent only loads context relevant to its current goal.
- **JSON mode** (00:10:34) — A `--json` flag returns structured output for scripting and agent parsing instead of human-formatted text.
- **Group chat capabilities** (00:14:19) — Emoji reactions, targeted/private messages, slash commands, quoted replies, suggested actions, markdown support, and source citations are coming to agents in group chats (dedicated session the following day at 11:50).
- **Agents 365 teammate identity** (00:16:02) — Agents can be given an agentic identity with their own alias and email, allowing them to live across Outlook, Word, Excel, PowerPoint, Teams, meetings, and group chats with added IT visibility, observability, permissions, and control.

## Topics covered
- The traditional multi-step path to deploying a Teams agent (app registration, credentials, endpoint, manifest, environment configuration, bot startup) and the friction it creates.
- Three pillars: bringing any agent on any stack, frictionless scaffolding, and turning an agent into a true teammate.
- Live conversion of a standalone project-management web app into a deployed Teams agent.
- Designing a CLI for both interactive human use (arrow-key navigation) and agent consumption.
- Using an agent as a blueprint to spin up project-specific personas that carry context across M365.
- Agents sending email from their own identity without leaving Teams.

## Notable quotes
> "This year we're bringing to you the Teams SDK, which is the consolidation of all the libraries and tools that you use into one streamlined developer experience." — Umang Sehgal

> "We're in the world of coding agents and CLI that is built for coding agents is what we are bringing to you." — Umang Sehgal

> "It makes sure that your agent only fills up its context with things that it actually needs for its particular goal and not for useless things that it might not actually end up using." — Aamir Jawaid

## Products and tools mentioned
- Microsoft Teams
- Teams SDK
- Teams AI Library (TypeScript and C#)
- Teams CLI
- GitHub Copilot
- Teams dev agent skill
- Agents 365 / Microsoft 365
- Microsoft Outlook, Word, Excel, PowerPoint
- Azure AI Foundry [inferred]
- Vercel [inferred]
- CrewAI
- Replit
- Cursor, Linear, Perplexity, Datadog, Atlassian [inferred]

## Speakers featured
- Umang Sehgal — Senior Product Manager, Teams platform
- Aamir Jawaid — Senior Software Engineer, Teams SDK

## Follow-up resources
- aka.ms/teams-sdk
- Companion session on group chat capabilities (following day, 11:50)
