**[00:00:02]** KERIM SATIRLI: Hi, my name is Kerim Satirli,
**[00:00:03]** I'm a Senior Developer Advocate at HashiCorp, we're focused
**[00:00:07]** on infrastructure and orchestration tooling.
**[00:00:10]** Thank you for joining our session on how to discover,
**[00:00:12]** govern and scale Microsoft Azure resources
**[00:00:15]** with HashiCorp Terraform.
**[00:00:19]** Now, today's session is about a problem every Azure team has,
**[00:00:23]** but very few have a clean answer for, the gap between what's
**[00:00:27]** in your Terraform state and what's actually running
**[00:00:30]** in your subscriptions and tenants.
**[00:00:33]** So sit back and let's get ready to dive in.
**[00:00:37]** Every practitioner and customer team I talk
**[00:00:40]** to gives me a coverage number, 80%, 90, sometimes higher.
**[00:00:46]** Now, when we actually sit down and compare Terraform state
**[00:00:48]** against what's running in their subscriptions,
**[00:00:51]** the real number is somewhere between 40 and 60%.
**[00:00:55]** Some do really well and actually hit 80%,
**[00:00:57]** but no matter their number, they all think one thing,
**[00:01:02]** we do everything with Terraform.
**[00:01:05]** The gap here isn't dishonesty, it's that nobody's measuring.
**[00:01:10]** Resources accumulate outside infrastructure's code
**[00:01:13]** for entirely human reasons, which we'll get to in a moment.
**[00:01:17]** And then the path back from unmanaged
**[00:01:19]** to managed has historically required a heroic engineering
**[00:01:22]** effort or fees you couldn't actually afford.
**[00:01:26]** That's a problem decisions about.
**[00:01:29]** By the end of the next 20 minutes,
**[00:01:30]** you'll have seen a workflow that closes that gap in a quarter,
**[00:01:34]** rather than a quarter year.
**[00:01:37]** Quick sidebar, if you've heard of infrastructures code,
**[00:01:40]** but aren't entirely sure what it or Terraform is,
**[00:01:43]** think of it this way, the traditional way
**[00:01:46]** to provision resources and deploy resources in Azure is
**[00:01:50]** to open the Azure portal, find the service you want
**[00:01:53]** and then manually click to get at your infrastructure.
**[00:01:57]** While this seems fast, it is error prone,
**[00:02:02]** because to get the same exact result,
**[00:02:04]** you have to click the same exact buttons next time
**[00:02:09]** and not make any mistakes.
**[00:02:12]** Comparatively, infrastructures code allows you
**[00:02:14]** to describe your infrastructure in human readable text file
**[00:02:18]** that you conversion control in review
**[00:02:20]** with your colleagues easily.
**[00:02:22]** And because it is code, tools like Terraform can parse it
**[00:02:26]** and turn your pros into provision infrastructure.
**[00:02:30]** So with all those benefits, you might wonder,
**[00:02:34]** how do resources end up not being codified?
**[00:02:38]** Well, there are four partners I see most often and none
**[00:02:42]** of them are actually failures of engineering discipline.
**[00:02:46]** The first is the most common, I'll codify it later.
**[00:02:50]** Somebody with all the right intentions clicks something
**[00:02:52]** in the portal during exploration, fully meaning
**[00:02:55]** to bring under management later.
**[00:02:58]** But later never arrives.
**[00:03:01]** The second is a 2 a.m. incident fix, because writing Terraforms
**[00:03:05]** and any infrastructures code while production is
**[00:03:07]** down is sometimes a hard sell, especially for teams
**[00:03:11]** that do not codify everything.
**[00:03:14]** The third is a classic, the acquisition.
**[00:03:17]** You inherit an environment you've never seen
**[00:03:20]** and you don't even know what's in it, all you know is
**[00:03:23]** that there's a new subscription in your account with stuff
**[00:03:26]** that doesn't look like it belongs.
**[00:03:29]** And the fourth is the POC that became production,
**[00:03:33]** because it worked, and nobody had time to rebuild it properly,
**[00:03:37]** because it was already live and serving customers.
**[00:03:42]** Point of this list isn't to prevent these situations,
**[00:03:45]** you can't, you absolutely can't,
**[00:03:48]** they are going to keep happening.
**[00:03:51]** The point is to have a fast path back.
**[00:03:57]** And this is even worse when you're running AI workloads.
**[00:04:00]** Not a genta clube [assumed spelling] to generate code, no,
**[00:04:03]** actual GPU resources for your AI LLM
**[00:04:06]** and machine learning infrastructure.
**[00:04:09]** When you can't attribute cost,
**[00:04:10]** because you're missing important tags,
**[00:04:12]** your organization will have a harder time figuring
**[00:04:14]** out which experiment, which team
**[00:04:16]** and which project a given resource belongs to.
**[00:04:21]** And, of course, network isolation is a huge problem.
**[00:04:24]** Your training environment
**[00:04:25]** and your inference environment have very,
**[00:04:28]** very different security postures
**[00:04:30]** and one ungoverned subnet can collapse that boundary.
**[00:04:34]** Identity sprawl is a third and this one's specific
**[00:04:36]** to agent based architectures.
**[00:04:39]** Every agent has managed identity,
**[00:04:40]** every managed identity has scopes
**[00:04:42]** and if those scopes aren't defined in code,
**[00:04:44]** your audit story falls apart the moment somebody asks.
**[00:04:49]** And we're not even diving into the blast radius of leaking data
**[00:04:52]** because your storage account is allowed
**[00:04:54]** to be publicly accessible.
**[00:04:57]** Now, if we briefly switch our terminal, Terraform, of course,
**[00:05:00]** understands this problem.
**[00:05:01]** Traditionally, you'd use the CLI to import some Terraform
**[00:05:04]** with the import command.
**[00:05:06]** Terraform has support for this and has supported it
**[00:05:09]** for years and still does.
**[00:05:11]** It works, but is very much one resource,
**[00:05:15]** one address at a time and, therefore, is time consuming.
**[00:05:19]** Since Terraform 1.5 E can do this with import blocks.
**[00:05:23]** Discovery is still in U, but this is a real improvement
**[00:05:26]** over the old workflow.
**[00:05:28]** You get a plan first model, you can review the generated config
**[00:05:32]** in a pull request and you can apply it when you're happy.
**[00:05:37]** If you've adopted this pattern, you're already
**[00:05:39]** in way better shape than most teams.
**[00:05:42]** But notice what's still missing, you're still writing
**[00:05:45]** that import block yourself.
**[00:05:47]** Even if you have some tooling that may infer it.
**[00:05:52]** This means that you already need
**[00:05:53]** to know what the resource ID is inside Azure, you need to know
**[00:05:58]** that the resource actually exists.
**[00:06:01]** Now, in the Terraform search, this feature is available
**[00:06:06]** in the Terraform CLI since Terraform 1.14,
**[00:06:09]** which was released in November 2025
**[00:06:12]** and it upgrades the way you're going to do imports
**[00:06:15]** in the future in an absolutely amazing way.
**[00:06:19]** The whole process is so simple, it consists of three steps.
**[00:06:24]** First, we define a search query, say,
**[00:06:28]** give me all unmanaged MS SQL servers in my subscription
**[00:06:32]** that INSMD build resource group.
**[00:06:35]** Then you run the Terraform query command on the CLI
**[00:06:39]** and let Terraform do its job.
**[00:06:41]** It authenticates to Azure the way you normally do
**[00:06:44]** and starts querying the remote API
**[00:06:46]** for all the unmanaged servers.
**[00:06:48]** Give this a minute or two,
**[00:06:49]** depending on how much data you have
**[00:06:51]** and how many resources your query is looking at
**[00:06:54]** and then you're ready for step three, generating code.
**[00:06:58]** Yep, no more hand coding everything,
**[00:07:01]** hoping you don't make copy/paste errors or forget an attribute,
**[00:07:05]** with Terraform search, you get the code generated for you,
**[00:07:10]** store it in the.TFL, so you can expect it, peer review it
**[00:07:14]** and make sure you're aligning your resources
**[00:07:16]** to your organization's requirements.
**[00:07:21]** Search, invert the import question.
**[00:07:26]** Instead of a situation where it's very much run,
**[00:07:29]** I know what I want, now help me write the config,
**[00:07:32]** this changes it to, show me what's there,
**[00:07:36]** generate the config from it and then let me plan the import.
**[00:07:40]** Three commands, instead of three weeks of inventory work.
**[00:07:46]** Let that sink in for a second.
**[00:07:50]** And now let me show you.
**[00:07:53]** Let's first have a look at what we're dealing with.
**[00:07:56]** I'll open the Azure portal in my browser
**[00:07:59]** and I can see our subscription, I'm in a single resource group
**[00:08:04]** and you can see roughly 30 resources scattered across it.
**[00:08:08]** Networking foundations, security groups, a nat gateway,
**[00:08:13]** a storage account and a function app and, of course,
**[00:08:16]** private DNS to put it all together,
**[00:08:19]** public IP addresses, and much more.
**[00:08:23]** Sadly, all of this is unmanaged.
**[00:08:27]** And you're not even seeing the worse of it.
**[00:08:29]** Some of these have tags, others don't,
**[00:08:32]** sometimes the tags match a format, sometimes they don't.
**[00:08:37]** And, now, I know this is not a heavy ask, but pretend for sake
**[00:08:41]** of this demo that three different teams click this
**[00:08:43]** environment together over the course of a year,
**[00:08:46]** I know I've been there, I know you've been there,
**[00:08:49]** so you know what we're looking at, different conventions,
**[00:08:52]** no central inventory, nobody's entirely sure what depends
**[00:08:56]** on what and which resources we can upgrade
**[00:09:01]** without breaking the others.
**[00:09:05]** So, let's change that, let's remove some of the risk
**[00:09:10]** and make this useable.
**[00:09:12]** First, we're write out the query
**[00:09:15]** for the resources we want to discover.
**[00:09:19]** There are too many resources to fit in a single screen,
**[00:09:21]** so I'll highlight three of them.
**[00:09:23]** I'll start with a nat gateway,
**[00:09:25]** because I absolutely want that to be managed.
**[00:09:28]** Then the security groups,
**[00:09:30]** because if there's anything I want to manage
**[00:09:34]** through Terraform right away, it is definitely my security stuff.
**[00:09:39]** And, of course, the two public addresses.
**[00:09:42]** By managing them through Terraform, I can bring them
**[00:09:44]** into other systems, I can use the whole Terraform provider
**[00:09:48]** ecosystem, and make sure those IPs end
**[00:09:51]** up in my monitoring tooling,
**[00:09:53]** they end up in my on-premise systems
**[00:09:56]** that need access and much more.
**[00:10:01]** Now, if you're looking at your screen, you'll notice
**[00:10:04]** that I'm not specifying any Azure credentials in this file.
**[00:10:08]** Reason for that is simple, Terraform search inherits these
**[00:10:13]** from your overall provider config,
**[00:10:15]** so as long as your normal Terraform plan run can succeed,
**[00:10:19]** Terraform query, the CLI command, can also
**[00:10:22]** and will also succeed.
**[00:10:25]** If I want to be even more prescriptive,
**[00:10:27]** I can configure each query to look only
**[00:10:30]** at a specific research group, for example.
**[00:10:33]** In this case I'm saying, for the nat gateway,
**[00:10:37]** only list unmanaged resources
**[00:10:40]** in the Microsoft built 2026 unmanaged resource group,
**[00:10:44]** which are created specifically for this session.
**[00:10:48]** Then back to Terraform
**[00:10:50]** and execute the Terraform query command.
**[00:10:53]** And after a few seconds and a few CPU cycles,
**[00:10:57]** we'll see our resources appear.
**[00:11:00]** Now, for the sake of this demo, I'm showing you the first two,
**[00:11:03]** but anything I query for, which will appear,
**[00:11:06]** as long as there's a match for my query.
**[00:11:09]** Keep in mind that if you set up constraints here,
**[00:11:13]** that result in the API not returning anything,
**[00:11:17]** Terraform also won't be able to find it.
**[00:11:20]** So don't hard code the variable,
**[00:11:23]** don't hard core the resource names, use variables
**[00:11:26]** and make sure everything makes sense.
**[00:11:29]** But, in this case, everything looks good,
**[00:11:31]** so let's export our config.
**[00:11:33]** For this, I'll use a Terraform query command again,
**[00:11:37]** but this time I specify the path I want to save the config to.
**[00:11:42]** And, again, after a few CPU cycles I can switch to my editor
**[00:11:46]** and inspect the newly generated unmanaged.TF file.
**[00:11:52]** And I'm showing an exert here,
**[00:11:54]** because ultimately those four resources generated about 2,
**[00:11:57]** 300 lines of import statements and resource definitions,
**[00:12:02]** but right from the top you can see
**[00:12:05]** that Terraform left a comment
**[00:12:06]** to let you know this is a generated file.
**[00:12:09]** Not shown on screen, but definitely
**[00:12:11]** in your file is a word of warning from Terraform
**[00:12:14]** to inspect and verify everything,
**[00:12:18]** we'll do that in the background
**[00:12:20]** and meanwhile continue on-boards.
**[00:12:22]** The four resources
**[00:12:24]** that I discovered are good for almost 300 lines.
**[00:12:29]** So I invite you to try this out yourself instead
**[00:12:31]** of watching me scroll through a long file.
**[00:12:35]** But I do want to show you one part.
**[00:12:38]** Below each discovered and config generated resource,
**[00:12:43]** you also have an import block
**[00:12:44]** to easily import this newly discovered,
**[00:12:48]** and currently unmanaged resource into your Terraform state.
**[00:12:52]** All it takes is one Terraform plan and apply cycle.
**[00:12:56]** And, of course, this is using the import block,
**[00:12:59]** you can easily use HCP Terraform for this.
**[00:13:04]** Now at this point you might be wondering, are we done now?
**[00:13:08]** We imported everything, right?
**[00:13:09]** No more unmatched resources, we learned how to do this
**[00:13:14]** in an almost programmatic way, you can bring
**[00:13:17]** in the HashiCorp Terraform agent skills and get a lot of this set
**[00:13:21]** up programmatically and through agentic loops and, yes,
**[00:13:27]** we could totally stop here, we could take a few minutes back,
**[00:13:30]** but there's one more thing I want to show you.
**[00:13:33]** We already made huge leaps, now I want to go
**[00:13:38]** from managed to the next level.
**[00:13:42]** We discovered we imported, but in doing so,
**[00:13:45]** we retained all the old configurations.
**[00:13:49]** Terraform did not make any changes to it, unless you did.
**[00:13:54]** So, the managed section is done,
**[00:13:57]** so let's mark this section as done.
**[00:14:00]** Now, what's next is to apply our organizational policies
**[00:14:03]** to our newly imported resources.
**[00:14:06]** This will allow us to eliminate drift
**[00:14:08]** and make sure any resources we imported feel and behave
**[00:14:12]** like other resources, with the right tag,
**[00:14:15]** the right naming conventions and many,
**[00:14:17]** many more things we can create it for, such as,
**[00:14:20]** appropriate instance types,
**[00:14:23]** making sure we're using the right SKUs,
**[00:14:26]** whatever you can imagine and want to create a policy for,
**[00:14:30]** this is a path you should be on.
**[00:14:34]** So let's switch back to our editor
**[00:14:36]** and create a Sentinel policy.
**[00:14:38]** HashiCorp Sentinel is a policy framework that blocks Terraform
**[00:14:42]** from carrying out operations that are not in line
**[00:14:45]** with your policy definitions.
**[00:14:48]** We'll start by defining types
**[00:14:50]** of resources we want to match against.
**[00:14:52]** Here we've got our set of public IPs, the nat gateway
**[00:14:57]** and the security code.
**[00:14:59]** Next, we'll collect all planned resources
**[00:15:03]** that are taggable whenever we run a plan.
**[00:15:06]** And then we'll process these resources in a loop
**[00:15:09]** and collect their tags.
**[00:15:11]** You'll notice a comment sign there, because in the interest
**[00:15:14]** of not flooding your screen,
**[00:15:17]** I'm only showing you a few lines of code at a time.
**[00:15:20]** So let's look at the policy separately.
**[00:15:23]** Here we've got a simple conditional where we check
**[00:15:25]** for violations, like, a missing owner tag
**[00:15:28]** or an owner tag in the wrong format.
**[00:15:31]** Now this is purely for demo purposes.
**[00:15:33]** Of course, in your case, you'll have many, many more policies
**[00:15:38]** and if you're wondering,
**[00:15:39]** how do I even get started with that checkout?
**[00:15:41]** The Terraform registry at registry.terraform.io,
**[00:15:45]** where we have a handful
**[00:15:47]** of amazing policy packs specifically
**[00:15:51]** for your Azure use case.
**[00:15:55]** But in this case, our policy is written,
**[00:15:58]** so just like with Terraform,
**[00:15:59]** we'll apply the policy through Sentinel.
**[00:16:03]** And, again, after a few CPU cycles,
**[00:16:05]** we can see that the results return and our resources are,
**[00:16:09]** in fact, not aligned with the organization's naming policy.
**[00:16:15]** This is exactly what we expected.
**[00:16:17]** We imported resources that we knew were not following
**[00:16:20]** organizational guidelines.
**[00:16:23]** Terraform happily imports those, Sentinel then prevents you
**[00:16:28]** from making further changes
**[00:16:30]** until you've eliminated this drift.
**[00:16:33]** That being said, we're using Sentinel
**[00:16:37]** in a soft-fail mode here, so we could still continue
**[00:16:40]** and just get an advisory, but for what it's worth,
**[00:16:45]** start working on a hard fail as soon as possible
**[00:16:48]** to make sure your infrastructure is governed the right way.
**[00:16:55]** Though, fixing all of this is a task for another time.
**[00:17:02]** For now, we're at the stage where we can rely
**[00:17:04]** on our infrastructure to be Terraform managed and governed
**[00:17:07]** by appropriate policies using Sentinel.
**[00:17:12]** And that brings us to the conclusion of this session.
**[00:17:15]** Hopefully you've learned something new and I've been able
**[00:17:18]** to inspire you to bring more resources
**[00:17:20]** under Terraform management and go the extra mile
**[00:17:23]** to govern them appropriately with organizational policies
**[00:17:26]** that make sense for you and your organization.
**[00:17:31]** Remember, use the Terraform query command
**[00:17:34]** to bring unmanaged resources under management
**[00:17:38]** and use Sentinel to enforce policies that make sense
**[00:17:41]** for your organization.
**[00:17:43]** Finally, here are three links I think are worth looking at.
**[00:17:49]** We've got the documentation for the CLI commands,
**[00:17:52]** a blog post diving into the why and how of Terraform query and,
**[00:17:57]** of course, a Sentinel playground
**[00:17:59]** to see the full policy in action.
**[00:18:03]** With that, thank you so much for joining, have a great day
**[00:18:07]** and a great rest of Microsoft built 2026.
