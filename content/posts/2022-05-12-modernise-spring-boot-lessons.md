---
title: "Lessons learned from modernising a lesser maintained (Spring Boot) service"
description: "What I learned from taking ownership of a lesser maintained service and bringing it up to a better standard."
tags:
- blogumentation
- spring-boot
- supportability
- incident-management
- production
- capital-one
- technical-leadership
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-05-12T08:55:38+0100
slug: "modernise-spring-boot-lessons"
syndication:
- "https://brid.gy/publish/twitter"
---
As part of the recent interviews I've done in the job hunt, I'd been asked about a time that I'd had a bit of push back persuading stakeholders of a piece of work, or working on a complex project. I wanted to write about it in a bit more depth, so it can help others, as well as be a chance for me to reflect on in the future.

Although I may have overstated exactly how much persuading it needed, I wasn't able to just go ahead and do it on a whim, as I needed to get my product owner on board with this, and given it was one of the _very_ key services for the business, it was fortunately a quite easy sell, as it would make us more confident in changes to a moneymaker and reducing time to resolve costly incidents for a growth channel.

Note that although this is using the example of a Spring Boot service, it's hopefully a generic enough problem that you can still take learnings from it, regardless of your tech stack!

# Taking ownership

In my last role at Capital One, I was the Tech Lead of a newly formed team, the Purple Pandas. We were joining a Goal Team with a number of existing teams with ongoing intent, but at the time we joined, we'd not yet ironed out the intent that we'd be working on.

In the meantime, we took ownership of the Partner Quotation API from another team. The idea was to give us a production system to maintain while we were working on other pieces of work, as well as the chance to alleviate some of the pressure on this other team, as they had quite a lot going on!

I want to note, before I go further, that I am absolutely __not__ throwing shade or blame around - I understand why the maintenance was not as highly prioritised, and I'd like to make sure folks don't read into this situation as being common at Capital One. It also wouldn't have been as good a story if it were a very well maintained service, would it?

Incidentally, this service was originally owned by the team I was in before the Purple Pandas, and we'd not maintained it very well before it got transferred to this next team about a year previously, as we'd not had much bandwidth for maintenance while delivering PSD2.

In that year since, the team I'd been on had finished the PSD2 delivery and we'd started getting breathing room to look at improving our services. This was very useful because I got the chance to do this on 7 services that were _very_ similar structure and composition to the Quotation API, and it gave us a strong idea of what "modernised" looks like, as well as applying it in a very cookie-cutter means.

I pride myself in continual improvement of my technical self, and how that relates to services, libraries and tools I use, and want to keep improving what I've got and striving to keep these modern and consistent, where possible. I learned some really great things from my previous Staff Engineer, James, and I made sure to let him know that I wasn't able to hit the ground running as well without his prior art!

(As an aside, you'll see me using a mix of `I` and `we`. Although it was a group effort in the team, I was spearheading the work and leading the overall plan of action, so am uncharacteristically taking a good chunk of credit for it)

# Gauging what needed to be done

As tech lead, it was my job to start off by understanding the gaps in the service if any and put together some initial stories that would allow us to improve it. We knew there was one piece of intent to implement HTTP signatures, and in the weeks leading up to starting the new team I highlighted a few other areas that we'd need to look at.

From one of my previous teams I picked up the behaviour of proactively monitoring the system, looking through logs and monitoring to attempt to see what "normal" looks like for the service, and as soon as I knew Quotation would be one of our services, I started doing this. While starting to get more comfortable with where everything was, I was fortunate to have spotted a couple of incidents associated with this service.

As someone who learns really well from things going wrong, this gave me a really great chance to get a feel for the service's currently monitoring and logging, and see that it wasn't as good as I was used to with other services.

## Initial quality-of-life improvements

I started by looking at some of the things that would improve consistency in contributions to the codebase from the new team, based on lessons learned in my previous team and across the shared libraries community.

Before I wanted us to even start making any code changes, there was the enforcement of a consistent code formatting using the excellent [Spotless](https://github.com/diffplug/spotless). Having an enforced format reduces the need to nitpick in code review, and is really great to remove the need for engineers to have to even think where i.e. curly brackets should be or whether we're using tabs or spaces.

[WhiteSource Renovate](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) was starting to get some traction internally, and I'd seen some teams having some good results with it. I decided it'd be good to set it up for our new service, and it made _such a difference_ over time, and allowed us to constantly stay up-to-date with new releases. I've written up [the learnings](https://www.jvt.me/posts/2021/09/26/whitesource-renovate-tips/) that made it more effective over time, too.

Something else important to me was having [SonarQube](https://sonarqube.org) for static code analysis, to catch issues in PRs, either before a human did, or to catch things that we'd not be able to see, as well as automate some of the analysis of the codebase as it exists.

With this basis done, we could start work on the project, as we had a good set of tools to support changes to the service.

## Signatures work

As mentioned, we wanted to integrate the HTTP signatures work, which I'd ended up doing for all of our 7 previous services, as well as being the main implementer on the library we'd built for it, so I was well versed in the implementation.

What made this a little extra work was that firstly we needed a major version bump for Spring Boot, as the version we were using had just nudged over the point of no longer receiving security updates. This was already on my radar to do regardless of the HTTP signatures work, but it came nicely as a prerequisite we could take to Product.

Once the fairly painless upgrade was complete, it was time to work on HTTP signatures. By implementing the signatures work, it also gave us a chance to further delve into the way the service was tested, and it helped highlight a few things like our need for [environment-agnostic acceptance tests](/posts/2021/01/18/agnostic-acceptance-tests/).

## Suportability

As I mentioned there were issues with supportability. I started by looking at the first issue we were facing - that we'd receive alerts in our monitoring to tell us a specific partner is having issues, and then when we go to our logs, we have no clue which partner the logs are for. This was information readily available, we just need to make sure that they were configured in our logging format.

Once we added the partner IDs to logs, we realised that although we could see the shape of errors, this highlighted a lack of logging around consumer-facing errors. Gateway logs showed that there was a 400, but app logs didn't say what. Next step was to add more information about errors to the logs, as well as any [errors from the Spring web framework](/posts/2020/10/29/spring-log-all-exceptions/).

With more information about who was getting what errors, we started to want to track down a specific interaction. Although we were using [tracing IDs](https://www.jvt.me/posts/2021/11/22/correlation-ids/), we did not log these due to the way our logging configuration was set up. Again, we tweaked our configuration to add these, as they were available in requests, we just needed to populate them in our logs.

Once we added these, it highlighted that in a few cases we were seeing duplicated uses of a singular tracing ID. Looking at this, it appeared that this was due to a miscommunication in the documentation, which we corrected, and spoke to affected folks.

With a greater ability to filter our logs for the errors occurring, we were able to see that there were cases we had tracing ID being malformed, which was due to the case-sensitivity of UUID formats, which required we do a bit of tweaking and sending it correctly to downstream components.

With all of these changes, they were done iteratively - I used this as a chance to ship small features to production regularly (which wasn't as common at the time in the org) to make sure we were comfortable with the release process, as well as not wanting to change too much to begin with.

Finding it awkward to use the pattern-based string log format we had in the service at the time, I wanted to moved to structured logging. I started off by using a fluentd regex to parse the string format which was horrible, and I made clear we didn't want to maintain long, but did the job and gave us our first taste of it.

We then moved to fully JSON structured logs as per [my article](https://www.jvt.me/posts/2021/05/31/spring-boot-structured-logging/) and it highlighted we had useful info in the logging context we never knew about, as we previously had to manually map each piece of logging context manually.

With all these in place, we could very straightforwardly track down where errors were coming from, whether they were expected (i.e. bad data from a customer that hasn't been validated client-side) and we got some great feedback from support folks that it was better than what we had previously!

## Test coverage

A very common issue to see in a codebase you've not created is lower test coverage than you'd like, and this was the same. I started by using tools like SonarQube to highlight the percentages and gaps, augmented with some manual work to discover areas to investigate.

Although code coverage as a metric isn't super accurate - especially as we may have covered the line but not exhaustive arguments that could go into the method - it was a good way for us to start understanding the codebase and look at areas that were lacking. It also didn't give us great visibility of whether a unit, unit integration or component test covered the lines, just that it was covered, so we still needed to dig through the code to understand. In the future we could consider looking at mutation testing as a means of discovering gaps in our tests' implementation, too.

Instead of just going in and trying to increase from the lowest coverage upwards, I looked at what areas were very important, such as validation of user input and other pieces of business logic. It was then a case of looking at where the coverage was, and seeing what we could shift left, as the tests were very component-level heavy, which were slow and required the whole application and its stubbed dependencies to be running locally.

While we were doing this, we did an upgrade from JUnit 4 to JUnit 5, as 5 has a tonne of great features we wanted such as [easier parallelisation](https://www.jvt.me/posts/2021/03/11/gradle-speed-parallel/).

As a later follow-up, I noticed that this service's tests had a lot of overlap with a couple of other services in the Goal Team, which all looked at Quotations. For this, I created a common library that each set of tests could use and give us the opportunity to reduce a fair bit of duplication across tests.

# Outstanding changes

Now, there wasn't all the time in the world to get things finalised, so there were still a few outstanding pieces of work:

- Finish the coverage
  - We'd got to a good level of coverage of some of the main validation pieces, but there were a few things to improve, or to shift further left, such as [testing JSON serialisation](https://www.jvt.me/posts/2021/06/02/testing-json-spring-boot/) and a bit more core business logic
- [Introduce a JSON Schema](https://www.jvt.me/posts/2021/12/16/api-object-schema/)
  - As this is a partner API, it would make things _much_ easier to have a means for consumers to rely on a machine-parseable format for the response bodies that ties directly to the codebase, whereas we had our documentation separate to the Java classes. Although we didn't spot any inconsistencies, that's always a risk where they're not aligned, as well as the documentation slowly coming out of date compared to the code.
  - This would also make onboarding much easier as the validation rules, which can be described in JSON Schema, would directly correlate with what we did in code!
- Introduce domain objects
  - We'd reused the HTTP layer objects across the service, and used it for HTTP layer interactions as well as data transformation to then be sent elsewhere. As part of my investigations into [Onion Architecture](https://www.jvt.me/posts/2022/01/28/spring-boot-onion-architecture/) as well as general architecture patterns, I've seen the light of having a specific domain layer that can be used regardless of the API/eventing contract

# Lessons

So what did I, and we as a team, learn from this whole process?

## Learn what "good" means for your project

When going into the project, there were a few things that I deemed to be a good requirement for a maintainable project:

- Consistent formatting
- Static analysis scanning and code quality metrics i.e. SonarQube
- Supportability
  - Do the logs provide all the information required to understand what's gone wrong in a given interaction?
  - Does the monitoring give us warning when we're approaching an issue, or only when things have gone wrong?
  - Do we understand the failure modes, and can gracefully degrade service?
- Do the tests have good (~80%?) coverage of business-logic areas?

There were also some other value-adds:

- Are the tests fast, or if not, what can we do to parallelise them?
- Can we shift tests left, so instead of doing a full component test, we could capture with a few unit (integration) tests?
- Are we utilising internal shared libraries / Open Source where possible to reduce the amount of effort we're putting on ourselves?
- Are we following consistent patterns across teams/the ecosystem, so a new team member could onboard more easily?

## Automate what you can do to get an idea of what's up

Where possible, see what you can automate to give you a set of high-level areas to look at. You can then use your human perception to prioritise this list further and take it as a plan of action, but making it so you don't have to read through 1000s of lines of code you've never seen before is beneficial.

For instance, using something like WhiteSource Renovate or Dependabot, you can work out just how far behind software updates you are. Manually doing this would be painful, so outsource it!

You can use measures like code coverage to understand whether there are areas that are drastically untouched, and weigh that up with whether they're areas that we should be looked at, rather than just thinking "oh we're at 80% that's great!" when that could be just testing getters and setters or trivial methods.

If your project has an architecture you've seen before, whether it's Onion Architecture or packages like `controller`, `service` and `repository`, I'd so thoroughly recommend [using ArchUnit](https://www.jvt.me/posts/2022/01/21/code-standards-archunit/) to enforce structure, as well as any patterns or styles you have.

Static Analysis tools like SonarQube can give you a backlog of items to look at - ranging from "this is a security issue" to "this code could be made more consistent".

## Make changes incrementally

Iterative, incremental changes are great, and gives you a chance to learn whether what you're doing is working, instead of doing a big switchover as part of a big-bang rollout. It's unlikely that you're only going to have one service or piece of work to be doing, so looking at smaller chunks you can slip in with any work that's going out is much better!

(Process involved in releasing, aside - if you can only ship monthly, then you're kinda stuck!)

The initial pieces of groundwork I did around code formatting and quality scanning were to give us a good basis to start operating as a team. These helped make the next changes easier, and even shipping code formatting changes to production was useful, as we could validate the process works, as well as have a tonne of confidence in the release.

## Getting everyone invested

I also found that, after the initial changes to get a basis of the team to be able to contribute to the codebase, we needed to make other changes. Instead of slipping these in under a business-as-usual (BAU) epic, I worked with my Engineering Manager and Product Owner to get prioritised as an Epic, as it was providing business value rather than _just_ being i.e. security updates that would usually sit in the BAU epic.

These "value improvements", as I called them, were a number of the supportability and code coverage changes, and by doing it as a separate epic we got much more buy in, and visibility over progress with this compared to other pieces of product work.

As these were more customer value oriented, everyone was a little more bought in than just thinking of it as paying back some technical debt, and even if it was just putting a bit of spin on it, it still made a good difference.

## Think about supportability / operability

One of the big things we learned was what it meant to make our service supportable - through discussions with our support teams, and blundering through debugging production incidents, we discovered what was put on our support rota wasn't quite as good as it could've been.

One of the things I regularly do with services I own is keep an eye on logs, understanding the traffic patterns, seeing common issues encountered in Production, and learn what we can do better to serve our customers. This proactive monitoring is great to give me an idea of what "normal" looks like but also helps highlight when things are not fit for purpose.

By realising we were missing key information for our support teams, we made incremental steps, over a few sprints, to improve what we produced to make it a supportable system.

Something here that's important is to make sure you're actively seeking feedback from the folks supporting your systems to find out if they're getting what they need to do a great job. In our case, we'd probably have learned that no, it wasn't enough.

## Share what you've learned

Something we did - but not quite enough - while working on this was to share with others what we've learned. By making the learnings visible, others can learn from you, and even if they end up going a different route, they'll at least have had a more informed decision.

Another part of this blog post is to share things wider, because I hope it can be helpful to others to see the thought processes behind the work as well as what we did to solve certain things.
