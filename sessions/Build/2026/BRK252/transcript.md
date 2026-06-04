**[00:00:00]** To our session from Observability to ROI for AI agents
**[00:00:04]** on any framework, we're excited to walk you through Microsoft
**[00:00:08]** Foundry Observability.
**[00:00:09]** We'll start with an introduction, but then we'll get right
**[00:00:13]** into a variety of demos that cover the end to
**[00:00:16]** end agent DevOps life cycle, where we'll walk you through
**[00:00:20]** how you can observe any agent on any framework run
**[00:00:24]** through a code.
**[00:00:25]** First, end to end observability, talking about both inner and
**[00:00:29]** outer loop optimization, how you turn traces into action for
**[00:00:33]** continuous improvement, and then finally, how you prove the value
**[00:00:38]** of your genetic workloads through agent ROI.
**[00:00:43]** Now we all know that agents are non deterministic, creating
**[00:00:47]** new reliability and consistency challenges for developers and operators.
**[00:00:52]** This is where observability comes in.
**[00:00:55]** Microsoft Foundry Observability covers 4 core pillars.
**[00:01:00]** Starting with tracing that let you view the full end
**[00:01:03]** to end execution workflow of your agents.
**[00:01:07]** Then going into evaluation which are all run off of
**[00:01:10]** the traces so that you can assess the quality and
**[00:01:13]** safety of your agents.
**[00:01:15]** Transitioning to monitoring, where you can run the same evaluations
**[00:01:19]** that you run offline in an online setting so that
**[00:01:22]** you can detect issues in real time.
**[00:01:25]** And then finally leading to optimization so that you can
**[00:01:28]** continuously improve your agents.
**[00:01:33]** Now Microsoft Foundry provides all of the building blocks that
**[00:01:37]** you can that you need to create reliable and high
**[00:01:40]** quality production agents.
**[00:01:42]** Observability is part of the control plane that spans across
**[00:01:46]** all of the capabilities that you need to build agents,
**[00:01:50]** including our agent service models, IQ for knowledge tools, and
**[00:01:54]** machine learning capabilities such as fine tuning.
**[00:01:59]** What we're going to cover today in this session is
**[00:02:01]** we're going to walk you through the agent DevOps life
**[00:02:04]** cycle.
**[00:02:04]** We're going to show you how traditional DevOps is evolving
**[00:02:09]** for the age of AI agents.
**[00:02:11]** We're going to start with getting started, show you how
**[00:02:14]** you can get out-of-the-box observability, and then we'll transition into
**[00:02:19]** the inner loop where developers plan, code, test, and release
**[00:02:23]** all with observability at their fingertips directly within the IDE.
**[00:02:28]** And then as they transition to the outer loop, they
**[00:02:31]** can leverage the same observability capabilities to monitor their agents,
**[00:02:35]** analyze results and get insights, optimize, and then feed those
**[00:02:38]** signals back into the inner loop for continuous improvement.
**[00:02:43]** Now before that, do we do that?
**[00:02:45]** Let me walk you through our demo scenario.
**[00:02:48]** Our demo scenario builds on the, you know, data center
**[00:02:52]** scenario that you saw in BRK 241, which was the
**[00:02:55]** other session on developing production agents and we have a
**[00:03:00]** vendor history analyst agents for Microsoft's data center operations.
**[00:03:05]** What this agent does is if I'm a vendor manager
**[00:03:08]** and I'm managing vendors that are fixing and addressing issues
**[00:03:12]** in data centers, I want information about how those vendors
**[00:03:15]** are doing so that when I have a conversation with
**[00:03:19]** those vendors, I can have a data-driven your conversation to
**[00:03:22]** get outcomes.
**[00:03:23]** And what this agent does is it summarizes vendor job
**[00:03:27]** history, surfaces, insights, highlights key learnings to help me have
**[00:03:31]** those conversations.
**[00:03:33]** Now in the first part, let's go into the getting
**[00:03:36]** started experience.
**[00:03:37]** Here we'll walk you through how you can get out
**[00:03:40]** of out-of-the-box observability and we'll start with the beginning of
**[00:03:44]** the inner loop, going from plan to code test to
**[00:03:46]** release.
**[00:03:47]** And for that, I would like to welcome Felicia on
**[00:03:50]** stage.
**[00:03:50]** She's going to kick it off with a live demo
**[00:03:53]** to help us get started.
**[00:03:54]** Welcome, Felicia.
**[00:03:56]** Hi, Sebastian and thank you everybody.
**[00:03:58]** I'm so excited to be here to show you the
**[00:04:01]** end to end loop and the especially the the agent
**[00:04:04]** life cycle and the inner to outer loop journey.
**[00:04:07]** So as you have probably seen in one of the
**[00:04:10]** talks that Jeff and Tina did all about how we
**[00:04:13]** deploy A hosted agent and what hosted agents are about,
**[00:04:17]** I'm going to start with an existing hosted agent.
**[00:04:21]** And this is the agent that Sebastian was talking about.
**[00:04:24]** It provides us with details about the vendors and you
**[00:04:27]** know, what are things that they're probably doing.
**[00:04:29]** Is there any investigation or insight that I need about
**[00:04:33]** their work?
**[00:04:34]** So this is the playground that's in our portal.
**[00:04:36]** You can send it a query and see what it
**[00:04:40]** does.
**[00:04:42]** I've sent it a query, the basic query of something
**[00:04:44]** a user might type.
**[00:04:46]** And soon you'll see on the right side that the
**[00:04:49]** logs will start streaming in.
**[00:04:51]** So you know that this has been sent.
**[00:04:53]** Oh.
**[00:04:53]** That's great.
**[00:04:53]** Awesome.
**[00:04:54]** Yeah, and I'm hoping to get some result back to
**[00:04:58]** understand how my agent might actually do in production.
**[00:05:03]** And what's really important is when we start playing with
**[00:05:06]** agents, it's really hard to assess if they're trustworthy, if
**[00:05:10]** they actually have good health.
**[00:05:12]** And I don't always know how well I can do
**[00:05:14]** that.
**[00:05:14]** So how do I do that?
**[00:05:15]** How?
**[00:05:16]** How do I figure out how to evaluate my agent?
**[00:05:19]** Yes.
**[00:05:19]** So evaluation is the keyword over there.
**[00:05:22]** The thing that I wanted to see is can I
**[00:05:24]** set up my agent in a way that I can
**[00:05:26]** evaluate for a bunch of different types of questions that
**[00:05:30]** a user may ask?
**[00:05:30]** So it can cover a wide range of cases.
**[00:05:34]** This agent is thinking for a little bit, but while
**[00:05:37]** it's doing that, what I'm going to do is go
**[00:05:40]** ahead and show you the various ways in which we
**[00:05:43]** can actually do evaluation.
**[00:05:44]** But the one interesting thing I want to demonstrate today
**[00:05:48]** is something that we call a rubric evaluator.
**[00:05:52]** So a rubric evaluator is a really interesting new feature
**[00:05:55]** that we've added to Foundry and it gives you a
**[00:05:58]** multi, a multi dimensional evaluation score.
**[00:06:02]** That's cool.
**[00:06:02]** So I have no data.
**[00:06:04]** How can I, you know, get started?
**[00:06:07]** OK, so that's a good question too.
**[00:06:08]** Let me see if I can actually first start with
**[00:06:11]** the rubric.
**[00:06:12]** I'm going to, I'm going to just show you how
**[00:06:15]** I like fill out this rubric.
**[00:06:16]** So what I'm going to do for this rubric is
**[00:06:19]** I'm going to name it something and suggest that it
**[00:06:21]** be a rubric type.
**[00:06:22]** I'm going to give it the system prompt that my
**[00:06:25]** agent uses, select a model and the target for it
**[00:06:28]** is the hosted agent that I just showed you, and
**[00:06:31]** then I'm going to go generate the rubric.
**[00:06:33]** Oh, this is cool.
**[00:06:33]** So this is where I can add the context that
**[00:06:36]** to go and generate an evaluator that's.
**[00:06:39]** Awesome, yes, so you can always upload and more context
**[00:06:42]** files from your code.
**[00:06:43]** You could obviously do this in code as well and
**[00:06:45]** once this has gone ahead it will create something like
**[00:06:48]** this.
**[00:06:49]** Over here you will see that my rubric is generated
**[00:06:52]** across 8 different dimensions and the whole different weights, and
**[00:06:56]** it's really interesting that it's copilot, not copilot.
**[00:06:59]** Boundary is able to actually do this based on the
**[00:07:03]** prompt and the agent that you have suggested.
**[00:07:05]** So this really simplifies evaluation for me because I can
**[00:07:09]** see everything across a whole set of dimensions, all within
**[00:07:12]** a single evaluator.
**[00:07:13]** That's really cool.
**[00:07:14]** Yes, now I, I want to see how well my
**[00:07:16]** agent did.
**[00:07:17]** So let's go back to my agent.
**[00:07:18]** So it has replied and you can see over here
**[00:07:22]** that it's, it didn't think for 0.0 seconds, but it's
**[00:07:26]** contradictory.
**[00:07:27]** The evidence is they're not sure whether this vendor actually
**[00:07:30]** needs some management from my side or not.
**[00:07:33]** They have a recommendation.
**[00:07:34]** Great.
**[00:07:34]** So this is something that I would want to investigate.
**[00:07:37]** So let's go to the traces over here where you
**[00:07:40]** can see.
**[00:07:41]** Let me pull up the traces of other types of
**[00:07:44]** queries that this agent might have interfaced with so I
**[00:07:48]** know exactly whether there is an issue with the way
**[00:07:52]** it's replying.
**[00:07:53]** Is it actually a good reply or not a good
**[00:07:55]** reply?
**[00:07:56]** You can see that these traces are being run because
**[00:07:58]** we've set up continuous evaluations and jobs.
**[00:08:01]** So it's pulling production traces from App Insights for me,
**[00:08:04]** and I can see all of them represented over here.
**[00:08:07]** And you can also see the evaluator that I had
**[00:08:10]** previously created running against these traces, and it gives me
**[00:08:14]** a score as the traces populate in.
**[00:08:16]** You can see over here that the scores are varied
**[00:08:19]** based on the kind of question the user asks.
**[00:08:22]** Interesting.
**[00:08:23]** You can see one score over here, which is a
**[00:08:25]** little bit low, and I want to investigate that.
**[00:08:27]** So I'm going to just look at that trace and
**[00:08:31]** then click on this trace ID.
**[00:08:33]** And as I open this trace ID, it gives me
**[00:08:37]** this really rich view.
**[00:08:40]** In this view, you can see that when I'm invoking
**[00:08:43]** the agent, I am able to look at the evaluations
**[00:08:46]** against them and OK, I see the detailed view of
**[00:08:49]** the fact that both task completion and the vendor history
**[00:08:53]** rubric score are both low.
**[00:08:55]** Can you click on the user view so that I
**[00:08:57]** can see what actually happened so that I can analyze
**[00:09:00]** the explanation?
**[00:09:01]** So let's look at what this prompt was that generated
**[00:09:04]** this low score.
**[00:09:05]** So it seems like the user asked a very specific
**[00:09:10]** question and it seemed like the agent lacked the exact
**[00:09:15]** data that it was supposed to provide because which was
**[00:09:20]** referenced by the user.
**[00:09:22]** Yeah, yeah, that makes sense.
**[00:09:23]** So it's effectively hallucinating.
**[00:09:25]** It's pretending to say, hey, this vendor's performing well, but
**[00:09:30]** it's not actually giving the correct response with the context
**[00:09:34]** that the user was requesting.
**[00:09:37]** Awesome.
**[00:09:37]** Yeah.
**[00:09:37]** This is very cool, Felicia.
**[00:09:39]** I'd love, love the demo.
**[00:09:41]** We're going to do a quick recap of everything that
**[00:09:44]** we just saw in this demo.
**[00:09:46]** One of the exciting things that we are looking forward
**[00:09:50]** to announcing today is the the open ecosystem support that
**[00:09:54]** Foundry provides.
**[00:09:55]** So what you saw within the tracing experience and the
**[00:09:59]** evals being run off of the traces is a core
**[00:10:01]** part of Foundry's value proposition.
**[00:10:04]** Not only can you evaluate Foundry agents, but you can
**[00:10:07]** also evaluate Foundry and non Foundry agents that are built
**[00:10:11]** with any framework.
**[00:10:13]** So that includes the most popular agent frameworks that are
**[00:10:16]** out there, Lang chain, Land Graph, Open AISDK, Microsoft Agent
**[00:10:21]** Framework and you get complete visibility into the full Asian
**[00:10:25]** execution workflow and eval signals that are produced directly from
**[00:10:29]** from the traces.
**[00:10:31]** Now from there you get full stack observability through Foundries
**[00:10:36]** partnership with Azure Monitor.
**[00:10:38]** Within Foundry.
**[00:10:40]** We give you observability for your apps, agents and all
**[00:10:43]** of the AI platform components.
**[00:10:46]** But then all of that data goes to Azure Monitor
**[00:10:49]** where you can get full stack view across all of
**[00:10:52]** your Azure resources, your data, your infrastructure and so forth.
**[00:10:57]** And then we read that data back into Foundry so
**[00:11:00]** that you have centralized observability for all of your AI
**[00:11:04]** workloads.
**[00:11:06]** The other thing that you saw Felicia present is our
**[00:11:09]** Rubric Evaluator.
**[00:11:10]** We're really excited to announce that the Rubric Evaluator is
**[00:11:14]** now available in public preview.
**[00:11:16]** It gives you out-of-the-box and context specific observability for your
**[00:11:22]** agents.
**[00:11:22]** Whether you're creating a new agent and you have no
**[00:11:26]** data or you have an existing agent that already has
**[00:11:30]** traces, you can use Rubric Evaluator to auto generate a
**[00:11:34]** multi dimensional evaluator and use that both for your offline
**[00:11:39]** testing and for your online evaluation.
**[00:11:44]** Now let's take it one step further and let's move
**[00:11:47]** into the full agent DevOps loop covering both the inner
**[00:11:51]** and outer loop.
**[00:11:53]** We covered a little bit of the getting started experience,
**[00:11:56]** but I'm going to hand back to Felicia again for
**[00:11:59]** the next part of the demo where we'll show you
**[00:12:01]** how you can use our code First, Observability.
**[00:12:05]** Yeah, awesome.
**[00:12:06]** So we were in the portal as you may have
**[00:12:10]** seen and I am now in my editor.
**[00:12:13]** And what I wanted to demonstrate is how we can
**[00:12:16]** use this the Foundry MCP server and the Foundry skill
**[00:12:20]** to better understand, analyze and even do actions on behalf
**[00:12:24]** of Foundry from your developer environment.
**[00:12:28]** So how do I get access to the Foundry MCP?
**[00:12:30]** How does that work?
**[00:12:31]** So the Foundry MCP and the Foundry skill are both
**[00:12:34]** packaged under the Foundry Toolkit which is an extension in
**[00:12:38]** VS Code.
**[00:12:39]** Eventually we will be working with other coding agents and
**[00:12:42]** other editors that you can use it over there, but
**[00:12:44]** today you can go and access it from there.
**[00:12:48]** What I have done right now is just prompted copilot
**[00:12:52]** chat inside VS Code to go and get that eval
**[00:12:55]** result that you saw me hook up earlier on the
**[00:12:58]** portal and to give me some associate explanations of why
**[00:13:03]** you saw that 0.4 that I pulled out from the
**[00:13:06]** traces.
**[00:13:07]** Why is that score showing up low and what are
**[00:13:09]** opportunities for improvement?
**[00:13:11]** Now, the cool part about using the skill is that
**[00:13:14]** a skill is ultimately an opinionated flow that we as
**[00:13:18]** Foundry creators are providing to you as an end user
**[00:13:21]** to say, hey, this is how you should observe and
**[00:13:24]** analyze and perhaps you know, optimize your agent.
**[00:13:28]** This is the loop that we would recommend you do.
**[00:13:30]** So when you use this scale, it already knows what
**[00:13:33]** part of the observably loop you are in and it
**[00:13:37]** can suggest you things that from Foundry or perhaps they
**[00:13:41]** could be like coding, you know, issues.
**[00:13:43]** It could be either a client side thing or a
**[00:13:45]** server side thing.
**[00:13:46]** It helps you connect both those layers to suggest improvements
**[00:13:50]** for your agent.
**[00:13:51]** So.
**[00:13:51]** Yeah, so wait a minute, I don't have to go
**[00:13:53]** through hundreds of traces and eval results anymore.
**[00:13:56]** Yeah, I mean, that's the power of being able to
**[00:13:59]** actually use this skill.
**[00:14:01]** And you can see over here choosing A Foundry MCP
**[00:14:03]** and getting the evals.
**[00:14:05]** And it's it's going to run this entire thing for
**[00:14:09]** me for a little bit.
**[00:14:11]** So what I'm going to do is show you a
**[00:14:13]** run that I did previously over here and here you
**[00:14:17]** can see the exact same query that I just sent
**[00:14:20]** a couple of hours ago.
**[00:14:22]** I was using my project endpoint and it got all
**[00:14:25]** these evaluator.
**[00:14:27]** It ran eval get and it got the evaluator definition
**[00:14:31]** and the last run and all of that and it's
**[00:14:34]** giving me the last 8 hour evaluation analysis and and
**[00:14:37]** here is that entire summary.
**[00:14:40]** Wow, that's cool.
**[00:14:40]** And it's even all of us were trying out this
**[00:14:42]** agent and it's showing all of our evaluation runs.
**[00:14:45]** That's awesome.
**[00:14:45]** Yeah, we're a great team.
**[00:14:47]** It looks like my runs actually didn't do as well
**[00:14:50]** as perhaps Vivex, but that's fine.
**[00:14:54]** So it's it's also giving you a per dimension breakdown,
**[00:14:57]** and it's also telling you which dimension is actually the
**[00:15:01]** weakest.
**[00:15:01]** Oh, that's really cool.
**[00:15:02]** So within the rubric, right, we have a bunch of
**[00:15:05]** different dimensions and being able to drill into the dimension
**[00:15:08]** that that has the low score is a really great
**[00:15:11]** way to get insights.
**[00:15:12]** Yeah, and you know, it's always well and good if
**[00:15:15]** my monitoring tab is showing me some things off, but
**[00:15:18]** what do I actually do about it?
**[00:15:19]** I mean, that's a real challenge.
**[00:15:21]** And over here it's actually giving you a pretty detailed
**[00:15:26]** explanation of what could have gone wrong.
**[00:15:30]** What are the patterns and what are the recommended improvements
**[00:15:33]** over here?
**[00:15:34]** The the other thing that I want to drive home
**[00:15:36]** is that this is something that you can trust more
**[00:15:39]** than obviously just putting that result in a general LLM
**[00:15:41]** because it is grounded first of all, in your repo
**[00:15:44]** context and in the skill context of Foundry.
**[00:15:46]** So it just makes that more actionable and trustable as
**[00:15:49]** you analyze the failure patterns that are coming up.
**[00:15:52]** So Jared's recommending that I can perhaps do a system
**[00:15:55]** prompt change and it tells me reasons for that and
**[00:15:58]** also perhaps how I should change my harness and evaluator
**[00:16:02]** to better do that.
**[00:16:03]** So what I'm going to do is I'm going to
**[00:16:05]** actually say that's what I did.
**[00:16:07]** I said yeah, draft the system prompt and I'm going
**[00:16:09]** to set it off and it's going to come up
**[00:16:11]** with like a new prompt for me.
**[00:16:14]** And it did come up with a new prompt, like
**[00:16:17]** a new system prompt, which oops, I actually deleted that
**[00:16:21]** file earlier.
**[00:16:22]** But what what I can do is I can like
**[00:16:24]** actually set out a new baseline and see if I
**[00:16:27]** actually helps improve the score on the rubric.
**[00:16:31]** Yeah, the cool part is that first one metric definition
**[00:16:33]** block addresses exactly that trace issue that we saw earlier.
**[00:16:36]** But how do I do this at scale?
**[00:16:38]** You know, is there I can do this kind of
**[00:16:40]** one off, but you know what, what can I do
**[00:16:43]** there?
**[00:16:43]** So the cool thing about Foundry and it all being
**[00:16:47]** all in one is that you can actually pull these
**[00:16:50]** traces back into your data set.
**[00:16:53]** And what that helps you do is it helps you
**[00:16:56]** regression prove these things later on.
**[00:16:59]** So if you're just a developer working in your inner
**[00:17:01]** loop, you can run the changes that you may be
**[00:17:04]** locally staging for your agent against that data set and
**[00:17:07]** then push that code to production.
**[00:17:10]** That's awesome.
**[00:17:11]** Really great demo.
**[00:17:12]** Thank you, Felicia.
**[00:17:13]** And we'll do a quick run through again of the
**[00:17:16]** core set of capabilities that we just highlighted, including code
**[00:17:20]** first observability for Foundry agents, which we're super excited about
**[00:17:24]** the skill based guided user experience that you just saw
**[00:17:28]** where you can not only run evaluations, but you can
**[00:17:31]** also analyze the evaluation results.
**[00:17:34]** You can do comparisons across, you can look at traces
**[00:17:37]** and then seamlessly transition to optimization and making improvements to
**[00:17:42]** your agents.
**[00:17:43]** And that's all available in VS Code, GitHub, copilot chat,
**[00:17:46]** CLI and so forth.
**[00:17:48]** There are a number of other additional public preview capabilities
**[00:17:52]** that we're excited to announce including multi turn evaluation, which
**[00:17:57]** is a new capability within the Foundry.
**[00:17:59]** Previously everything was single turn, but now you can look
**[00:18:03]** across an entire session.
**[00:18:05]** Where this is really powerful is an agent might succeed
**[00:18:08]** at the end of the session, but if a session
**[00:18:11]** took 20 minutes, that's not a successful session if you
**[00:18:14]** expect the session to take 5 minutes.
**[00:18:16]** So we can do that with multi turn evaluation.
**[00:18:22]** Another feature that we're shipping that goes along with multi
**[00:18:26]** turn evaluation is user simulation.
**[00:18:28]** User simulation enables you to automatically generate realistic conversations.
**[00:18:33]** So if you don't have multi turn data available to
**[00:18:36]** run your first evaluation, user simulation helps you get started.
**[00:18:41]** And then the other bit is, and Felicia alluded to
**[00:18:45]** this already is.
**[00:18:46]** What do you do with all of the signals that
**[00:18:49]** are generated?
**[00:18:50]** Well, you want to be able to feed traces back
**[00:18:52]** into the inner loop to improve your test coverage.
**[00:18:56]** Your initial test coverage is only going to get you
**[00:18:59]** so far.
**[00:18:59]** If you have 20 test cases, that's not going to
**[00:19:02]** cover everything that you see in production.
**[00:19:04]** So now with traces to data sets and smart filtering
**[00:19:07]** capabilities, you can select traces and feed those back into
**[00:19:11]** your data sets to improve your test coverage in the
**[00:19:15]** inner loop.
**[00:19:17]** Now I'll quickly walk you through our evaluator catalog.
**[00:19:20]** So you also saw this earlier.
**[00:19:21]** We have a very comprehensive evaluator catalog in the foundry
**[00:19:25]** with built in evaluators that span across quality, risk, safety
**[00:19:29]** and agent evaluation.
**[00:19:31]** Several of our evaluators are now multi turn as well,
**[00:19:34]** groundedness, coherence, task completion, customer satisfaction and our rubric evaluators
**[00:19:40]** are also multi turn so that you have the ability
**[00:19:43]** to create, you know both custom LLM as a judge
**[00:19:46]** and code based evaluators and rubric evaluators and make those
**[00:19:50]** multi turn.
**[00:19:52]** We recommend that you use a variety of these evaluators.
**[00:19:55]** Rubric covers obviously multi dimension, but custom evaluators including code
**[00:20:01]** based evaluators especially for non deterministic scenarios are.
**[00:20:06]** Highly recommended.
**[00:20:07]** For example, if you want to do a regex check
**[00:20:09]** or look up something in a database, you can do
**[00:20:11]** that with a code based evaluator.
**[00:20:13]** You don't need an LLM as a judge to do
**[00:20:15]** that.
**[00:20:16]** Now let's move on to the next part of our
**[00:20:19]** session, which is optimization at scale.
**[00:20:22]** So for that I would like to invite Vivek on
**[00:20:25]** stage and he's going to walk us through the next
**[00:20:27]** demo.
**[00:20:28]** Thanks Sebastian.
**[00:20:30]** So happy to be here.
**[00:20:32]** Let me start with a quick recap.
**[00:20:36]** So we started with, we have an agent that's working
**[00:20:39]** well.
**[00:20:39]** It's hosted in Foundry.
**[00:20:41]** We have a set of, we have a data set
**[00:20:42]** which is a list of representative tasks that we want
**[00:20:45]** our agent to be doing.
**[00:20:46]** And we have rubrics which tells us how good it
**[00:20:49]** is on those tasks.
**[00:20:50]** Now what comes next, we know that how good it
**[00:20:53]** is.
**[00:20:53]** We want to still improve it.
**[00:20:54]** We want to fix specific gaps and we want to,
**[00:20:56]** we want that agent to be in general doing well
**[00:20:59]** across all of those tasks.
**[00:21:01]** This is where ACD AI Agent Optimize comes in.
**[00:21:03]** There's a new feature that we're launching and we're going
**[00:21:05]** to see live how it works.
**[00:21:10]** I'm going to start and it starts with a warning.
**[00:21:15]** Optimization will create new versions of your agent, and this
**[00:21:18]** is a key feature that we are just not recommending
**[00:21:21]** with this optimization what your next system prompt should be.
**[00:21:24]** It is also trying out.
**[00:21:26]** It is deploying those versions for your agents, trying across
**[00:21:29]** those tasks and assessing on rubrics and then iterating on
**[00:21:32]** it.
**[00:21:33]** The prompt or the context that works.
**[00:21:35]** It double S down on it, which doesn't work.
**[00:21:37]** It tries another strategy for it.
**[00:21:39]** That's awesome.
**[00:21:39]** So it's, it's real.
**[00:21:41]** It's live.
**[00:21:41]** Yes, it is real and it is iterative.
**[00:21:43]** Yeah.
**[00:21:44]** The next thing is eval dot Yamil.
**[00:21:46]** And just to quickly state we already recapped it.
**[00:21:49]** What I need to get started is, is an agent
**[00:21:52]** that's hosted a data set.
**[00:21:54]** That's my data set that I wanted to be doing.
**[00:21:55]** Well, it's a 40 query data set, an evaluator.
**[00:21:59]** This is my rubrics that Felicia walk through that how
**[00:22:01]** I'm assessing how good that agent is on those tasks
**[00:22:04]** and that's all.
**[00:22:06]** So I'm going to say yes.
**[00:22:07]** For this one.
**[00:22:10]** It's reading my instructions file.
**[00:22:11]** So this is a system prompt that I've given for
**[00:22:13]** my agent.
**[00:22:13]** I want it to be iterating on it.
**[00:22:16]** I can also iterate on skills.
**[00:22:17]** I have not configured skills for this agent, so I'm
**[00:22:19]** not going to say anything here.
**[00:22:21]** It can also iterate on my tool description and parameter
**[00:22:24]** descriptions because that also goes into your agents context and
**[00:22:27]** effect how agents use those tools.
**[00:22:29]** I'm going to want to improve that too.
**[00:22:32]** And there's also one more thing where we can also
**[00:22:35]** iterate on.
**[00:22:36]** If there's a set of models and I'm not sure
**[00:22:38]** which model is great good one for me.
**[00:22:40]** I can specify a list of models here, and it
**[00:22:42]** can recommend the model that's best performing for my agent
**[00:22:45]** on those tasks.
**[00:22:46]** Why is that important?
**[00:22:48]** Yeah, this is one of the things where there are
**[00:22:51]** new models every time.
**[00:22:52]** There are trade-offs between cost, latency, and you need to
**[00:22:55]** be able to run these evaluations multiple times to figure
**[00:22:59]** out what what good this model is.
**[00:23:02]** As a developer, I've done it a lot of times
**[00:23:04]** in a very non streamlined way where I try a
**[00:23:06]** new model and then figure out what it is and
**[00:23:09]** then have to redo on it many, many other tasks.
**[00:23:11]** This one is where I can figure out the best
**[00:23:14]** possible combination of model prompt, tool definition and skills all
**[00:23:18]** together.
**[00:23:19]** Awesome.
**[00:23:21]** So in this one, just to recap, we just, we,
**[00:23:24]** I'm selecting only a model, a system prompt and tool
**[00:23:27]** definitions to be optimised.
**[00:23:30]** This is asking you to select an optimization model.
**[00:23:33]** And this is different from my agent model.
**[00:23:34]** This is a model that's going to be used by
**[00:23:37]** the optimization job to self reflect, to retraces, to read
**[00:23:41]** evaluation rubrics, and then decide what needs to change.
**[00:23:46]** The better model, the better it is.
**[00:23:47]** So even if your agent might be running with a
**[00:23:49]** smaller model, using a better reflection model here really helps.
**[00:23:55]** OK, we have started.
**[00:23:57]** How long is that going to take?
**[00:23:59]** It can take minutes 10s of minutes to.
**[00:24:02]** So I can walk my dog and get coffee.
**[00:24:04]** In the meantime, I have already run this before so
**[00:24:07]** we can jump into it prior run of it.
**[00:24:10]** So this is my agent.
**[00:24:12]** I took the same agent that Felicia had and I
**[00:24:14]** wanted to optimize it.
**[00:24:16]** So this is an in progress job that we just
**[00:24:20]** started, but we can look at the last job that
**[00:24:23]** I've been hill climbing on and first up we got
**[00:24:26]** a 2014% boost over what our based system prompt was.
**[00:24:30]** 2 definitions were with just context engineering, and this one
**[00:24:33]** I didn't have to sit through, read the prompts, read
**[00:24:36]** the traces.
**[00:24:37]** Wow, that's the last time, yes.
**[00:24:41]** And it happened in 25 minutes.
**[00:24:42]** But more importantly, we can walk through it.
**[00:24:45]** It created 4 candidates for me.
**[00:24:48]** The first candidate it suggested a system prompt that made
**[00:24:52]** 38 out of 40 tasks work for me.
**[00:24:55]** Then the next one is System prompt and tools, then
**[00:24:59]** Tools, and then finally a candidate 4 which works all
**[00:25:02]** the time.
**[00:25:02]** 40 out of 40 has increased the baseline score from
**[00:25:07]** .577 to .7.
**[00:25:08]** So it keeps trying new things and then adjusting along
**[00:25:11]** the way.
**[00:25:12]** Yeah.
**[00:25:12]** And that's the beauty of it that it is.
**[00:25:15]** It is figuring out the right thing to change, trying
**[00:25:17]** it out, learning from that and then iterating and then
**[00:25:20]** suggesting the new things.
**[00:25:21]** Awesome.
**[00:25:23]** We can quickly see what what it has changed.
**[00:25:25]** And I'd really love this view that you can see
**[00:25:28]** that the system problem has been changed grounded more on
**[00:25:31]** the traces and your data and your rubrics.
**[00:25:34]** And it has also changed tool definitions.
**[00:25:38]** So the description of the tool has changed.
**[00:25:40]** And we remember earlier that was hallucinating on one of
**[00:25:43]** the vendor details that was not there is exactly those
**[00:25:45]** things that it has addressed here.
**[00:25:49]** That's really cool.
**[00:25:50]** That's awesome.
**[00:25:52]** You can dive deep into this view score details and
**[00:25:55]** you can see your evaluation results.
**[00:25:57]** So this is a real evaluation that has been drawn
**[00:26:00]** for this agent iteration.
**[00:26:01]** And I really like this view where I can, yeah,
**[00:26:05]** I can go and see view details.
**[00:26:08]** I can see for a specific task what this task
**[00:26:11]** is, why it has been scored and also read an
**[00:26:14]** analysis out of it.
**[00:26:15]** So is this a once said and done thing or
**[00:26:18]** what do I?
**[00:26:19]** Yeah, it's not once said and done.
**[00:26:22]** So I've optimized on this 40 task, but my agent
**[00:26:24]** will do many other tasks.
**[00:26:25]** It's a it's a thing where you have to keep
**[00:26:27]** looking at your traces, figuring out what are the right
**[00:26:30]** right set of traces are smart filtering will help there.
**[00:26:33]** And then keep doing this optimization, keep hill climbing for
**[00:26:36]** your agent based on what users are trying.
**[00:26:38]** Domains are changing, model is changing and even your tool
**[00:26:40]** descriptions are tool definition and tool implementations are changing here.
**[00:26:44]** That's awesome.
**[00:26:44]** Thank you, Vivek, for for the fantastic demo and Agent
**[00:26:49]** Optimizer is now in private preview and will public preview
**[00:26:54]** soon.
**[00:26:55]** We're really excited about this feature.
**[00:26:57]** As you saw, it enables you to try different combinations
**[00:27:01]** and then pick the best combination for the job.
**[00:27:04]** You're using evals and running through, you know, those combinations
**[00:27:09]** and then surfacing the results back up to you.
**[00:27:14]** Now let's walk through the final part of the session,
**[00:27:17]** which is you're walking you through how you prove the
**[00:27:21]** value for your agents.
**[00:27:22]** So return on investments for agents in Foundry, this is
**[00:27:27]** the final step.
**[00:27:29]** So once you've you've set up your inner and outer
**[00:27:32]** loop, how do you prove the business value of your
**[00:27:35]** agents?
**[00:27:36]** Well, you have to do math.
**[00:27:38]** You have to figure out whether or not your agents
**[00:27:41]** are generating sufficient value.
**[00:27:43]** It's worth the cost that you're spending on your agent
**[00:27:46]** workloads.
**[00:27:47]** So for that, I'm going to walk you through a
**[00:27:51]** demo and we'll show you the new ROI agent ROI
**[00:27:55]** feature that is in private preview and we'll also public
**[00:28:00]** preview soon.
**[00:28:02]** The way this feature works is it looks at all
**[00:28:06]** of the agent invocations and based on the settings that
**[00:28:10]** you specified.
**[00:28:11]** So you can go to the settings, enable the feature
**[00:28:15]** here you select an evaluator and then you assign a
**[00:28:19]** business value to the evaluator.
**[00:28:21]** Now you have to do the math to figure out
**[00:28:23]** what the business value is.
**[00:28:25]** We don't have that information available, but let's just say,
**[00:28:29]** you know, for this vendor analyst agent, every time this
**[00:28:34]** vendor analyst agent successfully completes its task and gives me
**[00:28:38]** an analysis, that saves me $5 worth of time that
**[00:28:42]** I would have spent running a query or looking up
**[00:28:45]** the information elsewhere.
**[00:28:48]** And that is the business value that's generated by this
**[00:28:52]** agent.
**[00:28:52]** Now from there I can go into optional settings.
**[00:28:55]** And one of the things this feature does is it
**[00:28:58]** automatically pulls in the token cost of your agents and
**[00:29:02]** then you specify the tool cost of your agent.
**[00:29:05]** So that's something again, that we don't, we can't provide.
**[00:29:07]** And you have to sort of average out across your
**[00:29:11]** agent invocations.
**[00:29:12]** But that's the other part of the feature.
**[00:29:15]** And then once enabled, I can track over time the
**[00:29:18]** net value that my agent is generating.
**[00:29:20]** So you can see I have in this case, 3
**[00:29:23]** different versions.
**[00:29:25]** And then over time, I can see the, the difference
**[00:29:28]** between, you know, the value and the cost and the
**[00:29:30]** net value.
**[00:29:32]** And it's interesting because I can see that the tool
**[00:29:35]** calls are actually costing me more than the than the
**[00:29:39]** LLM and you know, that's something that I could potentially
**[00:29:43]** figure out how to optimize.
**[00:29:45]** And then at the bottom, I can also see how
**[00:29:48]** the ROI is changing across versions.
**[00:29:50]** And one of the other features that we'd be providing
**[00:29:54]** as part of this capability is for the ability to
**[00:29:57]** then drill into traces so that you can look at
**[00:30:00]** traces that are low ROI.
**[00:30:02]** To give you a really good example, if you have
**[00:30:05]** an agent invocation that is an agent call that just
**[00:30:09]** doesn't succeed.
**[00:30:10]** That is all negative cost.
**[00:30:13]** That's something that you obviously want to drill into.
**[00:30:16]** You can use, you know, the code first capabilities that
**[00:30:19]** we provide to root cause and analyze what happened.
**[00:30:22]** And so we're very excited about this.
**[00:30:24]** As I mentioned earlier, this is now available in private
**[00:30:28]** preview within the Foundry.
**[00:30:31]** We are going to make this available soon in public
**[00:30:34]** preview as we collect more feedback.
**[00:30:36]** And if it's something that you're interested in, we're more
**[00:30:40]** than happy to talk to your sales team and we
**[00:30:42]** can engage with you and and have you try out
**[00:30:45]** the feature, give us feedback and and so forth.
**[00:30:49]** Now we walked you through your end to end observability
**[00:30:53]** in the Foundry.
**[00:30:54]** We started with you're building reliable agents.
**[00:30:57]** So Felicia showed you how you can you test out
**[00:31:00]** your agents in the playground.
**[00:31:02]** You can then create a rubric evaluator that is context
**[00:31:06]** specific.
**[00:31:06]** You can look at traces to test out the agent
**[00:31:09]** and look at the evaluation scores.
**[00:31:12]** And then we went into the IDE.
**[00:31:15]** We showed you your code first capabilities with Foundry Toolkit
**[00:31:20]** and our Foundry skills so that you can debug it.
**[00:31:24]** Finally, we gave you the ability to optimize and then
**[00:31:28]** you get that sort of broader view with with the
**[00:31:31]** agent ROI feature.
**[00:31:33]** Foundry observability covers broadly all of the capabilities that you
**[00:31:39]** need to ship your agents with confidence giving you tracing,
**[00:31:44]** evaluation, monitoring and optimization.
**[00:31:47]** So we covered on a lot of these features today
**[00:31:50]** and I will just briefly go through and emphasize a
**[00:31:54]** few key capabilities.
**[00:31:55]** For tracing, we continue to invest heavily in open telemetry
**[00:32:00]** as the standard that underpins both tracing and evaluation.
**[00:32:05]** Our engineers are heavily involved in the open source community.
**[00:32:09]** We're contributing new semantics, for example for memory, we just
**[00:32:13]** contributed new semantics for memory that are coming soon into
**[00:32:18]** Foundry.
**[00:32:19]** That is something that Microsoft is committed to as part
**[00:32:22]** of the open source effort.
**[00:32:23]** And then for evaluation, we also have beyond the rubric
**[00:32:27]** evaluator, the built in evaluators that are showed in the
**[00:32:32]** catalog.
**[00:32:33]** We have red teaming agents, CICD integration and so forth
**[00:32:37]** for monitoring.
**[00:32:38]** We also, in addition to running evaluation and production, give
**[00:32:43]** you access to all of the operational metrics that you
**[00:32:47]** need to understand how your AI applications and agents are
**[00:32:51]** performing.
**[00:32:52]** And then finally, for optimization, we have the agent optimizer,
**[00:32:55]** but we also provide single shot optimization.
**[00:32:57]** That's another option that's available for you.
**[00:33:01]** We have a number of customers that are already using
**[00:33:05]** our observability capabilities like Entity Data who are using Foundry
**[00:33:10]** together with Azure Monitor to transform AI into an enterprise
**[00:33:15]** grade production ready system with all of the built in
**[00:33:19]** capabilities that we provide.
**[00:33:21]** We're very excited about this.
**[00:33:22]** We would love for everybody in this room to give
**[00:33:25]** it a try, give us feedback.
**[00:33:27]** We launched a bunch of new capabilities that we're super
**[00:33:29]** excited about to build.
**[00:33:31]** We have a lab where you can get your hands
**[00:33:34]** on sort of experience with a bunch of these capabilities.
**[00:33:38]** You can also take the lab with you.
**[00:33:39]** So that we're excited about as well.
**[00:33:41]** Everything is available online now.
**[00:33:45]** As a reminder, Microsoft provides, you know, all of the
**[00:33:49]** building blocks and the agent for the agent platform.
**[00:33:53]** You can start building in GitHub and then within Foundry
**[00:33:57]** you get all of the capabilities that you need to
**[00:34:00]** be able to run your agents, evaluate and optimize, and
**[00:34:04]** then get all of the, you know, governance capability and
**[00:34:08]** so forth and all the building blocks that you need.
**[00:34:12]** And then finally, you can distribute agents to your users.
**[00:34:15]** RAM 365 Copilot, Teams, apps and APIs.
**[00:34:21]** Now what's next?
**[00:34:23]** We have a bunch of sessions still coming up tomorrow,
**[00:34:27]** so if you missed any of today's sessions, they are
**[00:34:30]** here.
**[00:34:31]** I encourage you to watch the recordings, but tomorrow we
**[00:34:36]** have a breakout session on a 365 that also covers
**[00:34:39]** how your Foundry observability aligns with a 365 S if
**[00:34:44]** you're interested in that topic.
**[00:34:46]** Highly recommend that you attend that session.
**[00:34:48]** We have a demo session that goes into a little
**[00:34:51]** bit more detail on the interoperability story that we just
**[00:34:54]** talked about.
**[00:34:56]** And then we have a lightning talk that covers how
**[00:34:59]** Azure Monitor fits into the picture.
**[00:35:01]** We'd love for you to attend that as well.
**[00:35:04]** Here's a link to all the resources.
**[00:35:07]** Like I said, the lab is going to be public
**[00:35:09]** available, so if you don't have a chance to attend
**[00:35:12]** the lab here, you can get access to that and
**[00:35:15]** we encourage you to start building and we'll take it
**[00:35:18]** from there.
**[00:35:19]** Thank you everybody for attending.
**[00:35:21]** Have a great build.
