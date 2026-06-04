<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK262\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK262\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:48.2658417+00:00
-->
# Summary

## Overview
This advanced Windows session argues that as AI agents shift from answering questions to taking real actions—running commands, modifying files, moving data—the operating system must enforce safety rather than relying on agents to self-govern. The speakers present three Windows platform primitives—agent identity, containment, and manageability—and demonstrate them through GitHub Copilot CLI/SDK integration and live sandboxing demos.

## Key announcements
- **Three Windows agent primitives: identity, containment, manageability** [00:05:00] — Windows treats agents as a new class of user with a distinct security principal, an enforced isolation boundary, and IT-governable policies.
- **Microsoft Execution Containers (MXC) Library** [00:11:12] — A cross-platform, declarative library that dynamically composes a right-sized container per agent action by matching developer, user, and IT policy against available OS primitives.
- **Dynamic composition across container sizes** [00:11:58] — MXC scales from small processes to VMs, Firecracker-style micro VMs, and cloud PCs, spanning Windows, WSL, and Linux.
- **Hyperlight micro-VM with the Nanvix OS** [00:17:12] [inferred] — A hardware-backed virtual machine running a roughly 10-megabyte OS launches and executes a script very quickly with full hypervisor protection.
- **Sandbox shipping out-of-box in GitHub Copilot CLI and SDK** [00:21:16] — Built with the Windows team and currently behind an experimental flag, with general availability and default-on planned for the future.
- **Agent 365 native integration via MXC** [00:27:27] — Agents built with MXC gain integration with Microsoft Defender, Entra, and Intune (in preview) so security and IT teams can constrain local agents.

## Topics covered
- Risks of high-agency, low-guardrail agents (deleted production databases, unwanted email deletion) and the amplified "blast radius" of agent mistakes.
- Risk vectors across agent-to-human, agent-to-tools, agent-to-application, agent-to-agent, and agent-to-LLM interactions.
- Observed Copilot usage trends: auto-approval removing gates, SDK-versus-CLI permission-model mismatch, and orchestration jobs growing from minutes to 30+ minutes.
- Agent identity as a first-class system entity requiring security principals, policy membership, and audit logs, demonstrated with a separated-session gateway node.
- Non-determinism of agents that write and evolve their own code, and least-privilege per-action sandboxing.
- Declarative container policy: certificate access, time limits, read/write path restrictions, network allow-listing (GitHub API only), UI and clipboard scoping.
- Monitoring a deliberately malicious agent hitting sandbox boundaries (e.g., attempting to read the SAM hive / NTUSER.DAT) and feeding failures back to improve policy.
- Supervision concepts: human-in-the-loop versus autonomous agents, surfacing intent at waypoints, and continuous consent.
- Copilot CLI/SDK sandbox demos: blocking desktop file deletion, restricting outbound/local network access, blocking turning a private repo public, prompt-injection exposure, and disabling the sandbox after user review.

## Notable quotes
> "Agents aren't you, no matter what we do today." — Stuart Schaefer

> "When an agent can choose its own actions at runtime, that makes it unpredictable. But because it's unpredictable, it doesn't mean that it's uncontrollable." — Stuart Schaefer

> "Agents are still exposed to prompt injection attacks in the modern era." — Patrick Nikoletich

## Products and tools mentioned
- Windows
- Microsoft Execution Containers (MXC) Library
- Hyperlight [inferred]
- Nanvix
- WSL
- GitHub Copilot CLI
- GitHub Copilot SDK
- Microsoft Agent 365
- Microsoft Defender
- Microsoft Entra [inferred]
- Microsoft Intune
- Microsoft Teams
- Firecracker

## Speakers featured
- Kirupa Chinnathambi — Product Manager, Windows Platform and Developer team
- Stuart Schaefer — Architect, Windows Platform and Developer team
- Patrick Nikoletich — Product Manager, GitHub (Copilot)

## Follow-up resources
- The agentic booth (Patrick available the evening of the session; colleagues the following day) for further questions.
