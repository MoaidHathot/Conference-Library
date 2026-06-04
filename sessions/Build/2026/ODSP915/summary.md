<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP915\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP915\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:43.8613069+00:00
-->
# Summary

## Overview

This five-minute live demo from Red Hat shows a multi-agent system that diagnoses and resolves support cases across partner ecosystems, built on Azure and Red Hat OpenShift AI. The session walks through deploying an MCP server from a catalog and consuming it within an agentic application that handles routing, role-based access, and auditing.

## Key announcements

- **Deploying an Azure MCP server from the OpenShift AI MCP catalog [00:01:38]** — The catalog provides pre-built MCP servers that can be browsed, picked, and deployed to a cluster, handling the container image, configuration, and authentication via managed identity without custom glue code.
- **Multi-agent support resolution quickstart [00:00:24]** — An open-source multi-agentic system that diagnoses and resolves problems across partners in the same ecosystem, leveraging the Azure MCP server and Red Hat AI secure MCP catalog.
- **Role-based access enforcement with audit logging [00:04:38]** — A user without department membership (Josh) is denied access to all agents, with the denial recorded in the audit log and trail.

## Topics covered

- Layered architecture: user access layer, orchestration and security layer, routing agent, and support agents
- PatternFly web application providing the chat interface
- Routing agent intent detection and delegation to specific support agents
- A2A as the inter-agent communication layer and ADK for developing the agents
- Deploying MCP servers to an OpenShift cluster via operator
- Querying the Azure Well-Architected Framework for AKS and Azure web application best practices
- Authentication, authorization, and audit handling
- OpenTelemetry-based event storage and audit trail for security events
- Demonstrating access control by comparing an authorized user against an unauthorized user

## Notable quotes

> "We will just deploy from the catalog the MCP server, and we will consume that as a regular workload."

> "Josh doesn't belong to any department, so any of the agents will be able to answer his requests."

## Products and tools mentioned

- Azure MCP server
- Red Hat OpenShift AI (ARO)
- Red Hat AI secure MCP catalog
- OpenShift AI MCP catalog
- PatternFly
- A2A (Agent-to-Agent)
- ADK (Agent Development Kit) [inferred]
- Azure Kubernetes Service (AKS)
- Azure Well-Architected Framework
- OpenTelemetry
- Azure managed identity

## Speakers featured

- Carlos Camacho — Red Hat
- Sharon — Red Hat (named as co-presenter in the demo)
