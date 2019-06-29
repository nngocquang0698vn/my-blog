---
title: Why You Should Use GitLab.com
description: A discussion about the reasons that I would greatly recommend the GitLab.com platform for all your Git hosting, opposed to its competitors.
tags:
- gitlab
- opensource
- persuasive
image: /img/vendor/gitlab-wordmark.png
date: 2017-03-25T10:51:09+01:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: why-you-should-use-gitlab
---

# tl;dr

> I would say the main difference is GitHub is designed for people who want to collaborate on writing software, but that's where it stops. GitLab is designed for people to collaborate _and_ take that software right through to build and deployment. &mdash; [eddieajua][eddieajua-dear-github]

- Do you want a 'batteries included' platform, that means you can write, build, review, deploy all within the same place?
- Do you want to enhance the process of building software, without having to jump around different services just to get everything done?
- Do you want to be building on a platform that's built transparently and as actual Open Source?
- Do you want to support a project built to support you?

If any of the above questions are 'yes', please read on! Sorry in advance for the wall of text, though.

# On a technical level

There are a number of technical reasons why GitLab is superior to other hosting providers, and should be very strongly considered against using another service.

## Unlimited Public and Private Repos

GitLab.com provides an unlimited amount of both public and private repositories, _for free_. This was the first reason that got me moved to GitLab, especially as it was coming to the end of my time using GitHub's education pack. I had previously used Bitbucket for any private repos I wanted in excess of GitHub's five repos, but when I found that GitLab made it possible to have all my repos on a single service, and even better - _for free_ - I was sold.

## CI

Having Continuous Integration built into the platform is hugely useful. Although CI platforms for i.e. GitHub are great, and integrate nicely, there's nothing better than not even having to leave GitLab to see how your builds performed.

With GitLab's CI, you also gain the option of using Docker-based infrastructure, which means that you don't have to wait for all your dependencies to be installed as part of your CI build, slowing down time to feedback. As you can choose any Docker image, be it from the Hub or a private registry (more details can be found in the [Private Registry section](#private-registry)), you can prepackage the large (or even all) dependencies in an easy to access format, such that your CI can start as soon as the image is downloaded.

This removes a lot of the cruft of configuration, making it possible to "just get it working" much more quickly, and not have to work out all the dependencies required for Ruby 2.4.0 on an Ubuntu 14.04 box - instead, you would specify i.e. `image: ruby:2.4.0` and be done.

Additionally, unlike other offerings, you can run the same CI job locally using the Open Source [GitLab Runner][gitlab-runner], in the same fashion that would be run on GitLab.com's infrastructure. This is a huge plus - no more `WIP: Travis please run this time` commits! Because of this, you can also configure a runner to run on your own infrastructure - for instance if there is some special configuration that would take too long on the existing CI infrastructure.

Finally, using [Docker-in-Docker][dind], you can also build Docker images through your CI pipeline - for instance, this site is built using Docker and an image is published to [my container registry][jvtme-container-registry].

### Private Registry

As mentioned above, GitLab.com provides a private Docker registry per project. That means that if you're using Docker for your project, you can anonymously pull images, and push images easily once you've performed a `docker login`. All you need to do [is enable it][gitlab-ee-docs-container-registry-project] for your project, and then you're ready to go.

Because this is a private registry, too, it means that you don't have to worry about getting a paid subscription to the Docker hub, or work out how to set one up yourself - it all _just works_!

For instance, this is how I [distribute this site][jvtme-container-registry], and I use it for its ability to contain all my dependencies for development, CI, and deployments.

### Environments

Environments are a feature of the CI platform that help capture the different stages that an application must go through before reaching end user consumption, i.e. `dev`, `qa`, `prod`. This is something that is tracked within the [`.gitlab-ci.yml`][jvtme-ci-yaml] file, and then provides an easy way to see what environments are running what code, as well as exposing links to the environments themselves from the GitLab UI:

![The environments page on the repository for `jvt.me`](/img/jvt.me-environments-21-03-17.png)

GitLab also provides the ability to [check out your deployments locally][gitlab-docs-env-ref] - it does this by creating a Git `ref` which then tracks the commit in each environment. This makes it much less effort to determine which code is currently in which environment in a way that requires no manual (or even scripted) work by yourself, as it is handled through GitLab itself, and you can easily hook into it as the link describes.

### Review Apps

[Review Apps][review-apps] are very tightly related to [CI](#ci) and [Environments](#environments) and provide the ability to dynamically spin up an `environment` for the Merge Request you are working on, that will be rebuilt on every commit, allowing for quick feedback in your own production-like environment. Because this is integrated in with the CI, it means that it can be achieved using the same toolset that is used for your staging and production environments. This is great because it means that Code Review doesn't require everyone to spin up the code in a staging environment individually, but it instead will perform all of the workload for you, and let the focus be on reviewing the code and application.

Right now, the code only works for static sites (more details are in the [GitLab Pages section](#gitlab-pages)) but from a conversation I had with [@systses][sytses] and [@ayufanpl][ayufanpl] at FOSDEM 2017, there is a lot of thought and work going into the ability to run full, dynamic, applications through GitLab.

## GitLab Pages

GitLab Pages has a huge advantage over other providers - you can use _any static site generator_ that you want! So that means that if you wish to try out something different than [Jekyll][jekyll], such as [Hugo][hugo], [Octopress][octopress] or [Hakyll][hakyll]. And because this all runs off the Docker-based infrastructure, it's very easy to get started with any of the static site generators, even more so due to [GitLab's provided example repos][gitlab-pages-group]. Additionally, because it's built on GitLab's CI platform, you can run many steps before you publish your site. For instance, I run [html-proofer][html-proofer] against my site, so I can check that all the links within the site resolve correctly.

## Process Improvements

Last weekend, while setting up a new repo for [Hack24][hack24], [@anna_hax][anna_hax] and I found that unless I was given the GitLab `Master` role for the repository, I wouldn't be able to push into `master`. This took us by surprise, but made sense - it's one of those things, you don't want every developer to be able to blindly push in, you'd want to ensure that there is a lot more control over the `master` branch.

By having more of a delve, I found the following options:

![GitLab's approvals section](/img/gitlab-approvals.png "GitLab's approvals section")

In order to make Merge Requests more robust, it can be useful to enforce the amount of approvals that must be given in order to allow a merge to occur. At the same time, there may be specific people in your project that you'd want to perform an approval for, and therefore you can call them out here, too.

<div class="divider"></div>

![GitLab's protected branches](/img/gitlab-protected-branches.png "GitLab's protected branches")

Protected branches on GitLab provide a bit more control over the ability to push and merge - this means that you can limit the two options separately - i.e. you can ensure only your CI or service account can push directly to `develop` (for instance, when running workflows using something like [mvn-jgitflow][jgitflow]) but that any of the developers in your team can perform a merge _into_ `develop`. This extra control can be greatly useful when working on larger, distributed teams, and will make it possible to more tightly restrict access control to ensure that your project is managed correctly.

<div class="divider"></div>

![GitLab's push rules](/img/gitlab-push-rules.png "GitLab's push rules")

In addition, GitLab adds some extra controls over what can be pushed up - such as blocking any secrets, which is common to hear about, and I can see being a great thing to have enabled, for that one time you forget and then end up with a [$6000 AWS bill][aws-bill-6k].

Additionally there can be enforcement on the commit messages, making sure that the messages follow a set format, and that it's committed only from a certain email, or that it's only via a GitLab.com user.

<div class="divider"></div>

![GitLab Merge Requests can be automerged when CI pipelines succeed](/img/gitlab-merge-when-ci-succeeds.png "You can set GitLab to automerge a Merge Request when the CI Pipeline succeeds")

This is another really great feature - having a MR auto-merge when the CI job finishes. No longer do you have to keep checking back to see if i.e. Jenkins has succeeded for the MR. This is something that can be triggered and then you can just go and work on something else, freeing you up to focus on other things. This may not sound like a killer feature, but when you have relatively large build pipelines, this saves you from context switching back and forth to check if things have passed, so you can then merge them.

<div class="divider"></div>

![GitLab stops `WIP` Merge Requests from being merged until the `WIP `is removed from the title](/img/gitlab-wip-merge.png "A WIP Merge Request cannot be merged until the `WIP` is removed from the title")

![GitLab stops `WIP` Merge Requests from being merged until the `WIP `is removed from the title](/img/gitlab-wip-merge-2.png "A WIP Merge Request cannot be merged until the `WIP` is removed from the title")

This is something that I've found when working on teams using GitHub - in order to make it obvious that a Merge Request is a WIP that you don't want merged, it's best to set the title to i.e. `WIP: Add Why-GitLab article` and then add a `DO_NOT_MERGE` label. However, GitLab makes this even easier by detecting the `WIP` in the title, and disallowing merging until the title is updated. Although this seems like a minor thing, it means there's a little less overhead that you personally have, as you can't accidentally merge though the changes (if the CI passes, that is).

# Non-technically

GitLab also has a few reasons that are about them as a company, and how they approach their work.

## Open-ness

GitLab runs a company that embraces transparency and open-ness, and makes it much easier to want to support them.

### Open Communication

GitLab is very different to other companies - most notably how amazingly open and transparent they are with all they do.

In response to the [Dear GitHub][dear-github] letter, [GitLab responded][dear-github-gitlab] to show that there were actually a number of features requested that were already available on GitLab. For the features that hadn't yet been released, there were links to the issues raised on their own issue board, such that anyone would be able to see GitLab's discussion on the progress of the feature. This stark contrast compared to the black box that other companies are was a welcome change for a number of people.

This transparency was also shown when they recently [did an oops and deleted their production database][techcrunch-gitlab-backup] while finding that their backup procedures were actually silently failing. They were incredibly open with what actually went wrong, sharing the internal Google Doc that they had been updating live, such that the world could see exactly what the internal GitLab team could:

<blockquote class="twitter-tweet" data-lang="en-gb"><p lang="en" dir="ltr">We accidentally deleted production data and might have to restore from backup. Google Doc with live notes https://t.co/EVRbHzYlk8</p>&mdash; GitLab.com Status (@gitlabstatus) <a href="https://twitter.com/gitlabstatus/status/826591961444384768">1 February 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

They even set up a live stream so the public could hop in on their conversations about what to do, and to follow the restore process copying files back to the production server! They also released [a very detailed postmortem][gitlab-database-postmortem], that explained exactly what happened, and what issues they encountered. Normally, such a postmortem would be only internally available, and therefore the service consumers would have missed out on the real context for what caused the outage. However, GitLab's incredibly open way of working prevailed, and as Sid had explained to me, it was so everyone could learn from their mistakes, and understand why it happened.

### Open Operations

As above, there is a lot of open-ness that GitLab practices. For instance, [their 'team handbook' is source available][gitlab-handbook], and there are 'about 500 pages of text' about the ins-and-outs of how they run the company - for instance the benefits that can be found, the values and beliefs they hold as a company, and technical information about team structures.

As well as how the company itself is run, they also have all their issue tracking about their [infrastructure and day-to-day jobs][gitlab-infrastructure] all on GitLab.com, too. I adore the fact that the whole world is able to watch as GitLab approach problems, and communicate in the most collaborative way possible - it's a huge plus, and shows that they live 'open-ness'.

### Open Source

Although this is a technical reason, I thought I'd put this in the 'Open-ness' section, as it complements the others in this section.

GitLab has an 'open core' model, which means that it provides a free, core version of GitLab, called [GitLab Community Edition][gitlab-ce] which is MIT Expat licensed. This product is completely free and is available in different means - via [source][gitlab-ce-source], via [Docker image][gitlab-ce-docker] and via [Omnibus package][gitlab-ce-omnibus]. There is a proprietary version called GitLab Enterprise Edition, which is the version you will find running on GitLab.com. This means that although it's not 100% open, it's a lot more open than their competitors. The main feature differences between the versions are [compared here][gitlab-compare-editions], but EE is primarily aimed at Enterprises, so are built for access management over hundreds or thousands of users.

The reasoning for Open Core is simple - by having an Enterprise version, they can keep GitLab.com gratis (free as in beer). The income gained by GitLab EE licenses pays for a blinding majority of the costs of the company, making it possible to have the work on the Open Source project as well as providing the ability to have GitLab.com completely gratis. However, just because features are in GitLab EE doesn't mean that they won't reach the CE.

There was recently [an issue raised][gitlab-issue-pages-ce] that a number of people wanted GitLab Pages in the Community Edition, as it was only available for GitLab EE. After announcing the release, GitLab realised that there was a lot of users who wanted this, and therefore [decided to bring Pages to GitLab CE][gitlab-issue-pages-ce]. These sorts of wins for the community are huge - a company that's built on Open Source, Open-ness and general respect and love for their users is one that you should always want to support.

<https://about.gitlab.com/2017/03/15/gitter-acquisition/>

# Caveats

## Open Core

Although they're Open Source, it's still not quite open enough. As there are a number of features only available in GitLab.com, there may be workflows you start to use that you then can't reproduce on CE, meaning that you're then locked into using EE. However, as mentioned, GitLab do release features from EE into CE regularly, so there is always the chance that something you'd like to have in the CE can be requested.

## Infrastructure Issues

Since I've been using GitLab (about 18 months) there have been a few times where they've had issues with their infrastructure - such that they have had service outages for short periods of time (the worst being around 45 minutes, excluding their backups mishap).

## Less Community Usage

Being a lesser used platform, there are less projects that are hosted solely on GitLab, meaning that it's harder to get exposure, as less people are going to be using it. Additionally, the search and [discoverability functionality isn't ideal][systses-discoverability], and therefore it's a bit harder to find what you want.

There's an easy fix for this though - let this article persuade you to give it a go, and to start using it for a couple of projects you have. Then, if you're happy with it, convince a friend to join. Very soon, it'll be growing pretty large and building the community even more.

# Conclusion

Overall, I hope that the above reasons give you enough reason to at least try out GitLab.com and to experience the unified platform it provides. I hope that given a bit of exposure to what it can provide you, GitLab can help you become more productive, and at the same time, you can help shape GitLab into something that will help others everywhere.


[review-apps]: https://about.gitlab.com/features/review-apps/
[environments]: https://gitlab.com/help/ci/environments
[ci-stages]: https://docs.gitlab.com/ce/ci/pipelines.html#pipelines
[gitlab-runner]: https://docs.gitlab.com/runner/
[gitlab-docs-env-ref]: https://gitlab.com/help/ci/environments
[jvtme-ci-yaml]: https://gitlab.com/jamietanna/jvt.me/blob/master/.gitlab-ci.yml
[jvtme-container-registry]: https://gitlab.com/jamietanna/jvt.me/container_registry
[gitlab-ee-docs-container-registry-project]: https://docs.gitlab.com/ee/user/project/container_registry.html#enable-the-container-registry-for-your-project
[sytses]: https://twitter.com/sytses
[ayufanpl]: https://twitter.com/ayufanpl
[anna_hax]: https://twitter.com/anna_hax
[dind]: https://github.com/jpetazzo/dind
[octopress]: http://octopress.org/
[hugo]: https://gohugo.io
[hakyll]: https://jaspervdj.be/hakyll/
[gitlab-pages-group]: https://gitlab.com/groups/pages
[jgitflow]: https://bitbucket.org/atlassian/jgit-flow
[aws-bill-6k]: https://awsinsider.net/articles/2015/09/08/aws-bug-bill.aspx
[hack24]: https://hack24.co.uk
[html-proofer]: https://github.com/gjtorikian/html-proofer
[techcrunch-gitlab-backup]: https://techcrunch.com/2017/02/01/gitlab-suffers-major-backup-failure-after-data-deletion-incident/
[gitlab-database-postmortem]: https://about.gitlab.com/2017/02/01/gitlab-dot-com-database-incident/
[gitlab-handbook]: https://about.gitlab.com/handbook/
[gitlab-infrastructure]: https://gitlab.com/gitlab-com/infrastructure/issues
[gitlab-ce]: https://gitlab.com/gitlab-org/gitlab-ce
[gitlab-compare-editions]: https://about.gitlab.com/products/#compare-options
[gitlab-issue-pages-ce]: https://gitlab.com/gitlab-org/gitlab-ce/issues/14605
[systses-discoverability]: https://twitter.com/sytses/status/842806897447116801
[eddieajua-dear-github]: https://github.com/dear-github/dear-github/issues/56#issuecomment-236050643
[dear-github]: https://github.com/dear-github/dear-github/tree/2f45c3255a55c3ac111817840537151d96e1649e
[dear-github-gitlab]: https://about.gitlab.com/2016/01/15/making-gitlab-better-for-large-open-source-projects/
[jekyll]: https://jekyllrb.com
[gitlab-ce-source]: https://gitlab.com/gitlab-org/gitlab-ce
[gitlab-ce-docker]: https://hub.docker.com/r/gitlab/gitlab-ce/
[gitlab-ce-omnibus]: https://gitlab.com/gitlab-org/omnibus-gitlab/
