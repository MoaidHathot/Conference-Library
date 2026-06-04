**[00:00:02]** COSMOS DARWIN: Hello,
**[00:00:02]** and thanks for tuning into Microsoft Build.
**[00:00:05]** My name is Cosmos Darwin.
**[00:00:06]** I'm a Product Manager on the Microsoft Azure team.
**[00:00:10]** In this session, we're going to be talking
**[00:00:11]** about shipping physical AI to the edge using a variety
**[00:00:15]** of technologies for Microsoft's Adaptive Cloud approach,
**[00:00:18]** including Foundry Local and Azure Local.
**[00:00:22]** Now, here's specifically what we're going to cover.
**[00:00:24]** First, I want to take just a moment to, sort of,
**[00:00:26]** frame the opportunity and the challenges of physical AI.
**[00:00:29]** We talk a lot about AI, including this week
**[00:00:32]** at Microsoft Build, but often, it's in the context
**[00:00:34]** of a chatbot on a computer screen.
**[00:00:37]** There's so much more potential than that when we talk
**[00:00:40]** about bringing AI out into the physical world.
**[00:00:42]** That's what we'll frame
**[00:00:44]** up as the opportunity for this session.
**[00:00:46]** Then I'll show a demo of a basic agentic robot
**[00:00:51]** to help you understand the opportunity
**[00:00:53]** for combining language models and generative AI
**[00:00:56]** with physical systems.
**[00:00:58]** Then we'll spend most of the session unpacking how it works.
**[00:01:00]** I want to really give you a sense for some
**[00:01:02]** of the core ideas, what's novel and what isn't relative
**[00:01:06]** to conventional robotics.
**[00:01:09]** Then, finally, I'll just very briefly mention a few
**[00:01:12]** of the Adaptive Cloud technologies that we used
**[00:01:14]** in this demo including small form factor infrastructure,
**[00:01:17]** Foundry Local enabled by Azure Arc,
**[00:01:19]** and the Azure IoT Operations suite of platform services.
**[00:01:24]** Now, this session is for builders, so I'm not going
**[00:01:27]** to give you the marketing pitch for each of those products,
**[00:01:29]** but I do just want to give you a sense for how we used them
**[00:01:31]** to put together the basic agentic robot that we showed.
**[00:01:35]** Without any further ado then, let's get started.
**[00:01:39]** What is physical AI?
**[00:01:41]** Well, when we talk about AI, we talk a lot
**[00:01:43]** about the transformative potential, how AI helps
**[00:01:46]** so many people to really achieve more, to do things
**[00:01:49]** that they might have thought before would take a long time.
**[00:01:51]** Suddenly, that time is compressed and things
**[00:01:54]** that you would have considered to be a large,
**[00:01:57]** challenging task can be completed very quickly,
**[00:02:00]** but the benefits from those advancements have not been
**[00:02:04]** evenly distributed.
**[00:02:05]** An awful lot of the examples we give are documents
**[00:02:08]** or spreadsheets, basically, information workers benefiting
**[00:02:11]** from the advances of AI.
**[00:02:14]** Let me give you a few examples of types of work
**[00:02:17]** that have not really seen that same change.
**[00:02:19]** For example, performing inspections or maintenance
**[00:02:22]** or even repairs out in the physical world.
**[00:02:26]** This work has not really benefited from the advances
**[00:02:30]** of AI in the last few years.
**[00:02:32]** Similarly, factories, yeah,
**[00:02:36]** you can automate manufacturing in a factory context.
**[00:02:39]** A lot of things are actually built outside of a factory.
**[00:02:41]** You can look around and you'll see job sites everywhere
**[00:02:43]** where construction is happening,
**[00:02:45]** and you won't see a lot of robots.
**[00:02:47]** It's people performing that work.
**[00:02:50]** Similarly, in logistics and distribution and warehousing,
**[00:02:54]** a lot of this looks the same now as it did a decade
**[00:02:58]** or even two decades ago.
**[00:02:59]** Those gains in productivity have not really materialized yet.
**[00:03:04]** Those things, once they get distributed through logistics
**[00:03:06]** and arrive at brick-and-mortar retail
**[00:03:09]** or quick-serve restaurants, a lot of the work
**[00:03:12]** of stocking shelves or food prep, similarly,
**[00:03:15]** has not really benefited from this advancement with AI
**[00:03:19]** in the last few years.
**[00:03:21]** There's a common theme to all of these examples,
**[00:03:24]** which is that in each of these situations,
**[00:03:27]** interacting with other people and interacting
**[00:03:30]** with a changing environment around you, with changes
**[00:03:32]** in the open world, is a core part of the work.
**[00:03:35]** This is something
**[00:03:36]** that historically robots have struggled with.
**[00:03:39]** Robots excel when you're in a controlled environment,
**[00:03:41]** you're doing the exact same task over and over,
**[00:03:44]** so a factory is a great example of this,
**[00:03:46]** but all of those examples I just gave are domains
**[00:03:49]** where robots have struggled to make inroads.
**[00:03:54]** As a result, the work looks an awful lot
**[00:03:56]** like it has for decades.
**[00:03:59]** However, what's exciting is that many people, myself included,
**[00:04:02]** believe that that is beginning to change.
**[00:04:05]** With some of the advances in recent years with AI models
**[00:04:08]** and being able to run them locally, it is possible to go
**[00:04:11]** from robotics to a more agentic approach to robots
**[00:04:15]** that may be better able to do a lot of these tasks.
**[00:04:19]** To illustrate that, my team
**[00:04:21]** and I have put together a basic example.
**[00:04:23]** Now, let me set expectations.
**[00:04:25]** This robot I'm about to show you, it's not going
**[00:04:27]** to take anyone's job, but it does serve to sort
**[00:04:30]** of show the potential of combining AI,
**[00:04:34]** especially language models, with physical systems.
**[00:04:37]** Take a look.
**[00:04:40]** [ Music ]
**[00:04:44]** Hey, robot, can you pick up the red cube?
**[00:04:48]** [ Music ]
**[00:04:56]** That's right and put it in the bowl.
**[00:04:59]** [ Music ]
**[00:05:01]** Wait, I changed my mind.
**[00:05:03]** Can you give it to me?
**[00:05:07]** [ Music ]
**[00:05:13]** Thank you.
**[00:05:14]** Now pick up the green brick.
**[00:05:18]** [ Music ]
**[00:05:25]** Now put it in this green bowl.
**[00:05:29]** [ Music ]
**[00:05:44]** That's right.
**[00:05:44]** Well done.
**[00:05:46]** Isn't the robot cute?
**[00:05:49]** [Laughter] Now look, as I said, it's a simple
**[00:05:53]** or a basic example, so that robot is not about to go
**[00:05:56]** out into the open world and address any
**[00:05:58]** of the scenarios I talked about at the beginning, but I do want
**[00:06:00]** to reflect on a few
**[00:06:01]** of the interesting aspects of what we just saw.
**[00:06:05]** I, as the person interacting with the robot, did not need
**[00:06:08]** to adhere to a strict syntax of commands to sort
**[00:06:11]** of start or stop the robot.
**[00:06:13]** I could interact with it
**[00:06:14]** in a very natural way, in a very fluid way.
**[00:06:17]** I could just say what I wanted it to do,
**[00:06:20]** even if it was a kind of rambling sentence.
**[00:06:22]** "Hey, robot, please, would you mind maybe picking
**[00:06:25]** up that thing there?"
**[00:06:27]** The robot, because it's an agentic robot, is able to reason
**[00:06:31]** about what it heard and figure out what I meant anyway,
**[00:06:35]** even though the interaction was kind of messy, the inputs coming
**[00:06:39]** from a person were messy.
**[00:06:41]** Likewise, it was able to respond as the environment
**[00:06:44]** around it changed, because it's continuously listening,
**[00:06:47]** continuously looking, and when I moved objects on it
**[00:06:50]** or when I changed the instruction midstream,
**[00:06:53]** it was able to sort of pick up and adapt and keep going.
**[00:06:56]** You can easily imagine a version of that
**[00:06:58]** with a different embodiment, more sophisticated hardware,
**[00:07:01]** for example, with more different things that it knows how to do,
**[00:07:05]** being a helpful collaborator in spaces where, historically,
**[00:07:09]** people have not been able to benefit
**[00:07:10]** from having a helpful robot collaborator
**[00:07:12]** because of the challenges I mentioned.
**[00:07:15]** Okay. How does it actually work?
**[00:07:18]** Let's unpack a little bit, what is going on behind the scenes
**[00:07:21]** in that demo, so that you can see the pieces that are new
**[00:07:25]** and novel and then the other pieces which, actually,
**[00:07:27]** are very much just sort of conventional robotics.
**[00:07:30]** Everything you saw in the demo, all of the intelligence required
**[00:07:33]** to make the robot work as shown,
**[00:07:36]** runs on this small, industrial computer.
**[00:07:40]** For the demo, we use the Lenovo ThinkEdge SE100
**[00:07:43]** because it's sort of industrial grade.
**[00:07:45]** It has an optional NVIDIA discrete GPU,
**[00:07:48]** but many other devices would work too.
**[00:07:50]** This is just the one that we chose.
**[00:07:52]** This computer is physically on the table,
**[00:07:54]** co-located with the robot.
**[00:07:55]** You can see it actually in the background of the video,
**[00:07:58]** and it's connected just over USB, nothing fancy,
**[00:08:01]** to three peripherals: First, a UVC-compliant RGB camera,
**[00:08:05]** which is positioned over the workspace looking
**[00:08:07]** down at the table.
**[00:08:09]** Second, a UAC-compliant omnidirectional microphone,
**[00:08:12]** which, of course, is used to capture the speech.
**[00:08:15]** Then finally, the small tabletop robot arm, which has six degrees
**[00:08:20]** of freedom and a seventh if you want
**[00:08:22]** to count the gripper attachment that it has.
**[00:08:24]** By the way, all of these are deliberately approachable,
**[00:08:28]** off-the-shelf budget options,
**[00:08:30]** because there's very little preventing you
**[00:08:31]** from just trying this at home yourself, as we did.
**[00:08:35]** Now in the video, you can see each of these things,
**[00:08:37]** but just to sort of show you clearly, that was the USB camera
**[00:08:40]** over the work surface, and that's the USB microphone.
**[00:08:42]** These really are -- there's nothing terribly fancy
**[00:08:45]** about these.
**[00:08:45]** It's not a depth camera or anything like that.
**[00:08:47]** It's just a classic, almost like a webcam,
**[00:08:50]** so that's the hardware setup.
**[00:08:52]** Perhaps a little more interesting is
**[00:08:53]** on the software side.
**[00:08:55]** On that small form factor industrial computer,
**[00:08:57]** we chose to run the Azure Linux operating system,
**[00:09:00]** and then Foundry Local, which you may know as something
**[00:09:03]** that was originally available on Windows, then it expanded
**[00:09:06]** to Windows and Android.
**[00:09:07]** Foundry Local is now newly packaged as a container image
**[00:09:10]** that you can run on Linux, which was a great fit
**[00:09:13]** for our scenario here.
**[00:09:15]** Foundry Local then hosts all of the AI models that we use
**[00:09:19]** to make the robot do what it does.
**[00:09:21]** At runtime, here's how this actually comes together.
**[00:09:25]** Firstly, audio from the microphone is split
**[00:09:28]** into utterances, and then fed into Nemotron Speech Streaming.
**[00:09:32]** Nemotron is a speech-to-text model
**[00:09:35]** that was developed by Nvidia.
**[00:09:37]** It's available for free
**[00:09:38]** in the Foundry Local catalog, and it's great.
**[00:09:41]** It's one of the best models in terms of performance
**[00:09:43]** and in terms of very low error rate.
**[00:09:45]** As you saw in the video, even though I am facing away
**[00:09:48]** from the microphone, not speaking terribly clearly,
**[00:09:51]** there's a bunch of ambient noise, it was still able to pick
**[00:09:54]** up and transcribe everything I said very reliably.
**[00:09:57]** Feeding the audio into Nemotron Speech gives us back text
**[00:10:01]** of what was said by the user.
**[00:10:04]** In parallel with that, frames from the camera
**[00:10:07]** over the work surface are continuously being captured
**[00:10:10]** and fed into a variety of vision models,
**[00:10:13]** including an open vocabulary detector model,
**[00:10:16]** to recognize everything that we can see on the surface.
**[00:10:19]** That certainly includes colored blocks and the little bowls
**[00:10:24]** or containers that we put them in.
**[00:10:26]** It includes a human hand, for example,
**[00:10:28]** but it's not limited to that.
**[00:10:29]** Something we didn't show in the video is, also,
**[00:10:31]** just everyday objects can be recognized
**[00:10:34]** by these detector models, so sunglasses, for example,
**[00:10:37]** or a wedding ring, that's no problem.
**[00:10:40]** It will pick them up.
**[00:10:41]** Basically, for each of these detections,
**[00:10:43]** it's returning the coordinates within the frame
**[00:10:45]** of where that object was seen.
**[00:10:47]** As applicable, it also returns the orientation, the major axis
**[00:10:51]** of rotation, because, of course, that's very important
**[00:10:54]** if the robot is going to go actually pick that object up.
**[00:10:57]** The vision pipeline gives us these coordinates
**[00:10:59]** and angles of rotation.
**[00:11:02]** Now for the most important part, the reasoning.
**[00:11:06]** All of these inputs, the text from the speech pipeline
**[00:11:10]** and the coordinates from the vision pipeline,
**[00:11:12]** are fed into a small language model that runs locally
**[00:11:16]** on that small industrial computer.
**[00:11:18]** Now for the demo, we chose Quen3 because it's available for free
**[00:11:21]** in the Foundry Local catalog, and it supports reasoning
**[00:11:23]** and tool calling, but many other options would likely work
**[00:11:27]** as well.
**[00:11:28]** We chose the 1.7-billion parameter version,
**[00:11:30]** which most people would say means it's a small language
**[00:11:32]** model, but if you had more compute available,
**[00:11:35]** you could also run a larger version
**[00:11:36]** and quite possibly handle more complex types of instructions.
**[00:11:41]** What's happening here is given all of the inputs,
**[00:11:44]** the language model is asked to choose between a set
**[00:11:47]** of tool calls that are available to it.
**[00:11:49]** Now, for our example, again,
**[00:11:50]** it's very basic, it's very simple.
**[00:11:52]** We just gave it four tools that it knows how to call.
**[00:11:54]** Those tools are Pick, so go pick up an item at a location.
**[00:11:58]** Place, put it somewhere at some other location, or Pick
**[00:12:02]** and Place, all as one movement.
**[00:12:05]** Then the final tool call is Stop.
**[00:12:06]** When it hears something like in the video when I say "Wait,"
**[00:12:10]** it interprets that as a "Stop" tool call.
**[00:12:13]** All the language model does is decide based on what it sees
**[00:12:16]** and hears, which of these tools is it being asked to call?
**[00:12:20]** In the example we've been using, of course,
**[00:12:22]** it's a pick-and-place tool call where the
**[00:12:24]** "Pick" target is the red cube; the "Place" target is the hand,
**[00:12:27]** me, and once it has done that interpreting,
**[00:12:31]** the rest is pretty straightforward, right?
**[00:12:32]** That gets converted into a sequence of movements
**[00:12:34]** that get planned out and then the robot arm executes them.
**[00:12:37]** This part is really no different
**[00:12:38]** from how it would have been in the past.
**[00:12:40]** What's so interesting is the additional flexibility,
**[00:12:44]** the additional almost humanness that comes
**[00:12:47]** from the robot being able to interpret very messy inputs
**[00:12:51]** and still figure out what you meant and then complete the task
**[00:12:54]** if it's among the set of tools that it has.
**[00:12:57]** All right.
**[00:12:58]** There were a number of adaptive cloud technologies that we used
**[00:13:01]** to make this demo possible, and so I do want
**[00:13:03]** to just briefly touch on each of them.
**[00:13:06]** The first one is the small form factor infrastructure,
**[00:13:09]** that industrial computer that we use to run the whole demo.
**[00:13:12]** There are a bunch of capabilities
**[00:13:13]** that Microsoft Azure has offered for several years
**[00:13:15]** that have previously been limited
**[00:13:17]** to Azure Local on big servers.
**[00:13:19]** This is things like provisioning machines from the cloud
**[00:13:22]** or managing them from the cloud.
**[00:13:24]** What's new is that those capabilities are now available
**[00:13:26]** in preview for these smaller industrial form factors,
**[00:13:30]** so take a look.
**[00:13:31]** In the Azure portal, I can go provision a machine.
**[00:13:36]** You'll see when I input the ownership voucher
**[00:13:38]** for that Lenovo SE100 that I have, it picks it up,
**[00:13:43]** and I can actually choose what software stack to install
**[00:13:46]** onto this computer straight from the cloud portal without needing
**[00:13:48]** to plug in a keyboard or monitor.
**[00:13:50]** In this case, I chose Azure Linux, and I could do
**[00:13:52]** that provisioning entirely from the cloud.
**[00:13:55]** Once I do that, I get a resource representation
**[00:13:59]** in the Azure Resource Manager for this computer.
**[00:14:02]** You'll see it looks and works an awful lot
**[00:14:04]** like a cloud virtual machine.
**[00:14:05]** It's a provisioned machine resource type,
**[00:14:08]** and it has a bunch of things that I get visibility into
**[00:14:11]** and management functions that I can perform.
**[00:14:14]** One simple example is I can grant access to this machine
**[00:14:17]** to a colleague of mine directly
**[00:14:19]** from the cloud portal using Microsoft Entra ID,
**[00:14:22]** which means I don't need to have a password on a Post-it note
**[00:14:25]** that I've written down or SSH key that I send to them.
**[00:14:29]** This is a much more robust way of managing a device like this,
**[00:14:33]** which is going to be really important if I want
**[00:14:35]** to take this system and have hundreds or thousands
**[00:14:39]** of them distributed across many locations.
**[00:14:41]** Being able to manage it all
**[00:14:42]** through the cloud control plane is going
**[00:14:43]** to be extremely helpful.
**[00:14:45]** That's one of the things that we did in this demo.
**[00:14:48]** Another one which I've already mentioned is we used Foundry
**[00:14:50]** Local, and specifically, the flavor of Foundry Local
**[00:14:53]** that is newly available now as a container image for Linux.
**[00:14:58]** On our small form factor industrial computer,
**[00:15:01]** we installed Azure Linux as I said.
**[00:15:03]** Now also to keep all of this straight,
**[00:15:04]** we also just installed K3s, like a small, single-node Kubernetes,
**[00:15:09]** and then we packaged our application code as a container.
**[00:15:13]** That code is just Python.
**[00:15:14]** It's really not terribly fancy.
**[00:15:18]** Alongside that container, we then deployed Foundry Local
**[00:15:21]** in a container, and Foundry Local exposes an open AI
**[00:15:24]** compatible REST API that we can use
**[00:15:26]** to make inferencing requests, and this is great
**[00:15:28]** because it means we don't need to host the AI models
**[00:15:31]** in our own code, which can be very clunky.
**[00:15:33]** It can kind of -- you can run into challenges related to size
**[00:15:36]** and agility and all sorts of reasons
**[00:15:39]** that you don't really want to do it that way, but also,
**[00:15:42]** there are a few specific advantages to this approach
**[00:15:44]** that I thought were pretty compelling.
**[00:15:46]** The first is Foundry Local gives you a trusted, authoritative way
**[00:15:50]** to access a safe instance of a model.
**[00:15:54]** In our demo, we wanted Quen3,
**[00:15:56]** the 1.7-billion parameter version.
**[00:15:58]** All we had to do was give its name in our configuration file
**[00:16:03]** and then Foundry Local goes out and retrieves a trusted copy
**[00:16:07]** of that model from the Foundry Local online catalog,
**[00:16:10]** downloads it to run entirely locally, and from that point on,
**[00:16:13]** there are no calls to the cloud at all.
**[00:16:14]** It's just running inside of that Foundry Local container for you.
**[00:16:18]** You can see in the catalog here,
**[00:16:20]** there are so many options available,
**[00:16:21]** including Nemotron Speech, the other model
**[00:16:23]** that we used in the demo.
**[00:16:26]** Once the model is running,
**[00:16:27]** you can then just access it using an endpoint very much the
**[00:16:31]** way you would if it was running in the cloud.
**[00:16:33]** It's like a drop-in replacement
**[00:16:34]** for making an API call to a public cloud.
**[00:16:37]** Instead of accessing, say, Azure to run the model,
**[00:16:41]** the model is running locally
**[00:16:42]** on the small form factor device right next to your code.
**[00:16:45]** What's great about that, of course,
**[00:16:46]** is the latency is super predictable, and for a system
**[00:16:49]** that is going to be out in the physical world interacting
**[00:16:51]** with people, it all needs to be as close to real time
**[00:16:53]** as you can get, so this is a great fit.
**[00:16:56]** Now speaking of real time, the other thing
**[00:16:58]** that Foundry Local takes care
**[00:16:59]** of that I loved is it handles detecting the available hardware
**[00:17:04]** accelerators in your hardware and lighting them up for you.
**[00:17:09]** In our case, our Lenovo SE100 has an Nvidia GPU.
**[00:17:12]** It has an RTX 2000 in it, and when you're using Foundry Local
**[00:17:17]** on top of the small form factor infrastructure managed
**[00:17:20]** through Azure, the whole top-to-bottom stack can be lined
**[00:17:23]** up for you.
**[00:17:24]** Everything from the kernel mode driver to the device plug-in,
**[00:17:27]** to the user mode libraries that are inside
**[00:17:29]** of the Foundry Local container, all of that is lined up.
**[00:17:32]** Actually, as you see in the diagram,
**[00:17:34]** your own application code doesn't even need to do anything
**[00:17:37]** with the GPU, actually.
**[00:17:38]** You're still benefiting from GPU-accelerated inference,
**[00:17:41]** because as you make those inference requests
**[00:17:43]** to Foundry Local, they happen much quicker
**[00:17:45]** because the GPU is there.
**[00:17:46]** In this instance, it sped up reasoning by Quen
**[00:17:50]** by a factor of many times.
**[00:17:51]** We tried it both ways.
**[00:17:52]** This was a huge boost.
**[00:17:55]** Here you can actually see a screenshot.
**[00:17:56]** This is a pre-release tool,
**[00:17:58]** so it may change a little before we release it,
**[00:18:00]** but you can see a screenshot of that Nvidia RTX 2000E running
**[00:18:05]** in our device, and in the Azure portal,
**[00:18:07]** I can see the usage of that GPU.
**[00:18:10]** Every time Quen is asked to interpret some instructions,
**[00:18:13]** you can see a small spike in the GPU usage,
**[00:18:16]** which shows you that it's being used.
**[00:18:18]** All right.
**[00:18:19]** The last piece of the puzzle I want to talk
**[00:18:20]** about is Azure IoT Operations.
**[00:18:24]** IoT Operations is a suite of platform services
**[00:18:27]** that enables you to connect to devices and protocols
**[00:18:30]** in your local environment.
**[00:18:31]** Then connect the data from them up into the cloud,
**[00:18:34]** and potentially, route commands back, such as mission plans
**[00:18:38]** for a robot, for example.
**[00:18:41]** IoT Operations includes a number of built-in connectors
**[00:18:43]** that are really handy for things like OPC UA, HTTP, ONVIF,
**[00:18:47]** and it also includes an industrial grade MQTT broker
**[00:18:50]** that you can configure so that as data flows into the broker,
**[00:18:54]** you can then configure how it gets transformed and sent
**[00:18:57]** up to the cloud, for example,
**[00:18:58]** for you to do analysis in Microsoft Fabric.
**[00:19:02]** Now in our example, there are some things
**[00:19:04]** that we were interested in monitoring.
**[00:19:06]** One of them is the robot's span or reach, right?
**[00:19:10]** Our robot, of course, is very small, and it can only reach,
**[00:19:13]** I don't know, maybe half a meter or something.
**[00:19:15]** The field of view of the camera is actually larger than that,
**[00:19:17]** and so occasionally, you have the situation
**[00:19:19]** where the camera can see an object, and the robot believes
**[00:19:22]** that it's being asked to go pick or place that object,
**[00:19:25]** but it actually can't reach it, as you see in this image here.
**[00:19:29]** Now, in the case of just a single robot on a tabletop,
**[00:19:32]** of course, it's not that hard to diagnose this yourself,
**[00:19:34]** but you can imagine deploying this
**[00:19:36]** across many locations in the field.
**[00:19:38]** Being able to get real-time telemetry and intelligence off
**[00:19:41]** of a system like this is everything.
**[00:19:43]** That is where Azure IoT Operations is so valuable.
**[00:19:48]** Let me show you.
**[00:19:48]** On the K3 instance that we run
**[00:19:51]** on this small industrial computer,
**[00:19:54]** we deployed Azure IoT Operations using the extension approach.
**[00:19:56]** Both IoT Operations and Foundry are available as extensions,
**[00:20:00]** which means it's just a couple of clicks or a single YAML file,
**[00:20:03]** and you're off to the races.
**[00:20:05]** Once IoT Operations is installed,
**[00:20:07]** you get this really approachable operations experience,
**[00:20:10]** which would be usable not only by a more IT persona,
**[00:20:13]** but actually an operations persona
**[00:20:15]** who maybe has specific knowledge
**[00:20:16]** about millimeter offsets and things like that.
**[00:20:20]** You can configure how data should flow
**[00:20:22]** from a discovered asset in your environment, in this case,
**[00:20:26]** the robot arm, up into a workspace in the cloud,
**[00:20:30]** and you can even transform that data here.
**[00:20:33]** For example, if you needed to do a unit conversion or add
**[00:20:36]** or remove additional properties, like in our example,
**[00:20:39]** we're just trying to see if the coordinates are safe to reach.
**[00:20:42]** For example, we could remove the z-coordinate,
**[00:20:44]** because it doesn't really matter here.
**[00:20:46]** You can do that through this very approachable interface,
**[00:20:49]** so that when the data arrives in Microsoft Fabric,
**[00:20:51]** it's ready for your data team to just interact with.
**[00:20:54]** It's already cleaned up.
**[00:20:55]** It's already formatted in a way that they'll understand.
**[00:20:58]** For us, we configured Azure IoT Operations to stream all
**[00:21:03]** of the coordinate requests from the robot.
**[00:21:05]** Every time that it is asked to go grab something
**[00:21:08]** at a particular location,
**[00:21:09]** it streams back what coordinates it was asked to grab from,
**[00:21:12]** and we can then analyze if those were safe or unsafe.
**[00:21:16]** All of that is coming in real time off of the system,
**[00:21:18]** so you can imagine if you were going to deploy this broadly,
**[00:21:21]** this would be an extremely valuable capability.
**[00:21:25]** Okay. Where does that leave us?
**[00:21:27]** Advances in AI together
**[00:21:29]** with Azure's Adaptive Cloud approach are making it easier
**[00:21:32]** than ever to build and operate intelligent physical systems.
**[00:21:36]** This year and I think in the years ahead, we are going
**[00:21:39]** to have to update our notion of what types
**[00:21:42]** of tasks it is possible to extend AI
**[00:21:45]** to with an agentic approach to robotics.
**[00:21:49]** If you're as excited about this as I am, I encourage you
**[00:21:51]** to get started right now.
**[00:21:53]** All of the things that we showed here are available off the shelf
**[00:21:56]** for you to try.
**[00:21:57]** The small form factor infrastructure is available
**[00:21:59]** in preview now.
**[00:22:00]** You can take it for a spin.
**[00:22:02]** Foundry Local as a container image for Linux,
**[00:22:05]** enabled by Azure Arc, is also available
**[00:22:07]** as a preview right now.
**[00:22:08]** You can go try that out for a scenario like ours
**[00:22:10]** or many other scenarios as well.
**[00:22:13]** Of course, last but not least,
**[00:22:14]** Azure IoT Operations is also available for you to try.
**[00:22:18]** All right.
**[00:22:19]** That's it for me.
**[00:22:20]** Thank you so much for watching and enjoy the rest of Build.
