<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD819\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD819\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:17.4906804+00:00
-->
# Summary

## Overview
Microsoft Fabric Real-Time Intelligence (RTI) is presented as a unified, SaaS-based platform for building event-driven AI applications and autonomous agents that move from streaming signal to insight to action in seconds. Using a stadium game-day operations scenario, the session walks through ingestion and stream processing with Eventstream, time-series analytics with Eventhouse, and agentic action via MCP, Fabric Skills, and the Operations Agent. The recurring thesis is that timely, high-granularity real-time data is foundational to accurate, useful AI ("no AI without RTI").

## Key announcements
- **Custom Stream Connector (private preview)** [00:15:07] — Developers can build their own connector, upload the package, and have Fabric host it to bring custom sources into an Eventstream.
- **New and expanded Eventstream connectors** [00:14:11] — Includes a new MQTT version, an Oracle DB Change Data connector, HTTP/REST endpoint ingestion, and a MirrorDB Change Feed connector, with roughly 40 connectors total.
- **DeltaFlow (public preview)** [00:17:20] — Simplifies processing Debezium CDC events, adapting to source schema changes, and managing hundreds or thousands of source tables into Eventhouse.
- **Delta Change Feed connector (public preview)** [00:22:09] — Works with mirror databases and, soon, general lakehouse Delta Tables.
- **Eventhouse MCP and Fabric Skills** [00:30:36] — Every Eventhouse endpoint exposes a remote MCP URL so agents can query live data, define rules in natural language, and use reusable skills via tools like GitHub Copilot CLI and Claude Code.
- **Operations Agent (generally available)** [00:38:39] — An autonomous virtual team member that observes, analyzes, decides, and acts 24/7, publishing into Microsoft Teams with recommended actions and root-cause analysis.
- **Anomaly Detector (public preview)** [00:38:01] — Lets non-data-scientists select an out-of-box model fitted to their data's seasonality and emit anomaly events for the organization to subscribe to.

## Topics covered
- Streaming ingestion via managed connectors (MQTT, SQL CDC, HTTP, Oracle, MirrorDB) routed to Eventstream with Kafka and AMQP endpoints.
- In-motion stream processing using SQL operators or no-code drag-and-drop, with schema registry governance and interactive test/debug.
- Window aggregations (hopping windows) for fraud/duplicate-ticket detection and late/out-of-order event handling policies.
- Spark Structured Streaming and Fabric Notebooks for Python-based processing and AI function calls; publishing Fabric Business Events.
- Eventhouse as a petabyte-scale, schema-less, multimodal store using Medallion Architecture (bronze/silver/gold), update policies, and materialized views.
- KQL and SQL querying, inbuilt forecasting, anomaly detection, geospatial and vector similarity search; Copilot natural-language-to-KQL.
- Agent-first analytics: building an end-to-end flow (item creation, ingestion, analysis) via CLI using MCP and Fabric Skills.
- Ontology-driven Operations Agent playbooks, activator alerts, and Eventstream observability through workspace monitoring.

## Notable quotes
> "We've heard from multiple customers, there really is no AI without RTI." — Tessa Kloster

> "This table is holding close to 378 trillion records... approximately 13.5 to 14 billion new records are being added [per minute]." — Anshul Sharma

> "Instead of just querying data, your agents can now reason, act, detect all in real time." — Anshul Sharma

## Products and tools mentioned
- Microsoft Fabric
- Real-Time Intelligence (RTI)
- Fabric IQ / Ontology item
- OneLake
- Eventstream
- Eventhouse
- Activator
- Real-Time Hub
- DeltaFlow
- Power BI
- Copilot
- Operations Agent
- Anomaly Detector
- Fabric Data Agents
- Fabric Skills
- Eventhouse MCP
- Fabric Notebooks / Spark (Spark Structured Streaming)
- KQL / KQL Database
- Azure Event Hubs, Event Grid, Stream Analytics, Azure Data Explorer, Azure Maps
- Azure SQL / SQL CDC
- MQTT, AMQP, Kafka
- Oracle DB Change Data connector, MirrorDB / Delta Change Feed connector, HTTP connector
- Mirror databases, Delta Tables
- GitHub Copilot CLI
- Claude Code
- Microsoft Teams

## Speakers featured
- Tessa Kloster — Partner Director of Product Management for Real-Time Intelligence and IQ
- Arindam Chatterjee — Principal Product Manager, Fabric Real-Time Intelligence team
- Anshul Sharma — Principal Product Manager, Real-Time Intelligence team

## Follow-up resources
- Fabric IQ session (referenced as also being recorded)
- Fabric release planner and release notes
- Hands-on labs/workshops, forums, communities, documentation, and LinkedIn updates (sign-up via the links and QR codes shown on screen)
