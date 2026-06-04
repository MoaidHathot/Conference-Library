<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM304\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM304\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:31:08.5043631+00:00
-->
# Summary

## Overview
C# is gaining union types in C# 15, a feature that lets developers model a closed set of data shapes and gain compiler-enforced exhaustiveness and implicit conversions. Mads Torgersen and Dustin Campbell demonstrate the syntax, show two usage patterns (grouping pre-existing types versus declaring discriminated unions afresh), and reveal the struct-based implementation that underlies the feature.

## Key announcements
- **Union types are coming to C# 15, shipping November** *(00:00:30)* — the feature is already available in preview for developers to try.
- **Unions enforce exhaustiveness in switch expressions** *(00:04:58)* — once a value is typed as a union, the compiler warns when not all case types (including null where applicable) are handled.
- **Implicit conversions from case types to the union** *(00:03:18)* — case types convert automatically to the union type, while non-member types (e.g. a shark added to a list of pets) produce a compile error.
- **Unions can be generic and carry function members** *(00:09:55)* — a `result<T>` union can wrap `success<T>` and `error`, and unions may declare computed properties and methods, though additional instance state is disallowed.
- **A `[Union]` attribute and `IUnion` interface ship in .NET 11 Preview 4** *(00:15:08)* — developers can hand-author union types for custom, non-boxing implementations or retrofit existing hand-rolled union classes.

## Topics covered
- Modeling sets of unrelated types (a dog library and cat library) under one "pet" concept without a shared base class.
- Compiler-enforced exhaustiveness and implicit case-type conversions.
- Discriminated-union style modeling where case types are declared together with the union (wire protocol success/error results).
- Adding computed members to a union while prohibiting extra instance state.
- The underlying implementation: a struct with a single boxed `object` value property, requiring constructors as union creation members.
- Custom union implementations to avoid boxing value types in performance-sensitive code.
- Why C# chose nominal, declared unions over TypeScript-style structural unions: .NET types must exist at runtime.

## Notable quotes
> "It took us five years roughly to get to this very simple design." — Mads Torgersen

> "We're really in the business of giving you more errors, and you love us for giving you more errors, because you're getting a tighter control of your scenario." — Dustin Campbell

> "TypeScript has it easy because all the types in TypeScript go away at compile time... But if we do union types in C#, they have to mean something at runtime too." — Mads Torgersen

## Products and tools mentioned
- C# 15
- .NET 11 (Preview 4)
- Visual Studio (preview)
- Visual Studio Code with the C# extension (Insiders/pre-release)
- GitHub Copilot
- TypeScript

## Speakers featured
- Mads Torgersen — Lead designer of C#
- Dustin Campbell — Engineer on the C# team

## Follow-up resources
- Visual Studio preview with union type support (.NET 11 preview)
- VS Code C# extension (pre-release/Insiders)
- The C# team's "experts zone" / Pavilion in the green dev tools area at the conference
