**[00:00:03]** DIPTI BORKAR: Hello everyone.
**[00:00:04]** Welcome to the "Unify Your Data Estate on a Single,
**[00:00:08]** AI-ready Data Lake" session at Microsoft Build.
**[00:00:11]** I'm Dipti Borkar, here with the OneLake and Fabric teams,
**[00:00:15]** and excited to share a lot of information
**[00:00:19]** about OneLake and Fabric with you.
**[00:00:22]** So let's jump right in.
**[00:00:24]** OneLake, if you can think of it that way,
**[00:00:26]** is the OneDrive for data.
**[00:00:28]** Not only does it unify data that's
**[00:00:30]** in your Microsoft managed estate, for example,
**[00:00:33]** Fabric of course, with all its various engines, the Azure
**[00:00:39]** and on-prem estate could be ADLS and others,
**[00:00:44]** the business productivity tools, SharePoint as well,
**[00:00:47]** maybe on-prem, other clouds, S3, GCP, and many,
**[00:00:52]** many other data providers, all with zero ETL,
**[00:00:57]** different mechanisms that exist, and we'll walk through it.
**[00:01:00]** We'll walk through both shortcuts and mirroring
**[00:01:04]** and how you can unify this data estate.
**[00:01:06]** Now, once your data is in OneLake and you have this
**[00:01:11]** in a single place, it's a single pane of glass,
**[00:01:14]** you can then access this information in many,
**[00:01:16]** many different places across the Microsoft ecosystem.
**[00:01:20]** Through Teams, through Fabric, through Foundry,
**[00:01:24]** OneLake is deeply integrated across all of these estates,
**[00:01:29]** all the way in Excel, where the OneLake hub can be opened up
**[00:01:33]** and you can bring in your structured data
**[00:01:35]** into Excel as well.
**[00:01:37]** So, unify your data in OneLake and make it available
**[00:01:42]** within your Microsoft estate.
**[00:01:44]** But that's not it, that's not where we stop.
**[00:01:47]** You can, with OneLake, the data is completely open.
**[00:01:51]** We'll hear about the open formats in just a bit.
**[00:01:54]** We support both Delta and Iceberg,
**[00:01:57]** and with these open formats, you can have data access
**[00:02:00]** through many, many different projects,
**[00:02:03]** products, and services.
**[00:02:05]** From opensource products like DuckDB to Databricks, Snowflake,
**[00:02:09]** ServiceNow, Salesforce, ClickHouse,
**[00:02:11]** and many, many others.
**[00:02:12]** And so the goal of OneLake is truly giving you
**[00:02:17]** that unification of data, especially for the AI age,
**[00:02:21]** where you need not just data, but also context,
**[00:02:25]** and make it accessible everywhere.
**[00:02:27]** Now, the OneLake ecosystem is extremely vibrant.
**[00:02:31]** There are many, many different types of systems
**[00:02:35]** that integrate into OneLake.
**[00:02:37]** You can integrate in natively.
**[00:02:39]** For example, Josh will talk about how Databricks
**[00:02:44]** and Snowflake can integrate in natively and read
**[00:02:48]** and write directly on top of OneLake, bringing in your data
**[00:02:52]** into OneLake and then being accessible
**[00:02:55]** in many different places.
**[00:02:57]** Or you can integrate using the catalog mechanisms,
**[00:03:01]** catalog federation if you call it, Iceberg rest catalogs,
**[00:03:05]** etc. And there's a large range of services
**[00:03:08]** that fall into that category.
**[00:03:10]** In addition, of course, OneLake integrates
**[00:03:13]** with the data movement projects and products as well.
**[00:03:18]** Informatica, Fivetran and others integrate with OneLake
**[00:03:22]** so that you can bring in data natively into OneLake from many,
**[00:03:25]** many different places.
**[00:03:27]** And there's many others.
**[00:03:28]** It's a vibrant ecosystem.
**[00:03:30]** It's continuously growing and if you're a builder,
**[00:03:34]** we look forward
**[00:03:35]** to you integrating with OneLake as well.
**[00:03:39]** Now, let's talk a little bit
**[00:03:40]** about the customers that are on OneLake.
**[00:03:43]** OneLake is the foundation for Microsoft Fabric.
**[00:03:47]** Microsoft Fabric is a single product
**[00:03:49]** that provides everything you need for managing your data,
**[00:03:54]** exploring your data, bringing in insights from your data
**[00:03:57]** and making it AI ready.
**[00:03:59]** And every customer of Fabric is also a OneLake customer.
**[00:04:02]** So this is 35,000-plus paying customers which are on Fabric
**[00:04:07]** and on OneLake, and over 80%
**[00:04:09]** of the Fortune 500 use OneLake as well as Fabric.
**[00:04:14]** And it's phenomenal to see the momentum that we've been seeing.
**[00:04:18]** The service itself, the OneLake service,
**[00:04:21]** has 48 billion interactions per day.
**[00:04:24]** It's pretty tremendous.
**[00:04:27]** We have a very, very strong reliability of course
**[00:04:31]** for serving up these interactions.
**[00:04:35]** As I talked about, a lot of this is using zero copy.
**[00:04:39]** And so we have a mechanism for shortcuts that we'll get into,
**[00:04:43]** 9.4 million active shortcuts that are already created
**[00:04:47]** on OneLake across the ecosystem.
**[00:04:50]** This is within OneLake itself.
**[00:04:51]** It might be from S3, AWS S3, GCP, on-prem, many,
**[00:04:58]** many different sources.
**[00:04:59]** So, phenomenal to see the momentum
**[00:05:02]** where customers are truly trying to unify their data and build
**[00:05:06]** that single pane of glass to see all of it and manage it.
**[00:05:10]** And in terms of growth, it's growing at 4X year-over-year
**[00:05:15]** from a storage perspective.
**[00:05:17]** So if you haven't started off with OneLake yet,
**[00:05:19]** let's get started and try it out.
**[00:05:23]** Lots of different customers, if you haven't started off
**[00:05:25]** with OneLake yet, take a look
**[00:05:27]** at our Fabric Featured Customer list.
**[00:05:29]** But there are three in particular
**[00:05:31]** that I wanted to call out.
**[00:05:33]** Lumen, where OneLake allowed them to ingest all the data once
**[00:05:41]** and then use it anywhere.
**[00:05:42]** So this beauty of a single pane
**[00:05:45]** of glass is what they benefited from.
**[00:05:49]** The London Stock Exchange Group, Fabric is,
**[00:05:53]** their data-as-a-service is built on Fabric
**[00:05:57]** and the interoperability between Snowflake and Databricks
**[00:06:01]** and others and the openness
**[00:06:04]** of OneLake is really what got them to adopt it.
**[00:06:08]** And then finally, AP Pension, where they eliminated the ETL
**[00:06:15]** and the E and the L, and really just left the transformation
**[00:06:18]** in there with our mirroring capabilities.
**[00:06:20]** Now, the core of OneLake has four different aspects,
**[00:06:25]** and we'll jump into it right after this.
**[00:06:27]** So you have the unified data estate,
**[00:06:30]** which we touched on a little bit.
**[00:06:32]** It's completely open and allows you to access data
**[00:06:36]** from many different platforms.
**[00:06:38]** It's truly built to be AI ready, and we'll see how it integrates
**[00:06:41]** with Foundry and many other aspects, many other products.
**[00:06:45]** And all of this comes with a unified layer discovery
**[00:06:48]** and governance with OneLake security.
**[00:06:51]** And so we'll touch on that in just a minute.
**[00:06:53]** But to jump into this, let me invite Josh.
**[00:06:57]** Josh, why don't you take it over and take us
**[00:07:00]** through these pillars across OneLake?
**[00:07:03]** JOSH CAPLAN: All right.
**[00:07:05]** Thanks, Dipti.
**[00:07:06]** Let's get into it.
**[00:07:08]** So it's been a really exciting past few years.
**[00:07:11]** We started with all these customers who were dealing
**[00:07:12]** with these data silos across the organization.
**[00:07:15]** They could not get the data they need.
**[00:07:16]** They could not blend together the data they need.
**[00:07:19]** And OneLake really came in like a wrecking ball
**[00:07:21]** and busted open these silos, freed the data,
**[00:07:24]** and unified it all into a single, logical lake.
**[00:07:28]** Now, with OneLake, there's always one lake
**[00:07:33]** per organization.
**[00:07:34]** You can never have more than one.
**[00:07:35]** You can never have less than one.
**[00:07:36]** It's always there.
**[00:07:37]** This is one of the ways we avoid silos.
**[00:07:39]** All data shows up in OneLake in open formats.
**[00:07:41]** It can be automatically indexed and scanned,
**[00:07:44]** and it's always protected by OneLake security.
**[00:07:48]** Now, bringing your data estate to OneLake can be very easy.
**[00:07:52]** There are two ways to bring data to OneLake.
**[00:07:55]** The first, and probably the easiest way,
**[00:07:56]** is just to connect your existing data estate.
**[00:07:59]** Here you can connect your data no matter where it lives
**[00:08:01]** without any data movement or any data duplication.
**[00:08:03]** There's no migration.
**[00:08:04]** This can include data in Azure or other clouds, or on-prem.
**[00:08:10]** Here you manage your existing storage resources,
**[00:08:12]** but you get all the same benefits and features
**[00:08:14]** of OneLake without any movement.
**[00:08:18]** Additionally, you can physically store your data in OneLake.
**[00:08:22]** We manage over three million storage accounts today
**[00:08:24]** for our users.
**[00:08:26]** This is what really makes us the OneDrive for data.
**[00:08:28]** OneLake automatically handles the scale and the throughput
**[00:08:31]** as your needs change, all without you having
**[00:08:33]** to manage your individual storage resources.
**[00:08:36]** No matter how the data gets to OneLake, whether you connect it
**[00:08:38]** or you store it there, all the functionality is the same
**[00:08:41]** after that.
**[00:08:45]** So we've made a lot of improvements
**[00:08:47]** on how we physically store data in OneLake.
**[00:08:50]** Since launch, Microsoft Fabric has always stored its data
**[00:08:53]** within OneLake.
**[00:08:55]** We recently announced
**[00:08:55]** that Snowflake can now also natively stores its iceberg
**[00:08:58]** tables in OneLake.
**[00:09:01]** We're also pleased to announce that now Azure Databricks is
**[00:09:04]** in preview with storing its data in OneLake as well.
**[00:09:07]** This is in addition to anything else
**[00:09:09]** that can talk to Azure Storage.
**[00:09:11]** OneLake exposes the same ADFS and Blob APIs, so any service
**[00:09:16]** that knows how to talk
**[00:09:17]** to storage can natively read or write to OneLake.
**[00:09:23]** We've been busy on making this native storage better
**[00:09:25]** over the years.
**[00:09:27]** Most recently, we've been stepping
**[00:09:28]** up our enterprise security.
**[00:09:30]** So, generally available today is data encryption
**[00:09:33]** with customer-managed keys when your data is at rest.
**[00:09:36]** We also have diagnostic logs with immutable storage,
**[00:09:39]** so you can see and debug everything that's happening
**[00:09:41]** within your entire data lake.
**[00:09:44]** And network security has gotten a lot stronger.
**[00:09:46]** We now support workspace-level private links,
**[00:09:48]** outbound access protection, workspace firewall,
**[00:09:51]** and now very new is the ability to do resource instance rules
**[00:09:54]** and specify specific Azure services that allow
**[00:09:57]** to connect to your data.
**[00:09:59]** You can learn more with the Fabric Security White Paper.
**[00:10:03]** Let's look at a quick demo of all the storage improvements
**[00:10:05]** that we've just released.
**[00:10:07]** SPEAKER 1: Let's take a look at some
**[00:10:08]** of the new OneLake storage features,
**[00:10:10]** starting here in this workspace.
**[00:10:12]** It's busy, it's real, and it looks
**[00:10:15]** like what most teams run in production.
**[00:10:17]** This is exactly where OneLake shines
**[00:10:19]** because all your data is together in one place,
**[00:10:21]** making it easy to manage things like cost and security
**[00:10:24]** without managing separate systems.
**[00:10:26]** One easy way to see how everything comes together is
**[00:10:29]** through an experience many of you already know,
**[00:10:31]** Windows File Explorer.
**[00:10:33]** With the OneLake File Explorer application,
**[00:10:35]** you can see everything in this workspace
**[00:10:37]** across all these different item types.
**[00:10:40]** They show up as folders and files
**[00:10:42]** in a single, consistent view.
**[00:10:43]** From here, I can bring data in by dragging files,
**[00:10:47]** or I could be using OneLake APIs or Connect ingestion tools.
**[00:10:51]** I'm not provisioning a storage account.
**[00:10:53]** I'm not setting up infrastructure first.
**[00:10:56]** I'm just putting data where it belongs.
**[00:11:00]** Now that my team has been running on Fabric for a while,
**[00:11:02]** storage has been growing, and the question that keeps coming
**[00:11:05]** up is, what is driving that growth,
**[00:11:07]** and where is the cost coming from?
**[00:11:09]** To answer that, I'm excited
**[00:11:11]** to show the new OneLake Storage Report for this workspace.
**[00:11:14]** Now instead of guessing, you can see item-level storage.
**[00:11:18]** You can immediately spot which items are driving the majority
**[00:11:21]** of your storage footprint.
**[00:11:22]** It's easy to understand what is in the total, including things
**[00:11:25]** that aren't always top-of-mind, like soft-deleted data
**[00:11:28]** and system folders used by workloads for logs,
**[00:11:31]** metadata, and temporary data.
**[00:11:33]** I can clearly see I have a lake house
**[00:11:35]** that contains 4TB of bronze data.
**[00:11:38]** I know I need to keep it for compliance reasons,
**[00:11:40]** but we rarely touch it after the first few days.
**[00:11:42]** That is a very common pattern at scale.
**[00:11:45]** But what if you could keep the data,
**[00:11:46]** but lower your storage cost?
**[00:11:48]** This is where the new OneLake storage tiers
**[00:11:51]** and lifecycle management policies really make
**[00:11:54]** a difference.
**[00:11:55]** You can automatically move infrequently-used data into cool
**[00:11:58]** or cold tiers so you save on storage costs,
**[00:12:01]** and you pay higher transaction prices only
**[00:12:04]** when you actually access that data.
**[00:12:06]** OneLake makes this easy by providing default tiering rules,
**[00:12:10]** and I can customize these rules if needed.
**[00:12:12]** So, now that you can see where storage is going,
**[00:12:15]** you can act on it in the same place
**[00:12:17]** without building separate lifecycle tooling.
**[00:12:20]** Putting your data in OneLake also brings together all your
**[00:12:24]** management capabilities in one place,
**[00:12:26]** and cost control is just one part of the story.
**[00:12:30]** OneLake includes enterprise-grade features
**[00:12:32]** like diagnostics events, which capture
**[00:12:35]** who accesses your OneLake data and can even make it immutable.
**[00:12:39]** You can set network protection rules,
**[00:12:41]** and you can use encryption with customer-managed keys.
**[00:12:44]** Everything is there for you to manage your data end to end.
**[00:12:48]** JOSH CAPLAN: That demo shows some of the recent improvements
**[00:12:50]** that we've just released.
**[00:12:51]** Let's do a little recap.
**[00:12:53]** The OneLake File Explorer is now generally available along
**[00:12:56]** with the OneLake MCP.
**[00:12:59]** In public preview now is a new item size reporting,
**[00:13:01]** and probably our biggest announcement,
**[00:13:02]** life cycle management with data tiering is now available.
**[00:13:11]** Those are all the great new improvements we've done
**[00:13:12]** for physically storing data in OneLake.
**[00:13:15]** Let's look at all the improvements we've done
**[00:13:17]** for connecting your existing data estate.
**[00:13:19]** For that, I'm going to bring Wee Hyong up here.
**[00:13:22]** WEE HYONG TOK: Thank you, Josh.
**[00:13:24]** Now in this section, we're going
**[00:13:25]** to cover how you could unify your data estate
**[00:13:27]** with shortcut and mirroring.
**[00:13:29]** Now, shortcuts are super cool.
**[00:13:31]** It allows you to connect to your data wherever it is.
**[00:13:35]** More importantly, there's no data movement,
**[00:13:37]** and you could use shortcut to connect data
**[00:13:39]** that is on-premises or in any cloud.
**[00:13:43]** While mirroring, on the other hand,
**[00:13:45]** allows you to bring your entire data catalog into OneLake.
**[00:13:49]** And if you're connecting to some of these data sources
**[00:13:52]** like Oracle, SQL Server, whether it's on-premises, in the cloud,
**[00:13:55]** it leverages the underlying change data capture capability
**[00:13:59]** to make sure that you have an up-to-date mirrored database.
**[00:14:03]** Now, shortcut and mirroring combined are super cool
**[00:14:06]** and it's allowing you to unify your data estate into OneLake.
**[00:14:13]** Now, since we shipped shortcut and mirroring a while ago,
**[00:14:17]** we're so excited that now there's lots
**[00:14:19]** of data sources that's generally available.
**[00:14:21]** Now whether it's a SQL family or product from SQL Server 25,
**[00:14:25]** to on-premises SQL Server and many, many more.
**[00:14:29]** At the same time, shortcut and mirroring allows you to connect
**[00:14:31]** to data sources like Snowflake, Oracle Database, SAP Datasphere,
**[00:14:37]** and more recently we brought shortcut and mirroring
**[00:14:39]** for SharePoint and OneDrive.
**[00:14:42]** Super exciting.
**[00:14:44]** Now, lots of these data sources are generally available,
**[00:14:48]** and you can leverage them in order for you to bring all
**[00:14:50]** of this data, whether it's with data movement
**[00:14:53]** or no data movement, into OneLake
**[00:14:55]** for all your analytics needs.
**[00:14:58]** Now, today, lots more are in public preview.
**[00:15:01]** We're so excited to share some of these new data sources,
**[00:15:04]** including support for DreamView, Azure Monitor, and soon,
**[00:15:08]** coming soon, support for AWS Group.
**[00:15:11]** Now, one of the top customer asks
**[00:15:14]** for mirroring is really the support
**[00:15:15]** for Workspace Private Link.
**[00:15:18]** Now, with mirroring support for Workspace Private Link,
**[00:15:21]** it allows you to bring private link network security
**[00:15:24]** to your mirrored database.
**[00:15:26]** But more importantly, all your traffic is routed
**[00:15:28]** through Microsoft Private Network
**[00:15:30]** and not the public internet.
**[00:15:32]** Now this has been one of the top customer asks
**[00:15:34]** for mirrored database for a while and we're so excited
**[00:15:37]** to bring this to public preview today.
**[00:15:40]** Now today, mirroring support
**[00:15:41]** for Workspace Private Link includes support
**[00:15:43]** for Azure Cosmos DB, Azure SQL Managed Instance,
**[00:15:48]** which is SQL MI, as well as SQL Server 2025.
**[00:15:51]** Now, we can't wait to see how you will use Mirrored Database
**[00:15:55]** with Workspace Private Link,
**[00:15:56]** and lots more data sources are coming.
**[00:16:00]** Now, next we're going to talk about shortcut transformation.
**[00:16:03]** Now, shortcut transformation are super cool, and it allows you
**[00:16:06]** to enrich your data with native AI capabilities in OneLake.
**[00:16:11]** Today, this is generally available,
**[00:16:13]** and what it enables you to do is you can point
**[00:16:16]** to source folders that's on OneLake
**[00:16:18]** and start adding defined AI transformation.
**[00:16:22]** And it will continuously auto-track the changes
**[00:16:25]** in the source and sync this with the destination
**[00:16:27]** and enriching the data with native AI at the same time.
**[00:16:32]** Now, we're super excited to share some
**[00:16:33]** of these new improvements to shortcut transformation,
**[00:16:37]** including the ability for you to preview and define schemas,
**[00:16:41]** one of the top customer asks as well,
**[00:16:43]** and to manage your transformation
**[00:16:45]** with detailed logs so that you can understand what is happening
**[00:16:49]** underneath the hood with enhanced monitoring.
**[00:16:52]** Now, if you have not checked out shortcut transformation yet,
**[00:16:55]** I encourage you to check it out.
**[00:16:58]** Now, this just shows you at a glance all the kind
**[00:17:00]** of shortcut transformation that's possible,
**[00:17:02]** whether it's converting formats like from Parquet to Table,
**[00:17:06]** Excel to Table, and many, many more, or enriching your data
**[00:17:09]** with AI, whether it's PII detection,
**[00:17:13]** whether it's translation, whether it's providing a summary
**[00:17:16]** of your text, sentiment analysis,
**[00:17:18]** name recognition, and many, many more.
**[00:17:21]** We can't wait to see how you're going
**[00:17:23]** to use shortcut transformation.
**[00:17:25]** And with that, let us see a demo of, you know, what does it mean
**[00:17:29]** to get to a OneLake unified estate?
**[00:17:31]** Let us play the demo.
**[00:17:33]** SPEAKER 2: I start in Fabric with a very basic task flow.
**[00:17:36]** I store some data, analyze and visualize it,
**[00:17:39]** and then I set up some alerting.
**[00:17:40]** Now, let me show you why this is such a basic architecture.
**[00:17:44]** Take a look at my lake house.
**[00:17:45]** All shortcuts to several different sources.
**[00:17:47]** Most are databases.
**[00:17:49]** But let's be honest, not all your critical data lives
**[00:17:52]** in a database.
**[00:17:53]** Some of it lives, duh duh dunhhh, in a SharePoint list.
**[00:17:56]** I see some of you nudging your coworkers right now.
**[00:17:59]** Yeah, I'm talking to you.
**[00:18:00]** So, I work for Zava, and Zava is opening 15 new stores
**[00:18:04]** this quarter.
**[00:18:05]** Some in Atlanta, Chicago, Seattle, Miami,
**[00:18:07]** all across the country.
**[00:18:09]** And how does the ops team track every store's readiness,
**[00:18:12]** staffing, build-out status?
**[00:18:14]** In a SharePoint list.
**[00:18:15]** And honestly, it's the right tool for this.
**[00:18:17]** Collaborative, accessible, the whole team lives there.
**[00:18:21]** But the problem is, how do I get the data out?
**[00:18:24]** You know, how do I get the data where I can analyze it?
**[00:18:26]** This means exports, CSV files, maybe some Power Automate
**[00:18:30]** if someone is feeling particularly heroic on a Friday.
**[00:18:33]** But today we are announcing SharePoint list mirroring.
**[00:18:37]** To get started is simple, like any other mirroring.
**[00:18:39]** So what you want to do is first you create a mirrored SharePoint
**[00:18:42]** online list item.
**[00:18:44]** Enter the URL for your site or select an existing connection.
**[00:18:48]** Then, select your list from the available data.
**[00:18:51]** You can also have it automatically mirror
**[00:18:53]** future tables.
**[00:18:54]** I'm not going to do that for now.
**[00:18:56]** Just click "Connect".
**[00:18:57]** Finally, name your mirror item and click the "Create" button.
**[00:19:00]** After a few moments, the item is created and the mirror starts.
**[00:19:04]** See, 195 rows already replicated.
**[00:19:08]** Now, let's jump to my lake house.
**[00:19:10]** Remember, this is a minimal and low-code approach.
**[00:19:13]** Instead of pipelines and notebooks, I create a shortcut
**[00:19:16]** to the SharePoint list that's mirrored in my mirrored item,
**[00:19:20]** and the data is available in my lake house.
**[00:19:22]** No pipeline, no copy job, it just shows up.
**[00:19:25]** Now, here's where it gets really interesting.
**[00:19:27]** That same Zava team also has an Excel workbook,
**[00:19:30]** the Regional Budget and Forecast.
**[00:19:33]** Build-out costs, market and spend,
**[00:19:35]** projected revenue per store, all stored in the Excel workbook.
**[00:19:38]** You know this file.
**[00:19:39]** Every organization has it.
**[00:19:41]** It's where half the company's decisions actually get made.
**[00:19:44]** Critical business data living in a spreadsheet.
**[00:19:46]** But today, I've been waiting to show you this.
**[00:19:49]** Starting today, Excel shortcuts in OneLake.
**[00:19:52]** Watch what that means.
**[00:19:53]** You create an Excel shortcut like any other shortcut.
**[00:19:55]** What's the difference is
**[00:19:56]** that Fabric detects it's an Excel file.
**[00:20:00]** You have options at this point.
**[00:20:01]** I'm simply going to enter the sheet number,
**[00:20:04]** accept the other defaults, and click "Next".
**[00:20:06]** Then you give it a shortcut name,
**[00:20:08]** and then the magic happens.
**[00:20:09]** No notebooks, no data flows, no data engineering required.
**[00:20:13]** Every sheet becomes a first-class table
**[00:20:15]** in your lakehouse.
**[00:20:16]** Two sources, one lakehouse, zero friction.
**[00:20:20]** Now let me show you why this matters.
**[00:20:21]** Let's go look at the Power BI report built
**[00:20:23]** on top of this lakehouse.
**[00:20:24]** Look at this.
**[00:20:25]** I've got store readiness
**[00:20:27]** and staffing percentages all in one report.
**[00:20:29]** SharePoint list data sitting right next
**[00:20:31]** to Excel workbook data, visualized together
**[00:20:33]** like they were always meant to be.
**[00:20:36]** This is the single pane of glass everyone's been asking for.
**[00:20:39]** But here's the thing.
**[00:20:40]** A report is only as good as the data behind it.
**[00:20:42]** And we all know data changes constantly.
**[00:20:44]** So let's put this to a real test.
**[00:20:46]** Let's say the Chicago store just finished hiring.
**[00:20:49]** The regional manager updates the staffing numbers right here
**[00:20:52]** in Excel, the two they already know and love.
**[00:20:54]** I'm going to bump Chicago staffing up.
**[00:20:56]** Done. No ceremony.
**[00:20:57]** No special processes.
**[00:20:58]** Just a normal Tuesday for the Ops Team.
**[00:21:01]** Now, the store manager sees that staffing is complete,
**[00:21:03]** so they hop into the SharePoint list,
**[00:21:05]** the same list the whole team has been living in,
**[00:21:07]** and they update Chicago status to ready to open, staffing 100%.
**[00:21:12]** Two different people,
**[00:21:13]** two different tools updating the same story
**[00:21:15]** from different angles.
**[00:21:16]** This is how work actually happens in organizations.
**[00:21:19]** Nobody stopped to think about data pipelines.
**[00:21:21]** Nobody filed a ticket with IT.
**[00:21:23]** They just did their jobs.
**[00:21:25]** Now watch this.
**[00:21:26]** I go back to the report, hit "Refresh", and there it is.
**[00:21:29]** Chicago, ready to open, fully staffed, budget on track,
**[00:21:32]** the Excel data flowed through,
**[00:21:34]** the SharePoint list data flowed through, everything landed
**[00:21:36]** in the lakehouse and lit up the report.
**[00:21:38]** No CSV files, no Power Automate workflows,
**[00:21:41]** no Friday afternoon heroics.
**[00:21:43]** This is what it looks like when your entire data estate
**[00:21:46]** just works.
**[00:21:47]** SharePoint lists, Excel workbooks, databases,
**[00:21:50]** all flowing into one lakehouse, all powering one set of reports.
**[00:21:53]** The tools your team already uses now connected
**[00:21:56]** to the analytics platform that drives decisions.
**[00:21:58]** That's the power of Microsoft Fabric.
**[00:22:01]** WEE HYONG TOK: The super exciting demo
**[00:22:02]** that you just seen, we can't wait
**[00:22:04]** to see how you use shortcut transformation.
**[00:22:06]** And now I'm going to hand it back to Josh
**[00:22:09]** to continue the rest of the presentation.
**[00:22:11]** Back to you, Josh.
**[00:22:12]** JOSH CAPLAN: Awesome.
**[00:22:12]** Thank you, Wee Hyong.
**[00:22:14]** So we've unified our entire data estate.
**[00:22:17]** Let's move on to the next pillar, open access.
**[00:22:22]** Remember, we've broken down those silos,
**[00:22:24]** we've brought everything into a single logical lake.
**[00:22:26]** Now, we unify for a purpose.
**[00:22:28]** We bring data together so that we can use it
**[00:22:31]** in lots and lots of places.
**[00:22:34]** All data in OneLake is available throughout the entire
**[00:22:37]** Microsoft ecosystem.
**[00:22:39]** We have deep integrations with products like Foundry, Power BI,
**[00:22:43]** Office, and Excel, as well as Copilot.
**[00:22:47]** But these integrations extend well beyond Microsoft.
**[00:22:50]** This data can be used with dozens of services outside
**[00:22:54]** of Microsoft, including Databricks,
**[00:22:56]** Snowflake, and Salesforce.
**[00:23:00]** Now, a key principle of OneLake is what we call one copy.
**[00:23:04]** One copy is the principle that you can use one copy of data
**[00:23:06]** across multiple engines.
**[00:23:08]** This separates the decision of how you want
**[00:23:10]** to create your data, how you want to create your lake,
**[00:23:12]** from how you want to consume it.
**[00:23:13]** You can have a team that prefers to use stored procedures
**[00:23:15]** in T-SQL to build a data warehouse.
**[00:23:18]** Or you can have a team that prefers to use Python
**[00:23:20]** and notebooks to build a lakehouse.
**[00:23:22]** It all ends up as data in OneLake that can be consumed
**[00:23:25]** by any engine to look at that data.
**[00:23:28]** That data can be consumed within Fabric, Databricks,
**[00:23:31]** or anywhere that can read an open data format.
**[00:23:36]** So, we've always shared data through OneLake.
**[00:23:38]** Recently, we released the OneLake Table API
**[00:23:40]** to make sharing of metadata even easier.
**[00:23:43]** OneLake now exposes the same opensource APIs
**[00:23:46]** for both Delta Lake and Iceberg natively as part of OneLake.
**[00:23:51]** So any application like Snowflake, like Databricks,
**[00:23:55]** that knows how to work with at least one
**[00:23:56]** of those formats can read all, and I mean all,
**[00:23:59]** data that's available within OneLake, no matter how
**[00:24:01]** that data was written, no matter what format that data is in,
**[00:24:05]** it can be used with any Iceberg
**[00:24:06]** or Delta lake-compliant application now using these
**[00:24:09]** Table APIs.
**[00:24:14]** We have some new announcements on the Table APIs.
**[00:24:16]** Generally available has been the ability to read metadata
**[00:24:20]** through the Table APIs.
**[00:24:21]** And now we're announcing the ability to write metadata,
**[00:24:25]** create tables, create schemas,
**[00:24:27]** update or publish transactions now through the Table API.
**[00:24:31]** This is available today.
**[00:24:37]** OneLake is available not just through a set of APIs.
**[00:24:39]** It's deeply integrated into all the Microsoft ecosystem.
**[00:24:43]** So there are dedicated experiences
**[00:24:44]** with Microsoft Foundry, within Excel, within SharePoint,
**[00:24:48]** where you can see this data and use it directly.
**[00:24:51]** OneLake data literally is everywhere.
**[00:24:57]** And OneLake data is everywhere for AI.
**[00:25:00]** OneLake is your AI-ready data lake.
**[00:25:03]** It turns out when we free data from those silos,
**[00:25:06]** data wasn't the only thing that was stuck inside.
**[00:25:09]** It was also the knowledge,
**[00:25:10]** the context that went along with that data.
**[00:25:13]** Different people working
**[00:25:14]** in different organizations had this context in their heads
**[00:25:17]** and stayed within those silos.
**[00:25:20]** This is where Microsoft IQ and Fabric IQ come in.
**[00:25:23]** It lets you free the data from those silos,
**[00:25:26]** encapsulate that context along with the data
**[00:25:30]** and unify it all in OneLake.
**[00:25:32]** Once all together, data and context in OneLake,
**[00:25:35]** you can distribute both to all the data
**[00:25:37]** and applications that need it.
**[00:25:39]** So no longer are you just getting data,
**[00:25:41]** you're getting data with the knowledge to help best work
**[00:25:44]** with that data and empowering your agents.
**[00:25:47]** It's OneLake that spans all databases, all clouds,
**[00:25:50]** and it has the semantic models
**[00:25:51]** to bring your analytical intelligence.
**[00:25:53]** It has the ontologies to bring your operational intelligence.
**[00:25:56]** It really is the best source of knowledge
**[00:25:58]** to ground your AI applications.
**[00:26:01]** To tell us more about this, I'm going to bring up Miquella here.
**[00:26:05]** Miquella de Boer: Thank you, Josh.
**[00:26:07]** So as Josh mentioned, OneLake already brings together unified
**[00:26:10]** data, business intelligence, and operational intelligence.
**[00:26:14]** But what is new is that we're now making that data usable
**[00:26:16]** across a full set of AI consumers, from Fabric
**[00:26:19]** and Foundry, to Copilot Studio and Partner Tools.
**[00:26:23]** When we make this data available
**[00:26:25]** through all these AI experiences,
**[00:26:26]** this data is actually never copied, but it's made available
**[00:26:29]** through a common data foundation with shared context
**[00:26:32]** and intelligence on top of it.
**[00:26:34]** But a lot of enterprise data is actually not
**[00:26:36]** in structured tables.
**[00:26:38]** It lives in documents, PDFs, and SharePoint sites.
**[00:26:41]** For example, think of customer conversations,
**[00:26:43]** contracts, and invoices.
**[00:26:45]** This data is extremely valuable for AI.
**[00:26:49]** Using OneLake, you can unify both your structured
**[00:26:51]** and unstructured data all in one place, and with support
**[00:26:56]** from many different sources like SharePoint and Amazon S3,
**[00:27:00]** all without data replication.
**[00:27:02]** And to make this even more useful,
**[00:27:04]** we're bringing the OneLake catalog natively integrated
**[00:27:08]** into Foundry.
**[00:27:09]** You can now discover all of your trusted enterprise data
**[00:27:12]** into one place, and immediately use it inside of knowledge
**[00:27:16]** and agents and in any of your AI workloads.
**[00:27:19]** It contains the full capabilities
**[00:27:21]** of the OneLake catalog for discoverability.
**[00:27:23]** Think of sensitivity labels and endorsements.
**[00:27:26]** This creates a consistent view of data
**[00:27:28]** across your entire estate of analytics and AI
**[00:27:31]** by having it available across Fabric and Foundry.
**[00:27:34]** So now let me actually show you what this looks
**[00:27:36]** like for enterprise unstructured data.
**[00:27:40]** Most organizations already have a huge amount
**[00:27:42]** of valuable unstructured data sitting in SharePoint.
**[00:27:45]** That includes business documents, PDFs,
**[00:27:47]** and of course Excel files.
**[00:27:49]** The challenge is that this content often contains some
**[00:27:52]** of the most important business context,
**[00:27:55]** but it's usually disconnected from analytics and AI.
**[00:27:58]** Now, moving over to my lakehouse in Microsoft Fabric,
**[00:28:01]** I can bring all of the data together in OneLake.
**[00:28:04]** Here, my unstructured SharePoint files can live alongside my
**[00:28:07]** structured data.
**[00:28:08]** And because I'm using OneLake shortcuts,
**[00:28:11]** the files are virtualized into place.
**[00:28:13]** There is no copy, no data movement,
**[00:28:15]** and no extra duplication to manage.
**[00:28:17]** I can also unify this with data from other sources,
**[00:28:20]** including multicloud data from S3 NetApp files
**[00:28:23]** that are network protected, or from Azure Blob Storage,
**[00:28:26]** where I have my customer support transcripts.
**[00:28:29]** So instead of creating another data silo,
**[00:28:32]** OneLake gives me one logical data layer
**[00:28:34]** across my organization's data.
**[00:28:37]** Now, I want to use this data to build an AI agent.
**[00:28:40]** In Microsoft AI Foundry, I can use knowledge
**[00:28:43]** to index this context and make it available for grounding.
**[00:28:47]** This indexing step is important because it turns raw files
**[00:28:50]** into searchable, retrievable knowledge that the agent can use
**[00:28:53]** to answer questions with the right business context.
**[00:28:57]** As part of Foundry knowledge,
**[00:28:59]** OneLake catalog is natively integrated.
**[00:29:01]** Here, I can search across available data,
**[00:29:04]** see what has been endorsed in my organization, and use signals
**[00:29:08]** like sensitivity labels to understand
**[00:29:10]** which data is trusted and ready to use.
**[00:29:13]** This lakehouse is promoted, so I know it is intended
**[00:29:16]** for broader use and is ready to power AI experiences.
**[00:29:20]** From here, I can directly add this OneLake knowledge source
**[00:29:23]** to my agent.
**[00:29:24]** And now I can start asking business questions like,
**[00:29:26]** "What are my best-selling products
**[00:29:28]** and how can I improve my sales?"
**[00:29:30]** That is the value of bringing OneLake Fabric
**[00:29:32]** and Foundry together.
**[00:29:33]** You can connect to business data where it already lives,
**[00:29:36]** unify structured and unstructured data
**[00:29:39]** without copying it, discover trusted data
**[00:29:41]** through the OneLake catalog, and use it natively in Foundry
**[00:29:44]** to build grounded AI agents.
**[00:29:47]** So this was a quick demo
**[00:29:48]** of how you can unify both Fabric and Foundry together.
**[00:29:51]** Back to you, Josh.
**[00:29:53]** JOSH CAPLAN: Thanks, Miquella.
**[00:29:54]** So remember, we've unified our entire data estate,
**[00:29:56]** and we unified for a purpose, so we can access it
**[00:29:59]** from anywhere, including AI.
**[00:30:01]** Now, to access from anywhere,
**[00:30:03]** we need to secure and govern that data.
**[00:30:08]** OneLake security is now generally available,
**[00:30:11]** and OneLake security really changes the game here.
**[00:30:14]** We went for a world where the most capable security was
**[00:30:17]** at the edges.
**[00:30:18]** It was in our presentation layers,
**[00:30:20]** it was in our database engines, and we had different security
**[00:30:26]** for every single engine.
**[00:30:28]** Now, we've unified all our data in the lake and we're able
**[00:30:31]** to use one copy of data across multiple engines.
**[00:30:34]** We need to do the same with our security,
**[00:30:36]** and that's what OneLake security does.
**[00:30:37]** It takes all the engine-specific capabilities
**[00:30:40]** like role-level security, column-level security,
**[00:30:43]** and moves it down to the data lake,
**[00:30:44]** so that now you can define your security definitions once.
**[00:30:48]** Those security definitions now live with the data in the lake
**[00:30:51]** and are enforced everywhere that data is used,
**[00:30:54]** no matter which engine you use it in.
**[00:30:56]** This is the power of OneLake security.
**[00:31:01]** Let's look at OneLake security in action.
**[00:31:04]** SPEAKER 3: Let's look at how Zava can use OneLake security
**[00:31:06]** to secure their data once
**[00:31:07]** and have it be enforced consistently throughout Fabric.
**[00:31:10]** Sarah is the platform admin and is looking
**[00:31:12]** to consolidate Zava's sales data into OneLake.
**[00:31:15]** She starts by setting up a mirrored database
**[00:31:17]** to pull the customers and sales data into OneLake.
**[00:31:21]** Now that the data is in OneLake,
**[00:31:22]** she can create OneLake security roles to control access
**[00:31:25]** to the sensitive data.
**[00:31:26]** She starts by creating a role for the business users.
**[00:31:29]** She calls the role non-PII and chooses the tables to include.
**[00:31:33]** She then configures CLS to remove email and phone
**[00:31:36]** from the customers table.
**[00:31:38]** She adds Patrick as a member and saves it.
**[00:31:41]** For the data science team,
**[00:31:42]** she creates another role called Data Science NoteU,
**[00:31:45]** which allows the PII data but restricts access to the EU rows
**[00:31:49]** for compliance reasons.
**[00:31:51]** Both Diego and Priya are members of this role.
**[00:31:56]** With the roles created, Priya, a data scientist at Zava,
**[00:31:59]** can now access this data from the Zava Analytics Workspace.
**[00:32:02]** She first verifies that the data she needs is available using the
**[00:32:05]** SQL endpoint.
**[00:32:06]** A quick query confirms the tables are reachable
**[00:32:09]** and that her identity is being honored.
**[00:32:10]** She sees only her allowed rows.
**[00:32:13]** Priya then pulls the data into her own lakehouse
**[00:32:15]** by creating shortcuts to the Zava DB.
**[00:32:18]** She then queries it using Spark, joining the sales
**[00:32:20]** and customer tables to analyze the results.
**[00:32:23]** Notice that the EU rows are restricted seamlessly,
**[00:32:26]** keeping the data secure while allowing Priya
**[00:32:28]** to use the data for machine learning.
**[00:32:31]** Diego is a sales manager and needs to create a semantic model
**[00:32:35]** for business users to consume the sales data.
**[00:32:37]** He builds a semantic model directly
**[00:32:39]** over the mirrored tables using direct link mode.
**[00:32:42]** The important part happens behind the scenes.
**[00:32:44]** The OneLake security roles defined by Sarah are pulled
**[00:32:46]** into the model automatically.
**[00:32:49]** Next, Diego goes to create reports for his team
**[00:32:52]** over the semantic model using Power BI.
**[00:32:54]** He creates a table of the customers
**[00:32:56]** and their order amounts, and then pulls in a chart
**[00:32:58]** for sales amounts over time.
**[00:33:00]** Notice that the order table automatically hides the EU
**[00:33:02]** customers from him since Diego is a member of the no EU role.
**[00:33:07]** Patrick is a business analyst on the same team as Diego.
**[00:33:10]** He uses the OneLake catalog to find the report Diego built.
**[00:33:14]** He opens the report to check on some orders,
**[00:33:15]** but notices that the sales table is disabled.
**[00:33:18]** This is because he is in the non-PII role
**[00:33:20]** and can't view the customer phone number.
**[00:33:23]** He prefers to do analysis in Excel anyways,
**[00:33:25]** so he again uses the OneLake catalog
**[00:33:27]** to find the semantic model and analyze it in Excel.
**[00:33:30]** But just like with the report itself,
**[00:33:32]** OneLake security automatically hides the PII columns from him.
**[00:33:35]** He can still interact with the model and build the pivot table,
**[00:33:38]** but OneLake security keeps the sensitive columns hidden.
**[00:33:41]** That's the promise of OneLake security.
**[00:33:43]** Secure your data once and have it be enforced everywhere.
**[00:33:46]** JOSH CAPLAN: That's a great demo.
**[00:33:47]** I want to announce the public preview
**[00:33:50]** of OneLake security for Eventhouse.
**[00:33:53]** This joins the already existing engines within Fabric
**[00:33:56]** that can have OneLake security enforced across the board.
**[00:33:59]** OneLake security is part of the OneLake catalog,
**[00:34:02]** which makes up the final piece of OneLake.
**[00:34:05]** OneLake catalog exposes all this data for discovery
**[00:34:09]** and governance, and is trusted
**[00:34:11]** by over 240,000 organizations worldwide.
**[00:34:14]** To learn more about the OneLake catalog,
**[00:34:16]** check out the session from Kim Manis.
**[00:34:19]** And to learn more about OneLake,
**[00:34:21]** please check out the links below.
**[00:34:24]** Thank you for your time today.
**[00:34:26]** I hope you've learned a lot about OneLake and you feel ready
**[00:34:28]** to bring your data and build the single, unified data lake
**[00:34:31]** for your entire organization.
