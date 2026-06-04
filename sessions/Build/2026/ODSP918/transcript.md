**[00:00:03]** RAVISH PATEL: Hi, everyone.
**[00:00:03]** My name is Ravish and I work at PingCAP on TiDB
**[00:00:07]** as a solutions engineer.
**[00:00:08]** Over the next 20 minutes or so, I'm going to show you how
**[00:00:12]** to build agent memory for your AI agents using just SQL.
**[00:00:17]** There's also a demo halfway through, so hopefully,
**[00:00:20]** you stick around, and let's get started.
**[00:00:25]** Before we get into TiDB, real quick, I want to talk
**[00:00:28]** about why agents are different.
**[00:00:31]** It's because they hit a database in completely different ways
**[00:00:34]** than the apps you've worked on before.
**[00:00:37]** There are three big things.
**[00:00:39]** First, agent workloads are bursty, right?
**[00:00:42]** One agent might be running out flat for 10 seconds,
**[00:00:45]** and then the other one might be sitting idle
**[00:00:47]** for two hours doing nothing, and your database has to handle both
**[00:00:52]** without costing you a lot of money.
**[00:00:54]** Second is you're dealing with massive concurrency.
**[00:00:58]** It's not an app with a thousand users, but instead,
**[00:01:02]** you're running millions of agents at the same time
**[00:01:04]** and each with their own state.
**[00:01:08]** Third is constant context recall.
**[00:01:11]** Basically, every step the agent takes,
**[00:01:13]** it has to remember what just happened.
**[00:01:16]** Otherwise, the whole thing will fall apart.
**[00:01:20]** Those are the three things you can't really skip.
**[00:01:23]** Let me quickly show you what most teams end up doing today.
**[00:01:32]** Here's the situation.
**[00:01:33]** Let's say an agent finishes a chat with the user.
**[00:01:36]** The user comes back tomorrow,
**[00:01:38]** and the agent has no clue who the user is.
**[00:01:41]** It's like the conversation never happened.
**[00:01:45]** To fix that, what most teams end
**[00:01:47]** up doing is they run three different databases plus a bunch
**[00:01:51]** of ETL pipelines, and that's their memory layer.
**[00:01:56]** You've got your regular database for storing chat history,
**[00:01:59]** user accounts, that kind of stuff,
**[00:02:02]** and that's the source of truth.
**[00:02:04]** Then on top of that, you have a vector database
**[00:02:07]** for semantic search so you can store embeddings
**[00:02:10]** of whatever the user said.
**[00:02:13]** On top of that, you have a search engine
**[00:02:16]** because vectors are bad at exact matches.
**[00:02:19]** If the user said a word like, let's say, "Tokyo,"
**[00:02:23]** you want a keyword index
**[00:02:24]** to actually find that word, "Tokyo."
**[00:02:28]** Then there's the fourth piece nobody really talks about,
**[00:02:30]** which is the glue layer.
**[00:02:32]** That's your ETL jobs, your message buses, the client jobs,
**[00:02:36]** something to keep all three of these things in sync,
**[00:02:40]** and your team has to write and maintain that code.
**[00:02:45]** So now, you've got three databases to run,
**[00:02:48]** three separate builds from three databases,
**[00:02:50]** and three things that can break.
**[00:02:54]** On top of that, your data is never really
**[00:02:56]** in sync, so it's just a lot.
**[00:03:03]** Now, look, if you're building just a regular application,
**[00:03:07]** you can kind of sort of live with this.
**[00:03:09]** It's annoying, but I guess you can deal with it.
**[00:03:12]** However, with agents, though, this stack breaks in a bunch
**[00:03:15]** of ways, and here's why.
**[00:03:17]** The first one is stale data.
**[00:03:20]** Your vector index is always a few seconds behind your main
**[00:03:23]** database, so the agent ends up reading old data and old facts.
**[00:03:29]** Let's say a user updated their address an hour ago,
**[00:03:31]** but the agent is still using the old one.
**[00:03:34]** Then you've got the read-after-write problem.
**[00:03:37]** Say your agent just placed an order, and two seconds later,
**[00:03:41]** the user asks, "What is the status of my order?"
**[00:03:44]** and the agent says, "I don't see any orders."
**[00:03:47]** The write just happened, but the read side hasn't caught up yet.
**[00:03:53]** Then the third one is partial writes.
**[00:03:55]** Agent, let's say, does a multi-step thing,
**[00:03:58]** like processing a refund.
**[00:04:00]** It deducts the balance, logs the refund event,
**[00:04:03]** triggers some sort of an email.
**[00:04:07]** Now, midway through, the email service dies
**[00:04:10]** so the balance shows that the refund was applied.
**[00:04:14]** The log says that it happened,
**[00:04:16]** but the user never got the email.
**[00:04:19]** Then the user calls the support, and support sees the logs
**[00:04:22]** and says it looks fine,
**[00:04:24]** so you're stuck explaining a ghost refund.
**[00:04:28]** The last one is a connection fan out, so for example,
**[00:04:32]** let's say you have 10,000 agents times the three systems is
**[00:04:36]** basically 30,000 connections you need to maintain and manage.
**[00:04:41]** Your connection pools can basically keep
**[00:04:44]** up with those connections, so your latency goes
**[00:04:47]** up when the traffic spikes, and you spend half
**[00:04:50]** of your time managing connections instead
**[00:04:52]** of building features.
**[00:04:56]** Look, this is all not just theory or hypothetical.
**[00:05:00]** This stuff actually happens in production, and you only run
**[00:05:04]** into it once you're at scale,
**[00:05:06]** which is the worst possible time for it to happen.
**[00:05:13]** That's where TiDB comes into play.
**[00:05:15]** Real quick, in case you haven't heard of TiDB before,
**[00:05:18]** here's a quick summary.
**[00:05:20]** So first, it is a distributed SQL database,
**[00:05:22]** so it can scale horizontally across nodes,
**[00:05:25]** so no sharding, no rewrites.
**[00:05:28]** You just add nodes and capacity whenever you need it.
**[00:05:32]** Second, it is MySQL compatible.
**[00:05:34]** Any drivers you have, any ORM, any tools you're using
**[00:05:38]** with MySQL, it works with TiDB as well.
**[00:05:42]** Third is it has an HTAP and an AI engine, so transactions,
**[00:05:47]** analytics, vector search,
**[00:05:49]** and full-text search all live in the same database.
**[00:05:54]** Fourth, it's used in production by many of our customers
**[00:05:58]** like Manus, Pinterest, Dify, and a lot of others.
**[00:06:03]** That's basically a quick overview of what TiDB is.
**[00:06:07]** Now let's go ahead and get into the capabilities.
**[00:06:13]** All right.
**[00:06:14]** Here's what TiDB gives your agents.
**[00:06:18]** The first three rows fix the three data problems
**[00:06:21]** that we just talked about, and the last two are extras
**[00:06:24]** that kind of just make your life easier
**[00:06:27]** when you're building agents.
**[00:06:29]** The first one is agent state and chat history.
**[00:06:33]** That's just normal SQL.
**[00:06:35]** Next up, we have semantic recall,
**[00:06:37]** which is a vector column with an HLSW index.
**[00:06:41]** Next is keyword search, which is a full-text index
**[00:06:45]** with a multilingual parser, so it can handle English, Spanish,
**[00:06:49]** Japanese, whatever you throw at it.
**[00:06:52]** Then we have embeddings on insert, which is nice.
**[00:06:56]** There's actually a SQL function called, "embed underscore text,"
**[00:07:01]** which basically you can give it some text
**[00:07:03]** and it will call the embedding model
**[00:07:05]** and it will store the vector for you in the table.
**[00:07:09]** The last one is hybrid retrieval,
**[00:07:11]** so you can run a vector search and on top of that,
**[00:07:14]** you can run a keyword search and then you can combine them
**[00:07:18]** with some sort of ranking algorithm.
**[00:07:22]** We're going to see all of this during the demo
**[00:07:24]** in just a second.
**[00:07:29]** Now, just one more slide and then we'll get into the demo.
**[00:07:33]** This goes back to what I said at the start
**[00:07:35]** about agents having different needs from a database.
**[00:07:39]** The first thing you get from TiDB is you get scale to zero.
**[00:07:43]** If you have idle agents,
**[00:07:45]** they literally don't cost you anything.
**[00:07:48]** You're only paying for the requests you actually run
**[00:07:51]** so when your traffic is bursty, your bill is bursty too.
**[00:07:57]** Then you get database branching.
**[00:07:59]** You can spin up an isolated database per agent
**[00:08:02]** in just a few milliseconds.
**[00:08:04]** Every agent gets its own workspace,
**[00:08:07]** totally separated from everyone else.
**[00:08:11]** Third is resource control
**[00:08:13]** so you can cap how much each workload uses,
**[00:08:17]** so if one agent goes off the rail,
**[00:08:20]** it doesn't take down everything else.
**[00:08:23]** The last one is fast scale out.
**[00:08:26]** Compute and storage are separated in TiDB,
**[00:08:29]** so when the traffic spikes, the database can add capacity
**[00:08:33]** in seconds instead of minutes.
**[00:08:37]** Okay, that's enough slides.
**[00:08:39]** Let me show you in the database.
**[00:08:43]** Okay. In Demo 1, we're going to create the memory table.
**[00:08:50]** Okay. Here we are in the SQL editor on a free TiDB cluster,
**[00:08:54]** and I'm going to run the whole demo on just one table.
**[00:08:58]** So up top, you see normal columns like a user ID,
**[00:09:01]** just a regular ID, content, a timestamp.
**[00:09:06]** The interesting one, however, is the embedding column.
**[00:09:09]** It's a vector with 1,536 dimensions,
**[00:09:13]** and it is a generated column.
**[00:09:15]** Every time a row gets inserted,
**[00:09:18]** TiDB calls the function called embed underscore text,
**[00:09:21]** which is pointed at my Azure Open API deployment,
**[00:09:25]** and it generates the embedding and stores it,
**[00:09:28]** no Python, no pipeline.
**[00:09:30]** Plus, at the end, you also see there's a vector index
**[00:09:33]** for semantic search and a full text index for keyword search,
**[00:09:37]** both on the same table.
**[00:09:39]** As you can see, the table is created.
**[00:09:45]** The step #2 for the demo is inserting memories
**[00:09:48]** and seeing the data.
**[00:09:55]** Now, I'm going to drop the five memories for user ID 42.
**[00:09:59]** As you can see, they are plain English strings,
**[00:10:03]** no embedding code in my script anywhere,
**[00:10:05]** but TiDB is calling the Azure Open API in the background
**[00:10:09]** to generate the embeddings.
**[00:10:12]** There they are, so you see five rows for "Jazz," "Vinyl,"
**[00:10:16]** "Peanut Allergy," "Tokyo Flight," "Email Preference,"
**[00:10:20]** and yeah, that's our data set that we're going to use
**[00:10:23]** for the rest of the demo.
**[00:10:31]** Step #3 is going to be semantic search.
**[00:10:38]** So here, the agent is asking, let's say,
**[00:10:41]** what does the user like to listen to?
**[00:10:43]** So notice, my question doesn't share a single keyword
**[00:10:46]** with anything in the database.
**[00:10:48]** There's no listen, no like, just Jazz and Miles Davis,
**[00:10:54]** but as you can see, the jazz row comes back first,
**[00:10:58]** and you can see the distance is 0.49.
**[00:11:02]** That's the closest batch by meaning,
**[00:11:05]** so TiDB took my English question, embedded it,
**[00:11:08]** and ranked the rows by similarity, all in one SQL call.
**[00:11:16]** Step #4 is keyword search.
**[00:11:22]** Now, sometimes you want exact word matching instead, you know,
**[00:11:27]** so vectors are kind of bad at that.
**[00:11:30]** Here, we're using a full text search to check
**[00:11:32]** if the user mentioned a city, and once we execute the query,
**[00:11:37]** you can see there will be a row, the Tokyo row,
**[00:11:40]** which is the exact match.
**[00:11:42]** Then you can also see the score of 1.34.
**[00:11:46]** The big thing here is this is the same table I just did vector
**[00:11:51]** search on, no separate engine, to keep everything in sync.
**[00:11:57]** Step #5 is hybrid search.
**[00:12:04]** So, okay, I guess this one really matters,
**[00:12:06]** so real hybrid search isn't just one query.
**[00:12:10]** It basically is two searches plus a ranking step on top,
**[00:12:15]** so what's happening here is the first common expression is
**[00:12:18]** running a vector search, grabbing the top 10 rows
**[00:12:21]** by meaning, and the second common table expression is
**[00:12:25]** running a keyword search,
**[00:12:26]** grabbing the top 10 by exact word match.
**[00:12:29]** Then we're combining them using something called reciprocal rank
**[00:12:33]** fusion or RRF.
**[00:12:36]** The data is super simple.
**[00:12:38]** Rows that rank high in both lists basically win,
**[00:12:43]** so I'm asking what dietary restrictions the user has.
**[00:12:46]** The vector is looking for the meaning.
**[00:12:49]** Keyword is looking for the words like "allergy" and "peanut,"
**[00:12:52]** and as you can see, the peanut allergy row comes first
**[00:12:55]** because it's scored well in both of these searches, the vector
**[00:13:00]** and the keyword search.
**[00:13:02]** One query, one database, no separate engines
**[00:13:06]** to keep everything in sync.
**[00:13:10]** The last one is going
**[00:13:11]** to be asset transactions across tables.
**[00:13:16]** So real agents, as we know, do multi-step writes that have
**[00:13:21]** to land together, and there are two tables here.
**[00:13:24]** So there's a memory table you've been seeing,
**[00:13:26]** and there's also a separate user facts table
**[00:13:29]** where we track aggregate stats per user, like their trips
**[00:13:33]** and their memory count.
**[00:13:35]** Now, what's happening here is I'm wrapping a transaction
**[00:13:38]** around two writes, insert into memories,
**[00:13:42]** update the user facts table, and then commit.
**[00:13:45]** As you can see, the new memory is in the memories,
**[00:13:48]** and trip counters went from 0 to 1
**[00:13:51]** and memory counter went from 0 to 1 as well.
**[00:13:55]** Both writes landed together, and if either one had failed,
**[00:13:58]** neither would have stuck.
**[00:14:00]** That's real distributed asset across multiple tables.
**[00:14:07]** Okay, so that was the whole demo.
**[00:14:09]** Now let me close out with a few companies actually running TiDB
**[00:14:12]** in production.
**[00:14:14]** These are real numbers and not just benchmarks.
**[00:14:17]** The first one is Manus.
**[00:14:19]** They are an AI startup company,
**[00:14:21]** and every agent gets its own database spun
**[00:14:24]** up in milliseconds.
**[00:14:26]** Over a million and a half of these agents right now,
**[00:14:29]** and they moved over to TiDB and got to production in two weeks.
**[00:14:35]** Then we have Dify.
**[00:14:36]** They are an AI dev platform company and their backend used
**[00:14:40]** to be a 500,000 containers, and they moved all of it onto TiDB.
**[00:14:46]** Now they just have one engine that does everything,
**[00:14:51]** and then we also have Pinterest.
**[00:14:52]** I mean, they are not an AI company,
**[00:14:54]** but the problem they had was very similar.
**[00:14:57]** They had six different databases systems doing different jobs.
**[00:15:00]** Now they'll have only one, which is TiDB, and TiDB is doing,
**[00:15:05]** basically, 1.3 million queries per second for Pinterest.
**[00:15:11]** Across all three, the story is basically the same.
**[00:15:14]** You have less stuff, more speed,
**[00:15:16]** and engineers building product instead of patching pipelines.
**[00:15:24]** Just a quick recap before I wrap up.
**[00:15:26]** With TiDB, you get auto-embeddings on inserts,
**[00:15:29]** no more Python pipelines.
**[00:15:31]** You get vector, full text search,
**[00:15:33]** and SQL all on the same table,
**[00:15:35]** so you've got one source of truth.
**[00:15:38]** You also get hybrid search the right way,
**[00:15:42]** two searches with RRF on top.
**[00:15:45]** The whole engine is built for how, actually,
**[00:15:47]** agents run with branching, scale to zero, and resource control.
**[00:15:53]** The best part is you can spin up a free cluster in 30 seconds,
**[00:15:56]** and it can scale to millions of agents.
**[00:16:01]** All right.
**[00:16:02]** If you want to try this, here's where to go.
**[00:16:04]** You go to TiDB.com, which is the main one.
**[00:16:08]** You can spin up a free TiDB starter cluster, no credit card,
**[00:16:12]** and your cluster is going to be ready within 30 seconds.
**[00:16:16]** TiDB also has a native Azure Open AI integration,
**[00:16:19]** so you can very easily integrate your Azure deployment.
**[00:16:24]** For agent patterns and the customer stories I just talked
**[00:16:27]** about, you can go to pinkhat.com/ai/agenticai.
**[00:16:33]** Now, if you are a Python developer, we have a Python SDK,
**[00:16:37]** which you can install by doing "pip install pytidb,
**[00:16:41]** and that gets you hybrid search and RRF in three lines.
**[00:16:46]** For cursor and Claude users, we do have an MCP server
**[00:16:51]** and a bunch of agent rules on github.com/pinkapp/ agentrules,
**[00:16:56]** so you can drop TiDB directly into your AI coding workflow.
**[00:17:01]** That's pretty much all I have, so thank you all so much
**[00:17:04]** for watching and go build something cool with TiDB
**[00:17:07]** and stop running three databases when you only need one.
