**[00:00:00]** JESSE HALL: Let's discuss agents, not just any agents,
**[00:00:02]** but real-time multimodal agents.
**[00:00:05]** Many agents being built today are single modal.
**[00:00:09]** They're text agents.
**[00:00:11]** And with text agents, latency is much more forgiving.
**[00:00:15]** Users are okay with a spinner or a text shimmer
**[00:00:19]** to let them know something's going on.
**[00:00:21]** But with real-time agents, latency is key.
**[00:00:25]** And so that's what we're going to talk about today.
**[00:00:27]** Real-time, it is built different.
**[00:00:30]** What is LiveKit?
**[00:00:31]** We'll discuss the cascaded pipeline and then how Azure
**[00:00:35]** and LiveKit work together.
**[00:00:37]** So before we talk about LiveKit, let's discuss some challenges
**[00:00:42]** that you will face when building a real-time multimodal
**[00:00:46]** agentic experience.
**[00:00:48]** You see, models, they are the easy part now.
**[00:00:51]** Everything around it is the hard part.
**[00:00:53]** Voice is one modality, and voice is real-time.
**[00:00:58]** And so we have to take the user's voice
**[00:01:00]** from their microphone, wherever they are in the world,
**[00:01:02]** send that to the models, generate a reply,
**[00:01:06]** and send that back to the user's speakers,
**[00:01:08]** all within a few hundred milliseconds,
**[00:01:11]** if we want to consider it real-time, over networks
**[00:01:14]** that we don't control.
**[00:01:15]** And so we have to think about all
**[00:01:17]** of the things that add to latency.
**[00:01:19]** So network conditions, echo and noise cancellation.
**[00:01:23]** We need to detect when the user is finished talking,
**[00:01:26]** so turn detection.
**[00:01:28]** We also need to allow the user to interrupt,
**[00:01:30]** but we don't want them to interrupt for a cough
**[00:01:33]** or a sneeze, or if they're back-channeling by saying, hmm,
**[00:01:36]** oh, yeah, we don't want that to interrupt.
**[00:01:39]** So there are a lot of things to think about and a lot of things
**[00:01:43]** that go into creating an excellent real-time
**[00:01:46]** user experience.
**[00:01:48]** And all of this has to work not just for a single user,
**[00:01:52]** but hopefully our application is very popular, and it needs
**[00:01:55]** to scale to hundreds, tens, or hundreds of thousands
**[00:01:58]** of users concurrently.
**[00:02:00]** And so, again, these challenges, they are not the responsibility
**[00:02:04]** of the models, but they are the responsibility
**[00:02:07]** of the real-time media infrastructure,
**[00:02:10]** which many are not even thinking about.
**[00:02:13]** And so this is exactly what WebRTC was designed for,
**[00:02:17]** but building infrastructure around WebRTC is not trivial.
**[00:02:21]** And so this is where LiveKit comes in.
**[00:02:24]** LiveKit is an open-source, real-time media layer
**[00:02:27]** that your agent and your orchestration runs on.
**[00:02:31]** So not just voice, but also video and data built on WebRTC.
**[00:02:36]** And so then we have the agent's SDK.
**[00:02:38]** You can choose between Python and TypeScript.
**[00:02:41]** And these two things allow you to bring your agent,
**[00:02:44]** the same agent, to any device.
**[00:02:47]** So phones, laptops, SIP and telephony, embedded devices,
**[00:02:51]** cars, wearables, robotics, and much more.
**[00:02:55]** And LiveKit is the transport layer
**[00:02:58]** that ChatGPT chose for their voice mode.
**[00:03:02]** Now, here is the voice pipeline.
**[00:03:04]** So, again, the user speech is where we start.
**[00:03:08]** And the first thing we need to do is VAD,
**[00:03:10]** voice activity detection.
**[00:03:12]** We need to detect when the user starts speaking,
**[00:03:15]** because we don't want to process silence.
**[00:03:17]** That would cost us a lot of money.
**[00:03:19]** So when the user starts speaking, then we send
**[00:03:22]** that speech to our speech-to-text model,
**[00:03:25]** which then transcribes the speech into text,
**[00:03:29]** sends that text to the LLM.
**[00:03:30]** The LLM generates a reply, again, in text,
**[00:03:33]** which sends that to the text-to-speech model,
**[00:03:36]** which then generates the voice that goes back to the user.
**[00:03:39]** So that's the very basic voice pipeline,
**[00:03:42]** or also called a cascaded pipeline.
**[00:03:46]** Here is a zoomed-out view of this.
**[00:03:48]** So, again, we have our user, wherever they are in the world,
**[00:03:50]** on whatever device, and they're connecting through WebRTC.
**[00:03:54]** WebRTC, every modern device already speaks it.
**[00:03:58]** It is an open browser standard.
**[00:04:00]** And so then that connects to the LiveKit server,
**[00:04:02]** which handles transport,
**[00:04:04]** jitter-buffering, codecs, SIP, fan-out.
**[00:04:07]** And it's self-hosted.
**[00:04:08]** Again, it's open source, so self-hosted.
**[00:04:11]** Or you can use it on LiveKit cloud, and we host it for you.
**[00:04:14]** That is the transport layer.
**[00:04:16]** Next, we go up to the application layer,
**[00:04:18]** or the orchestration layer.
**[00:04:20]** And this is where the agent's SDK comes in.
**[00:04:23]** This is where your code lives.
**[00:04:24]** This is where you connect media to the model.
**[00:04:29]** And so this, again, is where the voice pipeline fits in.
**[00:04:32]** This is where you pick which models you want to use,
**[00:04:34]** where your tools, your MCP servers, your custom functions,
**[00:04:39]** your custom business logic, all of that sits here.
**[00:04:42]** So the box below agent's SDK is a zoom-in
**[00:04:45]** of what is inside the agent's SDK.
**[00:04:49]** And so the key takeaway here is that WebRTC gets users
**[00:04:54]** to your agent reliably, and the agent's SDK gets your custom
**[00:04:58]** business logic to your users reliably.
**[00:05:02]** LiveKit is actually model agnostic.
**[00:05:05]** We don't have any models, but this is not an exhaustive list,
**[00:05:09]** but this is some of the more popular models
**[00:05:11]** that you can use through LiveKit.
**[00:05:13]** So again, you pick which STT, which LLM,
**[00:05:15]** which TTS models you want to use.
**[00:05:18]** You can mix and match these however you want.
**[00:05:21]** And it's very easy to swap them out.
**[00:05:23]** It's just one line of code to change out a model.
**[00:05:26]** Now, this is also where Azure fits in.
**[00:05:30]** So we can actually use Azure in all three of these places.
**[00:05:34]** You can use the Azure STT.
**[00:05:35]** You can use OpenAI through Azure for the LLM,
**[00:05:38]** and then the Azure TTS.
**[00:05:41]** Now, as you're building with LiveKit, this is actually,
**[00:05:43]** I think, in my opinion, the most important slide here.
**[00:05:47]** Please use our LiveKit MCP docs server or the skill to make sure
**[00:05:53]** that you are using the most up-to-date context.
**[00:05:56]** So we ship new features at LiveKit almost every week,
**[00:06:01]** and our docs are amazing.
**[00:06:02]** They're always up-to-date.
**[00:06:04]** But your agent doesn't know this.
**[00:06:06]** And so your coding agent needs the most complete context
**[00:06:10]** to build accurately with LiveKit.
**[00:06:12]** So I prefer the MCP server.
**[00:06:14]** It's amazing.
**[00:06:16]** Let's get into a demo.
**[00:06:17]** Let's see how we can build one of these out using Azure
**[00:06:20]** and go ahead and talk to it.
**[00:06:24]** So first thing in your terminal, let's do LKAppCreate,
**[00:06:28]** and we're going to use a template,
**[00:06:29]** the AgentStarterPython template.
**[00:06:31]** And then we're going to install another template using the same
**[00:06:34]** thing, but it's the ReactStarter template for our front end.
**[00:06:38]** Now, in the Agent template, you'll find the Agent.py file,
**[00:06:41]** and this is the entire single file
**[00:06:44]** where your agent logic sits.
**[00:06:46]** So first thing is we are importing some things
**[00:06:48]** from LiveKit agents and LiveKit plugins,
**[00:06:51]** namely the Azure plugin for LiveKit.
**[00:06:54]** A little bit below this, we have our Assistant.
**[00:06:57]** So this is our Agent.
**[00:06:58]** You can name this anything you'd like.
**[00:07:00]** But what we're setting up in here is our LLM initially.
**[00:07:03]** And so, again, we're using Azure LLM,
**[00:07:05]** and these are some environment variables
**[00:07:08]** from my Azure deployment.
**[00:07:09]** So I'm going to be using an open AI model here from Azure.
**[00:07:14]** Then we have our Instructions.
**[00:07:16]** Of course, you're a friendly and reliable voice assistant demoing
**[00:07:19]** at Microsoft Build, and I gave it some Microsoft
**[00:07:22]** Build information.
**[00:07:24]** We can collapse that, and we'll move down here to OnEnter.
**[00:07:27]** When the agent enters our session,
**[00:07:30]** we want to greet the user.
**[00:07:31]** So we're going to give it some instructions there,
**[00:07:33]** greet the user warmly, welcome them
**[00:07:36]** to Microsoft Build, et cetera.
**[00:07:39]** And then we define our server as AgentServer.
**[00:07:42]** We're setting up our Solero VAD here,
**[00:07:44]** and then here is our session.
**[00:07:46]** So we're going to name our session, named it MyAgent.
**[00:07:49]** But this is so that the front end knows
**[00:07:51]** which agent to connect to.
**[00:07:53]** So the front end needs that same identifier.
**[00:07:56]** Now, below this is where we're actually setting
**[00:07:58]** up our agent session.
**[00:07:59]** And so here's where we define our STT, our TTS,
**[00:08:02]** and other variables here.
**[00:08:04]** But again, we're using the Azure STT and the Azure TTS,
**[00:08:08]** and I'm defining the voice right here.
**[00:08:11]** When we start our session with the agent that we defined,
**[00:08:15]** and then we await the connection,
**[00:08:17]** and then we go ahead and run this file.
**[00:08:20]** It's actually very, very simple
**[00:08:21]** to get this agent up and running.
**[00:08:23]** Next, we just need to define some environment variables.
**[00:08:26]** So you get three environment variables
**[00:08:28]** from LiveKit Cloud once you've signed up.
**[00:08:30]** Of course, completely free.
**[00:08:31]** You'll also need some Azure environment variables here
**[00:08:34]** for your STT and TTS models.
**[00:08:37]** And then OpenAI API key, of course, as well from Azure.
**[00:08:42]** And then we just CD into Agent.
**[00:08:44]** We're going to UV Sync, and then UV Run the Agent Pi download
**[00:08:48]** files, which is going
**[00:08:48]** to download our small Solero VAD voice activity detection model.
**[00:08:53]** And then we're going to CD
**[00:08:54]** into the front end, PMPM install that.
**[00:08:56]** And then we're going to UV Run the Agent in Dev mode,
**[00:08:59]** and PMPM Dev on the front end.
**[00:09:01]** So I've customized my front end just a little bit,
**[00:09:03]** Microsoft Build theme here, and we're going to start talking.
**[00:09:10]** COMPUTER VOICE: Hi there.
**[00:09:11]** Welcome to Microsoft Build.
**[00:09:13]** I can help with questions about Microsoft technologies
**[00:09:15]** like Azure, Windows, Microsoft 365, GitHub,
**[00:09:20]** or the latest AI work Microsoft is sharing here.
**[00:09:23]** What would you like to explore?
**[00:09:25]** JESSE HALL: Awesome.
**[00:09:26]** Yeah. Tell me, what are the dates for Microsoft Build?
**[00:09:32]** COMPUTER VOICE: Microsoft Build 2026 takes place
**[00:09:34]** on June 2nd and June 3rd.
**[00:09:36]** It is a two-day event in San Francisco at Fort Mason
**[00:09:40]** with an online experience as well.
**[00:09:42]** Are you planning to attend in person or join online?
**[00:09:46]** JESSE HALL: That's today, and I'm already there.
**[00:09:48]** We'll see you.
**[00:09:49]** So that's it.
**[00:09:49]** Quick and easy.
**[00:09:50]** Integrate Azure.
**[00:09:51]** Give it a try today, and let us know what you think.
