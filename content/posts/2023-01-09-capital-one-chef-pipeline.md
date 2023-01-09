---
title: What I learned rebuilding our CI/CD pipelines for Chef Cookbooks
description: How a focus on developer experience and user needs helped us rebuild (Capital One's) CI/CD pipelines for Chef cookbooks the right way.
tags:
- chef
- capital-one
- jenkins
- job-dsl
- developer-experience
image: https://media.jvt.me/57345b1a3e.png
date: 2023-01-09T09:30:30+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: capital-one-chef-pipeline
---
As I've written about before on this blog, I used Chef quite a lot when I was at Capital One.

As part of some ongoing work across the enterprise, there was a move to replatform from one set of Jenkins servers (with team-owned maintenance, patching, etc) to an Enterprise managed set of infrastructure using CloudBees Enterprise Jenkins (without that overhead).

I'd been involved in leading and supporting work on various parts of this replatforming effort across the teams I'd been part of for various production services but we'd not yet gotten around to it for the Chef pipelines.

As a heavy user of Chef, and having made efforts to improve the pipelines over the years, I'd been interested in getting involved to help rethink what our Chef pipelines could look like as an ideal state. At the start of 2021, I got the go-ahead to start work on this from the team that owns the Chef pipelines, as it wasn't something that would be on their roadmap until later in the year anyway.

Over those few months, I ended up building it pretty much single-handedly with some support from the team that owned the Chef pipelines for a few bits of access and insight, and we managed to roll it out not long after for teams.

Note that below I use `I` and `we` fairly interchangeably, largely because I've gotten myself into the habit of using `we` when talking about work related things as a way to make folks feel like it's a collective effort, even if it's something I'm doing solo. The work was primarily mine to build and test, and although I did have support from the team owning the pipelines longer term, it was my project to ship.

Unfortunately I ended up [leaving the company](https://www.jvt.me/posts/2021/08/19/joining-cabinet-office/) before I could learn much from real-world usage of them, but I've since caught up with some ex-colleagues who've given me the insight into how things have been since, and as it's all been good feedback, I thought I'd blog about it publicly 😉.

This process taught me a few things, the biggest one of which is that having empathy for your users and what they want out of a system is super important.

Note that although this is about Chef cookbooks, hopefully the overarching concepts should be transferrable from other pacakge ecosystems.

# What did we have previously?

Before we talk about what we changed to, and how that benefited us, let's look at what we had prior to this rebuild.

Architecturally, there were multiple Chef Servers, and we used Artifactory as our Chef Supermarket.

There were 3 main parts of the Chef pipeline that consumers interacted with:

- cookbook upload pipeline
- community cookbooks upload pipeline
- my team's custom multi-branch pipeline

Behind the scenes we also had:

- authenticating to the Chef Server / Chef Supermarket
- authenticating to EC2 instances for Test Kitchen

New cookbooks were onboarded with a job that'd create a job based on a template, but then any future updates, such as adding new parameters to jobs, would require manually tweaking each job in the UI.

## Cookbook upload pipeline

Once you'd made the code changes to your cookbook, and got the changes merged to your default branch (`master` at the time), you would then need to go to the Chef Jenkins server and trigger an upload of your cookbook through the job.

Each Chef cookbook had a single pipeline, which was used to release from the cookbook's default branch, or release a hotfix from a branch. The pipeline sequentially ran a stage to run linting checks (through `cookstyle`), ChefSpec unit tests (if present) and then Test Kitchen integration tests.

Integration tests would be run against Amazon EC2 instances by ticking a `RHEL6`, `RHEL7` or `Amazon Linux 2` box when running the pipeline, and would not fail if no platforms were chosen. There would also be the option of which AWS account to test it in, as some cookbooks were only used in certain accounts.

Unit tests using ChefSpec were absent until fairly recently, due to very few teams using it, and when they were added it highlighted that a few folks' existing unit tests had been broken for a considerable amount of time 😅

If these all passed, we'd then use [thor-scmversion](https://github.com/RiotGamesMinions/thor-scmversion) to bump the version according to the latest commit's commit message.

## Faster feedback through a multi-branch pipeline

The team I was on when I started my work on Chef was working on a commercial off-the-shelf (COTS) identity solution, which meant that we had a lot of configuration to do on top of the code already available in the product.

As a team that was investing heavily in Chef, we felt like it'd be great to get faster feedback. Although we could've set up a Jenkins pipeline on our own Jenkins server, we wanted to keep it as close as possible to the real thing, as we had in the past seen issues between using a newer version of the ChefDK compared to the version used on Jenkins. We worked with the team owning Chef to set up a multi-branch pipeline on their Jenkins for our GitHub organisation's cookbooks, which allowed us instant feedback on PRs, which provided so much value over time.

However, I always felt that this would provide a good deal of value for other teams, especially in the case above where teams would find they had ChefSpec tests that'd been failing for some time, but it just wasn't super scalable due to the way we had set it up for our own usage. There was a fair bit of friction for us, and we'd regularly ended up breaking the Jenkins box (for everyone) due to the way that we pulled in our Gem dependencies, one that [I eventually worked out how to resolve](https://www.jvt.me/posts/2021/03/24/chef-cookbook-gem-metadata/), before we had finally containerised our build.

## Community cookbooks upload pipeline

For local development or for teams deploying using Chef Zero, there was a Chef Supermarket for cookbooks (backed by Artifactory) which mirrored the public Supermarket. However, the majority of deployments were with Chef Client in Server mode, which meant that if we wanted to use a community cookbook, we'd need to sync from Artifactory to the Chef Servers.

We had a job that took a cookbook name and version and would download that cookbook from our Artifactory mirror of the public Supermarket and upload to the Chef servers.

However, if the cookbook had direct or transitive dependencies that didn't have a matching version in the Chef Server, the job would fail. To resolve this, we'd need to look through the dependency graph - either through looking at the Chef Supermarket UI, or reading through the errors - and manually upload the cookbooks in the right order.

## Authenticating to the Chef Server / Chef Supermarket

To be able to connect to the various Chef Servers and Artifactory (as our Chef Supermarket) we needed configuration to do so.

We had a shared set of configuration for communicating with Artifactory which was available by default, and then as we used a number of Chef Servers, these each required their own configuration file and private key. The credentials themselves were securely managed and persisted to a directory on first use, and the configuration was persisted into Git.

## Authenticating to EC2 instances for Test Kitchen

As we were deploying our infrastructure using Amazon EC2, we needed a way to be more confident that the Chef cookbooks worked on a Capital One Amazon Machine Image (AMI) in one of our accounts.

The most common means for doing this is using SSH keys, where we'd pre-configured a different key in each of the AWS accounts we were testing against. These keys would then be selected depending on which account was in use.

## Yearly updates

To keep up to date with the latest feature developments coming into Chef, there would be a yearly upgrade to the latest Chef Workstation (previously referred to as the Chef Development Kit (ChefDK)). Ahead of this upgrade, there would be a few months for cookbooks to continue working on the existing version of Chef Workstation, but then there would be a "big bang rollout" and there would only be the ability to upload a cookbook that was tested against the new version of the Chef Workstation.

To give teams some insight into whether their cookbooks would work on the next version, there would be a "cookbook testing pipeline" during the pre-upgrade period, which would run with the new versions of `cookstyle` and Test Kitchen to validate what changes were required. This didn't include the full set of Chef Workstation dependencies, only the updated version of Test Kitchen with a Chef Client version pinned to the new Chef Workstation's Chef Client version, which led to some dependencies being out of sync.

This pipeline would give, at least for the majority of teams, confidence that their cookbooks would work, but it required teams to check it manually which slowed down teams' ability to plan whether they would be needing to do any work for the upcoming changes. Additionally, the steps to perform these checks didn't parallelise the steps, leading to teams needing to (in my opinion, unnecessarily) fix linting changes, before they could run Test Kitchen to work out if their cookbook fundamentally would work with the new version of Chef.

For the few teams that used ChefSpec, this was absent, so teams may not realise they still had changes to make when it came to the new Chef pipelines being available.

As a heavy user of Chef, my team would generally have a fair chunk of work allocated to investigate the work, and would need to do a fair bit of ChefSpec and some recipe changes, as well as [autocorrecting any Cookstyle changes](https://www.jvt.me/posts/2021/03/14/chef-cookstyle-autocorrect/).

And finally, for teams that did make changes in their cookbooks, there was a chance that they would then be unable to merge the changes and subsequently release them, as the cookbook upload pipeline was still pinned to the existing supported version of Chef, leading to style/linting changes or more fundamental changes possibly not working, and requiring a long-lived PR hanging around until it could be merged.

At the time that Jenkins was switched over to the new Chef version, we would have AMIs released using the new version of Chef, at which point teams had everything they needed to start using the new Chef version and releasing cookbooks that had updated to the latest changes required.

# Requirements

Thinking back over the years of upgrades and general usage I'd had of the Chef pipelines, as well as feeding in some thinking about a new standardised Enterprise pipeline that was landing in Capital One, and some of our nicer pipelines that we'd built for things, it gave me some ideas of what we wanted out of a "new" set of pipelines.

The existing pipelines weren't in any way particularly awful to work with, but as we'd learned quite a few things over the years, it gave us an opportunity to work to a better set of requirements, the biggest one of these being an improved developer experience, and consumers of the pipeline having to think less.

## Docker-based

As we were moving from a single Jenkins instance with a couple of worker agents, to a set of ephemeral Jenkins agents, there was no chance to pre-provision anything so we needed to either rely on the shared worker's installed runtime, or make it Docker-based.

It made most sense to be Docker-based, as we had already been starting to distribute a Docker image that included all the right versions of things that mirrored what was installed on Jenkins, and would make it possible to avoid relying on anything installed on these ephemeral agents.

This also gave a great way to make local builds reproducible with the exact setup that was deployed to Jenkins, if folks so wanted.

## Use Job DSL

As part of the replatforming work for other parts of the business, we'd been leveraging [Jenkins Job DSL](https://github.com/jenkinsci/job-dsl-plugin) for this, as it allowed configuring jobs through code, and allowing us to make it much easier to onboard many new jobs from a single line of code!

This would allow us to drastically reduce the ability for manual tweaking of jobs' configuration, by reducing folks' manual access to the Jenkins folder we'd be using, as well as making it very easy to make changes across the dozens of cookbook pipelines we had.

We had a lot of pre-built code that we could leverage for this with patterns that had been proved to work over several years of active development, and it gave us a great basis to work from.

Disclosure: since leaving Capital One, I've stepped up to become a maintainer on Job DSL plugin, but [I am looking for co-maintainers](https://groups.google.com/g/jenkinsci-dev/c/WtNZKVWVlJ0/m/Zbd7SH_GFAAJ)!

## Groovy-based pipelines

As we were looking to rebuild things from scratch, I wanted to rethink the languages that we were using to maintain the pipelines.

This took a mix of Bash, Ruby and a bit of Groovy in `Jenkinsfile`s, and aimed to convert it to predominantly Groovy. This would allow sharing code more easily, would take advantage of some of the patterns used in other Job DSL repos and experience in the organisation as we had a lot of Java developers who were familiar with Groovy, but would lead to it being harder to maintain for the team that had very little Groovy experience.

## Migrate away from thor-scmversion for versioning

The developer experience for versioning cookbooks with thor-scmversion wasn't perfect, although it was what teams were generally used to. Because the codebase hadn't been touched in almost 9 years at that time, we decided that it was finally time to decommission it after years of gripes.

It'd been something that would fairly regularly cause us some issues with both in terms of developer experience and some issues with the internal code, and would be left with running off a fork if we managed to fix any issues, which wasn't a problem, but wasn't what we really wanted.

The proposed solution was to replace thor-scmversion with simply setting the `version` in the cookbook's `metadata.rb`, which was a fairly common practice elsewhere in the Chef community.

## Multi-branch pipelines for everyone

Instead of having a single job for just uploads, we wanted to provide every team with a multi-branch pipeline to give them the confidence that the cookbook would work before it even landed on their main branch.

## Improved Test Kitchen configuration

As we decided to go for a multi-branch pipeline for everyone, there was no longer an option for manually specifying the platforms that you wanted to test on.

Instead, we wanted to make sure that the pipeline could auto-detect the supported platforms from the cookbook's underlying metadata.

## "Current" and "Next" pipelines

To allow teams to work through cookbook upgrades a little more easily, I considered what it would look like if there were two pipelines.

This would allow a "current" pipeline, which would do the build/test/release process for a given cookbook as usual. Then, when there was a new Chef Workstation version available, the "next" pipeline would start building - alongside the "current" - and start highlighting any issues.

One important thing here was that I didn't want to break the build if there were linting issues, but instead indicate that there was a warning

To prevent teams from unnecessarily planning work to perform Chef upgrades, and then end up not needing to do them, we wanted to provide better visibility into what changes were _actually_ required for the new Chef version.

## Community Cookbooks

We simply wanted to port over the functionality for uploading community cookbooks.

## Controlling Chef versions

A painful part of the upload pipeline was the "big bang rollout" aspect, which meant that some teams were waiting for the new Chef version to be able to start iterating over their cookbooks again.

Instead of this, we wanted to provide a means for teams to control themselves as to whether they use the new/previous version of Chef, and give them a longer window of time to do their upgrades.

Having been on a team that's unable to get to the Chef version upgrade in time for the switchover - due to other high priority work - it would've given us a bit more breathing room.

# What does it look like now?

We ended up building a pipeline that hit all the above requirements, as well as making a few other improvements while we were there.

This meant that we had:

- Job DSL controlling onboarding/offboarding of Jenkins jobs
- A multi-branch pipeline for the cookbook's "current" Chef version
- A multi-branch pipeline for the cookbook's "next" Chef version
- Pipelines executed through a Docker image
- Pipelines controlled through Groovy code with opportunities for extensibility (see [this blog post](https://www.jvt.me/posts/2021/02/23/getting-started-jobdsl-standardised/) for what this looked like)
- Job DSL would re-seed jobs every day, as well as on merges to the configuration, ensuring that manual tweaks in the UI could not be persisted for long
- Very restricted access in Jenkins, only allowing teams to build their jobs, with configuration only being possible through the Job DSL, which required code review by the Chef team
- Added [reporting](https://www.jvt.me/posts/2021/02/23/getting-started-jobdsl-standardised/) for jobs to give better visibility of failures

## Cookbook upload pipeline

Instead of a single job to upload this was migrated to a multi-branch pipeline. This allows for all teams to get faster feedback on their changes to speed up their development cycles.

On a cookbook's configured main branch, uploads would occur.

PRs into the primary branch, or `develop` if it existed, would have integration tests run, but otherwise we'd limit the number of places they'd execute due to requiring fresh AWS infrastructure to be spun up.

Because teams now needed to manage their versioning using the cookbook metadata's `version` property, rather than using commit messages, there was a chance folks would try and re-upload the same version unless a check was added. This checked that the version in the metadata wasn't currently `git tag`'d, and would fail the build if it was already present.

Teams would need to configure the webhooks on their side as a one-time setup, as well as add a shared user to be able to push Git tags to the repo.

## "Current" and "Next" pipelines

The "current" and "next" pipelines were provisioned under the hood for teams when they onboarded their cookbooks. For instance, when the following code ran:

```groovy
factory.createCookbookPipeline('monitoring-cookbook')
```

The Job DSL code would check if there's a "next" Chef client, and if so, set up the "next" pipeline, otherwise leave it disabled.

### More clear indications if work was required for upgrades

As mentioned, a requirement for the "next" pipeline was to make it easier to know if work was actually required to do a Chef upgrade, or if it was just linting or in fact no work at all.

With the "next" pipeline, which took place of the previous "cookbook testing pipeline", it would execute very similar configuration to the "current" pipeline, with ChefSpec or Test Kitchen failures failing the build. This would highlight that teams had immediate action to take, as if they were to use their cookbook on the new Chef version, their application would fail to run.

However, if only Cookstyle failed, it would only mark the build as `UNSTABLE`, which means "passed with warnings", displayed in yellow in the Jenkins UI. This meant that teams would be aware that they'd need to make linting changes when it came to their next changes on the cookbook in the new Chef version, but they wouldn't need to make any changes before the new Chef version was in place.

## Controlling Chef versions

When onboarding a cookbook in the Job DSL, you'd do something like:

```groovy
factory.createCookbookPipeline('monitoring-cookbook')
```

This would use the default version, which for instance was Chef 15.

However, if Chef 16 is ready to go, we could use our "next" pipeline until we've validated things are all good, then change:

```diff
-factory.createCookbookPipeline('monitoring-cookbook')
+factory.createCookbookPipeline('monitoring-cookbook', ChefVersion.Chef16)
```

This would then pin the "current" pipeline to Chef 16, and the "next" pipeline would be unconfigured, as we only support one version in the future.

Alternatively, if we're changing the "current" version of all cookbooks, to Chef 16, some teams may want to pin back to Chef 15, so can do so with:

```diff
-factory.createCookbookPipeline('monitoring-cookbook')
+factory.createCookbookPipeline('monitoring-cookbook', ChefVersion.Chef15)
```

Then they would have i.e. 3 months to completely stop using Chef 15 before the configuration would be removed and they'd be required to use Chef 16, or at least as long as there were still AMIs that were compatible with their Chef version.

This gave teams much more control over the process of version pinning in the most recent upgrade, as well as allowing teams to upgrade before the "big bang rollout", which means temas didn't have to wait week(s) with PRs ready to go, but unable to merge because it may not work on the old Chef Client version.

## Authenticating to the Chef Server / Chef Supermarket

To simplify the setup to authenticate to the various Chef Servers and Artifactory, we replaced potentially long-lived credentials on disk with only fetching them for the specific steps that were needed, and having i.e. our `knife.rb` configuration specified with:

```ruby
chef_server_url = ENV['CHEF_SERVER_URL']
client_key = ENV['CHEF_SERVER_KEY_PATH']
```

As the Jenkins agents that the jobs were running on were ephemeral, it wasn't as necessary, but it made it nicer to ensure that we cleaned up more aggressively.

## Authenticating to EC2 instances for Test Kitchen

To avoid needing to generate and securely manage a new SSH key for Test Kitchen, I [scripted a way](https://www.jvt.me/posts/2021/04/16/kitchen-ec2-dynamic-ssh-key/) to have dynamic keys. This improved things drastically by reducing the number of secrets we needed to manage, and was a pretty cool learning, too!

## Community Cookbooks

While I was on roll with improving developer experience, I wanted to look at whether there was a way to make uploading community cookbooks easier by more carefully determining the dependency graph, which wasn't on the requirements list, but I wanted to see if there was a way to do it.

As noted in [this blog post](https://www.jvt.me/posts/2021/04/18/chef-dependency-graph/) I found a way to construct the dependency graph, allowing the community cookbook job to fetch all dependencies, and upload them in the right order.

## Improved Test Kitchen configuration

We wrote some code that would take the cookbook's `metadata.rb` and auto-detect that the supported OS platforms and versions that it supported. For instance:

```ruby
supports 'redhat', '>= 6'
```

And from this, detect that `>= 6` means that it supports RHEL6 and RHEL7.

We also ensured that the absence of any supported platforms would fail the build, instead of silently allowing a cookbook to be untested.

There was also a case where some teams had multiple Test Kitchen suites that they wanted to run, but we were previously hardcoding it to just the `AWS` suite. While we were tweaking the scope of Test Kitchen, we introduced the all ability to run all kitchen suites in parallel, as a means to improve the coverage folks' cookbooks could be tested with.

# Were the changes worthwhile?

That's a lot of words to explain what was done, but did it actually work for what we set out? The TL;DR is yes, it did.

Firstly, I'm very happy to say that we've had some great feedback from it, and it makes it feel like it was all worth it!

The multi-branch pipelines are making it much more effective for folks doing active development on their cookbooks, and has had some good feedback, although it took a bit of time for some folks to get used to using it in a hands-on capacity.

In the most recent upgrade to Chef 17, the visibility improvements for the "next" pipeline was great, and meant that there were a number of teams who knew ahead-of-time that definitely they didn't need to do any work, even to check if they needed to do any work. The ability to pin the Chef version either to upgrade, or stay on the old version, was also well-used and beneficial.

One thing that we learned for next time is that we should've spent a bit more time working on how we could upskill the team with Groovy and Job DSL, as the team didn't have a tonne of knowledge - and we also didn't have a lot of time to handover before I left the company. However, the team have since been using Job DSL for one of their other projects, so that's super positive!

Overall it was a very beneficial piece of work, and we're really happy with how it went.

# What did I learn?

This process taught me a few things, the biggest one of which is that having empathy for your users and what they want out of a system is super important. Fortunately I'd been a user of the pipeline for ~4 years at this point, so I knew what I did and didn't want out of it as a bit of a power user. At the same time, I sought understanding from a number of folks who were using less intensive cookbooks, but still were big users of Chef. Continuing to learn what people wanted over time, and adapting what I was building was important.

Although I didn't really consider it early on, as time went on, I learned that I had another set of users' needs to take account of - the team maintaining the pipeline. We made some tweaks to fit in a few other needs that they had, which fit nicely.

I learned a fair bit more about Chef, Job DSL and Jenkins in general, and managed to write a dozen(!) blog posts during this period that were related to this work, which is pretty awesome.

As I said above, it was nice to see that it wasn't a collosal flop, and that it did actually work for what we needed, which gave me some great validation in what I'd spent years imagining.

However, as mentioned in [_Does the tech industry thrive on free work?_](https://www.jvt.me/posts/2022/10/22/tech-industry-free-labour/), this was a project I pretty much only did outside of working hours. I made the decision that I wouldn't be able to get it done during my working hours, but that it was during lockdowns in the pandemic and I was happy making that choice. It was a bit stop-start in nature as a lot of the work required making a change, running a build and seeing if that worked, which could take many minutes, so I slotted it in between games of Apex Legends. I found it worked for me, gave me a hyperfocus, and allowed me to get something done I really wanted, but were it not middle-of-pandemic, I probably wouldn't have done the same.

I'm pretty happy with how this whole project went, of what I achieved and the feedback from the users so far, and it just goes to show that if you listen to what your users want, you can build something pretty great.
