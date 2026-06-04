**[00:00:01]** INBAL SAGIV: Hi, everyone.
**[00:00:02]** My name is Inbal Sagiv, and I'm Principal Product Manager
**[00:00:06]** at Microsoft, working mainly on AI that runs locally.
**[00:00:11]** The session today is going to focus on extending Foundry Local
**[00:00:15]** for enterprise and disconnected environments.
**[00:00:18]** I'm going to walk you through some context from the market,
**[00:00:21]** then I'll speak through the AI offering, the model offering,
**[00:00:25]** the agent framework, and we'll close with some video agents.
**[00:00:31]** Let me start with the big picture.
**[00:00:33]** We're in a once-in-a-generation platform shift from applications
**[00:00:38]** to agentic AI as the operating layer.
**[00:00:43]** The data, as you see in that slide, is clear.
**[00:00:45]** We have 1.3 billion AI agents by 2028,
**[00:00:51]** which are automating end-to-end business processes.
**[00:00:54]** We see 82 percentages of organizations adopting agents
**[00:00:59]** in the next three years, moving from pilots to core workforce.
**[00:01:05]** And we see additional numbers that coming from our analysts.
**[00:01:09]** Bottom line, the takeaway is pretty simple.
**[00:01:12]** The organizations that operation --
**[00:01:15]** working today with some AI agent now need to move
**[00:01:19]** and define how the next decade
**[00:01:22]** of software is going to build and run.
**[00:01:25]** And everything is about agents and agentic capabilities.
**[00:01:32]** Now, let's see some of the scenarios that we hear
**[00:01:36]** from our customers because we want to ground everything
**[00:01:40]** that we ship with customer use cases.
**[00:01:43]** These are not optional design choices.
**[00:01:46]** These are hard constraints geopolitical risks,
**[00:01:51]** regulatory control, the need to operate through outages,
**[00:01:55]** the growing pressure to adopt AI
**[00:01:58]** without giving up on sovereignty.
**[00:02:00]** The bottom line here is that customer says
**[00:02:04]** that AI strategy has to work when actually things are break.
**[00:02:09]** This is not just when everything is running smoothly on cloud.
**[00:02:13]** Now you see here multiple type of use cases and scenario,
**[00:02:16]** but let me just pick two items here.
**[00:02:22]** One of these are actually the public safety.
**[00:02:26]** When you are running a command center or responding
**[00:02:30]** to a crisis, there is no tolerance for latency,
**[00:02:33]** for dependency, or for outages.
**[00:02:35]** AI needs to be operated fully disconnected while still
**[00:02:40]** delivering real-time situational awareness and decision support.
**[00:02:43]** No external calls, no data which has been sent to the cloud.
**[00:02:48]** If the network goes down, the system cannot goes down.
**[00:02:52]** We see it also from critical infrastructures
**[00:02:55]** like energy and utilities.
**[00:02:57]** These environments are distributed, often remote,
**[00:03:00]** and in these scenarios, connectivity is not guaranteed.
**[00:03:05]** Yet, they rely on AI for real-time monitoring,
**[00:03:09]** for diagnostics, and incident responses.
**[00:03:13]** If a substation or a rail system loses connectivity,
**[00:03:17]** operation does not.
**[00:03:19]** The AI must continue running locally safety
**[00:03:22]** and with compliance.
**[00:03:24]** So when you step back, this is the shift.
**[00:03:26]** AI is no longer just about performance or scale,
**[00:03:30]** but it's actually about resilience and control,
**[00:03:32]** and the ability to operate under these constraints.
**[00:03:37]** The organizations solving for these now are those ones
**[00:03:41]** that will actually be able
**[00:03:43]** to deploy the AI everywhere it matters.
**[00:03:50]** If we look at the portfolio that Microsoft offers, when it comes
**[00:03:55]** to sovereign cloud, this allow the customers the freedom
**[00:03:58]** to choose the right balance of control,
**[00:04:00]** capability, and autonomy.
**[00:04:04]** Sovereign AI is about control,
**[00:04:05]** not just about the location itself.
**[00:04:07]** So, in the middle, you see "sovereign private cloud,"
**[00:04:10]** which is a cloud environment, operated under full customer
**[00:04:15]** or national control, where data and the models
**[00:04:17]** and the operations remain within a defined regulatory
**[00:04:22]** or geographic boundaries.
**[00:04:24]** It combines the cloud capabilities with an isolated
**[00:04:28]** and compliant infrastructure, Azure Local,
**[00:04:31]** that can operate independently, ensuring the continuity,
**[00:04:35]** the control, and the resilience even
**[00:04:38]** without external cloud connectivity, as I mentioned.
**[00:04:42]** Now, we're focusing on this context, before I'll dive
**[00:04:47]** into the entire AI offering, it's very important
**[00:04:51]** to understand what is Azure Local and why we actually run
**[00:04:57]** on that Azure Local infrastructure.
**[00:05:01]** So Azure Local is not new.
**[00:05:04]** We're actually GA on both offering that is running
**[00:05:07]** on a connected and disconnected,
**[00:05:10]** fully disconnected sovereign use cases.
**[00:05:14]** And this is actually the foundation
**[00:05:15]** that makes the sovereign
**[00:05:17]** and enterprise AI possible on premises.
**[00:05:19]** It's not just a server.
**[00:05:21]** It's a proposed built-in AI-optimized infrastructure
**[00:05:27]** platform that designed to run the full Foundry Local stack.
**[00:05:30]** I'll speak through this in a minute.
**[00:05:33]** And when I refer to Foundry Local, I really refer
**[00:05:36]** from models to inferencing to agentic workflows entirely,
**[00:05:41]** where within the customer-own environment.
**[00:05:45]** Look at the hardware layer.
**[00:05:47]** So Azure Local delivers AI optimized hardware configuration
**[00:05:51]** that spanning across CPU, NPU, and GPU.
**[00:05:54]** It's validated and certified to run a set
**[00:05:59]** of Foundry workloads out of the box.
**[00:06:02]** When you need a single-node inferencing
**[00:06:04]** or a lightweight model or a multi-node GPU cluster
**[00:06:07]** for high-performance generative AI,
**[00:06:09]** then the hardware is pre-validated
**[00:06:11]** so customers can deploy with a confidence
**[00:06:14]** and without lengthy qualification cycles.
**[00:06:19]** Now, actually, everything when we talk in the context
**[00:06:22]** of AI runs on Kubernetes native operation.
**[00:06:26]** The platform runs Arc-enabled Kubernetes,
**[00:06:28]** which means AI workloads are deployed and scaled
**[00:06:31]** and managed using the same declarative operator-based
**[00:06:36]** approach that IT teams already know
**[00:06:40]** for their containerized application.
**[00:06:44]** And Foundry Local has been installed as an Arc extension.
**[00:06:47]** No custom orchestration or a proprietary tooling.
**[00:06:51]** If your team knows Kubernetes,
**[00:06:53]** they already know how to operate this one.
**[00:06:56]** I called out the connected and disconnected.
**[00:06:58]** It's very important.
**[00:06:59]** Azure Local is designed for the full spectrum of connectivity.
**[00:07:04]** In connected mode, it syncs model catalog
**[00:07:07]** and management policies from the cloud through Azure Arc.
**[00:07:11]** And in fully disconnected or air-gapped environment,
**[00:07:14]** the same infrastructure continues
**[00:07:16]** to operate autonomously.
**[00:07:17]** It means that models are cached locally and inference runs
**[00:07:20]** without any cloud dependency.
**[00:07:23]** And the operation teams actually retain the full control.
**[00:07:28]** Of course, it comes with a security and governance.
**[00:07:31]** So identity is handled through Microsoft Entra ID
**[00:07:33]** with the JWT validation and inference endpoints are secured
**[00:07:39]** with a TLS and API key or token-based authentication.
**[00:07:43]** This is the same identity and governance layer
**[00:07:46]** that customers use across their cloud estate.
**[00:07:50]** But we're just extended it to on-premises AI
**[00:07:53]** without any compromises.
**[00:07:56]** So Azure Local is not just about the hardware,
**[00:07:58]** not just about the infrastructure.
**[00:08:00]** It's the AI ready platform that brings the Foundry capabilities
**[00:08:05]** from the cloud to the enterprise edge
**[00:08:07]** with a pre-validated hardware,
**[00:08:09]** with a Kubernetes native operation,
**[00:08:11]** as well as the security that I was calling out.
**[00:08:16]** Now, I mentioned Foundry.
**[00:08:18]** So everybody knows
**[00:08:19]** that Microsoft has the out-of-the-box offering
**[00:08:24]** to build agent on cloud, on our public cloud.
**[00:08:27]** That's the Microsoft Foundry.
**[00:08:29]** And on the right side of the screen,
**[00:08:32]** we have our on-device inferencing offering.
**[00:08:37]** It's an SDK that optimized for Windows and Mac OS and Android.
**[00:08:42]** Now, what we're introducing today and announcing
**[00:08:45]** in a public preview is Foundry Local that runs
**[00:08:48]** on the infrastructure that I mentioned before,
**[00:08:51]** on Foundry Local for both connected
**[00:08:53]** and disconnected scenarios for single-node and multi-node
**[00:08:57]** across the different form factors of Azure Local.
**[00:09:01]** Now, today, we're happy to announce three capabilities
**[00:09:06]** when we say Foundry Local.
**[00:09:09]** On February this year,
**[00:09:11]** we've already announced the availability
**[00:09:14]** of Foundry Local model catalog on a single-node deployment.
**[00:09:18]** That was good for those customers
**[00:09:21]** that has ONNX inferencing needs
**[00:09:24]** and single node is sufficient for them.
**[00:09:26]** But those that really needs to scale and run
**[00:09:29]** across multi-node now can benefit
**[00:09:32]** from Foundry Local model catalog,
**[00:09:35]** as well as inferencing capabilities.
**[00:09:38]** So that is one of our announcements.
**[00:09:40]** The second one is around knowledge.
**[00:09:42]** We're happy to refresh our RAG offering.
**[00:09:46]** That's a local RAG offering that helps you
**[00:09:49]** to manage your knowledge in the organization,
**[00:09:52]** and we will show you how it's going to look like in a minute.
**[00:09:56]** As well as some tools.
**[00:09:57]** Now what tools means.
**[00:09:59]** It means that if you have a custom MCP, that you would
**[00:10:05]** like to connect it to your local sources, then now it's possible
**[00:10:10]** to do the mixture of choosing the right model using RAG
**[00:10:16]** capabilities and connect it through custom MCPs,
**[00:10:20]** and also other local tools that you might have.
**[00:10:23]** So the combination can come together,
**[00:10:25]** run on an Arc-enabled Kubernetes environment
**[00:10:29]** across the different form factors of Azure Local,
**[00:10:33]** from single-node to multi-node deployment.
**[00:10:36]** Which scenarios do we enable by that?
**[00:10:39]** So let's start to look at the models.
**[00:10:41]** From left to right, you see that there is now option
**[00:10:44]** to discover and deploy models.
**[00:10:47]** There is a catalog of models
**[00:10:48]** which are curated for those scenarios.
**[00:10:50]** And there is also an option to bring your own model.
**[00:10:52]** So if you have a container with models that you choose
**[00:10:58]** from Hugging Face, let me pick an example.
**[00:11:01]** Let's say YOLO 10 or any predictive or generative AI,
**[00:11:04]** you can package this together and mix it, and merge it
**[00:11:08]** with your own OCI registry.
**[00:11:12]** And we provide you the option to serve these models, whether it's
**[00:11:16]** with a vLLM or with an ONNX Runtime.
**[00:11:19]** On the agent and tool size, we have now the option to connect
**[00:11:23]** to your local data with those MCPs that I mentioned.
**[00:11:27]** We bring you a reference application
**[00:11:30]** so you can build your local chat experience, and of course,
**[00:11:34]** it comes with an option also to build agents
**[00:11:39]** that can run locally and connect
**[00:11:41]** with that entire platform offering.
**[00:11:44]** So today, we are announcing Foundry Local model offering.
**[00:11:50]** It means that we are expanding Foundry Local
**[00:11:53]** to include more community as well as proprietary models.
**[00:11:58]** And all these are validated and run on Azure Local
**[00:12:03]** for both connected and disconnected scenarios.
**[00:12:06]** Now, on the model platform offering,
**[00:12:09]** this is where the entire stack is being managed
**[00:12:12]** by the customers.
**[00:12:13]** This is where we bring the complete Foundry Local community
**[00:12:17]** models, the open source models, and making sure
**[00:12:20]** that these models can run
**[00:12:22]** through the different form factors or sizes of Azure Local
**[00:12:26]** from a single-node deployment to multi-node deployment.
**[00:12:29]** And it comes with a pre-built inferencing capabilities,
**[00:12:34]** like ONNX Runtime for single node deployment and vLLM
**[00:12:38]** for multi-node deployment.
**[00:12:40]** And this one works for both connected
**[00:12:43]** and fully disconnected scenarios.
**[00:12:46]** The other option where we bring the customers the different
**[00:12:54]** Foundry Local model called model as a service.
**[00:12:59]** This is Microsoft-managed offering,
**[00:13:02]** but that's the approach for the customers really
**[00:13:04]** to get an access to their frontier models.
**[00:13:08]** We are working with Microsoft partners
**[00:13:10]** to bring the proprietary IP models,
**[00:13:13]** so think about the Mistral and OpenAI and others, to customers
**[00:13:18]** with the most sensitive workloads
**[00:13:20]** where they cannot access the cloud.
**[00:13:24]** We're still partnering with some of these vendors,
**[00:13:27]** and there are specific eligibility criteria,
**[00:13:31]** so it's not available for everybody.
**[00:13:33]** Our customers are having some geopolitical
**[00:13:36]** and sovereign-driven model restrictions.
**[00:13:39]** So, for that purpose, we're shipping also the option
**[00:13:43]** of model as a service offering.
**[00:13:47]** This is driven, for example, by requesting EU only LLMs
**[00:13:53]** or geopolitical tension or regulatory pressure.
**[00:13:58]** Some customers has concern around foreign jurisdiction
**[00:14:02]** and external access and they prefer a long-term strategic
**[00:14:08]** autonomy, fully disconnected.
**[00:14:11]** So this is the purpose of having a model
**[00:14:13]** as a service option for those customers.
**[00:14:19]** And both are valid.
**[00:14:22]** It means that -- at the end, there is a link
**[00:14:24]** if you're interested either in model as a platform or model
**[00:14:28]** as a service, just fill in the form, and you can get access
**[00:14:33]** and support from our product groups.
**[00:14:36]** Now, you see here how things are being structured together.
**[00:14:41]** So on the infra layer, we have Azure Local.
**[00:14:43]** On top of it, we have the Kubernetes clusters.
**[00:14:46]** Then there is the inference model, which could be ONNX
**[00:14:50]** for single node, vLLM, what we are announcing today,
**[00:14:53]** for multi-node deployment.
**[00:14:54]** And on top of it, we have some community model.
**[00:14:56]** You see here, just a partial list.
**[00:14:58]** We have 71 different models in the catalog.
**[00:15:03]** But a customer would need to choose if the approach
**[00:15:06]** to manage these models is through the platform itself
**[00:15:10]** or through the model as a service that allows also
**[00:15:13]** to get access to those frontier models
**[00:15:16]** that meets the eligibility criteria
**[00:15:19]** that I mentioned before.
**[00:15:21]** So, in order to do that, you see here, a screenshot
**[00:15:25]** from Azure Local with the option now to get Foundry Local,
**[00:15:32]** everything that I've described so far,
**[00:15:34]** so that the IT can now decide to deploy this
**[00:15:37]** and make it available for the developers.
**[00:15:43]** With that model offering that we are proposing today in preview,
**[00:15:48]** I'm explicitly calling out the inference layer support,
**[00:15:53]** which is generative AI via ONNX Runtime
**[00:15:56]** for single-node deployment,
**[00:15:58]** plus vLLM for multi-node high-performance serving,
**[00:16:02]** plus predictive AI workloads through ONNX Runtime.
**[00:16:06]** So all models, whether it's from the Foundry catalog,
**[00:16:09]** from the partner providers,
**[00:16:11]** or from the customer own bring your own model,
**[00:16:14]** can run through one consistent runtime
**[00:16:17]** with an OpenAI-compatible REST endpoints.
**[00:16:22]** Key part of what we're actually enabling today is the breadth
**[00:16:27]** of model catalog.
**[00:16:29]** Customers are not locked into a single model strategy.
**[00:16:34]** They can choose across proprietary, open weight,
**[00:16:37]** and specialized models depending on the use case
**[00:16:40]** and the performance need and the regulation constraints.
**[00:16:44]** It means that using frontier models for reasoning
**[00:16:51]** or smaller efficient models for edge
**[00:16:54]** and disconnected environments is now possible.
**[00:16:57]** Customer can benefit from a domain-tuned model
**[00:17:00]** for specific workloads and all within the same platform.
**[00:17:04]** It results with flexibility without compromises
**[00:17:08]** on the right model, on the right place
**[00:17:11]** under full customer control.
**[00:17:15]** Now, let me walk you through some technical demo,
**[00:17:22]** so you can see how the things are coming up together.
**[00:17:25]** So that's just a screenshot from Microsoft Azure.
**[00:17:30]** And if we'll go here to "Settings," to "Extension,"
**[00:17:34]** and I'll click on the plus, there is a new option:
**[00:17:37]** Foundry Local on Azure Local.
**[00:17:40]** So I'll click on creation of that extension.
**[00:17:42]** I will fill in the right configuration parameters,
**[00:17:46]** review, and create this.
**[00:17:49]** That's all I need to do as an IT in order
**[00:17:52]** to get it available on Azure Local.
**[00:17:56]** Now, let's see how things are coming up together.
**[00:18:00]** I'm not making assumption
**[00:18:01]** that developers works with interfaces.
**[00:18:06]** Sometimes they prefer to work with either SDK, CLI, or API.
**[00:18:10]** So everything that we're shipping is available
**[00:18:13]** through these different options.
**[00:18:15]** Now, here is an example
**[00:18:17]** of how we're doing the model deployment.
**[00:18:21]** It's from PowerShell.
**[00:18:23]** So you see here that we're fetching the access token
**[00:18:26]** to be able to run those models.
**[00:18:31]** Here, what I see as part of the responses is the list
**[00:18:35]** of all the models which are available.
**[00:18:38]** Now I'm running another command in order to deploy one
**[00:18:42]** of the selected models.
**[00:18:43]** Let me just pause here and show you.
**[00:18:46]** I want to call it like gpt-oss-vllm.
**[00:18:48]** That's just a name that I want to put for the model.
**[00:18:51]** And in the body, I put here the model that I would like to run.
**[00:18:55]** In this case, it's gpt-opensource-20b.
**[00:18:59]** And I can also mention which inferencing I would like to use.
**[00:19:03]** And as a response, what actually happened here,
**[00:19:05]** you see here a POST request that says, "Oh,
**[00:19:07]** this one has been deployed."
**[00:19:09]** Now I want to do the same thing but with a Mistral model.
**[00:19:12]** So I'll just switch the body to Mistral 3b.
**[00:19:16]** And I'm running again a POST one.
**[00:19:18]** And as part of the response,
**[00:19:20]** this is actually the real deployment
**[00:19:22]** of these two selected models via a command line.
**[00:19:27]** Remember this, later on,
**[00:19:28]** I'm going to use it in my next demos.
**[00:19:33]** So, so far, we spoke about the model offering
**[00:19:36]** with the two options, and I showed you how it's going to --
**[00:19:38]** how things are being available for the IP --
**[00:19:42]** for the IT persona, as well as for the developer.
**[00:19:45]** Now look at the agent and tools with Foundry Local.
**[00:19:48]** So what you see here is the second part
**[00:19:52]** where we are enabling the developer also
**[00:19:55]** to build his own AI application with the deployed models.
**[00:19:59]** So in order to be able to do that,
**[00:20:01]** we provide a solution templates.
**[00:20:04]** Think about it as a code samples which are available now
**[00:20:08]** in Microsoft Foundry solution templates.
**[00:20:10]** So we have two offerings there.
**[00:20:12]** One is a chat UI.
**[00:20:14]** It's really a standard chat experience end-to-end,
**[00:20:19]** that is -- can be connected to an agent.
**[00:20:24]** And this agent can be created by the developer.
**[00:20:27]** And as part of this agent,
**[00:20:28]** you can use the deployed model on that cluster.
**[00:20:31]** There is also video agent just to show another example
**[00:20:35]** of use cases where, for example,
**[00:20:37]** content from CCTV cameras can be analyzed
**[00:20:41]** through a product named Video Indexer
**[00:20:43]** that again runs on Azure Local.
**[00:20:47]** We also, on the knowledge side, we also enable the --
**[00:20:52]** in the extension to use the agentic RAG capability.
**[00:20:56]** It means that you can really manage your local knowledge
**[00:21:02]** with a local chat UI, which has been connected
**[00:21:04]** to a local RAG logic behind the scenes that now also,
**[00:21:09]** for the first time, can take action.
**[00:21:11]** This is one of the preview announcements
**[00:21:12]** that we are making today.
**[00:21:14]** And there is an option either to build your own custom MCP
**[00:21:19]** or simply to use one of the out-of-the-box MCPs
**[00:21:25]** that we have in the catalog.
**[00:21:26]** With time, one of the things that we are looking at you
**[00:21:30]** to come back to us is which MCPs do you need?
**[00:21:35]** Which local sources you are interested to connect
**[00:21:37]** to your local environment?
**[00:21:41]** And then we can expand the catalog based
**[00:21:44]** on the customer requirements and need as we go.
**[00:21:48]** So it's just a matter of allowing you
**[00:21:51]** to manage your knowledge through agentic RAG, reasoning,
**[00:21:55]** and grounding capabilities, as well as to be able
**[00:21:58]** to invoke some tooling and making some agentic flows
**[00:22:06]** that can run automatically.
**[00:22:08]** Now, here is just an example how things are being
**[00:22:12]** modeled together.
**[00:22:12]** So, at the top, you see the knowledge pipeline.
**[00:22:19]** When a user asks a question
**[00:22:21]** and then the agent first plans the query.
**[00:22:24]** It decides what to search for.
**[00:22:27]** Then it selects which knowledge sources to hit.
**[00:22:30]** And finally, it merge the result into a grounded answer.
**[00:22:34]** And here's the key part.
**[00:22:37]** This is iterative.
**[00:22:40]** I mean, you can run it in a couple of iterations.
**[00:22:43]** If the agent look at the results
**[00:22:45]** and decide doesn't have enough, then it loops back.
**[00:22:48]** It rewrites the queries.
**[00:22:50]** It expands the scope.
**[00:22:51]** It retrieves again.
**[00:22:52]** That's what makes it an agentic RAG.
**[00:22:54]** And it keeps going until it has a high confidence evidence,
**[00:22:59]** or it hits the configured effort limit.
**[00:23:02]** All of this runs locally.
**[00:23:03]** No cloud calls.
**[00:23:05]** Every response is traceable back to the source document.
**[00:23:11]** What you see in the bottom is that we have two options
**[00:23:14]** of sources of tools that we are allowing.
**[00:23:18]** Either it's indexed or it's a remote.
**[00:23:22]** There is an explicit call out here
**[00:23:24]** for SharePoint Exchange Server as well as Exchange Server.
**[00:23:31]** Both are part of Microsoft 365 Local
**[00:23:36]** that can run on Azure Local.
**[00:23:38]** So now we are partnering and testing our POC.
**[00:23:44]** So if you are interested in these scenarios,
**[00:23:46]** we are welcoming you to register and try out the POC
**[00:23:51]** that we've built specifically, with these two capabilities,
**[00:23:57]** where we can read the local data.
**[00:24:02]** Now, how things are actually working together.
**[00:24:07]** In the middle, you see here the chat, the local chat experience,
**[00:24:13]** and the developer actually needs to build a local agent
**[00:24:17]** that can work with the deployed model,
**[00:24:20]** with the agentic RAG, and with those tools.
**[00:24:23]** So, in this case, I'm working with Mistral,
**[00:24:25]** and I just hit here a question.
**[00:24:28]** You see that there is an agent which has been --
**[00:24:31]** which has been connected to that particular implementation.
**[00:24:36]** And it show here the sources.
**[00:24:38]** So it says SharePoint and Exchange are toggled
**[00:24:40]** on because it comes with a pre-configured capability
**[00:24:45]** to connect to a local data.
**[00:24:48]** And every response here show me also the source.
**[00:24:51]** Where did I fetch the information from?
**[00:24:55]** So that really enables customers to run local chat capabilities
**[00:25:02]** with the deployed model.
**[00:25:04]** You see it says here Ministral.
**[00:25:06]** We don't need that strong model in that particular scenarios.
**[00:25:11]** But the good thing is that you can really now work
**[00:25:15]** with a drop-down menu and just to switch this as you do
**[00:25:18]** in other local chat experiences.
**[00:25:22]** Last but not least, I just mention another offering
**[00:25:25]** that we have for video analysis.
**[00:25:29]** So you can go to Foundry solution template
**[00:25:31]** and for the first time download the code sample,
**[00:25:35]** also for video analysis, and try it out yourself.
**[00:25:41]** Just like we -- I showed you with the local chat experience,
**[00:25:45]** you can do it also with a video agent.
**[00:25:49]** That can serve multiple type of scenarios,
**[00:25:52]** mainly for live video analysis.
**[00:25:56]** If you want to learn more, there is a link here
**[00:25:59]** where you can register to our preview that covers everything
**[00:26:04]** that I showed you so far.
**[00:26:07]** And then you can decide if you want to try
**[00:26:09]** out only the model offering or you want to expand it
**[00:26:13]** and also try the RAG and the local chat experience.
**[00:26:16]** That's available for customers that runs
**[00:26:19]** on Kubernetes on Azure Local.
**[00:26:23]** There is a great blog post
**[00:26:25]** that explains both technicalities and code samples.
**[00:26:29]** So feel free to just click here and learn more
**[00:26:34]** and download the code sample, and try it yourself.
**[00:26:37]** And, of course, documentation is also available for you to learn
**[00:26:43]** about the different models that we offer and in
**[00:26:46]** which scenarios to use what.
**[00:26:50]** In any chance that you would like to stay in touch,
**[00:26:53]** then feel free to reach out.
**[00:26:55]** We're looking at customers and developers
**[00:26:57]** that will give us feedback about the preview
**[00:27:01]** that we just announced today.
**[00:27:03]** And thank you so much for listening.
