**[00:00:00]** I've got a ton of stuff to talk about.
**[00:00:03]** So I packed a lot more information into this demo
**[00:00:06]** because there's been a lot of new capabilities have just
**[00:00:09]** been launched.
**[00:00:10]** So I'll try to squish that all into the time.
**[00:00:13]** And if there's any questions, just launch them in the
**[00:00:15]** middle of the discussion.
**[00:00:17]** I'm OK with that and we can have an interactive
**[00:00:19]** conversation or save them, save them till the end.
**[00:00:22]** So I work on a developer acceleration team at AMD.
**[00:00:26]** We focus primarily on the client side of AI.
**[00:00:28]** So AI PCs, these sweet little devices that are packed
**[00:00:32]** with compute power for AI processing and we're also involved
**[00:00:36]** in a lot of the work and bridging that to
**[00:00:39]** the cloud.
**[00:00:40]** So how are we combining those two technologies?
**[00:00:43]** My team works directly with Isvs and our OEM partners
**[00:00:46]** to get their AI apps in the market.
**[00:00:48]** And so we're kind of end of the line, like
**[00:00:50]** get stuff actually into production and built, but I have
**[00:00:53]** a whole suite of experts on my team that are
**[00:00:56]** full stack involved in, you know, down to the metal,
**[00:00:58]** the back end implementations.
**[00:01:00]** And we're also developing layers of software to help deploy
**[00:01:04]** applications and AI solutions in general out in the market.
**[00:01:08]** I'm going to touch a lot of those pieces here.
**[00:01:10]** So depending on, you know, what you're most interested, we
**[00:01:13]** can dig deeper into any one of them.
**[00:01:16]** So the primary discussion here is to talk about what
**[00:01:19]** we're calling Playbooks.
**[00:01:21]** This is a way to just speed up that developer
**[00:01:24]** cycle and get your apps built faster.
**[00:01:26]** So I'm going to showcase a couple of key playbooks
**[00:01:29]** in the in the areas of a gentic AI coding.
**[00:01:31]** We'll walk through how we're making that easier, walk through
**[00:01:34]** some of those playbooks.
**[00:01:35]** And then I really want to talk about fundamental shift
**[00:01:38]** that's happening underneath that, that's enabling those playbooks and experiences.
**[00:01:42]** And it's a technology that we're building into the rock
**[00:01:45]** and stack called lemonade and lemonade routers.
**[00:01:48]** So we'll cover a lot of this materials.
**[00:01:49]** We go forward before I get started, kind of a
**[00:01:53]** freebie here, take a picture.
**[00:01:56]** Thank you to our our marketing team.
**[00:01:59]** They've enabled a really great developer program here.
**[00:02:02]** We have access to a lot of content, but also
**[00:02:05]** some credits to cloud compute because, you know, these worlds
**[00:02:08]** need to live together.
**[00:02:10]** So we're developing on the edge.
**[00:02:11]** We're also developing on the cloud.
**[00:02:12]** Grab your credits and get access to some some compute
**[00:02:15]** power there on our Instinct class class devices.
**[00:02:20]** OK, I want to talk about AI use cases.
**[00:02:23]** Over the last couple of years, we've watched these use
**[00:02:25]** cases emerge.
**[00:02:26]** These are some core use cases that I'm personally following
**[00:02:29]** that I'm very interested in.
**[00:02:31]** And I see a lot of changing, a lot of
**[00:02:33]** disruption in.
**[00:02:34]** And we're looking at things from workflow automation, knowledge bases
**[00:02:38]** in general.
**[00:02:39]** Gaming is a little bit more emergent.
**[00:02:41]** We're starting to see how Gentek AI folds into that
**[00:02:43]** in a number of different ways.
**[00:02:45]** And then historically, we're thinking about coding as its own
**[00:02:48]** separate use cases, but fundamentally that's infiltrated everything.
**[00:02:52]** I mean, coding isn't even a use case.
**[00:02:53]** It's it's just a foundational layer.
**[00:02:56]** So we're going to talk about coding a lot in
**[00:02:58]** in this presentation, but I want to direct you over
**[00:03:00]** to a couple of individuals that are standing in the
**[00:03:03]** back.
**[00:03:04]** We've got a deep hands on workshop on coding with
**[00:03:07]** agents going on in the next pavilion.
**[00:03:10]** So if you're free at 1:15, definitely stop by early
**[00:03:12]** that workshop standing room only.
**[00:03:14]** It's been packed both days, but we'll go into deep,
**[00:03:18]** you know, hands on exercises on the machines, building those,
**[00:03:22]** those coding agents.
**[00:03:23]** I'm going to talk a lot about that here and
**[00:03:25]** and showcase just a, a few highlights of it.
**[00:03:29]** So the key theme that, you know, I'm really digging
**[00:03:32]** into here is this idea of of choice that we
**[00:03:35]** have.
**[00:03:35]** And what's happened in the last six months is we
**[00:03:38]** have a ton of choices, right?
**[00:03:40]** Part of that is AI assisted coding.
**[00:03:43]** Part of it is a genetic layer opening up a
**[00:03:45]** lot of options.
**[00:03:46]** But there's three fundamental modalities of choice that we have
**[00:03:50]** at our disposal now.
**[00:03:52]** One of them is the quality, like how you know
**[00:03:55]** how much performance in the accuracy of the quality of
**[00:03:58]** the task.
**[00:03:59]** Mostly we think about that in terms of the model
**[00:04:01]** we want to reach.
**[00:04:02]** Are we going to run a small model?
**[00:04:03]** Do we want to run a large foundational model and
**[00:04:06]** then have those trade-offs on cost.
**[00:04:08]** I'm going to show you an example of that in
**[00:04:10]** the demo.
**[00:04:12]** The other thing is locality.
**[00:04:14]** And what I mean by that is we can decide
**[00:04:17]** whether we want to run on a CPUAGPU or an
**[00:04:20]** NPU for running locally.
**[00:04:22]** And now we can also choose whether we want to
**[00:04:25]** split our workload across client and cloud.
**[00:04:28]** And in our presentation yesterday, we showed a use case
**[00:04:31]** with VLLM router.
**[00:04:32]** We're adding semantic filtering so the user can decide on
**[00:04:35]** those choices.
**[00:04:36]** So as a user, you're setting that policy either in
**[00:04:39]** that routing layer or in your agentic layer and then
**[00:04:42]** feeding that into our stack to do the physical routing.
**[00:04:45]** So I'll talk a little bit more about that.
**[00:04:48]** The other choice you have is we build up these
**[00:04:50]** different systems in the consumer space.
**[00:04:52]** You may have a laptop, You also may have a
**[00:04:54]** node like an appliance that's just sitting there in the
**[00:04:57]** background doing work all the time.
**[00:04:59]** And you now have choice about what kind of work
**[00:05:01]** is going to be running as a background task versus
**[00:05:04]** a foreground interactive task.
**[00:05:06]** That's going to change your decision making as well.
**[00:05:09]** And then the last, but maybe the most exciting is
**[00:05:12]** modality, right?
**[00:05:12]** Just the new models that have hit the market in
**[00:05:16]** the last six months or so, Omnimoto models, speech models
**[00:05:19]** have gotten much more sophisticated.
**[00:05:22]** So we're communicating, you know, with these things, right?
**[00:05:24]** Not with keyboards anymore.
**[00:05:27]** Also image generation, right?
**[00:05:29]** And also vision language models, so adding visual capability to
**[00:05:33]** our learning and our research and our development cycle.
**[00:05:38]** And then just amazing progress in AI models, text models,
**[00:05:42]** V LLMS in general.
**[00:05:44]** And those are all being integrated in these multimodal omnimodal
**[00:05:47]** experiences.
**[00:05:48]** And the industry has not fully standardized on how to
**[00:05:51]** do that.
**[00:05:52]** How do you serve that?
**[00:05:53]** How do you bring that into a single endpoint?
**[00:05:56]** But these are choices that we have.
**[00:05:57]** And so I'm going to talk to some of the
**[00:05:59]** tools that are making those choices easier to make.
**[00:06:04]** So I'll dig into this use case.
**[00:06:06]** One of the main themes of the discussion for for
**[00:06:09]** a gentic coding.
**[00:06:10]** It's a great place to showcase those those choices.
**[00:06:14]** And in this workshop, you can see some of that
**[00:06:15]** because you're going to define different agents for different tasks,
**[00:06:18]** right?
**[00:06:19]** You may have that architecture step.
**[00:06:20]** You need to get that right.
**[00:06:21]** You want to use a larger model for that, probably
**[00:06:24]** even want to push that onto the cloud.
**[00:06:26]** But as I'm doing small iterations, even debugging, maybe small
**[00:06:30]** feature tweaks, that's something that I could do local and
**[00:06:34]** I can offset either cost or mobility to be able
**[00:06:37]** to make that choice and pull those agents locally on
**[00:06:40]** my platform.
**[00:06:41]** So literally, I was playing with this this morning, trying
**[00:06:44]** to see if I could come up with some new
**[00:06:46]** fresh example to show you guys.
**[00:06:48]** And I was walking through, you know, the grounds here,
**[00:06:51]** coding on this laptop and still running jobs, iterating on
**[00:06:55]** features and debugging code not connected to the cloud or
**[00:06:58]** not connected to Wi-Fi.
**[00:07:00]** So that's a choice I have.
**[00:07:01]** I can literally be mobile coding with with these types
**[00:07:04]** of device.
**[00:07:05]** So that was kind of a fun exercise.
**[00:07:08]** And those choices can be dynamic.
**[00:07:10]** So we are quickly moving from static choices.
**[00:07:13]** So if you're setting up those semantic filtering rules, it
**[00:07:16]** could be rule, it could be a static rule, and
**[00:07:18]** now we're moving to more dynamic choicing.
**[00:07:20]** We need to be able to make that routing decision
**[00:07:22]** real time and on the fly.
**[00:07:23]** Could be based on what the resource availability is, or
**[00:07:26]** it could just be some dynamic setting in your workflow,
**[00:07:29]** right?
**[00:07:30]** If you're in a crunch and that bug is not
**[00:07:32]** getting flushed out, OK, it's time to move that off
**[00:07:35]** to a more robust model to be able to solve
**[00:07:38]** that bug and iterate ground that to 0 faster.
**[00:07:42]** So I'm going to showcase some of that in this
**[00:07:45]** example.
**[00:07:46]** While that runs, I'll flip over here quickly to the
**[00:07:51]** interface and bring up.
**[00:07:55]** Yeah, that's good.
**[00:07:58]** OK.
**[00:07:58]** So one of the things we did in our in
**[00:08:00]** our stack, rock EM stack in our tool called lemonade,
**[00:08:04]** Lemonade is the tool that gives us that routing capability,
**[00:08:07]** right?
**[00:08:08]** So it's abstracting away the back end.
**[00:08:10]** You don't have to be Rock EM experts, you don't
**[00:08:12]** have to be HIP experts, You don't have to be
**[00:08:15]** an expert on GP us or NP us or CP
**[00:08:16]** us.
**[00:08:17]** Lemonade is providing that abstraction and the routing capability.
**[00:08:20]** So you're feeding your semantic rules into Lemonade and then
**[00:08:24]** it's making those decisions for you.
**[00:08:27]** If you want to use a more robust semantic router,
**[00:08:30]** this will plug into things like VLLM router, open router
**[00:08:34]** and those tools.
**[00:08:35]** But I found on client, it's nice to be be
**[00:08:37]** able to have something a little bit more lightweight.
**[00:08:40]** I don't necessarily want to install the Docker image here
**[00:08:42]** in my Windows laptop, although I'm perfectly fine doing that
**[00:08:45]** on the cloud.
**[00:08:46]** So Lemonade can also take those rules itself and do
**[00:08:49]** that semantic filtering.
**[00:08:52]** But one of the key aspects of Lemonade, because it's,
**[00:08:54]** it's a little bit lower in the stack, we wanted
**[00:08:56]** to be able to plug into the agentic layer.
**[00:08:58]** So we introduced a new launch feature.
**[00:09:01]** So very easily you can go into Lemonade and ask
**[00:09:04]** it to launch your favorite tool, whether it's, you know,
**[00:09:08]** Codex or Clawed or Gaia or Open Claw, all of
**[00:09:11]** those agentic frameworks, it's fungible at that point.
**[00:09:15]** So now you have these different technologies that can plug
**[00:09:18]** together very easily.
**[00:09:20]** So in launching that, it'll pull up a, a list
**[00:09:24]** of models.
**[00:09:25]** Now the key here Lemonade was, was built as a
**[00:09:28]** client centric technology.
**[00:09:30]** So some of the default choices it's going to pull
**[00:09:33]** up our models that we know will run robustly on
**[00:09:36]** platform.
**[00:09:36]** So any of these choices that I, I select, you
**[00:09:39]** know, will be routed to the local processor.
**[00:09:42]** And depending on the choice of model, Lemonade knows if
**[00:09:45]** that's a GGOF file, will run that on the GPU.
**[00:09:48]** If it's something from our Vitis stack or our fast
**[00:09:51]** flow stack, we know that that model is ready to
**[00:09:53]** run on the NPU.
**[00:09:55]** Anything else can default back to CPU.
**[00:09:57]** So again, a lot of choices here.
**[00:10:00]** I'll show you what I did on the walk over.
**[00:10:03]** It took about 15 minutes, so I'm not going to
**[00:10:05]** run it here.
**[00:10:06]** But the first thing was I just asked it a
**[00:10:08]** simple task, OK, told me a weather dashboard, right?
**[00:10:11]** So it goes off and chewed up about 2020 thousand
**[00:10:14]** tokens, ran into a bunch of bugs and you can
**[00:10:17]** see like all the red space, it's iterating on those
**[00:10:19]** bugs.
**[00:10:20]** And you know, we don't, we know how that works.
**[00:10:22]** That's not really the demo.
**[00:10:25]** The demo is that if you look at the task
**[00:10:27]** manager over here, it's just burning up the local GPU,
**[00:10:30]** right?
**[00:10:31]** The Wi-Fi is silent.
**[00:10:32]** I could turn off the Wi-Fi.
**[00:10:33]** It's not talking to the cloud, and it's doing that
**[00:10:36]** initial planning phase locally on the strict Halo GPU.
**[00:10:41]** The second task is then it's got to go through
**[00:10:43]** and iterate on that debugging, and there I'm making that
**[00:10:46]** choice.
**[00:10:47]** Are we converging?
**[00:10:48]** I'll let it go one cycle.
**[00:10:49]** If it's not going to converge, I'll just flip it
**[00:10:51]** over to the cloud model and let it converge there.
**[00:10:54]** And after all that 50,000 tokens or so, you know,
**[00:10:57]** this is the beautiful weather dashboard it created.
**[00:11:00]** Not particularly impressive.
**[00:11:01]** It's like a blank HTML page with, you know, a
**[00:11:04]** search box.
**[00:11:04]** Enter your city.
**[00:11:06]** So now, now I'm in the feature planning mode.
**[00:11:08]** OK.
**[00:11:08]** I really want a couple graphs.
**[00:11:10]** And, you know, I want to see a sunny, you
**[00:11:12]** know, sunny logo when I'm in San Diego and something
**[00:11:14]** a little little breezier when I'm here in San Francisco.
**[00:11:17]** But that feature iteration I want to do at the
**[00:11:20]** coffee shop, right?
**[00:11:21]** I want to be in a creative space.
**[00:11:22]** I don't want to be at my desk.
**[00:11:23]** I don't want to be in an office space.
**[00:11:25]** I want to use the creative energy in the phase
**[00:11:28]** where I need it.
**[00:11:29]** And so again, I'm going to definitely shift back to
**[00:11:32]** my local laptop so I can do that creative iteration
**[00:11:34]** work there.
**[00:11:36]** So that's one example of what you can do with
**[00:11:38]** this stack.
**[00:11:40]** Let me switch over to this next topic.
**[00:11:51]** Thanks.
**[00:11:52]** OK, so all of this is accessible through these playbooks.
**[00:11:57]** We built out a whole suite of playbooks.
**[00:11:59]** It's full stack, so if you're a kernel developer, you
**[00:12:02]** can go to the playbook and figure out how to
**[00:12:05]** write optimized rock'em kernels.
**[00:12:07]** If you are a comfy UI user and you just
**[00:12:09]** like creating images through an application level interface, there's a
**[00:12:13]** playbook in there for you.
**[00:12:15]** If you want to be a Lemonade powered user and
**[00:12:18]** learn how to integrate that into your own application so
**[00:12:21]** that you can abstract away AMD hardware, have cross-platform capability
**[00:12:25]** to other vendors, Lemonade can do that and we have
**[00:12:28]** a playbook for you.
**[00:12:29]** So I'm going to show you that and do a
**[00:12:31]** quick walkthrough of those so you can see them.
**[00:12:34]** This came live really just a few weeks ago and
**[00:12:37]** it's launched primarily on the client platforms and Radeon GPU
**[00:12:42]** platforms.
**[00:12:43]** And we're quickly expanding this to the new Halo box.
**[00:12:46]** If you stop by our booth, you can see that
**[00:12:48]** that's the appliance PC that I mentioned before and that'll
**[00:12:52]** be launching in June.
**[00:12:54]** And then we're also going to be adding the blueprints
**[00:12:57]** from our Epic server and enterprise use cases as well
**[00:12:59]** as Instinct.
**[00:13:01]** So great place to go.
**[00:13:02]** It's a one stop shop.
**[00:13:03]** So you now have this developer interface.
**[00:13:05]** No matter which device you're targeting and no matter what
**[00:13:09]** type of developer you are, there are some really great
**[00:13:12]** playbooks here to get started.
**[00:13:14]** So if you want to code, you pop in there.
**[00:13:16]** It's basically a recipe to set up all the tools
**[00:13:19]** and the environment.
**[00:13:21]** It's one thing I'm very passionate about with my team.
**[00:13:24]** We just have to make this easier, right?
**[00:13:26]** Even if you're developing on, you know, big scale class
**[00:13:29]** enterprise GPU's, there's no reason this has to be difficult.
**[00:13:33]** Like the user experience here should be uniform, should be
**[00:13:36]** accessible across the product stack.
**[00:13:38]** That's that's really the goal here of these different playbooks.
**[00:13:43]** The other key thing is all those playbooks are open
**[00:13:46]** sourced, so they're sitting out there on a GitHub.
**[00:13:48]** You can go there, you can actually see the ones
**[00:13:50]** that are not released because it's GitHub and that GitHub
**[00:13:53]** project is public.
**[00:13:54]** So you'll go in there and you'll see like a
**[00:13:56]** much, much longer list of some really cool capabilities.
**[00:13:58]** There's a clustering playbook that's coming out where we've taken
**[00:14:01]** a bunch of these strict Halos, although like more like
**[00:14:04]** in a Nook form factor.
**[00:14:05]** Stack those up and we're running very, very large, you
**[00:14:08]** know, 200, three, 100 billion parameter models.
**[00:14:10]** There's a playbook for that.
**[00:14:12]** So very exciting.
**[00:14:13]** I'd I'd steer you over to the GitHub.
**[00:14:17]** So one of those playbooks that I want to run
**[00:14:20]** for you here live is on the Omni modal routing.
**[00:14:28]** So going back to that idea of choice for multi
**[00:14:31]** modality, some of those choices depend on the use case.
**[00:14:35]** So if I'm talking to my application, I need to
**[00:14:37]** route that inference to a specific place and in a
**[00:14:40]** very specific way.
**[00:14:42]** If I am asking it to generate an image, I'm
**[00:14:45]** also going to ask it to route to maybe a
**[00:14:47]** specialized image generation model.
**[00:14:51]** So in this use case, I want to showcase how
**[00:14:53]** that actually works in Lemonade.
**[00:14:56]** Now what Lemonade is, is actually an embeddable DLL that
**[00:14:59]** provides the, I call it the tracks and the switches
**[00:15:02]** to build your applications.
**[00:15:04]** The UI that I'm showing you is essentially it's a
**[00:15:07]** sandbox.
**[00:15:08]** It's it's a demo UI that we built and our
**[00:15:10]** open source community, they're constantly packing features into this.
**[00:15:15]** So we don't necessarily know exactly what's going to show
**[00:15:18]** up in this UI on any given week because the
**[00:15:20]** developers are adding really interesting things today.
**[00:15:23]** I added Mac support a couple months ago.
**[00:15:26]** I think they added NVIDIA support last week.
**[00:15:29]** And we encourage that, right?
**[00:15:30]** Even though this is something a lot of folks at
**[00:15:33]** AMD created and it's in, it's in it's beginning, we
**[00:15:36]** want this to proliferate.
**[00:15:38]** So where the developer community wants to take this, we're
**[00:15:40]** going to let them take that.
**[00:15:41]** We've opened up a BI weekly maintainers meeting.
**[00:15:43]** So that team is meeting and governing what shows up
**[00:15:46]** into this tool.
**[00:15:47]** So let me show you one of the coolest features
**[00:15:50]** that showed up is this Omni modal capability.
**[00:15:53]** The idea here is how do you bring that a
**[00:15:55]** collection of models together that you're going to need for
**[00:15:58]** your application?
**[00:15:59]** So in like a rich media experience where I want
**[00:16:04]** to go and create, you know, you know, draw me
**[00:16:09]** an image of a mountain with a train tunnel.
**[00:16:16]** So, you know, I need an image Gen.
**[00:16:18]** model for that, but I may want to talk to
**[00:16:20]** it.
**[00:16:20]** Also.
**[00:16:21]** I'm not going to do the voice because it's so
**[00:16:23]** noisy.
**[00:16:24]** It's it's not going to work really great right now,
**[00:16:27]** but I may want to interact with it on that,
**[00:16:30]** on that audio level.
**[00:16:31]** I may want it to talk back to me.
**[00:16:33]** If I'm asking it to create a children's book or
**[00:16:35]** a children's story, I want it to speak back and
**[00:16:38]** like tell the story to to my daughter, right as
**[00:16:40]** a as like a fun experience.
**[00:16:43]** So the Omni capability in lemonade is basically pulling together
**[00:16:46]** collections of models and putting the intelligent routing below it.
**[00:16:49]** So it knows based on the context of your query.
**[00:16:53]** If I say draw me a, it knows it needs
**[00:16:55]** to route that to a image Gen.
**[00:16:58]** model.
**[00:16:58]** If I say narrate a story about this, actually, if
**[00:17:03]** I say, you know, edit this to add a steam
**[00:17:07]** locomotive here, it's actually going to create a like a
**[00:17:12]** control net layer on that image Gen.
**[00:17:15]** model so that it can do the image editing.
**[00:17:18]** And now it's recycling that imaging.
**[00:17:19]** And I'll run through a couple of use cases here
**[00:17:22]** live.
**[00:17:22]** My favorite is at the end when we get to
**[00:17:24]** that final image and then it tells me a story
**[00:17:26]** about it because that's like a human experience that is
**[00:17:29]** near and dear to me.
**[00:17:30]** I think it's very cool.
**[00:17:33]** You know, I think I went through an exercise and
**[00:17:35]** said, OK, change it to Thomas the train because you
**[00:17:37]** know, my kid, well, she's 17 now.
**[00:17:39]** In all honesty, like it's not as cool to her,
**[00:17:41]** but it's still a cool use case.
**[00:17:43]** And it's sort of like channels as memories, narrative story
**[00:17:48]** of this scene.
**[00:17:50]** But the main point here is we've have all that
**[00:17:53]** choice at our disposal now.
**[00:17:55]** I didn't have to be an expert to build that.
**[00:17:58]** Like all of that machinery, the routing, the assembly of
**[00:18:01]** that collection, the type of models that are available, whether
**[00:18:05]** they run well on GPUs or Npus, all that's at
**[00:18:08]** my disposal.
**[00:18:10]** So the key technology here that's enabling it is part
**[00:18:13]** of our Rock EM stack.
**[00:18:14]** It's going to be available across our platform.
**[00:18:18]** OK.
**[00:18:18]** So while that runs, I don't know if you'll be
**[00:18:21]** able to hear it.
**[00:18:25]** It's yeah, it's not.
**[00:18:28]** I don't know if it's audios routing, but yeah, it's
**[00:18:30]** it's, you know, it's a really cool experience.
**[00:18:32]** It's it's like in this really like deep, like pensive
**[00:18:35]** voice starts telling a story about this misty mountaintop.
**[00:18:38]** And anyway, just a really fun experience.
**[00:18:42]** Let me talk about one other choice.
**[00:18:44]** I have a few more minutes left and this is
**[00:18:47]** something that we showed yesterday with VLLM router.
**[00:18:51]** VLM router has some very sophisticated semantic filtering and we
**[00:18:56]** can use that, but on the client that's a bit
**[00:18:59]** heavy.
**[00:19:00]** So there are cases where I can use an agentic
**[00:19:03]** layer to pass on those policies and those rules into
**[00:19:06]** that same routing layer and let it make decisions not
**[00:19:10]** just on modality, but on quality or cost or token
**[00:19:13]** usage.
**[00:19:15]** One of the key use cases that I really like
**[00:19:17]** and we showcased yesterday was, you know, I entered my
**[00:19:20]** Social Security number, said hey, this is my Social Security
**[00:19:24]** number, what state was I born in?
**[00:19:26]** And immediately it grabs that and says that's personal information
**[00:19:30]** based on the rules.
**[00:19:31]** We're going to keep that local.
**[00:19:33]** So we're going to answer that question, but we're going
**[00:19:35]** to run it on your local GPUNPU.
**[00:19:37]** And then of course it came back and said that's
**[00:19:39]** a fake Social Security number.
**[00:19:40]** So even the local models are intelligent enough to know,
**[00:19:43]** you know, when I'm, I'm trying to spoof them, if
**[00:19:45]** I give them a phone number, if I give them
**[00:19:48]** my, my name, my place of birth.
**[00:19:50]** And that's just one use case.
**[00:19:51]** Those semantic rules can be set by your use case,
**[00:19:54]** by your agent, by your routing policy based on your
**[00:19:57]** application.
**[00:19:58]** But I think that's a really great use case for
**[00:20:00]** client when we want to keep things local or firewalled.
**[00:20:04]** Another use case is cost, right?
**[00:20:07]** I think you're all in the same boat.
**[00:20:08]** Our company is looking at the cost.
**[00:20:10]** I talked to our IT team and they said, you
**[00:20:13]** know, people are asking a lot of really dumb questions
**[00:20:15]** on our enterprise server.
**[00:20:17]** You know, they're asking like, you know, Yeah.
**[00:20:20]** How many, how many Rs in Strawberry or like, you
**[00:20:22]** know, those types of silly things that we're just trying
**[00:20:25]** to test system or hello, how are you?
**[00:20:27]** And they want to be able to like push those
**[00:20:29]** costs off of the enterprise server because those costs are
**[00:20:32]** significant across our industry, right?
**[00:20:34]** It's, it's the most disruptive aspect of what's going on.
**[00:20:37]** So we can pull that stuff locally.
**[00:20:39]** Let's do silly things local, let's do small tasks local.
**[00:20:42]** It's another semantic rule.
**[00:20:43]** So we showcase that yesterday running on Azure cloud as
**[00:20:46]** one endpoint or strict Halo as the local endpoint.
**[00:20:50]** And that again is infinitely customizable.
**[00:20:53]** We're running on fireworks, we're running on, you know, clod
**[00:20:57]** any remote endpoint.
**[00:21:01]** OK, I just showed you this demo of the collections.
**[00:21:06]** OK, one last set of information about the the cortex
**[00:21:10]** that I was talking about here.
**[00:21:13]** Again, fully open source.
**[00:21:15]** So community is building it, contributing it.
**[00:21:17]** You can go there.
**[00:21:18]** You can see where it's going in the future.
**[00:21:22]** It was really invented down here at the back end.
**[00:21:25]** It's it's many things in the stack, but the back
**[00:21:28]** end is really, if you think about it was a
**[00:21:30]** is a device problem, right?
**[00:21:32]** There's so many devices.
**[00:21:33]** You've got Rock Em, you've got Vulcan, you have Llama,
**[00:21:36]** CBP, we have Vitis.
**[00:21:38]** If you get into the other modalities, you've got Stable
**[00:21:41]** Diffusion, Whisper, CPP.
**[00:21:43]** If you're doing text to speech, you've got Cocoro.
**[00:21:46]** It was really impossible to tie all that together in
**[00:21:49]** a meaningful way, and our developers were taking too long
**[00:21:51]** to get those applications to market.
**[00:21:53]** So this is where it was born.
**[00:21:55]** Make this as simple as possible, as simple as, you
**[00:21:58]** know, a standard API.
**[00:22:00]** So what API do you use there?
**[00:22:02]** Open AI has already solved this problem for us, right?
**[00:22:04]** They've created a standard inference endpoint API.
**[00:22:08]** Everything we do is based on that standard.
**[00:22:11]** So if you're plugging into a standard cloud endpoint, you
**[00:22:14]** can just as easily route that work to your local
**[00:22:17]** PC.
**[00:22:17]** So again, very accessible.
**[00:22:20]** And then moving up, we added a bunch of utility.
**[00:22:22]** If you've got model management and you're creating these collections,
**[00:22:26]** we've got utility for that.
**[00:22:27]** We talked about the router and then the most exciting
**[00:22:30]** work right now is happening on the application space.
**[00:22:34]** So what the community is building when you give them
**[00:22:36]** these tools, it blows my mind.
**[00:22:38]** Every week someone built like an App Store app so
**[00:22:42]** I can talk to my Strix Halo from, you know,
**[00:22:45]** from my phone.
**[00:22:47]** People are adding other vendors for which I think is
**[00:22:49]** great.
**[00:22:51]** People are adding, you know, home, home media hubs, home
**[00:22:54]** assistant hubs, all those use cases which as a technology
**[00:22:57]** company, like we don't necessarily have the time to go
**[00:23:00]** do that unless it's a major market segment.
**[00:23:03]** But the community of developers, they're passionate about it.
**[00:23:06]** A couple weeks ago at the Ubuntu Summit, one of
**[00:23:09]** the chief architects stood up and said, this is my
**[00:23:11]** passion project right now.
**[00:23:13]** I'm just really excited about the work that's happening in
**[00:23:16]** this space and encouraging the community to come in and
**[00:23:19]** just play right and invent.
**[00:23:23]** OK, one shameless marketing plug.
**[00:23:26]** I mentioned this Halo box.
**[00:23:27]** It's not out yet, but this is the future of
**[00:23:30]** what we're doing on Agentic AI.
**[00:23:32]** So there's a number of projects that I'm working on
**[00:23:35]** right now.
**[00:23:36]** This box is, if you go down to our booth,
**[00:23:38]** you can see it right now.
**[00:23:39]** It is the exact same processor that's in these laptops,
**[00:23:42]** but now it's in a form factor that you can
**[00:23:45]** just plug in and it's completely headless.
**[00:23:47]** And we're building up a couple of use cases that
**[00:23:50]** are going to be always on.
**[00:23:51]** So this is your team of agents that's running non-stop
**[00:23:55]** overnight in the morning.
**[00:23:57]** It's scraping all your GitHub issues, it's scraping all your
**[00:24:01]** social media.
**[00:24:02]** It's looking at the competitive landscape.
**[00:24:04]** And when I sit down in the morning, I open
**[00:24:07]** up my Notion dashboard.
**[00:24:08]** All that information's been scraped for me and presented in
**[00:24:12]** A to do list.
**[00:24:13]** So that's the kind of use case that's coming online
**[00:24:15]** with with these new devices.
**[00:24:18]** So yeah, keep an eye open for that.
**[00:24:21]** Come June, that'll be a big announcement.
**[00:24:23]** But if you want to check it out, go go
**[00:24:24]** by the booth.
**[00:24:26]** And then lastly, I-1 last call to action is to
**[00:24:30]** go to the developer portal.
**[00:24:33]** So developer.amd.com, you will see the playbooks, you'll see announcements
**[00:24:38]** about Halo.
**[00:24:39]** You will see a lot of the use cases that
**[00:24:42]** we're building on Lemonade and on the Rock'em Stack workshops,
**[00:24:46]** new events that are coming to here in San Francisco
**[00:24:50]** as well as worldwide.
**[00:24:51]** We just did a, a 4000 developer workshop in Shanghai.
**[00:24:57]** The next one's probably going to be about 10,000 developers.
**[00:25:00]** I mean, this is an area we are heavily investing
**[00:25:02]** in and we want to bring meaningful content.
**[00:25:05]** So hands on workshops, coding workshops, developer workshops.
**[00:25:09]** So this is the place to to, you know, keep
**[00:25:12]** tabs on that, the developer portal.
**[00:25:15]** Yeah.
**[00:25:15]** If you join, you'll get all those notifications.
**[00:25:17]** And then there's a bunch of gibbies for cloud credits.
**[00:25:20]** If you want to get on instinct to do some
**[00:25:22]** more serious development up there.
**[00:25:23]** If you get in the developer program, you can get
**[00:25:26]** credits to go do that work as well.
**[00:25:28]** OK, let me land the plane almost out of time,
**[00:25:30]** but I think we've got some wiggle room for questions.
**[00:25:33]** Yes, one minute.
**[00:25:35]** OK.
**[00:25:36]** And yeah.
**[00:25:37]** What do you got?
**[00:25:37]** Anybody want to dig deeper into some of those topics?
**[00:25:43]** Yep.
**[00:25:45]** June.
**[00:25:45]** It'll be announced in June.
**[00:25:46]** They're out now.
**[00:25:47]** You'll see them, but it'll be launched for for ordering
**[00:25:51]** in June.
**[00:25:55]** I don't know.
**[00:25:57]** Yeah, I don't know.
**[00:25:58]** It's, I mean, the hardware's fundamentally the same, right?
**[00:26:01]** So, yeah, seems about right for the high end.
**[00:26:06]** I mean, I think a lot of that's memory these
**[00:26:09]** days.
**[00:26:10]** When I first bought this laptop, it was about a
**[00:26:12]** lot cheaper than it was today.
**[00:26:15]** Memory cost, which is another cost function, right?
**[00:26:18]** Like if we're thinking about running a small model because
**[00:26:21]** it takes less memory, I have the options to do
**[00:26:23]** that.
**[00:26:25]** Other questions, OK.
**[00:26:30]** All right, folks.
**[00:26:31]** Thanks.
**[00:26:32]** Easy crowd.
**[00:26:32]** Appreciate it.
