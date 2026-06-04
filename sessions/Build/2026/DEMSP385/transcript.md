**[00:00:01]** All right, thank you.
**[00:00:02]** So quick raise of hand just for me, how many
**[00:00:04]** people are familiar with elastic Elastic search Elastic.
**[00:00:09]** All right, cool.
**[00:00:10]** It's pretty good.
**[00:00:11]** OK, so today I'm going to talk about how we
**[00:00:14]** can use elastic search with Code Review agency when you
**[00:00:17]** push PRS to help.
**[00:00:18]** Not we already do a lot of just is your
**[00:00:21]** code actually working?
**[00:00:22]** Is it syntactically correct?
**[00:00:23]** Things like that.
**[00:00:24]** We're going to tie it to if I push this
**[00:00:26]** PR, is it going to cause the same incident that
**[00:00:29]** happened last month?
**[00:00:34]** There we go.
**[00:00:35]** OK, So what happens right now is your code gets
**[00:00:38]** pushed and you you have a review and maybe it
**[00:00:42]** works.
**[00:00:42]** If it doesn't, it gets blocked.
**[00:00:43]** Otherwise you merge it.
**[00:00:44]** So we're going to again, take these post mortem incidents
**[00:00:47]** that happen, open telemetry traces that are in elastic search,
**[00:00:50]** and we're going to have that automatically check in and
**[00:00:52]** make a code review.
**[00:00:54]** So this is the most high level chart of this
**[00:00:58]** I could put together.
**[00:01:00]** So essentially you have your automated review process right now.
**[00:01:02]** So you push your PR and GitHub, GitHub actions, fire,
**[00:01:05]** they do whatever you know you normally have in your
**[00:01:08]** process right now.
**[00:01:09]** But we're going to add in calling Elastic Workflow, which
**[00:01:12]** in turn calls Elastic Agent Builder.
**[00:01:15]** Agent Builder is just our agent platform, but we run
**[00:01:17]** agents.
**[00:01:17]** We'll show it a little bit if it matches.
**[00:01:20]** And you know, using semantic search, things about open telemetry,
**[00:01:25]** similarities, anything in the incident post mortems that happened, it'll
**[00:01:29]** push back a comment in your code and then you
**[00:01:32]** can decide what you want to do.
**[00:01:35]** If you want to fix it, we can drop into
**[00:01:36]** VS Code.
**[00:01:37]** We can use Copilot and the MCP servers back to
**[00:01:40]** elastic search to make decisions.
**[00:01:42]** And we'll show all that in just a minute.
**[00:01:45]** So really the high level is moving from now, it
**[00:01:47]** looks good to it might be syntactically correct again, but
**[00:01:51]** it hits a production issue that happened last month.
**[00:01:54]** So I'm not a big slide guy, so we're going
**[00:01:57]** to just drop over into an actual example here.
**[00:02:00]** So because this is a big event, I practice this
**[00:02:03]** a bunch of times.
**[00:02:04]** That's why you have a bunch of these PRS up
**[00:02:06]** here.
**[00:02:06]** But we're going to actually go, and we're going to
**[00:02:08]** go and create a pull request and we'll show the
**[00:02:11]** code and all the other things in a minute.
**[00:02:13]** So I'm going to go in and I have some
**[00:02:16]** code changes.
**[00:02:17]** So what this does essentially is pretty small bit of
**[00:02:20]** code change.
**[00:02:21]** We're going to take this reserve and we're going to
**[00:02:23]** split out the rights.
**[00:02:24]** And so I should mention a little bit of background
**[00:02:26]** in this.
**[00:02:27]** The application is a, it's called Wayfinder.
**[00:02:30]** It's a e-commerce store.
**[00:02:32]** So we're in California.
**[00:02:33]** I'm from Chicago, but I like to dream that I'm
**[00:02:35]** going to go climb all these mountains and do all
**[00:02:37]** the adventure stuff.
**[00:02:37]** So I go to like a, you know, an adventure
**[00:02:39]** store and you buy all the gear and then you
**[00:02:41]** don't really do it, but it's an e-commerce store.
**[00:02:44]** And so key part of this is when you go
**[00:02:46]** to purchase an inventory, an item, the inventory has to
**[00:02:48]** be correct, right?
**[00:02:49]** There's one pair of boots left, but three people are
**[00:02:52]** trying to buy it.
**[00:02:53]** You're going to have an issue there and you want
**[00:02:55]** to make sure that only one person actually gets that
**[00:02:58]** sale.
**[00:02:59]** But what we did here is we decided to change
**[00:03:02]** do some refactoring and trying to trying to make a
**[00:03:05]** change that helps the this under high throughput.
**[00:03:10]** Let's create a pull request.
**[00:03:11]** And again, I'll look at the files to change the
**[00:03:13]** key one that changed here.
**[00:03:16]** Again, the specific code changes isn't super important, but it's
**[00:03:19]** it's rather minor.
**[00:03:19]** Instead of doing an atomic checkout right here, we decided,
**[00:03:24]** you know what, let's just set the quantity once and
**[00:03:27]** then I'm going to use it a couple times to
**[00:03:30]** do in pre computed quantities in here.
**[00:03:34]** So it's a pretty minor change.
**[00:03:36]** We, you know, we're just kind of move some things
**[00:03:38]** around and decide to do this and it it passes
**[00:03:41]** normal checks because it's a valid change you can do.
**[00:03:44]** If I go over to the back to the conversation
**[00:03:47]** part, Scroll down, see some of the checks.
**[00:03:51]** So the checks are running and you can have whatever
**[00:03:53]** checks you normally would put in here, but we have
**[00:03:55]** this elastic PR agent and this is kind of the
**[00:03:57]** key to what we're talking about today.
**[00:03:59]** So if I look up, look up, we can see
**[00:04:01]** that we have a new comment on here and elastic
**[00:04:04]** agent builder ran through the code and it said, OK,
**[00:04:07]** the PR reintroduces this critical race condition that previously caused
**[00:04:11]** production incidents.
**[00:04:12]** So it's recommending you don't do it.
**[00:04:14]** And key, it's not just using it's you know, it's
**[00:04:17]** training or it's, you know, what has been trained on
**[00:04:20]** about code and, and reviews.
**[00:04:22]** It's saying this actually caused an incident.
**[00:04:24]** You can see on April 7th, we had an an
**[00:04:26]** incident caused five O 4 gateway timeouts.
**[00:04:29]** It looks at hotel traces.
**[00:04:31]** It has specific trace examples.
**[00:04:33]** So again, it's saying if you do this, this is
**[00:04:35]** what happened.
**[00:04:36]** And when you made that change last time or now
**[00:04:38]** with all the coding agents, maybe the coding agent decided
**[00:04:41]** this was a good idea, but we broke production at
**[00:04:44]** least once before.
**[00:04:45]** Maybe you don't want to do it.
**[00:04:47]** It gives the root cause on why this is a
**[00:04:49]** bad idea and what caused the incident before.
**[00:04:53]** And it talks again about the PR removing and so
**[00:04:56]** it even gives a suggestion on how you can make
**[00:04:59]** this change not break production.
**[00:05:01]** That'd be great.
**[00:05:02]** We can take a look here.
**[00:05:07]** So it's a pretty simple setup.
**[00:05:09]** If we look at this is just calls this one
**[00:05:13]** workflow URL in real time.
**[00:05:15]** It takes about a minute to run depending on how
**[00:05:17]** much data you have, how large your production, how many
**[00:05:19]** incidents, RCA's and things like that.
**[00:05:22]** But the workflow file to set it up is again
**[00:05:24]** pretty straightforward.
**[00:05:25]** So we're calling Elastic Agent Builder, optionally posting a comment
**[00:05:29]** if it matches something that went wrong.
**[00:05:32]** We have to give it, you know, some environment variables.
**[00:05:35]** So we have things like the PR, the title repo,
**[00:05:37]** kind of whatever information that is needed for the agents
**[00:05:40]** in Elastic search to run.
**[00:05:42]** And then we go through and all this really is
**[00:05:45]** just collecting data to send to the agent.
**[00:05:47]** Here it's talking about using the tools, searching hotel traces
**[00:05:51]** for for information.
**[00:05:53]** And then all this is at the bottom is really
**[00:05:55]** just if the agent didn't match something, it's going to
**[00:05:58]** generate a comment that we saw depends it back.
**[00:06:00]** So this is just some parsing out.
**[00:06:01]** So really all we're doing is gathering information about the
**[00:06:04]** PR, getting the DIF, sending it off to Elastic, And
**[00:06:06]** then when if something comes back, we'll parse it out
**[00:06:08]** and make a comment.
**[00:06:10]** So that's on the the GitHub side.
**[00:06:12]** We can take a look if we hop over into
**[00:06:15]** Elastic and get it to jump.
**[00:06:20]** There we go.
**[00:06:20]** OK, so this is Cabana, which is our UI on
**[00:06:24]** top of Elastic search.
**[00:06:26]** And this is the agent builder or agent UI that's
**[00:06:29]** fairly new, depending on how familiar with Elastic.
**[00:06:32]** You know, we've been changing getting into agents and and
**[00:06:35]** making it embedded as much as possible like everyone else
**[00:06:38]** here at build.
**[00:06:39]** So you have your history of all the comments or
**[00:06:41]** all the conversations you've run before.
**[00:06:43]** These include the automated ones.
**[00:06:45]** So when the automated test and GitHub run and and
**[00:06:47]** call this, it still stores the the history so you
**[00:06:50]** can go in and see what happened.
**[00:06:52]** Now, like most agent platforms, we have things like skills.
**[00:06:56]** Sure, most people here are familiar with this, but on
**[00:06:59]** the off chance, right, skills kind of provide information on
**[00:07:02]** an agent on how something should be done or information
**[00:07:05]** about a system or just ways to perform a set
**[00:07:07]** of actions.
**[00:07:08]** Whereas tools are actually providing functions.
**[00:07:11]** So we have things like querying elastic search, obviously for
**[00:07:13]** all your datas in there, you can query it to
**[00:07:15]** look for things, doing semantic search, vector search, all kinds
**[00:07:18]** of things.
**[00:07:20]** We have tools to reach out to MCP servers.
**[00:07:23]** We have workflows.
**[00:07:24]** And since you're doing a custom agent, we want to
**[00:07:27]** make sure we give it some custom instructions.
**[00:07:30]** So I have one for today.
**[00:07:35]** This is where you kind of explain to the agent
**[00:07:36]** what's going on, right?
**[00:07:37]** So in this one it's, you know, you're an AI
**[00:07:39]** pull request reviewer, wave Finder is my store.
**[00:07:42]** You have access to open telemetry data, historical incidents, post
**[00:07:46]** mortems and going.
**[00:07:47]** And so when you get invoked on the PR and
**[00:07:49]** you kind of just walk it through the steps, we're
**[00:07:52]** going to fetch the PR diffs, we're going to identify
**[00:07:55]** any routes that are being used and we have the
**[00:07:57]** tools in here.
**[00:07:59]** You don't have to hard code the tools in here
**[00:08:01]** because put it in there automatically, but so you can
**[00:08:03]** kind of see what's going on today.
**[00:08:05]** And we're looking for patterns, so not keywords.
**[00:08:07]** We're not just doing keyword matching.
**[00:08:09]** We're doing, you know, semantic look up and things like
**[00:08:10]** that.
**[00:08:12]** And then if you do find a match, this is
**[00:08:14]** kind of important.
**[00:08:15]** We want to explain, you know, what the match is,
**[00:08:18]** how we found it, specific examples so that we're not
**[00:08:21]** just, again, we're not just saying seems like a bad
**[00:08:24]** idea.
**[00:08:24]** We're saying, again, production broke probably don't, maybe don't do
**[00:08:27]** that and some other rules.
**[00:08:30]** We look at the skill.
**[00:08:31]** One of the things you can do if you have
**[00:08:33]** a reoccurring incident is, you know, as part of your
**[00:08:36]** postmortem is an RCA is creating an actual skill that
**[00:08:39]** looks for things like race conditions.
**[00:08:41]** So production broke a couple times or race condition.
**[00:08:44]** We're going to make sure that the the agent understands
**[00:08:46]** specifically what can go wrong.
**[00:08:49]** Obviously they, these agents are or these LMS are smart,
**[00:08:51]** they are aware of things like race conditions, but you
**[00:08:54]** can kind of be very specific if you really have
**[00:08:56]** things that you need the agent to know.
**[00:08:59]** And then tools.
**[00:09:00]** So I mentioned that this agent has access to a
**[00:09:03]** couple tools.
**[00:09:05]** This is always curious for me.
**[00:09:07]** Who here is familiar with Elastic's ES pipe QL language.
**[00:09:12]** It's newish.
**[00:09:13]** That's why I ask.
**[00:09:14]** No, fantastic.
**[00:09:15]** So it is a sequel like syntax, being able to
**[00:09:18]** query Elastic with, you know, again, sequel like syntax.
**[00:09:22]** I'll show it in a second, but we have access.
**[00:09:24]** It has access to a couple tools here.
**[00:09:26]** So we're looking for similar traces based on Http://routes, looking
**[00:09:30]** for latency spikes on those routes, and then this one
**[00:09:33]** where we're looking for actual incidents.
**[00:09:36]** So where are we matching POST or previous incidents?
**[00:09:41]** This is a dead simple ESQL query.
**[00:09:45]** This match query function is a little deceptive in that
**[00:09:48]** it's not just matching on keywords, it's actually doing semantic
**[00:09:52]** search.
**[00:09:52]** It's doing vector search.
**[00:09:54]** We're using the Gina AI embeddings in the cluster where
**[00:09:56]** we generate embeddings on all these post mortem incidents and
**[00:09:59]** all the comments and all the data.
**[00:10:01]** And so then when we can match, you know, semantically
**[00:10:04]** on what was going on, give it a full text
**[00:10:06]** query.
**[00:10:06]** And again, you kind of give the short tool description.
**[00:10:09]** You can be more verbose in your real production environment.
**[00:10:15]** And then one other thing I want to show over,
**[00:10:17]** I'll show the agents in a second is workflows.
**[00:10:20]** So a couple of workflows for the production side, but
**[00:10:23]** the PR review that we saw, So in when we
**[00:10:25]** were in in GitHub side, we saw that the, the
**[00:10:28]** tool or the, the workflow there gathered some environment variables
**[00:10:32]** and then passed them over to Elastic and called a
**[00:10:36]** workflow.
**[00:10:36]** This is the other side of that GitHub workflow where
**[00:10:39]** we have these.
**[00:10:40]** I'll look at one that I ran last week when
**[00:10:42]** I was setting this all up.
**[00:10:45]** It's pretty straightforward.
**[00:10:46]** All it's doing is getting all these environment variables and
**[00:10:49]** information about the PR that we're we're pushing and looking
**[00:10:51]** for information for.
**[00:10:53]** And then I'm calling the agent in Elasticsearch.
**[00:10:55]** There's not much to see here.
**[00:10:57]** The input side is this body where again you can
**[00:11:01]** see it's the PR 37 and then all the other
**[00:11:04]** information we passed back to the agent.
**[00:11:07]** And the outcome in this case when I ran it
**[00:11:10]** was it did find because it's a demo, it did
**[00:11:12]** find a match to an incident that happened previously.
**[00:11:16]** So it says yeah, it ran for PR 37, the
**[00:11:18]** agent response to 200 and the the comment gets sent
**[00:11:22]** back.
**[00:11:22]** So we're not actually storing that right here, but it's
**[00:11:25]** saying that you know, it's inside GitHub MCP tool.
**[00:11:28]** Cool.
**[00:11:29]** So there's two things I can show example wise when
**[00:11:31]** you're talking to agent.
**[00:11:32]** So if you're just pushing code, you don't have to
**[00:11:35]** go in here, but you also because all the data
**[00:11:37]** is in there and it's it's an agent, you know,
**[00:11:40]** you as a developer can go in and ask questions
**[00:11:42]** to the agent directly.
**[00:11:44]** And so you can say, hey, I'm looking at APR
**[00:11:47]** that removes the and and quantity.
**[00:11:49]** So you can ask questions before you even submit the
**[00:11:51]** PR if you want and say, are they matching any
**[00:11:53]** known patterns?
**[00:11:55]** And so we're going to match the similar things we
**[00:11:58]** did for the GitHub automatically.
**[00:12:00]** So we roll back up, we can see it does
**[00:12:03]** a couple of things.
**[00:12:05]** So it has this search incident tool and it's saying,
**[00:12:08]** you know, it's looking for a specific concurrency patterns.
**[00:12:12]** So it matches, it calls it three times, actually looks
**[00:12:15]** for pattern terminology around that.
**[00:12:17]** So it's deciding, you know, phrases and things that could
**[00:12:20]** match potentially what you're asking about changing.
**[00:12:23]** It's finding 5 results, 5 results, different results and then
**[00:12:26]** it calls looking for similar traces.
**[00:12:28]** So it's looking for this endpoint to see if there
**[00:12:31]** were actually things that happened and latency spikes and then
**[00:12:35]** it gives you a nice kind of human friendly answer.
**[00:12:39]** But again, the key to all this is not just
**[00:12:41]** it's it's training and it's learning.
**[00:12:43]** It's on April, April 7th, an incident, similar thing was
**[00:12:49]** changed and we had to fix it happened.
**[00:12:54]** And you know, the, the, the 847 lockout contention events
**[00:12:58]** caused your production, you know, success rate to actually sell
**[00:13:03]** items dropping from 99.7 to 76.
**[00:13:06]** So it's giving concrete examples on how this is going
**[00:13:07]** to affect your production.
**[00:13:09]** And then it gives the post mortem and it talks
**[00:13:11]** about the specific, an example, a sample of specific traces
**[00:13:15]** that happened.
**[00:13:17]** And then again it gives that kind of recommendation.
**[00:13:21]** And we can also ask about a specific endpoint saying
**[00:13:23]** I'm going to work on this endpoint.
**[00:13:26]** Is there anything in these post mortem incidents that may
**[00:13:29]** have happened in the past, similar thing that we've seen?
**[00:13:32]** Because it's the same in point and everything it's going
**[00:13:35]** to find these and say, Yep, there's recent telemetry it
**[00:13:38]** broke.
**[00:13:38]** So a lot of ways you can go about asking
**[00:13:40]** questions, but it's all being able to use these actual
**[00:13:43]** incidents, open telemetry, tracing post mortem information you have and
**[00:13:47]** then get ahead of your code from actually breaking production.
**[00:13:51]** So great.
**[00:13:51]** So we, we started out in this code, we pushed
**[00:13:54]** and pushed APR get out, ran automatically and called Elastic
**[00:13:57]** search and said, Oh yeah, this code change matches an
**[00:14:00]** incident that happened and left a comment and it's up
**[00:14:04]** to you.
**[00:14:05]** Here in Elastic side, we're calling the agent, we're asking
**[00:14:07]** the very similar things.
**[00:14:08]** So different ways you can do it.
**[00:14:10]** But as a developer, you might just want to sit
**[00:14:12]** in VS Code and never actually go into a combat
**[00:14:14]** in Elastic.
**[00:14:15]** That's totally fine too.
**[00:14:17]** So in VS Code, I'm now using Copilot here and
**[00:14:20]** I do have though the MCP server hooked up to
**[00:14:24]** Elastic.
**[00:14:25]** So Elastic, all that data in there and all the
**[00:14:27]** tools that the agent has access to are exposed on
**[00:14:30]** MCP server protocol.
**[00:14:31]** And so you can just hook into the MCP and
**[00:14:34]** do things like call, find similar traces, search incidents, open
**[00:14:38]** telemetry, incident analysis, things like that.
**[00:14:41]** And you can do it right from get up.
**[00:14:43]** So I can say, you know, I got this PR
**[00:14:45]** comment for the inventory reserve.
**[00:14:49]** Can you actually tell me what's what was happening and
**[00:14:51]** what went on?
**[00:14:52]** And the very similar thing is going to happen here.
**[00:14:54]** Now we're just never leaving BS code.
**[00:14:56]** We're calling those same MCP server tools.
**[00:15:00]** Find similar traces, find latency spikes.
**[00:15:03]** It's analyzing all the information.
**[00:15:04]** And Copilot itself is putting together a very similar response
**[00:15:08]** on Yep, it was in a prepared statement.
**[00:15:11]** Hit the cash rate.
**[00:15:13]** I was saying the comment itself a justification, but it's
**[00:15:16]** exactly the pattern on April 7th.
**[00:15:18]** So you made this before or someone else made it
**[00:15:20]** before, or your coding agent decided it's going to make
**[00:15:23]** this, but it already broke.
**[00:15:24]** And So what you need to change again is giving
**[00:15:27]** an example on how to do this and when you
**[00:15:29]** can drop in here and give it.
**[00:15:32]** And because I don't want to actually make the change
**[00:15:35]** myself, I can just say yes, and copilot's going to
**[00:15:38]** go in and make that change for me and update
**[00:15:40]** it.
**[00:15:41]** So it's going to go in, it's going to figure
**[00:15:43]** out, you know, again, what changes to fix.
**[00:15:45]** It's a pretty simple code example.
**[00:15:47]** It's going to make those changes and then it's going
**[00:15:49]** to report back on on what it did.
**[00:15:51]** So I can show and again, it, you know, it
**[00:15:56]** describes as Scopilot does what changes it made.
**[00:16:01]** So it removed that, you know, hard coding the new
**[00:16:04]** quantity early on and it got rid of that misleading
**[00:16:06]** comment.
**[00:16:07]** It changed the, the DB statement here on line 46
**[00:16:11]** to, you know, be more thread safe and check out
**[00:16:15]** safe.
**[00:16:15]** And then it said it added a second check.
**[00:16:17]** It even added a second check in here because it,
**[00:16:19]** it gives the mention that this isn't truly transactional.
**[00:16:22]** We're, we're doing our best with kind of managing it.
**[00:16:25]** If you really wanted to, you can make it an
**[00:16:27]** actual SQL transaction.
**[00:16:27]** But in the code, this is what we're doing.
**[00:16:31]** So I can go ahead and I can commit that
**[00:16:32]** and push it back and, and make the change.
**[00:16:34]** The last thing I want to show is with all
**[00:16:38]** that real quick, just in the terminal, Yeah.
**[00:16:42]** And I can give a little test.
**[00:16:43]** So I have a harness that fires 20 requests.
**[00:16:46]** So again, it's kind of the thing of there's one
**[00:16:48]** pair of boots left, 20 people really want this boot.
**[00:16:52]** We want to make sure that only one person actually
**[00:16:53]** gets assigned it.
**[00:16:54]** So we're going to run it.
**[00:16:55]** So we made the change, run through this test real
**[00:16:58]** simple.
**[00:16:59]** And if everything works out, then we have.
**[00:17:01]** Yeah, we wanted one.
**[00:17:02]** We got one.
**[00:17:03]** Pretty straightforward.
**[00:17:05]** So what I'll leave you with is going back to
**[00:17:08]** which way I want to go by adding in, you
**[00:17:12]** know, post mortem information, RCA information, open telemetry data.
**[00:17:17]** You can do some of it, You can do all
**[00:17:19]** of it.
**[00:17:19]** You don't have to have it all together.
**[00:17:20]** But even just adding in open telemetry information to looking
**[00:17:24]** in for when spikes change by being able to call
**[00:17:26]** elastic search automatically as part of a GitHub action, you
**[00:17:30]** can get ahead of, you know, hopefully reoccurring production issues
**[00:17:34]** that happen.
**[00:17:35]** You can also load in some information if you were
**[00:17:37]** running in in dev and you run those post forums
**[00:17:39]** in dev and get ahead of them, you can load
**[00:17:41]** that in there so that these lessons learned in dev,
**[00:17:44]** you can store them in there and we can match
**[00:17:46]** that way.
**[00:17:46]** So thank you for hanging out.
**[00:17:49]** Elastic is over in the other building.
**[00:17:51]** We have these little you can build Legos and clicky
**[00:17:53]** things if you like fidgeting with things like I do.
**[00:17:56]** I appreciate everyone hanging out and thank you.
