**[00:00:00]** EDO SEGAL: Welcome to the Napster Companion API session.
**[00:00:03]** If you're here, you're probably curious
**[00:00:04]** about video multimodal agents
**[00:00:07]** that you can deploy in your application.
**[00:00:09]** One of the core areas of friction
**[00:00:11]** for doing this has been the cost.
**[00:00:14]** We've been working for the last three years on reducing the cost
**[00:00:17]** and engineering the heck out of it, so we can deliver it to you
**[00:00:21]** at a cost-effective way,
**[00:00:22]** so you can actually scale it to millions of users.
**[00:00:25]** And we've also made it incredibly easy
**[00:00:27]** for you to deploy them.
**[00:00:28]** So literally within one day, you can add a video multimodal agent
**[00:00:32]** to your agentic application.
**[00:00:34]** This adds another layer of human connection
**[00:00:36]** to everything you're building, as we're already seeing
**[00:00:39]** in the wild with some of the world's biggest companies.
**[00:00:41]** We'll share some examples, as well as walk you through how
**[00:00:44]** to actually build it yourself in a matter of hours.
**[00:00:47]** Over to Ziv Navoth, our Chief Product Officer.
**[00:00:51]** ZIV NAVOTH: Thanks, Edo.
**[00:00:53]** Let's start with cost because for many developers,
**[00:00:55]** that's been the gating factor.
**[00:00:57]** Real-time multimodal video agents have been technically
**[00:01:00]** possible for a while.
**[00:01:02]** What hasn't been possible is shipping them at scale.
**[00:01:05]** The Omniagent API runs at only one cent per render minute
**[00:01:09]** when you bring your own LLM.
**[00:01:10]** That's roughly 20 times cheaper than the alternatives.
**[00:01:14]** Enough that a five-minute customer call costs five cents,
**[00:01:18]** and a full-time agent running eight hours a day costs less
**[00:01:22]** than $5.
**[00:01:23]** So that's a shift that makes this a production tool instead
**[00:01:26]** of a proof of concept.
**[00:01:28]** Now, let's talk about how this fits in your stack.
**[00:01:31]** The Omniagent API is Azure Native.
**[00:01:34]** The browser-side SDK opens an HTTPS and WebRTC connection
**[00:01:39]** through Azure's Front Door and load balancing solutions.
**[00:01:43]** Our network stack also has private endpoint support.
**[00:01:46]** Omniagent core pods run in Azure Kubernetes Service, auto-scaled.
**[00:01:51]** The orchestration layer can talk
**[00:01:53]** to your own Azure OpenAI deployment,
**[00:01:55]** or it can talk to ours.
**[00:01:57]** The real-time multimodal rendering pipeline runs
**[00:01:59]** on dedicated Azure VM clusters
**[00:02:01]** and streams synchronized video back over WebRTC
**[00:02:05]** with low round-trip latency.
**[00:02:07]** Every component you see in this stack is running
**[00:02:09]** on an Azure managed service.
**[00:02:12]** Omniagent delivers three additional benefits.
**[00:02:15]** First, single cloud billing.
**[00:02:18]** The line item shows up on your existing Azure invoice.
**[00:02:21]** Second, your existing governance policies just keep working.
**[00:02:25]** The same Azure Policy, Defender,
**[00:02:27]** and DDoS protection you already have applies to this.
**[00:02:31]** Third, multi-provider support.
**[00:02:34]** Bring whichever LLM you've already deployed.
**[00:02:37]** Swapping providers is a key change, not a rewrite.
**[00:02:40]** It's the same agent configuration either way.
**[00:02:44]** Siemens is one of our key deployments.
**[00:02:46]** Their field service technicians interact
**[00:02:48]** with manufacturing systems through voice and video instead
**[00:02:51]** of dashboards and manual commands.
**[00:02:54]** The same architecture is running customer service,
**[00:02:56]** sales onboarding, and corporate training.
**[00:02:59]** Identical runtime, but a different agent.
**[00:03:04]** Let me show you how this comes together,
**[00:03:05]** from provisioning the resource to the live agent
**[00:03:07]** in your application in three steps: create, deploy, monitor.
**[00:03:14]** Let's build one.
**[00:03:15]** Step one, create your agent.
**[00:03:19]** The Omniagent API is part of your Azure account.
**[00:03:22]** You spin it up directly from the Azure portal,
**[00:03:24]** the same way you'd create a Cosmos DB
**[00:03:26]** or any other Azure resource.
**[00:03:28]** No separate purchase,
**[00:03:29]** no separate vendor, no separate bill.
**[00:03:32]** It lives alongside the rest of your Azure stack.
**[00:03:35]** Once it's running, open the Omniagent API dashboard.
**[00:03:39]** We'll walk through it click by click.
**[00:03:41]** Everything you see here is also available
**[00:03:43]** through the REST API itself, so you can build it click by click
**[00:03:46]** or call it from your code.
**[00:03:49]** A quick word on the anatomy of an agent before we build one.
**[00:03:52]** There are four parts.
**[00:03:54]** The Omniagent is the face, the voice, and the personality.
**[00:03:58]** The knowledge is the documents and data
**[00:04:00]** that the agent grounds its answers in.
**[00:04:02]** FAQs are the curated questions and answers
**[00:04:05]** for things you want handled the same way every time.
**[00:04:08]** And tools are what the agent calls out to when it needs
**[00:04:11]** to take action on the user's behalf.
**[00:04:14]** Omniagent plus knowledge plus FAQs plus tools.
**[00:04:17]** That's your agent.
**[00:04:19]** Now, let's go and build one.
**[00:04:21]** On the dashboard, you'll see two buttons:
**[00:04:24]** New Omniagent and New Digital Twin.
**[00:04:26]** An Omniagent is a fictional agent for support, sales,
**[00:04:30]** onboarding, or any role inside your application.
**[00:04:33]** A digital twin is an agent configured
**[00:04:35]** to represent a specific person: their likeness, their voice,
**[00:04:39]** their style, their personal knowledge.
**[00:04:42]** You don't even have to start from scratch.
**[00:04:44]** Napster ships a library of stock agents,
**[00:04:47]** pre-built personas across common roles.
**[00:04:49]** Pick one, customize it, and you're off.
**[00:04:53]** Or, build your own from scratch.
**[00:04:56]** Today, we're building Vera, a field service specialist.
**[00:05:00]** We give her a name, upload a photo, and the system spins
**[00:05:03]** up a lifelike video avatar.
**[00:05:06]** Then, we wire up the rest.
**[00:05:08]** We attach knowledge.
**[00:05:10]** Vera already has the equipment service manuals,
**[00:05:13]** the parts catalog, and the diagnostic procedures.
**[00:05:16]** Today, we're adding the Atlas service knowledge.
**[00:05:26]** We add FAQs.
**[00:05:27]** She already has the equipment safety protocols
**[00:05:30]** and the parts and warranty FAQ.
**[00:05:32]** Today, we're adding the field service FAQ.
**[00:05:47]** And we attach tools.
**[00:05:49]** This is what Vera uses to take action on the user's behalf.
**[00:05:53]** She already has get service history, look up part,
**[00:05:56]** order part, schedule inspection, and escalate to engineering.
**[00:06:00]** A pretty comprehensive toolbox.
**[00:06:02]** But today, we're going to add get customer lookup,
**[00:06:05]** so she can resolve a customer ID into a name.
**[00:06:09]** Omniagent, knowledge, FAQs, tools.
**[00:06:12]** That's Vera, defined once.
**[00:06:15]** But before we ship her, we test her in the playground.
**[00:06:25]** VERA: Hi, how can I help you?
**[00:06:27]** Marcus: Hey, Vera.
**[00:06:28]** I'm on site at customer 4421.
**[00:06:31]** The compressor is short-cycling.
**[00:06:33]** What should I check?
**[00:06:35]** VERA: Hey, Marcus.
**[00:06:36]** That's Northgate Industrial,
**[00:06:37]** same compressor we worked on last month.
**[00:06:39]** Their model has a known high-pressure switch issue.
**[00:06:42]** Let me pull their service history.
**[00:06:44]** Three pressure-related work orders in six months.
**[00:06:46]** Want me to open a parts request?
**[00:06:48]** Marcus: Yeah, go ahead.
**[00:06:52]** VERA: Done.
**[00:06:53]** The switch will be at your local depot by tomorrow morning.
**[00:06:55]** I've also scheduled a follow-up inspection for 30 days out.
**[00:06:58]** This unit needs closer monitoring.
**[00:07:01]** Marcus: Thanks, Vera.
**[00:07:04]** VERA: Good luck with the install.
**[00:07:05]** Call back if anything comes up.
**[00:07:09]** ZIV NAVOTH: That's the same Vera we just built.
**[00:07:11]** When she behaves the way we want, we can move on to deploy.
**[00:07:16]** The agent is multimodal by design,
**[00:07:18]** so it ships across the channels your users actually use.
**[00:07:21]** We also refer to this as an Omniagent.
**[00:07:25]** On the web, the web SDK opens a WebRTC connection
**[00:07:28]** and renders the video agent inside your application
**[00:07:31]** as a sales agent on your pricing page, a support concierge
**[00:07:35]** in your help center,
**[00:07:36]** an onboarding guide on your homepage.
**[00:07:39]** Lifelike presence, real-time voice,
**[00:07:41]** mounted to any element on your page.
**[00:07:44]** In your native mobile or desktop app,
**[00:07:47]** the WebSocket handler streams real-time voice
**[00:07:49]** between the app and the agent.
**[00:07:51]** Voice first, no browser required.
**[00:07:54]** On the phone, the agent answers inbound SIP and VoIP calls.
**[00:07:59]** An after-hours support line, an intake agent
**[00:08:02]** on your main number, a callback for high-priority customers.
**[00:08:06]** Your customers dial a regular phone number.
**[00:08:09]** The agent picks up.
**[00:08:12]** On text, the agent routes
**[00:08:13]** through your messaging channel of your choice.
**[00:08:16]** Same agent, same memory, same tools.
**[00:08:19]** You can also turn on memory at this layer.
**[00:08:22]** When you start a session for a user,
**[00:08:24]** you tell the Omniagent API to remember.
**[00:08:26]** From that point on, the agent extracts facts,
**[00:08:29]** summarizes conversations,
**[00:08:30]** and carries that context forward automatically.
**[00:08:34]** Memory follows the user across every channel.
**[00:08:38]** Start the conversation in your web app,
**[00:08:40]** continue it on the phone,
**[00:08:42]** pick it up over text the next morning.
**[00:08:44]** Same agent, with the same context, and no re-explaining.
**[00:08:49]** Step three: Monitor.
**[00:08:52]** Every conversation the agent has
**[00:08:53]** on every channel is captured and inspectable.
**[00:08:57]** Open any session, and you see the full transcript,
**[00:09:00]** every tool the agent called, every memory read and write,
**[00:09:04]** and the identity of the user.
**[00:09:06]** End-to-end audit, native to the platform.
**[00:09:10]** Track the outcomes that matter.
**[00:09:11]** How many issues did the agent resolve?
**[00:09:13]** How many actions did it take?
**[00:09:15]** Iterate the prompt, redeploy, and watch the numbers move.
**[00:09:20]** That's the platform.
**[00:09:21]** A multimodal AI co-worker, you can spin up in your Azure tenant
**[00:09:24]** in minutes, running on your own LLM,
**[00:09:27]** deployed across every channel your customers use,
**[00:09:30]** and inspectable end-to-end.
**[00:09:32]** Three things for you to take away.
**[00:09:35]** First, it's available today on Azure.
**[00:09:37]** Provision it from the portal the same way you'd provision any
**[00:09:40]** other Azure resource.
**[00:09:42]** Second, once you're signed up, the quickstart will get you
**[00:09:44]** to a running agent in under 15 minutes.
**[00:09:47]** Bring your existing Azure OpenAI deployment, and you're off.
**[00:09:51]** And third, if you're here at Build,
**[00:09:53]** come find us at our booth.
**[00:09:54]** We'll build a co-worker with you live.
**[00:09:57]** Thanks for your time.
