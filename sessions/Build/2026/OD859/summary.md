<!--
  Source:    P:\github\Conference-Library\sessions\Build\2026\OD859\transcript.md
  Metadata:  P:\github\Conference-Library\sessions\Build\2026\OD859\rich-manifest.json
  Model:     claude-opus-4.8
  Generator: Get-SessionSummary.cs (.NET 10 file-based program; GitHub.Copilot.SDK 0.3.0)
  Generated: 2026-06-04T12:44:21.3239362+00:00
-->
# Summary

## Overview
Windows platform security engineers outline how Windows is raising its baseline security across three dimensions: retiring legacy authentication, enforcing trusted code by default, and migrating cryptography to post-quantum standards. The session frames hardening as a shared responsibility between Microsoft and developers, who must shed legacy dependencies, sign all shipped code, and prepare applications for quantum-era cryptography.

## Key announcements
- **IAKerb and LocalKDC to replace NTLM in restricted scenarios (00:03:47)** — Kerberos extensions that enable authentication without line of sight to a domain controller and for local accounts, rolling out to client and server Windows Insider Program builds over the following weeks.
- **NTLM blocking policies (00:07:43)** — Administrative-template policies under Systems > NTLM that selectively block NTLM scenarios such as SSO and domain controller authentication, arriving over the following weeks.
- **Driver trust policy tightening (00:10:20)** — Cross-signed drivers are no longer trusted by default, with WHCP-certified drivers becoming the baseline, shipping to Windows 11 24H2 and newer in the May 2026 security update (Windows Server 2025 to follow).
- **Smart App Control reputation-based trust model (00:16:06)** — Default-enabled on tens of millions of Windows 11 consumer devices, trusting vetted Store content, WHCP drivers, and signed apps from trusted-root CAs while blocking unsigned code without reputation.
- **Microsoft artifact signing service (00:17:38)** — A fully managed code-signing service starting at $9.99/month basic tier, integrating with GitHub and Azure DevOps pipelines using digest signing so code never leaves the developer's system.
- **App control-aware applications via WLDP API (00:18:32)** — A new framework letting apps adjust security behavior based on policy state using an app control manifest, setting definitions, and the Windows Lockdown Policy API.
- **Post-quantum cryptography in SymCrypt and CNG (00:25:00)** — NIST-standardized ML-KEM and ML-DSA algorithms added, with Rust implementations and formal verification, plus IETF hybrid composite algorithms and TLS 1.3 hybrid key exchange via Schannel.

## Topics covered
- NTLM authentication weaknesses: lack of mutual verification, MD4-derived NT hashes and HMAC-MD5, and relay/pass-the-hash attacks
- Enhanced NTLM auditing (Server 2025, Client 24H2) and a remediation path: audit, fix unknown SPNs, register IPs, pilot IAKerb/LocalKDC, then block
- Deprecation of the cross-signing driver program and the two-phase audit-then-enforcement rollout informed by driver load diagnostic data
- WHCP certification workflow via the Hardware Dev Center, HLK testing, and distribution through Windows Update
- Application Control for Business and Smart App Control as kernel-integrated, agentless trust enforcement
- Quantum computing fundamentals, Shor's algorithm, and the harvest-now-decrypt-later threat to long-term sensitive data
- Crypto agility, hybrid composite algorithms (ML-KEM + ECDHE), and ML-DSA certificate/CMS support

## Notable quotes
> "We remove insecure patterns from the platform. You build on modern, supported foundations. That's how we reduce risk across the entire ecosystem." — Jeffrey Sutherland

> "The effort to inventory and update all asymmetric cryptography will arguably be the most complex multi-year transition we have ever undertaken." — Jason Fisher

> "Post-quantum cryptography is not just an upgrade. It is a fundamental shift to secure the next era of computing." — Jason Fisher

## Products and tools mentioned
- NTLM
- Kerberos
- IAKerb
- LocalKDC
- Windows Insider Program
- Windows Server 2025
- Windows 11 24H2 / 25H2
- Windows Client 24H2
- Wireshark
- Application Control for Business (App Control)
- Smart App Control
- Microsoft Defender
- Microsoft Store
- WHCP (Windows Hardware Compatibility Program)
- Hardware Dev Center
- HLK (Hardware Lab Kit)
- SignTool / SigCheck
- CI Tool
- Windows Lockdown Policy API (WLDP)
- GitHub
- Azure DevOps
- SymCrypt
- CNG (Cryptography Next Generation)
- BCrypt / NCrypt APIs
- ML-KEM, ML-DSA
- ECDHE / ECDH-P256
- RSA
- Schannel
- TLS 1.3
- Active Directory Certificate Services
- Crypt32
- Rust

## Speakers featured
- Jeffrey Sutherland — Windows security (host/presenter)
- Mariam Gewida — Windows security hardening team (NTLM elimination)
- Jordan Geurten — Technical Program Manager, Windows Platform Integrity team
- Jason Fisher — Group Engineering Manager, Cryptography and Integrity team, Windows

## Follow-up resources
- NTLM@microsoft.com — contact for reporting unique NTLM usage scenarios
