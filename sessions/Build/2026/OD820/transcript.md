**[00:00:03]** JUSTINE COCCHI: Hi, I'm Justine Cocchi,
**[00:00:05]** and I'm a Program Manager on the Azure Cosmos DB team.
**[00:00:08]** I'm joined today by Aayush Kataria,
**[00:00:11]** who's a software engineer also working on Cosmos DB.
**[00:00:14]** We're excited to talk to you today
**[00:00:16]** about designing reliable multi-agent apps
**[00:00:19]** with Azure Cosmos DB, and the example
**[00:00:21]** that we'll use today is a travel assistant,
**[00:00:24]** which is a multi-agent AI application
**[00:00:27]** that helps you plan personalized trips.
**[00:00:29]** One of the functionalities
**[00:00:31]** of our application is a chat feature.
**[00:00:34]** When a user wants to plan a trip, they can start a chat
**[00:00:37]** by saying something like "Plan a trip to Paris."
**[00:00:40]** This first gets routed to our orchestrator agent,
**[00:00:43]** who then can pass the message
**[00:00:45]** to various specialist agents, like the hotel agent.
**[00:00:48]** We can look up memories in Azure Cosmos DB with contacts
**[00:00:52]** that we already have stored about this user.
**[00:00:54]** We can embed the initial query with Azure Open AI,
**[00:00:58]** so that we can turn it into vectors that we can then search
**[00:01:01]** against our existing other metadata, like places
**[00:01:04]** and restaurants and hotels in Paris
**[00:01:06]** that may be useful for our user.
**[00:01:09]** Then we're ready to send our message back with the data
**[00:01:12]** that we found and help them plan their trip.
**[00:01:15]** This is just an example of one turn, and if we look
**[00:01:18]** at the user interaction flow, we can see many pieces of data
**[00:01:22]** that are moving through this user journey, from the message
**[00:01:25]** to the various agents we're talking to, when we're ready
**[00:01:28]** to actually create the trip, and lastly,
**[00:01:31]** we need to extract the memories
**[00:01:32]** so that we can remember what's happened next time the user
**[00:01:35]** comes and logs into our website.
**[00:01:38]** There's various things that we want to focus
**[00:01:40]** on in different parts of the user flow
**[00:01:43]** that will really help us keep the best user experience.
**[00:01:46]** In the beginning, the latency
**[00:01:47]** and personalization is the most important.
**[00:01:50]** We want to make sure the agent remembers key things
**[00:01:52]** about our users and that the responses are very fast.
**[00:01:56]** Otherwise, the user may become frustrated and they may go
**[00:01:58]** to one of our competitor travel sites.
**[00:02:01]** Whereas, in the back half, consistency
**[00:02:03]** and reliability become more important.
**[00:02:05]** We don't want to accidentally double-book a trip
**[00:02:07]** or forget something that we already talked about.
**[00:02:10]** So really keeping in mind the user perspective
**[00:02:13]** as we build our application will help us ensure
**[00:02:16]** that our application is reliable.
**[00:02:18]** Now, I want to zoom in on one thing,
**[00:02:20]** which is the number of agents here.
**[00:02:22]** We've talked about an orchestrator
**[00:02:23]** and some specialists.
**[00:02:25]** I want to hand it off to Aayush who's going to talk more
**[00:02:27]** about the multi-agent pattern
**[00:02:28]** and how it can help us in our application.
**[00:02:31]** AAYUSH KATARIA: Thanks, Justine.
**[00:02:32]** Going over the travel scenario that we'll be discussing today.
**[00:02:37]** Hi, I'm Aayush Kataria.
**[00:02:39]** I'm a software engineer at Azure Cosmos DB.
**[00:02:42]** So let's dive into why multi-agent.
**[00:02:45]** So let's start with what goes wrong when you don't.
**[00:02:49]** So on the left, you see the single-agent problem.
**[00:02:53]** When you have one agent trying
**[00:02:55]** to handle every domain all packed
**[00:02:58]** into a single system prompt, the model gets confused.
**[00:03:01]** It doesn't know which capability to invoke or when.
**[00:03:05]** There's no separation of concerns,
**[00:03:07]** so every change risks breaking something else.
**[00:03:10]** You can't scale or improve any area of expertise
**[00:03:14]** without touching everything.
**[00:03:16]** And as conversations grow longer,
**[00:03:18]** you hit context window limits.
**[00:03:20]** The model starts forgetting earlier parts
**[00:03:22]** of the conversation, leading to inconsistent behavior.
**[00:03:26]** So on the right-hand side, we have the multi-agent solution.
**[00:03:30]** Instead of one monolithic agent, you have specialized agents,
**[00:03:34]** each with a focus prompt and a specific set of tools.
**[00:03:38]** So an orchestrator sits on top, routes the user's request
**[00:03:42]** to the right specialist based on the intent,
**[00:03:45]** so this gives us a few big wins.
**[00:03:47]** So first, each agent has a smaller,
**[00:03:50]** more focused context, so it reasons better.
**[00:03:54]** Second, you can develop and update agents independently.
**[00:03:58]** Adding a new specialist doesn't require touching existing ones.
**[00:04:03]** Third, it's composable.
**[00:04:05]** You can plug in new capabilities
**[00:04:07]** without rewriting the whole system.
**[00:04:11]** So now let's look at how agentic memory works better
**[00:04:16]** than retrieval-augmented generation.
**[00:04:20]** So this is where we get into, I think,
**[00:04:24]** which is the most interesting part of the stock.
**[00:04:27]** That is agentic memory.
**[00:04:29]** So most people are familiar with RAG.
**[00:04:32]** That's retrieval-augmented generation.
**[00:04:34]** You have a knowledge base, you embed documents,
**[00:04:37]** and when a user asks a question, you retrieve the relevant chunks
**[00:04:40]** and feed them to the model.
**[00:04:42]** So it works well for what it does
**[00:04:45]** but has fundamental limitations
**[00:04:47]** when you're building agent-based applications.
**[00:04:50]** So let's walk through the comparison.
**[00:04:52]** Traditional RAG is static.
**[00:04:55]** Your knowledge base is fixed until you explicitly update it.
**[00:04:59]** Agentic memory, on the other hand, is dynamic.
**[00:05:01]** It grows automatically with every interaction.
**[00:05:05]** RAG gives the same results to everyone.
**[00:05:08]** It's searching a shared corpus.
**[00:05:10]** Agentic memory is user specific.
**[00:05:12]** It stores individual preferences and history,
**[00:05:16]** so two different users get completely
**[00:05:19]** different experiences.
**[00:05:21]** RAG retrieves by similarity alone.
**[00:05:24]** Whatever is closest in the embedding space comes back.
**[00:05:27]** Agentic memory uses salient scoring, which factors
**[00:05:30]** in importance, confidence, and resiliency.
**[00:05:34]** RAG doesn't learn from interactions.
**[00:05:36]** It's just a pure lookup.
**[00:05:39]** Agentic memory actively learns and adapts.
**[00:05:42]** Every conversation is an opportunity
**[00:05:45]** to extract new knowledge.
**[00:05:48]** And RAG has no concept of time.
**[00:05:51]** Agentic memory supports cross-session persistence
**[00:05:54]** with TTL policies.
**[00:05:56]** Let's now go over the system architecture
**[00:06:00]** for our travel agent application that we are going to demo
**[00:06:04]** at the later end of the session.
**[00:06:07]** So now let's zoom out and look at the full system architecture.
**[00:06:12]** So everything starts when a message lands
**[00:06:15]** in the orchestrator agent.
**[00:06:17]** This is the front door of our application,
**[00:06:20]** so every conversation comes through the orchestrator first.
**[00:06:23]** Its only job is to understand intent and decide
**[00:06:28]** which specialist should handle it.
**[00:06:31]** After that, there are specialized agents --
**[00:06:34]** hotel, dining, and activity.
**[00:06:36]** Each one owns a single domain, so has its own system prompt
**[00:06:42]** and pulls from a focused set of tools.
**[00:06:46]** In our multi-agent application,
**[00:06:48]** none of these agents are talking directly to the database.
**[00:06:53]** They go through the MCP server, which has many tools,
**[00:06:58]** like recall memories, discover places,
**[00:07:01]** transfer between different agents, and many more.
**[00:07:04]** The point of MCP is decoupling, so we can update or add tools
**[00:07:10]** without touching agent code, and one tool can be reused
**[00:07:15]** across every other agent.
**[00:07:17]** So underneath the MCP layer, we have our Azure Cosmos DB.
**[00:07:21]** It stores everything the application needs, sessions,
**[00:07:25]** messages, places, trips, API events, among others.
**[00:07:30]** Places are searched using hybrid search,
**[00:07:33]** and every container uses a hierarchical partition key,
**[00:07:37]** so the system is multi-tenant from day one.
**[00:07:41]** Next, we have the agent memory toolkit,
**[00:07:44]** which is a new Cosmos DB offering
**[00:07:47]** to host your memory layer, so for any multi-agent application.
**[00:07:52]** It is a separate background runtime
**[00:07:55]** that hands off the same Cosmos DB account
**[00:07:58]** that I mentioned before.
**[00:07:59]** It owns its own container called "memories"
**[00:08:03]** where the actual turns of the conversation, facts extracted
**[00:08:07]** from those turns, the user summaries, the thread summaries,
**[00:08:10]** everything is stored, and the agent never calls it directly.
**[00:08:15]** And then we have the Azure OpenAI
**[00:08:18]** which is providing the LLM reasoning
**[00:08:20]** and embedding capabilities.
**[00:08:22]** It's a shared utility that feeds both the agent runtime
**[00:08:26]** and the toolkit pipeline.
**[00:08:29]** Now let's go over some concepts about memory and agentic memory.
**[00:08:35]** So before we go deeper into memory,
**[00:08:38]** let's establish a clear vocabulary.
**[00:08:41]** People use the word "memory" loosely, so let's be precise.
**[00:08:45]** So there are three distinct concepts here.
**[00:08:48]** State, which is the snapshot
**[00:08:51]** of your entire application at any given moment.
**[00:08:55]** It contains everything needed to restore the application
**[00:08:58]** to that exact point, what the user said,
**[00:09:01]** what the agent decided, what tools were called.
**[00:09:05]** Then we have short-term memory, which is what happens
**[00:09:09]** within that particular single session.
**[00:09:12]** It's the conversation history,
**[00:09:14]** the messages going back and forth.
**[00:09:16]** This is what lets an agent refer back
**[00:09:19]** to something the user said three messages ago
**[00:09:22]** and give a coherent response.
**[00:09:25]** Then we have the long-term memory.
**[00:09:27]** This is where things actually start to get more powerful.
**[00:09:31]** This persists across sessions.
**[00:09:33]** When a user comes back days or weeks later,
**[00:09:36]** the agent can recall what it learned about them previously,
**[00:09:40]** their preferences, past decisions, feedback,
**[00:09:43]** and this is what enables personalization
**[00:09:46]** and learning over time.
**[00:09:48]** It's the difference between an agent
**[00:09:50]** that starts fresh every conversation and one
**[00:09:53]** that builds a relationship with the user.
**[00:09:57]** JUSTINE COCCHI: So Aayush,
**[00:09:58]** these are really interesting different types of memory.
**[00:10:01]** I'm wondering, how can we implement these
**[00:10:03]** into our travel application?
**[00:10:06]** AAYUSH KATARIA: Yeah.
**[00:10:06]** So in our travel application, we are going to implement all three
**[00:10:10]** of these different kind of memories.
**[00:10:12]** State management through LangGraph Cosmos DB checkpointer
**[00:10:15]** integration, and then short-term memory and long-term memory
**[00:10:19]** through the dedicated agent memory toolkit backed
**[00:10:22]** by Cosmos DB.
**[00:10:24]** Now let's move over to the code and I'll go
**[00:10:27]** over a few more core concepts, and then we can jump
**[00:10:31]** into our UI demo and look
**[00:10:34]** and get the feel how the agent memory toolkit works
**[00:10:37]** with our multi-agent application.
**[00:10:40]** So we just talked
**[00:10:41]** about long-term memory at a high level.
**[00:10:44]** Now I want to break that down
**[00:10:46]** because not all long-term memories are the same,
**[00:10:49]** and the toolkit reflects
**[00:10:51]** that with four different types of memories.
**[00:10:54]** So the reason this matters is each type has a different
**[00:10:58]** lifetime, a different way of being created,
**[00:11:01]** and a different way the agent uses it.
**[00:11:04]** So let's walk through them.
**[00:11:06]** As you can see here, we have a few different types of memory
**[00:11:11]** that we are storing in our agent memory toolkit.
**[00:11:15]** First is the facts, so sometimes called "semantic memory."
**[00:11:19]** These are simple, durable statements about the user.
**[00:11:23]** User is vegetarian, travels with a wheelchair, lives in Seattle.
**[00:11:27]** They are objectively true.
**[00:11:28]** They don't change often and they should never expire.
**[00:11:31]** Second is the procedural memory.
**[00:11:34]** This is behavioral patterns, preferences inferred
**[00:11:38]** from how the user actually behaves
**[00:11:40]** over multiple conversations, tends to book boutique hotels
**[00:11:44]** over chains, prefers late dinners.
**[00:11:47]** These are softer than facts, so the user might never say them
**[00:11:52]** out loud, but they emerge from repetition.
**[00:11:55]** They also never expire by default
**[00:11:58]** because behavioral patterns are usually stable.
**[00:12:02]** Third is episodic memory.
**[00:12:05]** These are tied to a specific time and place.
**[00:12:09]** Visited New York City in last spring,
**[00:12:12]** loved seafood on my Barcelona trip.
**[00:12:14]** These are how the system knows to reference a past trip
**[00:12:19]** when planning a new one, and these do expire.
**[00:12:24]** So the default is 90 days.
**[00:12:26]** Episodic memory gets a little noisy too fast,
**[00:12:30]** and a recommendation system doesn't really need
**[00:12:34]** to remember a coffee shop
**[00:12:36]** that you went probably four years ago.
**[00:12:39]** Fourth is the user summary.
**[00:12:41]** This is different from the other three.
**[00:12:44]** It's not extracted from a single message.
**[00:12:47]** It's a rolling synthesis of who this user I,
**[00:12:51]** regenerated automatically every few turns.
**[00:12:54]** It can be something like
**[00:12:57]** "This user is a frequent solo traveler, vegetarian,
**[00:13:01]** prefers cultural over outdoor, mid-range hotels."
**[00:13:06]** So the orchestrator pulls these into its system prompt
**[00:13:10]** at the start of every conversation.
**[00:13:14]** So even on day one of a brand-new session,
**[00:13:17]** the agent already knows the user.
**[00:13:21]** So let's go and look how it looks in the UI.
**[00:13:29]** So let me sign in with a user, Tony,
**[00:13:31]** for which we already have some preferences loaded.
**[00:13:38]** So let me go talk with the chat assistant.
**[00:13:40]** Let's say, "Hi, I am planning a trip to Tokyo,"
**[00:13:51]** and you'd be able to see that it's actually in the logs
**[00:13:55]** where my API server is running
**[00:13:57]** that it's actually going to the orchestrator.
**[00:14:00]** Orchestrator then works its magic,
**[00:14:02]** figure out what's the intent of the particular user,
**[00:14:05]** what tools would I be using, where should I go,
**[00:14:10]** and then eventually it gives us a response that, "Hello,
**[00:14:13]** to get started with Tokyo trip planning,
**[00:14:15]** please let me know what hotels you want,
**[00:14:19]** what activities you want to do."
**[00:14:21]** So let's see.
**[00:14:22]** Let's ask it what are my hotel preferences,
**[00:14:30]** and if we'll actually head back to the portal, we can actually,
**[00:14:34]** for that particular user in our memories container,
**[00:14:37]** I can search what all facts are actually stored.
**[00:14:41]** So if I'll execute this query, I can see the user's name is Tony.
**[00:14:48]** Tony prefers luxury five-star hotels.
**[00:14:51]** He loves art museums
**[00:14:53]** and contemporary galleries and everything.
**[00:14:56]** So if we'll head back to our UI, I can actually see that,
**[00:15:01]** based on your past interactions, here's what I know
**[00:15:03]** about your hotel preferences.
**[00:15:05]** You prioritize reliable Wi-Fi over price for business trips.
**[00:15:09]** You enjoy rooftop bars and quiet evenings during work travel.
**[00:15:13]** So similarly, I would be able to fetch my preferences
**[00:15:18]** for activities, my preferences for restaurants,
**[00:15:24]** my dietary preferences.
**[00:15:26]** So that way the agent toolkit is extracting the memories,
**[00:15:30]** storing those preferences back in Cosmos DB,
**[00:15:33]** and when the user is coming, and actually chatting
**[00:15:37]** with the chat assistant.
**[00:15:38]** It's able to leverage those preferences and memories back
**[00:15:41]** into the conversation.
**[00:15:43]** Now let's head back to the code once more
**[00:15:47]** and let's see how are we actually extracting all
**[00:15:53]** these memories.
**[00:15:54]** So storing memories is only half the challenge.
**[00:15:58]** The real value comes from making all this memory intelligent,
**[00:16:03]** meaning the system actively manages its own knowledge.
**[00:16:07]** So if we'll go to this particular class,
**[00:16:12]** we have public-facing APIs which are extracting memories,
**[00:16:17]** generating threat summary, generating user summary,
**[00:16:20]** and reconciling memories, which means conflict resolution.
**[00:16:24]** So the first piece is the threshold-driven extraction,
**[00:16:27]** which is extract memories.
**[00:16:29]** So the real value comes from making memories intelligent.
**[00:16:33]** So the user never has to say, "Remember this."
**[00:16:37]** As the conversation unfolds,
**[00:16:39]** a background pipeline runs every end turn
**[00:16:43]** in the agent memory toolkit and asks the LLM,
**[00:16:47]** "Is there anything new about this user worth remembering?"
**[00:16:50]** If the user is -- if the answer is yes, it pulls out a fact,
**[00:16:54]** classifies it as a fact, procedural or episodic memory,
**[00:16:58]** and writes it back to Cosmos DB.
**[00:17:01]** The agent loop doesn't wait on this.
**[00:17:04]** It happens asynchronously in the background.
**[00:17:07]** The second piece is conflict resolution, which is done
**[00:17:11]** by the reconciled memories method.
**[00:17:15]** So real conversations always would be contradicting.
**[00:17:19]** The user says "I'm vegan" on Monday.
**[00:17:22]** Three weeks later, they mention how much they love a steakhouse
**[00:17:25]** and they have started eating meat.
**[00:17:28]** So now what does the system do?
**[00:17:30]** So on a separate cadence,
**[00:17:32]** the toolkit periodically sweeps the user's facts
**[00:17:36]** and asks the LLM to classify the pairs of related memories
**[00:17:41]** so they can be either duplicates or updates.
**[00:17:44]** When it finds one, it doesn't delete the user.
**[00:17:47]** It marks it superseded by the winner.
**[00:17:51]** That is done so that the audit trail is preserved,
**[00:17:54]** so the user never sees a contradiction
**[00:17:57]** in the recommendations.
**[00:17:59]** But if you're debugging, say, six months later,
**[00:18:02]** you can still see exactly when
**[00:18:04]** and why the system changed its mind.
**[00:18:08]** The third place is rolling summaries.
**[00:18:11]** Conversations can get long.
**[00:18:13]** Token budgets are finite.
**[00:18:16]** The toolkit handles this by generating two kinds
**[00:18:19]** of summaries on a cadence.
**[00:18:21]** So one is threat summary
**[00:18:22]** that captures the current conversation,
**[00:18:24]** the current session, and the thread,
**[00:18:26]** and other is user summary that captures who this user is
**[00:18:31]** across all conversations.
**[00:18:33]** So just for this demo purposes, both user summary
**[00:18:38]** and threat summary are regenerated
**[00:18:40]** after every five turns, so we can actually see that happen
**[00:18:44]** in the demo in a few minutes.
**[00:18:47]** In production, the agent toolkit has like some default set
**[00:18:53]** which are tunable by the customer who's going
**[00:18:57]** to use the agent memory toolkit.
**[00:19:00]** So the orchestrator eventually pulls these summaries
**[00:19:03]** into context at the start of every turn,
**[00:19:07]** so even after a hundred messages,
**[00:19:09]** the agent doesn't lose the actual plot.
**[00:19:13]** The fourth piece is what I think of as the payoff.
**[00:19:18]** That is memory condition search.
**[00:19:20]** So everything that we've talked about so far is plumbing.
**[00:19:25]** This is where the memory shapes what the user actually sees.
**[00:19:30]** So before any specialist agent searches for a hotel
**[00:19:34]** or a restaurant, it recalls memories first
**[00:19:38]** to ask the toolkit, "What do we know
**[00:19:40]** about this user that's relevant to this particular query?"
**[00:19:44]** So the recall comes back with relevant facts and preferences,
**[00:19:48]** and the agent then encodes those
**[00:19:51]** as explicit filters on the search call.
**[00:19:54]** That's how "Show me hotels in Tokyo" becomes
**[00:20:00]** "Show me luxury hotels in Tokyo."
**[00:20:02]** So the personalization isn't bolted on at the end.
**[00:20:07]** It's baked into the query itself.
**[00:20:10]** So the agent memory toolkit runs all these automatically
**[00:20:14]** in the background on the right cadence
**[00:20:17]** without the application code having to coordinate them,
**[00:20:21]** and your agent always stays simple.
**[00:20:24]** So now let's go back to the UI
**[00:20:26]** and let's see how we'll choose a new user
**[00:20:30]** that has no preferences stored in our memories container.
**[00:20:34]** So let's see how the workflow is.
**[00:20:39]** So let me close this.
**[00:20:41]** Let me log out of this session.
**[00:20:45]** Let's choose a new user as Peter,
**[00:20:49]** and we can go in our portal.
**[00:20:51]** We can confirm that Peter doesn't have anything stored
**[00:20:56]** in the memories container.
**[00:21:02]** Let's go back here.
**[00:21:03]** Let's start a session.
**[00:21:04]** Let's say I'm planning a trip to Paris.
**[00:21:12]** Similarly, again, now if I'll go to my API server back
**[00:21:16]** in the terminal where it's running,
**[00:21:21]** I can see now it's the user is the user chosen as Peter.
**[00:21:25]** It's going to the orchestrator agent and, like,
**[00:21:28]** other tools that the orchestrator agent decides
**[00:21:31]** to go to.
**[00:21:32]** Let's head back to our UI.
**[00:21:34]** I have an answer.
**[00:21:35]** So, "Hello, I'd be happy to help you plan your trip to Paris.
**[00:21:39]** Would you like to start by finding hotels, restaurants,
**[00:21:41]** or activities, or perhaps create an itinerary?"
**[00:21:44]** So let's say I am vegan.
**[00:21:51]** If we'll head back to the portal,
**[00:21:53]** you can actually see some memories stored
**[00:21:56]** for that particular user.
**[00:21:58]** So this is a memory-type turn.
**[00:22:00]** Turn is nothing but just the conversation that the user
**[00:22:04]** and the agent is doing on our chat assistant.
**[00:22:09]** So as we said, I'm planning a trip to Paris.
**[00:22:12]** That is stored as a turn.
**[00:22:15]** And right now it's storing "I'm vegan" as a turn as well.
**[00:22:19]** If I'll execute the query again, you can see that it was able
**[00:22:23]** to extract the fact that the user is actually,
**[00:22:27]** in fact, vegan.
**[00:22:29]** So let me go back to the UI
**[00:22:31]** and let me deliberately contradict myself,
**[00:22:33]** and let's say I have started eating meat now.
**[00:22:42]** Again, if I go back to my portal, let me now filter it
**[00:22:46]** for just facts so that we can see how the fact is
**[00:22:52]** getting resolved.
**[00:22:54]** So right now we only have one fact here
**[00:22:57]** that the user is vegan.
**[00:22:59]** Let me execute the query again.
**[00:23:03]** So now you can see we have a new fact
**[00:23:05]** that the user has started eating meat and changing
**[00:23:09]** from a vegan diet, and if we go to the older fact
**[00:23:13]** that was the user is vegan, I can see that it's superseded
**[00:23:17]** by the same fact ID of my new fact so that
**[00:23:22]** that is done for an audit trail.
**[00:23:24]** As I explained before, if after six months or a year
**[00:23:28]** down the road you want to check like which fact was superseded
**[00:23:31]** by which fact, we would have a debug log, in that sense.
**[00:23:35]** Let's head back to the UI.
**[00:23:37]** Just couple of other things that I wanted to mention is
**[00:23:40]** that the prompt for these LLM models are our scripts
**[00:23:48]** that are written in our code itself.
**[00:23:50]** So if we'll go to -- go back to our code and I can show you
**[00:23:54]** like an extract memories prompt file.
**[00:23:57]** So here you can see that we are deliberately giving instructions
**[00:24:02]** to the LLM that these are the four different type of memories
**[00:24:07]** that you can extract, and we have given
**[00:24:10]** like detailed information in the prompt
**[00:24:12]** like what should be the structure
**[00:24:14]** of those memories rules according to like which rules
**[00:24:18]** and examples that what kind of a memory would be classified
**[00:24:22]** as fact, what would be classified as procedural,
**[00:24:24]** what would be classified as episodic, and similarly,
**[00:24:29]** prompts have been given -- the prompt, there are rules given
**[00:24:32]** to this prompt that what kind of turn should be extracted.
**[00:24:37]** So for an example, if my turn just has greetings
**[00:24:41]** to the assistant, those turns would not be extracted
**[00:24:45]** as a fact.
**[00:24:46]** So if I'm just saying hello, hi, good morning, good afternoon,
**[00:24:50]** so those turns would not be extracted.
**[00:24:53]** Now let's look at how summarization,
**[00:24:55]** auto-summarization works.
**[00:24:57]** So as I mentioned, just for this demo, we have set that cadence
**[00:25:02]** as five turns, so as soon as there would be five turns,
**[00:25:06]** auto-summarization would be generated.
**[00:25:08]** So let me ask it to recommend me some restaurants now.
**[00:25:19]** So now if we'll go back to our terminal window, I would be able
**[00:25:23]** to see that the orchestrator agent actually extracted the
**[00:25:28]** intent and it was able to call the dining agent
**[00:25:31]** to actually list the recommendations for restaurants.
**[00:25:37]** So let's go back to the UI and see what all results we get.
**[00:25:42]** So it can -- you can clearly see that it says
**[00:25:45]** that here are some restaurant recommendations in Paris
**[00:25:47]** and based on your updated dietary preference,
**[00:25:50]** so it's automatically picking up the current fact that we have
**[00:25:58]** in our memories container as we have already resolved
**[00:26:02]** that conflict and it's able
**[00:26:03]** to give us the correct recommended list of restaurants.
**[00:26:07]** Now, let's say, we can say, "Create an itinerary for Paris
**[00:26:15]** for three days," and as we can see,
**[00:26:19]** we have already done five turns with the agent,
**[00:26:23]** so we can actually go in our portal and also see
**[00:26:27]** if a summary is being extracted.
**[00:26:48]** So we can see that a user summary was extracted.
**[00:26:51]** If I run the query again, we should be able to see -- yeah.
**[00:26:59]** So we can see the user summary.
**[00:27:01]** The user is planning a trip to Paris.
**[00:27:03]** The user has changed their dietary preference
**[00:27:05]** from vegan to omnivore.
**[00:27:07]** So similarly, we would have a threat summary
**[00:27:10]** that would be extracted as well, and we can also see here
**[00:27:15]** that the itinerary agent was able
**[00:27:17]** to generate the whole itinerary for us.
**[00:27:21]** So the agent memory toolkit for Azure Cosmos DB is
**[00:27:25]** in public preview now.
**[00:27:27]** It has fact extraction, auto-summarization,
**[00:27:30]** and there are package instructions and prompts
**[00:27:34]** to do conflict resolution, extract different kind
**[00:27:38]** of memories, do user and thread summarization.
**[00:27:43]** Next, LangChain Azure Cosmos DB integration is also
**[00:27:48]** generally available.
**[00:27:49]** It's a integration package
**[00:27:53]** that has all the Cosmos DB integration for LangChain
**[00:27:56]** and LangGraph that were used to build
**[00:27:58]** that multi-agent application.
**[00:28:00]** You can use the vector store integration from LangChain.
**[00:28:04]** If you want to do state checkpointing
**[00:28:07]** for your multi-agent application,
**[00:28:09]** you can use the LangGraph checkpointer store.
**[00:28:12]** JUSTINE COCCHI: So Aayush,
**[00:28:13]** it looks like we've implemented the memory toolkit
**[00:28:16]** and LangChain, and there's a lot of touch points with Cosmos DB
**[00:28:20]** and many different containers.
**[00:28:22]** How can we verify that we're following all
**[00:28:24]** of the Cosmos DB best practices in this application?
**[00:28:27]** AAYUSH KATARIA: That's a really good question, Justine.
**[00:28:29]** So let me set up the scene.
**[00:28:32]** So most of the AI apps I've been building lately work.
**[00:28:37]** They pass the demos.
**[00:28:38]** They look great in a notebook, but there's a gap
**[00:28:41]** between it runs and it runs at scale
**[00:28:44]** without setting money on fire.
**[00:28:47]** So in Cosmos DB that gap is paved with decisions
**[00:28:52]** that you make on day one and pay for on day 90,
**[00:28:56]** that the partition keys you didn't think hard enough about,
**[00:28:59]** the indexing policy you left on defaults, the document shape
**[00:29:03]** that looked clean in code but blows up your IU build
**[00:29:07]** in production, so that's why we are introducing a Cosmos DB
**[00:29:12]** agent kit.
**[00:29:14]** So I'll show you.
**[00:29:17]** So you just need this one line of code
**[00:29:20]** that can just install your agent kit,
**[00:29:24]** and it would install these agents.
**[00:29:26]** You would have different skills
**[00:29:28]** that would have Cosmos DB best practices.
**[00:29:33]** Now let's go and see it in action.
**[00:29:37]** So I can just ask it that,
**[00:29:39]** "Can you provide me some recommendations
**[00:29:48]** on best practices for my data model?"
**[00:29:58]** So what's happening behind this prompt is the important part.
**[00:30:02]** So the agent kit isn't just a service.
**[00:30:05]** It isn't an account you provision.
**[00:30:08]** It's a repo of skills that any agent skills compatible coding
**[00:30:13]** agent can pull in, like GitHub Copilot, Claude Code,
**[00:30:17]** Gemini CLI, and others.
**[00:30:19]** And what these skills do is they give the agent Cosmos DB
**[00:30:25]** instincts of someone who has shipped,
**[00:30:29]** who has been shipping on it for years.
**[00:30:32]** So partitioning, indexing, RU economics,
**[00:30:35]** modeling for actual access patterns instead
**[00:30:39]** of how the data feels in your head.
**[00:30:42]** So here's the report ranked by impact, highest ROI first.
**[00:30:48]** So let's just go over the report.
**[00:30:52]** So it's giving you some critical recommendations.
**[00:30:55]** It's giving you some really highly important
**[00:31:00]** recommendations, and you can also interact with the agent
**[00:31:04]** if you want to push back on something
**[00:31:06]** and you can tell the agent
**[00:31:09]** that why did you did something in a certain way.
**[00:31:13]** So it can be an interactive collaborative effort with that,
**[00:31:17]** with this particular agent.
**[00:31:19]** So who is this for?
**[00:31:21]** So if you're new to Cosmos DB, the cognitive tax
**[00:31:25]** of am I modeling this right basically goes away.
**[00:31:29]** So you write code, the agent can reviews it,
**[00:31:32]** and you ship something that's well architected by default.
**[00:31:37]** So if you -- and if you're a seasoned Cosmos DB developer,
**[00:31:40]** point it at your existing services and let it hunt
**[00:31:43]** for the things that have quietly been costing you,
**[00:31:47]** so like old containers with stale index policies,
**[00:31:50]** queries that grew teeth over time, partition keys
**[00:31:54]** that stopped aging well.
**[00:31:56]** And the part that genuinely changes how teams operate is you
**[00:32:01]** can drop this into your CI and your PR reviews.
**[00:32:04]** Now every change gets a Cosmos DB expert opinion before it
**[00:32:09]** merges, so automatically every time at no extra cost.
**[00:32:14]** So that's the leverage of using the Cosmos DB agent kit.
**[00:32:18]** This Cosmos DB agent kit is generally available now.
**[00:32:23]** JUSTINE COCCHI: Awesome.
**[00:32:23]** Thanks, Aayush.
**[00:32:24]** Now we can feel confident that we have all the best practices
**[00:32:27]** in place for partitioning and cost management, but I also want
**[00:32:33]** to make sure we're production-ready
**[00:32:35]** and that we're using all the best practices
**[00:32:37]** for reliability and availability.
**[00:32:40]** And really, before we analyze how to do that, it's important
**[00:32:43]** to go back to the user requirements and what we need
**[00:32:46]** to guarantee to our users in terms of three key metrics.
**[00:32:50]** The first metric is SLO, which is the target level
**[00:32:54]** of service availability.
**[00:32:55]** Now, we have a global application and we want
**[00:32:59]** to make sure that our application is always available
**[00:33:01]** for our users that may be chatting from all over the world
**[00:33:05]** at any time of day, so we really can't have any downtime
**[00:33:08]** in our application.
**[00:33:10]** And we also want to look at two metrics for RPO,
**[00:33:13]** recovery point objective, and RTO, recovery time objective.
**[00:33:17]** Now, for distributed cloud applications, it's not a matter
**[00:33:21]** of if a disaster will strike, but when, and to ensure
**[00:33:24]** that we're prepared when something happens.
**[00:33:26]** So for recovery point objective,
**[00:33:28]** we need to define how long before the disaster strikes
**[00:33:32]** could we potentially lose data and ensure
**[00:33:35]** that our application has RPO targets
**[00:33:39]** that meet our user needs.
**[00:33:41]** Now, after the disaster, there's a potential time of downtime.
**[00:33:45]** So how long is it acceptable for us to be down?
**[00:33:49]** In our application, we really want five-nines of availability.
**[00:33:52]** We want our application to be always up and we want it
**[00:33:55]** to be available and all around the world.
**[00:33:58]** So we can use the active-active pattern in Azure Cosmos DB
**[00:34:01]** to ensure that we're getting those five-nines
**[00:34:03]** of availability.
**[00:34:04]** Now, in Cosmos DB, there's two different ways
**[00:34:06]** to achieve the active-active pattern.
**[00:34:09]** The first is with the multi-writer.
**[00:34:11]** In the multi-writer, you have multiple Azure Cosmos DB regions
**[00:34:14]** and they're all simultaneously accepting both read
**[00:34:17]** and write traffic.
**[00:34:18]** This is leaderless, meaning writes can come into any region
**[00:34:22]** and their conflict resolved across all regions.
**[00:34:25]** In this setup, the RTO is zero
**[00:34:27]** because all regions are already online
**[00:34:30]** and ready to accept traffic.
**[00:34:31]** The RPO is effectively zero.
**[00:34:34]** It's basically the conflict resolution
**[00:34:36]** and the replication time across regions.
**[00:34:39]** Now, in the single-writer setup, this is enabled
**[00:34:42]** by a new feature called "per partition automatic failover."
**[00:34:45]** This allows us to fail over at the individual partition level.
**[00:34:49]** Rather than waiting for an entire region
**[00:34:51]** to become unavailable and failover after that happens,
**[00:34:55]** we're able to react in a much more agile way by responding
**[00:34:59]** at the partition level.
**[00:35:01]** This is when you think about a brownout versus a blackout.
**[00:35:04]** It's much less common for an entire region to go
**[00:35:06]** down than an individual partition
**[00:35:08]** to maybe experience failures
**[00:35:10]** that require failing over to a new region.
**[00:35:13]** With per partition automatic failover,
**[00:35:15]** the unaffected healthy regions, or partitions, are still reading
**[00:35:20]** and writing from that primary write region,
**[00:35:22]** where any partition that is experiencing issues can fail
**[00:35:26]** over seamlessly.
**[00:35:27]** The application handles all of this, so we don't need
**[00:35:29]** to coordinate the failures in our app side, and we don't need
**[00:35:33]** to make an expensive call on when
**[00:35:35]** to failover the entire region.
**[00:35:36]** So this gives us the active-active pattern
**[00:35:39]** with five-nines of availability
**[00:35:41]** without actually having multiple writers.
**[00:35:44]** Per partition automatic failover is now generally available.
**[00:35:47]** This gives us zero downtime, zero data loss,
**[00:35:50]** and with zero touch because the SDK does the heavy lifting
**[00:35:53]** for us.
**[00:35:54]** So now we know that we have availability
**[00:35:58]** at the partition level, but we still do need
**[00:36:01]** to manage some complex operations
**[00:36:03]** in our application on the write path.
**[00:36:07]** Even though our rights are guaranteed to be available
**[00:36:09]** because Cosmos DB will be up,
**[00:36:11]** we need to make sure we still have consistency.
**[00:36:14]** Imagine the scenario our user has planned the trip
**[00:36:17]** with our travel app and they're ready to book.
**[00:36:20]** So when they say "Book it,"
**[00:36:21]** three things are really happening independently.
**[00:36:24]** First, in our trips container, we're updating the status
**[00:36:27]** of this trip to booked.
**[00:36:29]** We need to store memory.
**[00:36:30]** We need to remember, next time the user goes to chat
**[00:36:33]** with our app, they need to remember
**[00:36:34]** that they actually booked a trip to Paris.
**[00:36:37]** And lastly, in the events container, we need to emit
**[00:36:39]** that booking event so that our downstream systems
**[00:36:42]** and our logging also are coordinated with this write.
**[00:36:45]** Now, in our application, we can manage all
**[00:36:47]** of these independently, but they are writes
**[00:36:50]** to separate containers.
**[00:36:51]** So what if one of them fails?
**[00:36:53]** This is a really bad user experience.
**[00:36:55]** We don't want the agent to forget
**[00:36:57]** that a user actually booked a trip.
**[00:37:00]** We can use distributed transactions in Cosmos DB,
**[00:37:03]** which is now in public preview.
**[00:37:05]** This gives us atomic execution of multiple requests.
**[00:37:09]** Whereas, previously you could have a transaction
**[00:37:11]** within a single partition key,
**[00:37:14]** now you can get atomic transactions across partitions
**[00:37:17]** or even across containers, like we have in our use case.
**[00:37:20]** This means all three of those operations can either succeed
**[00:37:24]** or fail together.
**[00:37:25]** This gives us consistency at the container level
**[00:37:28]** and also simplifies our application,
**[00:37:30]** which improves reliability.
**[00:37:32]** We no longer need to manage all that error handling
**[00:37:35]** in our application and we can let the platform do the heavy
**[00:37:38]** lifting for us.
**[00:37:40]** If you remember our integrated embeddings
**[00:37:42]** in our embeddings generation, this is another opportunity
**[00:37:45]** to let the platform do the heavy lifting.
**[00:37:48]** The current flow that we have today is our natural language
**[00:37:51]** chat, so our user is giving a prompt.
**[00:37:54]** Before our application can do anything with Cosmos DB,
**[00:37:57]** we need to call OpenAI and we need
**[00:37:59]** to generate those embeddings.
**[00:38:00]** This leaves room for potentially rate limiting or error handling.
**[00:38:05]** It's more coordination that needs to happen
**[00:38:07]** in our application where we could see write loss
**[00:38:11]** availability without Cosmos DB actually being down.
**[00:38:15]** Maybe it's an issue with our error handling,
**[00:38:17]** and this makes it really brittle for the application
**[00:38:19]** and it puts the heavy onus on the developer to make sure
**[00:38:23]** that all of this is going smoothly.
**[00:38:25]** With integrated embeddings, this flow simplifies.
**[00:38:29]** So we no longer need to have that external synchronous call
**[00:38:33]** to OpenAI before we can keep going in our conversation.
**[00:38:37]** We can use integrated embeddings to write the raw message
**[00:38:40]** into Cosmos DB and it's automatically integrated
**[00:38:43]** with Microsoft Foundry.
**[00:38:45]** The embeddings are generated asynchronously
**[00:38:47]** and this allows us to focus on our business logic instead
**[00:38:51]** of focusing on coordinating all of these external calls.
**[00:38:55]** Integrated embeddings automatically generate the
**[00:38:58]** embeddings at write time.
**[00:39:00]** You define your Microsoft Foundry integration
**[00:39:02]** and you no longer need to rely on external pipelines
**[00:39:05]** to do all the plumbing for you.
**[00:39:07]** You can define the source and the target properties
**[00:39:10]** to create these embeddings on,
**[00:39:12]** which really gives you the full control
**[00:39:14]** for how the embeddings are generated in your application
**[00:39:17]** without needing to worry about coordinating
**[00:39:19]** that in the app itself.
**[00:39:20]** AAYUSH KATARIA: Integrated embeddings seems to be
**[00:39:23]** such a great feature, Justine.
**[00:39:25]** Like while building my multi-agent application,
**[00:39:27]** while I was testing it, chatting with the assistant,
**[00:39:30]** I was getting rate limited so many times and I had
**[00:39:33]** to wait for, like, sometimes like even for 30,
**[00:39:36]** 40 seconds to get actually the message back from the LLM.
**[00:39:41]** That sounds really nice.
**[00:39:43]** I was just going through my trips container
**[00:39:46]** and I actually thought of another scenario,
**[00:39:50]** that I have a lot of trips that are in my trips container.
**[00:39:54]** But what if I want to make a dashboard just to filter it
**[00:39:59]** with like what is the hottest destination
**[00:40:02]** that my users are traveling to, and that way I can add probably,
**[00:40:08]** say, more hotels or more restaurants, particularly
**[00:40:11]** for that particular destination so the users would have, like,
**[00:40:15]** more options for, like, where can they eat,
**[00:40:18]** what hotels they can stay at.
**[00:40:20]** Is there a way today that we can do that in Cosmos DB?
**[00:40:24]** JUSTINE COCCHI: Yeah, so let's take a look at the design
**[00:40:26]** of our trips container and see why this query,
**[00:40:30]** this new dashboard, higher-level query is so difficult
**[00:40:33]** to challenge to fulfill with our current architecture.
**[00:40:37]** So as our travel application is picking up steam
**[00:40:41]** and more users are using it, we have this need
**[00:40:44]** for cross-tenant queries.
**[00:40:46]** How many trips to Paris are next month?
**[00:40:48]** What is the top city?
**[00:40:49]** What is the top destination?
**[00:40:51]** These types of things are not really well served
**[00:40:53]** by our current architecture.
**[00:40:55]** Our current trips container is using a hierarchical partition
**[00:40:58]** key with tenant and then user and trip ID.
**[00:41:02]** This makes our agent queries really fast,
**[00:41:04]** and an individual user can really quickly learn
**[00:41:06]** about all of their trips.
**[00:41:08]** But as the platform developer of our travel agent site,
**[00:41:12]** we want that higher-level dashboard.
**[00:41:14]** We want to know how many, broadly across all tenants,
**[00:41:18]** how many trips to Paris are there next month?
**[00:41:20]** The issue with this query in our current architecture is
**[00:41:24]** that it's a cross-partition query.
**[00:41:26]** So Cosmos DB is a distributed database, and your data lives
**[00:41:29]** on multiple physical partitions.
**[00:41:31]** A query like this, where we're getting an account
**[00:41:33]** of all the trips to Paris, needs to be routed
**[00:41:36]** to every single physical partition so that we can count
**[00:41:39]** up all the trips and then give the answer back.
**[00:41:41]** For our new requirement of this dashboard, broad across tenants,
**[00:41:46]** we need new architecture.
**[00:41:48]** We can create a copy of our data using global secondary indexes.
**[00:41:53]** This allows us to create a secondary container
**[00:41:56]** or global secondary index that's partitioned on destination.
**[00:42:00]** This makes a query, like finding all the trips
**[00:42:03]** to Paris, extremely fast.
**[00:42:05]** We only need to check one partition instead of all of them
**[00:42:08]** in our previous container.
**[00:42:11]** Global secondary indexes are now generally available.
**[00:42:14]** They will automatically sync data from a source container
**[00:42:17]** and create a copy container with all
**[00:42:21]** of that synced data that's better suited
**[00:42:23]** for your query patterns.
**[00:42:24]** They really help you increase query efficiency
**[00:42:27]** and transform what would be very heavy cross-partition queries
**[00:42:30]** into single-partition look-ups.
**[00:42:32]** They help you isolate heavy workload operations
**[00:42:36]** into the secondary container to ensure that you can run them
**[00:42:40]** without impacting your transactional workload.
**[00:42:42]** So let's take a look at what this looks
**[00:42:44]** like in the Azure portal.
**[00:42:46]** I'm going to pull up my Azure Cosmos DB account
**[00:42:50]** and I've got my trips container here.
**[00:42:52]** As you can see, I'm using a hierarchical partition key
**[00:42:55]** with tenant ID, user ID, and the trip.
**[00:42:58]** Now, this is a fairly heavy document.
**[00:43:00]** We've got this days array, which is storing all the information
**[00:43:04]** about the activities that the user is doing every day.
**[00:43:08]** Now, for my global secondary index,
**[00:43:10]** I don't actually need this low-level information
**[00:43:12]** about every trip, so when I define my global secondary
**[00:43:15]** index, which I've already created my trips by destination,
**[00:43:19]** I can actually change the data model a little bit.
**[00:43:22]** I can project what properties are most important
**[00:43:25]** for me in this GSI.
**[00:43:27]** You see I have all of my trips here,
**[00:43:29]** but I've filtered out that days array.
**[00:43:30]** I don't need to have that written into my secondary data.
**[00:43:34]** I really can make sure the schema matches how I'm going
**[00:43:37]** to query it.
**[00:43:38]** Now, let's take a look at a query
**[00:43:40]** and we'll run the same query getting all the trips
**[00:43:43]** to Paris, France.
**[00:43:44]** First, I'm going to execute this on my trips container.
**[00:43:47]** So this is the primary container that we've already been using,
**[00:43:50]** and you can see I have 500 trips to France.
**[00:43:53]** If I look at the query stats, this costs me about 30 RUs.
**[00:43:57]** Now, imagine this query at scale
**[00:43:59]** when I'm constantly refreshing my dashboard
**[00:44:01]** and all my devs are looking at it.
**[00:44:03]** I wonder if there's a way that we can optimize this.
**[00:44:06]** So let's go into our GSI and let's go ahead
**[00:44:09]** and execute this same query.
**[00:44:12]** As I execute the same query against my GSI,
**[00:44:16]** I get the same answer, which is great, but if I look
**[00:44:19]** at the query stats, we see this time it only cost me 3 RUs.
**[00:44:23]** That's about a 90% savings.
**[00:44:25]** Now, the specific degree of savings will depend
**[00:44:28]** on your query and the physical partition layout of your source,
**[00:44:32]** but you can see how GSIs are a very powerful way
**[00:44:34]** to optimize your queries,
**[00:44:36]** especially when you have new evolving requirements.
**[00:44:39]** In this example, we didn't need a dashboard on day one,
**[00:44:43]** but global secondary indexes allowed us to add a GSI later
**[00:44:47]** on in the life cycle of our application and ensure
**[00:44:51]** that our queries are still efficient even
**[00:44:53]** as our requirements evolve.
**[00:44:55]** So we covered a lot today, and I really want
**[00:44:58]** to bring it all together
**[00:44:59]** with some key takeaways to keep in mind.
**[00:45:03]** First, make sure that your agentic applications have
**[00:45:07]** durable memory and that they're scalable by design.
**[00:45:10]** Remember the different memory types that enable your agents
**[00:45:13]** to give better responses.
**[00:45:15]** You can ship even faster with an AI-native dev experience
**[00:45:18]** and the Azure Cosmos DB toolkit to analyze your application
**[00:45:23]** and ensure that you're using those best practices.
**[00:45:26]** Think about reliability and availability.
**[00:45:28]** Are there certain platform features you can take advantage
**[00:45:31]** of to avoid brittle error handling
**[00:45:33]** in your application code?
**[00:45:35]** Really thinking about mission-critical applications
**[00:45:38]** and how you can build ready-to-ship AI applications.
**[00:45:43]** I want to leave you with several resources today.
**[00:45:46]** This first link, that Cosmos DB Travel Multi-Agent,
**[00:45:50]** will be all of the demo code that we shared,
**[00:45:52]** including a workshop if you want to walk
**[00:45:54]** through building this application yourself.
**[00:45:57]** We've also got several links for some
**[00:45:59]** of the various announcements that we released today.
**[00:46:01]** Thank you so much and I hope you enjoy the rest of Build.
