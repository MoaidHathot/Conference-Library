<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM368\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM368\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:19.5414626+00:00
-->
# Summary

## Overview
A foundational, demo-driven walkthrough of Microsoft Fabric's unified Data Science experience, framed around why traditional machine learning still matters alongside generative AI. Prashant G Bhoyar demonstrates an end-to-end workflow—ingesting public data, running and comparing models in Fabric notebooks with MLflow, deploying a model with a consumable endpoint, and building a natural-language Fabric Data Agent over warehouse data.

## Key announcements
This session is a demo and educational walkthrough rather than a product launch; it surfaces capabilities rather than new announcements.

- **Fabric Data Agent consumption surfaces** *(~00:14:25)*: Once published, a Fabric Data Agent is accessible as an MCP server endpoint and can be integrated with Microsoft 365 Copilot, Copilot Studio, and Microsoft Foundry.
- **Operational agent in preview** *(~00:15:15)*: An operational agent (distinct from the data agent) is available in preview to monitor real-time data and recommend business actions.

## Topics covered
- Why traditional ML remains relevant: consistent results, low latency, efficient compute, edge deployment, reproducibility, and feature attribution.
- Microsoft Fabric as a SaaS unified data platform spanning Data Factory, analytics, databases, real-time intelligence, and OneLake, with security and governance.
- Role separation between data engineers (building/securing data pipelines) and data scientists/ML engineers (applying statistics and ML).
- Common Fabric ML model types: classification, regression, clustering, and forecasting.
- The end-to-end data science process: define problem, get data into the Lakehouse, prepare data, run experiments, select best model, deploy, and generate insights (e.g., in Power BI).
- Demo use case: a healthcare analyst predicting a quantitative measure of diabetes progression, comparing linear regression against a decision tree regressor.
- Loading public Azure Blob storage data, converting a Spark DataFrame to a pandas DataFrame for scikit-learn, and a 70/30 train/test split.
- Experiment tracking with MLflow: naming experiments, listing runs, retrieving recent runs, and visualizing model comparison.
- Saving a run as a versioned model and exposing it via a deployment endpoint for consumption.
- Building a Fabric Data Agent: adding data sources, writing markdown agent instructions, testing natural-language queries, inspecting generated SQL, and publishing.

## Notable quotes
> "No matter where your data is, you can use that data for experimentation. I don't have to manually copy that data into the fabric."

> "The more descriptive or more detailed instructions you have, the better results you will get with your data agent."

> "The beauty of this is I can create my agent once and I can consume that across multiple different products or services."

## Products and tools mentioned
- Microsoft Fabric
- OneLake
- Lakehouse
- Fabric Notebooks
- Apache Spark (PySpark, Spark Scala, Spark SQL, Spark R)
- pandas
- scikit-learn
- MLflow
- Fabric Data Agent
- Power BI
- Azure Blob Storage
- Microsoft Foundry
- Foundry IQ / Azure AI Search
- Microsoft 365 Copilot
- Copilot Studio
- Data Factory
- Model Context Protocol (MCP)

## Speakers featured
- Prashant G Bhoyar — presenter, from Applied Information Sciences [inferred]; Community / MVP.

## Follow-up resources
- The presenter's LinkedIn profile, accessible via a QR code shown in the closing slide (URL not stated in the transcript).
