<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM363\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM363\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:04.5462351+00:00
-->
# Summary

## Overview
A practical walkthrough of publishing infrastructure-as-code solutions to the Microsoft Marketplace (formerly Azure Marketplace) via the Azure Application offer. The session traces the full journey from authoring a Bicep template through transpiling to ARM, designing the purchase UI, validating with the ARM Test Toolkit, and publishing through Partner Center to a customer's deployed managed application.

## Key announcements
- **The Azure Marketplace is now the Microsoft Marketplace** — the rebranded marketplace serves ISVs (visibility and go-to-market support), partners (private offer selling and reselling), and end customers (ease of deployment and Azure consumption commitment credit). [00:00:35]
- **Bicep visual designer in the VS Code Bicep extension** — an experimental feature accessed by right-clicking a Bicep file to get an interactive, exportable graphical overview of declared resources. [00:06:09]
- **ARM Test Toolkit (ARM TTK) runs 49 validation tests** — the same tests Microsoft runs on upload, so running them locally first prevents failed upload cycles. [00:12:53]

## Topics covered
- The Azure Application offer structure: a single offer containing multiple plans (e.g. silver, gold, platinum), each deploying a managed application plus a managed resource group (MRG) into the customer's subscription.
- The offer as a technical artifact: a zip file holding up to four files — mainTemplate.json (ARM) and createUiDefinition.json (mandatory), plus viewDefinition and optional deployment scripts.
- Authoring resources in Bicep and transpiling to ARM via `bicep build` or right-click build, with a side-by-side comparison arguing Bicep is cleaner than ARM's bracket/syntax overhead.
- Performing a test deployment to a test resource group before any marketplace work.
- Designing the portal purchase UX in the createUiDefinition sandbox environment, including previewing elements like VM sizes, passwords, storage accounts, and networks.
- One-to-one, case-sensitive mapping between createUiDefinition `outputs` and ARM/Bicep template parameters (e.g. local admin user).
- Partner Center technical configuration: zip upload, version naming, incremental vs. complete deployment mode, notification endpoint URL for purchase/cancel/upgrade events, and MRG access permissions for publisher and customer.
- Inspecting the deployed result: the no-cost managed application collecting billing/telemetry, the linked MRG holding VMs, load balancers, and key vaults, and nested deployments (including an ISV ID deployment for partner credit).

## Notable quotes
> "I want to kick us off with a bold statement saying that I believe that building Azure solutions today is easy... but shipping something to customers in a way that they able to trust it and to deploy it at scale, that is where it becomes challenging."

> "Even though the marketplace doesn't support bicep, I strongly advise you to start with bicep and then simply transpile into arm templates. So I'm a Bicep fan in case you didn't know this."

> "Do not upload that ZIP file before you see the 49 results in a successful state."

## Products and tools mentioned
- Microsoft Marketplace (formerly Azure Marketplace)
- Azure Application offer
- Azure managed application / managed resource group (MRG)
- Bicep
- ARM templates
- Visual Studio Code
- VS Code Bicep extension (with visual designer)
- createUiDefinition
- ARM Test Toolkit (ARM TTK)
- Partner Center
- GitHub Copilot
- GitHub

## Speakers featured
- Freek Berson — Microsoft MVP, based in the Netherlands, works for an ISV; author of a book on Bicep. [inferred] (captioned as "Craig Berson")

## Follow-up resources
- Session code published on the Microsoft-provided GitHub, accessible via a QR code shared at the end of the session.
