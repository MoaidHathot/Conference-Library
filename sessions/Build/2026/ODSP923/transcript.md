**[00:00:01]** JASON BERES: Today, we're going to talk
**[00:00:01]** about creating enterprise apps with AI, MCP, a little bit
**[00:00:05]** of low-code but not a lot of coding, because with AI,
**[00:00:08]** we can do a lot with very little effort nowadays.
**[00:00:11]** My name is Jason Beres.
**[00:00:12]** My email, jasonb@infragistics.com.
**[00:00:16]** And you can learn about everything we're going to talk
**[00:00:18]** about today at infragistics.com.
**[00:00:21]** So what are we going to talk about?
**[00:00:23]** Primarily, how you can build amazing experiences
**[00:00:26]** for any platform using Infragistics UI components.
**[00:00:29]** We've been doing this for over 35 years for every platform
**[00:00:33]** from the late '80s to the '90s to the 2000s,
**[00:00:36]** all the way through almost now to 2030: Desktop, Mobile, WPF,
**[00:00:40]** WinUI, MAUI, Windows Forms, and then modern web with Blazor,
**[00:00:44]** Angular, React, and Web Components.
**[00:00:46]** I'm going to show you today how you can just accelerate building
**[00:00:49]** out some of these amazing experiences
**[00:00:51]** that your customers expect using our tooling.
**[00:00:54]** So we're going to look at a little bit of AI with Copilot.
**[00:00:57]** We're going to look at some low-code
**[00:00:58]** with our App Builder product and how
**[00:01:00]** to use some command-line tools.
**[00:01:02]** Mostly, we're going to stick with demo,
**[00:01:04]** and then we'll go into next steps.
**[00:01:06]** So here's a few screenshots.
**[00:01:08]** Many enterprise applications built
**[00:01:10]** for the web today not only have your typical navigation,
**[00:01:14]** calendaring, charting, but data grids.
**[00:01:16]** Data grids end up being a very big part
**[00:01:18]** of most enterprise web applications
**[00:01:21]** and most SaaS apps with Infragistics.
**[00:01:23]** That's been our claim to fame for decades.
**[00:01:25]** So if you're building for Blazor or Windows Forms,
**[00:01:28]** you need dozens of really rich interactions available
**[00:01:32]** to you in that data grid.
**[00:01:33]** These screenshots have a few examples,
**[00:01:35]** but also just some good-looking applications
**[00:01:38]** with different themes and styles that you can apply
**[00:01:40]** across our components.
**[00:01:42]** And I'm going to give you a little taste
**[00:01:44]** of this in code demos today.
**[00:01:46]** And then for the desktop,
**[00:01:47]** we have not left the desktop behind.
**[00:01:49]** We still do a lot of work on Windows Forms and WPF.
**[00:01:53]** But now we're happy to announce
**[00:01:55]** at Build 2026 our brand new WinUI component suite.
**[00:01:59]** This mirrors much of the experience that you get
**[00:02:03]** in our WPF components.
**[00:02:05]** So rich components like data grids, data charts,
**[00:02:07]** geospatial maps, inputs, and more are
**[00:02:10]** in our new WinUI component set.
**[00:02:13]** And following shortly after this is MAUI,
**[00:02:15]** with our cross-platform story with those same components
**[00:02:19]** that now you can build Android applications, iPad applications,
**[00:02:22]** and desktop applications.
**[00:02:24]** So we give you components on any platform to build any type
**[00:02:28]** of experience that you need to deliver.
**[00:02:30]** So let's jump into a demo so you can see how
**[00:02:32]** to start putting this together.
**[00:02:34]** First, I'm just going to start
**[00:02:35]** at the infragistics.com homepage.
**[00:02:37]** I just want to highlight you can learn
**[00:02:39]** about our UI components here.
**[00:02:41]** We also have an embedded analytics SDK called Reveal,
**[00:02:45]** and we have a growth GTM platform, AI-native,
**[00:02:48]** AI-first work management tool called Slingshot.
**[00:02:52]** From our main menu, you can jump to any of the homepages
**[00:02:55]** for any of our products.
**[00:02:56]** I'll jump over to Ignite UI.
**[00:02:58]** And I just want to highlight again that with Ignite UI,
**[00:03:01]** which is our modern web tool set, we have Angular, Blazor,
**[00:03:04]** React, and Web Components.
**[00:03:05]** The way that we build components is each platform has the exact
**[00:03:09]** same components with the same APIs and the same feature set.
**[00:03:13]** So you don't have to choose one versus the other
**[00:03:16]** to get a specific component.
**[00:03:18]** If you think you're going to use React, and you're kind
**[00:03:21]** of trialing our React components,
**[00:03:23]** and then you decide we're going to go Blazor, great.
**[00:03:24]** Same things are available on Blazor.
**[00:03:26]** And basically, we ship everything you need
**[00:03:28]** to build high-performance web apps on your platform of choice.
**[00:03:32]** The easiest way to get started is using App Builder,
**[00:03:36]** which is our low-code WYSIWYG development platform.
**[00:03:39]** We've also injected AI into App Builder over the last 18 months.
**[00:03:42]** So you can actually use a conversational AI interface
**[00:03:46]** or a WYSIWYG drag-and-drop to build out apps.
**[00:03:49]** This is a super easy way to get started with our components,
**[00:03:52]** but still you can use our CLI.
**[00:03:54]** You can start in Visual Studio Code or Visual Studio.
**[00:03:57]** It doesn't really matter.
**[00:03:58]** Cursor, Windsurf, etc. But if I click "Sign In," I would go
**[00:04:02]** through my Office 365 login, and I would end up here
**[00:04:05]** at my App Builder workbench.
**[00:04:07]** You can start with any of our sample apps
**[00:04:09]** or click "New Application," and you have a dialog
**[00:04:12]** which has a few other options.
**[00:04:14]** You can use empty templates to get started.
**[00:04:16]** You can go right from Figma to an application,
**[00:04:19]** choose a sample app, or you can start creating with AI.
**[00:04:23]** What I'm going to do is just grab a sample application here.
**[00:04:26]** I will click the "CRM App," and I end
**[00:04:29]** up here right inside of the WYSIWYG IDE.
**[00:04:32]** This is a single-page application builder.
**[00:04:35]** The UI should seem familiar to you.
**[00:04:37]** You've got views on the left-hand side.
**[00:04:39]** When I select items, my properties change
**[00:04:42]** on the right-hand side based on what those items are.
**[00:04:45]** I can move items around.
**[00:04:47]** I have options when I click and right-click.
**[00:04:49]** I can edit with AI.
**[00:04:51]** All kinds of great features here just
**[00:04:52]** to give you a beautiful WYSIWYG experience.
**[00:04:55]** When it's working with something like a data grid,
**[00:04:57]** data grids you may want to add additional features to.
**[00:05:00]** So, for example, for this grid, if I want to add Row actions,
**[00:05:04]** Exporting, our Grid toolbar, Column Moving, Pinning,
**[00:05:07]** Resizing, Hiding, maybe Outlook Group By,
**[00:05:10]** I can just simply click and those features are enabled.
**[00:05:14]** If I wanted to customize those, I could click on the element
**[00:05:17]** or property, and it would modify it.
**[00:05:19]** Over on the left-hand side, I've got my toolbox,
**[00:05:22]** which has our UI components.
**[00:05:24]** One important aspect of Ignite UI is we ship 50
**[00:05:28]** of our components as open source MIT.
**[00:05:31]** So you can get started for literally free
**[00:05:33]** with the majority of our components.
**[00:05:35]** You can bind to any type of data.
**[00:05:37]** You can have routing, navigation,
**[00:05:39]** variables, custom theming.
**[00:05:41]** So you can have any type
**[00:05:42]** of theme you want with a single click.
**[00:05:44]** You can even build out your own themes.
**[00:05:47]** As well, we ship with six default themes around Fluent,
**[00:05:51]** Bootstrap, Material, and Indigo.
**[00:05:53]** And then you have some digital assets if you need it,
**[00:05:56]** and then your conversational AI helper.
**[00:05:58]** So let me go over to the theme, and let's pick something like
**[00:06:01]** "Fluent Light," which looks good.
**[00:06:03]** I just want to go ahead and run this application just
**[00:06:05]** to see what it looks like.
**[00:06:06]** So you'll see I have my dashboard here.
**[00:06:08]** My navigation is all built in.
**[00:06:10]** Here is my data grids with all of those features
**[00:06:13]** that I have in my data grid.
**[00:06:15]** This is that nice Kanban view.
**[00:06:16]** This was the dashboard view that I had changed.
**[00:06:19]** Remember, I added those grid features.
**[00:06:21]** So now I have my Excel-style filter.
**[00:06:24]** I have my Outlook Group By, my toolbar with exporting options.
**[00:06:28]** But what's cool is, here on the right-hand side,
**[00:06:30]** you can see the code for the screen that you're looking at.
**[00:06:34]** So let's say, for example, I want to jump
**[00:06:36]** over to the "Customers" view.
**[00:06:38]** This is the C# code that's being generated.
**[00:06:41]** And this is the HTML and the Blazor components
**[00:06:45]** that are being injected and generated,
**[00:06:47]** the Infragistics Blazor components.
**[00:06:49]** Remember, I said you can use any platform.
**[00:06:51]** So let's look at React and not Blazor.
**[00:06:53]** So now I have the same thing in React.
**[00:06:55]** App Builder does give you a really amazing experience
**[00:06:58]** for WYSIWYG drag and drop, AI app development.
**[00:07:01]** It doesn't matter.
**[00:07:02]** But what I want to do is, if I look at some of the views here
**[00:07:06]** that have nothing, I'm going to delete this, and we're going
**[00:07:10]** to leave Tasks empty for now.
**[00:07:12]** I want to go to "Publish."
**[00:07:14]** Actually, first, let's change this over to "Blazor."
**[00:07:16]** Let's do a "Blazor server" app.
**[00:07:17]** It doesn't really matter.
**[00:07:19]** I'm going to call this "CRM App,"
**[00:07:21]** and we're going to say "Build 2026."
**[00:07:25]** And I'm going to copy that.
**[00:07:26]** And let's publish this to GitHub.
**[00:07:29]** I can publish to GitHub, Azure DevOps,
**[00:07:31]** or I can download a zip file.
**[00:07:33]** It doesn't really matter.
**[00:07:35]** So let's just make this GitHub repo look nice.
**[00:07:38]** I'm going to make this public.
**[00:07:40]** I'm going to create this repository.
**[00:07:41]** We also have features that allow you to build this
**[00:07:45]** out as an actual app to GitHub pages.
**[00:07:47]** I'm not going to do that.
**[00:07:48]** I'm just going to click "Publish."
**[00:07:50]** This is creating my application in the cloud,
**[00:07:52]** all of the code that's necessary.
**[00:07:54]** It says the app is created.
**[00:07:56]** And you can see if I drill into "CRMAppBuild2026,"
**[00:08:00]** all of those pages that we looked at are here.
**[00:08:02]** So here's the Tasks page that we're going to work with.
**[00:08:05]** If I look at my "Customers.razor,"
**[00:08:08]** this is all production-ready, amazing C# HTML code.
**[00:08:13]** No black box here.
**[00:08:14]** No garbage code.
**[00:08:16]** So let's just grab this.
**[00:08:17]** Grab our Git.
**[00:08:18]** Let me pop up Visual Studio Code.
**[00:08:20]** Let's clone this.
**[00:08:25]** And we'll just go to a default folder.
**[00:08:27]** Let's open this guy up.
**[00:08:28]** And we're ready to rock and roll.
**[00:08:30]** This is exactly what we just saw inside of GitHub.
**[00:08:33]** So what I want to do first is go to my terminal.
**[00:08:37]** And I want to get my MCP server installed.
**[00:08:39]** You'll notice here there is no mcp.json.
**[00:08:41]** So using the Infragistics Ignite UI CLI,
**[00:08:44]** which I do have installed already,
**[00:08:46]** I can just tell it to do an AI config.
**[00:08:50]** And it went ahead, and it added in my
**[00:08:52]** VS Code folder, my MCP servers.
**[00:08:55]** So here's the Ignite UI CLI, Ignite UI theming.
**[00:08:58]** Let's just go ahead and hit "Start."
**[00:09:01]** Now those guys are up and running.
**[00:09:02]** I'm going to right-click on my project,
**[00:09:04]** open it up in the integrated terminal.
**[00:09:07]** And I want to install my skills now.
**[00:09:09]** So Ignite UI has a CLI, it has a theming CLI,
**[00:09:12]** and then it has skills.
**[00:09:13]** And all of these together inform the agents on how
**[00:09:16]** to best build application with Ignite UI.
**[00:09:19]** So I'm going to say "GitHub skill install."
**[00:09:21]** And what do I want to install?
**[00:09:23]** "igniteui/igniteui-blazor."
**[00:09:27]** If I was working in Angular or React,
**[00:09:29]** I would do Angular or React.
**[00:09:31]** You hit "Enter."
**[00:09:32]** I'm going to scroll down, and I'm going to say "(all skills)."
**[00:09:35]** I'm going to do "GitHub Copilot" and "Claude Code."
**[00:09:38]** And we'll do it for this project.
**[00:09:39]** It downloaded, and now it installed all of my skills.
**[00:09:44]** So you can see I've got my Ignite UI Blazor components
**[00:09:47]** skill, my Blazor generate from image design,
**[00:09:51]** Blazor grids, Blazor theming.
**[00:09:53]** So I'm ready to rock and roll.
**[00:09:55]** So we can close this out.
**[00:09:56]** And we actually don't need this anymore.
**[00:09:59]** I'll make this a little bit bigger,
**[00:10:01]** and we can even ask Copilot, "Do you have the IgniteUI Theming,
**[00:10:07]** CLIMCP Servers & Skills available?"
**[00:10:13]** And you can see that it responded very quickly that,
**[00:10:16]** yep, I have everything need to help you build
**[00:10:20]** out your Ignite UI for Blazor application.
**[00:10:23]** So let's just do a ".NET run."
**[00:10:26]** We'll open this guy up.
**[00:10:27]** Let's open it up in the external browser, and we'll be able
**[00:10:31]** to see that we've got the beautiful application
**[00:10:34]** that we saw inside of App Builder.
**[00:10:36]** All of the features and capabilities
**[00:10:38]** that we expect are here.
**[00:10:39]** Here's that empty Tasks page,
**[00:10:42]** but you can see even here I've got my Outlook Group By enabled.
**[00:10:45]** I've got filtering.
**[00:10:46]** I've got column moving.
**[00:10:48]** I've got column pinning.
**[00:10:49]** I can do an export to Excel.
**[00:10:51]** I can do column hiding.
**[00:10:53]** So there's all kinds of capabilities in this grid.
**[00:10:55]** I didn't have to write any code for this.
**[00:10:56]** This was all just done with App Builder.
**[00:10:58]** Now what I want to do is add another grid to my Tasks page.
**[00:11:03]** And I have some data up in the cloud.
**[00:11:05]** It's some customer data with addresses.
**[00:11:07]** I have a logo, which is just from RoboHash.
**[00:11:10]** So I want to bind my new grid on the Tasks page to this data.
**[00:11:15]** So let's go to Visual Studio Code.
**[00:11:17]** We can stop our application.
**[00:11:19]** And let's give it some instructions:
**[00:11:20]** "On the /Tasks page, add a new Ignite UI data grid
**[00:11:26]** with this data bound."
**[00:11:29]** "Add a nice margin around the page to match the other pages."
**[00:11:35]** "Add these grid features, Outlook Group By,
**[00:11:39]** Excel Style Filtering, Column Moving, Export to Excel."
**[00:11:44]** "And put the address information
**[00:11:48]** in a multi-row collapsible header."
**[00:11:51]** "Make sure to inspect the schema of the JSON file
**[00:11:55]** to get the field names and make sure the image
**[00:12:00]** for the logo column is rendered correctly."
**[00:12:06]** So now we've given some instructions.
**[00:12:09]** Let's go ahead and hit "Enter."
**[00:12:10]** And our application will now use the agents,
**[00:12:13]** the MCP servers to build out our app.
**[00:12:16]** And you can see that it's doing a list, a search, etc.,
**[00:12:21]** of the Ignite UI CLI MCP servers.
**[00:12:24]** It's engaging those skills.
**[00:12:25]** And we'll give it a second here, and it will add, or rather,
**[00:12:29]** update our application based on those instructions.
**[00:12:37]** So that wrapped up.
**[00:12:38]** Let's go ahead and ".NET run" again
**[00:12:40]** and see how our new Tasks page looks in the browser.
**[00:12:45]** So we're running again at localhost 5000.
**[00:12:48]** Let's just copy this.
**[00:12:49]** I think I might have this open.
**[00:12:52]** Yes, I do.
**[00:12:53]** We'll do a refresh.
**[00:12:54]** Oh, look at there.
**[00:12:55]** Our Tasks page is already loaded.
**[00:12:57]** Let's do a Refresh.
**[00:12:58]** So this is the grid that it added.
**[00:12:59]** It actually did an Outlook Group By for us.
**[00:13:02]** So let's collapse that Group By and see what else it did.
**[00:13:05]** Oh, you'll notice my beautiful logo in the left-hand column.
**[00:13:10]** You'll also notice I do have the multi-column header
**[00:13:14]** with a collapsible address information area.
**[00:13:17]** So that's actually working.
**[00:13:19]** If I scroll to the left, I have my Excel-style filter.
**[00:13:23]** I've got all of the toolbar options,
**[00:13:25]** along with Export to Excel.
**[00:13:27]** You'll notice I did specify Export to Excel.
**[00:13:30]** I didn't say PDF or CSV,
**[00:13:32]** so it actually did just give me the Export to Excel.
**[00:13:35]** So that's pretty amazing.
**[00:13:36]** It did all of this with just a simple command using the Ignite
**[00:13:40]** UI Blazor skills along with the MCP server.
**[00:13:44]** Next, we're going
**[00:13:44]** to do something a little bit different.
**[00:13:46]** I have a screenshot here.
**[00:13:47]** You can see it's just from Adobe Stock.
**[00:13:49]** It's a dashboard view, has a left nav, has some cards on it
**[00:13:52]** with some different data visualizations.
**[00:13:54]** I'm going to drag this into my chat and ask it
**[00:13:57]** to build this app out with Ignite UI.
**[00:13:59]** And let's see how close we can get.
**[00:14:01]** So I have this image.
**[00:14:02]** It's called "image (2).png."
**[00:14:04]** I'm going to drag it right in.
**[00:14:06]** I'm going to say "use Ignite UI, Blazor, MCP Servers, and skills.
**[00:14:11]** Build an app that looks exactly like the attached image.
**[00:14:16]** Make sure to match the colors, fonts, etc."
**[00:14:22]** Let's hit the "Enter" key.
**[00:14:23]** And we will just let this guy run for a second.
**[00:14:26]** It will start to detect that it has the MCP servers
**[00:14:30]** and the skills.
**[00:14:30]** It'll analyze the image.
**[00:14:32]** And we'll go right from an image
**[00:14:33]** to pixel-perfect enterprise-ready code
**[00:14:36]** with Ignite UI Blazor.
**[00:14:40]** And I want to continue to emphasize
**[00:14:42]** that we are using components, frameworks,
**[00:14:45]** along with the capabilities of AI,
**[00:14:48]** to not only deliver beautiful experiences,
**[00:14:51]** but to get the best outcomes.
**[00:14:53]** So there is no drift.
**[00:14:54]** There is no hallucination.
**[00:14:56]** I'm not going crazy with tokens because I'm generating screens
**[00:15:00]** with thousands and thousands of lines
**[00:15:01]** of divs using a design system my company didn't approve
**[00:15:05]** or has no idea what it is.
**[00:15:07]** Using something like Ignite UI with the.NET Framework,
**[00:15:10]** with Blazor, or React, or Angular,
**[00:15:12]** whatever your choice is, you'll get certainty in those outcomes
**[00:15:16]** in the most optimized, efficient manner.
**[00:15:20]** And it looks like the app is live on localhost 5072.
**[00:15:24]** Let's go ahead, and we'll open this up in our external browser.
**[00:15:29]** And that looks pretty good.
**[00:15:30]** So we've got a beautiful blue-themed app.
**[00:15:32]** We have our cards across the top.
**[00:15:34]** There's our Ignite UI chart.
**[00:15:36]** There is our gauge.
**[00:15:38]** It looks like it didn't use the data grid here below.
**[00:15:41]** But if I go back to my image, we'll open this guy up,
**[00:15:46]** and we can see that it is pretty darn close.
**[00:15:48]** That's a donut chart up in the upper right.
**[00:15:51]** That's our category chart here.
**[00:15:52]** If I scroll back up, it actually did the right values
**[00:15:55]** in the card.
**[00:15:56]** So what would I do next?
**[00:15:57]** I would still work with my agent, and I would continue
**[00:16:00]** to maybe bind this to live data, add new screens,
**[00:16:03]** maybe tweak what it did build.
**[00:16:05]** But ultimately, I end up with something in about two minutes
**[00:16:09]** that otherwise would have potentially taken days.
**[00:16:12]** I don't really know.
**[00:16:13]** I don't have a designer either.
**[00:16:14]** So just starting from a stock image gave me a huge advantage.
**[00:16:19]** And finally, I just want to highlight some
**[00:16:21]** of our WinUI capabilities.
**[00:16:23]** As I mentioned, this is the launch
**[00:16:25]** of our brand new WinUI product.
**[00:16:27]** I have a few demos here, but go to infragistics.com
**[00:16:30]** to download all of our new WinUI demos.
**[00:16:33]** Check us out on YouTube.
**[00:16:34]** But you can see, we have beautiful charts.
**[00:16:35]** We're shipping a data grid.
**[00:16:37]** We're shipping some other really cool components as well.
**[00:16:40]** If I scroll down, we have a neat one called the Dashboard Tile,
**[00:16:42]** which I really like.
**[00:16:43]** It allows you to give your end user a little bit
**[00:16:46]** of customization.
**[00:16:47]** So, for example, let's say you give them a data grid
**[00:16:50]** or a data chart, and they want to do some data analysis.
**[00:16:53]** With the Dashboard Tile, you can do things like swap
**[00:16:56]** between the data and the chart.
**[00:16:58]** You can configure the chart to show different features,
**[00:17:01]** different capabilities.
**[00:17:03]** If you don't want to show the configuration,
**[00:17:05]** you can even let your end users swap out the chart type
**[00:17:08]** at runtime so they have a little bit more control
**[00:17:11]** over what they're looking at on the screen.
**[00:17:14]** But this is just a taste of what we're doing in WinUI.
**[00:17:17]** I'm going to minimize this and just look
**[00:17:19]** at a little bit of code.
**[00:17:20]** So if I scroll over to the right, you'll notice here
**[00:17:23]** in my XAML, I have the Infragistics XamCategoryChart.
**[00:17:28]** If you've ever used our WPF product,
**[00:17:30]** you know it's called the XamCategoryChart.
**[00:17:32]** If you've used our Blazor chart or our Angular or React chart,
**[00:17:37]** this is the same capabilities, APIs, property settings
**[00:17:41]** across all of the charts, just like the other components in WPF
**[00:17:45]** and WinUI, and then our Angular, React, Blazor components.
**[00:17:48]** You're going to get that same experience no matter what
**[00:17:50]** when you're building applications.
**[00:17:52]** And you can see here on the right-hand side,
**[00:17:53]** I was even using GitHub Copilot chat
**[00:17:56]** to customize my WinUI experience.
**[00:17:59]** So you can still build out these beautiful applications using
**[00:18:02]** Infragistics UI components that you've known and loved
**[00:18:04]** for over 30 years now using GitHub Copilot, code by hand.
**[00:18:08]** It doesn't matter.
**[00:18:09]** It's all up to you.
**[00:18:11]** So let's go back to the slides, and we'll wrap up.
**[00:18:13]** So after seeing all of those cool examples
**[00:18:16]** and how you can build out beautiful experiences
**[00:18:20]** with the Infragistics UI components,
**[00:18:22]** no matter what platform you're working on, I don't think I need
**[00:18:25]** to be the one to say that you should start building
**[00:18:27]** with Infragistics today.
**[00:18:29]** You probably are already on the website downloading samples,
**[00:18:33]** checking out App Builder, or seeing what we have
**[00:18:35]** in our brand new WinUI product
**[00:18:38]** that we are releasing today at Build 2026.
**[00:18:42]** So please check out Ignite UI with our MCP servers and skills,
**[00:18:46]** no matter what IDE you're using, App Builder for low-code dev,
**[00:18:50]** as well as conversational AI to build
**[00:18:53]** out app experiences, and then WinUI.
**[00:18:56]** But even on the desktop, if you're still doing WPF
**[00:18:58]** or Windows Forms, we have a lot to offer there as well.
**[00:19:02]** So I want to thank everyone
**[00:19:03]** for joining us today in this session.
**[00:19:05]** Learn more at Infragistics.com
**[00:19:08]** and have a great rest of Build 2026.
