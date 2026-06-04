<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD812\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD812\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:42:47.3846040+00:00
-->
# Summary

## Overview
Fabric IQ is presented as a semantic foundation that unifies data, business meaning, and action on top of Microsoft Fabric, enabling developers to build AI-powered data apps and agents grounded in governed enterprise context. The session walks through Fabric's three layers—OneLake (unified data), real-time intelligence (reasoning over streaming/event data), and Fabric IQ ontologies (the "virtual brain" of the business)—using a stadium operations scenario, and extends to physical AI through an NVIDIA partnership.

## Key announcements
- **Graph analytics in Fabric IQ is generally available** (~00:29:50): Native graph capabilities built on OneLake data and the ontology, with a visual no-code GQL query builder for multi-hop relationship and causal analysis without additional ETL.
- **Operations Agent generally available in Fabric IQ** (~00:39:56): An agent that monitors anomaly events, Eventhouse data, and the ontology in real time, then recommends and takes governed actions, operating within a team channel.
- **Business events in the real-time hub** (~00:17:28): Ability to publish curated business events from notebooks for anyone in Fabric to subscribe to for analytics or action.
- **Geospatial map visualization generally available in Fabric** (~00:18:07): Map item for real-time and analytical geospatial needs.
- **Real-time intelligence updates leading into Build** (~00:16:43): GA of the SQL operator in Eventstream, Spark Structured Streaming support with Eventstream, DeltaFlow for event-driven apps, Copilot in real-time intelligence, and MCP plus skills.
- **Anomaly detector in public preview** (~00:44:23): Recommends the best model to detect anomalies on streaming Eventhouse data and emits anomaly events automatically.
- **Physical AI preview with NVIDIA** (~00:46:30): Real-time dashboards using OpenUSD scenes integrated with NVIDIA Omniverse libraries for bidirectional 3D operational visualization.
- **Planning in Fabric IQ** (~00:32:10): Announced at FABCON; enables what-if scenarios over trusted data for business and finance teams.

## Topics covered
- The Microsoft IQ layer: Work IQ, Foundry IQ, and Fabric IQ as distinct enterprise intelligence components.
- OneLake unification via physical copy or virtual shortcuts, open Delta Parquet format, and unified governance/security across 170+ connectors.
- Reuse of existing Power BI semantic models (20M+ models, 35M+ monthly users) as a foundation for ontologies.
- Building ontologies with Copilot and no-code tools: entities, properties, data bindings, relationships, rules, and actions.
- Real-time intelligence architecture, scale, and a public benchmark versus Confluent and Snowflake.
- Grounding agents (no-code to pro-code) via ontology, MCP, APIs/SDKs, Foundry, and Copilot Studio.
- Physical AI for airport operations combining Fabric, Fabric IQ, and NVIDIA Omniverse.

## Notable quotes
> "I want to be the chief information officer and now the chief integration officer." — Yitzhak Kesselman, paraphrasing customer CIOs

> "There really is no AI without RTI... any AI solution, especially an agentic solution, needs the highest volume granularity data it can get." — Tessa Kloster

> "Our data scientists now have time to really go for patterns that are telling us what is actually wrong with the system." — Dr. Werner Zirkel, Siemens Healthineers

## Products and tools mentioned
- Microsoft Fabric
- Fabric IQ
- OneLake
- Real-Time Intelligence
- Eventhouse / Eventstream
- Real-time hub
- Activator
- Power BI semantic models
- Copilot
- Operations Agent
- Data Agent
- Anomaly detector
- Graph analytics (GQL)
- Microsoft Foundry / Foundry IQ
- Work IQ
- Copilot Studio
- MCP (Model Context Protocol)
- Delta Parquet
- Spark Structured Streaming
- DeltaFlow
- Azure Event Grid, Event Hubs, Azure Data Explorer
- NVIDIA Omniverse
- OpenUSD
- Vanderlande OpenAir Platform

## Speakers featured
- Yitzhak Kesselman — Microsoft, Fabric data and IQ leadership (presenter)
- Tessa Kloster — Microsoft, real-time intelligence and Fabric IQ demos
- Dr. Werner Zirkel — Siemens Healthineers, data analysis and cloud solutions for customer services

## Follow-up resources
- Recommended Build sessions: Amir Netz on the unified Fabric overview, and Tessa Kloster's deep dive on real-time intelligence.
- Referenced in-session (via QR codes): real-time-in-a-day workshop, ontology playground, hands-on documentation and skills, and a featured partners link for onboarding.
