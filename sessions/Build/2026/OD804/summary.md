<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD804\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD804\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:42:44.3757578+00:00
-->
# Summary

## Overview
dotnetup is a new, cross-platform tool for acquiring and managing .NET SDK and runtime installations at the user level without requiring elevation. It aims to unify the fragmented landscape of IDE-based, package-manager, and manual install methods into one consistent, signed, auditable experience for both human developers and automated agents.

## Key announcements
- **dotnetup, a new cross-platform .NET install manager** [00:00:06] — A native AOT tool that behaves identically on every platform and installs .NET into the user directory without admin elevation.
- **global.json-driven SDK installation** [00:18:32] — Running `dotnetup sdk install` reads a repo's global.json (including roll-forward policies like `latestFeature` and `latestPatch`) and installs the matching SDK automatically.
- **Standalone runtime installation** [00:27:58] — `dotnetup runtime install 8.0 9.0 10.0` fetches multiple runtimes for multi-targeted test runs without installing full parallel SDKs.
- **Tracking, updates, and uninstalls via a manifest** [00:30:38] — `dotnetup list` tracks installed components and the channels being followed; `dotnetup update` installs new releases and removes out-of-date installs no longer needed.
- **Signed binaries and manifests** [00:09:42] — Work with the .NET releases teams to sign all binaries and manifests for provenance and supply-chain safety.
- **Roadmap milestones** [00:38:33] — Internal preview (stable SDKs, daily builds, one-shot A/B execution), public preview (self-update, update notifications, full signature verification, agent skills) before end of summer, then GA with official docs.

## Topics covered
- The heterogeneous state of .NET installation across Visual Studio, VS Code, package managers (WinGet, Homebrew), install scripts, and version managers (DNVM, Mise-en-Place, ASDF).
- Tradeoffs between centralized package-manager updates and per-repo SDK version control, especially the quarterly feature-band cadence.
- User-global (non-elevated) installs scoped to the user directory versus system-global installs.
- Multi-targeting libraries (e.g., NetStandard 2.0 source, tests targeting .NET 8/9/10) and running tests against multiple runtimes with a single latest SDK.
- A manifest/lock-file model for declared desired state, distinct from per-repo global.json.
- Component-based toolchain thinking (SDKs and runtimes as discrete components), drawing comparison to rustup.
- Designing for both humans and agents (LLM agents and CI/CD systems), including guardrails for non-elevated sandboxed use.
- Production guidance: prefer package managers or self-contained deployments rather than dotnetup.
- Planned integration with `actions/setup-dotnet` and the Azure DevOps UseDotNet task.

## Notable quotes
> "There's all those different installation mechanisms, and we discovered we would make another one. And this is the one that will solve all the problems. And I'm only half joking here." — Chet Husk

> "It's not just installations. It's understanding what you need and what you have and what is available and making those things all align consistently." — Chet Husk

> "When you use this tool, we want you to be confident that you are using the bits that Microsoft intended for you to use here." — Chet Husk

## Products and tools mentioned
- dotnetup
- .NET SDK / .NET CLI
- .NET runtime, ASP.NET Core runtime, Windows Desktop runtime
- Visual Studio
- Visual Studio Code (.NET install extension)
- WinGet, Homebrew
- DNVM (.NET Version Manager), Mise-en-Place, ASDF
- dotnet-install scripts
- global.json
- MSBuild Terminal Logger
- GitHub Actions `actions/setup-dotnet`; Azure DevOps UseDotNet task
- Dependabot, Renovate
- Aspire CLI
- Oh My Posh, Oh My Zsh
- rustup [inferred]

## Speakers featured
- Chet Husk — engineer on the .NET SDK team

## Follow-up resources
- aka.ms/dotnetup/get-dotnetup — acquisition script
- aka.ms/dotnetup/docs — Getting Started documentation
- dotnetup design spec (linked from the docs)
- dotnetup/feedback — discussion board on the .NET SDK repo
- github.com/baronfell/dotnetup-repo-patterns-demo — sample repo and GitHub Actions
- get.dot.net — the .NET download website
- dotnet/skills repo — planned agent skills
