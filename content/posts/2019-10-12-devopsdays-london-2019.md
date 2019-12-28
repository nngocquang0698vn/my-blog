---
title: "DevOpsDays London 2019"
description: "A writeup of the DevOpsDays London conference, and the talks and Open Spaces I attended."
tags:
- devopsdays
- devops
- cloud
- events
- monolith
- microservices
- testing
- security
- git
- sre
- on-call
- legacy-code
- agile
- ethics
- aws
- empathy
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-12T12:56:51+0100
slug: "devopsdays-london-2019"
image: /img/vendor/devopsdays-london-2019.png
---
Note: This is a lengthier writeup than I'd hoped to do, hence it taking a little longer to be written, so feel free to dive into the sections you're interested in.

I had a great time at DevOpsDays London 2019, after the [great time I had at 2018]({{< ref "2018-10-25-devopsdays-london-2018" >}}), and am really glad I went back again.

Paul Clarke has a great GIF slideshow to give you a bit of feel about what the event was like:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">That was <a href="https://twitter.com/hashtag/DevOpsDays?src=hash&amp;ref_src=twsrc%5Etfw">#DevOpsDays</a> London - amazing work on inclusion, content and...food <a href="https://t.co/1JRkYXunCd">pic.twitter.com/1JRkYXunCd</a></p>&mdash; Paul Clarke (@paul_clarke) <a href="https://twitter.com/paul_clarke/status/1177613127871016961?ref_src=twsrc%5Etfw">September 27, 2019</a></blockquote>

# Inclusivity

[As with last year]({{< ref "2018-10-25-devopsdays-london-2018" >}}#inclusivity), DevOpsDays London is without a doubt the most inclusive conference I attend:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">This is an awesome level of effort from <a href="https://twitter.com/hashtag/DevOpsDaysLDN?src=hash&amp;ref_src=twsrc%5Etfw">#DevOpsDaysLDN</a> to make this an event that has no boundaries or barriers for folks to join in, such a great length they go to, and I hope other conferences follow suit <a href="https://t.co/pMY9C0gmZj">pic.twitter.com/pMY9C0gmZj</a></p>&mdash; Jamie Tanna | www.jvt.me (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1177145808933806081?ref_src=twsrc%5Etfw">September 26, 2019</a></blockquote>

I just want to, again, applaud the great work the conference does. As a very privileged person, I'm not the target for most of the things they do to make it accessible to everyone, but I can still very whole-heartedly appreciate it.

It's also an amazing way to make those more privileged think about their privilege and the things they take for granted and could be doing to make their own spaces more accessible. With things like making our pronouns more visible, it goes a long way to normalising it for cisgendered folks, so everyone is used to seeing preferred pronouns for everyone, rather than it being a way of "outing" folks who are transgender / non-binary.

# Prioritising Trust While Creating Applications

<span class="h-card"><a class="u-url" href="https://jennifer.dev">Jennifer Davis</a></span>' talk was all about building security into the product, rather than an afterthought.

We heard about the impact that security mishaps can have on trust from the public (read: any of the security breaches in the last few years) and that there's no way to buy it back, you have to earn it.

Jennifer spoke a little about the awesome service [Have I Been pwned?](https://haveibeenpwned.com/), and the scare it'll give you once you see how many (often under-reported) data breaches you've been part of.

Jennifer mentioned that as humans we often don't want to deal with the difficult/complex things, so instead put them off until it's as late as possible. The risk with this is that security has to be built in from the beginning otherwise you'll likely need to refactor your applications quite a bit to get it in the right state.

Like having perfect resiliency or availability, there's no such thing as perfect security. You can strive for good security, or really good security, but the field moves on quickly, and it's too costly, to try and build it unbreachable. Often in the security field you'll hear that "it's not a matter of if you have a breach, but it's when".

Just like with continuous learning and improvement of your product, you need to make sure that you're revisiting your security.

Jennifer started by taking us back to basics and talking through the CIA model:

- __C__onfidentiality - only the people who should have access to the data, do have access
- __I__ntegrity - the data should be durable and only people who should be allowed to change it can change it
- __A__vailability - your data isn't useful if it's locked away and unreachable, so you need to give (the right) users access to it

Jennifer spoke about how security bugs are down to incorrect implementations that can be then taken advantage of, whereas a security flaw is an intentional mis-implementation of the code, such as the thinking "we'll revisit this later, it'll get us live for now".

Jennifer spoke about how defence in depth is the best approach, but instead of making it a big-bang rollout, look at an iterative solution. We heard a little bit about how we need to be careful of dependencies on Free/Open Source/Proprietary software that has vulnerabilities that they need to resolve. Jennifer mentioned that we need to be confident in our ability to raise potential security issues in i.e. meetings, where you can pick up on them before they've got as far as being typed on a keyboard, or to your users.

Jennifer mentioned that if we're starting to see that security is being seen as low priority, being put off or not fixed entirely, then it's a sign of a systemic issue which you should be worried about! Security should be more important (if not as important) as your feature delivery - if your users' data is leaked, they won't care that you just shipped a new cool feature instead of patching that security hole!

Jennifer spoke about how we should be looking to gather statistics on the things that a user can do from a given page, and what logs can tell us of these interactions, as well as who could be able to read these logs! And Jennifer made sure to stress that just because you've had a couple of failed logins doesn't mean someone is trying to hack that user, it could be that they're trying to type their password when they're still groggy from waking up, or they've had a couple of drinks too many.

Jennifer mentioned that it's worth looking to test against the [OWASP Application Security Verification Standard Project](https://www.owasp.org/index.php/Category:OWASP_Application_Security_Verification_Standard_Project).

We heard a little bit about threat models, which is a great way of mapping out the different ways that a bad actor could try and breach your system, looking at what they could be trying to gain access to, and what next steps they could take.

We heard a little bit about the architectural trade-off of security, and about how we should be trying to outsource some of this security where possible by using i.e. the cloud provider's MySQL offering which will be set up in a hardened fashion, instead of spending your own time trying to duplicate that work but inevitably realising that you could've spent that time better on feature delivery. The whole point of the Cloud is to allow the cloud provider to take on the operational burden, and for a small cost, reduce work on the team.

Jennifer also warned us about those tutorials you find online, which make it really easy to deploy an application or service. Jennifer mentioned that things that are easy to deploy are usually insecure by design as a secure system should be partly difficult to get up and running.

We heard a bit about the fact that specialisation is important, and that although DevOps seems like "let the developers do all the jobs", you need to still have testing staff who know what they're doing, as well as having folks trained in security! Both are used to help reduce risk, while we still want to have some level of thinking done by the developers, as well.

We heard about using static analysis and coding standards as a way to make sure that the code you're writing is secure. Linters can help pick up on subtle bugs, like [Apple's `goto` security bug](https://nakedsecurity.sophos.com/2014/02/24/anatomy-of-a-goto-fail-apples-ssl-bug-explained-plus-an-unofficial-patch/), not just regular coding style issues! And picking up on these coding style issues can pick up on poor consistency and poor use of programming patterns. Then, by having a coding standard, you can make sure that everyone is consistent, reducing the risk of a security bug being introduced by some seemingly innocuous code, written a little bit differently.

Bringing up specialisation again, looking to introduce secure code review and pairing with security folks is also super important. Even asking "what does CIA have to do here?" and thinking about whether those log messages you've added could be sharing more stuff than you really need. Think about what's going to go wrong, and add something into your comments / source code to show that you've thought about it, for future readers!

Jennifer shared [Jason Hand's presentation _Building a Minimum Viable Incident Response Plan_](https://jhand.co/CreateResponsePlan) as a good starting point for your organisation to look at how to respond to security events, which is really key. They're _going to happen_ no matter how hard you try to prevent them, so you want to make sure that you're prepared for them!

Consider how you're going to use your resources to _identify_ issues. Then, how are you going to _assess_ the impact of the issue, and ask questions like how long the issue has been there for. Finally, you need to understand how to _remdiate_ the issue, including thinking about what the projected impact is if left unresolved.

Jennifer left us with a few closing thoughts of what to think about next:

- identify the security maturity of our organisation
- assess the valuable practices that we're doing right now
- encourage folks learn security skills and broaden their knowledge
- incorporate feedback into our organisation
- update the threat models we have to ensure we're thinking about current attacks

A final thought from me is that security is never sleeping, and always looking for the next way to attack, so you need to stay vigilant too!

# Building and Growing an Agile Team

<span class="h-card"><a class="u-url" href="https://twitter.com/thatagile">Tom Hoyland</a></span> took us through a 12 month journey that led to his team working more efficiently because the team had managed to uncover all of their dependencies, blockers, and hidden work that wasn't previously visible.

Tom spoke about starting with this team and taking them through to being one of the best teams in the business (by their own definition of "best", of course) and working really well together. Tom mentioned that he very consciously wanted the team to do nothing when they started. That is, not to change anything about how they worked, as they wouldn't know what they should be changing.

Instead, Tom started to measure everything the team did, trying to understand how the team worked. After some time of understanding how things currently worked, they could move forward and change things afterwards, where they had more facts to rely on.

Tom shared how this constant gathering of metrics was able to lead to more informed decisions down the line, but also making sure that folks _don't know_ they're being measured, as it leads to the Observer Effect.

Tom shared how helpful it was to have a single view over the team's backlog, instead of there being lots of secret, disjoint backlogs from the tech side, the core business needs, the User Experience teams, etc. By bringing this, and all other dependencies and bottlenecks (such as compliance/security, meetings, tech debt) to the surface, the team was finally able to actually reason about their velocity and capacity in a meaningful way.

Tom talked about splitting their large team into squads, one squad who would work on the "commodity" work, which was all in a known domain, with known technology, and the other squad who'd work with bespoke problems, with unknown domains or new technologies. This was a great way to stabilise the throughput of the team, as it meant not as much context-switching.

Tom mentioned that the commodity squad is a great place to put new folks into, as they can learn a lot of the team culture and workflow without having the worry of being in uncharted territory where not as much support is possible.

Tom also shared how, when starting to see bottlenecks, the team borrowed ideas from the Scrum methodology and moved to become a bit more cross-functional, sharing the workload across disciplines. This not only gave even more collective ownership, but it also made the team a lot more well rounded, and more importantly, empathetic, as more of the team could understand why i.e. the business analyst wants to read Gherkin, not your code's unit tests.

This also helped with owning things like the testing integration environment, where it's no longer the testers' responsibilities, but everyone as a group.

Tom talked about how they noticed that the team's cycle times increased by a factor of several days - but it turns out that actually, that'd always been the case, they just didn't know.

Tom talked about [squad healthchecks](https://labs.spotify.com/2014/09/16/squad-health-check-model/) as a great way to get actionable feedback on the team's health over time, and that it provides some more metrics that can't be gleamed from burndown.

A very interesting approach towards the end of the journey was to split stories into the smallest conceivable piece of work that could be delivered, which allowed the team to build muscle memory from the sheer amount of repetition they'd be going through, as well as making it possible to uncover blockers in your workflow. An example was that a slow deployment that you do a couple of times a day isn't too bad until you're deploying 30 times a day, and you are going on at a snail's pace.

Interestingly, the size of stories were actually the same size, but could cut cycle time down from 7 days to 2 days, purely because all of the little blockages in the delivery/development pipelines had been resolved.

Tom talked about how an organisation can only be as agile as its least agile team, and that all the work they did to cut down their cycle times was for nothing, as it was then a painful process to get things into production, as there were a lot of things they'd not considered before building their project. Off the back of this first discovery, they then embedded the Operations side of their work into the planning, refinement and development of their applications, leading to a DevOps team.

By thinking about security, compliance and monitoring up-front, the 2 hour meetings for putting services into production were now 12 minutes. By making the questions visible ahead of time, these sessions were largely just ticking boxes and confirming everything was thought of. The up front thinking was now tackled by "war games", where various stakeholders would get in a room and look at how they would react to processes/software breaking, and how the teams would respond and resolve them.

Tom shared that we should look to create performance corridors from our various sets of metrics, which will allow us to notice when things aren't going so well, as well as being able to predict whether the team are getting better or worse.

One of my personal pain points is having to do things manually. I'd much rather write a little script to do a task I'll do a few times a year, than to do it manually each time. But Tom spoke about how we need to make sure that we automate _the right things_ rather than just automating all the things. This fits quite nicely with the mindset of "manual until it hurts", where you leave it until the last possible moment, so you know you're definitely automating it the right way.

Tom spoke about how, over time, the team culture changes, especially as new folks join and bring their own ideas about how things could work. This is really important, and that we learn to keep looking at whether these practices and values are still true.

But to start off, we need to have a set of rules, which are binary, such as "the pipeline breaking is everyone's issue" or "do a good job first time", as well as values, which are analogue, such as the team should be empowered to enact change, or should be focussed on their goal. These are really key in being able to bootstrap a team's culture growth, and give them a shared mission to move forward with.

This was a really interesting talk from Tom, and I think that as I join a new team that is mostly still settling, maybe we'll look to see if we can start to take in some of these tips.

# DevOps and Legacy Code

<span class="h-card"><a class="u-url" href="https://hankeln-consulting.de">Oliver Hankeln</a></span> and <span class="h-card"><a class="u-url" href="https://pgoetz.de">Peter Götz</a></span> spoke about how to bring DevOps to a legacy codebase / product, and the difficulties associated with it.

We heard about how you want to be in a place where you're not scared of releasing new changes to production, or sleepless nights of "what if I get called?"

But why is it so hard to be making changes to Legacy software, or moving it to a DevOps style of working?

Legacy software is often built with brittleness i.e. using vendor products that aren't built with the Cloud in mind, tight coupling between components that are very difficult to break down, limited subject matter experts who are continually becoming more specialised, meaning it's harder to communicate and work with them, and likely more manual processes than are usual, because "it's fine to do this if we only release 1-2 times a year".

But the issue with these are that they're all known problems/processes with known solutions, so what makes it so difficult? The issue is that these all come together, and they're interconnected issues, and it just gets a bit overwhelming.

In my day job, I work with an off-the-shelf Identity solution, which is a vendor-provided piece of software. It's been around for a while, and hasn't been built with the Cloud in mind, as it predated popular Cloud usage. It's been built with on-prem in mind, where you have full control over whether a server will experience downtime, and without worries of network partitions where i.e. Amazon's Ireland datacentre is disconnected from the world. Trying to use it in a modern world situation where connectivity could be lost at any point in time hasn't been easy!

We heard a bit about the coupling that occurs in applications - architecture, infrastructure and code.

## Architecture

One example they shared was how they had a utility that made `Hello <title> <name>` easier to generate, which was being used in many places across the codebase.

This was used as a way to learn a bit more about creating a microservice with its own build/test/deploy pipeline, which then spawned a blueprint for use with other work in the future.

As an aside, a library function like this, in my opinion, makes more sense as exactly that, a library function. I say this because externalising this then means you have the impact of an HTTP GET / HTTP POST across an unreliable network, and a lot of extra complexity. But I do know that there are pros around being able to update it for clients without them needing to change, so it's a difficult one.

## Infrastructure

We looked at a sample application which had a web server running an e-commerce website, which stored a given user's shopping cart in memory. This is all good until the server starts to receive a lot of traffic and you need to start looking at how to scale horizontally. In this case, adding a second server means you need to implement sticky sessions, with users always returning to the same instance of the web server to get their same cart data.

This then adds greater complexity in network routing as well as application management, and means you can't i.e. take one of those servers down for patching without migrating those cart sessions, or intentionally kill some customer sessions.

The solution for this is to move your dynamic data into the database sitting behind the application, which means you can scale the application as you need to without worrying about persisted state in those web servers.

## Code

A poor legacy code pattern would be to have, every time you want to interact with an HTTP endpoint, you use a low level HTTP library. Then, when you want to migrate to a different library, or update some common configuration across them, you have to manipulate large parts of your application, instead of modifying a common helper utility.

By thinking about "what if we wanted to change this down the line", you can start to architect your code in a way that will be more resistant to change in the future, especially through patterns like dependency injection and the use of interfaces over just instantiating the object you want in the constructor.

Another interesting thought was what happens if you want to replace the underlying protocol i.e. moving away from HTTP to another method? Would your application be able to cope with it?

## Big Bang Rollouts

Another interesting point in the talk was about the mindset of "let's refactor this for two years and then release it all at once", which is almost never going to be possible. These migrations must be iterative, and should be done by looking at what's the most pressing issue, fixing it, and then looking at the next.

A great nugget of wisdom was that legacy code takes time to grow bad, and so does it take time to fix it!

# An Engineer's Guide to a Good Night's Sleep

<span class="h-card"><a class="u-url" href="https://twitter.com/nickywrightson">Nicky Wrightson</a></span> gave a really interesting look at what on call support _should_ look like. Having been on call for the last two years, and looking at re-shaping what our current on-call looks like, I feel like this came at just the right time.

Nicky started off by telling us about one of her worst experiences with an overnight call-out. She mentioned that she is unable to remember this call, but apparently she thought James Bond was calling her up to give her a mission! Nicky used this light-hearted story to highlight the fact that having people woken up won't always be productive for you!

Nicky spoke about starting on a greenfield project at the Financial Times and getting the chance to decide what the support model should look like for the team. Nicky mentioned that empowered teams means that teams should also control their support and what that entails. She talked about how she wanted to do the right thing for the team, and make sure they had the personal support they needed, but also the project was being supported at the right level, too.

Nicky spoke about a more recent experience she's had working on an existing platform, which wasn't exactly in an ideal state. It was so flaky that all consumers of the application would add their own caching on top of it, allowing them to handle to the regular impact of increased latency.

Taking ownership of the platform wasn't the real issue, though, it was the sudden change in required SLA for incident resolution. Nicky mentioned that they've moved from their own custom container orchestration system to Kubernetes, and through other refactors they've all but removed out-of-hours call-outs to 3rd line support, meaning engineers really do get a good night's sleep!

But the most important takeaway I've taken from this talk is the following:

> build a system that can limp along until people are awake the next day

This could be that the system fails mostly gracefully if components are down, or it could be that you give your support teams enough to recover at enough of the platform that customers can still use it, and then when the full teams arrive the next day, you can get it up to full steam.

Nicky had 5 approaches to de-risk call-outs.

## Engineer's mindset

Nicky mentioned that this is most often developed from "battle scars" that engineers receive over time, and that help think about "how can we build this right". Charity Majors says it well:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">might be biased, but I think former sysadmins make the best software engineers. operability is *never* a secondary concern. <a href="https://t.co/76HUHgWzqM">https://t.co/76HUHgWzqM</a></p>&mdash; Charity Majors (@mipsytipsy) <a href="https://twitter.com/mipsytipsy/status/1081622073405927424?ref_src=twsrc%5Etfw">January 5, 2019</a></blockquote>

As Nicky mentioned above, engineers should own their support models.

One option that Nicky's had good success with in the past is that there are two teams on call, and the incident management folks will round-robin the teams. If they can't get through to one team, they'll try the other.

Nicky mentioned that this meant support was more relaxed, with folks able to go out for a bike ride or spend a bit more time with the kids, or maybe even pop in for a pint or two after work. They made on-call work around their life, not vice versa.

On call should be compensated for, and should be voluntary, and preferably not out of hours! For in hours work, the whole team should get involved, looking into what's happening in production, and maybe even looking at incidents that happened overnight that no one was called for.

The on-call folks then get time during their working time to invest in improving the platform; with dedicated time to improve supportability, alerting and even the support model itself, you can actually make some headway rather than it being an afterthought.

One thing Nicky made sure to stress was that when we're building software, we make sure that we consider whether a given error condition could be calling us out, and what we can do to prevent it being a high-severity incident.

Finally, Nicky mentioned that we should be designing severity levels within our own service, such as a warning level being raised if there's a high severity security patch that needs to be applied, but that maybe doesn't need to wake up the whole company for.

## Don't get called out for things that can be done from office hours

This is another great point by Nicky - we should be looking to minimise things that are risking engineers' sleep if they can be handled during the day.

Releases that happen during the day shouldn't be calling out an engineer overnight, because we should know very soon after the deployment whether things have gone horribly wrong. Unfortunately, change is almost always the cause of incidents, and incidents lead to call-outs.

For instance, if you've got a batch job that needs to be sent overnight, do you need to do all the processing overnight too? Or could you collect the data over the course of the day (alerting folks if there are issues) and then just actually send it overnight. Alternatively, can you replace these batch jobs with real-time processing?

You'll likely have more experienced (and awake) staff during the day, so if you can make changes when they're around, why wouldn't you?

We also heard a little bit about the stigma of deploying to production on a Friday, of which almost all the audience seemed to feel the fear of, despite the fact that we should all be happy pushing code at any point in the day, on any day.  This is likely a gap in your own development process and shows that you likely don't have enough evidence of risk mitigation to feel comfortable pushing to production.

[Charity has a post that's worth a read on this, titled _Friday Deploy Freezes Are Exactly Like Murdering Puppies_](https://charity.wtf/2019/05/01/friday-deploy-freezes-are-exactly-like-murdering-puppies/).

Your deployment tooling should be able to deploy, but also rollback, in a fully hands-off way. It shouldn't need to wait for one of you humans to notice a pattern, as computers are way better at it. But computers can only do so much, and only as well as we tell them to verify things, so it's worth having your own production test accounts that you can use to test whether things are actually working as well as they should be.

Nicky briefly touched on the usefulness of canary deployments and being able to find out with as limited customer impact as possible if things are going to break or not.

Nicky also referenced [_Testing Microservices, the sane way_](https://medium.com/@copyconstruct/testing-microservices-the-sane-way-9bb31d158c16) as another good read.

## Automate failure recovery where possible

As we'd already heard, computers are faster at noticing things going wrong (as long as you teach them how to detect it), and especially better than a sleepy engineer who's just been called out. If you can get your platforms to be self-healing, then you'll likely not impact anyone's sleep.

But this also means that you need to architect your applications in the right way. They need to be able to cope with change:

- handle termination gracefully (i.e. without corrupting data)
- they need to be transactional
- they should ideally be queue-backed
- they should be able to restart cleanly
- state should not be stored in the application, otherwise sticky sessions make things a whole lot more complicated for scaling

Nicky spoke about the ability to very easily perform a cross-region failover automagically. Nicky spoke about the importance of testing these things before they go bad, which [Euan Finlay's talk _Don't Panic_ at last year's DevOpsDays London]({{< ref "2018-10-25-devopsdays-london-2018" >}}#dont-panic) goes into in a bit more depth.

Nicky warned us against the care required in performing these failovers, and ensuring that the new stack doesn't get infected by the same root cause as the first, leading to both becoming unhealthy or failing altogether! Nicky recommended that to avoid this, you should run a rolling update to be able to ensure that only a few instances are affected at a time, giving you a chance to validate the change before switching more over.

Nicky also mentioned that we shouldn't necessarily trust our healthchecks / liveness probes, as we may miss things like garbage collection suddenly hitting, or the fact that the application responds to a healthcheck but the connection to a downstream service has failed because of i.e. a Security Group change.

Something interesting Nicky has seen work is that if it looks like there's an issue with their Kafka setup, they'll try to (automatically) restart the consuming service once. If that fixes it, then they won't alert anyone. If it doesn't fix it, then someone will get notified. This helps save time when it could be down to the consumers having issues, which has turned out to solve a lot of the issues!

## Understand what customers _really_ care about

Until you understand what your customers really want to do with your services, you can't define what the SLAs are going to be. Find what the critical paths are for customers, and what you need to protect the most.

For instance, with the Financial Times, they need to be able to break news. If that isn't available, then there's a big problem. For other issues on the platform, it's likely not as important.

Nicky touched on this mantra from Sarah Wells:

> Only have alerts that you _need_ to action

Sarah's reasoning was that you could alert on lots of different things, but unless it's honestly worth getting you out of bed, what's the point? You'll likely rewrite the service before fixing the root cause of the alert so don't add the noise or alert fatigue.

An interesting concept I'd not heard before was synthetic requests - a way to send a realistic request through the whole system (whether that's one you've made up, or are replaying a real interaction with the system) that allows you to send a constant flow of traffic through your platform. This helps you decipher those situations where you're unsure whether things are a unusually quiet, or are actually not working at all (as Nicky referred to it, Schroedinger's platform).

## Break things, and practice how to recover

This was all about looking at bringing Chaos Engineering to your organisation, and not only what if services aren't available, but what about if things get really slow, or if certain services start sending intermittent errors?

And one step further, Nikki lets us in on, is what happens if you simulate outages, but don't tell anyone? Chaos engineer the relationships between your delivery teams and incident management, and see how everyone copes with things going wrong as a way to (somewhat) safely practice incident response.

By practicing and seeing what can be done to break things, you'll be able to spot your single point of failures, and help you get used to how to sidestep/overcome it. Following on from Tom's talk about the super-thin stories that become second nature, get the teams used to the failover process and to the point where they could literally do it in their sleep!

When incidents do happen, make sure that the information in the alert gives you everything you need to action it, and make an informed decision straight away, ideally without needing to delve into logs or graphs.

And again, Nikki stresses, don't try and fix everything! Stick a crutch under the system to get things working good enough for your customers to keep using the critical stuff until the teams are in for the day, and can properly fix things.

# YAML Considered Harmful

<span class="h-card"><a class="u-url" href="https://twitter.com/emanuil_tolev">Emanuil Tolev</a></span>'s talk shared how we, as engineering groups, should be noticing YAML as a code smell.

One of the key reasons that we chose YAML as a configuration language was that we had human readable comments, but at the cost of whitespace sensitivity which leads to huge indented blocks that can be difficult to visually parse.

You can use tools like [YAML Lint](https://yamllint.com) which can help pick up on issues like you needing to quote numbers or the words `yes` and `no`.

Emanuil gave us an example of the [GitLab CI configuration for GitLab](https://gitlab.com/gitlab-org/gitlab-foss/blob/master/.gitlab-ci.yml), and how it's roughly 1100 lines, which then call out to shell scripts which are likely hundreds of lines themselves.

Emanuil shared that if we need a Domain Specific Language, we should do exactly that! Instead of faking it and saying "oh this is all just config", we should be truthful to ourselves about what we actually need.

Emanuil then spoke about how there are a few other options for us:

- Jsonnet - JSON as a language, plus ability to use functions, imports and variables
  - This is mostly a language itself, so actually why not just use a language?
- XML - this is well-defined, allows for very easy validation of schemas, but can be overly verbose and difficult to hand-craft
- JSON - no comments or multi-line strings, so not ideal for large bits of configuration
- INI - a bit of an "old-school" format, which does what it needs to but isn't as popular
- TOML - allows for hierarchy (without requiring whitespace) and can be quite nice to write

Emanuil urged us to consider how we can advance as engineers if we're building our applications in a configuration format, instead of in code.

I felt quite an affinity with this talk, as someone who over the last few years has been working with an off-the-shelf vendor product that requires more tweaking than code, so has to spend a lot of like looking at JSON files, which are used to configure the rest of the application.

Interestingly we didn't hear about the [security risks of YAML](https://arp242.net/yaml-config.html) - it's worth looking into if you're unaware.

# All aboard, Meetup Mates! How we’ve set sail towards making the Meetup scene in London fun for everyone.

I've written about this more at [Meetup Mates](/mf2/ef3229fd-63a3-4fba-b861-9dba605855fb/).

# Unleash your DevOps with Serverless

<span class="h-card"><a class="u-url" href="https://medium.com/@jonvines">Jon Vines</a></span> spoke about their own definition of DevOps as "increasing the flow of feedback and learning".

We heard a bit about a Serverless solution being one that costs you nothing if no one is using it.

And we went through a journey on redefining the responsibilities for developers and operations folks over time as you bring in more and more new tech, such as serverless.

# Panic Driven Development

<span class="h-card"><a class="u-url" href="https://carolgilabert.me">Carol Gilabert</a></span> shared a story about pushing a change to production before anyone noticed it was her changes that broke.

This story is better hearing it, so I'll update this post with a link to the video when it's live.

It was really interesting hearing about the importance of quality gates to help safely push things to production, but Carol went on to say that we shouldn't just be having quality gates because we need to be happy with what's going to production, but also as a form of empathy. We need to think about new folks (to the team, organisation, software engineering as a whole) who need to be given the ability to try new things (and hopefully break things - it's a great way of learning), but finding out that they've broken in a safe way.

# Z-agility - we need to talk about mainframes and modern engineering practices!

<span class="h-card"><a class="u-url" href="https://twitter.com/adihere">Aditya Vadaganadam</a></span> spoke about how there's lot of modern engineering processes that are being used with mainframes, and that we need to get more folks involved.

It's no secret that folks don't want to work on mainframes, and that the engineers who do know how to work on them are _literally_ dying out. Aditya wanted to share how mainframes may not be "cool", but they're here to stay, and still have about 68% of the world's workloads.

Aditya shared that we need to look at the three choices we have:

- containing the mainframe, and putting changes onto open systems
- kill the mainframe, and migrate workloads away
- tame the mainframe, and make it work with us

As we're underinvesting in the mainframe, it's only increasing the tech debt and making it more difficult for the next folks working on the project.

An interesting look at the other side of legacy code and the "monster" that sits beneath it, and how "we need to tame it".

# Open Spaces

Next, we had the Open Spaces, one of my favourite parts of the conference, as its a great chance to hear from other folks about how they do things. Often, these folks who are in the spaces with you don't have enough material for a full talk, or the confidence to do one, but can share a tonne of insight in a smaller group.

Unfortunately because these aren't mediated by anyone from the conference, it's up to the group themselves to decide how people talk (i.e. by raising hands) and it can lead to some stronger voices in the room continuing tot talk a bit more than they should do, as then you lose out on the less strong, but often much more insightful, voices.

It was also a bit more difficult in this year's set up to hear things, as a lot of the sessions were in spaces where there were a lot of other things going on, such as other sessions, or being next to the sponsors / exhibitors.

# Running Open Source Ethically

This session was sparked by the recent [controversy with Chef's contract with the US Government's Immigration and Customs Enforcement (ICE)](https://www.vice.com/en_us/article/mbm3xn/chef-sugar-author-deletes-code-sold-to-ice-immigration-customs-enforcement) and folks' unhappiness at their Free/Open Source code being used for evil.

We spoke a bit about the ability to use licenses to legally restrict bad actors could be a solution, although currently it wouldn't fit within the official definition of Open Source. There is [a great article](https://anonymoushash.vmbrasseur.com/2019/09/22/dont-just-do-something-stand-there/) by <span class="h-card"><a class="u-url" href="https://www.vmbrasseur.com/">VM Brasseur</a></span> talking about the risks of fragmenting what "Open Source" is defined as.

We talked about the difficulties of knowing that if you release something as Free/Open Source software, you have the risk that someone could be using it for something you morally/ethically agree with.

Although you are the moral controller of the software, and have moral obligation to do things in an ethical way, you can't legally do anything to stop people using your code (at least while under the term Open Source).

One participant mentioned that they work for the Ministry of Justice. That means that some of their software is used for building prisons. That's something they have to deal with daily, even though it does some good it is at the end of the day a prison. But they do say that you have the choice of who you work with commercially.

There was some discussion around privilege with ethics. For instance, marginalised groups wouldn't have been able to make the same statement that Seth did without wider repercussions.

We wondered about whether we could set up a union/group that could sit across many companies/communities, as a way to make more of a stand to companies who are acting unethically. This may make more of a statement than lots of folks on Twitter/Hacker News, and provide strength in numbers.

We talked about the lack of a professional ethics for Software Engineering, to which one participant mentioned that [the Association for Computing Machinery (ACM) has recently revised the _ACM Code of Ethics and Professional Conduct_](https://www.acm.org/code-of-ethics).

We talked a bit about whether Seth should've been able to yank the project himself, even though it was written under employment at Chef, even though it was still under his personal account not a Chef-owned repo.

We spoke about how the risk of making licenses more complicated is twofold. Firstly, it'll make it less likely that companies use projects with these licenses, harming the community in the long run, such as what we see with strong copyleft licenses like the GPL not being allowed in large enterprises.

And finally, we don't want to make it a case of "who has the most experienced lawyers", because a big evil company will win that game!

Fortunately, or unfortunately, the current state of licensing does not give us the ability to restrict how others use our work. We want to give software away under a license, and have to let is be used regardless of the person. We can build tools, not weapons, but what if those tools are used to make weapons?

As I'm writing this, it's been found that [GitHub also deals with ICE](https://www.latimes.com/business/technology/story/2019-10-09/github-ice-contract-employee-oppose), and that folks looking to move to i.e. GitLab.com will find that [GitLab aren't doing anything to look at who they work with ethically](https://twitter.com/techgirlwonder/status/1182045393292427265).

# Testing Infrastructure

This open space was so incredibly popular that we had to split into three large groups to discuss this. In my group, we basically ended up with the answer that no one had solved the problem, and everyone was interested in solutions.

We cleared up the fact that we didn't want to talk about testing our provisioning / configuration as code, such as Chef / Test Kitchen, nor did we want to check that our tools call to the AWS SDK correctly.

Instead, we wanted to validate that the infrastructure we're expecting to create, is then created. For instance, is this Terraform setup to create a new ELB + ASG + EC2s in a new VPC going to work?

We talked a little about why you'd want to test infrastructure, namely to find out issues before you get to production, especially with "risky" changes such as Security Groups or IAM roles, but also things that can be quite time costly if you get it wrong such as RDS or EKS. In the case of IAM, it's not just "has this policy applied correctly" but "does this policy give me the access I want?"

It's an important balance of risk - how important is it for you to know that a specific piece of infrastructure will work? If very, then get some more quality gates around it!

Some participants shared that they would regularly clean out their lower environments, as a way to ensure that they can recreate it all, from scratch, whereas others mentioned they use a separate AWS account altogether.

There was a mention of [Gruntwork's terratest project](https://github.com/gruntwork-io/terratest) which allows testing Terraform code, but no one in the group had any deep experience of it.

One participant shared that the [AWS Cloud Development Kit](https://github.com/aws/aws-cdk) has a `diff` functionality to show, similar to `terraform plan` what changes are going to be implemented.

One participant talked about [Hashicorp Sentinel](https://www.hashicorp.com/sentinel/) which allows for policy-as-code that happens between a `terraform plan` and a `terraform apply` to ensure that you're creating compliant resources. [Capital One's Cloud Custodian](https://github.com/capitalone/cloud-custodian) does similar, but likely won't integrate _as well_ for companies using Hashicorp products.

We talked a little about platform engineering teams who want to put out a blueprint for other teams to use, but they need to test that it'll work. This is a difficult one because it's hard to test it when you don't know all the ways teams are going to use it - but you can at least try to cover some of the common patterns, with some exploration work done with teams first.

We spoke a little bit about stubbing the cloud provider in your tests using i.e. [localstack](https://github.com/localstack/localstack) which is useful up until a point, but really the complexity is in the glue between services like IAM/Security Groups, so mocking it out won't help for a lot of the complexity, although it has its place for local testing.

There was a bit of a discussion around where do we stop with this testing? Do we trust anyone has implemented anything correctly? While working with a commercial off-the-shelf identity solution, we should trust that our vendor provides all the correct implementations and that they've tested everything fully, but we have also found defects before through our own extra testing. One suggestion was "trust but verify", just to make sure things are actually as they seem.

And finally, there was a discussion about not wanting to be always testing in a sandbox (account), but that we need to be testing in our real environments that will hopefully be closer to our production setup.

An interesting session, although unfortunately no silver bullets!

# Onboarding New Team Members

In this open space, we wanted to look at how we get new folks up to speed on everything when joining a new team/project.

We talked about the fact that documentation, although correct at one point in time, may no longer be the source of truth. Although it's possible to keep the setup guide updated regularly (as long as you have a lot of churn, as one participant put it) it's unlikely you're regularly going through your documentation to ensure it's up to date. Maybe something we should all take away is that we review what we've currently got, and see what we can do to improve it.

We talked a little about the different depth of detail / assumed knowledge we'd possibly need to change, but being careful to not assume knowledge because i.e. a mid-level Java developer doesn't necessarily know every Spring Web library inside-out.

We also talked about whether this is being done as a knowledge handover or as part of a way to train a new person up, and that it's important to make sure that it doesn't feel like a knowledge dump. One participant shared that a way to do it is to have i.e. a set of cards/post-it notes that each have a topic on it, and that your new hire needs to go through and learn all the things they need to. This can be sourced by the team, rather than one person thinking about what they need to know.

However, this can be quite a daunting thing to dump on a new person, saying "hey, here's a physical manifestation of _all the things_ you need to know".

One participant shared that seeing an infrastructure diagram of what services talk to what isn't as useful as how things actually work together, and what sort of user journeys they can be part of. It can be very helpful, in a weird way, if you have lots of postmortems or learning reviews following incidents, because it's a great way to understand more. I've personally learned the most from things being broken in integration environments, and having to piece through logs to find out what's broken.

We talked about pairing as a way to get knowledge across, getting the new person to drive and to see what sort of things block them, and help them understand what's going on together. One suggestion was to go with an iterative explanation, looking to get enough knowledge to unblock them, but as they need more details, provide more info.

However, there's also the viewpoint of neurodiversity and the fact that some folks may find it very difficult to pair. The first thing you should do is _ask_ whether the person in question feels comfortable pairing, and if not, don't force them - pairing is hard enough when you're willing and in the right state of mind that day, but can be really difficult if you're not. You could ask them to work on their own and ask you questions if they get blocked, but not require very strict pairing.

There was a bit of a conversation about looking at "what's weird in the codebase", as a way to drive out some interesting design decisions, pieces of tech debt or shortcuts that have led to issues down the line. This could be quite interesting, as it shows the process over time, and the realisation that it wasn't necessarily the right solution.

We talked about whether it's OK to try and teach all the things at the start, or whether you can leave them to learn on their own, with the potentially cumulative cost of mistakes making it harder to unlearn certain things.

Although everyone hears it said, and agrees and says they'll remember it, it can be very difficult to be happy with not understanding a thing completely. Unfortunately with modern software development where teams own a slice of the stack which then sits on top of other platform(s), there's too much to keep in your head, and especially when you're new, is too much to try and go for.

Instead, one suggestion was to find out who knows what parts of the codebase, and ask each of them different questions about things. Don't ask the same person each time, so you don't annoy them, but also as a way to get a wider understanding.

We spoke a little about how often capacity / velocity isn't impacted nearly as much as it should be while folks are upskilling, but also the existing team helping them with the knowledge share.

It can be really difficult getting new team members feeling like they're contributing, but I found it so useful when I joined my team and within a couple of weeks I was writing "production" code. That was so cool, and was such a confidence boost, and it really makes it feel like a worthwhile decision to join the team.

One interesting discussion we had was around the fact that it was mostly assumed that new team members were junior, but that's not always the case! We spoke about how with more senior folks, there's a higher expectation of what the person knows, but you should always ask what they know instead of assuming it! We should be mentoring/coaching in a constant way across the levels, but likely won't require as much time with the more senior people.

Something to always think about is that people have their own ways of learning and that we need to respect that. We need to ask people how they learn, and cater what we have towards that. It may not be a case of having everything prepared all of the time, but it will at least help with being more prepared to try and cater for different folks.

How do we know if we're not sharing knowledge in a helpful way? Well, our mentees need to tell us! Ask them for feedback, and action it, making sure we **??**.

Remember that not everyone comes from a Computer Science degree background, so we need to make sure we're not making wild assumptions on understanding and background.

We heard a little about how it is the whole team's responsibility to impart knowledge and to get the new people up to speed. This not only gets everyone spending more time with the new person, but also helping them to get different perspectives and learn where the rest of the team's strengths lie.

It's always important to remember to stress that it's a safe space and that it's OK to say you don't know, even if it's really frustrating where you have to keep dialing back your explanations to explain more of the background.

Also, remember that new folks may not be comfortable in asking questions of their peers/seniors, so you need to remember that you, as a more confident person, should do that for them. I do this quite a lot, asking questions that I could feel others in the room are thinking, or to make sure things are extra clear, even if no one else asks it, because I'm comfortable questioning a lot of the why.

It was noted that the questioning culture / mindset of understanding how things work is much harder to teach than a lot of technical skills or static knowledge.

A very interesting way of ensuring that knowledge is shared in the team is to enact Chaos Engineering for people:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Great keynote by <a href="https://twitter.com/drensin?ref_src=twsrc%5Etfw">@drensin</a> on Chaos Engineering for People Systems <a href="https://t.co/ugFCgd9sjo">pic.twitter.com/ugFCgd9sjo</a></p>&mdash; Marius Ducea (@mariusducea) <a href="https://twitter.com/mariusducea/status/1177272261293641728?ref_src=twsrc%5Etfw">September 26, 2019</a></blockquote>

This helps ensure that there are no single points of failure which can often happen when there are folks not in the office. This goes one step forwards to even do things like always give wrong answers - I like it!

One participant shared that getting new folks to own a new project / feature is a great way to give them some ownership of their own learning, while also being in a safe environment to fail. This also has the added bonus of being able to show off the work they've done to others, which proves to themselves that they know the thing, because they've just shared all the things they've done with others.

We also heard about the difficulties it brings when you move into a team and know _more_ than others, as it can lead to you wanting to change things, or tell people they're wrong. As this participant described, they instead wrote down everything they wanted to change / implement, waiting about a month, and found that by the end of the period they'd realised that nothing needed to be done, as there were reasons for all the things they wanted to change.

We spoke a little about the way that if your teams don't have some level of churn you're not going to be able to test out your onboarding process, but one participant suggested that we use secondments or bootcamps into other teams as a great way to gain that understanding as well as way for folks to increase their own social network and improve competencies outside their core areas.

As one participant described the quality of documentation - "if you still have to tell people things, your documentation could be better".

As an aside, I'd thoroughly recommend getting into the habit of [writing blog posts as a form of documentation]({{< ref 2017-06-25-blogumentation >}}), preferably public and on your own website, so they're yours and can be non-company specific. I've found this has been a massively useful way for me to store bits of useful information and grow my collection of tips and tricks that I can hold on to regardless of which team or company I work for.

# Fighting toxic working environments

<span class="h-card"><a class="u-url" href="http://alexstanhope.com">Alex Stanhope</a></span>'s talk was a really interesting look at what makes up a toxic environment, what the impact can be on your physical and mental health, though the means of a number of scientific studies into the impact of stress on physical and mental health,

Alex shared that generally, we as humans are able to work out when things are wrong, or at least that they're suboptimal. But it can be very difficult to call it out when we notice it, and not just sweep it under the rug, thinking "that's just the way things / those people are".

Alex also spoke about how a toxic environment could mean that people aren't confident enough to raise concerns which could be attempting to resolve issues that, at the end of the day, cause harm to others.

Alex spoke about how we should have a bit more empathy, being careful not to make seemingly innocuous jokes at others' expense, like the way that backend developers often look down on frontend developers as just "playing with crayons", not considering the real difficulty of working with CSS!

This can be especially dangerous with folks who feel they have much more to lose by speaking up i.e. if they're trying to go for a promotion or they're on a visa. This puts the more toxic folks in a really dangerous position of power, which can make things even worse by knowing they hold a lot of the power.

It was also interesting to hear about the [Jungian shadow](https://en.wikipedia.org/wiki/Shadow_%28psychology%29), and the way that folks won't necessarily share everything about themselves with their colleagues. I've definitely seen this in the past with respect to mental health impacts in-team not being shared openly, and resulting in unnecessary deterioration. By consciously (or maybe unconsciously) hiding these things, we are limiting who we are, and removing aspects of ourselves which makes us more human to others.

So what can be done if we see this? Managers are the ones who can likely make the most difference, by empowering people and giving them the belief in themselves to help break out of negative impact from toxicity. Clarity on what's happening behind the scenes can be useful, i.e. if there's a lot of organisation changes behind closed doors. Additionally, giving the more negative folks training to help them understand how they sound, how they're behaving and down to even the words they're using and the connotations that leads to. Look to assess the team's contribution as a whole, not looking at certain individuals. Managers need to beware of them being the issue, too, as they could be making it an environment that the team don't feel comfortable talking to them either because they're part of the problem, or that they haven't been nipping the toxicity in the bud, and are instead allowing it to continue.

Alex commented on the way that the talk he was giving was recorded, and if he said something awful that'd be recorded forever, and that he'd have to live with that forever. He recommended imagining that every interaction in your life was also recorded, and that you made sure to not say anything awful you wouldn't want following you around for years to come.

However, managers aren't the only people that can make a difference. We're not all managers, but we are all leaders. We have the capacity to make a difference, be it to fight against it or to elevate others so they can escape it. Alex shared the thought that there's no bystander in a toxic environment - you either contribute to it, you are complicit with it, or you fight against it.

I can see this in the past that I've not made comments in environments like this, and that's then made the situation worse, or that the toxicity has then started to spread, and for that I do apologise.

Alex shared that although it is a sensitive subject, we should be talking about our mental health. Others need to know how we are, and see the full picture of the person. If you're having a bad week, but your team just think you're being a bit lazy or insular, that doesn't really help anyone, does it? I spoke up in my retro the other day about the fact that I've been feeling quite a bit of burnout recently, and although it's great I did speak about it, it was too late, I should've called it out much sooner.

To start to break these toxic environments down, we should be calling out people on toxic behaviour, and make them reconsider what they're doing. That is not to say, however, that we humiliate people by making it a very public, awkward situation, but that others are made aware of bad conduct.

We also need to make sure that before we're calling out others, we see the behaviour in ourselves and we "embrace our inner crapness". We need to realise that we're not all amazing, and that we do some pretty bad things ourselves. Look to improve yourself before calling out others, although I would say that it shouldn't stop you if something _obviously awful_ is happening.

One thing that's been proven to make a big difference to the impact of toxicity on your life is that you help others - by helping others it lightness your own mental/emotional load, and can have lasting health benefits!

And remember that if toxicity was easy to detect, there would be a metric for it, and then no one would be sticking around in environments that it was detected in!

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">If any of these sound familiar, you may be in a toxic workplace - <a href="https://twitter.com/alex_stanhope?ref_src=twsrc%5Etfw">@alex_stanhope</a> is sharing some really insightful knowledge bombs at <a href="https://twitter.com/hashtag/DevOpsDays?src=hash&amp;ref_src=twsrc%5Etfw">#DevOpsDays</a> <a href="https://t.co/8dtAvaJyYd">pic.twitter.com/8dtAvaJyYd</a></p>&mdash; Jamie Tanna | www.jvt.me (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1177513152914706432?ref_src=twsrc%5Etfw">September 27, 2019</a></blockquote>

# How and why we lowered our SLO, and other SRE life-lessons

This was an interesting talk from <span class="h-card"><a class="u-url" href="https://twitter.com/Debs_za">Deborah Wood</a></span> from Pivotal about the reasons why you'd find that, actually, you don't need as much uptime as you think.

We had a quick-start guide to Site Reliability Engineering, which helped get everyone up to a good working knowledge for the rest of the talk - I found this especially good as my knowledge of what SRE is about is particularly lacking.

We heard about how investing in increasing number of nines isn't a great idea unless your users _really need_ the extra reliability, because otherwise it's a waste of time, money and complexity!

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Finally a great explanation of what &quot;nines&quot; relate to what downtime, thanks <a href="https://twitter.com/Debs_za?ref_src=twsrc%5Etfw">@debs_za</a> <a href="https://twitter.com/hashtag/DevOpsDays?src=hash&amp;ref_src=twsrc%5Etfw">#DevOpsDays</a> <a href="https://t.co/LwMV9CQkGe">pic.twitter.com/LwMV9CQkGe</a></p>&mdash; Jamie Tanna | www.jvt.me (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1177520030713634816?ref_src=twsrc%5Etfw">September 27, 2019</a></blockquote>

Debbie spoke about the real challenge:

- keeping users happy
- manage the tension between innovation and reliability
- maintain all the things
- manage conflicting needs

Debbie spoke about needing executive buy-in, largely to get everyone agreed to a policy, and to be able to get someone else to put pressure on when things aren't abiding.

So why did they drop their SLO? After a while of exhausting their 34 minutes of error budget, while having lots of slightly risky production deployments and some incidents, the team had to think about whether their SLO was being a bit too restrictive.

After looking into it, they realised that having 127 minutes of error budget didn't seem to impact the users too much, and gave the team more room to move.

And with SRE, the whole point of having this error budget is to make sure that you're using it! If you don't burn through the allocation, your product could be stagnating, or you may not be pushing out patches that you need, and worst of all, you'll be training your users to expect a higher availability!

With these amounts of budget, you can use it to practice whether you can perform a cross-region failover of your database, to help you validate whether you'd be able to handle the failover if it ever happened in real life.

The biggest take away from the talk was to reconsider what level of uptime your users actually need, so you can plan accordingly, instead of assuming they need a higher level of uptime than they really do.

# Digital inclusion: designing for everyone

<span class="h-card"><a class="u-url" href="https://blog.helen.digital">Helen Joy</a></span>'s talk is one I've seen before, and it's such a great talk about a really important topic.

It's worth a watch when the talks are uploaded from the conference, but the main takeaways are that we really think about our users and their level of technical skills. For Helen, working at the time with building applications to be used with the Driver and Vehicle Standards Agency (DVSA) which would be sitting in a mechanics' garage.

Speaking to several of the users, there was one, "Keith", who said he had very few technical skills. But you could be building for someone who has purposefully not wanted to use tech.


Helen shared that 4.3m adults in the UK have zero basic digital skills (i.e. using a search engine, sending an email, verifying the source of online information). That means that if you're relying on your user to know where the search bar is because it's the same as every other app, you're likely locking out some other folks!

We heard a little about how we need to design for all accessibility needs, and all levels of users, because as progressive as we think the world, is, not everyone has the digital privilege that we do.

# Bringing Product thinking to DevOps

<span class="h-card"><a class="u-url" href="https://twitter.com/oliphantism">Neha Datt</a></span> and <span class="h-card"><a class="u-url" href="https://twitter.com/marcelbritsch">Marcel Britsch</a></span> spoke to us about implementing DevOps, but thinking of it more with a product mindset.

It was interesting hearing some of the issues they found when implementing a DevOps culture in different places, and some of the lessons learnt. The most common learning was that they were overlooking some part of the end-to-end value chain, either missing end users or business input in making decisions with how things are done.

As an example, don't look to build a perfect production environment, instead think about how changes get from a developer's machine to production.

# Edward Thomson - Git Top Tips

<span class="h-card"><a class="u-url" href="https://edwardthomson.com">Edward Tomson</a></span> shared a couple of interesting tips for Git.

Firstly, we heard about the difficulties of working with developers on different operating systems, and the risk that some folks will introduce line changes that use a different set of line endings.

To this, Edward warned us against the use of `git config core.autocrlf` but instead to use `.gitattributes`, which is [has a great how-to on GitHub's documentation](https://help.github.com/en/articles/configuring-git-to-handle-line-endings).

This way, you can enforce it for anyone using the repo, as doing it via Git configuration means that developers need to set it up on their own machines before committing code, which we can't always rely on.

Next, we heard about using Git Large File System (LFS) for binary files. Edward shared that the term "binary files" is more in terms of the size, rather than whether they are purely in a binary format, and is dependent on how often the files change. If you're committing an image that likely won't change again, then it's OK, but if you have some regularly changing media you'll want to keep that separate from your core Git repo. This will save your repo's size on disk, avoiding horrible diffs, and more cleverly downloads the changes that it needs, instead of pulling all the files all the time.

Finally we heard a little about how to recover data with Git - primarily `git reflog` as a way to find out all the things that have happened to the local repo (which is why I cringe when people say to `rm -rf` their repo if something's gone wrong, because you can recover it with this), as well as the external tool [`git recover`](https://github.com/ethomson/git-recover).

# Nik Knight - Using Coaching Skills to Grow Compassion, Empathy and Kindness in DevOps

Following on from Alex's talk, this was interesting as it was all about helping to ensure that we're making it easier for folks to talk to each other.

<span class="h-card"><a class="u-url" href="">Nik Knight</a></span> mentioned that we should look to embed coaching skills to be more empathetic and compassionate, leading to better working and personal relationships.

We heard about the GROW model as a way to help make things better for your partner:

- __G__oal - what is their outcome? This should be achievable
- __R__eality - it may be a trashfire, that's OK! Before we can press forward, we need to know-how things currently are (but being careful to not try and solve things)
- __O__ptions - what could they do next, and what support is needed to help them get there?
- __W__ill - what are they going to do next? This has to be them doing it

This can be a loop through these stages, as long as it ends on Will and the partner going away and doing something to make things better.

Nik also shared the idea of a coaching dojo, which allows groups of three to experiment with this process, allowing for coaching, receiving, and feeding back to both.

This sounds interesting, and a good way of building trust and compassion by helping others.

# David McKay - The DShell Pattern

<span class="h-card"><a class="u-url" href="https://rawkode.com/">David</a></span> shared an interesting talk about how Docker has been seen to be a difficult to work with piece of software, and how we can make it easier to work with.

David shared that not everyone is going to use Docker, we shouldn't _force_ ourselves to use it. However, Docker is hugely useful as a way to encapsulate all dependencies, be a self-documented build process (as described in the `Dockerfile`) and be a deployable artifact, all in one!

David shared the threefold pattern:

1. Use a `Makefile`
1. Add a target for `dshell` and `dclean`
1. __Only__ use `make` targets

Within this, we have three files:

- `Dockerfile`
- `.docker-compose.yml`
- `Makefile`

This Dockerfile uses a multi-stage build, which Docker has supported for some time, and allows you to remove a `Dockerfile.build`, `Dockerfile.test`, etc.

Although it sounded a bit harsh when David mentioned it, it makes a lot of sense looking at it - we want to make it _as painful as possible_ for folks to use Docker natively. It should be hard for them to use their existing tools, so they have to get used to using `make dshell`, so they get an easier interface to it.

It's an interesting thought, and I'll see how it looks when working with some of my own projects.

# Nayana Shetty - Monitoring Decoded, Why What and How?

<span class="h-card"><a class="u-url" href="https://twitter.com/shettyny">Nayana Shetty</a></span> took us through some of the important reasons you'd want to monitor application such as being able to pick up on issues before the customer notices, because at the end of the day we want the customer to be happy.

Navana spoke about how we want to have self-healing architectures which is much easier when working with Microservices.

An interesting thought here was that we should be monitoring each service, not a system as a whole.

Navana shared two models.

First, the [USE method by Brendan Gregg](http://www.brendangregg.com/usemethod.html):

- __U__tilisiation: The percentage of time a resource is in use.
- __S__aturation: The amount of work the resource must (the “queue” of work).
- __E__rrors: A count of errors.

This allows a fair bit of monitoring opportunity, but the risk is that it can be difficult to get all the right data exposed for you, especially i.e. memory usage which can be difficult to model depending on what OS and application stack you're using.

Alternatively, there is the [RED model by Tim Wilkie](https://www.weave.works/blog/the-red-method-key-metrics-for-microservices-architecture/):

- (Request) __R__ate - the number of requests, per second, you services are serving.
- (Request) __E__rrors - the number of failed requests per second.
- (Request) __D__uration - distributions of the amount of time each request takes.

Finally, Navana shared some of the tools we can use to help with this monitoring, such as log and metric aggregation, visualisation, some basic healthchecks, and alerting.

# AbdulBasit Kabir - Moving to Kubernetes, or not?

<span class="h-card"><a class="u-url" href="https://twitter.com/abulkay">AbdulBasit Kabir</a></span> shared the experience of finding that cost on AWS was rising, and they wanted to move to a different platform. The new hotness was Kubernetes, so they though they'd try that, but realised that it was a fair bit more effort than it was worth, for similar costs, and a bit more complexity.

# Standardisation vs Freedom

This open space was talking about how to handle the split between wanting to allow folks to build whatever they wanted and to enforce some level of standardisation. This is an especially interesting subject as we've been talking about it recently at Capital One and how we can empower teams to try new things while still remaining within a controlled space. There were some really great learnings here that I'll definitely be mulling over.

One of the common practices was to have a "toolkit of defaults" which should do enough to get you up and running with the recommended set of tools. This then allows teams who are passionate about writing a certain thing themselves, or using a specific technology to do so, with the caveat that it won't be supported.

Some found that as soon as you say you need to support it yourself, the teams will end up not going that route - it may be a sign that maybe it's not worth the pain, or maybe it's that there needs to be a bit more discovery in that alternate tool before just saying it's not supported?

That being said, some teams suffer from ["Not Invented Here" syndrome](https://en.wikipedia.org/wiki/Not_invented_here) where they want to just rebuild things for the sake of owning it themselves.
We should be building tools that are so easy to onboard to it, that it's a really hard, irrational decision that could convince someone not to go for it.

It was agreed in the room that having lots of small, composable tools that can work together in the platform are beneficial to all. We discussed building the "guard rails" that give folks structure in how they can get up and running and just do enough of the work that they need to, then let them add in their own tools for the cases they need.

Something that folks find are that some teams are very happy to get stuck in to a new set of tools with no support, but others need a bit more time to get up to speed - it's difficult to build things for both, but it could be worth working with both types of teams to see what can be done to get i.e onboarding guides much easier to use.

There was a talk about policies vs standardisation, and how instead of forcing folks to abide by the same toolchains, the requirement would instead be that they need to follow a set of guidelines that if they could fulfill, they could run.

We spoke a little about how to handle compliance as well as policy, because if you've got a regulated business, you're likely going to have some strict rules to follow. Enforcing these over various tech stacks can be quite difficult.

I raised at this point about [Capital One's Cloud Custodian](https://github.com/capitalone/cloud-custodian) which is heavily used internally to enforce this policy-as-code, and we've found as an enterprise it can be really helpful.

One participant mentioned about [AWS Service Control Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scp.html) which provide the ability to add restrictions across your AWS organisations, in a way that it can even restrict users with root credentials to the account - this is super awesome for mitigating security risks for bad actors, or otherwise.

We had a bit of a chat about folks who maintain different sets of tooling, and the difficulties of maintaining parity across both.

There were some interesting chats about how standardisation requires lots of grunt work, regardless of the management buy in, because it is boring, not amazing work. It's an unfortunate fact and leads to people being bored with it - is it really worth it?

There was also a comment around how "a recipe doesn't always lead to the same cake", which was a really good point. If you have everyone i.e using Spring Boot microservices with the same logging library, there's nothing that says they're all going to log the same useful things. Software and infrastructure architectures can be different, despite having the same common tooling. This is OK, but remember that it's not a silver bullet!

We spent a bit of time talking about whether it's worth standardising legacy applications, to which one participant said "if only half the stuff is standardised, then it's not standardised", which was a good point. Either you're going to bite off the whole amount, and force it all to be standardised, or it's not really helpful.

There was a comment about how standardisation is all about repeatability, i.e. how quickly can I build a new application using the same patterns? Is it quicker than the last time I did it in exactly the same way? How easily could I move to another team using the same toolchain?

Another interesting discussion we had was about the shelf life of microservices and that, really, you should be decommissioning the microservice before you rewrite it, so maybe the time should be spent in looking at which ones you can remove rather than which can be updated in line with your standards.

We had a bit of a discussion around making it easy to find common patterns and capabilities, so teams know where they go to get all the information needed to build a new project.

There was an interesting discussion about treating the platform as a product, and to get feedback from your customers, finding out whether they're happy with what's going on. If one team are having problems, it could just be them, but if everyone is then you need to make changes. Getting some metrics on the platform in terms of engagement and satisfaction is helpful, too.

Getting feedback will always be interesting because you'll find a spectrum of answers, from "we hate all build systems" to "give us more options, we want to try different things".

One question that I didn't get the chance to ask was that we used to have an in-house application framework at Capital One, which we've since retired for internal use because it makes it harder for new folks to get started with. Instead, we've gone for building things on Spring Boot with fairly common design patterns. I was wondering if other folks have seen similar challenges - I'm interested to hear others' opinions - get in touch with the details in the footer!

As a final thought from one participant - take away their freedom, as it's easier to support. Optimise for the common case that most people should be doing, build a strong default that folks can use and "just work" but don't require it for everyone.

# How to manage integration test environments without painful change management

I spoke about the pain I feel with a shared integration environment that is slowly growing as more systems integrate and the risk of a service breaking a another system seemed quite painful. I spoke about some issues we had with requiring co-dependent releases, and whether there was anything that could help with managing the environment in a way that would make it possible to be more hands-off and self-regulate rather than requiring actual management.

We had a discussion about how lots of this sounds more like a distributed monolith, and that really, in a _true_ microservices architecture this shouldn't be an issue.

I spoke a little bit about how we aim to work with API versioning and content negotiation, but with some vendor-provided software we use, we unfortunately aren't able to version their APIs as easily, although there is some means we'll be looking to explore in the future.

One participant shared that they were able to run their "integration testing" through the use of Docker containers. Because all the services they worked with produced a Docker container that was easily runnable this made it possible to test as part of the pipeline and determine if there are going to be any breaking changes with either the latest version of the dependency, or at least a specific release.

The participant mentioned that they did not perform full integration testing with third parties (i.e. Facebook) as it was not quite feasible, but it at least made it possible to validate that internal contracts are still abided by.

I noted that this unfortunately wasn't possible for ours due to vendor constraints that meant we wouldn't be able to easily containerise, but that other teams likely could do this, and that it sounded like a great pattern for it.

Another participant shared that they had various suppliers working on providing modules of code for their project, and that each supplier had their own environment to work in, but then there was a system test environment for integrating that code in.

We talked a little bit about monolithic applications and how to split them down, but only if it's actually necessary! Instead of doing it because it's the next new thing, split it if the pain is felt because there are too many teams working on it and it is difficult to build/test/deploy/support, rather than splitting it too early.

One participant shared the talk [From Monolith to Microservices and back](https://www.youtube.com/watch?v=0jODVkkwiMc) that talks through some of the reasons you would actually want a monolith.

It's also worth a read of [the Open Space _What's wrong with a good monolith?_ at DevOpsDays London 2018]({{< ref "2018-10-25-devopsdays-london-2018" >}}#whats-wrong-with-a-good-monolith).
