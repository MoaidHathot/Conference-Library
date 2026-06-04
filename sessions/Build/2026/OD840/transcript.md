**[00:00:01]** JEREMIAH FOLLIS: Hi, I'm Jeremiah Follis,
**[00:00:03]** a PMM on Microsoft Security for AI team.
**[00:00:06]** And, today, we're talking about how
**[00:00:07]** to make any agent enterprise ready using Agent 365 SDK.
**[00:00:14]** And I'm joined here by Sunil Garg,
**[00:00:16]** and he's been leading the Agent 365 SDK work.
**[00:00:22]** And so, yeah, thanks for being here, Sunil.
**[00:00:25]** SUNIL GARG: Yeah, thank you, Jeremiah.
**[00:00:26]** Nice to be here.
**[00:00:27]** Hi, everyone, I am Sunil Garg.
**[00:00:29]** I am a Product Manager on the Agent 365 team.
**[00:00:33]** I run the Agent 365 SDK and CLI.
**[00:00:36]** And I also am a deployed PM in our ecosystem
**[00:00:40]** for driving partner adoption.
**[00:00:42]** So I get to spend a lot of time with developers, and I'm happy
**[00:00:45]** to talk about all of that today with all of you.
**[00:00:47]** Nice to be here.
**[00:00:49]** JEREMIAH FOLLIS: Yeah, so this session is really
**[00:00:51]** to help developers or security leaders understand the
**[00:00:54]** importance of observability, governance, and security
**[00:00:58]** for agents, and what Agent 365 SDK does and what you get
**[00:01:03]** out of integrating with it.
**[00:01:05]** So, yeah, let's go ahead and dig in.
**[00:01:07]** Sunil, developers everywhere are building agents
**[00:01:10]** to drive real business and technology transformation,
**[00:01:13]** but security and risk concerns can stall adoption fast.
**[00:01:17]** From where you sit, what should developers focus on to clear
**[00:01:21]** that hurdle, and what's keeping the enterprise customers
**[00:01:25]** up at night?
**[00:01:26]** SUNIL GARG: And that's a great question.
**[00:01:27]** And, honestly, it's the one I get more
**[00:01:30]** than any other right now.
**[00:01:32]** So here is what I would say to my developer audience.
**[00:01:35]** The excitement around agents is completely justified.
**[00:01:39]** Eight-two percent of leaders are planning to deploy agents
**[00:01:43]** in the next 12 to 18 months just to keep
**[00:01:46]** up with the workforce demand.
**[00:01:48]** But that same momentum is what's creating the anxiety
**[00:01:52]** on the other side of the table.
**[00:01:55]** When I talk to CISOs and CIOs,
**[00:01:57]** four things consistently come up.
**[00:02:00]** First, agent sprawl and resource access.
**[00:02:04]** Every team is spinning up agents and each one needs identity,
**[00:02:08]** permissions, and access to data and tools.
**[00:02:12]** The most important shift in your mental model
**[00:02:15]** as a developer is this, an agent is not an app,
**[00:02:20]** it's an actor with its own brain.
**[00:02:24]** Give it a scoped identity, least privilege access,
**[00:02:28]** and an audit trail from day one.
**[00:02:31]** If you bolt on governance later, you have already lost it.
**[00:02:36]** Second, data oversharing.
**[00:02:39]** Eighty percent of leaders tell us their top concern is
**[00:02:43]** sensitive data leaking through AI.
**[00:02:47]** This usually isn't a model problem,
**[00:02:50]** it's a grounding problem.
**[00:02:52]** The agent has access to, say, a SharePoint site, a CRM,
**[00:02:57]** an email thread that the user technically can reach,
**[00:03:01]** but probably shouldn't be surfacing in this context.
**[00:03:05]** Developers need to design agents with data boundaries in mind,
**[00:03:10]** agents respecting sensitivity labels, honoring the permissions
**[00:03:14]** of the user invoking the agent,
**[00:03:17]** and never let the agent become a shortcut around controls
**[00:03:21]** that already exist in the enterprise.
**[00:03:25]** Third, the new threat surface.
**[00:03:29]** Eighty-eight percent of organizations are worried
**[00:03:32]** about indirect prompt injections, and they should be.
**[00:03:37]** The moment your agent reads an email, parses a document,
**[00:03:41]** or browses a web page, untrusted content enters its
**[00:03:45]** reasoning loop.
**[00:03:47]** As developers, our job is to build the right hooks
**[00:03:51]** and guardrails into our agents
**[00:03:53]** so enterprise security teams can detect and respond
**[00:03:57]** to these attempted threats.
**[00:04:00]** That's where tools like Defender plug in.
**[00:04:03]** Assume your agent will be manipulated and designed
**[00:04:07]** for graceful failure when it is.
**[00:04:10]** And, fourth, regulatory uncertainty.
**[00:04:13]** More than half of the leaders I talk
**[00:04:16]** to admit don't fully understand how AI will be regulated,
**[00:04:22]** the EU sector specific rules in finance
**[00:04:25]** and healthcare evolving guidance in the U.S. My advice,
**[00:04:30]** don't wait for the rules to settle,
**[00:04:33]** build observability and traceability now.
**[00:04:37]** If you can answer what did this agent do on whose behalf
**[00:04:43]** with what data and why, you are ready
**[00:04:46]** for whatever framework lands.
**[00:04:49]** So what's keeping enterprise customers up at night?
**[00:04:52]** Well, it's not one of these.
**[00:04:54]** It's the compounding risk.
**[00:04:56]** An agent with too much access, reasoning over untrusted data,
**[00:05:02]** making decisions no one can audit
**[00:05:04]** in a regulatory environment that's still being written,
**[00:05:09]** that is the risk.
**[00:05:10]** The good news is every one of these problems has an answer.
**[00:05:15]** And most of those answers are things developers control,
**[00:05:19]** which is exactly what I would love to dig into today.
**[00:05:23]** Look, the developers who win here aren't the ones shipping
**[00:05:28]** the flashiest agents, they are the ones building agents
**[00:05:32]** that CISOs will actually approve.
**[00:05:35]** JEREMIAH FOLLIS: Wow.
**[00:05:36]** So that agent as an actor framing is a big mindset shift.
**[00:05:40]** Walk us through it.
**[00:05:42]** When an enterprise is bringing an agent
**[00:05:44]** into their organization,
**[00:05:45]** what are the questions that they're asking?
**[00:05:48]** SUNIL GARG: Yeah, let me build on that agent
**[00:05:51]** as an actor idea because it's the frame shift
**[00:05:54]** that unlocks everything else.
**[00:05:56]** So we need to stop thinking about agents
**[00:05:59]** as features inside an application, and start thinking
**[00:06:03]** of them as members of the workforce.
**[00:06:06]** When a new employee joins your company,
**[00:06:09]** an entire machinery kicks in.
**[00:06:11]** IT provisions a managed identity, their access is scoped
**[00:06:14]** to their role, their manager sets expectations,
**[00:06:18]** and everything they do is auditable.
**[00:06:20]** Nobody calls that bureaucratic overhead.
**[00:06:23]** That's just how organizations operate at scale.
**[00:06:27]** Agents need the same treatment.
**[00:06:30]** And the questions enterprise customers ask maps almost
**[00:06:34]** one-on-one to these questions they would ask
**[00:06:36]** about any new hire.
**[00:06:38]** Can IT discover and manage them?
**[00:06:41]** Today, mostly no.
**[00:06:44]** Register your agents with an identity from day one because,
**[00:06:47]** if IT can't see it, IT can't protect it.
**[00:06:52]** Second, who are they sharing sensitive information with?
**[00:06:56]** Think about flows of data, not just permissions
**[00:06:59]** on individual actions.
**[00:07:01]** An agent can have two perfectly reasonable permissions
**[00:07:05]** on their own, read from a CRM, send an email,
**[00:07:09]** and the combination still creates an exfiltration path
**[00:07:13]** designed with the full flow in mind,
**[00:07:15]** not just the individual action.
**[00:07:18]** Are they behaving properly?
**[00:07:20]** Build in the telemetry, behavioral signals,
**[00:07:23]** and hooks that let enterprise security teams monitor
**[00:07:27]** and course correct.
**[00:07:29]** You can't fix what you can't see.
**[00:07:33]** Are they well governed and audited?
**[00:07:35]** Every action needs to be attributable,
**[00:07:38]** which agent on whose behalf with what data to what outcome.
**[00:07:45]** So my guidance for developers,
**[00:07:48]** the bar for an enterprise-ready agent isn't whether it works,
**[00:07:53]** it's whether it could pass an onboarding review
**[00:07:56]** at a Fortune 500.
**[00:07:58]** Identity, behavior, data handling, auditability,
**[00:08:02]** build to that bar and you are not just building agents people
**[00:08:07]** will use, you are building agents enterprise will trust.
**[00:08:12]** And trust is what takes a demo to production.
**[00:08:18]** JEREMIAH FOLLIS: So that bar, I mean,
**[00:08:20]** passing a Fortune 500 onboarding review is high.
**[00:08:24]** And, honestly, for a developer just trying to ship an agent,
**[00:08:29]** all of this can feel overwhelming.
**[00:08:31]** What's your guidance of how does Microsoft help developers clear
**[00:08:35]** that bar without rebuilding the security stack themselves?
**[00:08:39]** SUNIL GARG: Yes, you are spot on, Jeremiah.
**[00:08:42]** It has been a big pain point for developers
**[00:08:45]** to build enterprise-ready agents because they may need
**[00:08:49]** to use a variety of open-source and development tools.
**[00:08:53]** Sometimes they need to justify, identify,
**[00:08:56]** and patch these controls themselves,
**[00:08:58]** let alone figuring it out how customers will eventually use
**[00:09:02]** and benefit from these bespoke implementations.
**[00:09:06]** So the bottom line is that it's challenging
**[00:09:09]** to maintain various controls from different vendors
**[00:09:13]** and make them all enterprise proofed.
**[00:09:15]** At Microsoft, we really want to help solve this challenge
**[00:09:19]** for developers to enable security
**[00:09:21]** and governance controls easily in the agents they build,
**[00:09:26]** no matter where they build it, how they build it,
**[00:09:29]** and where they run it.
**[00:09:31]** That's where Agent 365 comes in.
**[00:09:33]** Agent 365 is the control plane for agents,
**[00:09:37]** built so enterprise customers can observe, govern,
**[00:09:41]** and secure every agent in their environment.
**[00:09:45]** We made Agent 365 generally available on May 1st along
**[00:09:49]** with the SDK, and the SDK is what makes everything real
**[00:09:54]** for developers.
**[00:09:55]** So, for the rest of the session, I will focus exactly on that,
**[00:10:01]** how you as a developer can use the SDK
**[00:10:04]** to make your agent fully observable, manageable,
**[00:10:08]** and governable by Agent 365.
**[00:10:13]** JEREMIAH FOLLIS: So building on that,
**[00:10:14]** Agent 365 also gives developers a clear path
**[00:10:19]** to make sure the agents they build are manageable inside it.
**[00:10:24]** Sunil, when a maker or a developer is working
**[00:10:29]** in Agent Builder, Copilot Studio, or Foundry,
**[00:10:33]** what do they need to do
**[00:10:34]** to get Agent 365 controls on their agent?
**[00:10:37]** SUNIL GARG: Well, to be quite honest, nothing extra.
**[00:10:39]** Agent 365 is natively integrated
**[00:10:42]** out of the box with these platforms.
**[00:10:45]** It doesn't matter if you are no-code, low-code or pro-code,
**[00:10:50]** when makers and developers build on Microsoft AI platforms,
**[00:10:54]** the agent shows up in Agent 365 automatically.
**[00:10:57]** Identity, observability, governance,
**[00:10:59]** and security are all wired in.
**[00:11:02]** JEREMIAH FOLLIS: So, yeah, I mean, that's a clean story
**[00:11:04]** for the Microsoft side.
**[00:11:05]** Would like you to flip it on me, though.
**[00:11:07]** Say I'm a developer building on a different platform entirely,
**[00:11:11]** how does Agent 365 reach my agent in that case?
**[00:11:15]** SUNIL GARG: Yep, that's a good question.
**[00:11:17]** So Agent 365 already connects directly
**[00:11:20]** to leading third-party platforms like Vertex AI
**[00:11:23]** and AWS Bedrock, with more on the way.
**[00:11:28]** Agents built on these platforms can be registered
**[00:11:30]** in Agent 365 registry through connected platform integration.
**[00:11:34]** And, remember, registration is the first step
**[00:11:37]** to solving agent sprawl.
**[00:11:39]** So, once your agent is in the Agent 365 registry,
**[00:11:42]** customer admins can discover it.
**[00:11:44]** JEREMIAH FOLLIS: And what
**[00:11:45]** about developers building their own agents
**[00:11:47]** with an SDK or framework?
**[00:11:49]** OpenAI's SDK, LangChain, Claude, custom code.
**[00:11:54]** What if developers' other capabilities --
**[00:11:57]** what about them rather than just registration?
**[00:12:00]** That's a huge group and they need the same things,
**[00:12:03]** observability, governance, security.
**[00:12:06]** SUNIL GARG: Yeah, absolutely correct.
**[00:12:08]** So that's exactly where Agent 365 SDK comes in.
**[00:12:13]** This will be a long answer, but let's quickly talk through this.
**[00:12:17]** So the first thing I would say is Agent 365 SDK is not all
**[00:12:21]** or nothing.
**[00:12:23]** Whether you are building with OpenAI's SDK, LangChain, Claude,
**[00:12:27]** LlamaIndex, the Microsoft Agent Framework or fully custom code,
**[00:12:32]** you can layer Agent 365 capabilities
**[00:12:35]** onto what you are already running incrementally.
**[00:12:40]** You pick where to start and how far you want to go,
**[00:12:44]** which are observability, governance, and security.
**[00:12:49]** Now, let's start with observability.
**[00:12:51]** The SDK adds full open telemetry-based tracing,
**[00:12:56]** which means every input, every output, every tool call,
**[00:13:00]** every model invocation.
**[00:13:03]** Developers have two paths from here.
**[00:13:05]** The first, and the one what we recommend,
**[00:13:09]** is the Microsoft OpenTelemetry Distro.
**[00:13:12]** It comes with auto instrumentation for OpenAI,
**[00:13:15]** and LangChain, and Agent Framework,
**[00:13:17]** plus hooks for everything else.
**[00:13:20]** The second path is direct injection to an OTel endpoint.
**[00:13:25]** So let's say you already have an open telemetry pipeline running
**[00:13:30]** or you are on a stack that our SDK does not support yet,
**[00:13:35]** like Java, for example.
**[00:13:37]** You can plug straight in
**[00:13:39]** and reuse what you have already built.
**[00:13:42]** And one more thing on observability,
**[00:13:44]** we have AI-guided setup for coding agents that wires
**[00:13:48]** up registration and telemetry for you.
**[00:13:52]** So developers aren't reading docs and telemet
**[00:13:55]** to get to their first trace.
**[00:13:58]** Now, here is the part security teams care about.
**[00:14:02]** With observability enabled,
**[00:14:04]** enterprise security teams can leverage it for threat hunting
**[00:14:09]** in the Microsoft Defender portal.
**[00:14:13]** The Unified Observability SDK provided can enable both IT
**[00:14:19]** and security team to secure and govern agents
**[00:14:22]** with complete visibility.
**[00:14:25]** Next, governance.
**[00:14:28]** Agent 365 SDK can enable a customer's IT and security teams
**[00:14:33]** to govern tool access, including access
**[00:14:37]** to Microsoft 365 data through MCPs.
**[00:14:40]** So mail, calendar, OneDrive, SharePoint, Teams,
**[00:14:45]** they are all reachable through governed,
**[00:14:47]** admin-controlled auditable, revocable permissions.
**[00:14:52]** Developers don't have to build bespoke connectors
**[00:14:55]** or handle consent flows themselves.
**[00:14:59]** The SDK gives you the tool surface
**[00:15:02]** and admins decide what your agent is allowed to touch.
**[00:15:07]** Developers can also bring their own MCPs and register
**[00:15:10]** with Agent 365 to get the same controlled access
**[00:15:13]** for all of your MCPs.
**[00:15:16]** And, finally, security.
**[00:15:18]** So this is where Entra Agent ID comes in.
**[00:15:22]** Developers enable Entra Agent ID through the SDK.
**[00:15:26]** And, once it's enabled, a whole set of capabilities light
**[00:15:29]** up for the customer's admins to configure identity protection,
**[00:15:34]** conditional access, and ID governance.
**[00:15:38]** So your agent gets a real verifiable identity
**[00:15:42]** and the admins get to manage it
**[00:15:44]** with the same Entra controls they are already using
**[00:15:48]** for users.
**[00:15:50]** The shortest way to put it is bring whatever framework
**[00:15:55]** or model you want, Agent 365 SDK gives you observability,
**[00:16:01]** governance, and security
**[00:16:03]** as incremental capabilities, not a rewrite.
**[00:16:07]** JEREMIAH FOLLIS: So,
**[00:16:07]** once a developer has integrated the Agent 365 SDK,
**[00:16:13]** where do Entra and Purview fit in?
**[00:16:15]** SUNIL GARG: Yep, another great question.
**[00:16:17]** So we touched on some of this on the last slide,
**[00:16:20]** but let me put it in a different frame here.
**[00:16:24]** With Entra, there's really nothing extra to wire up.
**[00:16:29]** Entra Agent ID is part of the Agent 365 SDK.
**[00:16:33]** So, once the developers have integrated with the SDK,
**[00:16:38]** identity and access management, governance, threat hunting
**[00:16:42]** in Defender, all of that just lights up for the customer.
**[00:16:46]** No additional plumbing is needed.
**[00:16:48]** For data security and compliance controls,
**[00:16:51]** including sensitivity labels, DLP, data lifecycle policies,
**[00:16:56]** all of these works in the M365 surface area, such as Teams,
**[00:17:00]** where the agent is interacting with users.
**[00:17:03]** Microsoft also provides Purview APIs that developers can use
**[00:17:07]** to wire the data controls
**[00:17:09]** into agents they are building for other scenarios.
**[00:17:13]** Regardless, enterprise customers can configure
**[00:17:16]** and enforce their own Purview policies
**[00:17:19]** to get it going at runtime.
**[00:17:21]** We are looking into making this even more easier
**[00:17:23]** from a developer perspective.
**[00:17:25]** So same agent, two extension paths, one built-in
**[00:17:29]** and one with runtime hook.
**[00:17:32]** JEREMIAH FOLLIS: That's awesome.
**[00:17:32]** Well, let's get concrete.
**[00:17:35]** Once my agent is integrated, what exactly do customers get
**[00:17:40]** across access, data, and threat protection?
**[00:17:44]** SUNIL GARG: Yeah, so this is where it all comes together.
**[00:17:48]** And let's take a look at it.
**[00:17:49]** Right? So three pillars,
**[00:17:51]** all built on the security tool set enterprise customers already
**[00:17:55]** use every day.
**[00:17:57]** Once an agent's integrated, here is what the security teams get.
**[00:18:02]** First, with Microsoft Entra, the agent gets assigned an agent ID.
**[00:18:07]** And, from there, the agent identity can be secured
**[00:18:10]** and governed like any other identity in the org.
**[00:18:14]** Lifecycle management, conditional access,
**[00:18:16]** access governance, all the controls Entra admins already
**[00:18:19]** have and know how to run.
**[00:18:23]** Second, Microsoft Purview.
**[00:18:25]** This is where data security and compliance comes in.
**[00:18:28]** Enterprise customers can manage the agent's data security
**[00:18:32]** posture, configure information protection and DLP,
**[00:18:36]** layer in insider risk management,
**[00:18:39]** and build compliance control
**[00:18:41]** so the agent meets the regulatory requirements they are
**[00:18:44]** held to.
**[00:18:46]** And, third, Microsoft Defender.
**[00:18:48]** Security teams can investigate misconfigurations
**[00:18:52]** or vulnerabilities in agents, and do advanced hunting right
**[00:18:56]** in the Defender portal.
**[00:18:58]** And, if your agents are integrated with tools
**[00:19:00]** such as Microsoft 365 apps, Defender can also detect, block,
**[00:19:05]** and respond to threats, things like tool misuse.
**[00:19:10]** So the pattern across all three is the same.
**[00:19:14]** Security teams don't have to learn new tools.
**[00:19:17]** They work where they already work.
**[00:19:20]** Let me show you some of this in action now in the demo.
**[00:19:23]** Here, I have a Genspark agent
**[00:19:26]** that already integrates with Agent 365 SDK.
**[00:19:30]** And I can show you the security outcomes
**[00:19:32]** that enterprise customers can get from this agent.
**[00:19:37]** Let's start with what every agent needs first,
**[00:19:41]** being known to the enterprise.
**[00:19:43]** Since Genspark already integrates with Agent 365 SDK,
**[00:19:47]** the agent has Entra Agent ID and a blueprint,
**[00:19:51]** which makes the agent show up right here
**[00:19:54]** in the Microsoft 365 Admin Center visible, inventoried,
**[00:19:59]** and manageable like any other enterprise asset.
**[00:20:03]** Now, watch what happens the instant this agent is registered
**[00:20:08]** through a blueprint.
**[00:20:10]** The agent gets a Microsoft Entra Agent ID,
**[00:20:13]** a real first-class identity in the tenant.
**[00:20:16]** That means it's automatically subject
**[00:20:18]** to the same governance the organization already runs
**[00:20:21]** for human users.
**[00:20:23]** I can see the audit logs of what the agent has done.
**[00:20:26]** I can see the sign-in logs
**[00:20:27]** to each endpoint the agent has made or attempted.
**[00:20:32]** Just like how we can audit for human users,
**[00:20:35]** we can now audit for agents.
**[00:20:37]** Identity governs who the agent is,
**[00:20:41]** Purview governs what data it touches.
**[00:20:45]** So every interaction this agent has, every message it reads,
**[00:20:50]** every file it pulls from SharePoint,
**[00:20:52]** every email it drafts automatically flows
**[00:20:56]** through the tenant's Purview policies.
**[00:20:58]** Sensitivity labels are honored.
**[00:21:01]** Here, I have configured the highly confidential labeled
**[00:21:05]** documents to only be shared with human users.
**[00:21:09]** This prevented the agent from reading the document even
**[00:21:12]** if this document was created by this agent.
**[00:21:15]** Next, I have a DLP rule to prevent users
**[00:21:18]** from sharing sensitive data with AI agents.
**[00:21:22]** We can see that Purview blocked this message.
**[00:21:26]** Purview enforces it at the platform layer.
**[00:21:28]** The same controls protecting humans now protect the agent.
**[00:21:34]** Finally, security.
**[00:21:36]** Defender continuously monitors the agent's behavior the same
**[00:21:41]** way it monitors any user in the tenant, anomalous tool calls,
**[00:21:47]** unusual data access patterns, signs of compromises.
**[00:21:53]** Here, we can see that a high severity alert was raised
**[00:21:57]** because the user tried a prompt injection attack.
**[00:22:02]** The rule kicked in and the tool was blocked.
**[00:22:06]** This functionality is available to all tools, like MCPs,
**[00:22:10]** that are available on Agent 365,
**[00:22:13]** or you can register your own MCP with Agent 365.
**[00:22:17]** It works for both.
**[00:22:18]** So, if something goes wrong,
**[00:22:20]** the security team doesn't need a custom playbook for AI agents.
**[00:22:25]** They use the one they already have.
**[00:22:27]** JEREMIAH FOLLIS: Sunil,
**[00:22:27]** thanks for walking us through all of that.
**[00:22:29]** Let me wrap this up for everyone watching.
**[00:22:31]** So here is the picture.
**[00:22:33]** Enterprise customers need controls to manage agent sprawl,
**[00:22:37]** prevent data leakage, protect agents against threats,
**[00:22:43]** and meet their compliance requirements.
**[00:22:45]** That's the bar your customers are holding you to.
**[00:22:49]** And Agent 365 is what makes agents meet
**[00:22:52]** that bar whether you're building on Microsoft AI platforms
**[00:22:56]** or you're integrating an agent built anywhere else
**[00:22:59]** through Agent 365 SDK.
**[00:23:02]** The bottom line for developers, well,
**[00:23:05]** that's Agent 365 gives you a comprehensive way
**[00:23:09]** to make your agent enterprise-ready
**[00:23:12]** so you can build agents your customers actually want
**[00:23:15]** and will adopt.
**[00:23:18]** SUNIL GARG: Yeah.
**[00:23:18]** And, just to add to that, right, from a developer's perspective,
**[00:23:22]** this means you don't have to choose between shipping fast
**[00:23:25]** and being enterprise ready, to be quite honest.
**[00:23:29]** The SDK gives you a path where you can build
**[00:23:32]** on the framework you already use.
**[00:23:34]** And, the moment you integrate your agents,
**[00:23:36]** inherits the identity, governance,
**[00:23:39]** and security capabilities enterprise customers expect.
**[00:23:42]** So that's what unlocks adoption.
**[00:23:44]** JEREMIAH FOLLIS: Three resources
**[00:23:45]** to help you get building with Agent 365 SDK.
**[00:23:48]** Please take a look and save these links.
**[00:23:51]** And we can't wait to see what you can build.
**[00:23:55]** Thank you for joining us.
**[00:23:56]** SUNIL GARG: Thank you.
