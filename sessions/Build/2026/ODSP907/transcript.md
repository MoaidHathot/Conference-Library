**[00:00:01]** SPEAKER 1: Welcome to Beyond Golden Signals,
**[00:00:03]** Monitoring in the Age of Generative AI.
**[00:00:06]** What makes GenAI applications fundamentally different
**[00:00:10]** from the traditional software we've been monitoring
**[00:00:12]** for decades?
**[00:00:13]** There are four key shifts.
**[00:00:15]** The first is non-deterministic behavior.
**[00:00:18]** The second is the variable cost structure.
**[00:00:22]** Third, we're facing new attack vectors.
**[00:00:26]** And finally, quality is subjective.
**[00:00:32]** Now that we've established why the traditional approaches fall
**[00:00:35]** short and what the new challenges are,
**[00:00:37]** we'll start with the fundamental building block
**[00:00:39]** of all monitoring, the golden signals, or LETS.
**[00:00:46]** We'll dive into the first of the Golden Signals, latency.
**[00:00:49]** Latency answers that fundamental question:
**[00:00:52]** How long does each request take?
**[00:00:54]** In traditional monitoring, we often look
**[00:00:56]** at that median latency,
**[00:00:58]** which tells us what the average user experiences,
**[00:01:00]** for example, 850 milliseconds.
**[00:01:03]** But we'd also look at those extremes, the P95
**[00:01:06]** or P99 latencies, to catch the slower requests
**[00:01:10]** and identify the true outliers and bottlenecks.
**[00:01:13]** But for GenAI, you need to track latency
**[00:01:15]** at a more granular level.
**[00:01:17]** It's not just about the total time from the user clicking send
**[00:01:20]** to the response appearing.
**[00:01:22]** You've got to instrument the latency at multiple stages
**[00:01:24]** within the GenAI pipeline.
**[00:01:26]** For example, the time it takes your RAG retrieval
**[00:01:28]** to find relevant documents,
**[00:01:30]** or the time for the LLM call itself, and finally,
**[00:01:33]** that total request time.
**[00:01:35]** Understanding the latency breakdown is critical
**[00:01:38]** for optimizing and pinpointing
**[00:01:39]** where users are experiencing delays.
**[00:01:41]** In summary, for generative AI, track latency
**[00:01:45]** at multiple stages -- LLM calls,
**[00:01:48]** external API calls, total request time.
**[00:01:53]** Now let's move on to the second Golden Signal, errors.
**[00:01:56]** Errors are fundamental.
**[00:01:57]** We need to know what is the error rate and what types
**[00:02:00]** of errors are occurring.
**[00:02:01]** In the world of GenAI, you need
**[00:02:02]** to segment your errors beyond the classic HTTP status codes.
**[00:02:07]** While traditional monitoring would cover things like 400
**[00:02:09]** or 500 server errors, we must also now track a new category,
**[00:02:14]** that's LLM model errors.
**[00:02:16]** These are errors returned directly
**[00:02:17]** from the model provider,
**[00:02:18]** like the context length being exceeded
**[00:02:21]** or the model safety filter being triggered,
**[00:02:24]** or the model simply being overloaded.
**[00:02:27]** But the takeaway here is to track error rates by endpoint,
**[00:02:29]** by model, and by user segment to quickly identify patterns
**[00:02:33]** and to prevent small issues from turning into major outages.
**[00:02:38]** The third signal that we traditionally monitor
**[00:02:41]** is traffic.
**[00:02:42]** Traffic simply measures how much demand is the system handling.
**[00:02:47]** We typically track this as request per second, or RPS,
**[00:02:50]** over time, as you see in this chart.
**[00:02:53]** Now, the goal of traffic monitoring is
**[00:02:55]** to understand usage patterns.
**[00:02:57]** That's when your system is busy and by how much in order
**[00:03:00]** to ensure that you have the capacity to handle that load.
**[00:03:04]** And for GenAI applications, this is more
**[00:03:06]** than just the total number of API calls.
**[00:03:09]** You've got to also segment your traffic analysis
**[00:03:11]** to be truly effective.
**[00:03:13]** This means monitoring request patterns not just
**[00:03:15]** by time, but by feature.
**[00:03:17]** For example, is it the internal chatbot
**[00:03:19]** or the external facing summarization tool?
**[00:03:22]** Also the user type.
**[00:03:24]** Are premium users or new users driving the most traffic?
**[00:03:29]** And finally, by model.
**[00:03:30]** Which specific model?
**[00:03:32]** Is it a big model, a small model, a more expensive
**[00:03:35]** or cheaper model that's handling the majority of your volume?
**[00:03:38]** And by segmenting this traffic, you can optimize capacity,
**[00:03:42]** manage your model-specific rate limits effectively,
**[00:03:44]** and ultimately control your costs.
**[00:03:47]** The final signal is saturation.
**[00:03:49]** Saturation is all about answering the question,
**[00:03:51]** how constrained are your resources?
**[00:03:54]** It's generally measured by looking at the utilization
**[00:03:56]** of your critical infra.
**[00:03:58]** However, for GenAI apps, the bottlenecks have shifted.
**[00:04:02]** You must pay special attention to two new areas.
**[00:04:05]** The first one is GPU utilization.
**[00:04:07]** The second is API rate limits.
**[00:04:10]** But in the world of GenAI,
**[00:04:11]** your primary saturation warnings will come
**[00:04:13]** from watching infrastructure utilization
**[00:04:16]** and model serving capacity and associated API rate limits.
**[00:04:20]** This is nothing new, but they're new critical bottlenecks
**[00:04:23]** that you need to monitor in order to ensure
**[00:04:25]** that you can handle your increased traffic.
**[00:04:29]** All right, let's move to the first
**[00:04:30]** of our three critical new dimensions, cost monitoring.
**[00:04:34]** As we established, traditional LETS metrics completely miss the
**[00:04:38]** financial implications of GenAI.
**[00:04:41]** The cost structure is highly dynamic and unpredictable.
**[00:04:44]** That means if you don't have visibility, your spending can,
**[00:04:47]** and often will, spiral out of control.
**[00:04:49]** And in this section, we'll cover why this is a critical problem
**[00:04:52]** and, more importantly, the essential metrics
**[00:04:55]** and strategies you need to implement to track your spending
**[00:04:58]** and maintain a healthy budget.
**[00:05:00]** All right, let's look
**[00:05:01]** at why cost monitoring is absolutely critical,
**[00:05:03]** and it all boils down to the unpredictable nature
**[00:05:06]** of GenAI spent.
**[00:05:07]** We've identified three major ways cost can escalate
**[00:05:10]** without warning.
**[00:05:12]** The first is token creep.
**[00:05:15]** This happens when maybe your engineers
**[00:05:17]** or product managers are trying to improve quality,
**[00:05:19]** but they quietly increase the context window for the model.
**[00:05:23]** Without financial review, and because cost is directly tied
**[00:05:26]** to token count, this can result in a cost increase overnight.
**[00:05:31]** Second, we've got model drift.
**[00:05:33]** This is when your team, or myself, somebody like me,
**[00:05:35]** an engineer on your team, might take a faster, cheaper model
**[00:05:39]** and then move into something a little bit more
**[00:05:41]** but perhaps a little bit slower
**[00:05:43]** under the premise of better quality.
**[00:05:46]** This change in model, even if the usage volume stays the same,
**[00:05:49]** can escalate your spending.
**[00:05:52]** And finally, there are uncached calls.
**[00:05:55]** In GenAI, the same query can hit the API repeatedly
**[00:05:58]** if you haven't implemented an effective caching layer.
**[00:06:01]** And we've seen cases where your spend is redundant
**[00:06:05]** because the system is paying for the exact same expense
**[00:06:07]** of model completion over and over again.
**[00:06:10]** And without granular visibility into these three areas --
**[00:06:13]** that's token creep, model drift, and uncached calls --
**[00:06:16]** your costs can escalate rapidly.
**[00:06:20]** So now we know what to track,
**[00:06:21]** but how do we get that granular data?
**[00:06:23]** The answer is a robust cost attribution strategy.
**[00:06:26]** Which means one thing: You've got to tag everything.
**[00:06:30]** First, feature level tagging.
**[00:06:32]** That means by tagging your feature like summarization
**[00:06:35]** or text to speech, basically going in and adding
**[00:06:40]** that feature level tag will tell you
**[00:06:41]** which feature is costing the most.
**[00:06:44]** Secondly, user level tagging.
**[00:06:45]** So using tags like user ID or tagging by organization,
**[00:06:50]** it's essential for chargeback, accurate billing,
**[00:06:52]** and quickly identifying patterns
**[00:06:54]** of abusive usage before they drain your budget.
**[00:06:58]** Third, model level tagging.
**[00:07:00]** Tags like model or provider give you immediate visibility
**[00:07:04]** into the high leverage areas for cost optimization.
**[00:07:08]** You can benchmark the true expense
**[00:07:10]** of using one model versus another.
**[00:07:12]** Finally, endpoint level tagging.
**[00:07:15]** Attributing costs to a region, environment,
**[00:07:17]** or provider helps your infra planning.
**[00:07:20]** You can see how regional distribution of staging
**[00:07:22]** versus prod can impact your total spend.
**[00:07:25]** By making tagging mandatory, you gain the necessary visibility
**[00:07:29]** to understand where your money is going and more importantly,
**[00:07:32]** how to control your spend.
**[00:07:36]** All right, we're going to move on to our second
**[00:07:37]** of the three new dimensions, safety and security.
**[00:07:43]** Let's dive into the specifics of the GenAI threat landscape.
**[00:07:47]** We've categorized them based on their risk level,
**[00:07:49]** starting with the two that we deem critical, PII leakage
**[00:07:53]** and data exfiltration.
**[00:07:56]** Next, we have two attacks at the high risk level,
**[00:07:59]** prompt injection, which is probably the most common,
**[00:08:02]** and the next which is related is jailbreaking.
**[00:08:06]** Finally, there are two at the medium risk level.
**[00:08:09]** The first is denial of wallet.
**[00:08:10]** That's an attack against your budget.
**[00:08:12]** And the next is model extraction.
**[00:08:14]** And that involves sustained systematic probing of the model
**[00:08:17]** with queries to reverse engineer it.
**[00:08:22]** After identifying those threats, the next critical step is
**[00:08:26]** to implement the right metrics to detect and stop them.
**[00:08:29]** Simply put, we need to monitor for security breaches
**[00:08:32]** that don't look like errors.
**[00:08:34]** We focus on four key metrics here.
**[00:08:36]** First, the prompt injection rate.
**[00:08:40]** Second, the PII detection rate.
**[00:08:44]** Third, the content moderation score.
**[00:08:48]** And finally, jailbreak attempts.
**[00:08:53]** We now arrive at arguably the most crucial
**[00:08:55]** of our three new critical dimensions, quality monitoring.
**[00:08:59]** As we've seen, LETS tells you if the service is up,
**[00:09:02]** cost and safety will tell you
**[00:09:03]** if the service is budget compliant and secure.
**[00:09:05]** But ultimately, for a generative AI application, the only thing
**[00:09:09]** that truly matters is whether the output is good.
**[00:09:14]** GenAI presents a deep challenge when it comes
**[00:09:17]** to quality measurement.
**[00:09:18]** It's because quality in GenAI is inherently subjective,
**[00:09:22]** context-dependent, and as a result, difficult to quantify
**[00:09:25]** with traditional metrics.
**[00:09:28]** Let's look at the four core reasons for the difficulty.
**[00:09:31]** First, there's no ground truth.
**[00:09:34]** Second, context matters.
**[00:09:38]** Third, hallucinations are a major challenge.
**[00:09:42]** And finally, we're dealing with subjective satisfaction.
**[00:09:46]** That means that we've moved on from a binary world
**[00:09:48]** where it either works or it doesn't to a spectrum.
**[00:09:51]** Users are judging the response on how helpful,
**[00:09:53]** accurate, and complete it is.
**[00:09:57]** Now that we understand the challenge of measuring quality,
**[00:09:59]** let's look at the essential metrics you must implement
**[00:10:01]** to move beyond the simple "it works" status codes
**[00:10:04]** and truly measure the output of your GenAI app.
**[00:10:08]** We'd recommend tracking these six key metrics.
**[00:10:11]** First, the hallucination rate.
**[00:10:14]** Second, the relevance score.
**[00:10:18]** Third, user satisfaction.
**[00:10:22]** Fourth, we move on to answer completeness.
**[00:10:25]** And before last, we've got retrieval augmented generating.
**[00:10:28]** You must get back your retrieval quality.
**[00:10:31]** And finally, your response coherence.
**[00:10:34]** By implementing these metrics,
**[00:10:35]** you gain the complete multi-dimensional view
**[00:10:37]** of the quality necessary to optimize your app.
**[00:10:43]** All right, so let's bring it all together.
**[00:10:45]** To achieve that comprehensive GenAI observability,
**[00:10:48]** we've got to move on beyond the traditional Golden Signals.
**[00:10:52]** This is a complete monitoring stack
**[00:10:54]** that combines the fundamental LETS metrics, which tell you
**[00:10:58]** if the system is running,
**[00:10:59]** and then it integrates three new dimensions
**[00:11:02]** that tell you how it's running.
**[00:11:03]** The first is cost, how much are we spending?
**[00:11:06]** Second is safety or security.
**[00:11:09]** The third is quality.
**[00:11:10]** And by uniting these LETS metrics with cost, safety,
**[00:11:13]** and quality, we can gain visibility
**[00:11:15]** into our application's health, financial spend,
**[00:11:18]** security posture, as well as the quality of the output
**[00:11:22]** that your users are receiving.
**[00:11:25]** Now, of course, Datadog's been working on this problem already.
**[00:11:28]** We cover the standard Golden Signals and how they apply
**[00:11:30]** to your app, but we've also got cost, security,
**[00:11:34]** and quality monitoring that will help you monitor all of this
**[00:11:37]** in one central application,
**[00:11:39]** Datadog Large Language Model Observability.
**[00:11:43]** Here's a quick summary of LLM Observability.
**[00:11:47]** We've got standard metrics that we mentioned before.
**[00:11:49]** So we automatically capture and visualize key metrics
**[00:11:51]** like latency, errors, tokens per second,
**[00:11:54]** and API rate limit usage directly from your LLM calls.
**[00:11:58]** But we also give you quality and cost.
**[00:12:00]** The platform allows you to track
**[00:12:01]** and analyze those costs associated
**[00:12:03]** with different models.
**[00:12:05]** It also helps you evaluate prompt
**[00:12:07]** and response quality via integrated eval tools
**[00:12:10]** and tracing tool usage.
**[00:12:12]** Safety and security.
**[00:12:14]** Datadog provides capabilities to monitor for security risks,
**[00:12:17]** including identifying and masking PII in prompts
**[00:12:19]** and responses and detecting potential prompt injections
**[00:12:22]** or unsafe content.
**[00:12:26]** And that brings us to the end of our session.
**[00:12:27]** Thank you so much for your time.
**[00:12:29]** To recap the journey, we started
**[00:12:30]** by acknowledging the Golden Signals.
**[00:12:32]** That's latency, errors, traffic
**[00:12:33]** and saturation are the bedrock of monitoring.
**[00:12:36]** They're not going anywhere.
**[00:12:38]** But for GenAI apps, LETS alone leaves you blind
**[00:12:41]** to the things that matter most.
**[00:12:42]** A perfect 200 OK means nothing if your model is hallucinating,
**[00:12:46]** leaking PII, or burning through your budget one token at a time.
