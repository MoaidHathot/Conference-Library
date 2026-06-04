<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD806\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD806\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:42:49.0234998+00:00
-->
# Summary

## Overview
.NET 11 brings coordinated improvements across the SDK/tooling layer and the runtime/libraries layer, with a strong orientation toward agent-driven and AI-era development workflows. Chet Husk covers SDK initiatives in new capabilities, performance, and acquisition, while Rich Lander details library updates and two major runtime projects: runtime async and memory safety.

## Key announcements
- **`dotnet run` gains first-class device deployment for .NET MAUI** *(~00:02:44)* — The MAUI team contributed enhancements so `run` can pick a target framework, select a valid device, build the installation payload, and launch it on a simulator, via an extensible protocol usable by frameworks like Uno or Avalonia.
- **Agent-aware .NET CLI** *(~00:03:51)* — The CLI now heuristically detects when it runs under an agent and adjusts output rendering, such as disabling the terminal logger's token-inefficient live update in an LLM context.
- **Native AOT journey for the .NET CLI** *(~00:05:37)* — Bundled tools (user-secrets, dev-certs, user-jwts) are native AOT as of Preview 6, with `dotnet user-secrets` averaging ~54ms (only ~14ms application code); the entire CLI is on track for AOT.
- **MSBuild multi-threaded mode** *(~00:11:06)* — Threads, not just processes, will be supported by the time .NET 11 launches, reducing IPC and JIT-loading overheads; task authors can learn about adoption at the linked resource.
- **`dotnet up` acquisition tool** *(~00:12:14)* — A native AOT tool for consistent, admin-free, user-level acquisition and management of .NET tool chains across platforms, with previews coming soon.
- **SDK payload size reduction via hard links** *(~00:13:39)* — Automated deduplication in tarball layouts shaved roughly 80MB across platforms, benefiting downloads and SDK containers.
- **Process API convenience methods** *(Preview 4, ~00:15:00)* — New APIs (`RunAndCaptureTextAsync`, `ReadAllLinesAsync`, `CreateAnonymousPipe`, fire-and-forget) avoid the classic standard-output/standard-error deadlock and release resources correctly.
- **Runtime async (opt-in)** *(~00:28:37)* — A compile-time optimization that removes compiler-generated state machines in favor of runtime-managed suspension/resumption; opt in via `Features` `runtime-async=on`, enabled in Preview 4 for the product, likely default in .NET 12.
- **Memory safety project (preview)** *(~00:37:42)* — A two-release effort redefining the `unsafe` keyword as a reviewable caller contract and reducing unsafe usage, including in SIMD code.

## Topics covered
- Native AOT and trim-friendliness across CLI dependencies (templating, NuGet, parts of MSBuild)
- OpenTelemetry adoption in the CLI, traceable in the Aspire Dashboard
- Build resource contention from parallel agent work trees and a central MSBuild gatekeeper
- Unicode conformance APIs (`IsValid`, `IndexOfInvalidSubsequence`) and rune-aware string methods
- New regex `Any` newline option and `SearchValues`
- System.Text.Json: per-type/per-property naming policies, null-omission, and JSON Lines streaming
- Compression improvements including integrated Zstandard APIs
- Cleaner async stack frames for production diagnostics
- JIT bounds-check elimination, tail-slice handling, and improved inlining

## Notable quotes
> "When you write new code, and by new code, I mean when you enable runtime async, there's no state machines." — Rich Lander

> "Even shaving 100 milliseconds off of every command translates to real benefits given the number of times each individual developer issues a command." — Chet Husk

> "We're redesigning the unsafe keyword to mean a reviewable caller contract as opposed to establishing an unsafe context." — Rich Lander

## Products and tools mentioned
- .NET 11 SDK and runtime
- .NET CLI (`dotnet run`, `dotnet build`)
- MSBuild
- .NET MAUI
- Uno Platform, Avalonia
- Azure Functions
- Native AOT
- RyuJIT
- NuGet
- `dotnet up`
- DNX
- user-secrets, dev-certs, user-jwts
- OpenTelemetry
- Aspire Dashboard
- System.Text.Json (including JSON Lines / NDJSON)
- Zstandard
- SIMD
- `SafeProcessHandle`, `SearchValues`

## Speakers featured
- Chet Husk [inferred] — Product Manager on the SDK and MSBuild teams
- Rich Lander — Product Manager on the .NET team (runtime and libraries)

## Follow-up resources
- aka.ms/build MSBuild tasks guidance for adopting multi-threaded MSBuild (referenced as "MS/MS build slash Mt tasks" [inferred])
- GitHub discussions and issues for .NET 11 preview feedback
