<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\LIVE172\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\LIVE172\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:33:21.3347435+00:00
-->
# Summary

## Overview
A 15-minute demo-driven session showcasing a developer-optimized Windows 11 experience built around feedback from the "voice of developer" program. The presenters walk through machine setup, terminal enhancements, native containers, AI-assisted Windows app development, and new developer hardware, all aimed at reducing setup friction and accelerating build-and-ship workflows.

## Key announcements
- **WinGet developer configuration file** *(~00:02:00)* — A public, forkable GitHub repo with an opinionated WinGet config that installs developer tools (Python, Node, NVM [inferred], PowerToys, Git) and applies settings like dark mode and File Explorer tweaks, removing the need to manually enable developer mode; generally available today.
- **Core utilities in Terminal** *(~00:04:01)* — Linux-style core utilities (e.g. grep) now run natively in Windows Terminal, letting Unix/Mac/Linux scripts from sources like Stack Overflow or GitHub work without translation to PowerShell.
- **WSL containers and WSLC binary** *(~00:05:16)* — A built-in way to create, run, and interact with Linux containers natively on Windows, shipping with the standard WSL update and exposed as an API for use inside native applications, plus enterprise management controls.
- **Win UI agents and skills plugin** *(~00:07:39)* — A plugin bringing skills and agents (packaging, code review, design, templates) for Win UI/Windows development to GitHub Copilot or Claude Code, reportedly saving over 70% of measurable tokens.
- **WinApp CLI** *(~00:09:15)* — A CLI installable via WinGet that packages apps as MSIX, runs applications with package identity, and works with frameworks like Rust without Visual Studio; previously announced earlier this year.
- **Intelligent Terminal** *(~00:12:14)* — An experimental fork of Windows Terminal with integrated agents that analyze failed commands, suggest fixes, retain context across tabs, and connect to Copilot, Claude, or other agents on a permission-based model.
- **Surface RTX Spark Dev box** *(~00:14:18)* — A developer-first GPU machine with the NVIDIA RTX Spark [inferred] offering up to 1 petaflop of AI compute and 128GB of unified memory, preconfigured with the developer tools by default.

## Topics covered
- Reducing machine setup and update friction for developers
- Distraction-free, developer-first Windows 11 configuration
- Forkable, customizable WinGet configuration files
- Merging Linux/Unix command workflows with PowerShell
- Native Linux container creation, attachment, and detachment via WSLC
- Containers as an API embedded in native Win UI/WPF applications
- Enterprise observability and management of Linux containers
- Agent-augmented end-to-end Windows app development, packaging, and identity
- UI automation tooling that inspects visual trees, takes screenshots, and invokes controls
- AI-assisted error analysis and command correction in the terminal
- Developer-optimized AI hardware

## Notable quotes
> "Anybody can just create a Markdown file and call it a skill. As part of the work that we're doing here, we're creating a set of tools that agents can use to make it really easy for them to develop Windows applications end to end." — Nikola Metulev

> "Through this process we're able to save over 70% of tokens that we can measure." — Nikola Metulev

> "Some of them takes a long time to come out as well. We'll do a good job in the future as well to go take our communities with us and build a great Windows environment for our developers." — Beth Pan

## Products and tools mentioned
- Windows 11
- WinGet
- Windows Terminal
- Core utilities (grep, netstat)
- PowerShell
- WSL / WSL containers / WSLC
- GitHub Copilot
- Claude Code
- Win UI
- WinApp CLI
- MSIX
- Rust
- PowerToys
- Python, Node, NVM [inferred]
- Visual Studio / VS Code
- Intelligent Terminal
- Surface RTX Spark Dev box
- NVIDIA RTX Spark [inferred]

## Speakers featured
- Aditya Ramnathkar — Product Marketing Manager, Windows platform team
- Beth Pan — Principal Software Engineer, Windows platform team
- Nikola Metulev — Principal Software Engineer, Windows platform team

## Follow-up resources
- aka.ms/winuiskills [inferred] — download the Win UI skills (stated verbally as "AK dot Ms. Win UI skills")
