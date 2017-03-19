---
layout: post
title: Why You Should Use Gitlab.com
description:
tags: gitlab opensource
---

## tl;dr

`TODO`

## On a technical level

There are a number of reasons why Gitlab is technically superior to other hosting providers, and should be considered __??__.

### CI

Having Continuous Integration built into the platform is hugely useful. Although CI platforms for i.e. Github are great, and integrate nicely, there's nothing better than not even having to leave Gitlab to see how your builds performed.

With Gitlab's CI, you also gain the option of using Docker-based infrastructure, which means that you don't have to wait for all your dependencies to be installed as part of your CI build, slowing down time to feedback. As you can choose any Docker image, be it from the Hub or a private registry (more details **below**), you can prepackage the large (or even all) dependencies in an easy to access format, such that your CI can start as soon as the image is downloaded.

This removes a lot of the cruft of configuration, making it possible to "just get it working" much more quickly, and not have to work out all the dependencies required for Ruby 2.4.0 on an Ubuntu 14.04 box - instead, you would specify i.e. `image: ruby:2.4.0` and be done.

Additionally, unlike other offerings, you can run the same CI job locally using the Open Source [Gitlab Runner][gitlab-runner], in the same fashion that would be run on Gitlab.com's infrastructure. This is a huge plus - no more `WIP: Travis please run this time` commits! Because of this, you can also configure a runner to run on your own infrastructure - for instance if there is some special configuration, or if it needs to run on a machine __??__.

Finally, using **DIND**, you can also build Docker images through your CI pipeline - for instance, this site is built using Docker and an image is published to [my container registry][jvtme-container-registry].

**CI stages**

#### Private Registry

As mentioned above, Gitlab.com provides a private Docker registry, per project. That means that if you're using Docker for your project, you can instantly build up to it, and pull from it, with no extra steps. All you need to do [is enable it][gitlab-ee-docs-container-registry-project].

Because this is a private registry, too, it means that you don't have to worry about getting a paid subscription to the Docker hub, or work out how to set one up yourself - it all _just works_!

#### Environments

`TODO`

### Review Apps

Very tightly related to CI and Environments is the [Review Apps][review-apps] functionality.

### Gitlab Pages

Have you ever wanted to run a static site? But don't want to learn Jekyll? (Not that there's anything wrong with Jekyll, that is!)

What if you wanted to try out different types of static site generators?
What if you didn't want to set up the infrastructure to run on your own VPS? But wanted flexibility?

### Process Improvements

Only today, while setting up a new repo for [Hack24][hack24], __@anna__ and I found that unless I was given Master permissions, I wouldn't be able to push into `master`. This took us by surprise, but made sense - it's one of those things, you don't want every developer to be able to blindly push in, you'd want to ensure that __??__.

**TODO: screenshots**


## Non-technically

### Open-ness

Gitlab is very different to other companies - most notably how amazingly open and transparent they are with all they do.

For instance, <https://about.gitlab.com/2017/03/17/how-is-team-member-1-doing/>
<https://about.gitlab.com/2017/03/15/gitter-acquisition/>

## Caveats

`TODO`



[review-apps]:
[gitlab-runner]: https://docs.gitlab.com/runner/
[jvtme-container-registry]: https://gitlab.com/jamietanna/jvt.me/container_registry
[gitlab-ee-docs-container-registry-project]: https://docs.gitlab.com/ee/user/project/container_registry.html#enable-the-container-registry-for-your-project
