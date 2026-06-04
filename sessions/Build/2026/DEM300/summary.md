<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM300\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM300\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:30:58.9137951+00:00
-->
# Summary

## Overview

A demo-driven expert session showing how Visual Studio's profiler agent integrates AI-powered Copilot with benchmark.net and the Visual Studio Profiler to guide performance optimization. Using the popular CSV Helper NuGet library as a live target, the session walks through a measure-change-remeasure optimization loop, illustrating both successful and unsuccessful optimization attempts to demonstrate the realistic, data-driven nature of performance work.

## Key announcements

- **Profiler agent in Copilot chat** *(00:07:13)* — A dedicated agent invoked via `@Profiler` that knows how to write benchmarks, run the profiler, and analyze traces directly within Visual Studio.
- **Visual Studio integration with benchmark.net diagnosers** *(00:08:23)* — A Visual Studio diagnoser package published on NuGet (benchmark.net Diagnosers) lets the profiler pull diagnostic data from a benchmark while it runs.
- **Profiler "go to source" guided investigation** *(00:13:50)* — The agent uses profiling data rather than plain text search to identify which source lines consume the most time and steer its investigation.
- **Trace analysis and top insights** *(00:21:19)* — An analyze button and generate-top-insights feature surface known bad patterns in .NET and C++ (such as calling `Contains` on a list) and suggest concrete optimizations.

## Topics covered

- A structured optimization workflow: understand the issue, create a benchmark, enter the measure-change-measure loop, then verify improvement.
- Benchmarks framed as "unit tests for performance" — reusable, durable test harnesses paired with the profiler.
- Using benchmark.net global setup to isolate the code under measurement (resetting a memory stream's position rather than recreating test data).
- Generating a CSV-writing benchmark with Copilot by referencing existing read benchmarks in the project.
- Switching to benchmark switcher to select benchmarks at runtime.
- Optimizing the `ShouldQuote` logic into a single character-pass; the change dropped its CPU share from 13% to 7% but produced no overall time win (1.4 ms before and after).
- A prior successful optimization of the create-write delegate that improved timing from ~1.1 ms to ~0.8 ms (a 25% win).
- The reality that performance gains are usually many small "paper cuts" rather than a single 10x fix.
- Using Copilot as a learning tool to explain optimization results (e.g., JIT inlining limits based on IL instruction counts).
- Injecting functional tests into the loop so Copilot validates optimizations against existing tests.

## Notable quotes

> "Because if you're not actually measuring with data, you're not optimizing, you're just refactoring code. And so the data is really what turns it from a refactoring into an optimization." — Nik Karpinsky

> "It's these small little paper cuts all over your code base that are really just tripping you up and really starting to hurt you." — Nik Karpinsky

> "You can use Copilot to not only kind of achieve the results that you're looking for, but you can also use it to learn and grow as a software engineer as well." — Nik Karpinsky

## Products and tools mentioned

- Visual Studio
- Visual Studio Profiler
- Visual Studio profiler agent
- GitHub Copilot
- benchmark.net
- benchmark.net Diagnosers (Visual Studio package)
- CSV Helper [inferred]
- NuGet
- .NET
- C++

## Speakers featured

- Nik Karpinsky — Software Engineer at Microsoft, ~12.5 years on Visual Studio, primarily the Visual Studio Profiler

## Follow-up resources

- CSV Helper library, uploaded in the GitHub repo for the session
- CSV Helper optimization PR
- Profiler agent documentation
- Breakout session 207 (Mainstage, 4:00) with Mads [inferred] Karpinsky, covering the profiler agent, debugging agent, and unit test creation
