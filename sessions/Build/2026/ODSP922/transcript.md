**[00:00:00]** [ Music ]
**[00:00:06]** GREG CRIST: Hey, everyone.
**[00:00:07]** I'm Greg Crist, Cloud Ecosystem Architect here at Elastic.
**[00:00:10]** I'm really excited to introduce this demo
**[00:00:12]** from my colleague Jonathan Simon today.
**[00:00:14]** Before we jump in, I want to set some context because what you're
**[00:00:17]** about to see sits at the intersection of two things
**[00:00:20]** that are moving incredibly fast right now:
**[00:00:22]** the Microsoft AI ecosystem and Elastic's ability
**[00:00:25]** to bring your own data into the AI conversation.
**[00:00:28]** If you've been following what Microsoft's been building
**[00:00:30]** with Azure OpenAI and Foundry IQ,
**[00:00:34]** you know that developers now have a generally powerful,
**[00:00:36]** integrated environment for discovering, evaluating,
**[00:00:39]** deploying large language models.
**[00:00:41]** That's a big deal.
**[00:00:42]** But a model without the right context,
**[00:00:43]** without the right data is just a very expensive autocomplete.
**[00:00:47]** And that's where Elastic comes in.
**[00:00:49]** Elastic is natively available on the Azure Marketplace, deployed,
**[00:00:52]** managed and built through your Microsoft Marketplace.
**[00:00:55]** It means you can go from zero
**[00:00:56]** to production grade AI search deployment
**[00:00:58]** without leaving the Azure ecosystem,
**[00:01:00]** without a separate procurement motion,
**[00:01:02]** and without managing additional vendor relationships.
**[00:01:05]** It's Elastic on Azure, the way Azure customers expect things
**[00:01:08]** to work.
**[00:01:09]** When you pair Elastic with the models you've already exploring
**[00:01:11]** in Microsoft Foundry model catalog,
**[00:01:14]** whether it's Azure OpenAI or other models
**[00:01:16]** from the broader catalog, you get something very compelling:
**[00:01:19]** grounded, relevant, trustworthy AI answers that are powered
**[00:01:22]** by your data and not just the model's training data,
**[00:01:25]** which brings me to what Jonathan is going to show you today.
**[00:01:28]** In his demo, you'll see how Elastics Agent Builder lets you
**[00:01:31]** take a traditional e-commerce search experience
**[00:01:33]** and transform it into a conversational AI agent.
**[00:01:36]** One that understands your product catalog,
**[00:01:38]** speaks your customers' language and delivers results
**[00:01:41]** that actually drive conversation.
**[00:01:43]** No full application rebuild required.
**[00:01:45]** He'll walk through how to connect an LLM,
**[00:01:48]** wire in your own data and deploy an agent that's ready
**[00:01:50]** for your e-commerce site.
**[00:01:52]** It's a practical look at what's possible
**[00:01:54]** when you combine the best of Microsoft's AI platform
**[00:01:56]** with Elastics context engineering
**[00:01:58]** and search retrieval capabilities.
**[00:02:01]** All right, over to you Jonathan.
**[00:02:02]** JONATHAN SIMON: Thank you for that introduction.
**[00:02:04]** Hello everyone, I'm Jonathan Simon.
**[00:02:06]** I'm a Senior Product Marketing Engineer at Elastic
**[00:02:09]** and today I'm going to show you how you can use Elastic Agent
**[00:02:12]** Builder and workflows to create an AI search experience.
**[00:02:18]** The agenda for this webinar is that I'll start
**[00:02:21]** with a quick overview of the Elastic solutions
**[00:02:23]** that are available, and then I'll introduce Agent Builder,
**[00:02:27]** and then we'll jump right into a demo
**[00:02:29]** where I'll show you a e-commerce website
**[00:02:32]** for a fictitious company called Wayfinder Supply Company,
**[00:02:36]** and then we'll look at Elastic Agent Builder.
**[00:02:38]** I'll give you an overview of that.
**[00:02:40]** We will use Agent Builder to create a workflow.
**[00:02:42]** We'll create an MCP tool.
**[00:02:44]** Then we'll create an agent, and then we'll integrate that agent
**[00:02:47]** that we created back into the Wayfinder web app.
**[00:02:51]** And then we'll conclude with a walkthrough of the architecture
**[00:02:55]** that the Wayfinder web app is created with.
**[00:03:00]** Okay. Elastic has three solutions: search,
**[00:03:05]** observability and security.
**[00:03:08]** Elasticsearch allows you to bring any data
**[00:03:11]** into the Elasticsearch platform
**[00:03:13]** and it gives you blazing fast lexical, exact match search,
**[00:03:18]** semantic search based on vectors,
**[00:03:21]** and now agentic search powered by AI agents created
**[00:03:26]** with Elastic Agent Builder.
**[00:03:29]** Elastic Observability is if you need observability
**[00:03:34]** into the applications that you're running.
**[00:03:36]** So, if you need application performance monitoring, metrics
**[00:03:40]** and more, all you have to do is bring your logs into Elastic
**[00:03:44]** and we'll use AI to parse and partition those logs
**[00:03:47]** into a structured format that will allow you
**[00:03:49]** to see instantly exactly what's going on in your applications.
**[00:03:56]** Elastic Security.
**[00:03:58]** If you've been tasked with protecting systems
**[00:04:02]** or monitoring endpoints, or even running a security operations
**[00:04:07]** center, Elastic Security has features like attack discovery,
**[00:04:12]** automatic remediation with workflows that will enable you
**[00:04:16]** to stay ahead of the modern cybersecurity threats
**[00:04:20]** that are ever present.
**[00:04:25]** Now, to get started with Elastic,
**[00:04:28]** Azure is a great place to do that.
**[00:04:30]** All you have to do is log into Azure,
**[00:04:32]** go to the Microsoft Marketplace and search
**[00:04:34]** for Elastic Serverless
**[00:04:37]** and you'll see the three solutions pop up.
**[00:04:40]** Then all you have to do is click "Get it Now"
**[00:04:42]** and that will create a full featured Elastic project
**[00:04:46]** that you can get started with.
**[00:04:51]** And now I'm proud to announce Elastic Agent Builder.
**[00:04:55]** It's been available in technical preview for a while now,
**[00:04:59]** but it is officially generally available so you can use it
**[00:05:03]** for your production workloads.
**[00:05:05]** Now, the best way to explain how Elastic Agent Builder works is
**[00:05:09]** to show you.
**[00:05:11]** So, let me do that right now with a demo.
**[00:05:14]** All right, so this is an e-commerce website
**[00:05:16]** that sells camping gear for a company called Wayfinder.
**[00:05:21]** Now, all of the products, descriptions,
**[00:05:23]** the titles that you'll see we created with generative AI.
**[00:05:28]** And the search for this website is powered by Elastic.
**[00:05:32]** So, let's check it out.
**[00:05:33]** We can browse gear and you can see, you can click an item,
**[00:05:39]** see its images, see its details, its title, you can add it
**[00:05:44]** to cart, all the things that you'd expect
**[00:05:46]** with an e-commerce website and there's also search.
**[00:05:49]** So, let's check that out.
**[00:05:51]** You can see we've got chat-based search, we've got hybrid search,
**[00:05:53]** we've got lexical search.
**[00:05:56]** So, let's go ahead and try a query.
**[00:05:58]** What if I typed "jackets?"
**[00:06:01]** And there we go.
**[00:06:02]** We get a nice list of jackets to choose from.
**[00:06:05]** But what if I were to type "coats?"
**[00:06:09]** No results.
**[00:06:11]** And that's because none of the products have the word "coat"
**[00:06:14]** or "coats" in their title or their descriptions.
**[00:06:18]** What if I try hybrid search?
**[00:06:22]** There we go, we get jackets again.
**[00:06:24]** And that's because we have run the titles and descriptions
**[00:06:27]** through the Elastic Inference Service to create vectors
**[00:06:31]** and store those in a vector database.
**[00:06:33]** And so, that hybrid search knows that coats are similar
**[00:06:37]** to jackets and we get similar results
**[00:06:39]** that we saw before for lexical search.
**[00:06:43]** Now, suppose we wanted to get more sophisticated.
**[00:06:45]** We wanted to actually create a trip planner that was powered
**[00:06:49]** by AI that you could ask a question like this,
**[00:06:55]** "Plan a three-day backpacking trip to Yosemite next weekend."
**[00:07:00]** Let's run that.
**[00:07:03]** And oh, "Trip Planner Agent is not built yet."
**[00:07:07]** Well, that's okay, we can fix that.
**[00:07:10]** Let's go build an agent to power the trip planner.
**[00:07:13]** We can do that in Elastic Agent Builder.
**[00:07:17]** Okay, so here is Elastic
**[00:07:20]** and this is the Elastic Agent Builder interface.
**[00:07:24]** The first thing that you should notice is
**[00:07:27]** that we already have an agent that's enabled
**[00:07:29]** and we have an LLM that the agent can use.
**[00:07:32]** Now, this is configured right out of the box.
**[00:07:33]** You don't have to do anything.
**[00:07:35]** As soon as you install Elastic, this is available.
**[00:07:38]** The other cool thing here to note is
**[00:07:39]** that if I click this LLM, currently, it's Anthropic,
**[00:07:43]** but you can see there's a whole bunch of other LLMs
**[00:07:46]** that are preconfigured by default.
**[00:07:49]** Now, suppose there was an LLM you wanted to use
**[00:07:51]** that wasn't included in this list.
**[00:07:53]** Well, Agent Builder has a solution for that, too.
**[00:07:56]** We can click "Manage" and you can see all the pre-configured
**[00:08:01]** LLMs here.
**[00:08:03]** And then I can click "Create Connector."
**[00:08:05]** We can search for Azure and select Azure.
**[00:08:11]** And now, we need a place that we can find LLMs,
**[00:08:15]** deploy LLMs and run LLMs.
**[00:08:18]** Well, it turns out that there's a great place
**[00:08:20]** to do that right in Azure.
**[00:08:22]** So, I'm going to jump over to that right now.
**[00:08:23]** This is the Microsoft Foundry running in Azure.
**[00:08:26]** You can see we don't have any models deployed,
**[00:08:29]** so let's go deploy one.
**[00:08:30]** I'll click "Deploy Base Model" and you can see there's a ton
**[00:08:35]** of different models to choose from.
**[00:08:37]** Let's try "Mistral."
**[00:08:42]** I'll select the "Mistral Large"
**[00:08:45]** and let's go ahead and deploy that.
**[00:08:47]** We can use the default settings.
**[00:08:54]** There we go.
**[00:08:54]** That was pretty fast.
**[00:08:56]** We'll jump over to "Details," select the target URI,
**[00:09:02]** we'll go back to the connector settings here and I'll plug
**[00:09:06]** in that URI I just copied,
**[00:09:09]** go back to the foundry and grab the key.
**[00:09:17]** And enter the API key for authentication.
**[00:09:22]** And then we'll give this connector a name.
**[00:09:23]** We'll say "Mistral Large 3"
**[00:09:28]** and then we'll click "Save and Test."
**[00:09:32]** That saved the settings.
**[00:09:33]** And then, now we have a nice interface to actually test it
**[00:09:35]** out with a Hello World prompt.
**[00:09:37]** So, we'll run that and there we go.
**[00:09:39]** The test was successful.
**[00:09:41]** So, now when we go back to Agent Builder
**[00:09:44]** and we click the LLM selector,
**[00:09:47]** we now see we've got Mistral Large 3.
**[00:09:51]** So, right out of the box, Agent Builder is a great place for you
**[00:09:55]** to try out agents with LLMs and your own data.
**[00:09:59]** Okay, so now let's get on with building an agent
**[00:10:02]** for the trip planner for that Wayfinder Supply Company web app
**[00:10:06]** that you saw earlier.
**[00:10:09]** The first thing we're going to need is a workflow.
**[00:10:11]** So, I'll click "Workflows."
**[00:10:13]** You can see, there's a few there already,
**[00:10:15]** but we'll create a new one.
**[00:10:17]** And now, I'm going to jump over to Visual Studio Code
**[00:10:21]** to copy a workflow that I've got saved here.
**[00:10:24]** And copy that.
**[00:10:28]** Go back to the workflow and paste that in.
**[00:10:32]** And let's quickly walk through the elements here
**[00:10:35]** in this workflow.
**[00:10:35]** So, you can see there's a version.
**[00:10:37]** It's got a name.
**[00:10:38]** Get customer profile.
**[00:10:41]** There's an input.
**[00:10:42]** It takes a user ID input.
**[00:10:43]** That's a string, and this workflow is triggered manually.
**[00:10:47]** There's a couple other ways that workflows can be triggered.
**[00:10:51]** And workflows have one or more steps.
**[00:10:53]** This one has a single step.
**[00:10:54]** It's called Call CRM MCP.
**[00:10:57]** And this is basically doing an HTP post call
**[00:11:00]** to an external MCP server to get the customer profile.
**[00:11:08]** Another cool thing about workflows is
**[00:11:10]** that each step can have an on-failure handler.
**[00:11:12]** And in this case, if there's a failure,
**[00:11:14]** you can see that we'll retry twice.
**[00:11:17]** And that you can add delays, too.
**[00:11:18]** Here's a one-second delay between the retry attempts.
**[00:11:22]** And then finally, workflows have the ability to log their output.
**[00:11:27]** And so, in this case, we're doing a log to profile
**[00:11:31]** and log profile to the console.
**[00:11:34]** And so, that should take the results that we get
**[00:11:36]** from running this workflow and create a log for it.
**[00:11:40]** So, let's go ahead and save that and we'll run it.
**[00:11:49]** And so, you can see we get this input for the User ID,
**[00:11:55]** and we have the option to enter a value for that.
**[00:11:57]** So, for this, I'll type "User Member."
**[00:12:01]** I'll run it.
**[00:12:08]** There we go.
**[00:12:08]** Successful.
**[00:12:10]** You can see the details of the response that came back.
**[00:12:13]** And here's that log profile output
**[00:12:16]** that I talked about earlier.
**[00:12:17]** If I click that, we can see.
**[00:12:19]** In a nice readable format,
**[00:12:21]** we got a customer called Alex Hiker.
**[00:12:23]** You can see his loyalty tier, lifetime purchases
**[00:12:26]** and his lifetime value and his purchase history.
**[00:12:30]** Cool. So, our workflow is working.
**[00:12:33]** Great. All right, so now let's go and create a tool
**[00:12:37]** that uses that workflow.
**[00:12:38]** I'll go back to Agent Builder, click the "More" menu,
**[00:12:43]** click "View All Tools," click "New Tool."
**[00:12:47]** And here we can see there are different tool types.
**[00:12:51]** There's an ESQL tool type, which is Elasticsearch query language,
**[00:12:54]** which is similar to SQL, but even more powerful.
**[00:12:58]** There is an index search tool type.
**[00:13:00]** So, if you want to just do a straight search
**[00:13:02]** against an Elastic index.
**[00:13:04]** There's a Word workflow tool type,
**[00:13:06]** which is what we'll be using.
**[00:13:07]** And there's an MCP tool type which is currently
**[00:13:10]** in Tech Preview, but that allows you to chain tools together
**[00:13:13]** to create a complex workflow.
**[00:13:17]** So, I'm going to go back to "Workflow"
**[00:13:19]** and then we'll select the workflow that we just created,
**[00:13:21]** the "Get Customer Profile" workflow,
**[00:13:24]** and then we'll give this a Tool ID.
**[00:13:26]** I'll jump back over to Visual Studio code, copy this Tool ID.
**[00:13:33]** We'll call it Tool Workflow, Get Customer Profile, go back
**[00:13:37]** and copy the description, and that's all we need.
**[00:13:43]** I'll go ahead and click, "Save and Test."
**[00:13:54]** So, that saved the details.
**[00:13:55]** And then it opens this testing flyout.
**[00:13:58]** Because it's using that workflow that took a input of User ID,
**[00:14:02]** this tool that uses that workflow also needs the input.
**[00:14:07]** And so, I'm going to type same thing I did before.
**[00:14:09]** "User Menu, User Member," click "Submit."
**[00:14:17]** And there we go, successful response.
**[00:14:19]** And if we look at the output, it should be similar
**[00:14:21]** to what we saw before.
**[00:14:22]** And there he is, Alex Hiker, same customer, the loyalty tier,
**[00:14:27]** lifetime value and the purchase history.
**[00:14:30]** Sweet. Okay, so now we've got a tool that's using the workflow.
**[00:14:35]** So, let's go ahead and create an agent
**[00:14:37]** that will use that same tool.
**[00:14:39]** One final thing I'll note about any tool that you create
**[00:14:42]** in Agent Builder, it's officially an MCP tool.
**[00:14:45]** So, with an API key, you can access that tool
**[00:14:48]** from any other application that you're building.
**[00:14:52]** Great. Okay, so we'll go to "Agents," I'll click "More,"
**[00:14:57]** "View all Agents," and we're going to create a new agent.
**[00:15:02]** I've got Visual Studio ready
**[00:15:03]** with some values here that I can copy.
**[00:15:07]** So, I'm going to copy this Agent ID.
**[00:15:09]** We'll call this the "Trip Planner Agent."
**[00:15:13]** We're going to copy these custom instructions.
**[00:15:15]** Now, this isn't marked down.
**[00:15:17]** That specifies exactly how you want the agent to behave.
**[00:15:20]** In our case, we're telling it to search the product catalog
**[00:15:23]** to generate a trip plan and all --
**[00:15:26]** and the areas that it should be searching in for trip plans
**[00:15:31]** and additional details.
**[00:15:38]** Other items that we need are a display name.
**[00:15:40]** So, I'll copy that.
**[00:15:41]** We'll call this the Trip Planner Agent.
**[00:15:46]** Need a description.
**[00:15:52]** And that's all the details we need for our agent.
**[00:15:54]** The final thing that we need to do though is
**[00:15:56]** to assign it some tools.
**[00:15:58]** And so, I will go ahead and click the Tools tab here
**[00:16:01]** and then we'll sort by ID, and there is the tool
**[00:16:05]** that we just created, the tool workflow,
**[00:16:07]** "Get Customer Profile" tool.
**[00:16:09]** So, I'll enable that and I will also enable these three tools.
**[00:16:15]** Great. Now, I'll click Save and Chat."
**[00:16:19]** And so, here we are, back in the Agent Builder interface.
**[00:16:22]** And notice that now the agent that's selected is the Trip
**[00:16:24]** Planner agent that we just created,
**[00:16:26]** so that we can quickly test it out.
**[00:16:28]** If you wanted to go back to a different agent,
**[00:16:30]** you can simply click that
**[00:16:31]** and then you got your options for different agents.
**[00:16:35]** So, let's go ahead and test this.
**[00:16:37]** I've got a prompt that we can test it with right here.
**[00:16:43]** We can say, "Plan a three-day backpacking trip
**[00:16:46]** to Yosemite this weekend," and we'll run that.
**[00:16:51]** And one of the cool things about Agent Builder is
**[00:16:52]** that it gives you a summary of what it's thinking and reasoning
**[00:16:56]** about as it responds to your prompt.
**[00:16:59]** You can also expand this section to see the exact steps
**[00:17:03]** that it's taking as it does its reasoning.
**[00:17:06]** So, you can see that it is planning a trip.
**[00:17:08]** It knows that this weekend is March 13th through the 15th.
**[00:17:12]** It's getting the weather conditions
**[00:17:14]** for that and the road alerts.
**[00:17:17]** It ran an ESQP query to get information
**[00:17:21]** about the user's past click stream.
**[00:17:24]** Now, it's searching for waterproof tents here.
**[00:17:29]** Looking for rain Jackets.
**[00:17:35]** Getting more details about the tent.
**[00:17:37]** Looking for sleeping bags that are suitable
**[00:17:39]** for the temperatures that are expected this weekend.
**[00:18:00]** Getting more details about the sleeping bag.
**[00:18:06]** And there we go.
**[00:18:06]** Voila. We've got a backpacking trip itinerary
**[00:18:11]** to Yosemite for this weekend.
**[00:18:14]** You can see, it's got a trip overview,
**[00:18:16]** it's got weather conditions, it's got product recommendations
**[00:18:20]** that are suitable for the conditions of the trip timing,
**[00:18:25]** and it's got a suggested three-day itinerary.
**[00:18:28]** Sweet. So, we have an agent that we can now go and integrate back
**[00:18:33]** with the Wayfinder web app so that we can get
**[00:18:35]** that Trip Planner button working as it should be.
**[00:18:39]** There's one final thing though that I wanted to show you
**[00:18:42]** and that's the fact that any agent that you build
**[00:18:46]** with Elastic Agent Builder,
**[00:18:48]** its operations are also accessible via API.
**[00:18:51]** So, it's cool that we can come in here into Agent Builder
**[00:18:55]** and chat with it using this interface.
**[00:18:57]** But even cooler is all of these functions are accessible
**[00:19:01]** via API.
**[00:19:02]** So, if you want to integrate
**[00:19:03]** that into your existing apps, it's easy to do.
**[00:19:06]** And so, for example, I can propose a query like this.
**[00:19:13]** I could go look at the documentation for the APIs
**[00:19:16]** for agents and I encourage you to do that.
**[00:19:19]** But I wanted to show you how you can also just ask a question
**[00:19:22]** like this.
**[00:19:22]** "Hey, generate an example Python API call
**[00:19:25]** to the Trip Planner agent with the prompt that we ran before."
**[00:19:31]** And so, I'm showing you this because I want you to understand
**[00:19:34]** that you can work with the agent
**[00:19:35]** to help you generate example code
**[00:19:37]** that will then help you get started
**[00:19:39]** with integrating the agent into your existing apps.
**[00:19:43]** And here we go.
**[00:19:44]** Let me zoom in on this a bit.
**[00:19:46]** Very simple Python.
**[00:19:48]** It imports a request library.
**[00:19:50]** It's got the URL to get to the agent.
**[00:19:52]** It shows you that you're going to need an API key.
**[00:19:55]** Here's the prompt that we ran.
**[00:19:57]** It does the query and prints out the response.
**[00:20:00]** Sweet. All right, so now we have everything that we need
**[00:20:04]** to integrate this agent back into the Wayfinder web app.
**[00:20:08]** So, let's go take a look at that.
**[00:20:10]** I'm going to refresh.
**[00:20:14]** Sweet. Okay, so let's give it a try.
**[00:20:17]** Now, the way this app is written is such that
**[00:20:20]** if the Trip Planner agent is available,
**[00:20:24]** it will work as expected.
**[00:20:25]** If it's not, you'll see the error message
**[00:20:27]** that we saw before, that it's not yet implemented.
**[00:20:30]** But because we just created the Trip Finder agent,
**[00:20:33]** this should work.
**[00:20:33]** Let's try it out.
**[00:20:35]** We click "Trip Planner."
**[00:20:37]** We'll click the suggested prompt here.
**[00:20:40]** We'll say "This weekend" and run it.
**[00:20:46]** All right, looks like it's working.
**[00:20:47]** Now, similar to the Elastic Builder --
**[00:20:50]** Elastic Agent Builder UI, this also shows the reasoning.
**[00:20:54]** So, we can expand this section, and we can see
**[00:20:57]** that it's planning a trip for Yosemite for this weekend.
**[00:21:02]** It's getting the customer profile.
**[00:21:07]** Looking for waterproof rain gear based on the temperature
**[00:21:11]** that are expected this weekend.
**[00:21:14]** Looking for sleeping bags that are suitable
**[00:21:16]** for the temperatures expected this weekend.
**[00:21:23]** Searching for backpacks, searching for tents.
**[00:21:35]** All right, there we go.
**[00:21:43]** That looks great.
**[00:21:46]** Sweet. So, similar to what we saw before inside
**[00:21:50]** of Agent Builder, now you can see it integrated right
**[00:21:53]** into this web app.
**[00:21:55]** So, we've got our three-day Yosemite backpacking trip plan
**[00:21:58]** for this weekend.
**[00:21:59]** You see the weather conditions.
**[00:22:01]** We got recommended gear.
**[00:22:03]** And look over here in this pane, you can see all the gear
**[00:22:05]** that it's recommended with easy buttons to add it
**[00:22:08]** to your shopping cart if you want to add that.
**[00:22:11]** And then we also have a way to view the itinerary
**[00:22:14]** which you can print out and bring with you on the trip.
**[00:22:17]** So, that's pretty cool.
**[00:22:18]** We went from an e-commerce site that had chat,
**[00:22:22]** hybrid and lexical search to using Agent Builder
**[00:22:26]** to build an agent that powered a concierge type trip planner
**[00:22:31]** with product recommendations using Agent Builder and tied
**[00:22:36]** to an LLM that's running on Microsoft Foundry.
**[00:22:40]** Super powerful.
**[00:22:42]** And let's do a quick tour of the architecture
**[00:22:44]** that powers the Wayfinder web app.
**[00:22:46]** So, starting at the top here you can see the front end is written
**[00:22:50]** in React.
**[00:22:51]** So, a user submits a query like "Plan my trip to Yosemite."
**[00:22:55]** That sends an HTP request to the backend which is written
**[00:22:58]** in Python running Fast API Server.
**[00:23:01]** That Python backend does an API query
**[00:23:04]** to the Elastic stack running the Trip Planner agent
**[00:23:08]** that we just created.
**[00:23:09]** And you can see that the Agent Builder agent has access
**[00:23:14]** to the four tools that we gave it.
**[00:23:15]** And starting over on this side,
**[00:23:17]** you can see the Agent Builder has a tool called
**[00:23:20]** "Product Search" that does semantic search
**[00:23:22]** against the product catalog.
**[00:23:24]** It also has a tool called "Get User Affinity"
**[00:23:26]** which does an ESQL query to the user's clickstream.
**[00:23:32]** Additionally, it has a tool called "Check Trip Safety"
**[00:23:35]** and that goes through a workflow that does an HTP post
**[00:23:38]** to an MCP server to get weather information.
**[00:23:41]** And finally, the tool that we created, "Get Customer Profile,"
**[00:23:45]** goes through a workflow called "Get Customer Profile"
**[00:23:48]** that does an HTP post to an external MCP server
**[00:23:52]** that queries a CRM service.
**[00:23:55]** And all of that creates the trip planner that you just saw.
**[00:24:00]** Hopefully, I've enticed you to check out Elastic
**[00:24:03]** and Elastic Agent Builder and here are some resources
**[00:24:06]** to help you get started.
**[00:24:07]** The first one is the Agent Builder documentation,
**[00:24:12]** and the next link here is a link to the GitHub repo
**[00:24:16]** where you can find all the code you need
**[00:24:18]** to run the Wayfinder Supply web app on your own machine.
**[00:24:24]** It's also got a great readme
**[00:24:26]** to explain exactly how everything works
**[00:24:29]** and to help you get started.
**[00:24:31]** Additionally, it's got a link to a workshop
**[00:24:33]** that you can run completely for free without installing anything
**[00:24:36]** to try it out yourself.
**[00:24:39]** And finally, here's a QR code that you can scan
**[00:24:42]** so that you can get Elastic running
**[00:24:45]** on Azure free for seven days.
**[00:24:48]** So, go ahead.
**[00:24:50]** Give it a try.
**[00:24:51]** GREG CRIST: Thanks, Jonathan.
**[00:24:52]** That was a great practical walkthrough of how
**[00:24:54]** to build an agent using Elastic as well
**[00:24:56]** as the Microsoft Foundry environment.
**[00:24:59]** If you'd like to learn more, please come visit Elastic
**[00:25:02]** at the Microsoft Build Conference 2026
**[00:25:04]** and use this QR code to learn more.
**[00:25:07]** Thanks very much for your time today.
**[00:25:09]** [ Music ]
