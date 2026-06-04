<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\BRK210\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\BRK210\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:29:01.7141770+00:00
-->
# Summary

## Overview
This session reframes developer productivity for the AI era around Microsoft's EngThrive model, arguing that AI changes how engineers work but not the fundamental nature of productivity. Tim Bozarth contends that teams must measure and target outcomes rather than activity, organizing all metrics under the triad of Speed, Ease, and Quality, and demonstrates the approach through two short, high-impact case studies.

## Key announcements
- **EngThrive framework defined by Speed, Ease, and Quality [~00:13:00]:** Microsoft's mission to "make it fast and easy to build great work," where fast/easy describe how teams work and great work describes what they make, with all three dimensions held in balance rather than traded off.
- **Focus-time case study recovered ~2.1 hours per engineer per week [~00:28:21]:** An 8-week program run by a small team using Viva Insights data yielded a 13% PR-velocity increase, a 25% decrease in "bad developer day" telemetry, and roughly 55,000 recovered engineering hours.
- **Time-to-first-PR case study hit the sub-one-week target [~00:30:44]:** An 8-week effort across Microsoft drove new-hire and team-transfer onboarding speed down using an onboarding agent, improved PR documentation, video exercises, and manager communication.
- **First Mate onboarding agent [~00:32:02]:** A day-zero agent attached to each new engineer to help them ship their first PR and progress toward their 10th and 30th PRs.
- **SRE Agent origin [~00:30:01]:** Operational and system-health toil identified through focus-time work became the impetus for an agent that handles routine SRE/operational tasks, freeing SREs for deeper work.
- **New EngThrive paper on "bad developer days" [~00:28:55]:** A paper published within the prior few weeks expands on the bad-developer-day concept.

## Topics covered
- Two AI value propositions: improving products versus transforming how engineers work (the latter being the talk's focus).
- How developer time actually divides: roughly 40% innovation, ~45% keeping the lights on, ~15% organizational responsibilities, with active coding only 10-15% of the week.
- The three waves of AI interaction: transactional chat, asynchronous agent tasks, and agents pursuing complex goals with tools, memory, and entitlements.
- Shifting SDLC weight from create/operate toward plan and validate as coding trends toward zero.
- Code becoming a system output rather than input; non-uniform model capability across coding, architecture, verification, operations, and "taste."
- Activity metrics versus outcome metrics, and failure modes like "token maxing."
- Measuring systems rather than individuals; productivity versus performance.
- Core outcome metrics: idea-to-customer time, innovation-time ratio, and quality measures (defect escape, incidents per PR, mean time to mitigate, customer experience).
- Operating principles: bottleneck focus, leadership accountability, and continuous improvement over fixed benchmarks.
- Focus-time research: 60/90/120-minute flow thresholds, with Microsoft adopting 120 minutes.
- Why gaming an outcome metric (e.g., a no-op first PR) still produces real value.

## Notable quotes
> "Activity describes motion, outcomes describe progress."

> "If you can game an outcome metric, you get promoted. If you can game an activity metric, well, welcome to the game."

> "As engineers, as first line managers, as second line managers, as wherever we are, we have way more power than we think."

## Products and tools mentioned
- Microsoft EngThrive
- Viva Insights
- First Mate (onboarding agent)
- SRE Agent
- ChatGPT
- Azure
- Microsoft Teams
- Microsoft Secure Future Initiative [inferred]

## Speakers featured
- Tim Bozarth — Microsoft engineering leader; previously ran platform and infrastructure work at Netflix and engineering programs at Google (per remarks during Q&A).
