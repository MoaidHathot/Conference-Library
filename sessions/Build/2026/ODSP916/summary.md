<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\ODSP916\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\ODSP916\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:51.9686100+00:00
-->
# Summary

## Overview
This session reframes accessibility in PDF documents as a systems-level engineering concern rather than a compliance afterthought. It argues that semantically tagged PDFs—carrying embedded structure and metadata—are dramatically faster, safer, and more accurate for LLM data extraction than OCR-based pixel processing, benefiting both human readers and machine consumers.

## Key announcements
This was a technical demonstration rather than a product launch; the central comparison presented was:
- **Embedded-text extraction outperforms OCR by roughly 200x** *(00:08:50)* — Extracting four pages with iText [inferred] leveraging embedded text took 0.075 seconds versus about 18 seconds for the Docling OCR pipeline *(00:07:41)*.
- **OCR extraction leaks unintended content** *(00:08:00)* — The OCR pipeline pulled a watermark into the Markdown output, which the author never intended to expose and which could be abused to jailbreak an LLM *(00:08:20)*.
- **OCR loses semantic structure** *(00:09:30)* — OCR failed to recognize sublists, while the embedded-metadata approach reconstructed them correctly, and such errors compound over time into wrong output.

## Topics covered
- The PDF drawing language and how rendering instructions place characters by pixel rather than conveying meaning.
- Why LLMs see only pixels and must spend tokens or rely on text extraction to recover document data.
- The four accessibility principles—perceivable, operable, understandable, robust—as shared needs of humans and LLMs.
- Tagged PDFs as a mechanism for adding semantic structure (headers, paragraphs, tables) analogous to HTML while preserving pixel-perfect rendering.
- A hands-on data pipeline comparing Docling OCR against embedded-text extraction, converting PDFs to information-dense Markdown for downstream LLM training.
- Security and reliability implications: watermark leakage, jailbreak risk, and compounding OCR errors.
- Practical guidance for producing accessible PDFs by enabling metadata embedding and verifying correct tags.

## Notable quotes
> "What we see is very easy for us because we are trained on it, but LLMs don't have this and so it's very hard for them to interpret the actual meaning behind those pixels." — Guust Ysebie

> "We need to design for understanding not just rendering, and that's especially the case in PDF documents." — Guust Ysebie

> "Accessibility isn't extra work. What you do now is only a few more minutes of work and that means that your AI infrastructure which you will build in the next following years will be so much better at processing all your documents." — Guust Ysebie

## Products and tools mentioned
- PDF (tagged PDF)
- iText [inferred]
- Docling
- Markdown
- HTML
- OCR
- Java

## Speakers featured
- Guust Ysebie — Software engineer working on PDF tooling and accessibility [inferred: at iText].
