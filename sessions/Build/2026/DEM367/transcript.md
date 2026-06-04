**[00:00:05]** Hello everyone, good to see you.
**[00:00:09]** Today I want to talk about the developer joins your
**[00:00:13]** team, not the HR onboarding, not the badge pickup.
**[00:00:18]** The moment your team is your team open a repo
**[00:00:23]** they never seen a wonder where to start.
**[00:00:28]** For the next 25 minutes, I'm going to show you
**[00:00:31]** how was that moment change when the AI agent sits
**[00:00:35]** next to you.
**[00:00:40]** I'm Michel Riber, I work for Avanade in France.
**[00:00:44]** As you can listen my accent, I'm sure you know
**[00:00:47]** I'm in French, but I assume it's difficult to change.
**[00:00:52]** Sorry.
**[00:00:53]** I'm MVP for 17 years.
**[00:00:57]** A long time.
**[00:01:01]** 3 numbers to set the scene.
**[00:01:04]** 3 to 9 months.
**[00:01:06]** That's how long it takes on average for a developer
**[00:01:10]** to become fully productive in a new code base, not
**[00:01:14]** to ship their first commit to actually be autonomous.
**[00:01:19]** It's a long time.
**[00:01:21]** 40%.
**[00:01:23]** That's how much of week of week 1 is spent
**[00:01:27]** reading code, not writing it, just reading.
**[00:01:32]** And that's normal, except that reading time is usually solitary
**[00:01:37]** and dependent how good the documentation is.
**[00:01:42]** And as we know, the documentation is generally obsolete, not
**[00:01:48]** up to date.
**[00:01:51]** That's the reality.
**[00:01:52]** That's the fact.
**[00:01:58]** One in three question.
**[00:02:00]** This may be my favorite because when you start on
**[00:02:04]** a new project, one in three questions never get asked
**[00:02:09]** out loud.
**[00:02:10]** Because the new developer is afraid of looking dumb, because
**[00:02:16]** the tech lead is in a meeting, because the question
**[00:02:20]** feels too basic to this other slack these three numbers.
**[00:02:25]** This is not an HR problem.
**[00:02:27]** This is what we call developer experience.
**[00:02:31]** That's exactly what we are going to attack today for
**[00:02:40]** facts.
**[00:02:42]** Actor one, understand the code base, get from zero to
**[00:02:47]** a mental map in minutes.
**[00:02:50]** Actor 2 surface the hidden context, the decision that shaped
**[00:02:55]** the code and never made it into the docks.
**[00:03:00]** Actor three, identify what and who really matters, critical components
**[00:03:06]** and the white people to talk to.
**[00:03:10]** Actor 4 ship the first contribution, a real PR that
**[00:03:14]** follows the team's convention on day one.
**[00:03:19]** At the beginning I wanted to do all this demo
**[00:03:23]** full live, but when you use AI agents, sometimes it
**[00:03:27]** takes minutes rather than seconds, so I prefer to do
**[00:03:31]** a studio life demo.
**[00:03:35]** To make this concrete, I present to you, I introduced
**[00:03:38]** to you Sara.
**[00:03:40]** She is a fictional developer, but the situation she's in,
**[00:03:45]** you've all seen it.
**[00:03:47]** Day one new team repo.
**[00:03:50]** She never opened.
**[00:03:52]** So with me.
**[00:03:54]** Last updated 14 months ago.
**[00:03:57]** So Alvron, it's not up to date.
**[00:04:00]** The tclid is meeting until 5:00 PM, so difficult to
**[00:04:05]** have a conversation with him, to understand the architecture, to
**[00:04:12]** understand the project, the code base, more than 2000 files
**[00:04:17]** in the code base, a real code base, more than
**[00:04:22]** five different languages, Python, react.net, SQL and so on.
**[00:04:29]** And we need to tackle with legacy and actual code,
**[00:04:34]** recent code and the implicit deadline for the new developer.
**[00:04:40]** First PR at the end of the week.
**[00:04:43]** Nobody tells you, but everyone expected that the situation.
**[00:04:50]** So when Sarah opens the code base this is what
**[00:04:55]** she has.
**[00:04:57]** This code base come from open source project.
**[00:05:00]** Post hog I just picked that open source project by
**[00:05:04]** default.
**[00:05:06]** I have no relation with this code base.
**[00:05:09]** But what I wanted is a code base that has
**[00:05:12]** a long history.
**[00:05:14]** The more history you have the more the better agent
**[00:05:18]** will be.
**[00:05:21]** So actor one Sara opens her agent and asks the
**[00:05:25]** more natural question in the world.
**[00:05:29]** I just joined the team.
**[00:05:31]** Give me a tour, give me the entry point.
**[00:05:34]** Explain to me the code base, not from technical part
**[00:05:38]** but also functional part.
**[00:05:42]** So this is a query I ask to my agent.
**[00:05:49]** Notice it's not just listing the folders at workspace gives
**[00:05:54]** copyloads the actual code in context, it's within import recent
**[00:06:00]** commits and inferring boundaries from how the code actually connects.
**[00:06:07]** So I launched this point and then the agent will
**[00:06:12]** analyze all the code base, the 2000 files and it
**[00:06:17]** will explain to me what are the main entry points.
**[00:06:22]** For example, to have this kind of response, normally you
**[00:06:27]** should have a 2 hour whiteboard session with a tacloid.
**[00:06:32]** So in 2-3 minutes you've got all the information.
**[00:06:41]** Here I've got the description of the front end which
**[00:06:45]** is developed in React.
**[00:06:48]** So also I've got the different entry point and that's
**[00:06:52]** it.
**[00:06:55]** Here I've got the explanation of the node dot JS
**[00:07:00]** server with a different method, the different modules, the different
**[00:07:06]** class and the file where I can find the class.
**[00:07:13]** The agent will give me the architecture and the data
**[00:07:17]** flow from the front to the back with a different
**[00:07:20]** method, a different class.
**[00:07:26]** It will also explain the query path from the back,
**[00:07:29]** the front end to the back end and the different
**[00:07:32]** Kafka topics.
**[00:07:34]** So it will really understand the code base and so
**[00:07:38]** Sara can understand quickly what what is the project and
**[00:07:44]** where, where to find the correct the correct code.
**[00:07:49]** It will also analyse what is the active code versus
**[00:07:52]** the older code.
**[00:07:54]** So here I've got the different folder where the code
**[00:07:59]** is really active in the last month and here where
**[00:08:03]** I can find the legacy code.
**[00:08:06]** Sometimes it's code that is never used, but it's code
**[00:08:10]** that will not involve the from several months.
**[00:08:17]** And what is really interesting is I asked the agent
**[00:08:21]** give me the diagram of all the class of the
**[00:08:25]** project.
**[00:08:28]** It's not in the documentation.
**[00:08:29]** It's created by analyzing the code base and the relationship
**[00:08:33]** between the different classes, the different dependencies.
**[00:08:38]** If I zoom in, this is the diagram made by
**[00:08:42]** the agent.
**[00:08:44]** No documentation, just the code base.
**[00:08:48]** And that's very impressive.
**[00:08:51]** In just three minutes you've got all this information.
**[00:08:58]** How to do this is where it gets interesting.
**[00:09:03]** Sarah has a map now, but a map doesn't tell
**[00:09:07]** you why the road were drawn that way.
**[00:09:10]** She needs a context the documentation doesn't contain.
**[00:09:20]** This is a prompt.
**[00:09:21]** The new prompt I sent to the agent.
**[00:09:24]** Now I ask to the agent, look at this file
**[00:09:29]** final dot PY.
**[00:09:31]** Why does the file exist?
**[00:09:35]** What problem was it built to solve?
**[00:09:38]** As you can see now I add at GitHub, it's
**[00:09:42]** not just reading the code, it's pulling PR description, commit
**[00:09:47]** messages, issue threads to understand all the history of the
**[00:09:52]** module, not just the last version, but all the histories,
**[00:09:57]** the different steps, the different milestone for this particular module.
**[00:10:07]** So you will think during several seconds and at the
**[00:10:11]** end what I have, it will explain to me the
**[00:10:14]** raging, the motivation and the major re factor for this
**[00:10:19]** module based on the code base and all the PR,
**[00:10:22]** the commits, all the documentation it can analyze, it can
**[00:10:27]** index.
**[00:10:32]** It will also explain the core algorithm for this module.
**[00:10:36]** And then it will explain to me the full story
**[00:10:40]** from PR and commits.
**[00:10:42]** So as you can see this project started in 2021,
**[00:10:45]** so a long history.
**[00:10:49]** So at the beginning they use Krikaus Enterprise Edition.
**[00:10:54]** If we go deeper Phase 2, they replace this version
**[00:10:58]** by the open source version.
**[00:11:00]** So I've got also the PR with a different refactor,
**[00:11:06]** so then I can analyze manually if I want 3
**[00:11:10]** the next step they decide to replace Postgres by criccaos
**[00:11:16]** and so on.
**[00:11:19]** And then I've got the timeline with a different milestone
**[00:11:23]** for this module.
**[00:11:24]** So I can really understand what are the technical decision
**[00:11:32]** what what is the real history of this module and
**[00:11:37]** just in few seconds without documentation next next question to
**[00:11:45]** the agent.
**[00:11:47]** I see that post hogs this open source project uses
**[00:11:51]** Krikaus for analytics queries instead of post grade.
**[00:11:57]** So I asked the agent find the original decision behind
**[00:12:01]** that choice.
**[00:12:02]** What why they migrate from post grade to Krikaus And
**[00:12:07]** the same you will analyze all the decision about Krikaus
**[00:12:12]** in the repository in the PR and then they will
**[00:12:16]** explain me the different phases, different milestone, the preexisting POC.
**[00:12:23]** Before 2020 Phase 2 they had a pain point with
**[00:12:29]** Posegre.
**[00:12:30]** So I know the reason why they analyzed Posegre versus
**[00:12:33]** Picaus because they had a specific pain point.
**[00:12:39]** If you if you read it will explain the what
**[00:12:42]** is the pinpoint.
**[00:12:45]** I think it's a performance issue they have for specific
**[00:12:50]** queries.
**[00:12:52]** Phase 3 they did comparison with different solution to replace
**[00:12:58]** Fosgrae.
**[00:13:01]** Phase four, they started the migration, so they decided to
**[00:13:06]** move from persuade to Kekaus.
**[00:13:09]** So I know I've got the milestone, I've got a
**[00:13:13]** different issue and the PR where they start the the
**[00:13:17]** migration.
**[00:13:23]** And then as previous I explained earlier, we've got a
**[00:13:27]** different timeline from the succession of to do POC.
**[00:13:33]** Why they choose Kekaus?
**[00:13:37]** Why they evaluate the different database?
**[00:13:39]** They evaluate the migration epic, the first implementation PR and
**[00:13:45]** when Cacaos was in production one again just by analyzing
**[00:13:50]** the Kitab repository.
**[00:13:55]** Next I ask to my agent what are the unwritten
**[00:14:00]** conventions.
**[00:14:02]** So I asked the agent to explain to me what
**[00:14:06]** are the convention in the code base for error handling,
**[00:14:11]** for logging, for naming convention and so on.
**[00:14:16]** Not based on the documentation, but based on the real
**[00:14:19]** active code.
**[00:14:22]** So the agent will answer after a few seconds or
**[00:14:25]** so.
**[00:14:26]** The logger he will explain what I have to develop
**[00:14:30]** use, what the code I use, sorry what the code
**[00:14:34]** I have to use rather than the the second one.
**[00:14:38]** So I need to use import structured instead of logging
**[00:14:42]** that the convention implemented in the existing project.
**[00:14:48]** Same for the error handling.
**[00:14:50]** You will explain what I have to do based on
**[00:14:53]** the convention of the of the team.
**[00:14:58]** You will also explain how to implement the logging in
**[00:15:01]** my code.
**[00:15:06]** So act 3 Sarah now understand the code base, she
**[00:15:11]** has the context.
**[00:15:13]** Now she needs to prioritise the the work she has
**[00:15:18]** to do.
**[00:15:23]** This query I will understand.
**[00:15:28]** I will ask the agent what are the five files
**[00:15:32]** I absolutely need to read first, what are the main
**[00:15:36]** parts of the code?
**[00:15:40]** And the agent will answer so it will give me
**[00:15:46]** the five important files, team routine and so.
**[00:15:53]** And here's the mental model after analyzing the five files,
**[00:15:58]** then I'm going to ask also to to the agent
**[00:16:02]** who are the main contributors for the core model, because
**[00:16:07]** I need to, if I have a question about this
**[00:16:11]** module, who should I contact to have a discussion, to
**[00:16:16]** understand, to explain a specific point.
**[00:16:20]** So thanks to the PR, to the committee, I can
**[00:16:23]** retrieve who is the owner of the module.
**[00:16:26]** So then I can ask question to the to this
**[00:16:29]** guy.
**[00:16:32]** Sometimes an agent has a strange behavior.
**[00:16:38]** Instead of give me the name, it just gives me
**[00:16:41]** the command to execute.
**[00:16:44]** Well, it's it's an, it's not an illustration, but it's
**[00:16:48]** a strange behavior of the of the agent.
**[00:16:53]** The the main point is I've got the different query
**[00:16:56]** to execute if I want to know who are the
**[00:16:59]** best contributors.
**[00:17:03]** So Sarah can execute, can launch this command if she
**[00:17:07]** want active 4.
**[00:17:09]** The last one shipped the first PR.
**[00:17:14]** So I need to read an issue, I need to
**[00:17:16]** plan the approach, I need to implement following the convention,
**[00:17:21]** run the test, debug and grab the PR description.
**[00:17:27]** So for that I use a real issue of this
**[00:17:30]** project of the post org project.
**[00:17:33]** So I select this one 58757 and then I will
**[00:17:38]** ask to the agent will the issue explain what is
**[00:17:43]** the issue, what are the technical change imply and which
**[00:17:50]** file should I update.
**[00:17:55]** So he will read the issue.
**[00:17:56]** He will explain to me what what is the issue
**[00:18:00]** and what are the file I should modify.
**[00:18:04]** So he will explain the code what are the updates
**[00:18:08]** I need to to made to be successful.
**[00:18:14]** So he will explain all the in all the files
**[00:18:17]** what I have to to modify.
**[00:18:21]** Then before I can't do by myself the update, but
**[00:18:27]** I can ask the agent do the update.
**[00:18:31]** So before writing the code I just ask to the
**[00:18:35]** agent give me an approach find me the revamp files.
**[00:18:40]** So give me the the workflow, give me the strategy
**[00:18:44]** to apply this issue.
**[00:18:46]** But don't update the code for the moment.
**[00:18:51]** So it will analyze the root cause, it will analyze,
**[00:18:56]** it will advise to me to change the back end
**[00:19:00]** of the database by adding a new column.
**[00:19:04]** It will give me the serializer, it will give me
**[00:19:08]** all the code I have to implement.
**[00:19:12]** So now I analyze this plan.
**[00:19:15]** As the plan is OK.
**[00:19:16]** So now I ask the agent implement the fix, let's
**[00:19:21]** do it.
**[00:19:25]** And here if you see the the the red lines
**[00:19:29]** on the right, it's what the agent updated to fix
**[00:19:33]** the the issue.
**[00:19:38]** Now the agent applies the the update.
**[00:19:43]** Now I ask the agent run the test to verify
**[00:19:47]** that I've got no regression and if you find if
**[00:19:51]** a test fail, debug it and fix it.
**[00:19:58]** After that.
**[00:19:59]** I wanted to we can imagine the tests are OK.
**[00:20:05]** I want to draft the PR description.
**[00:20:09]** Once again I asked the agent what is the convention
**[00:20:13]** in the team?
**[00:20:14]** What is the structure of the PR?
**[00:20:18]** So he will analyse the last PR out its structure
**[00:20:22]** and he will give me the description automatically.
**[00:20:28]** So he will put you will define the title, the
**[00:20:32]** problem, the different change made by the to fix the
**[00:20:36]** issue in the back end, the front end.
**[00:20:40]** Oh, sorry.
**[00:20:42]** And he will also.
**[00:20:43]** As you can see the PR was observed by an
**[00:20:45]** agent.
**[00:20:46]** So I know that to fix this issue I use
**[00:20:50]** copilot and cloud sonnet 4.6.
**[00:20:53]** That's very important to twice the the issue.
**[00:20:58]** If you if you have got the following position sweep
**[00:21:03]** and sibalt to take home AI as a context engine,
**[00:21:07]** not a code generator.
**[00:21:10]** In the onboarding process, the value is not inviting code,
**[00:21:14]** it's in understanding what already exists.
**[00:21:18]** Don't judge an agent by how well it writes judge.
**[00:21:22]** Judge it now how well it explained the code base
**[00:21:26]** is.
**[00:21:27]** Is the documentation an agent with what actually what actually
**[00:21:32]** there, not what we wish was there.
**[00:21:35]** That changed your relationship with documentation.
**[00:21:38]** Fewer pages to maintain, more investment in the code base.
**[00:21:43]** So it's important that the code base is readable, it's
**[00:21:47]** important that you put some good comments on your code
**[00:21:51]** to to allow the agent to analyse the context globally.
**[00:21:56]** And the last senior time is the scariest resource.
**[00:22:02]** Every question asked answered by by AI is focused returned
**[00:22:06]** to the team.
**[00:22:08]** So it's not a replacement of the human, it's like
**[00:22:12]** an assistant or a pair programmer that will help you
**[00:22:16]** to understand and to resolve the different issue.
**[00:22:23]** So try it on Monday, give you the next hire
**[00:22:28]** an AI agent, measure time to 1st PR.
**[00:22:32]** That's a very important metric if you can.
**[00:22:37]** If you cannot improve it, you've got a problem in
**[00:22:41]** your in your cut days before AI, after AI, compare
**[00:22:45]** the time you you have from the day one to
**[00:22:49]** the first PR.
**[00:22:55]** So to conclude, onboarding used to be a test of
**[00:22:59]** patience.
**[00:23:00]** With AI, it can become a test of curiosity.
**[00:23:03]** That's my favorite maxim.
**[00:23:09]** So what I want, what I wanted to demonstrate today
**[00:23:12]** is in boarding it's one prompt, one plan, 1 PR
**[00:23:16]** day one.
**[00:23:17]** So in reality is not one day but in few
**[00:23:20]** days rather than few months, you can on board a
**[00:23:24]** new developer and the developer will be more productive.
**[00:23:30]** If you get any question, you can contact me via
**[00:23:33]** Linkin if you want.
**[00:23:35]** We don't have time to answer question today except if
**[00:23:39]** you meet me during the the build.
**[00:23:42]** Thanks for your time.
**[00:23:45]** Have a good have a great build.
