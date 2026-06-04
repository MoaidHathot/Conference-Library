**[00:00:00]** [ Music ]
**[00:00:07]** POORVI NARANG: Welcome to Build 2026.
**[00:00:09]** I'm Poorvi Narang, Senior Product Manager for Azure Linux.
**[00:00:13]** In this session, we'll take you through Azure Linux,
**[00:00:16]** Microsoft's purpose-built Linux distribution for Azure --
**[00:00:20]** what it is, where it runs, and what's new with Azure Linux 4.0.
**[00:00:25]** So here's what we'll cover.
**[00:00:27]** We'll start with Microsoft's Linux journey,
**[00:00:30]** then dive into what Azure Linux is and where it runs on:
**[00:00:34]** AKS, VMs, and containers.
**[00:00:37]** We'll walk you through Azure Linux 4.0;
**[00:00:39]** introduce Azure Container Linux; cover the key benefits
**[00:00:43]** around security, performance, and resiliency;
**[00:00:47]** and close with how to get started today.
**[00:00:50]** Microsoft's Linux story goes back further
**[00:00:52]** than most people realize.
**[00:00:54]** In 2009, we released 20,000 lines of code
**[00:00:58]** into the Linux kernel, and yes, the headline was "Pigs do fly."
**[00:01:03]** By 2011, Microsoft was one of the top five contributors
**[00:01:08]** to the Linux kernel, driven by our investment
**[00:01:11]** in Hyper-V and virtualization.
**[00:01:13]** In 2015, we released VS Code
**[00:01:16]** and co-founded the Node.js Foundation.
**[00:01:19]** By 2018, we'd acquired GitHub,
**[00:01:22]** VS Code was the number one developer tool,
**[00:01:25]** and Azure was trending towards 50% Linux workloads.
**[00:01:29]** Then in 2019, we shipped the Linux kernel for WSL,
**[00:01:34]** and we quietly released an internal project called
**[00:01:38]** CBL-Mariner on GitHub that would eventually become Azure Linux.
**[00:01:44]** In 2023, we made Azure Linux generally available
**[00:01:48]** as a container host on AKS and released.NET
**[00:01:52]** and Java container images built on it.
**[00:01:55]** And today at Build,
**[00:01:57]** we're announcing Azure Linux 4.0 preview for VMs and VMSS,
**[00:02:02]** plus Azure Container Linux as an immutable OS on AKS.
**[00:02:07]** This is our next chapter.
**[00:02:09]** So why build our own Linux distribution?
**[00:02:12]** Four reasons.
**[00:02:13]** First, security.
**[00:02:15]** We own the end-to-end supply chain.
**[00:02:18]** Every package that is built from source and signed by Microsoft.
**[00:02:23]** You don't have to wonder where your binaries came from.
**[00:02:26]** Second, performance.
**[00:02:28]** Azure Linux is a highly performant image,
**[00:02:31]** optimized specifically for Azure workloads
**[00:02:34]** across a variety of environments.
**[00:02:36]** Third, quality.
**[00:02:38]** We maintain a high-quality bar
**[00:02:40]** to minimize outages and disruptions.
**[00:02:43]** If tests fail, the release does not ship.
**[00:02:46]** And lastly, support and compliance.
**[00:02:49]** One vendor, one support channel,
**[00:02:51]** centralized support, and compliance.
**[00:02:54]** This is a distribution for Azure by Azure.
**[00:02:57]** And this isn't theoretical.
**[00:02:59]** Over 80% of Microsoft's Linux usage runs on Azure Linux today:
**[00:03:05]** Office, LinkedIn, Xbox, Defender, Cloud Shell, AKS,
**[00:03:10]** App Services, and core Azure infrastructure.
**[00:03:14]** Using Azure Linux allows these teams to spend less time
**[00:03:18]** on operational tasks like meeting compliance,
**[00:03:21]** managing OS upgrades, and scanning
**[00:03:23]** and patching critical security vulnerabilities.
**[00:03:27]** When you adopt Azure Linux, you're running the same OS
**[00:03:30]** that powers Microsoft's most critical infrastructure.
**[00:03:34]** We trust it, and so can you.
**[00:03:36]** Now, let me walk you through the architecture.
**[00:03:39]** Azure Linux is a three-layer stack.
**[00:03:42]** At the foundation is the Azure Linux Kernel,
**[00:03:45]** an upstream LTS Linux kernel optimized for Hyper-V
**[00:03:49]** across cloud and edge, with Azure-specific silicon drivers
**[00:03:54]** for better performance.
**[00:03:55]** It's hardened with secure defaults
**[00:03:57]** and supports multiple architectures
**[00:03:59]** like x86_64 and ARM64.
**[00:04:03]** On top of that is the Azure Linux Core RPM packages,
**[00:04:07]** but with a deliberately small default footprint.
**[00:04:11]** You get what you need, nothing that you don't.
**[00:04:14]** And wrapping everything is the around-the-clock protection
**[00:04:17]** from Microsoft.
**[00:04:19]** Every package is built from scratch
**[00:04:21]** to ensure supply chain security.
**[00:04:24]** Critical CVE patches are available quickly
**[00:04:26]** for commercially supported images.
**[00:04:29]** We do monthly servicing plus on-demand updates
**[00:04:32]** for critical issues.
**[00:04:34]** Azure Linux runs everywhere you need it.
**[00:04:37]** On AKS, it's been generally available since 2023,
**[00:04:41]** running millions of cores in mission-critical workloads
**[00:04:44]** across thousands of customers.
**[00:04:47]** And today, we're announcing Azure Container Linux,
**[00:04:50]** now generally available as an immutable OS for your AKS nodes.
**[00:04:55]** On virtual machines, Azure Linux is entering preview.
**[00:04:58]** It's the same distribution but more general purpose,
**[00:05:02]** supporting any VM or VMSS deployment.
**[00:05:05]** And Azure Linux container images is entering preview,
**[00:05:10]** pre-installed with all the tooling you need to work
**[00:05:13]** with Azure, ready to pull
**[00:05:14]** from the Microsoft Container Registry.
**[00:05:18]** Now let's talk VMs specifically.
**[00:05:20]** Azure Linux supports any Linux workload you want to run.
**[00:05:24]** It's a full general-purpose distribution.
**[00:05:27]** The packages are derived from Fedora and optimized for Azure.
**[00:05:32]** Each package undergoes rigorous performance
**[00:05:35]** and quality testing before release.
**[00:05:38]** On day one of general availability, you get support
**[00:05:41]** for Microsoft extensions and partner products,
**[00:05:44]** so your existing tooling works out of the box.
**[00:05:48]** For security and compliance, you get SLAs for high
**[00:05:51]** and critical CVEs, backed by thousands
**[00:05:54]** of security researchers and MSRC, plus FIPS validation,
**[00:05:59]** CIS Level 1 and Level 2 benchmarks will be available
**[00:06:03]** at GA, along with Secure Boot support.
**[00:06:06]** Now, let me introduce Azure Linux 4.0.
**[00:06:10]** It's built on a robust open-source foundation, Fedora,
**[00:06:14]** and enhanced with Azure-specific innovations
**[00:06:17]** to deliver a powerful, secure,
**[00:06:20]** and developer-friendly environment.
**[00:06:23]** Robust upstream support.
**[00:06:25]** We leverage Fedora's active community
**[00:06:27]** for rapid innovation and development.
**[00:06:30]** Declarative deviations.
**[00:06:33]** Any changes from upstream are clearly documented,
**[00:06:36]** making auditing and compliance straightforward.
**[00:06:39]** Simplified ISV experience.
**[00:06:42]** If your partners already support the RHEL ecosystem,
**[00:06:45]** Azure Linux will feel familiar and easy to adopt.
**[00:06:49]** Enhanced security.
**[00:06:51]** Azure CVE SLAs are inherited, and we're compliance-ready
**[00:06:55]** out of the box with FIPS/FedRAMP, CIS benchmarking,
**[00:07:00]** Secure Boot, and SELinux enforced by default.
**[00:07:04]** Operational excellence.
**[00:07:06]** A rolling release model,
**[00:07:07]** LTS plus hardware enablement kernels,
**[00:07:11]** and single-vendor support for streamlined management.
**[00:07:15]** Now, let me show you Azure Linux 4.0 in action.
**[00:07:19]** I've already SSH'd into an Azure Linux 4.0 VM running in Azure.
**[00:07:24]** First, let's confirm what we're running.
**[00:07:28]** This is Azure Linux 4.0,
**[00:07:29]** built on a Fedora foundation, optimized for Azure.
**[00:07:33]** We're running the 6.18 kernel, the latest upstream LTS kernel,
**[00:07:38]** hardened and tuned for Azure workloads.
**[00:07:41]** One of the things that makes Azure Linux 4.0 stand
**[00:07:44]** out is SELinux is enforcing by default.
**[00:07:48]** No extra configuration needed.
**[00:07:50]** You get mandatory access control out of the box.
**[00:07:54]** And look at how lean this image is: a small set of packages.
**[00:07:58]** A lightweight footprint means fewer packages to patch,
**[00:08:01]** fewer CVEs to deal with, and a smaller attack surface.
**[00:08:06]** For package management, Azure Linux 4.0 ships with DNF5.
**[00:08:10]** Fast, modern, and familiar
**[00:08:12]** if you've worked with Fedora or RHEL.
**[00:08:15]** Installing a package is exactly what you'd expect.
**[00:08:19]** Finally, the firewall.
**[00:08:21]** Firewalld is active and locked down by default.
**[00:08:24]** Only explicitly allowed services are open.
**[00:08:27]** If I want to open a custom port like 8080, I add it explicitly.
**[00:08:32]** Nothing is open unless you say so.
**[00:08:35]** That's the kind
**[00:08:36]** of secure-by-default posture we want for production workloads.
**[00:08:40]** So that's Azure Linux 4.0.
**[00:08:42]** Secure by default with SELinux and firewalld,
**[00:08:46]** lightweight with a minimal package set,
**[00:08:49]** and built on a modern kernel optimized for Azure.
**[00:08:53]** Azure Linux 4.0 ships with native support
**[00:08:56]** for Azure services, development tools,
**[00:08:58]** and security features your workloads already depend on.
**[00:09:02]** For security and observability, you get Defender for Cloud
**[00:09:06]** for robust security management, and Azure Monitor
**[00:09:09]** for comprehensive health and performance insights.
**[00:09:13]** For custom image management, Azure Image Builder
**[00:09:16]** and Image Customizer let you build, customize,
**[00:09:20]** and deploy your own Azure Linux images tailored to your needs.
**[00:09:24]** And for the developer ecosystem, there's full support
**[00:09:27]** for popular runtimes like.NET and OpenJDK,
**[00:09:31]** along with seamless control through Azure CLI.
**[00:09:34]** Since general availability in May 2023,
**[00:09:38]** thousands of customers have adopted Azure Linux
**[00:09:41]** across financial services, healthcare,
**[00:09:44]** video streaming, and data analytics.
**[00:09:47]** Customers running streaming services have reported strong
**[00:09:50]** reliability due to fewer interruptions on Azure Linux.
**[00:09:54]** Large retailers have chosen it
**[00:09:57]** for best-in-class performance on Azure.
**[00:10:00]** And customers in regulated industries like healthcare
**[00:10:03]** and finance who need strong security guarantees have adopted
**[00:10:07]** Azure Linux for its reduced attack surface.
**[00:10:11]** The consistent feedback: Azure Linux delivers on reliability,
**[00:10:15]** performance, and security.
**[00:10:18]** Now my colleague, Flora Taagen, also on the Azure Linux team,
**[00:10:23]** will walk you through how Azure Linux is used in AKS
**[00:10:27]** and why it matters for your Kubernetes workloads.
**[00:10:31]** FLORA TAAGEN: Thanks, Poorvi.
**[00:10:33]** On the left, you can see a typical AKS node running a
**[00:10:37]** purpose-built version of Azure Linux,
**[00:10:39]** including only the essential components needed
**[00:10:42]** to run Kubernetes workloads efficiently.
**[00:10:45]** Azure Linux for AKS is a lightweight operating system.
**[00:10:49]** Packages are deliberately selected and rigorously tested
**[00:10:53]** on AKS infrastructure, so you get a minimal footprint
**[00:10:57]** with high confidence in stability.
**[00:10:59]** Azure Linux on AKS is available wherever you need it,
**[00:11:03]** in the cloud with AKS or at the edge through AKS enabled
**[00:11:06]** by Azure Arc, giving you a consistent platform
**[00:11:09]** across environments.
**[00:11:11]** And finally, security is built
**[00:11:13]** into Azure Linux on AKS by design.
**[00:11:17]** Azure Linux provides strong compute-level isolation,
**[00:11:21]** and with options like an immutable host configuration,
**[00:11:25]** it helps reduce drift
**[00:11:26]** and minimize attack surface over time.
**[00:11:29]** Overall, Azure Linux with AKS gives you a minimal,
**[00:11:33]** well-tested, and secure foundation
**[00:11:36]** for running containerized workloads at scale.
**[00:11:39]** At Build, we're excited
**[00:11:41]** to announce the general availability
**[00:11:43]** of Azure Container Linux on AKS.
**[00:11:47]** Azure Container Linux, or ACL,
**[00:11:49]** brings together Flatcar's proven, vendor-neutral,
**[00:11:54]** and immutable design with the hardened security
**[00:11:57]** and trusted supply chain of Azure Linux.
**[00:12:01]** The result is a secure, scalable container host, purpose-built
**[00:12:05]** for running modern workloads in production.
**[00:12:08]** ACL is based on Flatcar's architecture
**[00:12:11]** and delivers a minimal,
**[00:12:13]** immutable operating system optimized for containers.
**[00:12:17]** While it isn't binary compatible with Flatcar, since it's built
**[00:12:21]** on Azure Linux rather than Gen2 sources,
**[00:12:25]** it provides the same core functionality
**[00:12:27]** and operational model that customers rely on today.
**[00:12:32]** Where ACL really stands out is in its built-in,
**[00:12:36]** out-of-the-box security guarantees.
**[00:12:39]** First, immutability is enforced at the kernel level.
**[00:12:43]** Critical system components like the usr directory are locked
**[00:12:46]** down to prevent drift and unauthorized changes.
**[00:12:50]** Second, ACL uses a minimal, purpose-built package set,
**[00:12:55]** reducing the overall attack surface
**[00:12:57]** and lowering exposure to CVEs.
**[00:12:59]** Third, it includes strong runtime protection
**[00:13:03]** through SELinux, enforcing strict least-privilege access
**[00:13:07]** controls across the system.
**[00:13:09]** On top of that, ACL supports Trusted Launch
**[00:13:12]** with a unified kernel image, ensuring the integrity
**[00:13:15]** of the system from the very first stage of boot.
**[00:13:19]** And finally, ACL benefits
**[00:13:21]** from the same secure end-to-end Microsoft supply chain
**[00:13:25]** as Azure Linux, using signed RPMs that you can trust.
**[00:13:30]** Together, this gives customers a modern, immutable,
**[00:13:34]** and security-first foundation
**[00:13:36]** for running container workloads on AKS at scale.
**[00:13:40]** This slide is here to help you differentiate
**[00:13:42]** between the two Azure Linux-based container host
**[00:13:45]** options on AKS.
**[00:13:48]** On the left is Azure Linux.
**[00:13:50]** This is the more general-purpose,
**[00:13:52]** familiar Linux node experience.
**[00:13:55]** It uses the standard Kubernetes host stack, and it's a great fit
**[00:13:59]** for customers doing lift-and-shift migrations
**[00:14:01]** or who want a flexible, familiar host environment while still
**[00:14:06]** benefiting from Microsoft's security posture
**[00:14:08]** for AKS workloads.
**[00:14:10]** On the right is Azure Container Linux.
**[00:14:13]** This is the more opinionated, container-optimized option.
**[00:14:17]** It builds on Azure Linux but adds stronger security
**[00:14:21]** and integrity guarantees by default.
**[00:14:23]** For example, a read-only usr backed by dm-verity,
**[00:14:27]** SELinux enabled, plus an A/B update agent
**[00:14:31]** and other hardening features.
**[00:14:33]** It's designed for cloud-native customers who want a minimal,
**[00:14:37]** immutable host model similar to what they may have seen
**[00:14:40]** with other container-optimized OSs in the ecosystem.
**[00:14:44]** Now the practical part.
**[00:14:46]** These options are not mutually exclusive.
**[00:14:49]** In AKS, you can run an Azure Linux node pool alongside an
**[00:14:53]** Azure Container Linux node pool in the same cluster
**[00:14:56]** and schedule workloads to the right host based on your needs.
**[00:15:00]** So the takeaway is, choose Azure Linux
**[00:15:03]** when you want the familiar, flexible host experience.
**[00:15:06]** Choose Azure Container Linux when you want the most hardened,
**[00:15:10]** minimal, immutable host by default.
**[00:15:12]** And if you have mixed requirements,
**[00:15:14]** you can use both side-by-side in one cluster
**[00:15:17]** by splitting workloads across node pools.
**[00:15:21]** Now let's demo Azure Container Linux in action.
**[00:15:24]** First thing we'll do is create an AKS cluster running Azure
**[00:15:28]** Container Linux.
**[00:15:30]** The only thing you need
**[00:15:31]** to specify is os-sku AzureContainerLinux
**[00:15:34]** in the az aks create command.
**[00:15:37]** It's really that simple to get started.
**[00:15:40]** Now, let me grab the credentials so that I can interact
**[00:15:43]** with the cluster, and let's take a look at our nodes.
**[00:15:47]** You can see the node is running Azure Container Linux,
**[00:15:50]** and the OS image column confirms it.
**[00:15:53]** Let's now take a look at what's running on this node.
**[00:15:56]** First, the OS identity.
**[00:15:58]** You can see this is Azure Container Linux,
**[00:16:01]** built on the Azure Linux package pipeline
**[00:16:04]** with the same immutable OS architecture
**[00:16:07]** as Flatcar Container Linux.
**[00:16:09]** Here's the kernel.
**[00:16:10]** Azure Container Linux runs the Azure Linux Kernel.
**[00:16:14]** And bootctl shows us the secure boot chain.
**[00:16:18]** You can see Secure Boot is enabled with vTPM attestation,
**[00:16:23]** and the OS uses a unified kernel image, meaning the kernel,
**[00:16:27]** ramfs, and the command line are all signed as a single bundle.
**[00:16:32]** Now, let's look at how ACL protects the system partition.
**[00:16:37]** Dm-verity is active on usr.
**[00:16:40]** This cryptographically verifies every block read from disk.
**[00:16:44]** And if we try to write to usr directly,
**[00:16:47]** even as root, it's denied.
**[00:16:50]** The file system is read-only enforced at the block layer.
**[00:16:54]** ACL also ships with SELinux in enforcing mode.
**[00:16:58]** So in summary, ACL gives you defense-in-depth
**[00:17:01]** at the node level.
**[00:17:03]** An immutable OS image verified by dm-verity
**[00:17:07]** and mandatory access controls with SELinux.
**[00:17:10]** Even if an attacker gets root access inside a container,
**[00:17:14]** the host stays protected.
**[00:17:16]** When it comes to Azure, customers depend
**[00:17:18]** on a diverse ecosystem of Azure-native, third-party,
**[00:17:22]** and open-source tooling across DevOps, observability,
**[00:17:26]** networking, and security.
**[00:17:29]** On AKS, Azure Linux enables seamless integration
**[00:17:32]** with the broader ecosystem,
**[00:17:34]** supporting leading partner solutions called
**[00:17:37]** out on this slide, with full compatibility
**[00:17:39]** with Azure extensions.
**[00:17:41]** Azure Linux 4.0 for VMs
**[00:17:44]** and Azure Container Linux deliver strong day-one partner
**[00:17:48]** support by supporting the following subset of partners,
**[00:17:51]** accelerating readiness for your production workloads
**[00:17:54]** from the get-go.
**[00:17:56]** Azure Linux is deeply integrated with the open-source ecosystem,
**[00:18:00]** building on and contributing to the upstream kernel and Fedora,
**[00:18:05]** as well as key community projects
**[00:18:07]** such as Kata Containers, containerd, and systemd.
**[00:18:11]** So why choose Azure Linux as your OS?
**[00:18:14]** Let's explore three core benefits: resiliency,
**[00:18:18]** security, and performance.
**[00:18:20]** Many customers managing large-scale Azure workloads are
**[00:18:25]** concerned about outages during OS or application upgrades.
**[00:18:29]** In traditional distributions,
**[00:18:31]** upgrades can introduce frequent reboots, downtime,
**[00:18:36]** or regressions that disrupt services.
**[00:18:39]** Azure Linux mitigates this risk
**[00:18:41]** through rigorous end-to-end validation
**[00:18:44]** across Azure scenarios prior to release.
**[00:18:48]** Any failure blocks the release,
**[00:18:50]** helping prevent customer-impacting issues
**[00:18:53]** in production environments.
**[00:18:55]** Core components such as the kernel
**[00:18:57]** and critical system packages are maintained on stable,
**[00:19:01]** long-term support versions with security patches backported.
**[00:19:06]** Changes are introduced in a controlled manner
**[00:19:09]** at release boundaries, avoiding disruptive mid-cycle updates.
**[00:19:14]** Performance issues can impact line-of-business apps,
**[00:19:18]** and customers often blame the OS for regressions.
**[00:19:22]** Azure Linux solves this with a lightweight image optimized
**[00:19:26]** for Azure, resulting in faster pod
**[00:19:29]** and node startup times on AKS.
**[00:19:32]** For example, MediaKind reported faster node setup times,
**[00:19:36]** and PlayFab saw quicker scaling
**[00:19:39]** to handle player influx on Azure Linux.
**[00:19:43]** We regularly run performance tests alongside quality checks.
**[00:19:48]** If regressions appear, we block the Azure Linux release.
**[00:19:52]** Data for cluster create and cluster upgrade operations show
**[00:19:56]** that Azure Linux is consistently on par
**[00:19:59]** or faster than other distros.
**[00:20:02]** Security challenges include CVE overload
**[00:20:06]** and supply chain threats.
**[00:20:07]** Azure Linux addresses this
**[00:20:09]** by reducing the overall attack surface.
**[00:20:12]** Because we ship fewer packages,
**[00:20:15]** there are simply fewer CVEs to begin with.
**[00:20:18]** On top of that, we enforce strict remediation SLAs,
**[00:20:23]** with critical CVEs addressed within five days.
**[00:20:27]** At the kernel level, all modules are signed
**[00:20:30]** with Microsoft's trusted key, which ensures
**[00:20:33]** that only authorized code can run in kernel space.
**[00:20:37]** And from a supply chain perspective, everything is built
**[00:20:41]** from source on Microsoft-managed infrastructure,
**[00:20:44]** giving you full control and transparency.
**[00:20:48]** Azure Linux also enables strong out-of-the-box compliance
**[00:20:52]** with FIPS images, CIS benchmark alignment,
**[00:20:56]** and Secure Boot support included at no additional cost.
**[00:21:01]** And here's the part I'm most excited about:
**[00:21:03]** how you can get involved and started on Azure Linux today.
**[00:21:07]** Everything is open source.
**[00:21:09]** Our GitHub is where you can file issues and submit PRs.
**[00:21:14]** We actively review community contributions,
**[00:21:17]** and we want more of them.
**[00:21:19]** You can get started with our enterprise offerings
**[00:21:21]** by following the links
**[00:21:22]** to our documentation included on this slide.
**[00:21:25]** And we run a bimonthly community call.
**[00:21:28]** In this forum, we share roadmap updates, demo new features,
**[00:21:32]** and take feedback live.
**[00:21:34]** This is a community effort,
**[00:21:36]** and your feedback directly shapes what we build.
**[00:21:39]** So that's Azure Linux end-to-end, modern, secure,
**[00:21:43]** and purpose-built for Azure.
**[00:21:45]** From Azure Linux 4.0 to Azure Container Linux,
**[00:21:49]** we're bringing a unified foundation
**[00:21:51]** across VMs, AKS, and containers.
**[00:21:55]** We're excited about where this is going,
**[00:21:57]** and we'd love your thoughts.
**[00:21:59]** Questions, feedback, please reach out.
**[00:22:02]** We look forward to hearing from you.
**[00:22:04]** Thanks for joining us today.
**[00:22:06]** [ Music ]
