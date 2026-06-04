<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD821\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD821\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:19.2102643+00:00
-->
# Summary

## Overview
This advanced session traces how Microsoft transformed Azure DocumentDB (formerly Azure Cosmos DB for MongoDB vCore) from a managed service into an open-source project and back again, building the managed offering atop the open-source, Postgres-backed DocumentDB engine. Product Manager Abinav Rameesh details the project-versus-product distinction, the rationale for open-sourcing under MIT and joining the Linux Foundation, and how the managed service competes on being cheaper, faster, and better—demonstrated through multicloud and hybrid-cloud replication.

## Key announcements
- **DocumentDB went open source under the MIT license (Jan 2025)** — After beginning the effort in January 2024, the team released the project to strong media coverage, GitHub stars, forks, and adoption [00:01:48–00:05:32].
- **Joining the Linux Foundation** — The team joined the foundation to give the developer community assurance that the project would persist independently of Microsoft and not have "the rug pulled from underneath them" [00:14:47–00:16:20].
- **32TB disks today with a roadmap to 64TB and 160TB** — Decoupling storage from compute lets large workloads run on far fewer compute nodes (e.g., ~13 instead of 100 for 200TB) [00:23:10–00:23:58].
- **12x performance boost via SSD v2 at no extra cost** — IOPS caps moved from 20,000 to 80,000, so a workload that once cost $4,500/month delivers the same performance at $280/month [00:30:57–00:32:25].
- **1 million sustained writes per second on a single node** — Achieved on a 32-core machine with a 2TB disk at 80,000 IOPS, reaching nearly 200,000 transactions per dollar [00:32:48–00:34:00].
- **Multicloud and hybrid-cloud replication demos** — Globally distributed setup across Azure, AWS, and GCP with managed failover and zero data loss, plus on-prem-to-Azure sync replication [00:35:22–00:41:25].

## Topics covered
- The distinction between an open-source project (user and contributor cohorts) and a revenue-driving managed product
- Licensing decisions and the choice of the three-paragraph MIT license for frictionless adoption
- Open-source health metrics: elephant factor, bus factor, and heartbeat factor
- Internal mentorship from Citus, Postgres contributors, TypeScript, and VS Code teams
- Why Postgres: extensibility, maturity, and extensions like Citus and pgVector for vector search/RAG
- Building a MongoDB-compatible query protocol on top of Postgres rather than reinventing indexing, query performance, and high availability
- TCO drivers: separating storage and compute cost, and eliminating charges for support, licensing, backups, networking egress, and observability
- Customer migrations from DB2 (262TB, ~$9M/year savings), HBase (bill cut more than half), and a 200TB competitor migration
- Global strong consistency with acknowledgment from primary plus at least one remote replica
- Hybrid-cloud resilience when the replication pipe breaks and resyncs

## Notable quotes
> "We started with a managed service, went back into building an opensource engine from the managed service, but then funneled all of our opensource learnings from the project back into the managed service." — Abinav Rameesh

> "We didn't want the community to feel that at any point we could pull the rug from underneath them."— Abinav Rameesh

> "You start at $280 a month, stay at $280 a month, and you get the same performance that you previously would have needed $4,500 for." — Abinav Rameesh

## Products and tools mentioned
- Azure DocumentDB (formerly Azure Cosmos DB for MongoDB vCore)
- DocumentDB (open-source engine)
- PostgreSQL
- Citus
- pgVector
- MongoDB (API compatibility)
- Azure Premium SSD v2 managed disks
- Kubernetes / DocumentDB Kubernetes operator
- VS Code DocumentDB extension
- Prometheus and Grafana
- AWS and GCP (Kubernetes clusters)
- Linux Foundation
- MIT License
- TypeScript

## Speakers featured
- Abinav Rameesh — Product Manager, Azure DocumentDB team

## Follow-up resources
- documentdb.io — open-source project, events, and updates (also hosts the community-driven samples gallery and skills.md)
- Link to the Azure managed service for feature, performance, and TCO updates (referenced at the end of the session)
