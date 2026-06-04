<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP938\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP938\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:45:22.5856000+00:00
-->
# Summary

## Overview
A 15-minute practical walkthrough of five high-impact strategies for hardening GitHub Actions workflows against software supply chain attacks. Erika Heidi of Chainguard frames each recommendation around real exploitation patterns, repeatedly citing the Trivy attack as a concrete example of how insecure defaults, hijacked tags, and over-privileged tokens can be chained into org-wide compromise.

## Key announcements
- **Use Copilot agent to audit workflows (00:00:51)** — Pointing the Copilot agent at a repository and prompting it to evaluate GitHub Actions reliably surfaces vulnerabilities such as `pull_request_target` code execution, exposed secrets, and tag-pinned actions.
- **Chainguard minimal container images (00:05:54)** — Built from source and kept patched, the Chainguard Python image carried four CVEs versus 579 for the default Docker Hub Python image.
- **Chainguard Libraries for trusted dependencies (00:09:15)** — Available for Python, Java, and JavaScript, these are built in a tamper-proof environment with no pre/post-install scripts, claiming to avoid more than 90% of build- and distribution-time attack risk.
- **Digestabot for digest pinning (00:11:02)** — A free, open-source Chainguard tool that opens pull requests with updated digests whenever a container image or GitHub Action publishes a new version.
- **Octo-STS for short-lived tokens (00:13:06)** — A free GitHub app that issues temporary, fast-expiring credentials using the same concepts behind Sigstore and Cosign, replacing long-lived personal access tokens.

## Topics covered
- Risks of `pull_request_target` with head code execution, which runs PR code in the main branch context with access to secrets and environment variables.
- The Trivy attack as a case study in PAT exfiltration, tag rewriting, and org-wide takeover.
- Branch and release-tag protection to prevent direct pushes and tag rewriting that propagate malicious code.
- Minimizing attack surface across direct and transitive dependencies, including base OS and runtime layers.
- Ghost releases and the gap between verifiable source code and tampered build artifacts in public registries.
- The statistic that 98% or more of malware is inserted at build and distribution time, bypassing maintainer review.
- Pinning actions and images to a digest (a unique build hash) rather than a mutable tag.
- Banning long-lived, broad-privilege personal access tokens in favor of short-lived credentials.

## Notable quotes
> "98% or more of malware is inserted during build and distribution time. So it bypasses regular review from maintainers."

> "Attackers are shifting left and they are focusing on turning developer laptops and CI/CD pipelines into nodes for propagation because that's where all the credentials and secrets are."

> "Pinning to a digest is the safest practice you can use regarding tagging containers and GitHub actions."

## Products and tools mentioned
- GitHub Actions
- GitHub Copilot agent
- Chainguard Containers
- Chainguard Libraries
- Docker Hub
- Digestabot
- Octo-STS
- Sigstore
- Cosign
- Trivy [inferred]
- npm

## Speakers featured
- Erika Heidi — Staff DevRel Engineer, Chainguard
