<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\DEM365\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\DEM365\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:32:13.8191100+00:00
-->
# Summary

## Overview
A live, hardware-focused .NET demo arguing that apps gain a defensible advantage and a "magic" user experience when they interact with the physical world rather than stopping at REST APIs. The session centers on a custom test harness that lets coding agents develop and validate against real, physically connected hardware, then walks through three core connectivity protocols (BLE, NFC, USB) framed in familiar web-development terms.

## Key announcements
- **Custom hardware test harness for agentic workflows** *(~00:07:01)* — A scripted orchestration layer (not unit tests, mocking, or manual QA) that connects to real hardware, deploys apps, and prints line-by-line output so a coding agent can see what worked and what failed.
- **Live NFC test-harness demo against remote hardware** *(~00:09:28)* — Copilot ran an Android NFC test against two phones physically connected to a Mac mini in the speaker's basement, exercising reader/writer roles and packet comparison; the test returned false because the phones were intentionally mis-stacked.
- **Uno Platform agent-first studio release** *(~00:02:40)* — The speaker noted Uno's new studio is "agent first" with predefined skills and an MCP server for development that can build cross-platform apps from a design.

## Topics covered
- Using on-device hardware (accelerometers, geolocation, NFC, Bluetooth) to add physical-world context unavailable to web apps.
- Trust and identity scenarios: QR-code login backed by a Bluetooth co-location check, and Wi-Fi onboarding via NFC tap exchanging SSID and credentials.
- The cyclical movement of inference between cloud and edge, and the competitive "moat" of shipping physical hardware.
- Bluetooth Low Energy mapped to REST: services as API roots, characteristics as endpoints, UUIDs for spec compliance, read/write/notify as HTTP verbs, descriptors as headers; example using a humidity/temperature sensor with an LED.
- NFC fundamentals: tag types, reader/writer toggling, peer-to-peer large-data exchange, and regional payment tag-type differences (Japan vs. US).
- USB enumeration sequence (reset, descriptor, address assignment, config) and bulk transfer between devices.
- Platform differences: Android USB versus iOS requiring MFi certification.

## Notable quotes
> "It always feels like magic when your app actually interacts with the real world, when it will unlock a door, when it will interact with a machine."

> "It's really hard to copy your competitor's hardware quickly... than it is to point a copilot at your competitor['s] software and say, can you make that for me real quick?"

> "Android, in the case of USB, is not iOS. It is not equivalent to iOS... you need an MFi certification if you want to be able to connect USB devices compliant with iOS."

## Products and tools mentioned
- .NET
- .NET MAUI
- Uno Platform (Uno Studio)
- GitHub Copilot
- Model Context Protocol (MCP)
- Bluetooth Low Energy (BLE)
- NFC (Near Field Communication)
- RFID
- USB / ADB
- Raspberry Pi
- Mac mini
- Google Pixel [inferred]
- FPGA
- Apple MFi certification

## Speakers featured
- Jared Rhodes — presenter; Microsoft MVP [inferred from session tags]

## Follow-up resources
- The session's code repository ("refill" / "repo"), referenced as containing the test harness, deployment setup, and protocol demos, though no explicit URL was provided in the transcript.
