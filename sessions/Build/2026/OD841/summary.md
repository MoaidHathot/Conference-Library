<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD841\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD841\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:47.1819646+00:00
-->
# Summary

## Overview
This advanced-level session demonstrates an integrated security workflow that connects Microsoft Defender for Cloud and GitHub Advanced Security, spanning local code scanning through to runtime cloud risk. James Brotsos argues that the long-standing trade-off between shipping fast and staying secure is dissolved by embedding AI-driven, agentic scanning and remediation directly into developer-native surfaces—terminal, IDE, and pull request—while giving security teams a correlated, prioritized posture view.

## Key announcements
- **Defender CLI powered by code name "MDASH"** [00:02:46] — A multi-model agentic scanning harness that orchestrates over a hundred specialized AI agents across an ensemble of frontier and distilled models, running a five-stage pipeline (prepare attack surface, scan candidate paths, validate by agent debate, de-duplicate, prove the vulnerability with triggering inputs).
- **AI-powered fix command in the CLI** [00:04:19] — Copilot analyzes a SARIF result file, understands code context, and rewrites the vulnerable code to fix it without leaving the terminal.
- **Pull request annotations with contextual fixes** [00:06:22] — Findings such as XPath injection surface in the PR with a plain-language explanation and a Copilot-suggested parameterized fix.
- **AI code security initiative view** [00:07:34] — A single-pane-of-glass posture dashboard that rolls up findings from the CLI, pipeline, and agentless code scanning, scored and prioritized, and correlated with the cloud environment.
- **Code-to-runtime attack path mapping** [00:08:54] — Defender traces a running container back through runtime, ship, build, and code phases, filtering on risk factors like internet exposure and sensitive data paths.
- **GitHub issue creation assigned to Copilot** [00:12:33] — From the attack path view, a GitHub issue is created, assigned to Copilot, and identifies that fixing one package resolves three additional CVEs.
- **AI model artifact scanning** [00:16:04] — The same CLI scanner inspects model artifacts for malicious content, catching a malicious pickle serialization payload in the pipeline before deployment.

## Topics covered
- The broken collaboration loop between developers and security teams
- Agentic, multi-model scanning versus traditional single-model pattern matching
- Shift-left scanning in the terminal before code reaches the repository
- Side-by-side review of AI-generated fixes in the IDE
- Pipeline gating via GitHub Actions
- Correlating code vulnerabilities with runtime cloud risk and business criticality
- Attack path analysis: internet exposure, sensitive data access, and known vulnerabilities combined
- AI model supply-chain security and pickle deserialization attacks
- Discoverability of AI models across Azure ML workspaces and registries
- Immutable artifact remediation ("replace, don't patch")

## Notable quotes
> "The model is one input. The system around it is the product." — James Brotsos

> "It's reasoning about what the code actually does, the way an attacker would." — James Brotsos

> "The security team sees the risk, the developer sees where to fix it, the same data, but with a different lens." — James Brotsos

## Products and tools mentioned
- Microsoft Defender for Cloud
- GitHub Advanced Security
- Defender CLI (code name "MDASH")
- GitHub Copilot
- VS Code
- GitHub Actions
- Azure portal
- Azure Machine Learning
- Hugging Face
- PyTorch
- TensorFlow
- SafeTensors
- SARIF

## Speakers featured
- James Brotsos — Product Manager working on securing code and applications, Microsoft

## Follow-up resources
- The Defender CLI is available today, built into Microsoft Defender and GitHub Advanced Security (no specific link provided in the transcript).
