**[00:00:00]** Hi everyone, I know this is lunchtime, but thank you
**[00:00:02]** for taking the time and coming here.
**[00:00:05]** My name is Sunita Muthukrishna.
**[00:00:07]** I'm APM on the Fabric app dev team.
**[00:00:09]** And this is Chris.
**[00:00:11]** He'll introduce himself.
**[00:00:12]** Hey everyone, I'm Chris.
**[00:00:13]** I'm also on the Fabric app dev team.
**[00:00:16]** All right, so today I'm hoping most of you guys
**[00:00:19]** attended the keynote and you probably saw the Ray Finn
**[00:00:22]** being brought up.
**[00:00:23]** So today we'll be kind of demoing you a little
**[00:00:25]** bit more about that before we go into the details.
**[00:00:28]** Let's go ahead to what the agenda looks like.
**[00:00:32]** I'll just give you a quick introduction of what Raefen
**[00:00:34]** is and go through the demo.
**[00:00:36]** But all of you probably have been building applications maybe
**[00:00:39]** by coding and stuff for a while.
**[00:00:41]** So have you guys seen this issue where your org
**[00:00:44]** is telling you I need you to build more stuff,
**[00:00:46]** be more productive and stuff like that.
**[00:00:49]** But then when you actually build those applications with some
**[00:00:51]** of your production, your production data or your production resources
**[00:00:55]** that you want to work with, it becomes pretty complex
**[00:00:57]** to actually end to end figure out how you're going
**[00:01:00]** to build the app, right?
**[00:01:02]** So this is where Rayfin comes into picture.
**[00:01:05]** And with Rayfin, you have a Code First SDK that
**[00:01:08]** makes it a lot more easier for you to figure
**[00:01:11]** out or define your data models, your roles, your permissions
**[00:01:14]** on on the data itself.
**[00:01:16]** And you get an CLI which allows you to quickly
**[00:01:19]** do local development, deploy it to Fabric.
**[00:01:22]** All of that is streamlined through the CLI experience.
**[00:01:25]** Now, since you're deploying to Fabric, you also get the
**[00:01:27]** enterprise grade security, governance and all the different capabilities that
**[00:01:30]** Fabric has to offer.
**[00:01:33]** Now, without waiting for too much time, get into the
**[00:01:35]** demo.
**[00:01:36]** It's 25 minutes.
**[00:01:37]** It's going to go pretty fast.
**[00:01:42]** Alright, so the first thing that we're going to do
**[00:01:45]** is just quickly create a simple application.
**[00:01:48]** You can run an NPM create command.
**[00:01:51]** This will ask you a few questions about do you
**[00:01:53]** want to start from a template?
**[00:01:56]** And you can quickly pick a template that you want
**[00:01:58]** to start with.
**[00:01:59]** We have a couple of months to choose from Indiana.
**[00:02:05]** This case I'm just creating a simple hello world application,
**[00:02:07]** which is A to do application.
**[00:02:10]** It takes a while for you to set up all
**[00:02:11]** the dependencies and stuff because you're starting from a template.
**[00:02:14]** So a lot of the things is pre baked into
**[00:02:16]** it and the way we've built it in such a
**[00:02:18]** way is like the template has all the skills and
**[00:02:21]** stuff that you need to work with any coding agent.
**[00:02:24]** So when you're working with coding agent and Rayfin, it
**[00:02:26]** should be pretty seamless.
**[00:02:27]** It understands the context and can give you build the
**[00:02:30]** application the way the SDK expects it to, right?
**[00:02:37]** Once the application is done, all you have to do
**[00:02:40]** is get into your actual project folder.
**[00:02:45]** All right, alright.
**[00:02:50]** And you, if you've seen the demo, you just do
**[00:02:53]** an upcoming.
**[00:02:54]** These are all the different options that you have.
**[00:02:56]** Now at the back end, we are deploying a database.
**[00:03:00]** You have your static content, you have the auth service
**[00:03:03]** as well.
**[00:03:04]** So here auth is fabric single sign on.
**[00:03:08]** So these are all the services that are baked in
**[00:03:10]** without you having to do any custom stuff to configure
**[00:03:14]** or set things up at this point.
**[00:03:19]** All right, now if you want to kind of go
**[00:03:21]** build a field operations app, like a building maintenance person
**[00:03:25]** has to go figure things out.
**[00:03:27]** So I can use copilot to actually provide a prompt.
**[00:03:30]** And all it does is uses the prompt information to
**[00:03:33]** figure out, OK, how do I create an application where
**[00:03:35]** a dispatcher can assign define jobs and a technician can
**[00:03:39]** get those jobs assigned to him and then execute on
**[00:03:41]** those jobs.
**[00:03:42]** So you have two different roles and the single application
**[00:03:45]** handles both those roles and all the different tools and
**[00:03:48]** capabilities that are needed to complete the work.
**[00:03:52]** Fast forward.
**[00:03:55]** Yes, it finished pretty quickly and now you can see
**[00:03:58]** there's a simple list of jobs that are already predefined.
**[00:04:01]** We have some canned data and stuff here because deployment
**[00:04:04]** can take a few minutes.
**[00:04:05]** Now there's a job called Stay Check.
**[00:04:08]** I'll let Chris talk to some of these things here
**[00:04:10]** on how he wants to execute the job.
**[00:04:12]** If you guys wouldn't mind helping me, you know, test
**[00:04:14]** the things out.
**[00:04:14]** Is the audience excited?
**[00:04:16]** Here we go.
**[00:04:17]** I'm going to say this is the pass.
**[00:04:19]** And then how big is the audience?
**[00:04:21]** And I'm not going to actually take the picture again
**[00:04:23]** because I lost the camera when I tried that.
**[00:04:24]** But, you know, go ahead and just give everybody else
**[00:04:27]** here a really nice, you know, high selfie from me.
**[00:04:40]** Cool.
**[00:04:40]** That was pretty neat, isn't it?
**[00:04:42]** Like quickly taking a picture.
**[00:04:43]** Imagine you're on site, you want to take pictures of
**[00:04:45]** the the tasks that you're working on and upload them.
**[00:04:48]** Now there's an issue that there's one of the job
**[00:04:50]** that doesn't make sense.
**[00:04:51]** It says GM it it's not very clear.
**[00:04:53]** So let's kind of ask Kopade to fix that because
**[00:04:56]** there's no way in the app right now to actually
**[00:04:59]** edit my title if I make a mistake.
**[00:05:02]** So all Chris is doing is providing some of the
**[00:05:05]** details.
**[00:05:06]** OK, make sure that I can edit the title and
**[00:05:09]** give the capability to the application.
**[00:05:17]** Now the copilot has a lot of context on the
**[00:05:20]** CLI as well as SDSDSDK.
**[00:05:22]** So anything that you need to kind of any action
**[00:05:25]** you want to take, you can just tell copilot to
**[00:05:27]** deploy it to Fabric.
**[00:05:28]** It should deploy it to Fabric using our CLI.
**[00:05:33]** Now this would require some database changes you would assume,
**[00:05:35]** right?
**[00:05:36]** I'm trying to make sure that I can edit the
**[00:05:38]** thing.
**[00:05:39]** I might have to make sure that there's a CRUD
**[00:05:40]** operation that actually manages these details, right?
**[00:05:43]** So Rafe and SDK allows you to define the data
**[00:05:47]** models.
**[00:05:47]** It also gives you the capability with a data client
**[00:05:50]** so you can perform perform all those operations.
**[00:05:53]** As part of that, Chris is going to take a
**[00:05:55]** look into the actual data models.
**[00:05:58]** So here you can see these are all the data
**[00:06:00]** models that are defined in code.
**[00:06:02]** Typically you would use T SQL, set up all your
**[00:06:04]** database schema, figure out all the relationships.
**[00:06:07]** This is everything in TypeScript code.
**[00:06:10]** You define your data models, you define your relationship, everything
**[00:06:13]** in code.
**[00:06:15]** Let's take a look at like the client services and
**[00:06:19]** now any data application that is correct operations, right?
**[00:06:24]** You have to do a create, select, read, write data
**[00:06:26]** and stuff like that.
**[00:06:28]** So here you can see that there's a simple client
**[00:06:31]** capability in our SDK as well, which allows you to
**[00:06:34]** perform all those operations.
**[00:06:36]** I can update data, I can read from the data,
**[00:06:38]** I can query multiple rows, I can create, I can
**[00:06:41]** do a lot of the CRUD operations just through using
**[00:06:44]** the client rather than having to write this from scratch,
**[00:06:48]** right?
**[00:06:53]** Did Copilot actually finish it, Chris?
**[00:06:57]** Yeah, looks like actually finished 40 seconds ago.
**[00:07:01]** OK, let's check it out if it actually worked.
**[00:07:03]** Let's go ahead and just make sure everything's actually installed
**[00:07:08]** in this work tree.
**[00:07:19]** There you go.
**[00:07:21]** And run dev and then here is a.
**[00:07:23]** So now you can you can run the application locally
**[00:07:26]** as well to test out your changes.
**[00:07:28]** So we're running this out locally.
**[00:07:31]** You can see there's a Docker composed.
**[00:07:32]** So because it's running on my local machine Docker setup,
**[00:07:34]** all of those things are set up in such a
**[00:07:36]** way so that I can evaluate if my changes are
**[00:07:38]** good before I actually push it to Fabric again.
**[00:07:47]** Now under the hood, it's spinning up all the back
**[00:07:49]** end services.
**[00:07:49]** So it's actually spinning the database locally.
**[00:07:51]** It's spinning the Rayfin service locally as well.
**[00:07:56]** So once all of this is set up, it's up
**[00:08:00]** and running and you should be able to sign in.
**[00:08:09]** And once you sign in, let's see if we can
**[00:08:12]** actually edit the title.
**[00:08:15]** Now, obviously on your local machine, you're not going to
**[00:08:17]** have all the production data, right?
**[00:08:19]** So he's just going to test it out to see
**[00:08:21]** if things are working on your local machine.
**[00:08:23]** Once you deploy the changes, all you have to do
**[00:08:25]** is do a Raven up and that should allow me
**[00:08:27]** to deploy my changes to the item that's already there
**[00:08:30]** in Fabric.
**[00:08:38]** All right, if anyone's familiar with Fabric, you have a
**[00:08:45]** workspace so you can figure out, provide the information about
**[00:08:52]** which workspace you want to deploy it to and then
**[00:08:57]** you can deploy it to that.
**[00:09:01]** This gives you a lot more control as if I
**[00:09:03]** want to deploy to a different workspace you can do
**[00:09:05]** it as well.
**[00:09:06]** Instead of the day, so I'm pushing straight to prod.
**[00:09:09]** Yes, testing in prod is fun too sometimes.
**[00:09:21]** Alright, it takes a minute, but it's actually you can
**[00:09:24]** see some of the details that's coming out in the
**[00:09:26]** output.
**[00:09:27]** It's actually checking for the database changes, schema changes, what
**[00:09:30]** happened?
**[00:09:31]** Should I apply some schema changes?
**[00:09:32]** It's also validating.
**[00:09:33]** OK, I need to deploy the static content, right?
**[00:09:39]** Let's refresh the page and see if we can edit
**[00:09:43]** the task.
**[00:09:50]** There you go.
**[00:09:54]** So this was the whole development life cycle of the
**[00:09:57]** app from beginning to finish.
**[00:10:00]** And this, since this is running in Fabric, imagine this
**[00:10:02]** is talking to your production data and stuff like that.
**[00:10:05]** So you can see how seamless it was.
**[00:10:07]** You don't have to figure out how do I connect
**[00:10:09]** to a database.
**[00:10:09]** You don't have to figure out how do I set
**[00:10:11]** up the auth service because it's using Fabric single sign
**[00:10:14]** on.
**[00:10:14]** Now the application here, you can see it's on the
**[00:10:17]** browser, right?
**[00:10:18]** But you also have an embedded view.
**[00:10:20]** So think of imagining like internal applications, right?
**[00:10:24]** You want to view it within your Fabric portal.
**[00:10:26]** You can view it inside your Fabric portal as well.
**[00:10:34]** So you have the embedded view, you have all the
**[00:10:36]** properties and stuff to manage your application.
**[00:10:38]** Although your local development life cycle is on VS Code.
**[00:10:47]** Alright, you.
**[00:10:48]** Want to try another feature?
**[00:10:49]** Yes.
**[00:10:50]** Right, which one you want to do?
**[00:10:52]** Let's see, what can we do?
**[00:11:00]** What do you have in mind?
**[00:11:03]** I'm not sure.
**[00:11:04]** There's so many features coming to my mind right now.
**[00:11:06]** What about the issue where I'm not sure if I
**[00:11:08]** actually am assigned this task or not?
**[00:11:11]** That's nice.
**[00:11:13]** I didn't know who this assign is assigned to anyway,
**[00:11:15]** so I think let's do that.
**[00:11:16]** Let's go ahead and assign it to somebody and so
**[00:11:18]** we can view those details and then.
**[00:11:20]** We're going to do one other cool trick, which is
**[00:11:25]** if I go back here and do PM run dev
**[00:11:28]** local all over again.
**[00:11:31]** Sometimes when you have too much fun with tools, you
**[00:11:33]** want to build so many things.
**[00:11:37]** What's fun is that before this GitHub Copilot desktop app,
**[00:11:40]** this demo ran a little bit longer, so we usually
**[00:11:43]** have a couple of extra bugs to go shoot out,
**[00:11:46]** so it was nice.
**[00:11:52]** So I'm getting my local dev environment up and running
**[00:11:55]** again, just talking to myself and we're going to go
**[00:11:59]** and try out SO.
**[00:12:00]** You guys have seen the demo with the GitHub Copilot
**[00:12:02]** app on the keynote.
**[00:12:04]** That's exactly what he's using here.
**[00:12:06]** It gives you a lot of the capabilities like one
**[00:12:08]** stop shop for everything to actually manage the whole life
**[00:12:11]** cycle.
**[00:12:20]** One good advantage of using like Rayfin with coding agents
**[00:12:24]** is because everything is code first.
**[00:12:27]** It has a lot of context and understands and they
**[00:12:29]** do a pretty good job to stay within the boundaries
**[00:12:31]** defined by the SDK.
**[00:12:32]** So if you say this is these are the rules,
**[00:12:34]** these are my boundaries play within this context.
**[00:12:37]** It's it's comfortable enough to understand that and is able
**[00:12:40]** to work within that.
**[00:12:42]** So you can re imagine any kind of application could
**[00:12:45]** be a line of business app, it could be a
**[00:12:47]** customer facing app, but there's a lot of potential based
**[00:12:50]** on what you want to build.
**[00:12:52]** All right, now let's see if this new feature didn't.
**[00:13:02]** Reset the config properly.
**[00:13:04]** Let's try one more time.
**[00:13:09]** Live demo.
**[00:13:17]** Alright, while this is spinning, do you guys actually build
**[00:13:23]** apps and stuff?
**[00:13:25]** For how many of you raise your hand If you
**[00:13:29]** build apps for as a full time job and for
**[00:13:32]** fun too, that's included.
**[00:13:36]** Alright, you did notice that there was a username password
**[00:13:43]** there.
**[00:13:43]** That's for local testing.
**[00:13:45]** So this way you have like your Fabric single sign
**[00:13:48]** on once you're in production, but you have local testing
**[00:13:51]** for like username and password.
**[00:13:52]** So it gives you a little bit of flexibility to
**[00:13:54]** play with like test data versus your production data.
**[00:14:02]** All right, let's just ask Copilot again to see who's
**[00:14:07]** assigned.
**[00:14:09]** And I'm able to use this cool pick and Polish
**[00:14:11]** feature here, so I can go ahead and actually select
**[00:14:13]** the item that I'm talking about rather than trying to
**[00:14:15]** refer to it vaguely.
**[00:14:25]** Alright, it's going to run through a few of the
**[00:14:29]** checks in terms of like figuring out how it's going
**[00:14:33]** to build this thing.
**[00:14:35]** But so far what I've shown you is a simple
**[00:14:37]** and easy way leverage coding agents, leverage the Rayfin SDK,
**[00:14:42]** build your end to end applications.
**[00:14:45]** Do all of you use Fabric as well?
**[00:14:49]** Yes.
**[00:14:50]** OK.
**[00:14:51]** Have you used it only for data so far?
**[00:14:54]** How many guys, how many of you guys are going
**[00:14:57]** to try this out so?
**[00:15:05]** And then it wants me to sign back in again.
**[00:15:08]** Yes, right now.
**[00:15:15]** Let's see, time to test things out.
**[00:15:20]** It's still trying.
**[00:15:22]** It still hasn't worked.
**[00:15:23]** What's interesting there is that it recognized that it wasn't
**[00:15:25]** showing up in the UI.
**[00:15:26]** So it's going and trying another thing, which is it's
**[00:15:28]** nice when you've got the kind of embedded view here
**[00:15:31]** with the copilot app because it can actually go and
**[00:15:33]** manipulate the UI for you.
**[00:15:34]** You don't need to stand up, you know, Playwright or
**[00:15:36]** something like that as a separate tool.
**[00:15:37]** It can still go use Playwright.
**[00:15:38]** So if it needs to open up an external browser
**[00:15:40]** to do that, it can still do those things.
**[00:15:41]** But it's really nice having it just kind of right
**[00:15:44]** here inside of the editor itself.
**[00:15:48]** Now it's adding the assigned drop down.
**[00:15:50]** So let's give that a shot.
**[00:15:52]** There you go.
**[00:15:52]** And you can see this one actually wasn't designed to
**[00:15:54]** myself, so I'm going to go ahead and fix that
**[00:15:56]** now.
**[00:15:58]** And if I go back to this, let's see does
**[00:16:03]** it work?
**[00:16:05]** Yep.
**[00:16:11]** So we've added a couple of features already in this
**[00:16:14]** really short time.
**[00:16:17]** Now this, this is a pretty easy way to kind
**[00:16:19]** of keep on iterating till you get the kind of
**[00:16:21]** application that you're thinking of building.
**[00:16:24]** And you didn't have to really spend a lot of
**[00:16:26]** time trying to understand the details or the logistics of
**[00:16:28]** all the things that actually it takes to actually build
**[00:16:31]** an application today.
**[00:16:34]** And again, if you want to deploy it, you can
**[00:16:36]** deploy it to Fabric and you kind of iterate the
**[00:16:38]** whole loop.
**[00:16:38]** This is kind of your development life cycle loop at
**[00:16:40]** this point.
**[00:16:42]** Anyone has any questions, maybe just raise your hand.
**[00:16:45]** Let me know any questions.
**[00:16:54]** Graph QL, I think Graph QL is just an API
**[00:16:58]** at this point, right?
**[00:16:59]** Graph Graph QL you use it for data access to
**[00:17:02]** pull information that you want to across multiple sources.
**[00:17:06]** Sorry, yes you can write data back as well.
**[00:17:10]** But this is using Graph QL under the hood for
**[00:17:13]** all the credit operations.
**[00:17:15]** So it's not like a different thing.
**[00:17:16]** But you're building an application sometimes, right?
**[00:17:20]** You're thinking of an end to end solution that you're
**[00:17:22]** trying to build.
**[00:17:23]** So for the end to end solution, you have different
**[00:17:25]** pieces and components you want to work with.
**[00:17:27]** Graph QL might be 1 component, but maybe I want
**[00:17:30]** to work with a SQL database.
**[00:17:31]** Maybe I want to work, I want to have the
**[00:17:33]** auth service with fabric sign on.
**[00:17:35]** If you want to do custom stuff for that, it
**[00:17:37]** takes a while to build those things.
**[00:17:39]** So you're getting a lot of it out-of-the-box.
**[00:17:41]** So when I share my application with you, if you
**[00:17:43]** have the right permissions, you can log in.
**[00:17:45]** You don't have the right permissions, you can't log in.
**[00:17:47]** So there are a lot of benefits because you're getting
**[00:17:51]** the the whole package, your hosting, your back end plus
**[00:17:55]** auth all of that in one one product.
**[00:18:09]** I'll iterate her question.
**[00:18:11]** She was asking can we deploy it to a capacity?
**[00:18:15]** So it's an item inside of fabric.
**[00:18:18]** So if you're familiar with fabric, fabric has you create
**[00:18:20]** a workspace, you can add an item to it.
**[00:18:23]** So this is just another item called app.
**[00:18:25]** You can go create the item inside any workspace you
**[00:18:28]** want, and whatever capacity it's attached to, that's the capacity
**[00:18:32]** that you get to work with the application.
**[00:18:35]** It's the same CU model.
**[00:18:37]** There's nothing different that you're going to see in terms
**[00:18:39]** of your billing and stuff like that.
**[00:18:41]** And all the services that come under the hood, which
**[00:18:43]** is the fabric SQL database for database and for the
**[00:18:46]** reference service, the hosting, but you're only going to get
**[00:18:48]** charged for some of the child services there.
**[00:18:50]** That's it.
**[00:19:16]** Before, because we have 5 minutes, maybe you want to
**[00:19:18]** show the slide on the resources for the next step.
**[00:19:23]** So I'll, I'll ask her a question again just so
**[00:19:26]** everyone hears.
**[00:19:27]** So she was asking is how do I make it
**[00:19:30]** discoverable across my organization.
**[00:19:33]** So the you have a share option because it's an
**[00:19:36]** item, the same fabric permission model that you would see.
**[00:19:39]** So you can share it with anyone within your organization
**[00:19:42]** through the link.
**[00:19:44]** They can have access to the application because at the
**[00:19:46]** end of the day, it's an application.
**[00:19:47]** You have a URL for the app to access, but
**[00:19:50]** the user has to have explicit permissions of actually executing
**[00:19:53]** stuff because under the hood, you're working with data.
**[00:19:57]** So you want to make sure that the right person
**[00:19:59]** on your team or organization has access to the data.
**[00:20:02]** So you don't want to give it to everyone else.
**[00:20:03]** So in the Fabric portal itself, you provide like, OK,
**[00:20:06]** these are the people who have access to run and
**[00:20:09]** interact with the applications.
**[00:20:11]** These are the people who have access to collaborate with
**[00:20:14]** me on the applications.
**[00:20:15]** You have all of those capabilities but uses the same
**[00:20:18]** fabric permission model.
**[00:20:21]** Alright.
**[00:20:22]** We have 3 minutes left and I do want to
**[00:20:24]** kind of let you guys know is here's the documentation
**[00:20:28]** and we have a GitHub repository.
**[00:20:30]** You want to go check out some of the stuff
**[00:20:31]** about the product.
**[00:20:33]** We have 4 labs that Chris is driving along with
**[00:20:36]** a few folks from my team as well.
**[00:20:39]** So if you want to kind of give it a
**[00:20:41]** shot, try it.
**[00:20:42]** Please, please come and join the labs and check it
**[00:20:45]** out.
**[00:20:47]** I'll be at the export booth today at 2:30.
**[00:20:50]** So you want to come and chat?
**[00:20:52]** Find me there.
**[00:20:55]** Any other questions?
**[00:20:56]** We have a couple more minutes.
**[00:20:57]** I wanted to make sure if anyone has any other
**[00:20:59]** questions.
**[00:21:00]** That's right.
**[00:21:02]** Sorry.
**[00:21:04]** I think there's a fabric AI booth here.
**[00:21:07]** Yeah, here.
**[00:21:08]** Yeah.
**[00:21:11]** You have a question?
**[00:21:12]** Yes, I think.
**[00:21:16]** It was the initial thing he did where it was
**[00:21:17]** to change the title.
**[00:21:18]** I noticed that he said please update the fabric stuff
**[00:21:22]** or something as part of that process.
**[00:21:25]** Do you recall that?
**[00:21:25]** I'll ask him.
**[00:21:27]** I was curious.
**[00:21:28]** What might fail if you get it doesn't need to,
**[00:21:30]** because I've tried it without providing all that context and
**[00:21:33]** it's worked for me.
**[00:21:34]** But I think I'll let everyone know before I talk
**[00:21:38]** to it.
**[00:21:41]** No.
**[00:21:42]** So when we were editing the feature, when we were
**[00:21:46]** adding the feature for editing the title, so I think
**[00:21:49]** there was some text about Fabric that was in the
**[00:21:52]** in the prompt that was.
**[00:21:53]** The question is, do I need to provide that Fabric
**[00:21:55]** context?
**[00:21:56]** I think the only time you need to provide the
**[00:21:58]** Fabric context is if you are deploying to Fabric.
**[00:22:01]** So if I'm telling the copilot deploy to Fabric, I
**[00:22:04]** say deploy to Fabric.
**[00:22:06]** And because we have the CLI and the copilot is
**[00:22:08]** aware of the CLI, it will just do a Rayfin
**[00:22:11]** up under the hood.
**[00:22:13]** Now it should have the context information.
**[00:22:15]** OK, which workspace do I deploy it to and things
**[00:22:18]** like that.
**[00:22:19]** So if it doesn't have the context, it will probably
**[00:22:20]** ask you.
**[00:22:21]** But that's the only time you call out Fabric is
**[00:22:24]** hey, now, I think the apps kind of ready.
**[00:22:27]** Let me push it to Fabric.
**[00:22:28]** That's the only time.
**[00:22:29]** But development time you don't really need to.
**[00:22:32]** Its you figure out what you want the app to
**[00:22:35]** look like, feel like and you keep iterating on it.
**[00:22:41]** Anything you want to add, Chris?
**[00:22:42]** We have a couple minutes left.
**[00:22:43]** Yeah, one one last thing I'll show it's, it's mentioned
**[00:22:47]** there on the the Rayfin repo pieces as well.
**[00:22:50]** But obviously like all the other sessions, as you'll see
**[00:22:52]** here, there's a accompanying GitHub repo that contains the source
**[00:22:55]** code that we kind of shared with today.
**[00:22:57]** But what's also cool is that that template that we
**[00:23:00]** have that we use for the demo today is also
**[00:23:03]** checked into our awesome Rayfin repo.
**[00:23:05]** We're accepting community contributions for templates and other things that
**[00:23:08]** people think are cool here.
**[00:23:10]** So you can try out this demo yourself by, you
**[00:23:12]** know, following the instructions to install the field engineer demo.
**[00:23:16]** You see here, there's a very simple NPM create command
**[00:23:19]** where you basically just pass the template that you want
**[00:23:21]** it to use and it will go ahead and automatically
**[00:23:24]** install that for you.
**[00:23:25]** All the things that you saw it initially doing when
**[00:23:27]** we started out the demo.
**[00:23:27]** So if you've got new features for field technician, I'm
**[00:23:30]** I'm always open to new features being added there.
**[00:23:33]** If you want to add a new template, by all
**[00:23:35]** means, please send a new template and you can also
**[00:23:37]** use that same pattern as well by simply just passing
**[00:23:40]** any GitHub URL that has a Raifen template in it.
**[00:23:43]** You can use that even for your own private template
**[00:23:44]** marketplaces inside of your company as well.
**[00:23:46]** So definitely recommend trying checking out those marketplace pieces.
**[00:23:50]** I will when this gets done, check this into a
**[00:23:52]** branch for the demo thing.
**[00:23:54]** So it's been very interesting watching it work.
**[00:23:56]** It's been using the new canvas stuff to actually go
**[00:23:58]** and invoke JavaScript in like the console on the canvas
**[00:24:00]** page to go try to figure out what's going wrong
**[00:24:02]** with the state machine that's, you know, driving this thing.
**[00:24:05]** So yeah, you know, very much definitely try out Rayfin.
**[00:24:09]** Of course, Rayfin's great.
**[00:24:10]** Try out the new GitHub copilot app if you haven't
**[00:24:12]** already tried that out, and then try using them together.
**[00:24:15]** It's a really great combination.
**[00:24:16]** Thanks everyone.
**[00:24:17]** Thank you so much everyone for staying around and watching
**[00:24:20]** us talk in demo.
