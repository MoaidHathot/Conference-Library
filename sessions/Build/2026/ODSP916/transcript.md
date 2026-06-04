**[00:00:01]** GUUST YSEBIE: Hello, LM.
**[00:00:02]** So today we're going to talk a little bit
**[00:00:05]** about designing systems
**[00:00:07]** for every user including people and LLMs.
**[00:00:10]** My name is Guust Ysebie and I'm currently working
**[00:00:12]** as a software engineer enterprise where I mostly work
**[00:00:16]** on our PDF as the gate.
**[00:00:18]** So I also work a lot on accessibility within PDFs
**[00:00:22]** and that's the knowledge I want to share with you today.
**[00:00:27]** PDF documents today are not only consumed by people.
**[00:00:32]** They are also being consumed by LLMs.
**[00:00:35]** So they should be as accessible as possible
**[00:00:38]** for both these consumers.
**[00:00:41]** Which principles are useful for everyone?
**[00:00:45]** The first one is perceivable.
**[00:00:47]** It needs to be operable.
**[00:00:48]** It needs to be understandable.
**[00:00:50]** And it needs to be robust.
**[00:00:51]** Why am I telling you all of this?
**[00:00:53]** It's because it's all of those kind of issues that both humans
**[00:00:57]** and LLMs encounter when working with PDF documents.
**[00:01:01]** Let's have a quick look at the PDF.
**[00:01:04]** When you have physical data format it means
**[00:01:06]** that you can use different kinds of formats like fonts,
**[00:01:10]** like images, videos, put them together in to one.
**[00:01:14]** The most important parts you'll have
**[00:01:16]** to understand is the drawing language,
**[00:01:19]** and the drawing language is just drawing instructions
**[00:01:23]** which you can see displayed.
**[00:01:25]** What this does is when you have a canvas
**[00:01:27]** like a PDF page it just simply says like,
**[00:01:32]** "Move to this certain location and then we need
**[00:01:35]** to draw these characters on this exact location."
**[00:01:39]** This ensures that when you open the PDF I created
**[00:01:43]** that your PDF knows exactly on which pixel
**[00:01:47]** to render which content.
**[00:01:49]** The pixels and characters are like very different
**[00:01:53]** from what we actually do when we look at the PDF.
**[00:01:58]** Those pixels we can actually design a reading order to it.
**[00:02:02]** We understand its semantics then and based on drawing
**[00:02:06]** of the (inaudible) like lines, like list symbols,
**[00:02:09]** we can determine what the order (inaudible) the data to be in.
**[00:02:14]** Of course if you're an LLM you don't have all that kind
**[00:02:17]** of meta information out of the box.
**[00:02:19]** The LLM just looks at the page and sees pixels.
**[00:02:23]** So it's very hard for LLMs then to extract the data from it.
**[00:02:28]** You would lose either a lot of tokens where you need
**[00:02:31]** to have training or you would need those text extraction
**[00:02:37]** so you can actually first extract the data from it
**[00:02:40]** and then train your LLM on the data.
**[00:02:44]** So what you have to remember here is what we see is very easy
**[00:02:50]** for us because we are trained on it, but LLMs don't have this
**[00:02:54]** and so it's very hard for them
**[00:02:56]** to interpret the actual meaning behind those pixels.
**[00:03:00]** If you, for example, would have a PDF,
**[00:03:03]** LLMs actually are quite good in extracting this kind of data.
**[00:03:07]** But, as you can see on the left side,
**[00:03:09]** it doesn't have any structure.
**[00:03:11]** It doesn't really know what means what.
**[00:03:15]** Yeah. We can make a guess
**[00:03:16]** and you will input probably as a title.
**[00:03:19]** But it's very hard and very inefficient to train your LLMs
**[00:03:24]** on because it can't apply semantic reasoning
**[00:03:27]** on to the context.
**[00:03:29]** On the right side, on the other hand, exactly the same context,
**[00:03:32]** but now we added semantic meaning.
**[00:03:35]** We added which part of the document is actually a header,
**[00:03:39]** which one is a table, and as you can see it will be far more
**[00:03:43]** easier for the LLM and for your normal users
**[00:03:47]** to actually extract the semantic meaning.
**[00:03:51]** So in PDFs, normal PDFs, didn't really have like this kind
**[00:03:56]** of system where you can take contents with semantic meaning.
**[00:04:01]** But of course PDF evolved
**[00:04:04]** and now it includes a mechanism for this.
**[00:04:06]** This mechanism is text PDFs.
**[00:04:09]** You as a developer have the advantages
**[00:04:12]** because low level tools do it for you
**[00:04:15]** because if we open the PDF now, for example here,
**[00:04:19]** we can quickly see that now
**[00:04:23]** on the right we have our text structure.
**[00:04:25]** So it means we actually have kind
**[00:04:27]** of the same structure you would know
**[00:04:28]** from HTML while still having pixel perfect rendering
**[00:04:33]** on the left.
**[00:04:33]** So now we for sure know that for example the text
**[00:04:37]** in blue is in H1.
**[00:04:39]** Below it is a paragraph.
**[00:04:41]** And then we have a table.
**[00:04:42]** So now we have pixel perfect rendering
**[00:04:46]** and we have complete semantic information
**[00:04:49]** and meta data about our document.
**[00:04:52]** So because we now have like this bunch of semantic information,
**[00:04:56]** bunch of meta data, and creating tools on top
**[00:04:59]** of PDFs are far more easy.
**[00:05:01]** Now we can just look in to our text structure
**[00:05:04]** and see which text is there.
**[00:05:07]** This means assistive technology, search, extraction,
**[00:05:10]** and all the other things are far more easier to implement
**[00:05:14]** because now we have a structured model of the data
**[00:05:19]** that we display within our PDF document.
**[00:05:22]** Text extraction is probably one of the most interesting things
**[00:05:26]** because lots of developers need
**[00:05:28]** to process a bunch of PDF documents.
**[00:05:31]** So for our table today I did a quick demo
**[00:05:34]** where I built an LLM data pipeline
**[00:05:37]** and on the first (inaudible) we're going
**[00:05:39]** to use OCR based solution.
**[00:05:43]** We are going to use Docling in our circumstance.
**[00:05:46]** Why? Because it's the most well used and one
**[00:05:49]** of the best tools out there.
**[00:05:52]** It's open source as well.
**[00:05:54]** And on the other hand we are going to use iText as the gate
**[00:05:58]** to leverage the embedded text system within the PDF
**[00:06:02]** which contains all the meta data.
**[00:06:04]** Instead of trying to analyze pictures,
**[00:06:07]** to actually extract the content we really want to.
**[00:06:10]** So let's get started.
**[00:06:12]** So we have this PDF document.
**[00:06:15]** This is just a normal summary with some tables, some lists,
**[00:06:20]** and some stress tests where we have, for example, a water mark
**[00:06:26]** in to it and some very tiny little text.
**[00:06:29]** So the first thing we're going
**[00:06:31]** to do is we're going to run Docling on it.
**[00:06:34]** And we're going to convert it to a mark down file.
**[00:06:36]** Why mark down file?
**[00:06:38]** Mark down files are very information dense
**[00:06:41]** so it means you have semantic information.
**[00:06:46]** So let's run Docling first.
**[00:06:48]** This script is quite easy and can just be executed with item.
**[00:06:55]** This just reads the PDF document
**[00:06:59]** and calls the correct library functions
**[00:07:01]** to convert it to a mark down.
**[00:07:03]** While this is running and trying to extract the data
**[00:07:07]** if we have a look at this this is still warming up.
**[00:07:11]** It's loading a bunch of its models.
**[00:07:14]** This only has to be done once, of course, for Docling.
**[00:07:16]** And so now it will start doing the actual conversion.
**[00:07:24]** As you see, it takes a bit of time.
**[00:07:30]** So now you can see it's finally done.
**[00:07:33]** So to convert those four pages of information based
**[00:07:39]** on processing the OCR
**[00:07:41]** so processing the pixels it takes about 18 seconds.
**[00:07:46]** So if we look at the output we generated
**[00:07:49]** from this we see it's actually quite good.
**[00:07:53]** We have all the tables.
**[00:07:55]** We have the lists.
**[00:07:57]** We have even the difficult languages.
**[00:08:00]** But we also have the water mark, for example,
**[00:08:03]** which is not something we really want.
**[00:08:05]** So it's not the author intent to be actually extracted.
**[00:08:09]** And this might be used if you're using OCR tools
**[00:08:14]** to (inaudible) training data
**[00:08:16]** because then the data will also be in to your mark down file
**[00:08:20]** and it might be used or abused to jailbreak your LLM.
**[00:08:25]** So how does it compare to the basic Java implementation
**[00:08:29]** where we use iText to actually extract the data
**[00:08:32]** and the meta information from it?
**[00:08:34]** Now it's a far different story.
**[00:08:37]** So now you see it's only 0.75 seconds.
**[00:08:42]** Excuse me.
**[00:08:43]** 0.075 seconds.
**[00:08:45]** So it's 200 times faster than the OCR implementation.
**[00:08:50]** And not only that.
**[00:08:52]** If we look at the output you see the tables look exactly
**[00:08:57]** the same.
**[00:08:58]** The content looks exactly the same.
**[00:09:00]** But, for example, the water mark which the author didn't intend
**[00:09:05]** to be actually displayed or to be used
**[00:09:09]** or to be actual important data is not there as we expected,
**[00:09:14]** and it's of course a lot better for security reasons and all
**[00:09:19]** of that, all those things.
**[00:09:20]** But what you also have to take in to account,
**[00:09:23]** if we compare the list of which it notes we see here PDF OCR
**[00:09:30]** didn't manage to actually extract
**[00:09:32]** that those were sublists.
**[00:09:34]** Why? Again because the semantic meaning was lost
**[00:09:38]** from the document while if you are using the meta data
**[00:09:43]** which was embedded in to the document you see the sublist is
**[00:09:47]** correctly constructed.
**[00:09:49]** This means that the Docling OCR actually generates
**[00:09:52]** like some kind of mistakes which are very hard to trace
**[00:09:55]** and those mistakes can compound over time
**[00:09:59]** which in the end produces very wrong output formats.
**[00:10:03]** So that was the table.
**[00:10:04]** As you can see, we generate the same mark down documents
**[00:10:08]** to then train our LLMs models
**[00:10:10]** to extract the business data that we require.
**[00:10:15]** So what do we have to remember here?
**[00:10:17]** We need to design
**[00:10:18]** for understanding not just rendering,
**[00:10:20]** and that's especially the case in PDF documents.
**[00:10:23]** So when you are producing a PDF you should enable that,
**[00:10:28]** the meta data, as being embedded.
**[00:10:31]** This can be done in most PDF libraries by enabling a flag.
**[00:10:37]** Then you have to make sure that those tags are correct
**[00:10:41]** and convey the author's intent of the PDF document.
**[00:10:45]** And if you do those two steps you'll have a bunch
**[00:10:48]** of advantages you get for free.
**[00:10:50]** You get smart data extraction.
**[00:10:52]** You get easy search.
**[00:10:54]** And your PDF documents are accessible.
**[00:10:58]** So you have to remember accessibility isn't extra work.
**[00:11:03]** What you do now is only a few more minutes of work
**[00:11:07]** and that means that your AI infrastructure
**[00:11:10]** which you will build in the next following years will be
**[00:11:14]** so much better at processing all your documents
**[00:11:18]** which means you will have gained a competitive edge just
**[00:11:23]** because you make your data accessible
**[00:11:27]** to both users and LLMs.
**[00:11:30]** All right.
**[00:11:31]** Thank you very much.
**[00:11:32]** If there are any questions please don't hesitate
**[00:11:35]** to contact me or enterprise and we will gladly help you out.
