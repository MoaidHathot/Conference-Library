<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP901\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP901\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:24.9498736+00:00
-->
# Summary

## Overview

Most Azure teams overestimate how much of their infrastructure is actually managed by Terraform, with real coverage often falling between 40 and 60 percent. This session demonstrates how Terraform Search (the `terraform query` command) discovers unmanaged Azure resources, generates configuration and import blocks automatically, and how HashiCorp Sentinel then enforces organizational policy to close the gap between declared and running infrastructure.

## Key announcements

- **Terraform Search via the `terraform query` command** [00:05:42] — Available in the Terraform CLI since Terraform 1.14 (released November 2025), it inverts the import workflow: instead of writing import blocks by hand, you define a query, run it, and let Terraform discover matching unmanaged resources.
- **Automatic code generation from discovery** [00:06:58] — Search generates resource definitions and import blocks into a `.tf` file (the demo's four resources produced roughly 300 lines), eliminating hand-coding and copy/paste errors while keeping output reviewable in a pull request.
- **HashiCorp Terraform agent skills** [00:13:14] — The discovery-to-import workflow can be set up programmatically through agentic loops.

## Topics covered

- The measurable gap between Terraform state and resources actually running in subscriptions and tenants.
- Four common reasons resources end up unmanaged: "I'll codify it later," 2 a.m. incident fixes, inherited acquisitions, and POCs that became production.
- Why ungoverned AI/GPU workloads amplify risk: untagged cost attribution, collapsed network isolation between training and inference, and identity sprawl from per-agent managed identities and scopes.
- The evolution of import tooling: one-at-a-time CLI `terraform import`, import blocks since Terraform 1.5, and now query-driven discovery.
- The three-step search workflow: define a query, run `terraform query`, generate config.
- Scoping queries to specific resource groups and inheriting Azure credentials from existing provider config.
- Applying HashiCorp Sentinel policies to imported resources to eliminate drift and enforce tags, naming conventions, instance types, and SKUs.
- Sentinel soft-fail versus hard-fail enforcement modes.

## Notable quotes

> "The gap here isn't dishonesty, it's that nobody's measuring."

> "Three commands, instead of three weeks of inventory work."

> "Terraform happily imports those, Sentinel then prevents you from making further changes until you've eliminated this drift."

## Products and tools mentioned

- HashiCorp Terraform
- Terraform Search / `terraform query` command
- Terraform CLI (1.5, 1.14)
- HCP Terraform
- HashiCorp Sentinel
- HashiCorp Terraform agent skills
- Microsoft Azure (portal, subscriptions, resource groups)
- Azure NAT gateway, network security groups, public IP addresses, storage account, function app, private DNS
- Terraform Registry (Azure policy packs)

## Speakers featured

- Kerim Satirli — Senior Developer Advocate, HashiCorp

## Follow-up resources

- Terraform Registry: registry.terraform.io (Azure policy packs)
- Documentation for the CLI commands (referenced, URL not provided)
- Blog post on the why and how of Terraform query (referenced, URL not provided)
- Sentinel playground demonstrating the full policy (referenced, URL not provided)
