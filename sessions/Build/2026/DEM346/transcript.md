**[00:00:01]** Hey everyone, I'm Pooja Trivedi.
**[00:00:03]** I'm an architect leading developer experiences in AI for Linux
**[00:00:07]** on Windows, and I'm joined here today by.
**[00:00:11]** Hi, my name is Craig.
**[00:00:12]** I'm a product manager working on the Windows Subsystem for
**[00:00:15]** Linux and other awesome AI tools on Windows.
**[00:00:18]** And today we're going to be talking to you about
**[00:00:20]** a new feature, WSL containers.
**[00:00:22]** And so really the talk boils down to just these
**[00:00:25]** three points.
**[00:00:25]** So this is the only really three takeaways you need.
**[00:00:28]** The first is you're going to be able to run
**[00:00:30]** Linux containers locally on Windows.
**[00:00:32]** That includes running them directly part of ACLI or running
**[00:00:36]** them as part of an API with within Windows applications.
**[00:00:40]** Second is that it's going to be part of the
**[00:00:42]** Windows Subsystem for Linux.
**[00:00:44]** So this will just be a new feature that you
**[00:00:46]** get directly as part of WSL.
**[00:00:48]** No need to install something new.
**[00:00:49]** It will just be part of an existing package that
**[00:00:51]** I hope you're already using.
**[00:00:53]** And the third is that we're want to make this
**[00:00:56]** enterprise ready.
**[00:00:57]** So this means that all the industry standard tools that
**[00:01:00]** you're using like MDE, Intune and more, all of that
**[00:01:03]** will just work with WSL containers as well so that
**[00:01:06]** you can feel secure and safe using this inside of
**[00:01:08]** your enterprise environment.
**[00:01:11]** And I think really the fun part here is let's
**[00:01:15]** go and jump out of the slides and jump into
**[00:01:18]** a live demo of taking a look at the CLI.
**[00:01:22]** So if we could switch to the other machine, we'll
**[00:01:25]** take a look.
**[00:01:33]** All right, as Craig said, when we ship this, you
**[00:01:36]** will get the full capabilities of WSL containers via simple
**[00:01:40]** WSL update.
**[00:01:41]** You don't need to download any third party tools, no
**[00:01:45]** starting of daemons, no Faustian rituals.
**[00:01:48]** And what it comes with is a command line tool
**[00:01:52]** called.
**[00:01:53]** You can't switch, can't switch.
**[00:01:56]** Oh, great.
**[00:01:57]** Oh, it's switched OK.
**[00:01:58]** Nice.
**[00:02:03]** What it comes with is a command line tool called
**[00:02:06]** WSLC and here I wanted to show you the command
**[00:02:10]** reference that the tool exposes.
**[00:02:13]** And as you look at this you'll realise that it
**[00:02:15]** looks very familiar to you.
**[00:02:16]** If you're used to using any of the standard Linux
**[00:02:19]** container tools out there.
**[00:02:20]** All the sub commands, options, switches within these also track
**[00:02:24]** very closely.
**[00:02:25]** We've also internally aliased it to container, so if you're
**[00:02:29]** more familiar to using container you can use that binary.
**[00:02:35]** Let me start by showing you a really simple flow
**[00:02:37]** here.
**[00:02:38]** I'm going to start by showing you how to create
**[00:02:42]** a Debian Linux container on Windows.
**[00:02:47]** And if you're not familiar, the Dash IT switch here
**[00:02:50]** tells WSLC to give me an interactive shell into my
**[00:02:53]** Debian Linux container.
**[00:02:56]** Normally it would download this image for me from a
**[00:02:58]** public registry.
**[00:02:59]** If I don't have it here, we have some Internet
**[00:03:01]** issues here.
**[00:03:02]** So I pre downloaded it.
**[00:03:04]** And so I'm inside of the shell of the Debian
**[00:03:07]** Linux container.
**[00:03:08]** I can detach out of it using the standard control
**[00:03:11]** P control Q sequence.
**[00:03:13]** And now if I do a WSLC PS-A or if
**[00:03:16]** I do a WSLC container list if that's more familiar
**[00:03:21]** container.
**[00:03:23]** List.
**[00:03:24]** Container list.
**[00:03:27]** You'll see that the DBN Linux container started about 40
**[00:03:29]** seconds ago.
**[00:03:31]** I'm going to attach back to my container using WSLC
**[00:03:35]** attach and the container ID or the container name and
**[00:03:39]** there it is, I'm back inside of DBN Linux.
**[00:03:43]** I'm going to exit out of this container and terminate
**[00:03:46]** it, and WSLC PS-A will now show me that the
**[00:03:49]** DBN Linux container is exited about four seconds ago.
**[00:03:54]** So this was a really simple flow.
**[00:03:56]** Next, I want to show you how you would build
**[00:03:59]** custom images using WSLC.
**[00:04:01]** You would want to use this when you want to
**[00:04:04]** bring your cloud workloads or your production workloads directly onto
**[00:04:07]** your primary Windows development box so that you can iterate
**[00:04:11]** on it, test it, debug it locally.
**[00:04:13]** And that way, because it's packaged as a container, you
**[00:04:16]** get the same environment that you have in production locally
**[00:04:19]** on your box here.
**[00:04:19]** And so you don't have the gotcha as of it
**[00:04:21]** works in dev, doesn't work in prod.
**[00:04:24]** So let me start by showing you a container file.
**[00:04:28]** If you're not familiar with this file, the container file
**[00:04:31]** has all the ingredients and the recipe that you need
**[00:04:34]** in order to build your container images.
**[00:04:36]** So it packages up your environment, your dependencies, your application
**[00:04:41]** logic, the instructions on how to run your application into
**[00:04:44]** a file, and then you can use this to build
**[00:04:47]** a container image.
**[00:04:48]** For me here, it's a really simple Linux utility I
**[00:04:51]** wrote for fun, which allows me to run all of
**[00:04:54]** my favorite Linux inspection commands on any file I drop
**[00:04:58]** to it.
**[00:04:59]** So the first line here is basically saying that my
**[00:05:03]** container environment starts with a very simple lightweight Python 312
**[00:05:08]** image.
**[00:05:09]** The next few lines here are installing all the dependencies
**[00:05:12]** that are needed for my container and my application logic
**[00:05:15]** to run successfully.
**[00:05:17]** Here I'm copying my application logic into the container and
**[00:05:20]** it's a web server that listens on port 5000.
**[00:05:23]** So I want to expose that port out of my
**[00:05:25]** container and map it onto my windows box when I
**[00:05:28]** run this container so that I can interact with this
**[00:05:31]** web server that's running inside of the Linux container locally
**[00:05:34]** from my windows box using local host.
**[00:05:37]** And then the last line here is the instructions on
**[00:05:39]** how my application should be started within this environment.
**[00:05:43]** So let me build this image using WSLC build.
**[00:05:47]** I'm going to call it my Linux spy and I
**[00:05:52]** can use the container file to build this.
**[00:05:57]** There it goes.
**[00:05:58]** And now if I do a WSLC images, and yes
**[00:06:01]** you can use grip here on PowerShell because I'm going
**[00:06:05]** to do a shameless plug here for another friend of
**[00:06:08]** mine.
**[00:06:09]** We have imported all the core utils, about 168 Linux
**[00:06:12]** utils into Windows now which are fully integrated.
**[00:06:17]** So here's the image that just built it says 9
**[00:06:20]** hours ago because some of the caching for base layers
**[00:06:24]** was already used.
**[00:06:25]** I'm going to now start a container using this image
**[00:06:28]** and I'm going to do a port mapping.
**[00:06:31]** As I mentioned earlier, my container web server listens on
**[00:06:34]** port 5000.
**[00:06:35]** I'm going to map it to my Windows host using
**[00:06:38]** this Dash P switch.
**[00:06:41]** And here I'm starting up my container.
**[00:06:43]** There it goes.
**[00:06:44]** I can now hit it on 127001, which is local
**[00:06:48]** host and I can interact with my Linux by my
**[00:06:52]** forensics tool.
**[00:06:53]** Here and there it is.
**[00:06:54]** It runs all of my favorite Linux commands on it.
**[00:06:58]** So now that I've shown you how you would expose
**[00:07:01]** services out of a Linux container onto your Windows host,
**[00:07:04]** I wanted to show you something more interesting.
**[00:07:07]** I wanted to show you how these containers can actually
**[00:07:10]** tap into the GPU that's present on your Windows host
**[00:07:13]** for your AI scenarios or if you want to run
**[00:07:16]** graphical applications or whatever.
**[00:07:18]** Have you.
**[00:07:19]** I've already built my container and pre warmed it so
**[00:07:22]** it's already running.
**[00:07:25]** I did that to save time and I'm going to
**[00:07:27]** start.
**[00:07:28]** It's a Jupiter notebook web server again.
**[00:07:30]** It listens on port 8888, which I exposed out using
**[00:07:33]** port mapping.
**[00:07:34]** I'm going to start running these cells while I tell
**[00:07:38]** you what this cool AI container of mine does.
**[00:07:42]** What it does is it actually pulls down a G
**[00:07:46]** PT2 model and then it fine tunes it on the
**[00:07:49]** GPU on this Windows host and then it torch compiles
**[00:07:53]** this so that it generates fused Triton kernels.
**[00:07:56]** Those are those fused Triton kernels are optimised kernels that
**[00:08:00]** allow my model to run really fast on the GPU.
**[00:08:03]** And then for your entertainment, it shows you a head
**[00:08:07]** to head race between a compiled model and its uncompiled
**[00:08:10]** eager mode counterpart.
**[00:08:13]** And you can see how fast the compiled model runs.
**[00:08:16]** And while all this is happening, the GPU on my
**[00:08:18]** Windows box here is being leveraged to do all of
**[00:08:21]** this work inside of the Linux container.
**[00:08:25]** And before I hand it back over to Craig for
**[00:08:27]** some more WSL containers goodness and how you can embed
**[00:08:30]** those into your Windows application flows, I quickly wanted to
**[00:08:33]** show you the command that I ran to start my
**[00:08:36]** AI container here.
**[00:08:38]** So I ran it using run Dash IT you're familiar
**[00:08:41]** with that I showed you earlier.
**[00:08:43]** There's port mapping.
**[00:08:43]** And then the Dash V switch here is saying that
**[00:08:46]** I want to mount volume.
**[00:08:47]** So I want to mount the HF, the hugging face
**[00:08:50]** cache directory that's on my Windows host here onto this
**[00:08:54]** location into my container.
**[00:08:56]** And then the Dash Dash GPU's.
**[00:08:58]** All switch is asking the Linux container to use the
**[00:09:01]** GPU on my Windows box here.
**[00:09:03]** And I'm going to hand it back to Craig.
**[00:09:05]** Awesome.
**[00:09:07]** So if we jump back to the slides, we'll be
**[00:09:09]** able to see kind of the next step.
**[00:09:11]** And really the summary of that demo is there's two
**[00:09:15]** ways to interact with WSL container.
**[00:09:18]** There's the CLI, which we just showed as an awesome
**[00:09:21]** way to directly interact with those containers, but we also
**[00:09:24]** have an API.
**[00:09:25]** So the CLI is perfect for direct container access, direct
**[00:09:28]** building, running, and then the API is going to be
**[00:09:31]** a Nugent package that you'll be able to run.
**[00:09:33]** And it's basically two different doors for the same engine.
**[00:09:36]** It's all powered by the same WSLVM that actually powers
**[00:09:39]** WSL distributions.
**[00:09:41]** And really, when we talk about this, it begs the
**[00:09:44]** question, why did we build this?
**[00:09:46]** Who is this for?
**[00:09:47]** What are our goals at Microsoft for making this technology?
**[00:09:50]** And that breaks down to three different customer profiles.
**[00:09:53]** The first is if you're a container developer, this is
**[00:09:56]** for you.
**[00:09:56]** If you like to build, use containers.
**[00:09:59]** We wanted to make it easier to get started with
**[00:10:01]** to use containers and have that all run seamlessly on
**[00:10:04]** Windows.
**[00:10:05]** We also wanted to be able to be opinionated about
**[00:10:08]** our approach.
**[00:10:09]** We know that we are building both an API and
**[00:10:11]** ACLI, so we want them to work together, and we're
**[00:10:13]** probably going to write some pretty custom commands to do
**[00:10:16]** that.
**[00:10:17]** That's why we built our own Linux container CLI as
**[00:10:19]** opposed to using other standard tools like Docker or Podman
**[00:10:22]** or Rancher Desktop.
**[00:10:23]** However, those tools all work great, and if they still
**[00:10:26]** solve problems for you, you should use them.
**[00:10:28]** This is just another approach, and by nature of this
**[00:10:31]** work, this is fully open sourced.
**[00:10:34]** It's fully open sourced on WSL and all of the
**[00:10:36]** code that we're doing, all the improvements that we're doing
**[00:10:39]** to the underlying VM technology are going to accrue to
**[00:10:41]** those other container technologies as well.
**[00:10:44]** So for example, we're improving the cross OS file performance.
**[00:10:47]** You'll get that as well on Docker Desktop, Rancher Desktop,
**[00:10:50]** Padman Desktop, as well as on the Linux container CLI
**[00:10:53]** inside of WSL.
**[00:10:55]** Secondly, we're also wanting to build this for app builders
**[00:10:58]** and IS VS.
**[00:10:59]** We want you to be able to take some awesome
**[00:11:01]** Linux code that you have lying around or in the
**[00:11:04]** cloud and run that directly and locally as part of
**[00:11:07]** a Windows application.
**[00:11:08]** We want you to be able to do that all
**[00:11:10]** using really standard and powerful AP is in your Windows
**[00:11:13]** app.
**[00:11:14]** And lastly, we all started building this for enterprise IT
**[00:11:17]** admins.
**[00:11:17]** These are folks who, hey, I want to run open
**[00:11:20]** Claw inside of my enterprise and I want to run
**[00:11:22]** that in a containerized environment using Linux, but I want
**[00:11:25]** to manage that using all the Windows tools like Intune
**[00:11:28]** or MDE that I'm familiar with.
**[00:11:31]** We're building this exactly for scenarios like that where I
**[00:11:34]** want to be able to use these powerful tools and
**[00:11:36]** applications and run Linux on Windows.
**[00:11:38]** And I don't want to be afraid of, hey, there's
**[00:11:41]** a black box opaque VM running in my organization.
**[00:11:44]** How do I access that?
**[00:11:45]** I want to make sure that you get that powerful
**[00:11:47]** isolation without having to worry about your security tools not
**[00:11:50]** being able to break that boundary.
**[00:11:53]** And so this brings us to a really awesome plug
**[00:11:56]** that we wanted to show for one of the partners
**[00:11:59]** that we've worked with.
**[00:12:01]** We have worked a lot with the Moonray team.
**[00:12:04]** Moonray is a very powerful rendering engine that is used
**[00:12:08]** to render amazing movies like the bad guys two or
**[00:12:11]** the wild Robot, which I'm a big fan of personally.
**[00:12:14]** And that rendering engine is built entirely on Linux.
**[00:12:18]** And so we've been able to work with the Moonray
**[00:12:21]** team to say, hey, how could we make it easier
**[00:12:23]** to get started with Moonray, which is also an open
**[00:12:26]** source application, and be able to use that on Windows.
**[00:12:30]** So that brings us to our second demo of let's
**[00:12:33]** go ahead and run the API portion of WSL containers.
**[00:12:36]** So I'm going to flip over here and you can
**[00:12:39]** see I'm in this project and I'm about to go
**[00:12:43]** run moonray.exe, which is a build that I've created.
**[00:12:47]** So again, this is a full Linux based rendering engine,
**[00:12:50]** but I have an EXE on my system and then
**[00:12:53]** I've given it some files.
**[00:12:54]** Of course it's backslashes.
**[00:12:56]** So we're running this in Windows and I've given it
**[00:12:59]** some input RDLB which are just render input files.
**[00:13:02]** And then I'm saying please output this jpg for me
**[00:13:04]** and I'm going to open up task manager so we
**[00:13:07]** can take a look at what's happening while we run
**[00:13:09]** this.
**[00:13:10]** When I run it, I've left some debug info here,
**[00:13:13]** it's starting up a session for me.
**[00:13:15]** That's how quickly it started the container.
**[00:13:17]** And then now it's doing the full render.
**[00:13:19]** And so if I look at my CPU, all the
**[00:13:21]** renders happening on my CPU, it's happening directly inside of
**[00:13:25]** this Moonray VM right here.
**[00:13:27]** And then now that the render is complete, the Moonray
**[00:13:30]** VM shuts down and all of that gets released back
**[00:13:33]** to Windows.
**[00:13:34]** So it's totally seamless.
**[00:13:35]** If I did not include these debug messages, it would
**[00:13:37]** just look like a Windows app.
**[00:13:39]** I would actually be none the wiser that this was
**[00:13:41]** running Linux in the back end.
**[00:13:43]** And then the cool part is if we take a
**[00:13:45]** look at the output, you can see it outputted that
**[00:13:47]** JPEG for me right here, which is a wonderful orange
**[00:13:50]** coffee maker showing some of the cool rendering of, you
**[00:13:53]** know, see through ray tracing applications.
**[00:13:56]** There.
**[00:13:56]** So this VM creation in the background, all of this
**[00:13:59]** running is all completely transparent to the to the user
**[00:14:02]** of the API.
**[00:14:02]** All you're doing is you're creating and managing containers via
**[00:14:05]** the API.
**[00:14:06]** Exactly so you as the developer can have control.
**[00:14:08]** Hey, I want some Linux code but I don't want
**[00:14:10]** my users to every worry am I running Linux or
**[00:14:12]** Windows.
**[00:14:13]** It just should all just work.
**[00:14:15]** So let's take a look at a sample project that's
**[00:14:17]** related to see how this might look in a code
**[00:14:20]** perspective.
**[00:14:21]** I have some container or some Nugent packages.
**[00:14:24]** I added this containers package and then I've defined this
**[00:14:28]** item group here saying please build this container for me.
**[00:14:32]** You can find the container file here and output it
**[00:14:35]** here.
**[00:14:36]** And if you take a look on my left hand
**[00:14:38]** navigation, that container file is directly with all of the
**[00:14:41]** source code of my app.
**[00:14:43]** It's built into my application.
**[00:14:45]** So this is all a part of your CS project
**[00:14:47]** file, so that container file as well.
**[00:14:49]** So it's all integrated together as a single experience, even
**[00:14:52]** though and.
**[00:14:53]** When I build and run this, it will automatically build
**[00:14:55]** the container for me.
**[00:14:56]** So 1F5 experience and it's going to run my sample
**[00:15:00]** app in this case.
**[00:15:01]** This app is a fake and very whimsical app that
**[00:15:04]** I built.
**[00:15:05]** I wanted to build an AI agent that would run
**[00:15:08]** stocks for me.
**[00:15:10]** So it's going to buy and sell some fake stocks,
**[00:15:12]** and that's the container starting up.
**[00:15:14]** It's starting a bunch of processes and services in the
**[00:15:17]** background, and then now it's started my stock trading.
**[00:15:20]** And so I've hired an AI agent I called Herbert
**[00:15:23]** to buy and sell some stocks.
**[00:15:26]** And what actually is happening is I've given this container
**[00:15:29]** its own desktop and I've given it a visualization of
**[00:15:31]** the desktop so we can see what's happening.
**[00:15:34]** And we can see the AI agent actually goes in
**[00:15:37]** and make some fake stock trades, but he has a
**[00:15:40]** really bad habit of eating files.
**[00:15:43]** So yes, I actually did program this to go randomly
**[00:15:46]** delete files on my system.
**[00:15:48]** And when it deletes the file, it really deletes it
**[00:15:51]** on Windows.
**[00:15:52]** So that actually deleted the file here.
**[00:15:54]** And what we're highlighting is that there is a high
**[00:15:58]** level of integration between the container and Windows.
**[00:16:01]** You can specify, I want these ports open.
**[00:16:04]** That's how I viewed that desktop that I showed.
**[00:16:07]** And you can specify, I only wanted to access this
**[00:16:10]** file on Windows.
**[00:16:12]** So I minimize the blast radius.
**[00:16:14]** Even though it really was deleting random things.
**[00:16:17]** I'm OK with showing that on this demo machine because
**[00:16:20]** it could not physically delete all the files on Windows.
**[00:16:23]** It could only delete the files in this C temp
**[00:16:26]** Herbert folder.
**[00:16:27]** So that's a very quick overview of where we're going
**[00:16:31]** with the API.
**[00:16:33]** And I'm sure the next burning question that you must
**[00:16:35]** have is how does this all work?
**[00:16:36]** So Pooja, would you be able to explain some of
**[00:16:38]** the architecture?
**[00:16:39]** Yeah, sure.
**[00:16:41]** So the way this works is every Windows application intending
**[00:16:46]** to create Linux containers gets a lightweight utility VM that's
**[00:16:51]** dedicated to it that's created in the background.
**[00:16:55]** All of the applications Linux containers are Co located on
**[00:16:59]** this VM.
**[00:17:00]** Every application as well as the CLI flow gets a
**[00:17:02]** separate VM.
**[00:17:03]** And what this gives us is a hypervisor boundary per
**[00:17:07]** app and it also gives us resource separation and a
**[00:17:11]** way to not 'cause conflict.
**[00:17:13]** So all of a container, all of an application's containers,
**[00:17:17]** it's names, it's volume, volume names, networks are all isolated
**[00:17:22]** on a on AVM basis.
**[00:17:23]** So there is no conflict there.
**[00:17:26]** Going into a little bit more detail on the left,
**[00:17:29]** here you see the Windows operating system and on the
**[00:17:32]** right is a virtual machine that was either created by
**[00:17:35]** a Windows application by calling into the WSL containers API
**[00:17:38]** or the CLI flow.
**[00:17:40]** So as we mentioned, the two entry points into the
**[00:17:44]** WSL containers world are via the API, which is exposed
**[00:17:48]** by a library called WSLCSDK.
**[00:17:51]** We publish it via Nugent package that Windows applications can
**[00:17:54]** include and then start interacting with the WSL containers API
**[00:17:57]** to create and manage containers.
**[00:18:00]** Or the other entry point into this world is the
**[00:18:03]** WSLC command line executable or container executable that I demoed
**[00:18:07]** earlier.
**[00:18:09]** Both of these talk to WSL service via inter process
**[00:18:12]** communication.
**[00:18:13]** If you've used WSLWSL, service exists today in that world
**[00:18:19]** it is used.
**[00:18:20]** Its job is to manage the distros that WSL runs,
**[00:18:22]** the life cycle of the WSL virtual machine, and the
**[00:18:25]** communication between the VM and the host.
**[00:18:28]** We've augmented the same service to now manage the containers
**[00:18:32]** that run within these VMS, and it also manages and
**[00:18:35]** relays information back and forth between these containers and the
**[00:18:39]** users.
**[00:18:40]** On the Windows host side, inside of the Linux virtual
**[00:18:42]** machine we run a container runtime.
**[00:18:45]** Today we're on Mobi.
**[00:18:46]** It's an open source engine that powers Docker today and
**[00:18:50]** WSL service uses an HV socket to communicate users intent
**[00:18:54]** to the container runtime by opening this HV socket with
**[00:18:57]** the Linux virtual machine.
**[00:19:00]** It is not a network socket, it's a specialized socket
**[00:19:02]** that is used specifically for communication between the VM and
**[00:19:06]** the hypervisor.
**[00:19:07]** It's an it's a special extension of the Winsock API
**[00:19:11]** and every VM has.
**[00:19:12]** It's sort of like a point to point per VM
**[00:19:14]** to the hypervisor.
**[00:19:15]** So it's an isolated communication channel for every VM, and
**[00:19:19]** once the user issues a command for container creation, the
**[00:19:23]** container runtime goes ahead and creates those containers, and WSL
**[00:19:27]** service does the job of relaying that information back and
**[00:19:31]** forth.
**[00:19:31]** Sorry, oops, excuse me.
**[00:19:40]** So that's that.
**[00:19:42]** Next, I wanted to quickly touch on storage.
**[00:19:46]** So the container runtime inside of every virtual machine uses
**[00:19:50]** a central directory within this VM to store container related
**[00:19:54]** information.
**[00:19:54]** It's metadata, it's scratch space, etcetera.
**[00:19:58]** And usually it's a location like Viralib and the container
**[00:20:01]** storage location.
**[00:20:02]** What we do is we now map this location onto
**[00:20:06]** a virtual disk on the Windows host side or a
**[00:20:09]** VHD.
**[00:20:11]** And every application gets its own VHD as well.
**[00:20:14]** The CLI flow also gets its own VHD.
**[00:20:16]** So at the storage level everything is separated per application
**[00:20:19]** as well.
**[00:20:22]** And lastly, I quickly wanted to show you what the
**[00:20:24]** flow would look like when a command as shown above
**[00:20:27]** is run.
**[00:20:27]** The run dash IT I've already talked about before.
**[00:20:30]** The volume mount here is saying that I want to
**[00:20:34]** map my C: data directory on the Windows side onto
**[00:20:38]** the slash data mount on the Linux container side.
**[00:20:42]** And I want to create a Debian latest container.
**[00:20:44]** So when this is issued, the container runtime creates that
**[00:20:48]** Debian latest container and then it attaches a slash data
**[00:20:52]** volume onto this container.
**[00:20:54]** And then under the hood we go ahead and map
**[00:20:58]** the slash data folder or volume onto the SQL and
**[00:21:02]** data folder on the Windows side using Verdio FS.
**[00:21:06]** Vario FS is a relatively new file sharing protocol that
**[00:21:11]** is used for sharing files between VM and hypervisor.
**[00:21:15]** And for us we have this added complexity here of
**[00:21:18]** translating all of the file system semantics between 2 completely
**[00:21:21]** different operating systems.
**[00:21:23]** If you've used WSL, it uses Plan 9 today.
**[00:21:27]** Vario FS is about twice as fast as it stands
**[00:21:31]** today in this environment.
**[00:21:33]** And we're investing more in this areas and looking at
**[00:21:36]** various alternatives as well to make this even faster.
**[00:21:42]** And before we wrap up WSL containers here, I wanted
**[00:21:46]** to also quickly take a detour and mention what else
**[00:21:50]** is new for WSL.
**[00:21:52]** Microsoft's Linux distro, Azure Linux 4 dot O is now
**[00:21:55]** available for general use, so that's exciting.
**[00:21:58]** It is the same distro that runs AKS today.
**[00:22:02]** This is what powers Azure.
**[00:22:03]** So if you use this, it gives you a consistent,
**[00:22:06]** battle tested, proven environment.
**[00:22:10]** It Microsoft provides the entire stack for Linux, so it's
**[00:22:14]** a single vendor, full supply chain attestation from build to
**[00:22:18]** deployment.
**[00:22:19]** So you know where to go if you have issues.
**[00:22:22]** It's available today for VM, so you can try that
**[00:22:25]** out.
**[00:22:26]** And the WSL distro is coming out soon as well.
**[00:22:28]** So once that comes out, we would love for you
**[00:22:31]** to try that out as one of the distros for
**[00:22:33]** WSL.
**[00:22:33]** It is container optimized.
**[00:22:35]** It is lightweight.
**[00:22:37]** So please try it out and let us let us
**[00:22:38]** know what you think.
**[00:22:41]** And that's it for WSL containers.
**[00:22:43]** We will be posting on the CLI blog when this
**[00:22:46]** goes live.
**[00:22:48]** Please try this out with your real world scenarios.
**[00:22:51]** Let us know, give us feedback so we can improve.
**[00:22:54]** And we plan to thank you public preview by the
**[00:22:56]** end of June.
**[00:22:57]** So you will be able to try it out there.
**[00:22:59]** We're open source, so you can go check our progress
**[00:23:01]** at Microsoft WSL.
**[00:23:02]** And then we'll be here for questions as well as
**[00:23:04]** the dev lead for Moon Ray.
**[00:23:06]** We'll be here as well if you have questions.
**[00:23:07]** So thank you very much.
**[00:23:08]** Thank you all.
**[00:23:09]** Thank.
**[00:23:09]** You so much.
