---
layout: post
title: Building Chef Cookbooks with GitLab
description: An introduction to how to build a cookbook using GitLab's Continuous Integration platform in conjunction with `kitchen-docker`.
categories: guide
tags: howto finding gitlab chef test-kitchen docker
---
## Bootstrapping

This tutorial expects you have the [Chef Development Kit (ChefDK)][chefdk] installed, have an account on GitLab.com, and a [repo created][gitlab-new-project].

We'll start by creating a new cookbook, by running `chef exec generate cookbook user-cookbook`. This is going to be a pretty boring cookbook, and will create a user.

Let's start by pushing the code up to GitLab, i.e. `git remote add origin git@gitlab.com:jamietanna/user-cookbook.git && git push -u origin master`.

## Creating a Recipe

Now we have our empty cookbook available, let's start adding some functionality.

**`user_01`**

Now let's push this to GitLab.

## Initial CI Setup

Oh, that was boring. We've not got anything doing any automated checking to see if we're actually pushing the right code!

What if we set up our pipeline to run our unit tests whenever we pushed a commit?

**`ci_01`**

## Making Our Recipe More Useful

Okay, so now we've got a bit more interactive feedback, let's start making our recipe more configurable.

**`user_02`**

And now, let's add the ability to generate an SSH key for the given user, only if they have a given attribute.

**`user_03`**

## Integration Testing

So now we've got a few cases where there can be different combinations of attributes. However, our unit tests can only tell us so much, as they're based on assumptions. It is not until we actually run our recipes on a real machine that we can see how it's going to _execute/perform_.

# **TODO: Add a case where the integration test proves us wrong with our assumptions**

### Local Testing

### GitLab CI

`.kitchen.yml`:
```yaml
driver:
  name: docker
  # make kitchen detect the Docker CLI tool correctly, via
  # https://github.com/test-kitchen/kitchen-docker/issues/54#issuecomment-203248997
  use_sudo: false
```

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

[gitlab-new-project]: https://gitlab.com/projects/new
[chefdk]: https://downloads.chef.io/chefdk
