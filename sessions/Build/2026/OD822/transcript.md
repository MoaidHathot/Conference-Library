**[00:00:03]** GUY BOWERMAN: Hello, I'm Guy Bowerman.
**[00:00:05]** I'm a Product Manager for Azure Database
**[00:00:07]** for Postgres Flexible Server.
**[00:00:10]** In this Build 2026 session,
**[00:00:12]** I'll cover migrating workloads to Postgres on Azure.
**[00:00:16]** Migration tooling, it's in a phase
**[00:00:18]** of rapid improvement right now.
**[00:00:21]** The technology is more accessible,
**[00:00:23]** the cost is lower than it's ever been.
**[00:00:25]** I'll be looking at why we're seeing an increase in migration
**[00:00:29]** to Postgres, and also why on Azure, and then I'll be digging
**[00:00:33]** into the tooling that's available to help.
**[00:00:36]** So with that, let's take a look at the agenda.
**[00:00:39]** So I'll start with the why migrate.
**[00:00:42]** Then I'll take a quick look at some of the more recent features
**[00:00:46]** and Build 2026 announcements for Postgres on Azure.
**[00:00:51]** And then I'll go through the tooling that's available
**[00:00:53]** for migrating Postgres workloads to Azure.
**[00:00:57]** And after that, I'll look at how to migrate Oracle workloads,
**[00:01:01]** including the schema,
**[00:01:02]** the database code, and apps to Azure.
**[00:01:05]** So with that, let's get started.
**[00:01:08]** And we'll start with the "why".
**[00:01:11]** So this industry trend that we're seeing
**[00:01:13]** to consolidate database workloads to Postgres seems
**[00:01:19]** to be accelerating, and there are multiple reasons for that.
**[00:01:22]** I mean, one, Postgres is a mature database service.
**[00:01:29]** It's got a highly optimized query engine.
**[00:01:32]** The extension model in Postgres is perfectly suited to adapt
**[00:01:35]** to any new technologies, whether it's the latest AI innovations
**[00:01:40]** or industry-specific technologies like GIS.
**[00:01:44]** It's opensource.
**[00:01:45]** It's backed by an independent community with no license fee,
**[00:01:49]** and that's really key.
**[00:01:50]** Cost is important.
**[00:01:52]** But what about migration to Postgres on Azure?
**[00:01:56]** Let's take a look at that.
**[00:02:00]** So we take opensource Postgres, just as is, no changes,
**[00:02:04]** and run it as a managed service with all
**[00:02:07]** of the enterprise features needed
**[00:02:09]** to run critical workloads.
**[00:02:12]** We work with a lot of household names,
**[00:02:13]** just kind of showing a few here, but OpenAI is a good example.
**[00:02:18]** They're willing to bet their production workloads
**[00:02:21]** on managed Postgres running on Azure.
**[00:02:25]** One of the reasons for this is we've been building the
**[00:02:27]** enterprise features that our customers are asking for.
**[00:02:31]** As well as enterprise fundamentals like performance,
**[00:02:34]** security, reliability, we're also paying a lot of attention
**[00:02:38]** to asks from the developer community.
**[00:02:41]** So we'll invest in features like the VS Code extension,
**[00:02:44]** the Azure AI extension, Microsoft Foundry integration.
**[00:02:49]** But you could still ask, why not just self-host on a VM?
**[00:02:53]** You could run a VM in Azure and host there,
**[00:02:56]** or host it with Kubernetes.
**[00:02:59]** So, I really like to think about the full cost of ownership
**[00:03:04]** for a production workload.
**[00:03:06]** Now, there's an overhead to manage.
**[00:03:09]** You've got high availability, disaster recovery,
**[00:03:12]** you've got scalability, configuration, integration,
**[00:03:15]** security, then there's compliance,
**[00:03:18]** there's maintenance updates, major version upgrades.
**[00:03:22]** I'm not going to read out every line of this.
**[00:03:24]** you'll be pleased to know.
**[00:03:26]** You're welcome to pause.
**[00:03:27]** But these are just some of the high-level points,
**[00:03:30]** and there's a lot more.
**[00:03:31]** So the key point is, if you're self-hosting and running
**[00:03:35]** in production, there's a cost to staying online and meeting all
**[00:03:41]** of these requirements.
**[00:03:43]** So let's just dig into that cost in another level of detail.
**[00:03:48]** There was a recent study by TechTarget
**[00:03:51]** that measured the before and after cost of self-managed
**[00:03:56]** versus running in Azure Database for Postgres.
**[00:04:00]** When you're hosting in a managed environment where you can scale,
**[00:04:04]** compute, and disk resources with features
**[00:04:07]** like built-in connection pooler, these companies were able
**[00:04:11]** to not just save costs, but also
**[00:04:13]** to get better application performance
**[00:04:16]** than when they were running on-premises.
**[00:04:18]** So, one other thing that I think is useful to call out is
**[00:04:23]** when Azure is hosting an opensource database,
**[00:04:26]** it's not just about cost.
**[00:04:28]** We also have a responsibility to the community,
**[00:04:31]** to the upstream opensource community.
**[00:04:33]** So I'll just touch on that a little bit.
**[00:04:37]** We have a team of Postgres committers.
**[00:04:39]** Now, they're independent.
**[00:04:40]** We don't tell them what to work on.
**[00:04:42]** They work on contributing to upstream opensource Postgres.
**[00:04:47]** If we take Postgres 18, for example,
**[00:04:51]** some really significant features for things like query execution,
**[00:04:55]** async IO, observability, these were contributed
**[00:04:59]** by Microsoft committers.
**[00:05:01]** Now, it's great for Postgres, but it also means our customers,
**[00:05:04]** if they run into problems, we can reach out to the top experts
**[00:05:08]** in the world on these topics for help.
**[00:05:11]** So that's one area of investment.
**[00:05:13]** But another that's really important is we're investing
**[00:05:15]** in the developer experience for Postgres.
**[00:05:19]** Now, the VS Code Postgres extension, which is free to use,
**[00:05:25]** it's rapidly becoming a standard for Postgres developers.
**[00:05:29]** And it passed a half a million downloads a few months ago.
**[00:05:34]** But it's not just a development environment.
**[00:05:36]** It's becoming more of a database operations platform.
**[00:05:41]** So you can deploy and manage Postgres.
**[00:05:44]** You can also do performance monitoring,
**[00:05:45]** troubleshooting, visualization.
**[00:05:48]** There are regular updates
**[00:05:50]** and there's continuous improvement on this.
**[00:05:52]** And I'll come back to this platform in the context
**[00:05:55]** of migration in a few minutes as well.
**[00:06:00]** So, that's kind of the why migrate.
**[00:06:02]** Let's look at some of the new features
**[00:06:04]** and announcements that we've added.
**[00:06:08]** So, we have a tech community blog.
**[00:06:11]** It's called "Microsoft Blog for Postgres",
**[00:06:13]** and every month we recap the latest features
**[00:06:17]** that have been added.
**[00:06:19]** The community blog is a great resource for keeping
**[00:06:21]** up with our product and engineering teams,
**[00:06:23]** and it also really shows the pace of development,
**[00:06:26]** because every month we've got a new set of features
**[00:06:28]** and we include guidance on where to look
**[00:06:31]** up more information and how to use them.
**[00:06:34]** I'm going to pick on one area in particular, which is performance
**[00:06:37]** and scale, and just take a quick look at some
**[00:06:40]** of the latest updates in that area.
**[00:06:44]** I'll start with a very recent announcement, Premium SSD v2.
**[00:06:50]** It was recently made generally available.
**[00:06:53]** It enables up to 80K IOPS, 1.2 GiB per second throughput.
**[00:07:00]** It's ideal for IO-intensive workloads.
**[00:07:04]** What's nice is if you need more space,
**[00:07:07]** you can incrementally add it and only pay for what you need.
**[00:07:11]** You don't have to double the size and pay for all of that.
**[00:07:15]** The graph on the right, it shows a PG bench test
**[00:07:18]** across five workload profiles ranging from 32
**[00:07:21]** to 256 concurrent clients.
**[00:07:25]** As the concurrency increases, you see that SSD v1,
**[00:07:30]** which maxes out at 20K IOPS, it starts to max
**[00:07:33]** out as it reaches these limits.
**[00:07:36]** While SSD v2, it continues to scale,
**[00:07:39]** getting up to four times the transaction rate
**[00:07:42]** with sub-millisecond latency.
**[00:07:45]** Now, there's even more, a higher IOPS storage
**[00:07:50]** or a more powerful storage coming soon called UltraDisk,
**[00:07:53]** and I'll talk a little bit about that in the context
**[00:07:58]** of another new announcement, which is the Intel
**[00:08:01]** and AMD v6 compute SKUs are now generally available.
**[00:08:06]** So, with these compute SKUs,
**[00:08:07]** you get up to three times the memory, double the vCores of v5.
**[00:08:13]** You also get better performance per core
**[00:08:16]** and better price performance.
**[00:08:18]** So these are based on the 5th Gen Intel Xeon
**[00:08:21]** and the 4th Gen AMD EPYC 9004.
**[00:08:25]** And with these, you will be able to get up to 400K IOPS
**[00:08:32]** if you use the v6 SKUs with the new high-performance UltraDisk
**[00:08:36]** Storage option that's coming soon.
**[00:08:39]** So, these features enable massive scale-up.
**[00:08:42]** But then there's also scaling out
**[00:08:44]** and parallelization to consider.
**[00:08:46]** So we'll take a quick look there.
**[00:08:49]** We recently made cascading read replicas generally available.
**[00:08:53]** So, now Postgres primary can replicate to read replicas,
**[00:08:57]** which can in turn replicate to another layer of read replicas.
**[00:09:00]** So if you need to scale out read-heavy workloads,
**[00:09:04]** you can have up to 30 replicas from one primary.
**[00:09:08]** It gives you more flexibility and if you for example want
**[00:09:12]** to set up cross-region disaster recovery, you can have some
**[00:09:16]** of these replicas running in other regions.
**[00:09:18]** So this is how customers like OpenAI, for example,
**[00:09:22]** are able to have massive scale in their workloads.
**[00:09:27]** So that's scaling out read workloads.
**[00:09:29]** You can also scale out your data across multiple nodes.
**[00:09:34]** So, one feature that it's been generally available
**[00:09:38]** for a while now, elastic cluster, it makes use
**[00:09:40]** of the Citus Postgres extension.
**[00:09:43]** Your app can talk to one Postgres endpoint,
**[00:09:46]** but you can also shard your data across multiple Postgres nodes.
**[00:09:52]** So, this overcomes the storage and processing limits
**[00:09:55]** of a standalone server.
**[00:09:57]** And you can shard by rows or you can shard by schema,
**[00:10:00]** depending on whether you want to make application changes or not,
**[00:10:03]** and the level of parallelization that you want.
**[00:10:06]** So this can lead to massive performance improvements.
**[00:10:10]** And this feature, when it comes to managed Postgres,
**[00:10:12]** this feature is unique to Postgres on Azure,
**[00:10:14]** and it really unlocks scale.
**[00:10:17]** It's tried and tested, too.
**[00:10:19]** Behind the scenes, it's powering other services at Microsoft.
**[00:10:23]** And in terms of recent announcements,
**[00:10:25]** we recently added Postgres 18
**[00:10:27]** and major version upgrade support.
**[00:10:31]** So that's kind of some of the big performance
**[00:10:33]** and scale new features.
**[00:10:35]** What else are we announcing at Build 2026?
**[00:10:39]** There's a lot of new announcements.
**[00:10:40]** I'll mention a few of them here.
**[00:10:42]** I've divided them into a few categories here, "Migrate",
**[00:10:45]** "Maintain", "Monitor", "Build".
**[00:10:48]** For "Migrate", I'm going to go deeper
**[00:10:50]** into the AI-assisted migration features.
**[00:10:53]** Also, Azure Migrate, the Azure Migrate tool has added Postgres
**[00:10:57]** server discovery and made some improvements there.
**[00:10:59]** So, that really helps with the first phase of migration,
**[00:11:02]** which is, what do I have?
**[00:11:04]** What do I need to migrate?
**[00:11:08]** Then under "Maintain", a managed service, it needs maintenance.
**[00:11:13]** For example, applying minor version updates to Postgres
**[00:11:16]** or security patches to the container OS.
**[00:11:21]** We've added some features to increase your control
**[00:11:24]** over when maintenance is applied.
**[00:11:26]** So now you can defer a maintenance update for up
**[00:11:28]** to two weeks, and you can also apply an update
**[00:11:32]** on demand instead of waiting for a predefined window.
**[00:11:35]** So this is really useful to just get that control
**[00:11:38]** to apply a maintenance update
**[00:11:39]** when it doesn't inconvenience a production workload.
**[00:11:42]** And then for major version upgrades,
**[00:11:45]** we've added a pre-upgrade validation check.
**[00:11:47]** We've extended the pre-upgrade validation check.
**[00:11:50]** So you can simulate an upgrade,
**[00:11:52]** fix any issues before applying an upgrade.
**[00:11:55]** And the goal here is an upgrade that works with no surprises.
**[00:11:59]** Under monitoring, you may have seen there's a new Grafana
**[00:12:04]** dashboard option for Postgres available in the Azure portal.
**[00:12:09]** These Grafana dashboards,
**[00:12:10]** they make monitoring your workload a lot easier
**[00:12:12]** and customizable.
**[00:12:14]** Or if you run your analytics and reporting in Microsoft Fabric,
**[00:12:18]** then you can mirror your data from Postgres for free.
**[00:12:22]** And we've added support for more scenarios like empty tables,
**[00:12:26]** more DDL, data definition language operations,
**[00:12:32]** to make it more robust.
**[00:12:34]** And then we've also added Defender security assessments.
**[00:12:38]** So you can audit the security posture for your database.
**[00:12:42]** For example, does my database have public access?
**[00:12:46]** Does it have public schema access, public role access
**[00:12:48]** that needs locking down?
**[00:12:50]** Or does it have the recommended PG audit settings?
**[00:12:53]** And then in the category of building apps, there's a bunch
**[00:12:58]** of improvements that have been made to the
**[00:13:00]** VS Code Postgres extension.
**[00:13:01]** So an example is query plan visualization.
**[00:13:05]** There's an enhanced performance dashboard, so you can work
**[00:13:07]** with the query store to troubleshoot your top queries.
**[00:13:12]** We've added more operations as well, like backup and restore.
**[00:13:17]** I'm going to include a few links at the end
**[00:13:19]** to some Build sessions where you can see some
**[00:13:21]** of these new features as well.
**[00:13:23]** And also linking to another area
**[00:13:26]** which is the high-performance HorizonDB service that's
**[00:13:29]** in preview.
**[00:13:33]** Let's get on to migration then.
**[00:13:35]** And let's say you have a Postgres workload.
**[00:13:38]** Maybe you're running it on-premises,
**[00:13:39]** you're running it in a VM.
**[00:13:41]** Let's take a look at the tooling that's available
**[00:13:43]** to move it to Azure.
**[00:13:46]** Now, whether you're bringing your workload,
**[00:13:48]** wherever you're bringing your workload from,
**[00:13:51]** we have a migration service that moves it in one step.
**[00:13:54]** So, you could be running in a VM.
**[00:13:56]** We've also got support for a bunch of other services
**[00:14:00]** where you could be running Postgres.
**[00:14:03]** In fact, we've also recently added EDB
**[00:14:06]** and Huawei as sources as well.
**[00:14:09]** So with the migration service in Azure Database for Postgres,
**[00:14:15]** you can just point it to the endpoint
**[00:14:17]** of your source and move it.
**[00:14:19]** You can migrate online to minimize downtime,
**[00:14:22]** or you can do an offline migration
**[00:14:23]** that has fewer limitations and a very easy setup.
**[00:14:27]** You can also do things like flexible server
**[00:14:29]** to flexible server migration.
**[00:14:32]** It's not officially a supported option, but it works
**[00:14:36]** and it gets you random, it could be useful
**[00:14:39]** for certain configuration changes
**[00:14:41]** that might have otherwise required a
**[00:14:43]** point-in-time restore.
**[00:14:45]** So how do you actually get to it?
**[00:14:46]** Let's take a quick look at that.
**[00:14:49]** You can run the migration service from the Azure portal
**[00:14:52]** or on the command line with Azure CLI.
**[00:14:56]** If you're using the portal, the best way to reach it is
**[00:14:59]** to create a new flexible server
**[00:15:01]** and then select the migration option.
**[00:15:03]** So I've included that in this little screenshot here.
**[00:15:07]** From there, you can select your source and it takes you step
**[00:15:10]** by step, as well as listing the prerequisites
**[00:15:14]** that you need to follow.
**[00:15:16]** Now, the list of checks there, worth paying a lot of attention
**[00:15:21]** to and it also links through to docs and tutorials
**[00:15:24]** to help you with these steps.
**[00:15:26]** If you're using the command line,
**[00:15:29]** CLI has full support built in.
**[00:15:31]** If you do run into limitations, there are also options
**[00:15:35]** to use things like the opensource PG dump and restore.
**[00:15:39]** I'll include a link to scenarios where you may want
**[00:15:42]** to do this as well at the end.
**[00:15:45]** So that's Postgres-to-Postgres migration, very straightforward.
**[00:15:49]** Let's look at something more complex,
**[00:15:51]** like migrating Oracle workloads to Postgres and Azure.
**[00:15:55]** I touched on some of the reasons people want to do this.
**[00:15:59]** Perhaps the number one reason that we see a big rise in Oracle
**[00:16:03]** to Postgres migrations is license cost.
**[00:16:07]** Now, I'm showing a list price example here of a license cost
**[00:16:12]** for the 16-processor license.
**[00:16:15]** Maybe you'll get a discount.
**[00:16:17]** But if you compare it to the Postgres license cost of zero,
**[00:16:20]** there's a really compelling reason to look into migration.
**[00:16:25]** The only caveat which has stopped a lot of people
**[00:16:28]** from migrating in the past is
**[00:16:30]** that cross-database migration has always been complex
**[00:16:34]** and therefore costly.
**[00:16:37]** If you divide the migration journey into phases,
**[00:16:41]** it starts with discovery and assessment.
**[00:16:44]** But the most challenging,
**[00:16:45]** complex phases are really for migration.
**[00:16:49]** It really migrates in the database schema,
**[00:16:52]** migrating the database code, like store procedures, packages,
**[00:16:56]** triggers, etc., migrating the application.
**[00:17:00]** Maybe you've got a Spring Boot or like Hibernate app or.NET,
**[00:17:05]** Python, etc. And then, of course,
**[00:17:07]** migrating the data as well.
**[00:17:10]** So, these four phases are typically
**[00:17:12]** where we work with customers on.
**[00:17:14]** And then of course once you get your database into Postgres
**[00:17:17]** and Azure, there's a lot of performance tuning
**[00:17:19]** and cloud optimization options
**[00:17:21]** that you can then take advantage of.
**[00:17:25]** So, particularly the first three steps of these complex areas
**[00:17:29]** like schema, database code, and application migration,
**[00:17:33]** this is where we've added our own tooling
**[00:17:35]** to help reduce the complexity
**[00:17:37]** and lower the cost of these steps.
**[00:17:39]** So, what's the tooling?
**[00:17:41]** So the AI-assisted Oracle-to-Postgres migration
**[00:17:44]** tool, it's available now in the VS Code Postgres extension.
**[00:17:50]** It takes care of the Oracle schema, database code,
**[00:17:53]** and application code phases of the migration.
**[00:17:56]** I've included a short link here.
**[00:17:59]** You can go directly to more details.
**[00:18:01]** So with that, let's take a look into how it works.
**[00:18:06]** We'll start with the schema conversion.
**[00:18:09]** So the migration tool starts by extracting the Oracle schema
**[00:18:13]** and then groups it into related objects.
**[00:18:17]** It uses an LLM to create related chunks and then deploys a set
**[00:18:22]** of schema conversion agents which interact with the LLM,
**[00:18:26]** and they create the SQL code for Postgres.
**[00:18:29]** They validate the code and then make further changes
**[00:18:32]** and iterative improvements.
**[00:18:34]** So the final schema output is then available to review,
**[00:18:39]** and also notes from this phase are available for the AI tooling
**[00:18:42]** to use in the code conversion phases as well.
**[00:18:46]** So let's take a look at this in action.
**[00:18:49]** I'm going to show a schema migration demo that's recorded
**[00:18:53]** by Jonathon Frost, who's one of the program managers
**[00:18:56]** who worked on this feature.
**[00:18:59]** JONATHON FROST: Hi there.
**[00:19:00]** This is Jonathan Frost from the Azure Postgres team.
**[00:19:03]** In this demo, I will demonstrate the Oracle-to-Postgres
**[00:19:06]** migration experience.
**[00:19:08]** To begin our migration journey,
**[00:19:10]** we'll create a new migration project using the Postgres
**[00:19:13]** extension and provide a name for the project.
**[00:19:17]** Next, we'll connect to an Oracle server
**[00:19:20]** by providing connection parameters.
**[00:19:22]** In this case, we are connecting to an instance
**[00:19:25]** of Oracle version 19c.
**[00:19:28]** I can list schemas available on the Oracle server
**[00:19:31]** and select the one or more I want to connect to Postgres.
**[00:19:35]** Now, I'll configure the scratch Postgres database.
**[00:19:38]** The scratch database is used
**[00:19:40]** to test each converted schema object
**[00:19:42]** and automatically fix discovered issues.
**[00:19:45]** The agentic self-correction approach using this live
**[00:19:48]** Postgres database significantly improves reliability
**[00:19:52]** of the migration process.
**[00:19:54]** The last step
**[00:19:55]** of the configuration process is connecting
**[00:19:57]** to an Azure OpenAI endpoint.
**[00:20:00]** This endpoint is used in combination with Agent Mode
**[00:20:03]** to scale migration to thousands of objects,
**[00:20:06]** something Copilot Agent Mode cannot do out of the box.
**[00:20:10]** Now that we have created a migration project, I'll go ahead
**[00:20:13]** and click the "Migrate" button to start the extraction
**[00:20:16]** and conversion process.
**[00:20:18]** The first stage is extracting the Oracle DDL,
**[00:20:21]** which is indicated by this top progress bar.
**[00:20:25]** The second stage is converting each chunk of DDL
**[00:20:28]** by the multiagent orchestration workflow.
**[00:20:31]** At this point, the chunk was attempted to be compiled
**[00:20:33]** against the Postgres database.
**[00:20:35]** And at this point, some errors occurred in the compilation.
**[00:20:39]** In the following step, the conversion agent took this
**[00:20:42]** into account and reconverted this chunk of DDL
**[00:20:46]** and recompiled it against the Postgres scratch database.
**[00:20:49]** Lastly, the status updates show the compilation was successful
**[00:20:53]** and the chunk was applied to the Postgres database.
**[00:20:56]** Additionally, we can see two coding notes were captured.
**[00:21:00]** Coding notes are context items that may be helpful
**[00:21:03]** to an application migration,
**[00:21:05]** and our additional application conversion tooling brings these
**[00:21:08]** into the process.
**[00:21:09]** Here, we see a comprehensive migration report is generated
**[00:21:13]** and shows the details of the number of objects converted,
**[00:21:16]** object types, and the Postgres extensions detected and used
**[00:21:20]** for the conversion context.
**[00:21:23]** This test conversion only processed 34 objects.
**[00:21:26]** We have had customers successfully test this
**[00:21:29]** on a scale of over 2,000 objects.
**[00:21:32]** Now that everything has been converted,
**[00:21:34]** we can use our Postgres extension visualize schema
**[00:21:37]** feature to quickly validate the tables and relationships now
**[00:21:40]** in the Postgres database.
**[00:21:42]** This looks good.
**[00:21:43]** Next, let's review the converted DDL.
**[00:21:46]** To do this, let's right-click on the addresses table
**[00:21:49]** and compare the Oracle version
**[00:21:51]** and the generated Postgres version side-by-side.
**[00:21:54]** All right, this also looks good.
**[00:21:56]** Now, let's go back to the migration project wizard.
**[00:22:00]** After this initial conversion is done,
**[00:22:02]** we can enter interactive mode.
**[00:22:04]** For every conversion issue that was discovered
**[00:22:06]** and couldn't be resolved automatically,
**[00:22:08]** the tool has created a follow-up task for the developer.
**[00:22:12]** You can see here in this table,
**[00:22:14]** we have a handful of tasks to review.
**[00:22:16]** Let's work on this complex trigger one together.
**[00:22:19]** I will click the "Run Task" button
**[00:22:21]** to help me with this task.
**[00:22:22]** The migration tool has generated a custom prompt for me
**[00:22:26]** that gives all the context to the agent mode and enables it
**[00:22:29]** to suggest a solution for the issue.
**[00:22:31]** Agent mode was able to recognize the issue
**[00:22:34]** and provide a correction.
**[00:22:36]** Let's have a look at the two files that were modified.
**[00:22:38]** These look good.
**[00:22:40]** We can keep the changes and finalize the migration.
**[00:22:43]** In this demo, we were able to connect to an Oracle database
**[00:22:47]** and convert its schema into the Postgres format.
**[00:22:50]** We were able to perform it at scale, and then track
**[00:22:53]** and resolve complex migration issues in interactive mode.
**[00:22:57]** GUY BOWERMAN: So, that's schema conversion.
**[00:22:59]** Now, for application conversion, you'll be creating a
**[00:23:03]** VS Code workspace migration project
**[00:23:06]** and copy the application files locally.
**[00:23:09]** The VS Code extension leverages GitHub Copilot Agent Mode.
**[00:23:13]** It uses a Claude model with custom conversion blueprints
**[00:23:17]** and report templates from the schema conversion phase.
**[00:23:21]** The agents are using LLMTs,
**[00:23:24]** or large language model-based translation layers,
**[00:23:27]** to convert the code queries and application logic
**[00:23:31]** across the technology stacks.
**[00:23:34]** It also uses an Azure database for Postgres instance
**[00:23:36]** to validate versions and extensions as it goes along.
**[00:23:42]** With that, let's take a look at that in action.
**[00:23:45]** So I'll play another demo from Jonathon.
**[00:23:48]** It's a shorter demo that covers moving a Java application.
**[00:23:54]** JONATHON FROST: Hi there.
**[00:23:54]** This is Jonathon Frost from the Azure Postgres Team.
**[00:23:57]** And in this demo,
**[00:23:58]** I will demonstrate the Oracle-to-Postgres application
**[00:24:00]** code migration experience.
**[00:24:02]** We have already created an Oracle Database Schema
**[00:24:05]** Conversion project.
**[00:24:06]** Now we continue on our journey to the next step of the wizard,
**[00:24:10]** Application Conversion.
**[00:24:11]** I will click "Convert Application"
**[00:24:13]** to start the process.
**[00:24:15]** I will select the location of the application codebase,
**[00:24:18]** and the connection to a Postgres database instance
**[00:24:21]** to provide database context to the application conversion.
**[00:24:24]** In this case, I have a copy of the codebase already in the root
**[00:24:27]** of my VS Code workspace, which I am selecting.
**[00:24:30]** This starts a composite prompt,
**[00:24:32]** which invokes a custom language model tool, or LMT,
**[00:24:35]** for converting the Oracle client application code
**[00:24:38]** to Postgres equivalence using the target Postgres
**[00:24:41]** database context.
**[00:24:42]** You will see here and here we are connecting
**[00:24:45]** to our chosen Postgres database.
**[00:24:47]** Then, at these points,
**[00:24:49]** our additional LMTs are obtaining the version
**[00:24:52]** and installed extensions of the Postgres database.
**[00:24:55]** Here you will see our coding notes are being read
**[00:24:58]** from our recent database schema migration.
**[00:25:01]** These provide valuable context
**[00:25:02]** to the application conversion flow.
**[00:25:04]** At this point, you can see that it's making resource
**[00:25:07]** and database connection changes to the code base.
**[00:25:12]** Now, it is changing the ORM code to align to the models
**[00:25:15]** of the Postgres table data types.
**[00:25:20]** Now, at this point,
**[00:25:21]** we are calling the build Java project LMT.
**[00:25:24]** This LMT is provided from the Java app mod extension.
**[00:25:28]** By referencing this LMT in our blueprints,
**[00:25:30]** we can leverage capabilities across our related extensions.
**[00:25:33]** The build process runs and looks
**[00:25:35]** like it was successful on the first try.
**[00:25:39]** In the next step, we call into the generate unit test LMT.
**[00:25:44]** This is another LMT provided by the Java App mod extension
**[00:25:47]** and provides a powerful capability
**[00:25:49]** to extend our conversion experience.
**[00:25:52]** Now that the unit tests are completed,
**[00:25:54]** you can see it successfully generated and ran over 30 tests
**[00:25:58]** with 100% passing rate.
**[00:26:00]** Not bad. For a final step
**[00:26:02]** in the application migration experience,
**[00:26:04]** a comprehensive report is generated
**[00:26:06]** and opened automatically for the user when the flow completes.
**[00:26:10]** In this demo, we were able
**[00:26:11]** to convert an Oracle client application codebase
**[00:26:14]** to the Postgres equivalents.
**[00:26:15]** We performed this process with a combination of custom LMTs
**[00:26:19]** for code conversion and database context.
**[00:26:21]** We detected this was a Java app,
**[00:26:23]** and then we leveraged the Java app mod extension LMTs
**[00:26:27]** to provide enhanced capabilities across our installed extensions.
**[00:26:31]** GUY BOWERMAN: Okay, so let's do a quick recap.
**[00:26:34]** We looked at some of the reasons behind the industry trend
**[00:26:37]** to consolidate database workloads on Postgres.
**[00:26:40]** We looked at why Postgres on Azure.
**[00:26:43]** And then I went through some of the latest performance
**[00:26:47]** and scale features and also Build 2026 announcements.
**[00:26:51]** Then we looked at migration tooling
**[00:26:53]** for Postgres-to-Postgres migration,
**[00:26:56]** and the AI-assisted tooling for Oracle-to-Postgres on Azure.
**[00:27:01]** There's a lot of information there,
**[00:27:03]** and I'll add some next steps to find out more.
**[00:27:07]** So here are some links to Build 2026 sessions.
**[00:27:11]** Some of these, like the lightning talk, for example,
**[00:27:14]** are only available at Build, and others are available online.
**[00:27:18]** I've included a short link here aka.mspostgresonazurebuild2026.
**[00:27:24]** You can go there and see the links to the sessions.
**[00:27:28]** So with that, oh, one other thing I've added is some links
**[00:27:32]** to the Postgres documentation as well
**[00:27:34]** on migration and migration tools.
**[00:27:38]** So with that, I'll leave it there
**[00:27:39]** and thank you for watching.
