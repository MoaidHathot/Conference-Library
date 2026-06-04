**[00:00:02]** CHRIS ANDERSON: Hi.
**[00:00:03]** Thanks for watching the video.
**[00:00:04]** My name is Chris Anderson.
**[00:00:05]** I'm an Engineer on the Windows UI team,
**[00:00:07]** working on some new experimental frameworks features
**[00:00:11]** going forward.
**[00:00:11]** And I want to talk about some of the stuff
**[00:00:13]** that we've been working on behind the scenes
**[00:00:15]** and really trying to move this to more of in the public.
**[00:00:18]** So welcome.
**[00:00:21]** First, I really want to spend the time, before I dive
**[00:00:23]** into the new and exciting things that I think are attractive
**[00:00:28]** and shiny bobbles in the feature, I want to talk
**[00:00:31]** about the stuff that we need to get going
**[00:00:33]** so that we can earn the right to build some of these things.
**[00:00:35]** And this is really the core features
**[00:00:38]** that people have been asking for and really need
**[00:00:41]** to be productive on top of WinUI.
**[00:00:43]** The first and foremost is performance, fundamentals,
**[00:00:46]** quality, fixing a lot of bugs.
**[00:00:48]** On the performance side, we've invested heavily
**[00:00:51]** in really improving memory usage as well as switching
**[00:00:55]** over to a system compositor,
**[00:00:56]** which should yield some even better performance improvements.
**[00:00:59]** And this stuff all actually hit the public in our Git repo.
**[00:01:03]** And so it should be available to go play with today.
**[00:01:06]** And there will be WinApp SDK versions
**[00:01:08]** that incorporate these changes available shortly
**[00:01:10]** through the experimental preview branches.
**[00:01:13]** We're also adding in a lot of new controls.
**[00:01:15]** We have DataGrid and Charting that are up and coming
**[00:01:18]** that should be out relatively shortly.
**[00:01:19]** These will be showing up in the core WinUI bits
**[00:01:21]** and will allow you to go after a lot more
**[00:01:24]** of these data-oriented scenarios.
**[00:01:26]** One of the big things that I'm personally really excited
**[00:01:28]** about is for us to complete our journey to open source.
**[00:01:31]** We've started on this path quite a while ago.
**[00:01:33]** We recently hit our Phase 3,
**[00:01:35]** which was when we could actually run tests in public.
**[00:01:37]** And so anyone can grab the bits, compile WinUI,
**[00:01:40]** and then run the test to make sure that they have something
**[00:01:42]** that is fully functional.
**[00:01:43]** If they want to make changes, they can run the test
**[00:01:44]** and make sure they haven't broken anything,
**[00:01:45]** which is an important part of having an open source library.
**[00:01:48]** The big next phase for us is Phase 4.
**[00:01:51]** And really, that is where we move the team
**[00:01:53]** from using internal source repos to working primarily
**[00:01:58]** and almost exclusively in the public repos.
**[00:02:01]** And so you'll see the team start to land all
**[00:02:03]** of their pull requests in the public repo side of it.
**[00:02:06]** And that's really just about getting to a place
**[00:02:08]** where we can accept changes from the community, we can engage
**[00:02:10]** in the community, and the community can see the work
**[00:02:12]** instantly as soon as we've got it going.
**[00:02:15]** With these changes, we've really heard a common set of themes.
**[00:02:18]** Probably the number one thing is,
**[00:02:22]** are you guys actually serious this time?
**[00:02:23]** Are you going to stick with this framework?
**[00:02:25]** WinUI 3 is four years old.
**[00:02:29]** Are you going to keep going, or is this the year
**[00:02:31]** that you're going to announce a brand-new framework yet again?
**[00:02:33]** And I will say that, no, we have no intention
**[00:02:35]** of building a new framework.
**[00:02:37]** In fact, we're dropping the number, and we're referring
**[00:02:39]** to WinUI as just WinUI because we have no intention
**[00:02:42]** of really making a massive shift, breaking change on it.
**[00:02:46]** And we're really trying to push hard to stretch WinUI
**[00:02:49]** to be accessible for any use case that we want.
**[00:02:52]** We've started to integrate it into the shell
**[00:02:54]** at a much faster rate.
**[00:02:55]** And so you're going to see a lot
**[00:02:57]** of the first-party features coming
**[00:02:58]** from Microsoft being built on top of WinUI.
**[00:03:01]** And we hope to see a lot
**[00:03:02]** of third-party developers really start to adopt it.
**[00:03:05]** We've seen some pickup already, but we know that the move
**[00:03:09]** to adopt a new UI framework can take a long time,
**[00:03:12]** especially in enterprise spaces.
**[00:03:13]** And so we see this as our time to really start showing
**[00:03:17]** that we are putting our muscle behind this
**[00:03:19]** and that we're committed to move WinUI forward.
**[00:03:21]** And that is fully our intention.
**[00:03:24]** The second thing we've heard a lot is, beyond DataGrid
**[00:03:26]** and Charting, there's just a ton of feature gaps in the platform.
**[00:03:30]** Everything from what are you doing on system tray?
**[00:03:32]** And you have limited use of Windows.
**[00:03:34]** A bunch of people use open source libraries
**[00:03:36]** to fix these gaps, and can we just get the platform fixed?
**[00:03:39]** And so we have a large backlog.
**[00:03:41]** We're going to start working through that
**[00:03:42]** and really start trying to address the feature gaps
**[00:03:45]** that people are calling out.
**[00:03:46]** But it's been one of the biggest issues.
**[00:03:48]** The third thing that is a constant source
**[00:03:51]** that people bring up is, how are we going to migrate?
**[00:03:54]** How are we going to go from the current set
**[00:03:55]** of frameworks we have?
**[00:03:57]** Can we just incrementally adopt WinUI?
**[00:03:59]** Or are you making an all-or-nothing proposition
**[00:04:01]** where you have to rewrite everything?
**[00:04:03]** We have a reasonable story of WinForms interop today.
**[00:04:07]** It's not great, but it's a reasonable story.
**[00:04:08]** It works pretty well.
**[00:04:10]** But we want to build on that.
**[00:04:11]** We want to make it that that should be a bulletproof part
**[00:04:13]** of the story, that WinForms interopting with WinUI
**[00:04:16]** in either direction should be just super easy to do.
**[00:04:20]** So we intend to do that.
**[00:04:20]** We want to make WPF migration equally good
**[00:04:23]** that you should be able to mix and match WPF
**[00:04:25]** and WinUI with no problems.
**[00:04:27]** And so that's a big chunk of work that we want
**[00:04:30]** to get to in the future.
**[00:04:31]** What we've also seen is that the development style is changing
**[00:04:37]** quite a bit.
**[00:04:38]** The AI assistance has changed the way people write software.
**[00:04:42]** It's changed the way I write software.
**[00:04:43]** I rarely type semicolons anymore.
**[00:04:46]** I'm almost always using AI to drive most
**[00:04:48]** of the code that I'm writing.
**[00:04:49]** I use it for code reviews, for writing tests.
**[00:04:54]** I have it help me with specs.
**[00:04:55]** It's like this whole notion of this AI shift has really,
**[00:04:58]** really transformed the way you write all the code.
**[00:05:02]** At the same time, we've seen this journey of more
**[00:05:04]** and more dynamic UI continue.
**[00:05:08]** It accelerated in a lot of ways.
**[00:05:10]** And I look at things like SwiftUI, Compose,
**[00:05:13]** and React as examples of the best practice
**[00:05:16]** in the industry today for building these dynamic UI.
**[00:05:19]** And it becomes super straightforward to build things
**[00:05:22]** that are incredibly flexible and responsive
**[00:05:24]** to what the user does.
**[00:05:25]** And so that's another trend that we really see.
**[00:05:28]** And the second one is really this notion of getting to code
**[00:05:31]** as the primary way to write things.
**[00:05:33]** On one way, you can say that this move
**[00:05:35]** to CLI-based coding tools with Claude Code, GitHub Copilot,
**[00:05:40]** things like this have led to Visual Studio Code becoming one
**[00:05:45]** of the most productive places to be to work on your project
**[00:05:48]** with your terminal window next to you.
**[00:05:50]** And this really gets to a world
**[00:05:51]** where code first becomes the de facto standard.
**[00:05:54]** And so what we really want to do is get C#
**[00:05:57]** as a primary way to target WinUI.
**[00:06:01]** We want to elevate C# from being a way to do code behind for XAML
**[00:06:05]** to a way that you can actually write an entire application.
**[00:06:08]** So you should be able to build an existing WinUI framework,
**[00:06:12]** use the controls, the templates.
**[00:06:15]** All of those features should be accessible
**[00:06:17]** from a C#-first experience.
**[00:06:19]** Several of those are currently locked behind needing
**[00:06:21]** to have XAML.
**[00:06:22]** And so we really want to bring C# up to parity.
**[00:06:25]** We're also announcing today a new experimental framework,
**[00:06:28]** which is called Reactor.
**[00:06:31]** Microsoft UI Reactor is a way for us to experiment
**[00:06:36]** with the new styles of programming, new controls,
**[00:06:39]** and new app models as we think about it.
**[00:06:43]** The Reactor repository, you should think of as a place
**[00:06:46]** for us to experiment with ideas
**[00:06:48]** that we don't necessarily have full conviction behind,
**[00:06:51]** and that we really want to engage with the community
**[00:06:52]** and do development out in the open.
**[00:06:54]** And so it was started as an open project.
**[00:06:56]** It is very early.
**[00:06:58]** It is a high churn rate.
**[00:07:01]** We're changing lots of the code on a daily basis.
**[00:07:04]** So you should really think of this as a place that is open
**[00:07:08]** for a ton of feedback, a ton of guidance from the community,
**[00:07:12]** a ton of participation from the community.
**[00:07:13]** We already have PRs landing from some of the community,
**[00:07:16]** and we would like to get more.
**[00:07:18]** And the idea is that as we find good ideas
**[00:07:20]** and as we bake those ideas, we'll be pushing them
**[00:07:21]** down into the production WinUI bits, and that they will,
**[00:07:25]** at that point, become consistent and standard
**[00:07:28]** across the WinUI stack so that it doesn't stand out.
**[00:07:31]** So you may see things that look foreign in the Reactor layer.
**[00:07:34]** And really don't panic about that stuff.
**[00:07:37]** It is a place for us to try these ideas out and then see
**[00:07:40]** which of these makes sense to go get pushed in.
**[00:07:42]** So really, the main action I would say
**[00:07:44]** for people watching this video today is please pick up WinUI.
**[00:07:48]** Go build something with it.
**[00:07:49]** Keep using it.
**[00:07:50]** Keep making it forward.
**[00:07:51]** We have no plans on deviating off
**[00:07:54]** that as our primary way of moving forward.
**[00:07:56]** We're investing in it.
**[00:07:57]** We hope that you will too.
**[00:07:59]** And then the last thing is, let's go try out Reactor.
**[00:08:01]** Give us feedback.
**[00:08:02]** Go clone the repo and try it out.
**[00:08:04]** Let's start by diving in and showing you what's
**[00:08:06]** in the new Reactor repo, and let me show you that.
**[00:08:12]** Let's dive right into Microsoft UI Reactor,
**[00:08:15]** which is a new open source project that we're releasing
**[00:08:19]** that shows the future direction
**[00:08:22]** that we're thinking of for WinUI.
**[00:08:24]** It includes a bunch of controls that are experiences
**[00:08:27]** that we think are going to be delivered as part
**[00:08:28]** of the core WinUI bits using the XAML you know and love,
**[00:08:31]** data binding, the MVVM architecture,
**[00:08:34]** all the features you're looking for.
**[00:08:35]** As well, there's included
**[00:08:37]** in the project a new domain-specific language
**[00:08:40]** or a new projection into C# for all
**[00:08:43]** of the WinUI controls that are out there.
**[00:08:46]** And this allows you to use C#
**[00:08:48]** with your primary programming experience if you're the person
**[00:08:51]** who would like to do a more functional,
**[00:08:52]** reactive-style approach as opposed
**[00:08:56]** to an XAML-based approach.
**[00:08:58]** The library itself, if you go look at the open source project,
**[00:09:02]** you'll find that almost everything
**[00:09:03]** in there is written using this new C# style.
**[00:09:06]** That's mostly because we wanted to experiment
**[00:09:08]** with this new style of programming
**[00:09:11]** as we built these controls to see what it felt like
**[00:09:13]** and where the edges were of the thing of it.
**[00:09:16]** We don't really expect that this is going to be the right way
**[00:09:19]** to build most of these controls.
**[00:09:21]** A lot of them are going to be integrated directly into WinUI.
**[00:09:24]** They'll be written in C++ using the same WinRT frameworks
**[00:09:26]** that you're familiar with.
**[00:09:28]** This is just more of a way for us to experiment and learn.
**[00:09:31]** And so don't take that just because you see DataGrid that's
**[00:09:34]** in there, that's written using this Reactor-style syntax,
**[00:09:38]** it doesn't mean that's how we're going
**[00:09:39]** to eventually ship the DataGrid.
**[00:09:40]** This is more of just an experimental playground.
**[00:09:42]** This is a good time to give this context
**[00:09:44]** on what I mean by experimental.
**[00:09:46]** This is a place where we are likely to change every line
**[00:09:49]** of code in this project.
**[00:09:50]** We are very early.
**[00:09:51]** We want to do the development out in the open,
**[00:09:53]** which means that we're going to change a lot of things.
**[00:09:55]** We're going to change the syntax.
**[00:09:56]** The current syntax is using this fluent functional style
**[00:09:59]** expression, but that may completely change.
**[00:10:02]** We're working with the C# team about the right way
**[00:10:04]** to express these kinds of construction patterns.
**[00:10:08]** And we really want to do it in a way
**[00:10:09]** that feels very natural in the language.
**[00:10:11]** And so we're going to iterate.
**[00:10:12]** We're going to change a lot of stuff.
**[00:10:13]** Now is really a chance for you to play with the team
**[00:10:16]** in the project and take a look.
**[00:10:17]** We've already had some contributors from outside
**[00:10:20]** of the company who've added some new features to the product
**[00:10:23]** and have given a lot of feedback, have issued some PRs.
**[00:10:26]** So we're really looking forward to collaborating
**[00:10:28]** with the community on all of this.
**[00:10:31]** So let's dive in and look at the code and how this functions.
**[00:10:34]** So we see here we have a "ReactorApp.Run,"
**[00:10:37]** which is just starting up the project, creates a window.
**[00:10:39]** The devtools flag, we'll talk about it a little bit.
**[00:10:42]** It's something that you'd normally only put
**[00:10:43]** in a debug build of your product.
**[00:10:45]** And then here we have a component,
**[00:10:46]** which is the main unit of composition.
**[00:10:48]** And we "override Element Render," create a title bar,
**[00:10:50]** heading, text block, put it in a flex column.
**[00:10:52]** And that's what you see over here on the left.
**[00:10:54]** So the first thing I'm going to say is
**[00:10:55]** that the text block is hard to see,
**[00:10:57]** so let's just make the font size larger.
**[00:11:01]** We'll save, and then we're going to come over here,
**[00:11:05]** and we'll create a flex column because I want
**[00:11:08]** to take this header and Hello text
**[00:11:11]** and indent them a little bit.
**[00:11:13]** So I'm going to just say "Margin24," and then I also want
**[00:11:19]** to have it occupy all the space.
**[00:11:20]** So I'm going to say "grow:1, basis:0."
**[00:11:25]** Save that, and we see that the app is updating.
**[00:11:27]** Down here on the bottom left,
**[00:11:28]** I'm just running a normal standard.NET watch command,
**[00:11:33]** and up on the left is the app running.
**[00:11:34]** At some point, this might crash.
**[00:11:36]** It turns out hot reload, not always the most stable.
**[00:11:38]** We will see how this goes.
**[00:11:40]** But in the meantime, we can just continue to iterate.
**[00:11:44]** So we can see basically hot reload is working.
**[00:11:46]** We can create our functions.
**[00:11:48]** We have a nesting.
**[00:11:49]** In this case, we can do imperative construction.
**[00:11:52]** We can also do more of your expression-based construction.
**[00:11:55]** Whatever you'd like to do, it's your place to play.
**[00:11:58]** Let's make this interactive, though.
**[00:12:00]** So let's create some state.
**[00:12:01]** So we'll say we want a count, UseState.
**[00:12:06]** It could be 0.
**[00:12:07]** And then we'll just have a name.
**[00:12:09]** Feels like what you need to do.
**[00:12:14]** And we'll just say "name."
**[00:12:18]** And then we'll go update our text here.
**[00:12:26]** And we'll just use "name."
**[00:12:28]** And then we'll say "count: count."
**[00:12:32]** Great. So we see it updates.
**[00:12:34]** We got the name of the text.
**[00:12:35]** And like you see, as you'd expect,
**[00:12:37]** you can do any C# function you want in here.
**[00:12:40]** Let's make this interactive.
**[00:12:42]** So the first thing we'll do is we'll add a "nameField."
**[00:12:48]** And we'll just say it takes a name and it sets a name.
**[00:12:51]** And then we'll have a row of buttons.
**[00:12:56]** We'll just have a "FlexRow."
**[00:12:58]** And we'll create a button that's "-."
**[00:13:05]** And for that, we'll just say set count to "count -1."
**[00:13:11]** And then we'll have a button "+."
**[00:13:15]** And we'll do "setCount, count+1."
**[00:13:21]** Great.
**[00:13:25]** If I can type today.
**[00:13:27]** And then last, I want to just put some space.
**[00:13:29]** So I'll say "with ColumnGap = 4."
**[00:13:34]** Great. And let's add these into our header here.
**[00:13:36]** So we'll have it be the name field.
**[00:13:39]** And then we'll have the buttons.
**[00:13:42]** "Save." We've got our name field.
**[00:13:46]** The buttons are a little weird, but we'll just type the buttons.
**[00:13:49]** We can type in the name field now.
**[00:13:51]** And if I click "+," we see that the count updates.
**[00:13:54]** Perfect. We'll get that little layout glitch there fixed
**[00:13:57]** in just a second here.
**[00:13:58]** Let's continue.
**[00:14:01]** So we have basic state, single state.
**[00:14:03]** Let's do a little richer one.
**[00:14:04]** Let's do collection.
**[00:14:06]** So we'll just say I want "Enumerable"
**[00:14:14]** that is "Range to 100."
**[00:14:18]** And we'll say, let's just take the index,
**[00:14:21]** and we'll create another string.
**[00:14:23]** We'll just say "Item # i."
**[00:14:28]** And we'll do a "Guid.NewGuid.
**[00:14:32]** ToString" and grab eight characters of it.
**[00:14:35]** And we'll make that into a list.
**[00:14:37]** Great. If we want to visualize this, let's create a "listView."
**[00:14:47]** And we're going to take the items we just created.
**[00:14:50]** We need to create a "keySelector."
**[00:14:52]** So we're just going to say,
**[00:14:57]** because all of our items are unique strings, pretty easy.
**[00:15:01]** We can do that.
**[00:15:03]** I have a little typo here.
**[00:15:05]** Let's go fix that.
**[00:15:06]** And then we need to create a "viewBuilder,"
**[00:15:09]** which is just how we want to create it.
**[00:15:11]** So we'll say "item."
**[00:15:12]** We don't need a second argument.
**[00:15:13]** And we'll create a "TextBlock" with the item in it
**[00:15:16]** and a margin of 8 all around it.
**[00:15:21]** And last, just because I don't want
**[00:15:23]** to have it animate too much, we'll put that in here.
**[00:15:26]** And we'll add our list item to our listView here.
**[00:15:30]** And because we're putting it in a flex grid,
**[00:15:33]** I want to have this guy be the largest piece.
**[00:15:36]** So it's going to fix that little glitch we saw earlier,
**[00:15:38]** also because that will consume the rest of the space.
**[00:15:40]** So now we see our list of items.
**[00:15:43]** They're in a list box.
**[00:15:44]** They scroll.
**[00:15:45]** And we click "+."
**[00:15:46]** Everything works.
**[00:15:47]** But the first thing you should notice is that when I click "+,"
**[00:15:48]** all of these become new guids.
**[00:15:50]** That's because this render method is being called
**[00:15:53]** every frame.
**[00:15:53]** Every time you make a change, it's being called.
**[00:15:55]** It's recomputing the display.
**[00:15:57]** And then we're diffing between the two things.
**[00:15:58]** So we only update the things that are actually changed.
**[00:16:01]** And in this case, we're rerunning this every time.
**[00:16:03]** So these state variables,
**[00:16:04]** because we did UseState, they stick around.
**[00:16:07]** And so here we'll do a "UseReducer," which is the name
**[00:16:10]** for the thing that we do that is a collection value.
**[00:16:13]** And now we'll go in here and say we want
**[00:16:16]** "items" and "updateItems".
**[00:16:19]** And so this is how we'll be able to mutate this.
**[00:16:21]** And if we save this,
**[00:16:22]** we'll notice right away it fixes the bug.
**[00:16:24]** We can increment and decrement.
**[00:16:25]** We can change our text.
**[00:16:26]** And these are no longer recomputing on every frame.
**[00:16:29]** Great. Quite an improvement.
**[00:16:32]** Let's go and actually update it
**[00:16:33]** so we can add something to that list.
**[00:16:35]** So add "Add" button.
**[00:16:39]** And we'll say what we want to do is "updateItems."
**[00:16:44]** And this, you take in a list, you return a list.
**[00:16:46]** And so it's going to be the list that's coming in,
**[00:16:49]** it's going to be called "list."
**[00:16:51]** And it will say what we want to return is a new list.
**[00:16:55]** And the first item we'll have is "New item #,"
**[00:16:59]** and we'll do "list.Count + 1."
**[00:17:06]** And then I won't bother with the guid.
**[00:17:08]** And then we'll just give the rest of the list here.
**[00:17:13]** We've got our basic thing.
**[00:17:15]** We'll save that.
**[00:17:15]** And now, if we come over here and click "Add,"
**[00:17:17]** we see we can add the new items at the top.
**[00:17:20]** Everything still functions.
**[00:17:25]** One thing I'd like to show, I want to demonstrate,
**[00:17:27]** I've been talking about this diffing thing
**[00:17:29]** and this incremental update.
**[00:17:30]** And so let's go take a look at that.
**[00:17:31]** So I mentioned before, we had this DevTools idea.
**[00:17:34]** And so the idea is that we hypothesize that there is a case
**[00:17:40]** to have some more developer-friendly things built
**[00:17:42]** into the framework.
**[00:17:43]** And so here, what I'm going to do is I'm going to turn in
**[00:17:45]** and say, I want to have this "DevToolsMenu" show up.
**[00:17:48]** Now, this DevToolsMenu actually is automatically conditional
**[00:17:51]** on you having set this DevTools property
**[00:17:54]** that you wanted to opt into this.
**[00:17:56]** And then on the command line
**[00:17:56]** that you actually specified you'd
**[00:17:57]** like to run this specific instance with these on.
**[00:18:00]** And this lets you turn on developer features
**[00:18:02]** in your product so you can debug it better, you can use things,
**[00:18:04]** and you can just write conditional code
**[00:18:06]** pretty trivially.
**[00:18:07]** We have a couple of features built in.
**[00:18:09]** So here I'm going to say highlight reconciler changers.
**[00:18:11]** And now, when I click "+," you'll see that it shows that,
**[00:18:14]** oh, we're just updating the string
**[00:18:15]** because that's one big string.
**[00:18:16]** And if I click the text, you can see we also are updating the
**[00:18:19]** text box as we do it.
**[00:18:21]** And so, really, this is just a way
**[00:18:23]** to visualize what is changing each frame.
**[00:18:26]** And so what I'd like to do is demonstrate what happens
**[00:18:28]** with a list like this.
**[00:18:29]** So let's go into our list.
**[00:18:30]** And instead of just doing a TextBlock, let's do a "FlexRow."
**[00:18:35]** And we'll put a second thing, which is another "TextBlock"
**[00:18:39]** that says ""Count: " + count."
**[00:18:44]** And we'll do the same margin of 8.
**[00:18:48]** Great. And so now we see, we saw a big red thing
**[00:18:50]** because it got re-rendered completely,
**[00:18:52]** like new elements created.
**[00:18:54]** But now, when we click "+,"
**[00:18:55]** you'll see all we're doing is changing that portion.
**[00:18:58]** But this top one, we're changing the whole thing.
**[00:18:59]** And that's because this is one text block that says "Hello"
**[00:19:03]** and it does a big string.
**[00:19:04]** And so we have to update that whole string.
**[00:19:05]** That's an atomic thing.
**[00:19:06]** But here we were able to update only the Count part
**[00:19:09]** because that was a separate element, and we're able
**[00:19:11]** to do incremental updates to that element.
**[00:19:15]** Great. Let's turn off the flashy blinky.
**[00:19:23]** Great. So the next thing I'd like to touch on is how
**[00:19:27]** to build new components.
**[00:19:28]** So here we have this flex row.
**[00:19:30]** The easiest way to build a new component is I can just simply
**[00:19:33]** extract a method.
**[00:19:34]** And we'll call this "ListItemView."
**[00:19:40]** And it turns out that's all we had to do.
**[00:19:43]** This is the new function.
**[00:19:44]** This the new component.
**[00:19:45]** We don't have to do anything else.
**[00:19:46]** It just works.
**[00:19:47]** So we're able to add, in fact, if I change this and say,
**[00:19:50]** actually, I want this to say "Countish."
**[00:19:53]** And we save it.
**[00:20:00]** Sometimes you get a crash.
**[00:20:04]** As promised, the.NET watch is not always a thousand
**[00:20:09]** percent reliable.
**[00:20:10]** Great. While we're waiting for that to load, let's go through
**[00:20:12]** and do the next thing that we could create here.
**[00:20:19]** I'll just go make a quick change here to force the reload.
**[00:20:23]** So instead of just creating a function,
**[00:20:27]** you can also create a full component.
**[00:20:28]** And so the component gives you a life cycle.
**[00:20:30]** It lets you know when the component is mounted
**[00:20:33]** into the tree.
**[00:20:34]** There's an update method you can override.
**[00:20:36]** And so if I want to create a new component from scratch,
**[00:20:40]** it's a little more work than just a function.
**[00:20:41]** And so what I'll do here is I'll create "ListItemView."
**[00:20:44]** I'll delete this version.
**[00:20:46]** And we see that we have a class that derives from component.
**[00:20:50]** It declares what properties it takes,
**[00:20:52]** in this case, an item and a count.
**[00:20:53]** It has roughly the same content that was in there.
**[00:20:57]** And then we have a little helper method
**[00:21:03]** that gives you the convenience function call
**[00:21:06]** of just calling it ListItemView instead of having
**[00:21:08]** to do a bunch of construction.
**[00:21:09]** And so what I'll do is I'll come up here and I'll add
**[00:21:13]** "using static Components."
**[00:21:16]** And so now this list item view is now binding to that.
**[00:21:19]** And so if I save, it's still working and no real change.
**[00:21:32]** We think.
**[00:21:38]** All right.
**[00:21:40]** We'll try to get that going again.
**[00:21:43]** Great. Beyond the list view, I want to show one
**[00:21:47]** of these new controls.
**[00:21:48]** We talked about new controls that we're thinking of adding
**[00:21:50]** to the platform that we're looking
**[00:21:51]** at that we want feedback on.
**[00:21:53]** And so let's go replace this list view
**[00:21:55]** with something a little richer.
**[00:21:56]** And so what I'll do is I'm going to go and replace this with a --
**[00:22:09]** We'll replace this with a "PieChart."
**[00:22:12]** And PieChart takes in the list of data
**[00:22:15]** that you want, in this case, items.
**[00:22:17]** And then you have to provide it with a way to get a function
**[00:22:22]** for the individual component.
**[00:22:28]** So I need to get the value, so we'll say "d,"
**[00:22:30]** and we're just going to return 1,
**[00:22:31]** so everything is a unit 1 thing.
**[00:22:36]** And then I will just say I'd like to have --
**[00:22:41]** See if this refreshes.
**[00:22:53]** Come on.
**[00:23:01]** I have to have code that compiles for it to work.
**[00:23:04]** There we go.
**[00:23:05]** So probably a few, two things.
**[00:23:09]** Let's just take the first five.
**[00:23:12]** That's better.
**[00:23:14]** But what I'd like to do is have a label on these things.
**[00:23:16]** And so we'll say the LabelView that I'd
**[00:23:18]** like to use is taking a item.
**[00:23:24]** Too much noise in there.
**[00:23:28]** And we'll just return "ListItemView" of that item
**[00:23:33]** and the count property.
**[00:23:35]** And so now we see our counts, and in fact if we "+,"
**[00:23:39]** we see that they increment as they should.
**[00:23:42]** Those are a little hard to see, so let's go in here
**[00:23:44]** and just say, we can do a little offset.
**[00:23:47]** So we'll say "LabelRadiusOffset" and make it be 30.
**[00:23:52]** And we say, okay, great, they're out there.
**[00:23:54]** But, actually, let's do this.
**[00:23:55]** Let's make this be "15 * count."
**[00:23:59]** And now, as we plus and minus the count, those labels move.
**[00:24:04]** So you can see this system is really giving this a lot
**[00:24:06]** of flexibility of what you can do,
**[00:24:08]** how you can transform the code, and that the UI just continues
**[00:24:12]** to update and keep up with it.
**[00:24:14]** But so far, everything we've shown is synchronous code,
**[00:24:17]** which works really well.
**[00:24:18]** But what I'd like to do is see what this looks
**[00:24:20]** like if we get asynchronous code.
**[00:24:22]** And so here what I have is a resource,
**[00:24:26]** which is an asynchronous value.
**[00:24:28]** And I've just hard-coded it.
**[00:24:29]** At the moment, it's just a delay for two seconds.
**[00:24:31]** And then randomly, every 20%, let's just have it pretend
**[00:24:34]** that it fails, just because that's what the network does.
**[00:24:37]** This guy had a little different code in what it wants to show,
**[00:24:40]** so we'll leave that so we can see it.
**[00:24:43]** And we see if we compile, it doesn't work right now,
**[00:24:45]** so we got to, first off, we can't update this item
**[00:24:47]** because it's now an asynchronous thing coming in.
**[00:24:50]** And then last, you'll see that this isn't even a list yet.
**[00:24:53]** It says there is no take on this.
**[00:24:56]** And so what we need to do is get the data out of
**[00:24:58]** that asynchronous result.
**[00:24:59]** So we'll say "items.Match."
**[00:25:01]** We're going to return the element.
**[00:25:03]** And we can basically set what element we want
**[00:25:06]** for different states.
**[00:25:06]** So for loading, we're going
**[00:25:08]** to have it return a text block that says "loading."
**[00:25:14]** And if we get into an error state, we'll ignore the error
**[00:25:18]** for now and say, show me a "TextBlock" that says "error."
**[00:25:25]** And we'll make that be red.
**[00:25:37]** And then the last one we can do is what happens
**[00:25:40]** if we actually get the data we wanted.
**[00:25:41]** Hey, that would be great.
**[00:25:43]** And so we'll say that that takes something
**[00:25:45]** which we'll call "data."
**[00:25:47]** And now we can use our function down here.
**[00:25:50]** And we'll say "data."
**[00:25:53]** And now, if we save, we see it says "loading" briefly.
**[00:25:57]** Goes into an error state.
**[00:25:59]** So what I want to do is have it that I can kick this
**[00:26:02]** and have it try in because we lost the race.
**[00:26:05]** So what we'll do is we'll say, hey, whenever name changes,
**[00:26:07]** pretend that's a dependency of this resource.
**[00:26:10]** And so now I can come in here,
**[00:26:14]** and if I change the name, it goes to "loading."
**[00:26:17]** And we won the lottery this time,
**[00:26:18]** and so we get to see the value.
**[00:26:20]** So you can see that what we've built
**[00:26:21]** in is easy-to-use asynchronous functions that can allow you
**[00:26:26]** to handle the normal cases you see in UI,
**[00:26:29]** be able to very easily show loading states, error states.
**[00:26:32]** And you can do this with any asynchronous values.
**[00:26:34]** You can have lists that return these, etc.
**[00:26:39]** So we've now seen the breadth of the main core pieces of what's
**[00:26:44]** in Microsoft UI Reactor.
**[00:26:46]** It's an experimental framework.
**[00:26:47]** We have a new set of controls, which, like Charting,
**[00:26:50]** would be something that's just generally in WinUI.
**[00:26:53]** It's not going to be specific to the Reactor syntax.
**[00:26:56]** Very few things would ever be specific to the Reactor syntax.
**[00:26:59]** But we can play with this new way
**[00:27:00]** of doing C#-first development and see how it feels,
**[00:27:03]** see what it looks like.
**[00:27:04]** Please go try out the repo, clone it, build something
**[00:27:08]** with it, send feedback, file feedback items, issue a PR.
**[00:27:12]** Let's go see what we can do with this and see
**[00:27:14]** if this is something that is interesting
**[00:27:16]** to the community, and learn together.
**[00:27:18]** Thank you.
