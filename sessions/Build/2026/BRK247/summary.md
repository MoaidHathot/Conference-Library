<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK247\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK247\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-06T08:21:41.9161093+00:00
-->
# Summary

## Overview
A live, demo-heavy session in which Mark Russinovich and Scott Hanselman offer a "no hype" assessment of how agentic coding is reshaping software engineering—where it delivers genuine boosts, where it produces "slop" and "nonsense," and what this means for the profession. Their central argument is that AI accelerates experienced engineers with good "taste" while struggling to uplift early-career developers, threatening the pipeline that produces senior talent.

## Key announcements
- **Shared-memory transport for gRPC** — Russinovich and another Microsoft engineer used agentic coding to add a shared-memory path to gRPC for Go and .NET, achieving dramatic latency/throughput gains over TCP and Unix domain sockets, and are preparing to submit it upstream (~00:30:00–00:33:00).
- **Tiny Tool Town** — Hanselman showed a GitHub-powered website hosting 451 small personal tools, where users can contribute their own by filing an issue (~00:09:16–00:10:48).
- **Open Claw Windows companion app** — an open-source app with skills, voice, markdown files, permissions, and a rich diagnostic section, built by a small team Hanselman invited contributions to (~00:33:44–00:34:08).
- **Zoom It panorama screenshot feature** — a new scrolling-screenshot capability stitched from multiple PNGs, which proved "incredibly hard" due to subpixel/BGR anti-aliasing complicating image matching (~00:19:08–00:23:44).
- **Preceptorship paper** — the speakers co-authored a paper proposing a nursing-style "preceptorship" model for mentoring early-career engineers in the AI era (~00:40:44–00:41:44).

## Topics covered
- A spectrum of AI-assisted work from "slop" through "vibes" to production-grade engineering.
- Internal Microsoft examples: Microsoft Scout (codename "Lobster" [inferred], 17 engineers) and the .NET Aspire team's agentic workflows.
- "Commit maxing" and token-maxing as misleading productivity metrics; activity versus impact.
- AI failure modes: sleeps inserted to "fix" race conditions, blaming benchmarks instead of code, false task-completion claims, sycophancy ("you're absolutely right"), and self-flagellating error messages.
- Context windows versus human accumulated context; why "commit early, commit often" matters.
- "Sculpting"—actively watching and steering the model rather than prompting blindly.
- The MIT study on cognitive offloading (handwritten vs. Google vs. ChatGPT essays) and system 1/system 2 thinking.
- The decline in early-career hiring and the risk of a missing-senior-engineer "hole."
- Enduring fundamentals: concurrency, memory management, testability, maintainability.

## Notable quotes
> "Activity is not impact."

> "There's no shortcut to learning... you actually use your brain muscle and make it hurt."

> "The future of software engineering is not who writes the code."

## Products and tools mentioned
- GitHub Copilot
- Claude / Claude Opus (referenced as Opus 4.5, 4.7, and 4.8 [inferred])
- Microsoft Scout
- .NET Aspire
- Zoom It
- Winget
- gRPC
- Dapr (Distributed Application Runtime)
- ffmpeg
- Open Claw
- 1Password
- Microsoft Teams

## Speakers featured
- Mark Russinovich
- Scott Hanselman
- Darby Kosten
- Simon Willison — cited for his definition of an engineer's job (present at the event)
- Ion Stoica — creator of Mesos and Spark, professor at UC Berkeley, cited on AI oversight
