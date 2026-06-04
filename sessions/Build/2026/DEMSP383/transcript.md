**[00:00:00]** Hey everyone.
**[00:00:01]** Thank you so much for joining the session.
**[00:00:03]** My name is Vignesh and I am a part of
**[00:00:05]** the applied AI team at Fireworks AI.
**[00:00:08]** I'm going to take you through a small presentation, maybe
**[00:00:11]** like 5 minutes on what Fireworks AI is, what we're
**[00:00:14]** doing, and also how you can use open source models
**[00:00:17]** through Fireworks AI on Foundry and start building out AI
**[00:00:20]** workflows for like different use cases.
**[00:00:23]** So I'm going to go go ahead and get started.
**[00:00:25]** So we are high performance open source inference for open
**[00:00:30]** source models.
**[00:00:31]** We are we have a founding team from Pytorch at
**[00:00:34]** Meta and Vertex at GCP.
**[00:00:36]** We have we have day 0 support for almost all
**[00:00:40]** the major open source providers out there from Kimi to
**[00:00:44]** GLM 5.1.
**[00:00:45]** We serve around 30 trillion tokens per day and 180,000
**[00:00:48]** requests per second.
**[00:00:50]** You also have the option of bringing your own models
**[00:00:53]** to foundry and then deploying them using the fireworks serving
**[00:00:57]** stack.
**[00:00:57]** It's optimized for ultra low latency and we can also
**[00:01:00]** tune it for high throughput to make sure it's production
**[00:01:04]** ready for your work flows and you can use it
**[00:01:06]** to serve your customers.
**[00:01:08]** We are first party Azure integration and you can use
**[00:01:12]** your Mac or build it via Azure.
**[00:01:16]** How the fireworks serving stack itself works.
**[00:01:19]** So it's basically workload aware optimization for like different models
**[00:01:23]** that's available out there.
**[00:01:25]** Once you find an open source model that is up
**[00:01:28]** to mark with your evaluations, then we make sure that
**[00:01:32]** we have we tune different knobs to optimize it for
**[00:01:35]** your specific workload.
**[00:01:37]** You can have adaptive caching, we help you quantize the
**[00:01:40]** model but also have it own serving stack with our
**[00:01:43]** own inference engine called fire retention.
**[00:01:45]** But also choose the right setup of hardware that you
**[00:01:47]** would need to make sure you have like high throughput
**[00:01:50]** or like really low latency across your workload.
**[00:01:52]** So that's what we do.
**[00:01:54]** And then we abstract this and give you an endpoint
**[00:01:58]** that you can start using in production immediately how Fireworks
**[00:02:02]** operates on Microsoft Foundry.
**[00:02:05]** So you would be able to access all the state-of-the-art
**[00:02:09]** open models day zero on Foundry.
**[00:02:11]** We make sure we enable new models as they keep
**[00:02:14]** rolling out.
**[00:02:15]** It's optimized inference for like specific workloads that we spoke
**[00:02:19]** about in the previous slide.
**[00:02:20]** And of course, it's at an enterprise scale.
**[00:02:23]** So you would be able to scale up without any
**[00:02:26]** break in the workflow.
**[00:02:27]** And you can also like bring your own custom models,
**[00:02:30]** bring your own weights after fine tuning, and then upload
**[00:02:33]** it to Foundry to serve inference.
**[00:02:36]** A lot of people right now are really interested in
**[00:02:38]** post training their models.
**[00:02:39]** So how that workflow would work is once you're done
**[00:02:42]** post training the weights, you would register that custom model
**[00:02:45]** in Microsoft Foundry and then you would create a deployment.
**[00:02:49]** And then the inference request would be routed using the
**[00:02:52]** fireworks serving stack.
**[00:02:53]** And that's how you will get optimized inference with your
**[00:02:56]** own custom weights that you bring.
**[00:02:58]** Some of the use cases that we see across the
**[00:03:01]** board are like code completion, code review bots, customized chat
**[00:03:05]** bots, and even like some transcription and summarization use cases.
**[00:03:09]** And a lot of people also like to experiment with
**[00:03:11]** the different open source models.
**[00:03:13]** So you start with some sort of AB testing.
**[00:03:16]** I'm going to show you how you can compare different
**[00:03:18]** open source models through through Foundry.
**[00:03:21]** And then you can pick the best and then create
**[00:03:23]** an agent with that.
**[00:03:24]** And then you can start serving that using the Foundry
**[00:03:26]** endpoints that are being created.
**[00:03:28]** So these are some of the models that are available
**[00:03:32]** right now through Fireworks AI on Foundry.
**[00:03:35]** But we keep adding to the list.
**[00:03:37]** And as more and more models come out, we work
**[00:03:39]** really hard to make sure that we enable them on
**[00:03:42]** day zero so that you can get access to all
**[00:03:44]** the latest models.
**[00:03:45]** So I'm going to switch over to the Microsoft Foundry
**[00:03:48]** page and take you through what a workflow would look
**[00:03:52]** like.
**[00:03:52]** So this would be the landing page when you log
**[00:03:55]** into Foundry.
**[00:03:55]** And then if you go to Discover and you navigate
**[00:03:58]** to the models page, this is where you get all
**[00:04:01]** the different providers that are available on Foundry and the
**[00:04:05]** plethora of models that are available there.
**[00:04:09]** So what I would do is go search here for
**[00:04:11]** fireworks.
**[00:04:12]** So these are all the multi tenant models that are
**[00:04:17]** already enabled.
**[00:04:18]** So the infrastructure is already ready for you to go
**[00:04:21]** and start using.
**[00:04:22]** So what you would have to do is let's say
**[00:04:24]** you want to use a Kimi K 2.6 model and
**[00:04:26]** test it for your particular use case.
**[00:04:29]** I would click on that model and then I would
**[00:04:32]** go to deploy.
**[00:04:34]** So for the next two minutes, I'm going to take
**[00:04:36]** you to the different deployment options that would be available
**[00:04:39]** to you and how you would go about using that
**[00:04:41]** just testing it out.
**[00:04:43]** So they're like different deployment types.
**[00:04:45]** So data data zone standard is basically the multi tenant
**[00:04:49]** serverless endpoint that you would get for you to start
**[00:04:52]** testing Communique 2.6.
**[00:04:54]** So you can set tokens per minute rate limits across
**[00:04:57]** different accounts so that you can manage how much they
**[00:05:00]** can start calling this model and experiment with it.
**[00:05:04]** So this would be one common endpoint across multiple different
**[00:05:08]** users that you can start testing with.
**[00:05:10]** Maybe you just run evals on it and you don't
**[00:05:13]** run a massive production workload on this endpoint.
**[00:05:16]** If you're satisfied with the Kimi mod.
**[00:05:27]** Hello.
**[00:05:28]** Yeah.
**[00:05:28]** OK.
**[00:05:28]** So once your up to mark with your benchmarks and
**[00:05:31]** evaluation looks good on the model and you want to
**[00:05:34]** move to a more dedicated deployment or a single tenant
**[00:05:38]** deployment, that is when you would explore the global provision
**[00:05:42]** throughput or the data zone provision throughput.
**[00:05:45]** So if you click on this option, you can see
**[00:05:48]** there's like a PTU calculation metric that's going to come
**[00:05:51]** through.
**[00:05:52]** So this is going to help you calculate how many
**[00:05:55]** provision throughput throughput units you would need to deploy to
**[00:05:59]** serve your production workload.
**[00:06:01]** So let's say I have input token of 80,000 and
**[00:06:04]** then it's like 500 output tokens that are being generated
**[00:06:08]** and it's going to be like 300 requests per minute
**[00:06:11]** or 3000 requests per minute.
**[00:06:13]** And then I calculate it's going to show that you
**[00:06:16]** need 61,500 Ptus to cover this, this particular deployment.
**[00:06:20]** And then once you Max out the scale, right now
**[00:06:24]** it's up to 1160.
**[00:06:26]** That's all you could go to.
**[00:06:27]** So you would have to make sure that the workload
**[00:06:30]** meets the PTU units calculation.
**[00:06:32]** And then you click on deploy, it's going to create
**[00:06:34]** a single tenant deployment for you.
**[00:06:36]** So before moving on to like a specific dedicated deployment,
**[00:06:40]** you would want to test out how the model is
**[00:06:43]** actually performing for your specific use case.
**[00:06:46]** So in the interest of time, I'm going to switch
**[00:06:49]** over to some models that I've already deployed.
**[00:06:53]** So let's say I have a Kimi 2.5 and a
**[00:06:55]** minimax model already deployed here.
**[00:06:58]** So I'm going to go to the minimax model and
**[00:07:01]** this is opening me up to like a playground where
**[00:07:03]** I can start chatting with the model to see how
**[00:07:06]** it's performing for my use case.
**[00:07:08]** So let's say I have a code review agent and
**[00:07:12]** I want to test out-of-the-box how this particular model is
**[00:07:16]** with identifying specific aspects of a code.
**[00:07:19]** So here I want the model to catch issues with
**[00:07:22]** SQL injections or like hard coded secrets that are already
**[00:07:26]** there.
**[00:07:27]** So you can see there's like the latency is super
**[00:07:30]** quick, you have like a very good response already generated.
**[00:07:34]** So you go through the response, you see if it's
**[00:07:37]** good enough for your particular use case and you also
**[00:07:41]** have the option of pitting 2 models against each other.
**[00:07:44]** So let's say I want to compare this with a
**[00:07:47]** Kimi 2.6 model.
**[00:07:48]** Then I go to the compare models UI and then
**[00:07:52]** I'm going to send the same input again so that
**[00:07:55]** it simultaneously generates output across these two models.
**[00:07:59]** You can see the minimax model is like it does
**[00:08:02]** not have a lot of traffic right now.
**[00:08:04]** So the answer was generated super quickly, whereas the Kimi
**[00:08:08]** model is generating a more detailed answer which involves a
**[00:08:12]** lot of thinking.
**[00:08:13]** It's giving you different options of how you need to
**[00:08:16]** go about deploying this particular code into production.
**[00:08:19]** So depending on how important the different aspects of latency,
**[00:08:23]** quality and how many tokens generated are, you can pick
**[00:08:26]** one of these models and then click on Save as
**[00:08:29]** agent.
**[00:08:30]** So let's say I want to save the minimax model
**[00:08:32]** as an agent.
**[00:08:32]** I click on Save as agent here, or if I
**[00:08:34]** want to click have the Kimi model serving as an
**[00:08:37]** agent, then I would click use Save as an agent
**[00:08:40]** for this particular model.
**[00:08:42]** So I've already deployed some like a code review agent.
**[00:08:46]** So let's say I have a saved agent.
**[00:08:49]** Now I want to run it through some evaluations.
**[00:08:52]** So how would I go about doing that?
**[00:08:55]** So inside the playground you have a matrix Configurator.
**[00:08:59]** So you can use different agents that are already pre
**[00:09:02]** configured inside foundry with your own custom evaluation data sets.
**[00:09:06]** So I want to run it through a set of
**[00:09:09]** 50 rows with for like I want to see if
**[00:09:11]** it's performing well for intent, resolution, coherence, fluency, relevance.
**[00:09:16]** And then I'm I'm going to select those matrix and
**[00:09:19]** then I'm going to click on run full evaluation.
**[00:09:22]** I want to run the evaluation not against just the
**[00:09:24]** model, but my entire agent hardness.
**[00:09:26]** It might include multiple tool calls or you might have
**[00:09:29]** a very detailed system prompt that you've already created the
**[00:09:32]** agent with.
**[00:09:33]** So I want to use the entire hardness to run
**[00:09:35]** my evaluation.
**[00:09:36]** So I'm going to pick the agent and then click
**[00:09:39]** on next.
**[00:09:39]** You have different options.
**[00:09:41]** I'm going to go with the existing data set one
**[00:09:43]** and not the synthetic generation.
**[00:09:45]** I uploaded a code review eval data set.
**[00:09:49]** It's like 50 rows and then it's going to give
**[00:09:52]** you a preview of what it looks like.
**[00:09:54]** What do I have?
**[00:09:54]** I have the ground truth here to make sure that
**[00:09:57]** I can have a comparison with the generated response.
**[00:09:59]** And then you can also use some of the open
**[00:10:02]** source benchmarks that are already there.
**[00:10:04]** This is pre uploaded.
**[00:10:05]** So if it's like a basic coding agent and you
**[00:10:07]** want to send it through some of the benchmarks that
**[00:10:09]** are available, then you can use it.
**[00:10:12]** I'm going to use my data set for this particular
**[00:10:15]** workflow.
**[00:10:16]** And then there is automated field mapping.
**[00:10:19]** I have a GPD Photo Mini as my judge, a
**[00:10:21]** judge model for this particular use case, and I'm just
**[00:10:25]** going to click on next.
**[00:10:26]** And then there's a bunch of auto suggested criteria.
**[00:10:30]** You might not want to evaluate against all of this.
**[00:10:33]** Maybe you just want to do relevance, groundedness and coherence.
**[00:10:36]** So you would just select that and then you click
**[00:10:38]** on next again and then you give it a name
**[00:10:40]** and then you can submit.
**[00:10:41]** So this will ensure that the entire suite of evaluation
**[00:10:45]** that you have is run against all the rows and
**[00:10:48]** you will have percentage like numbers against each metric that
**[00:10:53]** you wanted to evaluate for.
**[00:10:55]** So I have some pre, I already ran some evaluations
**[00:10:59]** I have like a pre-existing run.
**[00:11:01]** So this one was already completed for this particularly for
**[00:11:05]** the code review agent that I had built.
**[00:11:08]** So if you can see task completion is at 90%
**[00:11:10]** task adherence and all of this, you can go through
**[00:11:13]** the metrics and if it's not good, then you tweak
**[00:11:16]** your harness further.
**[00:11:18]** You can go back to the same agent, create multiple
**[00:11:20]** iterations of versions of it and run the evaluation metrics
**[00:11:24]** again until it reach hits your benchmark and you want
**[00:11:26]** to push it to production.
**[00:11:28]** So once you're satisfied with the agent, you have different
**[00:11:33]** ways of publishing it.
**[00:11:34]** You can first take a look at the web app
**[00:11:36]** preview of how it would look like on the front
**[00:11:39]** end if you're choosing to publish through Foundry.
**[00:11:42]** So this is the same agent basically without the playground
**[00:11:46]** and you can send the same prompt here and see
**[00:11:49]** how it's performing.
**[00:11:51]** And if you want to use it as a workflow
**[00:11:54]** in code, then you would go to the call agent
**[00:11:57]** tab and you will have snippets of code available to
**[00:12:01]** you.
**[00:12:01]** You can also either use the project endpoint with your
**[00:12:05]** specific API key for your account and make sure you
**[00:12:08]** can incorporate it in Python workflows that's outside of the
**[00:12:12]** Azure Foundry UI.
**[00:12:14]** So this this is how like an end to end
**[00:12:16]** workflow of deploy, like going from just testing, comparing models
**[00:12:21]** and how you would go about starting to use this
**[00:12:24]** iterated model in like a production workflow looks like so
**[00:12:28]** you can test out the web UI, you can take
**[00:12:31]** the code snippet and start using it in Python workflows
**[00:12:35]** offline.
**[00:12:36]** So this would how like fireworks AI on foundry function.
**[00:12:40]** And this is how intuitive and easy it would be
**[00:12:43]** to use open source models.
**[00:12:44]** Now let's say you're you're still not happy with the
**[00:12:48]** quality of the out-of-the-box open source models and you want
**[00:12:51]** to move to a more fine grained workflow of doing
**[00:12:54]** some sort of post training.
**[00:12:56]** That's when the bring your own weights come into play.
**[00:13:00]** So you would take the base model as is and
**[00:13:03]** you can use any fine tuning framework available outside of
**[00:13:07]** Foundry or on Foundry.
**[00:13:08]** And we, we also the Fireworks AI native platform also
**[00:13:12]** supports fine tuning.
**[00:13:14]** You can go there, use one of our SFT or
**[00:13:16]** RFT frameworks that are available, tune the models and upload
**[00:13:19]** those weights and go through the same workflow that I
**[00:13:21]** just showed you to make sure you can serve inference
**[00:13:24]** on open source models using the Fireworks tech stack.
**[00:13:27]** So this was a very quick way of showing how
**[00:13:29]** you can use Fireworks AI on Foundry, and I'm happy
**[00:13:32]** to answer any questions if you have anything else that
**[00:13:36]** you would like to see on Foundry itself.
**[00:13:38]** So thank you for stopping by and this was great.
**[00:13:41]** Thank you for listening.
**[00:13:58]** Amazing.
**[00:13:59]** Thank you so much Manesh for the amazing demo session.
**[00:14:03]** Thank you so much everyone for being here and attending
**[00:14:07]** the amazing session.
**[00:14:09]** Just want to do some program announcement.
**[00:14:12]** We are going to also have a next session coming
**[00:14:15]** up really quickly.
**[00:14:16]** So if you are wanting to go to the next
**[00:14:19]** session, please hang tight, stay seated.
**[00:14:22]** If not, have a great day.
**[00:14:24]** Thank you so much for being here today.
