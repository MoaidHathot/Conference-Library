**[00:00:01]** SIMON MAHIEU: Hi, everyone, Simon here from Aikido.
**[00:00:03]** Today we're going to show you the Aikido plugin for VS Code.
**[00:00:08]** The Aikido plugin is built to scan your files for secrets,
**[00:00:13]** code security issues, IEC issues,
**[00:00:16]** and code quality issues while you're developing.
**[00:00:19]** This is the ultimate shift-left movement.
**[00:00:21]** Our plugin also comes with a couple
**[00:00:24]** of extra really neat features such as a pre-commit hook.
**[00:00:27]** Basically, we're going to check
**[00:00:29]** if there's any secrets before you commit.
**[00:00:32]** We've got Safe Chain included there as well,
**[00:00:34]** which is a malware package scanner,
**[00:00:36]** and then we also have the Aikido MCP, which helps you with,
**[00:00:40]** for example, vibe coding.
**[00:00:41]** On every code that gets created or every prompt that is ran,
**[00:00:47]** we will also run the Aikido MCP, so let's take a closer look.
**[00:00:51]** Super easy to install, by the way.
**[00:00:53]** You just have to have an Aikido license.
**[00:00:55]** You log in through a login button here
**[00:00:57]** or through a personal access token.
**[00:01:00]** As you can see, I've got a couple of files open here.
**[00:01:02]** It's going to look at these files and it's going to show me,
**[00:01:06]** for example, what the issues are.
**[00:01:08]** It looks like this file right here has a couple of issues.
**[00:01:12]** If I click into some of these issues, it's going to showcase
**[00:01:15]** where exactly that issue is, and it's always going
**[00:01:18]** to tell me what the issue is.
**[00:01:21]** I can then assess the impact with Aikido AI.
**[00:01:24]** I can report a false positive in case that's needed.
**[00:01:27]** Plus, we can also fix it with Aikido AI, so whenever I click
**[00:01:31]** that button on the right-hand side, a new tab will pop up
**[00:01:35]** and that one is going to give me a fix, if available, of course.
**[00:01:39]** Then that's going to allow us to push that fix straight
**[00:01:42]** into the file, or I can reject it if I don't
**[00:01:45]** like the solution provided.
**[00:01:48]** Once this is done, you'll see that popping up here.
**[00:01:50]** While this is running, you can also run a dependency scan,
**[00:01:55]** and you will also be able to do a full-on workspace scan.
**[00:01:58]** I have an entire repo loaded here in my VS Code.
**[00:02:01]** I will go through all those files
**[00:02:04]** and then just showcase how we find things while you're coding.
**[00:02:08]** On the right-hand side here, by the way, it's loaded our fix.
**[00:02:12]** Basically, the red lines are the bad lines,
**[00:02:14]** the green ones are the good ones.
**[00:02:16]** We can now reject those changes or apply those changes.
**[00:02:20]** When you do a workspace scan, as I said, it's going to go and run
**[00:02:24]** through the entire workspace and then it's going to give me all
**[00:02:27]** of the files where we've detected an issue.
**[00:02:31]** Once this is done running, you will see
**[00:02:33]** that they will all be lined here,
**[00:02:35]** and then I can click through all of them.
**[00:02:38]** In the meantime, I'm going to fire off a dependency scan.
**[00:02:42]** This is then going to showcase
**[00:02:43]** if there's open-source dependencies.
**[00:02:45]** Here we go.
**[00:02:46]** We've got all the files,
**[00:02:47]** and it tells us how many issues we have.
**[00:02:49]** I can go into this one right here.
**[00:02:51]** It's going to open up the file.
**[00:02:54]** If I click into one of these issues so they'll open
**[00:02:56]** up right here, and then on the left-hand side here,
**[00:02:59]** you can see that it's found a bunch of code issues.
**[00:03:03]** Again, if I hover over it, it's telling me what the issue is.
**[00:03:07]** I can again fix it with Aikido AI
**[00:03:09]** or even report false positives to Aikido.
**[00:03:13]** We've got this open-source dependency scan running here.
**[00:03:16]** It's almost done.
**[00:03:17]** Once that is done, I will showcase what it will find.
**[00:03:21]** There we go.
**[00:03:22]** We found some issues here in POM XML, and then if I click
**[00:03:26]** into it, it's basically telling me, hey, there's a couple
**[00:03:29]** of packages that probably need to get updated.
**[00:03:32]** I can actually create an autofix in my IDE as well.
**[00:03:38]** So yeah, there's a lot of different things that we can do.
**[00:03:42]** Again, with the expansion packs, you'll be able to get all
**[00:03:46]** of these included in the IDE plugin, so thank you so much.
**[00:03:52]** Have a great rest of your day.
