<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEMSP387\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEMSP387\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:58.5799588+00:00
-->
# Summary

## Overview
OpenShell is an open-source, Apache 2.0 agent-native runtime started by Ali Golshan and Alex Watson at NVIDIA to govern long-running autonomous agents in CLI environments. The session frames a zero-trust, secure-by-design model in which every agent runs inside an isolated sandbox, credentials are held outside it, and policy enforcement is pushed down to the kernel and infrastructure layer so that controls become deterministic rather than probabilistic.

## Key announcements
- **OpenShell, an open-source agent-native runtime (Apache 2.0)** — A project begun roughly eight months ago on 20% time, with roadmap, architecture, and code published on its GitHub repository [00:00:14].
- **Policy Prover for formally verified policy** — Policies written in OPA/Rego (or YAML) are translated into formal logic so an SMT-style solver can mathematically prove what an agent can still do, catching exfiltration paths a reviewing agent or human could be fooled into missing [00:04:22].
- **Sub-millisecond proving performance** — The prover runs in single-digit milliseconds, avoiding the doubled token cost and latency of using a second agent to review every action [00:07:11].
- **Privacy Router** — Inspects queries for PII and routes them to a local model, out to a frontier model, or rewrites them using differentially private techniques (low-epsilon DP) to preserve utility while keeping PII local [00:07:37].
- **Partner availability** — Announced (per a Microsoft announcement "yesterday") as embedded in Windows native WSL, Azure, and GitHub, and available via Canonical on Ubuntu, Red Hat OpenShift, and Docker [00:18:30].
- **Drivers for pluggable sandboxing** — Users can select the underlying isolation primitive (Firecracker, hardened containers, trusted computing, or gVisor/Kubernetes sandboxing) while OpenShell enforces the runtime on top [00:19:28].
- **Beta timeline** — Currently alpha (released at GTC in San Jose in March); beta targeted for the next couple of months, with potential donation to CNCF or the Linux Foundation [00:19:11].

## Topics covered
- Zero-trust sandbox model where every environment starts fully closed and access is granted incrementally.
- Gateway architecture holding credentials, secrets, and tokens outside the sandbox to limit blast radius from prompt injection.
- Running the agent itself inside the sandbox so a single policy language governs any agent across infrastructure.
- Agent self-negotiation of access against global policies, validated by the Policy Prover before grant.
- Hot-reloading of network and filesystem policies without restarting sandboxes, for machine-speed operation.
- GitHub as a persistence and audit layer using a map-reduce/fan-out pattern across multiple sandboxes.
- Logging in OCSF (Open Cybersecurity Schema Format), compatible with Splunk and Datadog.
- Google's A2A protocol [inferred] for high-rate inter-agent communication.

## Notable quotes
> "Every sandbox, every environment starts completely closed down. And then as the agent is basically granted access and additional components, it can move." — Ali Golshan

> "There's no way to fool an agent into not seeing that you're doing it. The prover will see it and will highlight that." — Alex Watson

> "Even 1% approval to human looks like thousands of prompts per day." — Ali Golshan

## Products and tools mentioned
- NVIDIA OpenShell
- GitHub Copilot
- OpenAI Codex
- Anthropic Claude
- OPA / Rego
- OCSF (Open Cybersecurity Schema Format)
- Splunk
- Datadog
- Firecracker
- gVisor
- Kubernetes
- Google A2A protocol [inferred]
- Windows WSL
- Microsoft Azure
- GitHub
- Canonical Ubuntu
- Red Hat OpenShift
- Docker
- Gretel

## Speakers featured
- Ali Golshan — co-creator of OpenShell at NVIDIA; co-founder of Gretel
- Alex Watson — co-creator of OpenShell at NVIDIA; co-founder of Gretel

## Follow-up resources
- The OpenShell GitHub repository (referenced for roadmap, architecture, code, and the examples used in the demos).
