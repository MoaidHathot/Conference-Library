<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP900\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP900\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:11.8262849+00:00
-->
# Summary

## Overview
A technical walkthrough of Arm Performix, a new performance analysis toolkit developed with Microsoft to observe and accelerate workloads running on Azure Cobalt. The session frames performance analysis as an investigative, evidence-driven process and demonstrates how Performix moves engineers from raw metrics to confidence-based, actionable optimizations through guided recipes and LLM integration.

## Key announcements
- **Arm Performix toolkit launch** ([00:00:10]) — A new performance analysis toolkit, built in collaboration with Microsoft performance experts, to observe and accelerate workloads on Cobalt.
- **MCP server integration** ([00:06:16]) — Performix provides an MCP server that couples profiling data, disassembly, target system details, and source code with an LLM to suggest confidence-based improvements.
- **General availability** ([00:07:28]) — Performix is available now, free to download and free to use.

## Topics covered
- Performance analysis as an iterative investigation: hypotheses, evidence-gathering, and revisiting assumptions rather than a linear process.
- Good experimental science: changing one variable at a time, repeating runs for consistency, and comparing against baselines.
- Core Performix concepts: targets (Cobalt instances accessed via SSH credentials) and recipes (experiments/workflows).
- System characterization recipe running microbenchmarks, including memory bandwidth versus access size to assess cache performance.
- System utilization recipe with a CPU heat map across a 96-core system showing core occupancy over a one-second interval.
- Code hotspots recipe for sampling time spent in code across all languages, including Java and .NET, tied back to source.
- Instruction mix analysis comparing matrix multiplications using Arm NEON versus SVE instructions.
- CPU microarchitecture recipe using Arm's top-down methodology to examine cache layers, pipeline stalls, and branch mispredictions.
- Breadth-first analysis followed by deep dives, plus command-line usage for terminal-based workflows.

## Notable quotes
> "Performance analysis can be thought of like a crime investigation. You have suspects, leads, hypotheses." — David Haikney

> "Understanding which parts of our code are hot ensures we can spend time optimizing the right places, something that can't be done with static analysis tools." — David Haikney

> "Powerful MCP server integration means performance analysis goes from being a passive activity of sampling and profiling to a dynamic one of actively suggesting improvements." — David Haikney

## Products and tools mentioned
- Arm Performix
- Azure Cobalt
- Model Context Protocol (MCP) server
- Visual Studio
- Arm NEON
- Arm SVE
- Java
- .NET

## Speakers featured
- David Haikney — Technical Product Director, Arm
