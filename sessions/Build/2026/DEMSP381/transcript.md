**[00:00:00]** Thanks for joining everybody.
**[00:00:01]** We had some tech difficulties back on track.
**[00:00:04]** So thanks for coming to our session scaling identity Ki
**[00:00:07]** cost effectively on Azure VMS.
**[00:00:11]** I'll do a quick intro Samir Nori, I'm in the
**[00:00:13]** software and ecosystem team at ARM work closely with different
**[00:00:15]** Microsoft and Azure teams.
**[00:00:17]** So our agenda is we'll talk quickly about the partnerships,
**[00:00:20]** our software ecosystem.
**[00:00:22]** You heard this morning in the keynote about Cobalt 200
**[00:00:25]** VMS being in preview Goa from Microsoft will step through
**[00:00:28]** that.
**[00:00:28]** And then Pranay is going to, you know, you know,
**[00:00:30]** walk through a demo here.
**[00:00:32]** So just a quick intro.
**[00:00:35]** And from an ARM perspective, for those who aren't familiar,
**[00:00:38]** you know, companies been around 30 years, we've shipped close
**[00:00:42]** to 350 billion chips over that time span from a,
**[00:00:45]** you know, company perspective.
**[00:00:48]** And our platform really is the computing platform for all
**[00:00:50]** devices.
**[00:00:51]** And you know, from cloud to edge, right?
**[00:00:53]** In this context, today we're here talking about, you know,
**[00:00:56]** data center and cloud and our partnership with Microsoft and
**[00:00:58]** Azure.
**[00:00:59]** And we have a strong developer community.
**[00:01:01]** You know, as you can see, our partnership and collaboration
**[00:01:05]** with Microsoft really hinges on 2 pillars it's on.
**[00:01:08]** One is the silicon innovation, silicon innovation pillar.
**[00:01:11]** And we work with, you know, the Microsoft hardware and
**[00:01:14]** systems teams on deploying and designing and developing, you know,
**[00:01:17]** the cobalt ship.
**[00:01:19]** There's two generations, the prior generation started off with, you
**[00:01:23]** know better price performance about 50% than the prior Gen.
**[00:01:26]** and Cobalt 200 now is about 50% better than, you
**[00:01:29]** know Cobalt 100 and Gobalt share some stats on in
**[00:01:31]** terms of the different workloads and benchmarks that you know
**[00:01:35]** we have so far.
**[00:01:37]** And then there's software enablement, right.
**[00:01:39]** So when it comes to software enablement, we have about
**[00:01:41]** 22 million developers an arm.
**[00:01:43]** We've been building this ecosystem for about 15 years and
**[00:01:46]** 95% of CNCF projects, you know, support ARM at this
**[00:01:49]** point.
**[00:01:50]** So across the different flavors and categories, you can see
**[00:01:54]** we work with a variety and most of the different
**[00:01:57]** open source packages as well as ISV, you know, software
**[00:02:01]** packages that are enabled and supported on ARM across Linux
**[00:02:04]** operating system, cloud native.
**[00:02:06]** So the CNCF Foundation, AIML and variety of different SAS
**[00:02:10]** and enterprise packages that you know run on ARM.
**[00:02:15]** So hopefully that gives you a flavor for, you know,
**[00:02:18]** the wide software support that's available.
**[00:02:21]** With that, I will turn it over to Goa to
**[00:02:23]** get into some details on Cobalt 200.
**[00:02:25]** Take it away.
**[00:02:26]** Hey everyone.
**[00:02:27]** I'm Goa.
**[00:02:27]** I'm from the ARM product team at Microsoft.
**[00:02:30]** I'm very excited to talk to you today about the
**[00:02:33]** Cobalt 200 VMS.
**[00:02:34]** But before that, let's see what a success story looks
**[00:02:37]** like for Cobalt 100.
**[00:02:38]** We launched Cobalt 102 years ago in 2024 and since
**[00:02:41]** then the response has been tremendous.
**[00:02:44]** We have several customers on enterprise side and the cloud
**[00:02:48]** native side that are interested in onboarding or have already
**[00:02:52]** onboarded onto our VMS and are experiencing very, very nice
**[00:02:56]** price performance benefits that ARM has to offer.
**[00:03:01]** And not just the third party customers, we also have
**[00:03:04]** the first party customers, the ones that you can look
**[00:03:07]** here like for example, Microsoft Teams is running on Azure,
**[00:03:10]** Cobalt 100 and we have Defender which says Cobalt is
**[00:03:14]** their default processor to to drive all their workloads.
**[00:03:17]** So such testaments come from the fact that our price
**[00:03:20]** performance is immense and unmatched compared to other offerings.
**[00:03:28]** Now that that was about Cobalt 100, that's yesterday's story.
**[00:03:31]** Now today Satya announced Cobalt 200 VMS and Cobalt 200
**[00:03:35]** and 100 of course are processors that are in house
**[00:03:38]** built, which means they are custom built, purpose built for
**[00:03:43]** service, service space by Microsoft, which is optimized for Microsoft's
**[00:03:48]** first party workloads and a variety of third party workloads.
**[00:03:52]** And Cobalt 200 VMS come innately supported with Azure Boost.
**[00:03:57]** And as Samir mentioned, the VMS, the per core VM
**[00:04:00]** performance is at least 50% better than the previous generation
**[00:04:05]** Cobalt 200 VMS are Cobalt 200 processor is built on
**[00:04:08]** a three nanometer technology on latest ARM architecture.
**[00:04:15]** Now let's talk about the VMS.
**[00:04:17]** We know the processor is immense and has tremendous per
**[00:04:20]** core benefits, right?
**[00:04:22]** So we want to translate all those benefits to our
**[00:04:24]** customers in terms of virtual machines.
**[00:04:27]** So we not only offer the D and the DP
**[00:04:29]** and the ECDS as per what 100, but we extended
**[00:04:33]** that to the memory optimized version wherein every core gets
**[00:04:37]** about 16 gigabytes of memory and the local local storage,
**[00:04:42]** dense local storage optimized LCDS, VMS for agent AI and
**[00:04:46]** cloud native workloads.
**[00:04:48]** So overall with all of these different VM offerings, we
**[00:04:52]** will be able to fit any, any workload that you
**[00:04:56]** know, an enterprise customer or a cloud native customer can
**[00:05:00]** imagine.
**[00:05:04]** This is something that's more relevant for developers, right?
**[00:05:07]** So what you see here are the benchmarks that we've
**[00:05:11]** tested on our VMS.
**[00:05:13]** So the on the left side you have the industry
**[00:05:16]** benchmarks, the spec and rate where you can see the
**[00:05:19]** comparisons across the board are compared to the previous generation
**[00:05:24]** workloads on a per CP, per vcpu performance basis.
**[00:05:27]** So the industry benchmarks and the Microsoft benchmarks along with
**[00:05:31]** the Microsoft products all speak the same story that we
**[00:05:34]** are much better delivering very high performance compared to our
**[00:05:38]** previous generation.
**[00:05:40]** Microsoft products themselves are a testament to that.
**[00:05:43]** And we run our own first party workloads in, in,
**[00:05:46]** in in addition to referring to our 3P customers.
**[00:05:53]** Lastly, before I hand over to Renee, I want to
**[00:05:56]** talk about what is what is in store for the
**[00:05:59]** future, right?
**[00:06:00]** The future is about agentic AI.
**[00:06:02]** So on the agentic AI front, we see that Cobalt
**[00:06:05]** 1, Cobalt 200 is well suited as it is suited
**[00:06:09]** in the cloud native space, be it sandbox creation, be
**[00:06:13]** it creating a request and doing the entire loop, be
**[00:06:17]** be it fitting as many sandbox agents into AVM Co.
**[00:06:21]** Cobalt 200 excels in all of these fronts and will,
**[00:06:25]** will will provide unmatched price performance benefits.
**[00:06:30]** And with that, I we have the regions we, we
**[00:06:33]** currently have previewed in eight regions, but we are going
**[00:06:37]** to expand those regions at GA And if you have
**[00:06:40]** further questions, I'll hang around, but I'll pass it over
**[00:06:44]** to Pranay for an exciting demo.
**[00:06:46]** Thank you.
**[00:06:46]** Thanks, I'm.
**[00:06:50]** Going to sit down?
**[00:06:54]** Just a quick show of times.
**[00:06:55]** How many of?
**[00:06:57]** You are familiar with, so I'll start there.
**[00:07:05]** So what we are doing here, So what we are
**[00:07:09]** showing is a transition aren't as a company and an
**[00:07:13]** architecture like something in Goa laid out how we transition
**[00:07:17]** or we launch the series for about 100 VMS.
**[00:07:21]** So if you look at cloud native applications or new
**[00:07:24]** additional applications, they had some bit.
**[00:07:26]** Fixed work.
**[00:07:27]** Flows.
**[00:07:28]** You get to from point A to point B, Execute
**[00:07:31]** a few tasks and you are done.
**[00:07:34]** What now we are seeing as an industry is essentially
**[00:07:38]** the applications moving towards an AI first, AI data or
**[00:07:42]** an agentic workflow in built applications where you can essentially
**[00:07:47]** take your applications and move them over to add that
**[00:07:51]** agentic capabilities.
**[00:07:53]** Now what's happening here is essentially in with Cobalt VMS.
**[00:07:58]** They support both those families.
**[00:08:01]** Essentially.
**[00:08:02]** With 100 and with two.
**[00:08:03]** 100 CPS VMS.
**[00:08:04]** That go and might talk about we have these different
**[00:08:08]** workloads supported on these different families so when you.
**[00:08:13]** Think about.
**[00:08:14]** Distributed microservices architecture, meaning your application is spanned across hundreds
**[00:08:19]** of nodes and how you scale that application.
**[00:08:22]** All of that gets converted or covered when you run
**[00:08:25]** this application on Cobalt DS.
**[00:08:29]** For a demo that was a primer.
**[00:08:31]** What we are giving here today is showing a cloud
**[00:08:34]** native application that's running on the.
**[00:08:38]** If you look at some business line, if you look
**[00:08:41]** at the first column which runs a polyglot microservices based
**[00:08:44]** application, it's a shopping cart essentially application where you have
**[00:08:49]** all of your microservices running on 4.100 MPs.
**[00:08:53]** In the second.
**[00:08:54]** On the orchestration.
**[00:08:56]** We are running it on the new work about 200
**[00:08:59]** mills which are much more capable to execute on.
**[00:09:02]** CPU Inferences.
**[00:09:04]** Without need for any other external teams and whatnot, and.
**[00:09:10]** The thought.
**[00:09:11]** Is where we are essentially provisioning multiple ports to solve
**[00:09:15]** those instances.
**[00:09:17]** Requests.
**[00:09:17]** Generated by the application.
**[00:09:20]** One thing all of this is.
**[00:09:22]** Happening and.
**[00:09:24]** Inside that cluster.
**[00:09:26]** So your data is not going outside, you're not talking
**[00:09:30]** to a third party LLM, and everything is local.
**[00:09:33]** And driving.
**[00:09:47]** And the second here are running on the newest 242
**[00:09:50]** years that you heard about it.
**[00:09:53]** You know the application is a shopping meeting container application.
**[00:09:58]** All of this and Infinity is running inside the EPS
**[00:10:02]** customer.
**[00:10:03]** What you see here is what I'm going to do
**[00:10:07]** again.
**[00:10:10]** So if you see here all the.
**[00:10:13]** Boats are.
**[00:10:14]** The Grammy on is 200 processes by V7 is 200
**[00:10:20]** processes and this has a minister which mix for both
**[00:10:28]** 100 and 200.
**[00:10:31]** What we are showing here is.
**[00:10:33]** That shopping.
**[00:10:34]** Application that's entirely on this cluster and it's running across
**[00:10:38]** all these different things, right.
**[00:10:40]** So what I'm doing here you add application can run
**[00:10:46]** that your existing application you can add AI native equations
**[00:10:53]** including inferencing and within the cluster itself.
**[00:10:59]** So what you see here is that the application that's
**[00:11:05]** employed from our AI and now when you go down
**[00:11:10]** and what I've done here is having an orchestrated as
**[00:11:16]** a family of ages that's managing lives everything in CPU.
**[00:11:23]** And so all of these will be able to execute
**[00:11:28]** within the trusted all local now.
**[00:12:08]** None.
**[00:12:18]** What's happening?
**[00:12:40]** And I'm trying to get in shape right.
**[00:12:41]** So what I do is I'm using this chat interface.
**[00:12:44]** I'm going to use this chat interface to see from
**[00:12:50]** where I want to camping here.
**[00:12:54]** But I can give some limits and some categories that
**[00:12:57]** exact items I want from the entire website I don't
**[00:13:01]** want.
**[00:13:09]** I think it's only under $2000 but GCB under $2000
**[00:13:19]** will be exactly 11.
**[00:13:22]** Cash back 199 and make sure that the budget is
**[00:13:26]** $2000.
**[00:13:28]** What's happening here is it's still give me 7 cash.
**[00:13:29]** It gives me $1200 worth.
**[00:13:34]** Taken from here.
**[00:13:35]** I still have around 700.
**[00:13:38]** Now that you see there's a rocket state of service
**[00:13:40]** that's running.
**[00:13:41]** It's routing that traffic to a shopping agent, which is
**[00:13:45]** scanning table, adding, finding those projects, budgeting, which is cutting
**[00:13:52]** into the budget and enabling the agent.
**[00:13:55]** But essentially it's using the list of items that are
**[00:14:01]** different to the budget.
**[00:14:05]** Now I need some shoes.
**[00:14:07]** I need some shoes.
**[00:14:11]** So I will add it.
**[00:14:11]** You can see I was doing A and now if
**[00:14:16]** I see you so look at it, what happened?
**[00:14:21]** It did not give me a list of shoes because
**[00:14:25]** it's one that was ability that simply my needs.
**[00:14:30]** And now I do just Add all of these and
**[00:14:33]** it should show up on my card.
**[00:14:39]** So what happened here is it maintained that context.
**[00:14:42]** So the context was carried over because we are using
**[00:14:45]** the KB cache.
**[00:14:46]** The context was not, it did not go and do
**[00:14:49]** back and forth.
**[00:14:51]** So we see it on the view and because if
**[00:14:53]** you see all those items are added to the again.
**[00:14:57]** Adding.
**[00:14:57]** The card and this is.
**[00:14:59]** Part of.
**[00:15:00]** It but what we do need to focus is all
**[00:15:03]** of this inferencing and these capabilities within all the CPU
**[00:15:07]** and in a local inferencing LLM.
**[00:15:10]** I'm using all 5 core.
**[00:15:12]** Mini model and in phonics runtime to interface with it
**[00:15:16]** and essentially.
**[00:15:18]** Works on CPU.
**[00:15:20]** Inside the APS trust, that's it and maybe going on
**[00:15:25]** the side.
**[00:15:36]** Yeah, these are some labs.
**[00:15:38]** We had a lab.
**[00:15:39]** We are doing a lab at.
**[00:15:41]** 6/30 9:00 and 3:00 tomorrow sign up for the lab.
**[00:15:46]** If you want to talk to us and you want
**[00:15:48]** to do more about the demos, this thumb up and
**[00:15:50]** you can all do it by yourself.
**[00:15:52]** So we'll, we'll talk to you all the different part
**[00:15:55]** during the labs.
**[00:15:59]** And lastly we have this program called ARM Cloud.
**[00:16:02]** Migration where we.
**[00:16:04]** Help our customers and partners.
**[00:16:06]** In their.
**[00:16:07]** Migration journey to R64.
**[00:16:09]** So in case you have this starting your journey or
**[00:16:11]** if you are already well ahead and you want to
**[00:16:14]** do some performance analysis on CPU, we are there to
**[00:16:16]** help this.
**[00:16:17]** Reach out to us with this migrate and we'll be
**[00:16:22]** happy.
**[00:16:23]** What we'll get is the migration resources and CP to
**[00:16:26]** help with your migrations.
**[00:16:29]** You'll also get engineering expertise for experts with that.
**[00:16:37]** Thank you so much for coming.
**[00:16:39]** Thank you.
