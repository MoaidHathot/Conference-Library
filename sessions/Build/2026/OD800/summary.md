<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD800\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD800\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:33:23.9496664+00:00
-->
# Summary

## Overview
Azure SRE Agent product managers demonstrate an AI-powered agent that moves site reliability engineering from passive alerting to autonomous action across the software lifecycle. Through two live demos, the session shows the agent preventing risky deployments via canary testing and automatically diagnosing, root-causing, and remediating a production incident, all while integrating with existing developer and incident-management tools.

## Key announcements
- **Azure SRE Agent for incident management and resource optimization** — An always-on AI teammate that automates operational tasks, accelerates root cause analysis, and is fully customizable to an organization's standards (00:03:58).
- **CLI-based agent creation and management** — Developers can create, configure, and interact with the SRE Agent entirely from developer tools like the terminal and Copilot CLI, using prebuilt recipes from the Microsoft SRE Agent repo rather than the Azure Portal (00:09:05).
- **SRE Agent endpoint as an MCP server** — The agent can be accessed as an MCP server to view analyses or configure it outside the Azure Portal (00:14:46).
- **Three operational modes** — Interactive (Copilot-style), reactive (alert-driven response via Azure Monitor, PagerDuty, ServiceNow), and proactive (scheduled cron-based health, compliance, and security checks) (00:40:50).
- **Enterprise trust and control layer** — Built-in reader/standard/administrator roles, per-agent user-assigned managed identity, "on behalf of" elevation, review versus autonomous run modes, command validation hooks, and KQL-queryable audit trails in Application Insights (00:37:30).
- **Inbuilt evaluation metrics** — An Intent Met quality score automatically calculated on every completed thread, rated on a one-to-five scale (00:40:23).

## Topics covered
- Reducing operational toil across inner-loop and outer-loop software development.
- Event-driven canary testing of pull requests in a staging environment before production merge.
- Connecting the agent to GitHub, Azure DevOps, Dynatrace, Log Analytics, and Azure activity logs.
- Recipe-based agent configuration using markdown instructions, YAML skill/sub-agent specs, and seeded core memory.
- Multi-path transparent root cause analysis evaluating multiple hypotheses against telemetry.
- Automated, reversible mitigation (restarts, scale adjustments, rollbacks) with human-in-the-loop guardrails.
- Incident automation through ServiceNow, including diagnosis, GitHub issue creation, and autonomous remediation of a credential-desync database password rotation.
- Agent memory of past incidents to detect recurring patterns.
- Secret-less security architecture: isolated identity sidecar, per-run Micro VM sandboxes, OAuth connectors, and egress proxy with optional bring-your-own VNET.
- Monitoring via Session Insights, incident metrics dashboards, and agent consumption tracking in Azure AI units.

## Notable quotes
> "What happens when AI agents don't just observe incidents, but actually act on them?" — Vyom Nagrani

> "Think of it as an always on SRE teammate that learns how your environment works and acts according to how you want it to." — Vyom Nagrani

> "But if this is the only thing you use the agent for, you're probably missing 90% of the value that an agent can unlock beyond a Copilot." — Vyom Nagrani

## Products and tools mentioned
- Azure SRE Agent
- GitHub Copilot
- GitHub Copilot CLI
- GitHub / GitHub Actions
- Azure DevOps
- Azure Portal
- Azure Monitor
- Application Insights
- Dynatrace
- Datadog
- Log Analytics workspace
- ServiceNow
- PagerDuty
- Azure App Service
- PostgreSQL
- Azure Container Apps
- Model Context Protocol (MCP)
- KQL

## Speakers featured
- Vyom Nagrani — Product Manager, Azure SRE Agent team
- Deepthi Chelupati — Product Manager, Azure SRE Agent team

## Follow-up resources
- sre.azure.com — Azure SRE Agent portal, documentation, blog posts, walkthroughs, DIY labs, and feedback links.
