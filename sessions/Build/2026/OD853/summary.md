<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD853\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD853\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:09.9291657+00:00
-->
# Summary

## Overview
Windows platform and security engineers detail how the operating system can host, contain, and govern AI coding agents at enterprise scale. The session frames agents as a new "execution problem" and walks through a spectrum of OS-enforced containment options, agent identity, and detection/response integrations that let developers move agents from experiments to production without sacrificing trust.

## Key announcements
- **Microsoft Execution Containers (MXC) SDK** *(00:06:48)* — A single SDK and policy model that applies OS-enforced containment across multiple isolation primitives, so one coherent abstraction can cover many workload types.
- **Composable sandbox model** *(00:07:13)* — The same policy maps to different isolation boundaries (process, micro-VM, full VM, cloud) depending on workload risk, avoiding lock-in to one rigid container.
- **Hyperlight micro-VM execution** *(00:10:44)* — Hardware-level isolation with sub-second startup for higher-risk operations, demonstrated running PDF-annotation extraction via an mxc.exe [inferred] host process that leaves no traces.
- **Process-level sandboxing in GitHub Copilot CLI** *(00:14:22)* — An experimental "sandbox enabled" mode runs each tool execution inside a kernel-enforced boundary, keeping the developer inner loop fast.
- **Local capabilities discovery with detection hooks** *(00:18:57)* — Hooks before/after tool use and at prompt submission give security products like Microsoft Defender stable integration points to inspect and block threats such as indirect prompt injection.
- **Entra Agent ID integration** *(00:22:55)* — Distinct, provisioned agent identities (via Entra and Intune) for session-isolated agents, plus low-cost agent-identification tags for delegated process-isolation scenarios.

## Topics covered
- Why agents differ from traditional software: non-deterministic, act at machine speed, operate on data that may carry adversarial instructions.
- The shift from a prompt-and-answer problem to an execution problem (where code runs, what it can reach, inherited authority).
- Four foundations of trustworthy agentic systems: containment, detection/response, agent identity, and governance.
- A four-stage adoption plan: plan, design, implement, refine.
- The containment spectrum: process isolation, Hyperlight micro-VMs, full Windows/Linux VMs, and Windows 365 cloud PCs.
- Delegated ("agent acts on behalf of user") versus distinct agent-identity models.
- Defender detecting prompt injection hidden in an issue attachment and surfacing it in the Defender portal for SecOps.
- Session isolation demonstrated with a modified OpenClaw agent running under a separate agent user account that cannot access the user's Documents.
- Enterprise governance across Windows, Entra, Intune, Defender, Purview, Agent 365, and GitHub.

## Notable quotes
> "If agent behavior is non-deterministic, then containment becomes the deterministic guardrail around it." — Nazmus Sakib

> "Containment is not a bolt-on. It is a design tool for building safer agentic apps from the beginning." — Nazmus Sakib

> "It is not enough to know that an agent exists. Organizations need to manage its lifecycle, understand what it can access, see what it has done, and apply policy consistently across devices and environments." — Klorida Miraj

## Products and tools mentioned
- Microsoft Execution Containers (MXC) SDK
- Hyperlight micro-VMs
- GitHub Copilot CLI
- Windows 365 (cloud PC)
- Microsoft Entra ID / Entra Agent ID
- Microsoft Intune
- Microsoft Defender
- Microsoft Purview
- Agent 365
- OpenClaw (open-source agent framework, as transcribed)
- Windows Task Manager / File Explorer
- Windows Insider builds

## Speakers featured
- Klorida Miraj — Windows Developer Platform team
- Nazmus Sakib — Windows Enterprise and Security
