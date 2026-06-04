<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM368-R1\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM368-R1\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:27.8858763+00:00
-->
# Summary

## Overview
A foundational, demo-driven walkthrough of Microsoft Fabric's Data Science experience, showing an end-to-end traditional machine learning workflow from data ingestion through model deployment. The session argues that classical ML retains clear advantages over generative AI for many workloads, then demonstrates building, tracking, and operationalizing models in Fabric, closing with Fabric Data Agents for natural-language data querying.

## Key announcements
- **Traditional ML still has a defined role alongside generative AI [00:00:54]** — Lower latency, deterministic and consistent outputs, compute efficiency, and lower cost make classical models preferable for many use cases.
- **End-to-end data science inside Fabric [00:03:34]** — Bring data into a Lakehouse, prepare it with Data Wrangler, run experiments in Notebooks with MLflow, deploy the model, and consume results in Power BI or custom apps.
- **Diabetes-projection demo using a public Microsoft dataset [00:05:00]** — A healthcare scenario ingests data from Azure Blob storage, splits it 70/30 for training and validation, and compares a linear regression against a decision tree regressor, with the decision tree scoring better [00:12:10].
- **Saving an experiment run as a deployable ML model with an endpoint [00:13:00]** — A selected run is saved as a versioned model and exposed via an endpoint for consumption by other apps.
- **Fabric Data Agent for natural-language insights [00:14:49]** — Any user can point a generative-AI-backed agent at OneLake data, add custom instructions, and receive insights; it is currently read-only [00:15:20].
- **Data Agent consumable across Microsoft products [00:15:30]** — The same agent can be surfaced in Fabric, Microsoft Foundry, Copilot Studio, Microsoft 365 Copilot, and as an MCP server.

## Topics covered
- When to choose traditional ML over generative AI (latency, determinism, cost)
- Microsoft Fabric as a unified SaaS data and AI platform, and its role-based workloads
- The data science process: define problem, gather data, prepare, train, generate insights
- Loading public data into a DataFrame, converting Spark DataFrames to pandas for scikit-learn
- Training and comparing linear regression and decision tree regressor models
- Experiment tracking and run evaluation with MLflow (metrics, mean squared error, training scores)
- Saving runs as versioned models and exposing model endpoints
- Spark runtime options in Fabric notebooks (PySpark, Spark Scala, Spark SQL, SparkR)
- Copilot assistance and VS Code editing for Fabric notebooks
- Fabric Data Agent: connecting warehouse tables, natural-language-to-SQL, and instruction tuning
- Integrating agents via Copilot Studio child/external agents and Foundry knowledge/tools
- Contrast between Fabric (single SaaS surface) and Azure Machine Learning in Foundry (multiple services)

## Notable quotes
> "Even though generative AI is kind of highlighting all the limelight these days... there is still a lot of use cases where you would like to use traditional machine learning model rather than using generative AI."

> "One of the advantages of doing everything in Fabric is everything you are doing is in one location, everything is SaaS based. So you are not thinking about spinning up multiple services."

> "As long as your data is in OneLake, you can add it to your data agent, add your custom instructions, and then it can give you insights from that data."

## Products and tools mentioned
- Microsoft Fabric
- OneLake
- Lakehouse
- Data Wrangler
- Fabric Notebooks
- Apache Spark (PySpark, Spark Scala, Spark SQL, SparkR)
- MLflow
- scikit-learn
- pandas
- Power BI
- Azure Blob storage
- Fabric Data Agent
- Microsoft Foundry
- Azure Machine Learning
- Azure AI Search
- Copilot Studio
- Microsoft 365 Copilot
- Model Context Protocol (MCP) server
- Fabric IQ
- Copilot (notebook assistant)
- Visual Studio Code

## Speakers featured
- Prashant G Bhoyar — presenter (Community, MVP)

## Follow-up resources
- Presenter's LinkedIn profile, available via the QR code shown at the close of the session [00:23:31].
