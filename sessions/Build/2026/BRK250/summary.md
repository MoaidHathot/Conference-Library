<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK250\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK250\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:35.0221827+00:00
-->
# Summary

## Overview
The session presents an open-source approach to governing AI agents across any framework, structured around a continuous loop of identifying risks, building evaluations, applying controls, and re-evaluating. Using a LangGraph-based banking manager agent as a running example, the speakers demonstrate two newly open-sourced tools—Assert for requirement-driven evaluation generation and Agent Control Specification (ACS) for framework-agnostic controls—and situate them within Microsoft Foundry's production governance stack.

## Key announcements
- **Assert open-sourced [00:10:18]** — A new tool, built in collaboration with Microsoft Research, that turns natural-language requirements into a detailed risk taxonomy, generates single-turn and multi-turn test sets, and scores results with a rubric-based judge, reducing a 21–28 day manual process to roughly five minutes.
- **Agent Control Specification (ACS) open-sourced [00:25:01]** — A specification sitting between an agent's runtime and policy engine that lets developers apply deterministic and AI-powered controls at input, output, and tool stages, working consistently across multiple frameworks.
- **ACS added to the Agent Governance Toolkit (AGT) [00:26:19]** — AGT, released in early April with an MCP security gateway, sandboxing, and identity, gains ACS as a new module and has already drawn over 100 contributors.
- **Foundry integration for cloud evaluation [00:34:05]** — Assert and ACS connect to Microsoft Foundry for cloud-based evaluation, production traffic sampling, continuous evaluation, and agent optimization, alongside Microsoft Defender, Purview, and Entra ID integrations.
- **Continuous evaluation with an RL-based adaptive attacker [00:37:00]** — Forthcoming research where a reinforcement-learning attacker generates test cases tailored to the specific model and application, learns from production behavior, and feeds signals into continuous learning.
- **Content provenance and information flow control [00:40:18]** — AI-generated images receive an imperceptible watermark and a C2PA-signed manifest; an information flow control project applying integrity and sensitivity labels is now in the GitHub CLI and Fabric.

## Topics covered
- Four failure modes of agents: poor instruction-following, information integrity and data leakage, incorrect tool use, and emergent multi-agent behavior.
- The "lethal trifecta" of context contamination plus internal and external access leading to data exfiltration.
- Limitations of generic safety benchmarks: low quality, inconsistent policies, saturation, and lack of application-specific coverage.
- Systematization: turning vague policy into a falsifiable, granular concept taxonomy reviewed by human risk experts.
- Why prompt-only fixes are insufficient, especially for multi-turn scenarios, and the trade-off between policy violations and over-refusal.
- CI/CD gating of AI safety regressions before shipping.
- Prompt optimization, harness/guardrail changes, and model weight updates as escalating mitigation layers.
- Multi-agent risk, red teaming, and a social reasoning benchmark for agent interaction.

## Notable quotes
> "60% of agents have access to privileged data, they're sharing sensitive data without authorization and they're distributing inappropriate information." — Sarah Bird

> "Before assert, it used to take somewhere between 21 to 28 days... but now it just took us 5 minutes." — Sandeep Atluri

> "We're not going to get to a state of trust if we don't all understand how the evaluations work, how the controls work." — Sarah Bird

## Products and tools mentioned
- Assert
- Agent Control Specification (ACS)
- Agent Governance Toolkit (AGT)
- Microsoft Foundry
- Microsoft Agent Framework
- LangGraph
- Model Context Protocol (MCP)
- Microsoft Defender
- Microsoft Purview
- Microsoft Entra ID
- C2PA
- GitHub CLI
- Microsoft Fabric
- GEPA [inferred]
- DSPy [inferred]
- Social reasoning benchmark (on arXiv)

## Speakers featured
- Sarah Bird — Chief Product Officer for Responsible AI, Microsoft
- Sandeep Atluri — leads Responsible AI science efforts, Microsoft
- Mehrnoosh Sameki
- Katelyn Rothney

## Follow-up resources
- Mark Russinovich's session, which covers content provenance and information flow control in more detail.
