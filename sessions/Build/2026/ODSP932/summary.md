<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP932\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP932\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:45:09.2469424+00:00
-->
# Summary

## Overview
A product demonstration of the Aikido plugin for Visual Studio Code, which integrates security scanning directly into the developer's IDE. The session shows how the extension detects secrets, code security issues, infrastructure-as-code issues, code quality problems, and vulnerable dependencies while developers write code, embodying a "shift-left" security approach.

## Key announcements
- **Aikido plugin for VS Code** [00:00:03] — An IDE extension that scans files for secrets, code security issues, infrastructure-as-code issues, and code quality issues during development.
- **Pre-commit hook** [00:00:24] — Checks for any secrets before a commit is made.
- **Safe Chain malware package scanner** [00:00:32] — Bundled malware scanner for packages, included with the plugin.
- **Aikido MCP** [00:00:36] — Runs on generated code and executed prompts to support workflows such as vibe coding.
- **Fix with Aikido AI** [00:00:27] — AI-generated fixes that can be pushed directly into a file or rejected, with red lines marking problematic code and green lines marking the suggested replacement.
- **Workspace and dependency scans** [00:01:50] — A full workspace scan lists all files with detected issues, and a dependency scan surfaces vulnerable open-source dependencies with autofix capability in the IDE.

## Topics covered
- Shift-left security and in-IDE scanning during development
- Secret detection and pre-commit secret checking
- Code security, infrastructure-as-code, and code quality issue detection
- AI-assisted impact assessment and automated fixes
- False-positive reporting
- Malware package scanning via Safe Chain
- Open-source dependency scanning, including outdated package detection in POM XML
- MCP integration for AI-assisted ("vibe") coding
- Installation via Aikido license, login button, or personal access token

## Notable quotes
> "The Aikido plugin is built to scan your files for secrets, code security issues, IEC issues, and code quality issues while you're developing. This is the ultimate shift-left movement." — Simon Mahieu

> "On every code that gets created or every prompt that is ran, we will also run the Aikido MCP." — Simon Mahieu

## Products and tools mentioned
- Aikido plugin for VS Code
- Visual Studio Code
- Aikido AI
- Aikido MCP
- Safe Chain
- Aikido personal access token / license

## Speakers featured
- Simon Mahieu — Aikido
