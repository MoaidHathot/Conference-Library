**[00:00:01]** All right, Welcome, everyone.
**[00:00:02]** Welcome.
**[00:00:03]** Great to see you all in person as well to
**[00:00:05]** those of you watching online.
**[00:00:07]** So here's the thing.
**[00:00:09]** Agents today, they're no longer confined to a chat box.
**[00:00:12]** They're not waiting for you and I to tell them
**[00:00:14]** what to do.
**[00:00:15]** They're taking action.
**[00:00:16]** They're calling tools.
**[00:00:17]** They're running workflows end to end that are pretty complex,
**[00:00:20]** that would have been almost unimaginable just a few months
**[00:00:23]** ago.
**[00:00:24]** So the problem is this, it's not about capabilities anymore.
**[00:00:27]** Agents are plenty capable, and we're a lot more productive
**[00:00:31]** as a result of that.
**[00:00:32]** Now what we want is we want agents to run
**[00:00:35]** safely and predictably.
**[00:00:36]** And in this session we're going to learn all about
**[00:00:39]** the capabilities Windows is providing to help your agents do
**[00:00:42]** just that.
**[00:00:43]** My name is Krupa.
**[00:00:44]** I'm a product manager on the Windows Platform and Developer
**[00:00:46]** team.
**[00:00:47]** I'm joined by Stuart, an architect also on the Windows
**[00:00:50]** Platform and Developer team, and Patrick, a product manager at
**[00:00:54]** GitHub.
**[00:00:54]** You'll be hearing plenty from Stuart and Patrick throughout this
**[00:00:57]** session.
**[00:00:59]** Now before we go into the technical details, I want
**[00:01:01]** to take a step back.
**[00:01:03]** As you can see from these headlines, the way agents
**[00:01:06]** are being used today, it's not great.
**[00:01:08]** As agents are gaining more capabilities and working with greater
**[00:01:11]** autonomy, they're causing real problems either in the wild or
**[00:01:15]** maybe even within our own organizations.
**[00:01:18]** And if I would generalize, the reason is that we're
**[00:01:22]** moving very quickly from AI that response and answers to
**[00:01:26]** AI that acts with agency.
**[00:01:28]** So when an agent makes a small mistake like sending
**[00:01:31]** an unwanted e-mail or modifying a file or even making
**[00:01:34]** something public it shouldn't, it gets amplified, it creates a
**[00:01:38]** chain reaction.
**[00:01:39]** The blast radius of the damage it causes is much
**[00:01:42]** larger.
**[00:01:42]** Here's a great example where you're using an agent is
**[00:01:45]** doing some coding, deletes your production database.
**[00:01:48]** Not great even in situations where you might have seen
**[00:01:51]** this example hitting your news feeds a short while ago
**[00:01:53]** where the agent is operating on your e-mail, you're telling
**[00:01:57]** it to stop, don't delete it.
**[00:01:58]** Agent acknowledges, go ahead and deletes it anyway.
**[00:02:01]** These are the kinds of examples that we need to
**[00:02:04]** close at a platform layer because when agent can operate
**[00:02:07]** on the things that matter to us, files, code, e-mail,
**[00:02:10]** all the systems you and I rely on, we cannot
**[00:02:13]** rely on the agent to self govern.
**[00:02:15]** We cannot rely on the agent to basically follow good
**[00:02:19]** intentions.
**[00:02:20]** It's even best effort.
**[00:02:21]** Prompting and prompt engineering can't solve this either.
**[00:02:24]** It really requires a more holistic solution.
**[00:02:27]** And also because it's not just the agent itself.
**[00:02:30]** The entire environment the agent operates in is a potential
**[00:02:33]** risk vector.
**[00:02:34]** An agent can be talking to humans, and there's risk
**[00:02:38]** agent to tools, agent to applications, agent to agent, or
**[00:02:41]** even agent to LLM.
**[00:02:43]** All of these are risk vectors and each of them
**[00:02:45]** has a risk profile that we cannot possibly account for,
**[00:02:48]** all from just our own vantage point.
**[00:02:51]** And this is not just a a theoretical problem.
**[00:02:53]** So I'm going to move away from examples and headlines
**[00:02:56]** to something that teams are actively exploring.
**[00:02:59]** And I'm going to turn over to Patrick to talk
**[00:03:01]** about what he and the Copilot team have identified.
**[00:03:04]** Wonderful, thanks Krupa.
**[00:03:07]** At GitHub we get the unique opportunity to see where
**[00:03:10]** modern model performance intersects with user behaviour and how those
**[00:03:14]** trends alter over time.
**[00:03:16]** If you take a look at the copilot CLI, one
**[00:03:18]** of the most common occurrences that happens over time is
**[00:03:21]** users start auto approving, removing the gates and letting their
**[00:03:24]** agents run for longer and longer sessions.
**[00:03:27]** When you scale it up to the copilot SDK, it
**[00:03:30]** rides on top of our copilot CLI server.
**[00:03:33]** But one of the unique differences that we did when
**[00:03:35]** we built the Copilot SDK was designing in a way
**[00:03:38]** that was made for SDK integrators and not for Copilot
**[00:03:41]** CLI users.
**[00:03:42]** What that led to was a mismatch between our permissions
**[00:03:45]** model inside of our SDK and one in our CLI.
**[00:03:48]** Certain integrators expected our SDK to be fully configurable, come
**[00:03:51]** with nothing out-of-the-box already set.
**[00:03:54]** All the CLI users expected it to protect their current
**[00:03:57]** working directory and other artifacts on their system.
**[00:04:01]** When you look a little bit farther into the orchestration
**[00:04:03]** side, our orchestrator inside of the Copilot CLI and SDK
**[00:04:06]** has become much more powerful, especially over the last six
**[00:04:09]** months.
**[00:04:10]** Where jobs typically ran from three to five to 10
**[00:04:13]** minutes or so, they can now run for 30 minutes
**[00:04:15]** or more, which means that the problems in these two
**[00:04:18]** first segments compound exponentially with time, especially as agents get
**[00:04:21]** more and more powerful.
**[00:04:25]** Thank you, Patrick.
**[00:04:26]** So the problem is very clear.
**[00:04:29]** Agents are operating with high agency and they're running with
**[00:04:32]** limited to no guardrails.
**[00:04:33]** Then the question then shifts to what does the platform
**[00:04:36]** need to provide to make agents safe by design?
**[00:04:40]** That's where Windows comes in.
**[00:04:41]** From its very beginning, Windows has always evolved to handle
**[00:04:45]** needs of its users.
**[00:04:46]** The part that's changed is this.
**[00:04:48]** The definition of a user is changing.
**[00:04:50]** What is a user today?
**[00:04:52]** They now include agents acting on their behalf, and that
**[00:04:56]** detail fundamentally changes how Windows and the platform need to
**[00:05:00]** react.
**[00:05:00]** And to account for this, there are three key platform
**[00:05:04]** capabilities that we're introducing that when agents adopt, they can
**[00:05:08]** work with agents as a new type of user and
**[00:05:10]** also ensuring agents can run safely and reliably.
**[00:05:13]** Let's walk through very quickly what these primitives are.
**[00:05:16]** I'm going to go into more detail in a few
**[00:05:18]** moments.
**[00:05:18]** First, it's agent identity.
**[00:05:21]** The agent needs to have an identity distinct from that
**[00:05:24]** of the human user.
**[00:05:25]** Second is containment.
**[00:05:27]** We don't want our agent to have full access to
**[00:05:30]** all the capabilities that our that we have as, as
**[00:05:33]** people.
**[00:05:34]** You know, we can't give it unfair access to all
**[00:05:36]** of our files and all of our data.
**[00:05:38]** What we need is we need to have agents running
**[00:05:40]** in a controlled environment where their blast radius is limited.
**[00:05:44]** And the last one is manageability.
**[00:05:47]** For many of us, that means an IT admin can
**[00:05:49]** deploy, monitor, govern and enforce the policies that dictate what
**[00:05:54]** an agent can do and also what it cannot do.
**[00:05:57]** So to dive deeper into this, starting with identity, I'm
**[00:05:59]** going to turn it over to Stuart.
**[00:06:01]** Great.
**[00:06:02]** Thank you, Krupa.
**[00:06:03]** So as Krupa said, one of the most interesting things
**[00:06:06]** about agents is what is the identity of an agent?
**[00:06:09]** I'm here to tell you, agents aren't you, no matter
**[00:06:13]** what we do today.
**[00:06:14]** The funny thing about where we got to is most
**[00:06:17]** agents run as you, the user.
**[00:06:19]** If you use ACLI, they're running in your session.
**[00:06:22]** They have access to all your data.
**[00:06:24]** The program itself is controlling what they do, but they're
**[00:06:27]** not you.
**[00:06:28]** Imagine what would happen if the agent could get access
**[00:06:31]** to almost anything from you and do whatever it wants.
**[00:06:34]** We need the system to be able to enforce a
**[00:06:37]** separation between an agent and you, and to be able
**[00:06:41]** to enforce the capabilities and promises that define what an
**[00:06:46]** agent is different than what a user is.
**[00:06:49]** In general, what a user is and what they do
**[00:06:51]** on a machine today can have a lot more rights
**[00:06:54]** than some of what we want our agents to be
**[00:06:56]** able to do.
**[00:06:57]** Do you want your agent to be admin on your
**[00:06:59]** machine?
**[00:07:00]** It's a question that you should ask.
**[00:07:02]** So for us, the way we think about it is
**[00:07:04]** this.
**[00:07:04]** Agents are a new type of identity in the system.
**[00:07:07]** When you think about users and devices and applications, we
**[00:07:11]** identify those on the system.
**[00:07:13]** Agents aren't just the processes of the CLI that you're
**[00:07:17]** using or whatever agentic application that you're using.
**[00:07:20]** They themselves are an intrinsic first class entity on the
**[00:07:24]** system.
**[00:07:25]** Just like users, apps and devices.
**[00:07:27]** They need to have a security principle.
**[00:07:30]** We need to be able to make assertions about them,
**[00:07:33]** things that define security permissions that the system itself can
**[00:07:37]** enforce.
**[00:07:38]** We need to be able to author policies that define
**[00:07:41]** what are the things that they are allowed to be
**[00:07:44]** members of, to join, to understand in general what an
**[00:07:48]** agent is allowed to do in the system and whatever
**[00:07:51]** they do needs to be audited by the system.
**[00:07:54]** We need to have logs that show what an agent
**[00:07:56]** does so that we can separate the actions of the
**[00:07:59]** agent from the actions of the user itself.
**[00:08:02]** So with that, we're going to do a quick demonstration
**[00:08:05]** here that will show you we have worked with the
**[00:08:08]** Open Claw team to work on showing how an agent,
**[00:08:11]** like Open Claw, an agentic system, can function in an
**[00:08:15]** operating environment where it is separated from you, the user.
**[00:08:21]** In this demo, what we'll see is this is a
**[00:08:24]** Teams chat, and in Karupa's Teams chat, he will go
**[00:08:28]** in and talk to his Open Clog Gateway node.
**[00:08:32]** The Open Clog Gateway node is running in a separate
**[00:08:35]** session on the same machine, but has a different user
**[00:08:38]** account and in a different session, which means all of
**[00:08:42]** its processes are separated from the desktop, from the windows,
**[00:08:46]** and from all the processes that are here.
**[00:08:48]** And by default, everything that it tries to accomplish has
**[00:08:52]** no access to what Karupa himself is doing.
**[00:08:54]** So as he interacts with the agent, it is fully
**[00:08:57]** separated, fully identified by Windows at its core.
**[00:09:01]** So that is how we look at agent identity.
**[00:09:04]** It is not you, and it should run separated from
**[00:09:07]** you.
**[00:09:07]** How do we so with a after agent identity?
**[00:09:17]** The next thing that we that Krupp introduced was containment.
**[00:09:19]** A really important thing about agents is, is that when
**[00:09:22]** agents operate as Kruppa said, they need a blast radius,
**[00:09:26]** the things that they can accomplish.
**[00:09:28]** What's really important is, is that for us to understand
**[00:09:31]** agents are non deterministic, different than the software that you
**[00:09:35]** run today.
**[00:09:36]** When we install an application at compile time, what the
**[00:09:40]** software can do is already defined.
**[00:09:43]** Our agents today write their own software.
**[00:09:45]** They evolve, they change on a very frequent basis, and
**[00:09:49]** as they operate with agency, they make decisions themselves.
**[00:09:54]** Not your mouse clicks, but the decision of the software
**[00:09:57]** itself.
**[00:09:58]** That non determinism is something that we need to think
**[00:10:01]** about how that happens in the system.
**[00:10:03]** When an agent can choose its own actions at runtime,
**[00:10:06]** that makes it unpredictable.
**[00:10:08]** But because it's unpredictable, it doesn't mean that it's uncontrollable.
**[00:10:12]** It means that what it needs is a boundary around
**[00:10:16]** what it can do, a boundary that's understandable, that we
**[00:10:20]** can understand what it can and cannot do.
**[00:10:23]** That isolation boundary allows us to control risk and to
**[00:10:27]** understand what is the profile of risk that that agent
**[00:10:31]** can have against our system.
**[00:10:34]** Also, what's really interesting is once you put an agent
**[00:10:38]** inside of one of these sandboxes, it allows us to
**[00:10:41]** enforce the design of least privilege, which is we can
**[00:10:45]** take the actions of an agent, it's individual actions, and
**[00:10:48]** put it inside of a sandbox and let that one
**[00:10:51]** sandbox for that one action have policy that defines just
**[00:10:55]** what it can do.
**[00:10:56]** And then when the agent decides to do something else,
**[00:10:59]** we'll build another sandbox for that.
**[00:11:01]** What that means is is that the sandboxes that we're
**[00:11:04]** going to build need to scale.
**[00:11:06]** The isolation boundary needs to be proportionate to the risk
**[00:11:09]** and proportionate to the action that's happening.
**[00:11:12]** For that, we've introduced what we call the Microsoft Execution
**[00:11:16]** Containers Library.
**[00:11:18]** The MXC Library is a library that's designed to help
**[00:11:22]** you create containers based on policy.
**[00:11:25]** The developer and the agent can declare the security requirements
**[00:11:29]** of their agent and the agent's actions.
**[00:11:32]** The library will then compile that together and match that
**[00:11:36]** against the policies of the system and the policies defined
**[00:11:40]** by IT, governed by tools that were used to using
**[00:11:44]** to deploy things to manage them and monitor them.
**[00:11:47]** Once that match has occurred, the MXC library will then
**[00:11:51]** look at the native OS platform and try to assemble
**[00:11:55]** together the right container for the job.
**[00:11:58]** That process is something we call dynamic composition.
**[00:12:03]** That means that when an agent runs, there isn't a
**[00:12:06]** fixed container.
**[00:12:08]** The MXC library allows you to create the container on
**[00:12:12]** the fly.
**[00:12:13]** It will, as I said, take the definition of the
**[00:12:16]** application that you want to run or the actual action.
**[00:12:19]** It will take the user's consent and permissions.
**[00:12:23]** It will take the policy defined by it and try
**[00:12:26]** to from that craft together a configuration of a container.
**[00:12:30]** With that configuration it will then look at the operating
**[00:12:34]** system primitives that are available for it to use.
**[00:12:38]** It's not just Windows, it's Windows, WSL, Linux, a full
**[00:12:43]** cross-platform library that can scale everything from tiny small processes
**[00:12:49]** to VMS, micro VMS, firecracker style micro VMS, all the
**[00:12:54]** way up to cloud based PCs.
**[00:12:56]** So MXC really allows us to define a security boundary
**[00:12:59]** that's designed and proportionate to the task that we want
**[00:13:03]** to accomplish.
**[00:13:05]** So what does that really mean for us as developers?
**[00:13:07]** How do we use this?
**[00:13:09]** Well, let's dive in a little bit deeper.
**[00:13:12]** MXC as I said is a declarative approach.
**[00:13:14]** What is really designed to say is let's look at
**[00:13:17]** the guard rails we want to put in place for
**[00:13:19]** the components of our agent.
**[00:13:21]** What is the composition of the container, what are the
**[00:13:24]** security requirements and what is the workload shape look like.
**[00:13:28]** So as we dig into a little detail, this can
**[00:13:31]** see this is a Python script.
**[00:13:33]** That Python script needs to be able to access my
**[00:13:36]** certificates, certificates to authenticate somewhere in the system.
**[00:13:40]** It needs to be able to run within a certain
**[00:13:43]** time frame.
**[00:13:44]** It can only access read write locations very much specified
**[00:13:48]** by here.
**[00:13:49]** Everything else is denied by default.
**[00:13:52]** What network am I allowed to talk to?
**[00:13:54]** I can only talk to the GitHub API server, and
**[00:13:56]** even more restrictive, I can't touch the UI of anything
**[00:14:00]** else on the system, but I can see the clipboard
**[00:14:03]** and read from it if something has done that.
**[00:14:06]** That allows me to specify with very fine grain detail
**[00:14:10]** what the container is and what the action of the
**[00:14:13]** agent can do.
**[00:14:14]** So let's do a quick demo.
**[00:14:16]** I'm going to escape out of here and do something
**[00:14:19]** really dangerous and bring up a command prompt.
**[00:14:23]** So the first thing I'm going to show you here
**[00:14:25]** is a really simple demo.
**[00:14:27]** This is a where's the?
**[00:14:34]** It's only showing PowerPoint only.
**[00:14:35]** Showing.
**[00:14:38]** That's a problem.
**[00:14:39]** That's great, duplicating the screen page.
**[00:14:47]** Oh, there we go.
**[00:14:47]** Fantastic.
**[00:14:48]** Awesome.
**[00:14:48]** Thank you.
**[00:14:49]** All right, so here is my command prompt.
**[00:14:53]** So from the command prompt, what I'll show you here
**[00:14:56]** quickly is this is essentially that script here I built
**[00:15:00]** for here, a script that will create a PowerPoint file.
**[00:15:04]** That PowerPoint slide will be generated using a Python script.
**[00:15:08]** That Python script will launch and create a Python, sorry,
**[00:15:12]** the PowerPoint file in this build demo folder.
**[00:15:15]** So if I come over here and I will tell
**[00:15:18]** the oops this to run like you'll see here is,
**[00:15:22]** oh, I have a mistake.
**[00:15:24]** It says I can't do it.
**[00:15:26]** The agent is run that script inside of the container.
**[00:15:29]** The container has failed.
**[00:15:30]** Why is it failed?
**[00:15:32]** Because it said access to the build demo folder is
**[00:15:34]** read only.
**[00:15:35]** Let's come in here.
**[00:15:36]** We'll change that quickly and we'll run it again.
**[00:15:46]** And what you see here is this is PowerPoint file
**[00:15:49]** generated by my script.
**[00:15:51]** Awesome.
**[00:15:52]** OK, so that's a simple demo, but the reality of
**[00:15:55]** it is what are we really here for?
**[00:15:57]** We're here to contain an agent that may have written
**[00:16:01]** scripts that aren't perfect.
**[00:16:04]** So what I did here is I created a demo
**[00:16:08]** that shows an agent running and a monitor of the
**[00:16:14]** agent.
**[00:16:15]** This agent is purposefully malicious and will try to escape
**[00:16:19]** its boundaries.
**[00:16:21]** The first thing it's going to do is try to
**[00:16:23]** see if it can get around the file system right
**[00:16:25]** to the the user Sam hive.
**[00:16:26]** See if it can steal into user dot DAT, see
**[00:16:28]** if it can grab the user's credentials.
**[00:16:31]** And what we'll see here is this on the right
**[00:16:32]** hand side.
**[00:16:33]** Those red things are it firing and hitting the boundaries
**[00:16:36]** of the sandbox itself.
**[00:16:38]** So listening to events from the sandbox, we can tell
**[00:16:41]** that the sandbox is in forcing the constraints here.
**[00:16:44]** So this is in live, this running demo pounding against
**[00:16:47]** the sandbox, US listening to that.
**[00:16:50]** What can a developer do with that?
**[00:16:51]** Two things.
**[00:16:52]** One, you can monitor and observe what actually is happening
**[00:16:56]** to the agent 2 If you want to know why
**[00:16:59]** did my agent fail, you can pull that data back
**[00:17:02]** in for the next loop around and understand how to
**[00:17:05]** evolve and make better policy for your agent.
**[00:17:08]** So there's that.
**[00:17:10]** The last thing I want to show you quickly is
**[00:17:12]** this.
**[00:17:12]** As I said before, we have many different sizes and
**[00:17:17]** shapes of containers.
**[00:17:19]** The smallest one is based on a technology we call
**[00:17:22]** Hyperlite.
**[00:17:23]** Hyperlite is a small VMM that will start here, a
**[00:17:27]** container which is a hardware backed virtual machine.
**[00:17:31]** The hardware backed virtual machine runs a tiny operating system
**[00:17:35]** called Nanvix that is about 10 megabytes in size.
**[00:17:39]** It will start up and run that same PowerPoint file
**[00:17:43]** very fast.
**[00:17:46]** Boom.
**[00:17:47]** And if you look, that is the same exact script
**[00:17:50]** of the other side that generated the same PowerPoint file,
**[00:17:54]** loaded incredibly fast in a very small amount of memory
**[00:17:57]** and fully protected by the hypervisor.
**[00:18:01]** So with that, my demos actually succeeded, which is fantastic.
**[00:18:08]** Exactly.
**[00:18:12]** So given all that, as Krupa said, all those things
**[00:18:16]** put together are useful ingredients, but the agent itself still
**[00:18:21]** needs to be managed.
**[00:18:26]** Platform that we operate in needs to make sure that
**[00:18:29]** the management system that we have can guarantee that the
**[00:18:32]** agents are operating within defined policies.
**[00:18:35]** So IT or you, the user, need to be able
**[00:18:38]** to specify what you do and don't allow your agents
**[00:18:41]** to do.
**[00:18:42]** The policies need to be able to control what can
**[00:18:44]** the agent access, what are the actions they are allowed
**[00:18:47]** to do.
**[00:18:47]** And as we showed, how do we observe those actions
**[00:18:50]** to make sure that they are correct?
**[00:18:54]** In general, we also believe that one of the most
**[00:18:56]** important things for you as a developer is to think
**[00:18:59]** about the concept we call supervision, which is that agents
**[00:19:03]** need to operate with clear oversight.
**[00:19:05]** The user needs to understand whether it is a human
**[00:19:09]** in the loop agent or a fully autonomous agent.
**[00:19:12]** They need to be able to trust what it can
**[00:19:14]** do.
**[00:19:15]** The most important thing is that as an agent becomes
**[00:19:18]** more and more autonomous, that trust needs to be something
**[00:19:22]** that we build upon to make sure the user believes
**[00:19:25]** and IT believes they still have operational control.
**[00:19:29]** We think you need to think about how do you
**[00:19:31]** surface the intent of your agent at natural waypoints.
**[00:19:34]** Make sure that even though an agent can do things
**[00:19:37]** fully autonomously, it should still ensure that it's notifying the
**[00:19:42]** user, providing places for it to compensate if there are
**[00:19:45]** problems.
**[00:19:46]** Why?
**[00:19:46]** Because agents make mistakes.
**[00:19:48]** Assume that your agent is not perfect and that you've
**[00:19:51]** defined it in such a way that your agent can
**[00:19:54]** compensate and bring the human user into the loop to
**[00:19:56]** compensate for it.
**[00:19:58]** And make sure that you think of consent as a
**[00:20:01]** continuous thing, not just as Patrick said one time.
**[00:20:04]** You set up this way and it's perfect.
**[00:20:06]** Agents will evolve policy and change and need to keep
**[00:20:10]** asking user why?
**[00:20:11]** Because we are.
**[00:20:13]** Learn autonomy with evidence.
**[00:20:14]** The more that we can build confidence in our users
**[00:20:17]** to trust the things that we do, that's where we'll
**[00:20:20]** build more and stronger and richer autonomous systems.
**[00:20:24]** With that, we believe in Windows.
**[00:20:26]** There's a lot of features that are in the platform
**[00:20:29]** and that we can add that help you use the
**[00:20:31]** surfaces that are there.
**[00:20:32]** The activity that your agent is running under can surface
**[00:20:35]** that using Windows channels.
**[00:20:37]** It can use notifications, It can use many things that
**[00:20:40]** exist there, as well as the guardrails and safety primitives
**[00:20:43]** that we help you show today.
**[00:20:45]** Further, if an agent has its own identity, the Providence
**[00:20:49]** of its code and an audit of what it does
**[00:20:51]** is a natural part of what the OS does.
**[00:20:55]** So with that, I'll turn over to Patrick.
**[00:20:58]** Wonderful.
**[00:21:00]** In the Copilot CLI and SDK, we started all the
**[00:21:03]** way over there.
**[00:21:05]** No sandboxes, no controls, basic guard rails, and the application.
**[00:21:09]** If the user hit the wrong prompt at the wrong
**[00:21:11]** point in time, they ended up in a land where
**[00:21:13]** they could do a lot more damage than they expected.
**[00:21:16]** Today we're happy to announce that the Copilot CLI and
**[00:21:19]** SDK, through our collaboration with the team over at Windows,
**[00:21:22]** we're able to ship a sandbox out of box, which
**[00:21:24]** is currently under the experimental flag.
**[00:21:27]** We'll be moving to GA in the future, so it'll
**[00:21:29]** become a default on solution in the future.
**[00:21:32]** We're moving to a fully isolated state where you'll take
**[00:21:35]** the entire agent to coast, shove it inside of safe
**[00:21:38]** environments, and allow it to execute freely, enabling you to
**[00:21:41]** accomplish a wider range of jobs in to end without
**[00:21:43]** supervising the agent directly or worrying about what it's doing
**[00:21:47]** and where it's going.
**[00:21:50]** So look at this in a more practical sense.
**[00:21:51]** Let's break down a little bit of what Stewart showed
**[00:21:54]** into 3 short little demos inside of the GitHub compiled
**[00:21:58]** CLI.
**[00:21:58]** Like I mentioned, you can actually fire it open today,
**[00:22:01]** and if you've enabled the experimental flag, you will be
**[00:22:04]** able to make sure it's actually running.
**[00:22:09]** Can you play on that one for me?
**[00:22:12]** Perfect.
**[00:22:14]** You will be able to access a slash sandbox, slash
**[00:22:16]** commands, which not only will Navy allow you to turn
**[00:22:18]** it on and off, but as you'll see, you'll have
**[00:22:21]** some quick handy out-of-the-box options that allow you to configure
**[00:22:24]** policy.
**[00:22:25]** You can turn on and off the sandbox.
**[00:22:26]** You can set the file system configuration notice, include working
**[00:22:29]** directories already there, and the policy will clear after it's
**[00:22:32]** done.
**[00:22:33]** If we just enable the file system protections and we
**[00:22:36]** ask the agent to just go off and delete all
**[00:22:38]** the files on our desktop, we probably don't really want
**[00:22:40]** that to happen, but it's a good test for the
**[00:22:43]** agent itself.
**[00:22:44]** We experienced our normal permissions prompt and we said yes,
**[00:22:47]** go delete everything on my desktop, which definitely don't want
**[00:22:49]** that to occur.
**[00:22:50]** I have plenty there.
**[00:22:51]** And you'll notice that's the agents, because it has the
**[00:22:54]** sandbox enabled, it's able to one block the deletion of
**[00:22:57]** all the files in the desktop protection number 12, the
**[00:23:00]** agents able to identify that it's actually operating with the
**[00:23:04]** sandbox on.
**[00:23:04]** So you're aware of what's providing that protection.
**[00:23:07]** And then three, there are some options there and some
**[00:23:10]** next level guidance for what you can do next to
**[00:23:12]** move your way around the sandbox if you need to.
**[00:23:16]** If we look at the next piece, go forward, one
**[00:23:19]** for me over there, perfect.
**[00:23:21]** We go forward to restricting outbound network access.
**[00:23:24]** You have a similar opportunity just off of the file
**[00:23:27]** system and towards the network ingress and egress to your
**[00:23:29]** system.
**[00:23:30]** If you look at the network tab, you can allow
**[00:23:32]** outbound connections, you can allow local network.
**[00:23:34]** They're separate, so you have a couple of different flex
**[00:23:36]** options there.
**[00:23:38]** But the beautiful thing is if you ask the agents
**[00:23:40]** to do something as sketchy and dangerous as turn your
**[00:23:43]** private repository public, which might be company IP, the agent
**[00:23:46]** can actually use those filters to block certain actions and
**[00:23:49]** prevent you from making dangerous calls outside the system.
**[00:23:53]** And while this might seem like a basic demo of
**[00:23:55]** me asking it to do something expecting some guidance, the
**[00:23:59]** thing to be aware of is agents are still exposed
**[00:24:01]** to prompt injection attacks in the modern era.
**[00:24:04]** Which means that any context that enters its world sphere
**[00:24:07]** can actually direct its guidance and force it to accomplish
**[00:24:09]** or take care of actions that you wouldn't necessarily expect
**[00:24:12]** it to.
**[00:24:15]** If we scale this up to the CLI and SDK
**[00:24:18]** perfect, you have an opportunity to leverage all these capabilities
**[00:24:22]** in any application that you integrate our harness into.
**[00:24:26]** And so this is a personal writing app that I
**[00:24:28]** use to hack on the Copilot SDK itself.
**[00:24:31]** I'll go ahead and I'll run a sandbox text.
**[00:24:33]** The way that I actually deploy agents out of here
**[00:24:36]** is I just write like I normally would in a
**[00:24:38]** file and I can just @an agent and it will
**[00:24:40]** deploy it because I'm actually using my AT sandbox agents,
**[00:24:43]** which comes with these policies enabled by default.
**[00:24:46]** What I'm able to do is similar to the first
**[00:24:49]** demo, ask it to delete my desktop files.
**[00:24:52]** The sandbox will block the action, you will see the
**[00:24:55]** calls failing in there, and more importantly you will see
**[00:24:58]** the agent providing its final guidance saying the sandbox blocked
**[00:25:01]** my action, it's preventing me from doing this.
**[00:25:03]** You need to find another way around.
**[00:25:05]** Now in a normal situation I wouldn't want to find
**[00:25:08]** another way around.
**[00:25:09]** I don't want to delete files again on my desktop.
**[00:25:12]** So if we take a simpler, easier to manage a
**[00:25:15]** scenario such as creating a hello dot TXT on my
**[00:25:18]** desktop, I can show you what it's like to build
**[00:25:21]** finer and greater experiences for customers using the SDK.
**[00:25:25]** Again, all of these scenarios are available and you can
**[00:25:28]** think about how you want to integrate them best into
**[00:25:30]** your solution.
**[00:25:31]** What's important about this one is I wanted to create
**[00:25:33]** a file, the sandbox blocked it.
**[00:25:36]** But because this is integrated in the SDK and you
**[00:25:38]** can not only detect when the sandbox is in action,
**[00:25:41]** but you have an opportunity to perform other actions on
**[00:25:44]** behalf of the user, you can simply hit disable the
**[00:25:46]** sandbox, let it continue.
**[00:25:47]** I reviewed the command which allows it to operate freely.
**[00:25:51]** Create the file on the desktop.
**[00:25:53]** It should see this thing minimized in a seconds, and
**[00:25:55]** you'll notice there's a file there allowing you to not
**[00:25:58]** only put the sandbox in place as a great default
**[00:26:00]** out-of-the-box option, but put in user experiences and other controls
**[00:26:04]** that allow users to navigate safely around it when they
**[00:26:06]** run into it and they expect the agent to be
**[00:26:09]** successful.
**[00:26:11]** Thank you, Patrick.
**[00:26:12]** So as part of us building all these platform capabilities,
**[00:26:15]** we actually work very closely with Patrick and to get
**[00:26:17]** a copilot team to design and validate the design.
**[00:26:20]** But we also work very closely with the broader ecosystem
**[00:26:23]** as well with partners like Open AI, Manus, Ermes, NVIDIA
**[00:26:27]** and Open Claw.
**[00:26:28]** Stuart gave a great demo and at the keynote today
**[00:26:31]** he saw more about how Windows primitive or helping Open
**[00:26:34]** Claw run more securely.
**[00:26:37]** So we covered a lot of ground in this talk,
**[00:26:39]** so let me go ahead and summarize the key things
**[00:26:42]** that you need to do to make sure agents run
**[00:26:44]** well on Windows.
**[00:26:45]** 1st, every agent should be running identified, should have its
**[00:26:49]** own identity distinct from that of the human user, with
**[00:26:52]** its own identity, permissions and audit trail.
**[00:26:56]** It should run contained.
**[00:26:57]** Every action runs the right sandbox enforced by policy, and
**[00:27:01]** it also runs managed.
**[00:27:03]** Now this is a topic that's going to require a
**[00:27:05]** lot more coverage, which we will cover in future sessions
**[00:27:08]** and blog posts and videos.
**[00:27:09]** But what we will do is I give up very
**[00:27:11]** high level overview.
**[00:27:12]** You know, at a high level IT admin policies apply
**[00:27:15]** consistently across devices with full enforceability and observability.
**[00:27:20]** Now if we go 1 little deeper, here's an extra
**[00:27:23]** feature you get as part of using MXC to build
**[00:27:26]** your agents.
**[00:27:27]** You get Agent 365 native integration and this enables your
**[00:27:31]** agents running on Windows to start secure and stay secure.
**[00:27:35]** And this also means you get the full ecosystem as
**[00:27:38]** well.
**[00:27:38]** You get Defender, Antra, Intune and preview their protections allow
**[00:27:43]** your security in IT teams to constrain and secure local
**[00:27:47]** agents to make them run more securely in enterprise context.
**[00:27:51]** So that's really like a nice icing on top of
**[00:27:53]** this to take it back to restart it from.
**[00:27:56]** As agents move from answering questions and to taking real
**[00:27:59]** actions, the biggest challenge is ensuring they run well.
**[00:28:03]** Windows gives the foundation to handle that shift.
**[00:28:07]** And Windows isn't just a place where agents can run.
**[00:28:10]** It's a place where they can run reliably, safely, and
**[00:28:14]** at scale.
**[00:28:15]** And with that, if you haven't done so yet, try
**[00:28:18]** MXC right now.
**[00:28:19]** What are you waiting for?
**[00:28:20]** And if you have any questions want talk to us
**[00:28:23]** further about any of these topics, come find Patrick's tonight
**[00:28:26]** at the agentic booth or some of her colleagues who
**[00:28:28]** will be there tomorrow to entertain more about these topics.
**[00:28:32]** Thank you.
