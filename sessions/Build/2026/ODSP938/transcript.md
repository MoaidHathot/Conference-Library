**[00:00:00]** ERIKA HEIDI: Hi, I'm Erika Heidi,
**[00:00:02]** Staff DevRel Engineer at Chainguard.
**[00:00:05]** In this short presentation, I will share five strategies
**[00:00:09]** to mitigate software supply chain risks in GitHub actions.
**[00:00:13]** So the first thing you should do is inspect your repositories
**[00:00:17]** for insecure defaults and other bad practices.
**[00:00:20]** For instance, using pull request targets
**[00:00:23]** with head code execution,
**[00:00:25]** or using long-lived personal access tokens
**[00:00:27]** with broad privileges, direct shell execution
**[00:00:31]** that can be manipulated by external actors,
**[00:00:34]** and also actions pinned by tag.
**[00:00:37]** These are some things that you should look for.
**[00:00:40]** I will talk a little bit more about each of these things.
**[00:00:45]** Another thing is unprotected main branch
**[00:00:47]** and unprotected release tags.
**[00:00:50]** It can be a little bit overwhelming,
**[00:00:51]** but the good news is that you can use Copilot agent
**[00:00:55]** in your repository directly and ask it
**[00:00:58]** for evaluate your GitHub actions
**[00:01:02]** and find any potential vulnerabilities.
**[00:01:04]** That was the prompt I used, for instance, here.
**[00:01:08]** And it was very effective in detecting the issues.
**[00:01:12]** So this was a repo that I set up for testing.
**[00:01:16]** And I created intentionally a lot of insecure things as a demo
**[00:01:22]** to demonstrate secret exfiltration.
**[00:01:26]** And so, this has a vulnerable GitHub action workflow.
**[00:01:30]** And Copilot was very successful in detecting the issues.
**[00:01:34]** Pull request targets with code execution.
**[00:01:37]** So why that's an issue?
**[00:01:38]** Because when someone creates a pull request, then the code
**[00:01:45]** from the pull request is executed.
**[00:01:47]** And when you use pull request targets, this is executed
**[00:01:51]** in the context of the actual main branch and all the secrets
**[00:01:57]** and all the environment variables that are used
**[00:02:00]** in the actual builds in the main branch.
**[00:02:05]** So any variables that you have,
**[00:02:08]** any secrets that you have can be exfiltrated,
**[00:02:11]** depending on how you run your code in this workflow.
**[00:02:16]** And the Copilot detected the pull request targets
**[00:02:19]** with execution that runs go setup.
**[00:02:24]** So this is a method -- this is the same method that was used
**[00:02:28]** for the initial Trivy exploitation.
**[00:02:32]** So they exploited the pull request targets
**[00:02:35]** that was using PAT with broad privileges.
**[00:02:42]** And another thing was secrets exposed
**[00:02:47]** to attack a controller binary.
**[00:02:49]** It's also critical.
**[00:02:51]** Write-capable token also give permission
**[00:02:55]** for writing the pull request.
**[00:02:57]** It's also high risk.
**[00:03:00]** And also, it also pointed out the actions pinned to a tag.
**[00:03:07]** So this is insecure because tags can be rewritten.
**[00:03:11]** And this was also used in the Trivy attack.
**[00:03:15]** The attackers were able to rewrite previous tags,
**[00:03:20]** all two points to the same malicious commit.
**[00:03:24]** So if you were pinning your action by tag,
**[00:03:27]** you would pull the new codes
**[00:03:29]** with malicious injected payloads.
**[00:03:35]** So yes, this workflow is definitely vulnerable.
**[00:03:39]** Ask Copilot to check your repo and see
**[00:03:41]** if it can find any vulnerabilities.
**[00:03:45]** So you should protect your branches, your main branch,
**[00:03:49]** especially in your tags so they cannot be rewritten.
**[00:03:54]** This would prevent the malicious code to be released
**[00:03:58]** to other users and it would contain propagation.
**[00:04:03]** And also, you should protect your main branch
**[00:04:05]** to prevent purge directly to the main branch.
**[00:04:09]** And attackers can also use stolen PAT
**[00:04:13]** to inject directly on the main branch.
**[00:04:16]** So this is also very important.
**[00:04:18]** And it's a setting that you need to change.
**[00:04:20]** So by default, you don't have this protection.
**[00:04:23]** So you need to go there in your repo settings
**[00:04:26]** and enable these protections.
**[00:04:33]** So the second tip important
**[00:04:37]** for minimizing your risk is minimizing your attack surface.
**[00:04:42]** So this is like one of the simplest practices.
**[00:04:45]** In theory, it's so simple.
**[00:04:48]** Just make sure you have a smaller attack surface
**[00:04:52]** so you have less entry points to be exploited.
**[00:04:56]** It's like a low-hanging fruit that you cannot ignore.
**[00:05:00]** You have to think about direct and transitive dependencies.
**[00:05:04]** So the dependencies of your dependencies are also a risk.
**[00:05:09]** Any weak link in the chain can be used
**[00:05:11]** as a foothold to obtain access.
**[00:05:15]** And even with low-privileged access, they can also try
**[00:05:21]** to exfiltrate privileges and some other type of exploitation.
**[00:05:26]** But once they get access, yeah, there's a lot they can do.
**[00:05:30]** So the main idea is not to remove functionality.
**[00:05:34]** So you don't want to remove things that you actually use.
**[00:05:39]** But to remove what you don't need, what doesn't need
**[00:05:41]** to be there in your runtime especially.
**[00:05:45]** Because there are lots of dependencies
**[00:05:47]** in the runtime level,
**[00:05:50]** in the base OS level that you don't need.
**[00:05:54]** And one way to do that is by using minimal container images.
**[00:05:59]** So Chainguard containers are very minimal.
**[00:06:03]** We build all packages from source
**[00:06:05]** and that helps us keep the images always up to date
**[00:06:08]** and with all patches applied.
**[00:06:11]** So we are able to have, for instance, our Python image.
**[00:06:17]** The latest CVE count was four CVEs against like 579
**[00:06:23]** for the default Python image you get from Docker Hub.
**[00:06:26]** So it's a significant change and it's kind of a low-hanging fruit
**[00:06:34]** because you can just change the base images you use
**[00:06:38]** to build your runtimes and your GitHub actions also.
**[00:06:43]** And use a smaller image with a small attack surface
**[00:06:46]** and less vulnerabilities.
**[00:06:50]** The third tip is pull from trusted sources.
**[00:06:56]** So I don't know if you know that, but 98% or more
**[00:07:01]** of malware is inserted during build and distribution time.
**[00:07:06]** So it bypasses regular review from maintainers.
**[00:07:10]** You don't see the actual,
**[00:07:12]** exploit the actual malicious code in the source code
**[00:07:16]** in the repo because it is introduced during CI/CD
**[00:07:20]** and injected directly into artifacts that are produced
**[00:07:25]** at build time and distributed to repositories everywhere.
**[00:07:32]** So public repos will download these artifacts
**[00:07:35]** that have been tampered with and they are different actually
**[00:07:39]** from what is in the source code.
**[00:07:41]** So there is low visibility about what happens
**[00:07:46]** at build time usually.
**[00:07:50]** So one thing that happens a lot is a ghost release.
**[00:07:53]** Attackers are exploiting the gap
**[00:07:56]** between the verifiable source code and the build artifacts
**[00:08:00]** that we consume when we pull from these sources,
**[00:08:04]** the public registries.
**[00:08:07]** Public registries were built mostly
**[00:08:10]** to facilitate distribution of dependencies of libraries
**[00:08:13]** and facilitate collaboration.
**[00:08:16]** And they don't have a lot of security measures.
**[00:08:18]** Most of the public registries
**[00:08:21]** from language ecosystems don't have a lot of security measures
**[00:08:25]** to protect artifacts from tampering.
**[00:08:29]** So it was not a main concern when we started
**[00:08:33]** to share code this at this level and at this volume.
**[00:08:39]** So now we are faced with registries that are public.
**[00:08:44]** They are also prone to be exploited.
**[00:08:48]** So attackers are shifting left and they are focusing
**[00:08:53]** on turning developer laptops and CI/CD pipelines into nodes
**[00:08:57]** for propagation because that's
**[00:08:58]** where all the credentials and secrets are.
**[00:09:02]** And you can, with these credentials,
**[00:09:05]** you can spread laterally and spread to other projects
**[00:09:11]** and other -- yeah, other orgs even.
**[00:09:15]** So one way you can reduce a lot of these risks is by pulling
**[00:09:21]** from trusted sources your language dependencies using
**[00:09:26]** Chainguard libraries.
**[00:09:28]** So we have libraries for Python, Java,
**[00:09:31]** and JavaScript ecosystems at the moment.
**[00:09:33]** And the way it works is we make sure that the build is safe,
**[00:09:39]** the build environment is a safe environment, tampering proof.
**[00:09:46]** And then we, you can pull these dependencies directly
**[00:09:49]** from our repos and you will be avoiding more than 90%
**[00:09:54]** of the risks involved with build and distribution time attacks.
**[00:09:59]** So we don't execute any pre- and post-install scripts.
**[00:10:03]** So we don't build those libraries.
**[00:10:06]** You will only get versions that are safe to install.
**[00:10:14]** Another important practice is pin to digest.
**[00:10:18]** Even Copilot pointed out that you should not use a tag
**[00:10:25]** in your actions, you should pin to a digest.
**[00:10:29]** A digest is a unique hash pointing to a specific build
**[00:10:33]** of a container image or a GitHub action.
**[00:10:36]** So you are not pulling unknown code.
**[00:10:40]** You will always be pulling the same builds, the same codes
**[00:10:45]** that you were executing before.
**[00:10:48]** So of course, this will get stale with time.
**[00:10:51]** You need to update the digest
**[00:10:53]** when there's new versions released of the image
**[00:10:56]** or the GitHub actions.
**[00:10:58]** But it gives you time to update.
**[00:11:02]** You can use Digestabot.
**[00:11:05]** It's a tool that Chainguard created and it's free to use,
**[00:11:08]** open-source, that you can use to keep your workflows
**[00:11:11]** and Docker files up to date.
**[00:11:13]** So whenever there is a new version of a container
**[00:11:17]** or a GitHub action, you will get pull requests
**[00:11:22]** with the updated digest.
**[00:11:24]** So it's very handy to keep your digest updated.
**[00:11:29]** Yeah, and pinning to a digest is the safest practice you can use
**[00:11:34]** regarding tagging containers and GitHub actions.
**[00:11:39]** So this is the action.
**[00:11:43]** And, really, you will define a workflow file,
**[00:11:49]** a YML file with a configuration and, yeah, then you will be able
**[00:11:55]** to do these updates automatically.
**[00:11:59]** And, final advice, I would say,
**[00:12:03]** is to ban personal access tokens.
**[00:12:07]** Don't use long-lived tokens
**[00:12:11]** because they can be really dangerous.
**[00:12:12]** We usually forget about tokens and a lot
**[00:12:17]** of people give a very long expiry time for the token
**[00:12:22]** and broad privileges which can be really dangerous.
**[00:12:26]** That's what we saw happening with Trivy.
**[00:12:28]** They had an org-wide PAT that was exfiltrated.
**[00:12:32]** So attackers had full control over the whole org.
**[00:12:36]** They were able to delete and create repos, create releases
**[00:12:41]** and do anything they wanted, basically.
**[00:12:44]** So using short-lived tokens is the best solution to make sure
**[00:12:49]** that you give only a limited privilege to a workflow run
**[00:12:54]** and for a limited amount of time.
**[00:12:56]** So even if the credential is exfiltrated,
**[00:12:59]** it will expire quickly.
**[00:13:02]** So you don't need to be so concerned about that.
**[00:13:06]** We have an app, also a GitHub app,
**[00:13:08]** that you can install for free.
**[00:13:11]** Call it Octo-STS.
**[00:13:13]** And it implements this strategy using the same concepts behind
**[00:13:18]** Sigstore and Cosign.
**[00:13:20]** So it will give you temporary credentials and they will expire
**[00:13:25]** in a short period of time.
**[00:13:27]** So Octo-STS is actually the identity
**[00:13:31]** that we will pull the request for you in your repo.
**[00:13:36]** And this is the app for you to find on GitHub.
**[00:13:41]** So a TLDR, before we close, first inspect your repository
**[00:13:49]** for insecure defaults and other bad practices.
**[00:13:52]** You can use Copilots to help with that.
**[00:13:55]** Ask it to evaluate your GitHub actions
**[00:13:57]** and find vulnerabilities.
**[00:13:59]** Number two, minimize attack surface.
**[00:14:02]** So you remove a lot of the software that doesn't need
**[00:14:06]** to be there in your runtime.
**[00:14:08]** And then this means that you have less entry points
**[00:14:11]** for an attacker to exploit and less vulnerabilities.
**[00:14:16]** So the third one is pull from trusted sources.
**[00:14:21]** We are seeing increase on NPM issues, incidents.
**[00:14:27]** And it's very important for us now to think
**[00:14:30]** about where we are pulling our open-source software from.
**[00:14:34]** So pull from trusted sources.
**[00:14:38]** And the number four is pin by digest.
**[00:14:41]** Don't pin by tag because tags can be hijacked.
**[00:14:44]** So pin by digest and use Digestabot to keep them updated.
**[00:14:49]** And number five, ban long-lived personal access tokens
**[00:14:53]** and use short-lived tokens instead.
**[00:14:56]** You can use Octo-STS for that.
**[00:14:59]** And yes, that was all I had for this short presentation.
**[00:15:06]** I hope you stay safe and see you next time.
