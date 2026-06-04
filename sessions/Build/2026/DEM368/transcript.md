**[00:00:00]** Super excited to introduce Prashant from Applied Information Science.
**[00:00:04]** Do you have this amazing session?
**[00:00:06]** Take care.
**[00:00:06]** Ahead, thank you.
**[00:00:07]** Welcome everyone to the session titled Data Science and Machine
**[00:00:11]** Learning with Microsoft Fabric.
**[00:00:13]** So what we are going to cover today is we
**[00:00:15]** will start with why traditional machine learning is still important.
**[00:00:19]** Like most of us is hearing about AI agents or
**[00:00:21]** generative AI or large language model a lot.
**[00:00:24]** But there is still a play for our traditional machine
**[00:00:27]** learning model.
**[00:00:28]** And then we will start with what is Microsoft Fabric,
**[00:00:31]** how Microsoft Fabric can support you with your machine learning
**[00:00:34]** models and data science journey.
**[00:00:36]** Then we will go with the demo.
**[00:00:38]** I will, I will show where I will show you
**[00:00:40]** an experiment where we will be using notebooks in fabric
**[00:00:43]** and we will run through the experiment using multiple models.
**[00:00:47]** And then we will select the best of the model
**[00:00:49]** and then how we can consume that models once it's
**[00:00:52]** deployed in fabric.
**[00:00:54]** Towards the end, we will also talk about fabrics data
**[00:00:57]** agent as well.
**[00:00:58]** So let's take a look at why traditional ML is
**[00:01:01]** still important.
**[00:01:02]** You know, even though there's a more and more push
**[00:01:04]** for generative AI, there's a lot of edge cases where
**[00:01:07]** traditional ML is still relevant.
**[00:01:08]** Like for example, you want consistent results, you want low
**[00:01:13]** latency results.
**[00:01:14]** You know, you want to have efficient compute because most
**[00:01:17]** of this large language model requires a really, really beefy
**[00:01:21]** infrastructure.
**[00:01:22]** Whereas a traditional machine learning you can we can run
**[00:01:25]** on edge devices as well.
**[00:01:27]** One of The thing is, you know, reproducibility, that's where
**[00:01:30]** you know, traditional ML really help and also regarding the
**[00:01:34]** feature attribution as well.
**[00:01:35]** So in case you have a use case where you
**[00:01:38]** want to use or run traditional machine learning models, these
**[00:01:41]** are some of the options available to us.
**[00:01:44]** Like the services that you can use is out of
**[00:01:46]** this is you can run those models on Foundry, You
**[00:01:50]** can also do that on Fabric.
**[00:01:51]** And of course you can also use all the open
**[00:01:54]** source product as well.
**[00:01:56]** In this particular talk, I will be focusing only on
**[00:01:59]** Microsoft Fabric.
**[00:02:01]** So what is Microsoft Fabric?
**[00:02:02]** It is Microsoft Unified data platform for AI transformation.
**[00:02:06]** It is a software as a service offering from Microsoft.
**[00:02:09]** Anyone can use fabric.
**[00:02:11]** Fabric is huge.
**[00:02:12]** There are lots and lots of different services available.
**[00:02:14]** We have data factory, we have analytics, we have databases,
**[00:02:17]** you can do real time intelligence.
**[00:02:19]** We also have something called IQ and you can you
**[00:02:22]** have one leg and we can also apply your traditional
**[00:02:26]** security and governance policies as well.
**[00:02:30]** When it comes to Fabric, there are multiple roles or
**[00:02:33]** multiple people with multiple skill set will be using fabric.
**[00:02:37]** What we will be focusing on is mostly on data
**[00:02:40]** scientist or machine learning engineers.
**[00:02:42]** Like traditionally what we have seen is the data engineers
**[00:02:46]** will be responsible for building, managing and securing your data
**[00:02:49]** pipelines.
**[00:02:50]** OK, that is going to ingest your data, that is
**[00:02:52]** going to store your data from various sources, you know
**[00:02:55]** in data factory or data warehouses.
**[00:02:57]** Whereas the data scientist or machine learning engineers will be
**[00:03:00]** applying the advanced statistics and machine learning techniques to the
**[00:03:03]** data that you already have.
**[00:03:07]** Now when it comes to machine learning model, these are
**[00:03:09]** some of the popular machine learning models that are available
**[00:03:13]** in fabric like for example classification which can help you
**[00:03:16]** in terms of predict a categorical value like whether a
**[00:03:19]** customer may churn or not.
**[00:03:21]** You can also use regression as well, clustering and forecasting
**[00:03:25]** as well.
**[00:03:26]** And this is like the high level process or steps
**[00:03:29]** that you will be using when it comes to using
**[00:03:31]** data science.
**[00:03:32]** Like first you define a problem and like what is
**[00:03:35]** your problem that you're trying to solve?
**[00:03:37]** The next step will be then where is your data?
**[00:03:39]** Get the data.
**[00:03:41]** And then next is then prepare your data for your
**[00:03:44]** experimentation.
**[00:03:45]** Then the last, then the next step is #4 step,
**[00:03:47]** which is we will be running like multiple experimentation where
**[00:03:50]** you train your model.
**[00:03:52]** And once you might identify what model you'll be using,
**[00:03:54]** then you'll be using that model in the application of
**[00:03:57]** your choice.
**[00:03:57]** Like for example, let's take example, your executives are looking
**[00:04:00]** at a dashboard in Power BI and they identified, OK,
**[00:04:03]** we need to solve this problem or we need to
**[00:04:05]** do some prediction on this particular data.
**[00:04:08]** The next step that you'll be doing is then get
**[00:04:10]** that data into the lake house.
**[00:04:12]** And once your data is in the lake house, the
**[00:04:14]** next step will be then is you prepare your data
**[00:04:16]** for your experimentation.
**[00:04:18]** And then you use your notebooks to run a series
**[00:04:21]** of experimentation on your on your data.
**[00:04:24]** Then you once your experiments are done, then you figure
**[00:04:28]** out or find out what is the best experiment or
**[00:04:31]** the model that's giving me better result.
**[00:04:34]** Then you deploy that model inside fabric.
**[00:04:37]** And the last step is basically use that model to
**[00:04:39]** generate the insights.
**[00:04:41]** Again, I'm showing you here the example of Power BI.
**[00:04:44]** But once the model is generated, you can consume that
**[00:04:47]** model in any platform or any, any, any language of
**[00:04:50]** your choice as well.
**[00:04:52]** Now with that, let's go to a demo.
**[00:04:55]** So what the demo that I will be showing you
**[00:04:58]** is let's say you are a healthcare analyst and your,
**[00:05:01]** your team is building a model to predict a quantitative
**[00:05:05]** measure for, for diabetes progression, OK.
**[00:05:08]** And they need to compute linear regression against decision trees,
**[00:05:12]** track whether feature matter most and ensure the best model
**[00:05:16]** is used or say for clinical validation.
**[00:05:19]** And for that you'll be using ML flow.
**[00:05:21]** If you don't use ML flow, then what you're looking
**[00:05:23]** at is you're manually running series of experiment, you're keeping
**[00:05:27]** the lag of the log of that and then finally
**[00:05:29]** figuring out which particular experiment gave me the best result
**[00:05:32]** and then use that experiment to deploy your model.
**[00:05:36]** So with that further ado, what I will do is
**[00:05:39]** I will switch the context and I will go to
**[00:05:42]** my notebook.
**[00:05:44]** Looks like the notebook is not there.
**[00:05:46]** So let me just quickly fix that real quick.
**[00:05:56]** OK, OK, perfect.
**[00:06:03]** All right, we are back in the business.
**[00:06:05]** OK, I need to look at this particular screen.
**[00:06:07]** All right, so let me zoom this a bit so
**[00:06:10]** people in the back can say how many of you
**[00:06:12]** are seeing the fabric notebook for the first time?
**[00:06:16]** OK, I see a lot of hands.
**[00:06:17]** OK, so let's start with a lake house like workspace
**[00:06:22]** first.
**[00:06:23]** And when you click on a new item, there are
**[00:06:25]** a lot of different things you can create in fabric
**[00:06:28]** notebook is one of that.
**[00:06:29]** So if I click on all items, you what you
**[00:06:31]** will see here is multiple things I can create.
**[00:06:34]** I can create a dashboard, I can create a data
**[00:06:36]** agent.
**[00:06:37]** I can also create the notebook.
**[00:06:39]** And we have already created a notebook here and I'm
**[00:06:42]** just going to run through that real quick.
**[00:06:44]** So let me first find out this notebook.
**[00:06:47]** Perfect.
**[00:06:47]** So this is a notebook that we'll be using.
**[00:06:49]** And what I have done is the first thing we
**[00:06:51]** are doing is we are getting the data that is
**[00:06:53]** publicly available.
**[00:06:54]** So this particular data set is already available on Azure
**[00:06:57]** BLOB storage.
**[00:06:58]** Anyone can use it for the experimentation purpose.
**[00:07:00]** So pulling that data, that means one of the key
**[00:07:03]** feature with Fabric is no matter where your data is,
**[00:07:05]** you can use that data for experimentation.
**[00:07:07]** I don't have to manually copy that data or into
**[00:07:10]** the fabric.
**[00:07:12]** So first thing first.
**[00:07:13]** So we are copying that data.
**[00:07:14]** And then once that data is there, the next step
**[00:07:17]** we are we are doing is we are displaying that
**[00:07:20]** data frame.
**[00:07:21]** OK.
**[00:07:21]** But one of The thing is this data frame that
**[00:07:24]** we loaded is loaded as a Spark data frame.
**[00:07:27]** The next thing we want to do is we want
**[00:07:29]** to use the Skykit learn and Skykit learn expect expect
**[00:07:32]** the pandas data frame.
**[00:07:34]** So here using these functions, we are converting that into
**[00:07:37]** the pandas.
**[00:07:38]** And once the pandas are generated, if I Scroll down
**[00:07:43]** then we are splitting the data for 70% training and
**[00:07:47]** 30% test.
**[00:07:48]** So I have a huge data sets I want to
**[00:07:50]** split for 70% training and once that training is done
**[00:07:53]** the next 30% I want to use for the validation.
**[00:07:56]** So once that is done, the next thing I am
**[00:07:59]** going to do is start training a linear regression model.
**[00:08:02]** And this is where you know you'll you'll be going
**[00:08:04]** into the experimental phase now like your data is there
**[00:08:07]** now, depending on your use case, you may be learning
**[00:08:09]** a linear regression model or any other model of your
**[00:08:12]** choice.
**[00:08:12]** So you're going through the multiple experimental phase right now.
**[00:08:16]** So first thing I'm going is a linear regression model.
**[00:08:19]** And once that is run, then I'll going with the
**[00:08:22]** decision T regressor as well.
**[00:08:25]** Once that is done, then I'm listing all the experiments
**[00:08:28]** that I have done with this notebook.
**[00:08:30]** OK.
**[00:08:31]** And if you see here the experiments that we are
**[00:08:34]** doing, you can see the names of that.
**[00:08:37]** So the experiment name is experiment diabetes.
**[00:08:40]** So that is the experiment that I'm using and inside
**[00:08:43]** that experiment I'm running using multiple machine learning models of
**[00:08:46]** my choice.
**[00:08:48]** So once that is done, the next thing I'm going
**[00:08:51]** to do is I'm going to listing all the experiments
**[00:08:53]** that I have done so far.
**[00:08:54]** So these are the three experiments I have run experiment,
**[00:08:58]** diabetes, diabetes classification, and diabetes regression.
**[00:09:02]** And then after that I'll be receiving, retrieving a specific
**[00:09:05]** experiment that I would like to focus on.
**[00:09:08]** Once that is there, then I will be retrieving all
**[00:09:10]** the runs for that experiment and from that run or
**[00:09:13]** from evaluating those run, I will see which particular run
**[00:09:17]** is giving me the best result and I can then
**[00:09:19]** use that experiment and deploy that as a model.
**[00:09:23]** So these are the different, I know the experiments I
**[00:09:27]** had.
**[00:09:27]** And then I just want to have the most 2
**[00:09:30]** recent runs that I will be using.
**[00:09:32]** And once that is there, the next thing I'm doing
**[00:09:35]** is I'm using visualizing the model comparison for that.
**[00:09:40]** And once I have enough data points and I'm in
**[00:09:42]** a position, now my experimentation is done.
**[00:09:44]** Now I need to generate a model from it.
**[00:09:47]** So what I can do is I can go back
**[00:09:50]** to my workspace here and then go to my experiment.
**[00:09:55]** And this is the experiment that we ran database classification.
**[00:10:00]** And here I can see all the previous runs that
**[00:10:03]** I have there.
**[00:10:04]** And I can select a specific run.
**[00:10:06]** And here you will see an option to save this
**[00:10:08]** as a model.
**[00:10:09]** So using this option, I can I can save this
**[00:10:12]** particular experiment as a as a model.
**[00:10:15]** So let's see, let's give it as a new name.
**[00:10:17]** I'm going to call it as build 26, model 01.
**[00:10:24]** And then I can select a specific folder and save.
**[00:10:28]** And once the model is saved, let me go back
**[00:10:33]** to my workspace real quick and arrange everything by the
**[00:10:38]** model over here.
**[00:10:40]** And this is the model that I have created.
**[00:10:42]** So I can go here, I can space, I can
**[00:10:44]** open this model over here.
**[00:10:46]** I can see various statistics for this model.
**[00:10:50]** I can also have the versioning as well.
**[00:10:52]** I can also have download the version files.
**[00:10:55]** But one key feature of Fabric is creating the model
**[00:10:59]** is one thing, but how I will make sure that
**[00:11:01]** someone else can use this model.
**[00:11:04]** So if I go on the settings for this model
**[00:11:07]** over here, so this is where you will see the
**[00:11:10]** information about the model.
**[00:11:12]** I can have the name of the model, I can
**[00:11:14]** have the description.
**[00:11:15]** And if I click on the endpoints, this is where
**[00:11:18]** I can capture the endpoint.
**[00:11:19]** So now my model is there, it's deployed in Fabric
**[00:11:22]** and I can now start consuming this model in the
**[00:11:24]** platform of programming language of my choice.
**[00:11:29]** Let's go back to our notebook and I will be
**[00:11:32]** running this experimentation now 1 by 1.
**[00:11:40]** So one thing that you will see in the notebook
**[00:11:42]** is I can use a different Spark environments to run
**[00:11:45]** this notebook.
**[00:11:46]** Like for example, by default, the spypark Python is selected,
**[00:11:49]** but I can also use a Spark scalar.
**[00:11:51]** I can also use Spark SQL and Spark R as
**[00:11:54]** well.
**[00:11:57]** So let's first make sure you know we are getting
**[00:12:00]** the data from the BLOB storage.
**[00:12:07]** All right, looks like the data is there.
**[00:12:09]** The next thing I'm going to do is displaying the
**[00:12:12]** data in the data frames.
**[00:12:18]** All right, it's done as well.
**[00:12:21]** And the next thing I'm going to do is convert
**[00:12:26]** this into the Pandas data frame, All right?
**[00:12:32]** And then here I will start creating this experiment He's
**[00:12:35]** already created.
**[00:12:35]** So I'm not going to create this again.
**[00:12:37]** But what I will do is I will just going
**[00:12:40]** to start the experimenting with linear regression model over here.
**[00:12:48]** All right, looks like this run is also finished.
**[00:12:50]** Now the next thing you want to do is I'm
**[00:12:52]** going to start with the decision T regressor.
**[00:13:01]** All right, this is done and the next thing I'm
**[00:13:06]** going to do is I'm going to list all the
**[00:13:11]** experimentation that I have done perfect that is done as
**[00:13:17]** well, and then retrieve the space, the most recent one
**[00:13:22]** and get all the experiments with that particular ID.
**[00:13:28]** There's a list is really long and then order by
**[00:13:32]** the start time and limit this to two.
**[00:13:37]** And then finally, I will do the visualization.
**[00:13:41]** OK, so this is regarding running your traditional machine learning
**[00:13:45]** workloads in Fabric.
**[00:13:47]** But how about you also want to use something like
**[00:13:50]** a generative AI as well in Fabric?
**[00:13:51]** How you can do that?
**[00:13:52]** So for that, there is something called data agents in
**[00:13:55]** Fabric.
**[00:13:56]** So let me go back to the slides.
**[00:13:58]** Let me minimize this.
**[00:14:01]** So Fabric data agent is one of the feature available
**[00:14:04]** inside fabric where if your data is in one leg,
**[00:14:08]** you can use or you can execute your queries in
**[00:14:11]** the natural language and behind the scene.
**[00:14:15]** The fabric data agent will convert your queries based on
**[00:14:18]** the instruction that you have provided into the corresponding SQL
**[00:14:21]** statements and then give you the information back.
**[00:14:24]** OK.
**[00:14:25]** And once your agent is created, you can then access
**[00:14:28]** that agent as an MCP server endpoint.
**[00:14:30]** You can also deploy that agent on M-65 copilot.
**[00:14:33]** You can also do an integration with Microsoft Foundry as
**[00:14:36]** well as copilot Studio as well.
**[00:14:38]** So without further ado, what I'll do is I'll go
**[00:14:42]** I'm going to go to the fabric again and let
**[00:14:45]** me go back to my workspace and let me arrange
**[00:14:48]** everything by.
**[00:14:51]** So this is the data agent that I have created.
**[00:14:54]** You can also click on the new item here and
**[00:15:00]** you can filter by agent and let me select all
**[00:15:07]** all right and then search agent all right.
**[00:15:13]** So this is what you need to select.
**[00:15:15]** There is also another operational agent is there, which is
**[00:15:19]** under preview, which you can use to monitor the real
**[00:15:22]** time data and recommend recommended business action.
**[00:15:25]** So in our case, I'm going to go with the
**[00:15:27]** sales data agent.
**[00:15:28]** And the use case here is we have a lot
**[00:15:32]** of sales data in the form of tables, OK.
**[00:15:35]** And what I want to do is every morning, let's
**[00:15:38]** say someone from my sales representative sales department would like
**[00:15:42]** to generate some insights from the data without this data
**[00:15:45]** agent.
**[00:15:46]** My current process is they have some certain set of
**[00:15:49]** questions.
**[00:15:49]** They will be sending that question to ADBA and that
**[00:15:52]** DBA will be running series of SQL statements, generate the
**[00:15:55]** starts and finally share that with let's say the sales
**[00:15:58]** executive.
**[00:15:59]** That's a very long and tedious process.
**[00:16:01]** How we can solve those kind of problems?
**[00:16:02]** So here first thing first, if I go into the
**[00:16:06]** data tab, I can add multiple data sources.
**[00:16:10]** So I can also add something called Azure AI Service.
**[00:16:12]** So if you have, if you are familiar with Microsoft
**[00:16:15]** Foundry, there is a service called Foundry IQ or Azure
**[00:16:18]** AI Search where you can index a lot of enterprise
**[00:16:21]** data sources.
**[00:16:22]** You can bring the data from there or you can
**[00:16:25]** also use the data sources that are already available inside
**[00:16:28]** your fabric.
**[00:16:30]** So for example, I already have this particular warehouse added
**[00:16:36]** data agent Lab.
**[00:16:37]** And let me quickly show you what exactly what exact
**[00:16:39]** information that we have.
**[00:16:41]** So in this particular warehouse, I have 4 tables like
**[00:16:44]** the customer information and a lot of different products that
**[00:16:48]** I have and also corresponding information about this product.
**[00:16:52]** So I added that as my data source over here.
**[00:16:56]** And if I go to the setup, I can click
**[00:16:58]** on the agent instruction.
**[00:17:00]** And what you see here on in the middle section
**[00:17:03]** is the instruction that I have given to my agent.
**[00:17:05]** Again, this instruction are you had to give it like
**[00:17:08]** just like you're writing a system prompt for your agent.
**[00:17:12]** The more descriptive or more detailed you you instructions you
**[00:17:16]** have, the better results you will get with your data
**[00:17:18]** agent.
**[00:17:19]** You can all write this instruction in the markdown format
**[00:17:22]** and you can see the corresponding results in the below
**[00:17:24]** below as well.
**[00:17:26]** And once that is done the next thing is then
**[00:17:28]** in the test pane here you can start seeing running
**[00:17:32]** the experimentation like for example let me rerun this question
**[00:17:36]** one more time like what are the top 10 most
**[00:17:39]** popular products of all time.
**[00:17:41]** Let me just clear the chart history and fire up
**[00:17:44]** this question over here.
**[00:17:47]** So now to get this information what the data agent
**[00:17:50]** will be doing is based on the user query and
**[00:17:53]** based on the instruction its going to run the analysis
**[00:17:56]** against all this data of that tables that we have
**[00:17:59]** added and behind the scene its constructing the SQL queries
**[00:18:03]** on the fly and it will be running the SQL
**[00:18:05]** queries and whatever the response from the SQL queries are
**[00:18:09]** coming back.
**[00:18:10]** The agent will again then go through the post processing
**[00:18:12]** step.
**[00:18:13]** Well based on my question and based on the instruction
**[00:18:15]** of my agent it will be finally showing me the
**[00:18:17]** results.
**[00:18:18]** So if you're interested how exactly the sources was made
**[00:18:21]** you can click on expand over here expand response and
**[00:18:25]** you can see here this is the data that came
**[00:18:27]** back and these are the steps your agent has done
**[00:18:30]** behind the scene.
**[00:18:31]** So if I expand this, these are the SQL queries
**[00:18:34]** that the agent data agent has fired up behind the
**[00:18:37]** scene and this was the output of the SQL queries
**[00:18:39]** were there.
**[00:18:40]** And finally based on my instructions and based on my
**[00:18:43]** query, it came back with this kind of answer over
**[00:18:47]** here.
**[00:18:48]** Now my data agent is working as expected.
**[00:18:50]** Now the next step is I had to publish this
**[00:18:52]** agent like for example if I go to the publish,
**[00:18:55]** this is where you can provide the description of the
**[00:18:58]** agent.
**[00:18:58]** Another feature set you will see that is I can
**[00:19:01]** also make this agent available like Fabricate Data agent available
**[00:19:05]** inside my Microsoft 365 Copilot as well.
**[00:19:08]** So my users can just add mention that agent and
**[00:19:11]** start interacting with that.
**[00:19:13]** And once I publish, and if I go to the
**[00:19:16]** settings pane, this is where I'll be seeing the name
**[00:19:20]** of the data agent, I'll be seeing the description.
**[00:19:25]** And once the agent is published, this agent is also
**[00:19:29]** available as an MCP endpoint.
**[00:19:31]** For example, you want to consume this agent, but you
**[00:19:34]** don't want to consume this on Microsoft 365 Copilot.
**[00:19:37]** You want to use your own open source framework or
**[00:19:39]** you want to use your own custom map.
**[00:19:41]** To do that all you have to do is you
**[00:19:43]** have to make the call to this custom MCP server
**[00:19:46]** URL that you can use.
**[00:19:48]** Another way for consuming this agent is I can also
**[00:19:51]** add this agent inside copilot studio.
**[00:19:53]** So copilot Studio is one of the SAS product that
**[00:19:56]** is available within Microsoft ecosystem where you can create multi
**[00:20:01]** agent solutions.
**[00:20:03]** And if I click on add an agent, there are
**[00:20:06]** various ways I can add agent.
**[00:20:08]** I can also create another child agent inside Copilot studio
**[00:20:11]** if I expand this.
**[00:20:12]** I can also bring the agent that I created using
**[00:20:14]** fabric as well along with some other options.
**[00:20:17]** So if I click on the fabric I had to
**[00:20:19]** create a connection and once I create the connection then
**[00:20:22]** based on the connection I have created whatever the fabric
**[00:20:26]** data agent that user have access to, I can bring
**[00:20:29]** in and start it right using that inside my Kopala
**[00:20:32]** studio agent as well.
**[00:20:34]** Another way to do that is I can also create
**[00:20:36]** an agent in Foundry and inside the foundry I can
**[00:20:39]** also add that data agent as a knowledge source as
**[00:20:43]** well.
**[00:20:44]** So the the beauty of this is I can create
**[00:20:46]** my agent once and I can consume that across multiple
**[00:20:49]** different products or services.
**[00:20:53]** With that, we come to an end.
**[00:20:55]** If you have any follow up question, please reach out
**[00:20:57]** to me.
**[00:20:57]** These are my contact details and this QR code will
**[00:21:00]** take you directly to my LinkedIn profile.
**[00:21:02]** With that, thanks for joining and have a wonderful rest
**[00:21:04]** of the conference and safe travels.
