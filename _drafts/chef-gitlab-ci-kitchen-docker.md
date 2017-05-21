---
layout: post
title: Building Chef Cookbooks with GitLab (Part 1)
description: An introduction to how to build a cookbook using GitLab's Continuous Integration platform in conjunction with `kitchen-docker`.
categories: guide chef gitlab
tags: howto finding gitlab chef test-kitchen docker gitlab-ci
---
## Bootstrapping

This tutorial expects you have the [Chef Development Kit (ChefDK)][chefdk] installed, have an account on GitLab.com, and a [repo created][gitlab-new-project]. **TODO also Docker**

We'll start by creating a new cookbook, by running `chef exec generate cookbook user-cookbook`. This is going to be a pretty boring cookbook, and will create a user.

Let's start by pushing the code up to GitLab, i.e. `git remote add origin git@gitlab.com:jamietanna/user-cookbook.git && git push -u origin master`.

## Creating a Recipe

Now we have our empty cookbook available, let's start adding some functionality.

**`user_01`**

Now let's push this to GitLab.

## Initial CI Setup

Oh, that was boring. We've not got anything doing any automated checking to see if we're actually pushing the right code!

What if we set up our pipeline to run our unit tests whenever we pushed a commit?

The easiest route we can go is to run on a Debian image, and install the ChefDK on top via the handy `.deb` package. At the time of writing, the latest version is 1.3.43.

**Or is the easiest route that we can install the gems?**

**`ci_01`**

## Making Our Recipe More Useful

Okay, so now we've got a bit more interactive feedback, let's start making our recipe more configurable.

**`user_02`**

**TODO: Link to commit**

So what if we want to specify the `group` of the user?

**`user_03`**

**TODO: Link to commit**

And now, let's add the ability to generate an SSH key for the given user, only if they have a given attribute.

**`user_04`**

**TODO: Link to commit**

## Integration Testing

So now we've got a few cases where there can be different combinations of attributes. However, our unit tests can only tell us so much, as they're based on assumptions. It is not until we actually run our recipes on a real machine that we can see how it's going to _execute/perform_.

**This will fail integration when trying to create a user in a given group, yay!**

Now, it's not often worth running integration tests against all combinations of machines you're going to run against, every time you commit. I prefer to run them when it gets to `develop` / on its way to `master`.


**TODO: Describe test kitchen**

### Local Testing

The most common method of integration testing cookbooks is by using [Vagrant][vagrant]. However, that's a little slow and requires a full Virtual Machine. Instead, we can speed up our testing by using [Docker][docker].

We can do this by using the [`kitchen-docker`][kitchen-docker] driver for [Test Kitchen][test-kitchen], which provides the same goodness that we can expect from Test Kitchen, but with the perk of it being run against a Docker image.

The specific Docker-related settings in our `.kitchen.yml` are:

```yaml
driver:
  name: docker
  # make kitchen detect the Docker CLI tool correctly, via
  # https://github.com/test-kitchen/kitchen-docker/issues/54#issuecomment-203248997
  use_sudo: false
```

This ensures that we're using the `kitchen-docker` driver, and that we ensure that it can correctly hook into the `docker` CLI tools. **NOTE:** This requires you to have set yourself up with the [`Manage Docker as a non-root user` steps][docker-post-install-linux].

Next, within our `.kitchen.yml`, we'll add the following:

```yaml
# TODO: .kitchen.yml
# TODO: remove `verifier` steps?
```

This will specify that we want to test against Debian Jessie. Adding another platform to test against is straightforward and won't be expanded on **Or should it??**.

Next, we define our test suite to run against. In this case, we're simply **....**. We specify which recipes we actually want to run, as well as any attributes we want to pass into the cookbook to test how it responds to any non-default configuration.

**TODO then run the converge**

Uh oh - it looks like things _weren't_ actually working after all.

### Fixing integration test issues


### GitLab CI

`.gitlab-ci.yml`:
```
docker_test:
  image: docker:latest
  services:
    - docker:dind
  stage: test
  script:
    - 'echo gem: --no-document > $HOME/.gemrc' && apk update && apk add build-base git libffi-dev ruby-dev ruby-bundler
    - gem install kitchen-docker kitchen-inspec berkshelf
    - kitchen test
```

## So it converged, now what?

**Integration tests! Inspec - next article?**

[gitlab-new-project]: https://gitlab.com/projects/new
[chefdk]: https://downloads.chef.io/chefdk
[vagrant]: https://vagrantup.com
[docker]: https://docker.com
[docker-post-install-linux]: https://docs.docker.com/engine/installation/linux/linux-postinstall/
