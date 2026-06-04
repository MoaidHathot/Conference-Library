<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM315\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM315\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:29.9444329+00:00
-->
# Summary

## Overview
Microsoft Discovery is positioned as an "Agentic Discovery" platform that moves R&D from AI-assisted tasks to autonomous teams of AI agents executing the full scientific method under human direction. The session pairs a vision framing of "frontier R&D" with a live demonstration of the newly released free desktop app and customer outcomes from enterprise deployments.

## Key announcements
- **General availability of Microsoft Discovery** — The enterprise platform, introduced in private preview at last year's Build, has moved to general availability (00:04:47).
- **Microsoft Discovery app (free download)** — A lightweight local on-ramp to frontier R&D that requires only a GitHub Copilot license and no Azure account to get started (00:05:23).
- **Discovery Engine** — A cognitive layer that fully automates the discovery loop (hypothesis, experimentation, reasoning), spawning and assigning tasks to agents and abandoning or continuing research paths based on model confidence scores (00:07:24).
- **Bookshelf with GraphRAG** — A graph-based information retrieval system that indexes scientific papers using entity-relationship graph structures rather than a traditional vector store, productizing GraphRAG technology from Microsoft Research (00:07:19).

## Topics covered
- The shift from AI as a productivity accelerator (incremental 20–30% gains) to agentic systems performing whole workflows.
- Parallels between agentic software engineering and agentic scientific R&D.
- The scientific method (reasoning, hypothesis, experimentation) as an automatable loop.
- Indexing scientific corpora: converting PDFs to markdown and GraphRAG versus vector embeddings.
- Prompt engineering for science: detailed, expert-driven instructions yield better results.
- A worked example evaluating containers versus serverless function execution for agentic tool calling, including cost models, cold-start latency, duty-cycle break-even, and a hybrid recommendation.
- Agents and tasks: prebuilt agents, markdown instructions compatible with GitHub Copilot agents, task dependencies, delegation, and subtasking.
- Reproducibility via saved computational "golden path" plans and in-silico-to-wet-lab next steps.
- Customer example (Science Co [inferred]): business agents identifying heat transfer fluids for semiconductors as an R&D investment, then multi-parameter optimization to find four candidate fluids.

## Notable quotes
> "We're flipping from AI assisting work to AI performing work, not replacing humans, but shifting the role that humans play in this new model." — John Link

> "This is not removing scientists, it's amplifying scientific judgment." — John Link

> "We collect the data, we formulate the problem, and then we let the system do the work while we can have a nice conversation about the product." — Viktor Veis

## Products and tools mentioned
- Microsoft Discovery (enterprise platform and app)
- Discovery Engine
- Bookshelf (GraphRAG)
- GraphRAG (Microsoft Research)
- GitHub Copilot
- Visual Studio Code
- Azure HPC
- Azure AI Foundry
- Jupyter Notebook
- Claude Opus 4.5 [inferred]
- GPT-5.2 [inferred]

## Speakers featured
- John Link — Partner Product Manager, Microsoft Discovery
- Viktor Veis — Microsoft Discovery (presenter/demo)

## Follow-up resources
- Microsoft Discovery enterprise documentation: aka.ms/Microsoft Discovery docs (as spoken)
- Microsoft Discovery GitHub repository (local app download and releases)
