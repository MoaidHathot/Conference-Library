<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP902\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP902\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:28.3288749+00:00
-->
# Summary

## Overview
This expert-level session demonstrates why AI-generated .NET MAUI interfaces often look unpolished and how pairing a structured design system with reusable "skills" files corrects the problem. Vishnu Menon of Syncfusion argues that AI should not invent UI but be taught a team's existing design rules, then constrained to follow them when composing screens.

## Key announcements
- **Design-system "skills" for Syncfusion MAUI controls** ([00:05:13]) — Skill files stored under `.agents/skills` (for example a Syncfusion MAUI button skill with `skills.md` and `troubleshooting.md`) let an AI agent read implementation guidance, getting-started steps, and troubleshooting before generating UI.
- **Installable skill catalog via the terminal** ([00:07:04]) — Skills for many Syncfusion MAUI controls can be copied into a project by pasting a command in the terminal, which adds the full set of skill files at once.
- **Reusable design-system skill applied to a demo dashboard** ([00:07:57]) — Adding a `design-system` skill alongside the control skills produced an employee dashboard with consistent theming, design tokens, and aligned components, contrasted against an earlier prompt-only attempt.

## Topics covered
- Why prompt-only AI UI generation yields color inconsistencies, misaligned icons, and non-production-ready screens.
- The root cause: AI lacks the application's design context, spacing rules, and component patterns, and has limited knowledge of specific UI controls, leading to guess-based implementations.
- Design systems in .NET MAUI: `styles.xaml` and `colors.xaml` in the Resources/Styles folder defining typography (for example Open Sans Regular), primary colors, and spacing across platforms.
- How design systems reduce hard-coding and eliminate repeated UI decisions, accelerating enterprise development.
- Skills as a mechanism to guide and constrain AI behavior rather than render UI directly.
- The distinction: design systems define what good UI looks like; skills define how the AI should behave.
- End-to-end demo: generating employee models, design tokens, and a dashboard page from a single prompt backed by skills.

## Notable quotes
> "AI is powerful, but without the right inputs and constrain, it can only guess, not design with intention."

> "Skills does not render UI. They constrain the decisions."

> "We are not asking AI to design UI. We are teaching it how we design UI."

## Products and tools mentioned
- .NET MAUI
- Syncfusion .NET MAUI controls (including the Syncfusion MAUI Button)
- Design-system skill files (`skills.md`, `troubleshooting.md`)
- `styles.xaml` and `colors.xaml`
- Open Sans Regular font

## Speakers featured
- Vishnu Menon — Senior Product Manager, Syncfusion
- Shriram Sankaran — listed as a session speaker

## Follow-up resources
- A QR code shown at [00:09:48] links to the demo sample data (URL not stated in the transcript).
