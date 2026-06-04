**[00:00:02]** Hey everyone.
**[00:00:04]** We're going to get this session started.
**[00:00:07]** So my name is Dave Citron.
**[00:00:08]** I'm CVP of products at Microsoft AI.
**[00:00:11]** And this is the under the hood session, a 25
**[00:00:14]** minute deep dive in what's actually happening inside the models
**[00:00:19]** that Mustafa announced on stage earlier today.
**[00:00:23]** And if you were watching the keynote and thinking cool
**[00:00:26]** numbers, but how did they actually do that, then this
**[00:00:28]** is the talk for you.
**[00:00:31]** So here's the structure.
**[00:00:32]** We're going to start with the philosophy behind the model
**[00:00:35]** and how we build.
**[00:00:36]** And then we'll talk through all 7 models that we're
**[00:00:39]** shipping.
**[00:00:40]** Then we'll go deep on Mai thinking one, our first
**[00:00:43]** frontier reasoning model, the architecture, the training recipe and the
**[00:00:48]** reinforcement learning system.
**[00:00:50]** And then we'll close with frontier tuning, which you heard
**[00:00:52]** about this morning.
**[00:00:54]** So you can take what we've built and then run
**[00:00:57]** your own hill climbing loop on top of it.
**[00:01:00]** So with that, let's jump in.
**[00:01:04]** OK, so this is what we announced this morning, 7
**[00:01:07]** models across image transcription, voice coding and thinking.
**[00:01:12]** And let me give you a quick map, but we'll
**[00:01:14]** go deep on each one.
**[00:01:16]** So Image 2.5 is our image generation and editing model
**[00:01:20]** now #2 on Ella Marina leader board for image to
**[00:01:24]** image.
**[00:01:26]** And the flash variant of Image 25 brings the quality
**[00:01:29]** to production scale at a third of the cost.
**[00:01:32]** We're really excited about that model.
**[00:01:34]** Transcribe 1.5 is the world's most accurate transcription model across
**[00:01:39]** 43 languages and is five times faster than Arrival models.
**[00:01:45]** Voice 2 is our most natural sounding speech model yet
**[00:01:48]** preferred on 72% of blind listening tests, and the Flash
**[00:01:52]** variant brings it under 150 milliseconds, so it's fantastic for
**[00:01:57]** voice agents.
**[00:01:59]** Code 1 Flash is our efficient coding model, already shipping
**[00:02:03]** as default in GitHub inside of VS Code, so definitely
**[00:02:06]** give that a try.
**[00:02:09]** And it just, it's amazing coding performance at just a
**[00:02:12]** 5 billion active parameter coding model.
**[00:02:15]** And then finally thinking 1 is our first reasoning model,
**[00:02:20]** 97% on Amy 2653 on Sweebench Pro.
**[00:02:24]** So we'll go super deep on how we built that
**[00:02:26]** and again, how you can tune it.
**[00:02:29]** Before we go model by model, I I want to
**[00:02:32]** spend a moment on philosophy because it drives real technical
**[00:02:36]** decisions At our lab.
**[00:02:38]** We call our approach humanist Super intelligence, State-of-the-art AI explicitly
**[00:02:44]** designed to serve people and organizations, not replace them.
**[00:02:49]** And the word humanist is doing real work here.
**[00:02:51]** It's not decorative.
**[00:02:53]** It means three concrete things.
**[00:02:55]** Human first.
**[00:02:56]** The model always prioritizes human well-being.
**[00:03:00]** Serve, not replace.
**[00:03:02]** We build AI that augments what people can do and
**[00:03:05]** platform commitment.
**[00:03:07]** We keep developers at the frontier, and that philosophy has
**[00:03:11]** three concrete implications for how we build.
**[00:03:15]** The most important we don't distill.
**[00:03:18]** Distillation can produce fast gains, transferring a stronger models behavior
**[00:03:22]** into a smaller one.
**[00:03:24]** Lots of labs do it, but it makes the teachers
**[00:03:27]** capability the practical ceiling for the student.
**[00:03:31]** And it wouldn't test whether our own training pipeline can
**[00:03:34]** actually climb from weak initial performance or make progress in
**[00:03:39]** domains where no good teacher exists.
**[00:03:42]** So we hill climb from scratch.
**[00:03:44]** Every capability in these models was earned through our own
**[00:03:47]** training loop, not borrowed.
**[00:03:50]** And that choice also gives us something else.
**[00:03:52]** Full transparency and control.
**[00:03:55]** We know exactly what went into these models.
**[00:03:57]** Clean, commercially licensed data.
**[00:04:00]** No third party weights.
**[00:04:02]** No black box inheritance.
**[00:04:05]** Every component is something we can debug, audit, and improve.
**[00:04:09]** And that's the foundation.
**[00:04:11]** So let's walk through what we actually built.
**[00:04:15]** All right, first up, image 25, number 2 on the
**[00:04:18]** image editing leaderboard surpassing Nano Banana.
**[00:04:22]** That's a real step change from even our previous iterations.
**[00:04:25]** And if you've been following along, we've been iterating here
**[00:04:27]** pretty quickly.
**[00:04:29]** What makes it special is its precision.
**[00:04:31]** When you give it an edit instruction, it executes with
**[00:04:34]** fidelity and consistency that other models struggle with.
**[00:04:38]** Complex compositional edits, changing lighting, adding objects that match the
**[00:04:43]** environment, editing one region while leaving everything else intact.
**[00:04:48]** It handles those super cleanly, and I definitely encourage you
**[00:04:51]** to give us a try on our Mai Playground website.
**[00:04:54]** In fact, you can even do it on your phone.
**[00:04:56]** The flagship 25 model is also optimized for maximum quality,
**[00:05:00]** so it's professional grade output for creative and enterprise work
**[00:05:05]** flows.
**[00:05:06]** It's already live in PowerPoint and rolling out to OneDrive
**[00:05:09]** and also available on Foundry right now.
**[00:05:13]** And the Flash variant brings the same architecture optimized for
**[00:05:16]** high volume production.
**[00:05:18]** So you get more throughput, minimal quality trade off, significantly
**[00:05:22]** lower cost per token.
**[00:05:25]** Next, let's talk about Voice 2.
**[00:05:28]** It's our latest speech generation model, and what sets it
**[00:05:31]** apart is its naturalness.
**[00:05:33]** We went deep on prosody, the rhythm, stress and intonation
**[00:05:37]** that makes speech sound like a person, not a text
**[00:05:41]** to speech engine.
**[00:05:43]** The headline new capability is fine grained emotional control.
**[00:05:47]** You can tune not just what the voice says, but
**[00:05:50]** how it feels.
**[00:05:51]** Warm, urgent, conversational, joyful.
**[00:05:56]** Available today in 15 languages and many more coming soon.
**[00:05:59]** So let's give a listen to what joy sounds like.
**[00:06:08]** And I'm not getting any audio.
**[00:06:10]** Can you hear that?
**[00:06:11]** I don't think so.
**[00:06:14]** There's supposed to be some sound.
**[00:06:15]** Now.
**[00:06:18]** Let me try that again.
**[00:06:20]** I just got the best.
**[00:06:22]** Perfect, perfect, perfect.
**[00:06:23]** OK, let's try it.
**[00:06:24]** I just got the best news ever.
**[00:06:27]** I.
**[00:06:27]** Cannot stop smiling.
**[00:06:29]** Everything I've been working towards has finally paid off and
**[00:06:32]** I I feel like I'm on top of the world
**[00:06:34]** honestly.
**[00:06:35]** This is the happiest I have.
**[00:06:36]** Ever been?
**[00:06:37]** I can't believe how amazing this feels.
**[00:06:39]** I'm so incredibly happy right now all.
**[00:06:44]** Right.
**[00:06:44]** So a little hard to hear, but that's our model.
**[00:06:46]** Yeah, thank you, Thank you.
**[00:06:48]** And I definitely recommend checking it out both on our
**[00:06:51]** website, which has some great examples of the range of
**[00:06:54]** emotions and voices.
**[00:06:55]** And then obviously, whatever you want directly on Mai Playground
**[00:06:59]** or inside a foundry.
**[00:07:01]** And, and one more quick nod to this model.
**[00:07:04]** It does a great job at voice cloning.
**[00:07:07]** So if you just give it a tiny amount of
**[00:07:09]** audio from a real person, it can replicate that voice
**[00:07:11]** with super high fidelity.
**[00:07:13]** And, and all it needs is a, a couple seconds
**[00:07:15]** of the source audio.
**[00:07:18]** And then again, we'll have a flash variant of this
**[00:07:20]** model as well.
**[00:07:21]** And that's particularly designed with voice agents in mind with
**[00:07:24]** incredibly low latency.
**[00:07:26]** And we can't wait to see what you build with
**[00:07:28]** it.
**[00:07:29]** All right, Next up, transcription with Transcribe 1.5.
**[00:07:33]** Transcribe 1.5 is simply the best transcription model in the
**[00:07:36]** world.
**[00:07:37]** Not close.
**[00:07:38]** The best soda accuracy across 43 languages beating Gemini and
**[00:07:42]** Open the Eyes flagship transcription models on head to head
**[00:07:46]** accuracy benchmarks.
**[00:07:48]** But we haven't just optimized for benchmark accuracy.
**[00:07:51]** This model optimizes for real world use, your actual audio,
**[00:07:55]** noisy environments like this one, accents, domain specific terminology, multiple
**[00:08:01]** speakers, you name it.
**[00:08:03]** And on artificial analysis speed benchmarks.
**[00:08:06]** Our model is in a league of its own, up
**[00:08:08]** to 5X faster than rival models and more accurate.
**[00:08:12]** No one else comes close in both dimensions at once
**[00:08:16]** and it's already being integrated across the Microsoft stack from
**[00:08:21]** copilot teams, GitHub Dynamics 365 and it's on foundry now.
**[00:08:26]** It's the fastest, most accurate and most cost effective transcription
**[00:08:29]** model available today.
**[00:08:31]** If you're building anything involving speech to text, this is
**[00:08:34]** your model.
**[00:08:36]** All right, Next up coding code 1 Flash is our
**[00:08:39]** dedicated coding model built from the ground up for a
**[00:08:42]** gentic coding tasks at speed.
**[00:08:45]** The the benchmarks 71.6 on Suebench verified 52 dot or
**[00:08:49]** sorry, 51.2 on Suebench Pro.
**[00:08:52]** And as you know, Suebench Pro is one of the
**[00:08:54]** hardest real world coding benchmarks out there right now, and
**[00:08:57]** it's optimized to be cost effective for high throughput workloads.
**[00:09:01]** And we can't wait to see what you build with
**[00:09:04]** it and to hear your feedback, definitely check it out
**[00:09:06]** in VS Code with GitHub Copilot today.
**[00:09:09]** All right, last but not least, and this is the
**[00:09:11]** model that we're going to go deep on Thinking 1.
**[00:09:14]** Thinking 1 is Microsoft's first reasoning model and the one
**[00:09:18]** we're we're really excited to to give you a peek
**[00:09:21]** under the hood.
**[00:09:22]** So the architecture is mixture of experts, 35 billion active
**[00:09:27]** parameters, about 1 trillion total with a 256 K context
**[00:09:31]** window.
**[00:09:32]** And it punches well above its weight class as you'll
**[00:09:34]** see in some of the benchmark numbers in a few
**[00:09:36]** slides.
**[00:09:37]** And it was hill climbed entirely from scratch.
**[00:09:40]** No distillation, no teacher model, clean, commercially licensed data lineage,
**[00:09:45]** the kind you need when you're shipping to enterprise customers.
**[00:09:49]** So let's jump into how it was built.
**[00:09:53]** Now.
**[00:09:53]** Again, there's a lot of really complex diagrams in the
**[00:09:55]** next few slides.
**[00:09:56]** I just want to give a quick nod to our
**[00:09:59]** tech report we launched on our website this morning.
**[00:10:02]** Over 100 pages, giving you detailed understanding of exactly how
**[00:10:05]** we built this thing from scratch.
**[00:10:08]** So definitely check it out.
**[00:10:09]** But a quick high level of that report.
**[00:10:13]** So there were three principles that govern every decision we
**[00:10:15]** made.
**[00:10:16]** Capabilities should be learned, not inherited.
**[00:10:19]** Simplicity is sustainable and scientific rigor over shortcuts.
**[00:10:25]** So let me make the data story concrete, starting with
**[00:10:27]** what we didn't use, because that's really the harder choice
**[00:10:30]** when you're designing a frontier language model.
**[00:10:33]** No open source training sets, no synthetic data.
**[00:10:37]** We actively haunted down AI generated content on the web
**[00:10:40]** and removed it from our training set, which gets harder
**[00:10:43]** and harder every month and the benchmarks are decontaminated.
**[00:10:47]** The numbers I'm going to show you are real.
**[00:10:50]** What we did use 30 trillion tokens sourced and processed
**[00:10:54]** entirely in house web code, books, papers, multilingual text, domain
**[00:11:00]** specific materials and every pipeline we own end to end.
**[00:11:05]** And then in mid training, another 3.55 trillion tokens of
**[00:11:09]** curated STEM mass coding data, verifiable answers and and code
**[00:11:13]** that either runs or it doesn't.
**[00:11:16]** And this phase extends context to 256 K and sets
**[00:11:19]** us up for the RL climb.
**[00:11:22]** So let's talk about the RL climb.
**[00:11:24]** Reinforcement learning is where the model actually learns to think.
**[00:11:27]** And this is the part I find the most interesting
**[00:11:30]** mechanically.
**[00:11:32]** So the base algorithm is GRPO.
**[00:11:35]** Generate a group of rollouts for a problem, score them
**[00:11:38]** against a verifiable ground truth, and reinforce the better ones.
**[00:11:43]** And for math and code, the reward is binary.
**[00:11:45]** Did you get the right answer?
**[00:11:47]** But running RL for thousands of steps on a model
**[00:11:50]** this size doesn't just work.
**[00:11:51]** And so we built 5 innovations that combined keep the
**[00:11:56]** climb stable across thousands of steps.
**[00:12:00]** The Amy score going from near 0 to 97% in
**[00:12:03]** a steady log linear line is an example of how
**[00:12:06]** all of these techniques come together.
**[00:12:10]** And again, if if you want to read about these
**[00:12:12]** techniques in detail, definitely check out our technical report.
**[00:12:16]** And we also trained 3 specialist models across STEM, agentic
**[00:12:20]** and helpfulness and safety and then merge them together so
**[00:12:23]** we get one model with three areas of mastery.
**[00:12:28]** So let's talk a moment about that safety climb.
**[00:12:31]** Safety isn't a filter bolted on at the end for
**[00:12:33]** this model.
**[00:12:34]** It's an entire dedicated RL climb with a reward model
**[00:12:38]** trained on human preference data.
**[00:12:41]** You cannot trade safety for helpfulness.
**[00:12:43]** It's baked into the math with this design.
**[00:12:46]** Then 15 rounds of red teaming across early, mid, and
**[00:12:50]** late training Microsoft's AI red teaming, plus independent external vendors.
**[00:12:55]** Over 2100 adversarial scenarios.
**[00:12:59]** The result on the safety help on this scatter plot,
**[00:13:02]** which is maybe a little bit hard to see on
**[00:13:04]** this slide, Mai sits above and to the right of
**[00:13:07]** Claude Sonnet 46-ON about five of eight of the categories
**[00:13:11]** and so more helpful and safer at the same time.
**[00:13:16]** OK, so bringing that all together, let's look at what
**[00:13:19]** that produced.
**[00:13:21]** Amy 25 at 97 and Amy 26 at 94.5 S.
**[00:13:25]** These are brand new problems released after our training cut
**[00:13:28]** off.
**[00:13:28]** The model has never seen them live code bench as
**[00:13:32]** 87.7 and again this benchmark continuously adds new problems to
**[00:13:36]** prevent contamination, so it's a genuine measure.
**[00:13:41]** Sui bench pro at 52.8.
**[00:13:43]** Again, real GitHub issues on real code bases.
**[00:13:46]** Competitive with Opus 46 and GPQA Diamond 84.2.
**[00:13:52]** So this is graduate level science questions.
**[00:13:54]** Biology, chemistry and physics without using any search tools.
**[00:13:58]** So this model really understands complex domains and this is
**[00:14:02]** a 35 billion active parameter model.
**[00:14:04]** So it's not the largest, but fully competitive because the
**[00:14:08]** capabilities were learned, not inherited.
**[00:14:12]** And that's Mai thinking one a clean foundation, well designed
**[00:14:16]** climb scientific rigor.
**[00:14:19]** Next, let's talk about how you can tune this model
**[00:14:21]** and make it your own with what you heard about
**[00:14:23]** this morning, Microsoft Frontier Tuning.
**[00:14:27]** So most AI products today ask you to rent a
**[00:14:30]** generic model and hope it works for your business.
**[00:14:33]** And we don't think that's good enough.
**[00:14:35]** Frontier Tuning is how we let every developer and org
**[00:14:39]** build its own hill climbing machine, a model that knows
**[00:14:44]** your work, your language, your data, trained entirely inside your
**[00:14:49]** environment.
**[00:14:51]** And there's really four things that matter for Microsoft Tuning.
**[00:14:55]** It's private, so your data never moves.
**[00:14:57]** It's cost efficient so you're not burning dollars on tokens
**[00:15:01]** you don't need.
**[00:15:02]** And it gets smarter on your actual context.
**[00:15:05]** And you control the model.
**[00:15:07]** No big model lock in, no dependency on anyone's road
**[00:15:10]** map but your own.
**[00:15:13]** And the process for building on top of this is
**[00:15:15]** pretty straightforward.
**[00:15:17]** You define your task and what looks like, what good
**[00:15:20]** looks like for your business.
**[00:15:22]** You bring in your data, your M365 context, your Azure
**[00:15:26]** Fabric context, your work flows, your domain expertise, and then
**[00:15:31]** we run training inside your secure tenant.
**[00:15:34]** You deploy once you're done through either Foundry or Copilot.
**[00:15:38]** It's simple as that.
**[00:15:40]** And then it doesn't stop.
**[00:15:42]** Real usage feeds back into the next training cycle.
**[00:15:46]** The model gets better the more your org uses it.
**[00:15:49]** That's what a hill climbing machine actually means.
**[00:15:52]** It compounds over time against your objectives, not some generic
**[00:15:56]** benchmark.
**[00:15:59]** OK, so here's a real world example that's really exciting
**[00:16:03]** for us.
**[00:16:04]** Land of Lakes needed it to generate product quality reports
**[00:16:08]** from tasting panel discussions, so we Frontier tuned Mai thinking
**[00:16:12]** 1 flash on that specific task and the result?
**[00:16:16]** 89.3% quality score, which is higher than all Frontier models
**[00:16:21]** and 10X more cost efficient.
**[00:16:24]** So higher quality, 10X more efficient.
**[00:16:26]** What could be better than that?
**[00:16:29]** And that's not a small model being a big one
**[00:16:31]** on a toy task.
**[00:16:32]** That's a tuned model beating the best generalists on a
**[00:16:35]** real business workflow at a fraction of the cost.
**[00:16:39]** This is just a taste of what you can achieve
**[00:16:41]** with Microsoft Frontier Tuning, and we're really excited for you
**[00:16:44]** guys to get your hands on it.
**[00:16:48]** All right, so across all of our new models and
**[00:16:51]** Frontier tuning, we can't wait to see what you built.
**[00:16:54]** Image 25, Voice 2, Transcribe 1.5 are all live in
**[00:16:57]** Foundry today and also available to play with on our
**[00:17:01]** Mai Playground website, which again works on your mobile phone.
**[00:17:05]** If you're bored a little bit later tonight, Thinking 1
**[00:17:08]** is live on Foundry as well for a couple of
**[00:17:10]** private preview customers and we'll be expanding it very soon.
**[00:17:13]** And if you're interested in testing it, please sign up
**[00:17:16]** on the Foundry website and code 1 Flash is available
**[00:17:19]** right now in VS Code, so definitely check that out
**[00:17:22]** and send us your feedback.
**[00:17:25]** All of the models will be available also across base
**[00:17:29]** 10 open router and fireworks.
**[00:17:31]** So if you use any of those, you're in luck.
**[00:17:34]** You can learn about all this stuff either on the
**[00:17:37]** Foundry website or Microsoft dot AI, which has everything you
**[00:17:41]** need from model cards to API documentation and also pricing.
**[00:17:47]** So that's it, short and sweet.
**[00:17:49]** Thank you so much for coming.
**[00:17:51]** And the team is here all week and you can
**[00:17:53]** see we have still a couple of sessions left later
**[00:17:56]** tonight and tomorrow.
**[00:17:58]** Definitely swing by the demo booth.
**[00:18:00]** And please send us your feedback either through any of
**[00:18:03]** these social channels.
**[00:18:05]** And please follow us on these as well.
**[00:18:08]** We're just getting started as a lab and we have
**[00:18:10]** much more to come.
**[00:18:11]** So thank you so much.
