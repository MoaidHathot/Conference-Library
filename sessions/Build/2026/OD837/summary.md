<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD837\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD837\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:43:46.2439066+00:00
-->
# Summary

## Overview
A builder-focused walkthrough of how Microsoft's Adaptive Cloud technologies bring AI out of the datacenter and into the physical world. Using a small tabletop agentic robot as a worked example, the session demonstrates how Azure Local on small form factor hardware, Foundry Local on Linux, and Azure IoT Operations combine to run language and vision models locally with low, predictable latency.

## Key announcements
- **Azure Local capabilities for small form factor devices (public preview)** — Cloud-based provisioning and management functions previously limited to large Azure Local servers are now available in preview for compact industrial hardware (00:13:06).
- **Foundry Local as a Linux container image, enabled by Azure Arc (preview)** — Foundry Local, originally on Windows and Android, is newly packaged as a container that runs on Linux and exposes an OpenAI-compatible REST API for local inferencing (00:08:55, 00:14:48).
- **Cloud provisioning without local peripherals** — Using an ownership voucher in the Azure portal, a device can have its software stack (e.g., Azure Linux) installed straight from the cloud with no keyboard or monitor attached (00:13:31).

## Topics covered
- The opportunity gap for "physical AI" in inspection, maintenance, construction, logistics, warehousing, and retail/food-prep work that conventional robotics has not addressed.
- The distinction between conventional robotics (controlled, repetitive tasks) and an agentic approach that tolerates messy, natural-language input and changing environments.
- Hardware setup: an industrial computer co-located with the robot, connected over USB to an RGB camera, an omnidirectional microphone, and a six-degrees-of-freedom robot arm with gripper.
- The runtime pipeline: speech-to-text, a continuous vision/object-detection pipeline returning coordinates and rotation, and a local small language model performing reasoning and tool calling.
- The four tool calls exposed to the model: Pick, Place, Pick-and-Place, and Stop.
- GPU acceleration handled automatically by Foundry Local, lining up driver, device plug-in, and user-mode libraries.
- Azure IoT Operations for telemetry, data transformation, and routing robot coordinate data to Microsoft Fabric for analysis (e.g., detecting out-of-reach requests).

## Notable quotes
> "This robot I'm about to show you, it's not going to take anyone's job, but it does serve to sort of show the potential of combining AI, especially language models, with physical systems." — Cosmos Darwin

> "Because it's an agentic robot, [it] is able to reason about what it heard and figure out what I meant anyway, even though the interaction was kind of messy." — Cosmos Darwin

> "From that point on, there are no calls to the cloud at all. It's just running inside of that Foundry Local container for you." — Cosmos Darwin

## Products and tools mentioned
- Azure Local
- Foundry Local
- Azure Arc
- Azure IoT Operations
- Azure Linux
- Azure portal / Azure Resource Manager
- Microsoft Entra ID
- Microsoft Fabric
- Lenovo ThinkEdge SE100
- NVIDIA RTX 2000 GPU
- NVIDIA Nemotron Speech (speech-to-text)
- Qwen3 1.7B [inferred] (small language model)
- K3s (single-node Kubernetes)
- Python
- MQTT broker; OPC UA, HTTP, ONVIF connectors

## Speakers featured
- Cosmos Darwin — Product Manager, Microsoft Azure team
- Roycey Cheeran (listed speaker; does not appear in the transcript)
