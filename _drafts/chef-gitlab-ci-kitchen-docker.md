---
layout: post
title: Building Chef Cookbooks with GitLab (Part 1)
description: An introduction to how to build a cookbook using GitLab's Continuous Integration platform in conjunction with `kitchen-docker`.
categories: guide chef gitlab
tags: howto finding gitlab chef test-kitchen docker gitlab-ci
---

**Want a TL;DR?** - Go to the [GitLab CI](#gitlab-ci) section, for the snippet you'll need to add to your `.gitlab-ci.yml` file to add integration test support.

Note: This tutorial is using `master` as the primary branch for development. This is not the method in which I normally work, which I will expand on in the next part of the series.

## Bootstrapping

This tutorial expects you have the [Chef Development Kit (ChefDK)][chefdk] and [Docker Command Line tools][docker] installed, have an account on GitLab.com with a [repo created][gitlab-new-project].

We'll start by creating a new cookbook, by running `chef exec generate cookbook user-cookbook`. This is going to be a pretty boring cookbook which will create a user and optionally create a file in their home directory.

Let's start by [pushing the code up][cmt-1] to GitLab, i.e. `git remote add origin git@gitlab.com:jamietanna/user-cookbook.git && git push -u origin master`.

## Creating a Recipe

Now we have our empty cookbook available, let's start [adding some functionality][cmt-2]:

**`user_01`**

Now let's push this to GitLab.

## Initial CI Setup

As we've not configured anything in GitLab CI to run, we won't actually have any automated means of determining whether the code we're pushing is correct or not.

What if we set up our pipeline to run our unit tests whenever we pushed a commit?

The easiest route we can go is to run on a Debian image, and install the ChefDK on top via the handy `.deb` package. At the time of writing, the latest version is 1.3.43, which is [done as follows][cmt-3]:

**`ci_01`**

## Making Our Recipe More Useful

Okay, so now we've got [a bit more interactive feedback][ci-4], let's start making our recipe more configurable ([CI][ci-4]).

**`user_02`**

So what if we want to [specify the `group` of the user][cmt-5] ([CI][ci-5])?

**`user_03`**

Next, we will create a file, owned by the user, in their own home directory, [which is done as follows][cmt-6] ([CI][ci-6]):

**`user_04`**

## Integration Testing

So now we've got a few cases where there can be different combinations of attributes. However, our unit tests can only tell us so much, as they're based on assumptions. It is not until we actually run our recipes on a real machine that we can see how it's going to __execute/perform__.

Now, it's not often worth running integration tests against all combinations of machines you're going to run against, every time you commit. I prefer to run them when it gets to `develop` / on its way to `master`. However, we'll cover this workflow in the next part of the series.

**TODO: Describe test kitchen**

### Local Testing

The most common method of integration testing cookbooks is by using [Vagrant][vagrant]. However, that's a little slow and requires a full Virtual Machine. Instead, we can speed up our testing by using Docker.

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

The steps in full can be found in [this commit][cmt-7] ([CI][ci-7]).

This will specify that we want to test against Debian Jessie. Adding another platform to test against is straightforward and won't be expanded on until the next post.

Next, we define our test suite to run against. In this case, we're simply **????**. We specify which recipes we actually want to run, as well as any attributes we want to pass into the cookbook to test how it responds to any non-default configuration.

To test this, we'll run `kitchen converge`. This will create our image if it's not already created, and then will run the cookbook on the new __node__.

So that works. Let's [add some more integration tests][cmt-8] ([CI][ci-8]) to cover all our bases:

**`add more`, then test**

Uh oh - it looks like things _weren't_ actually working after all.

### Fixing integration test issues

So it looks like we've got an issue. Looking into **the integration test output**, we're failing due to:

#### `custom_group`

It looks like it's trying to add `jamie` to the `test` group, which is what we expected. But what we didn't know is that the group needs to be created _before_ we can add it to the group. This is the reason we do integration tests!

This is fixed [by adding][cmt-9] ([CI][ci-9]):

**`fix/custom_group`**

#### `hello`

This is a problem due to the `~jamie` actually not working, because Chef doesn't expand out the special `~` character to the home directory of the `jamie` user.

The easiest (but not nicest) way of doing this, is to [update the home directory path][cmt-10] ([CI][ci-10]) to `/home/#{node['user']}`, which expands out to i.e. `/home/jamie`:

**`CI_FIX_HOME`**

However, that still doesn't quite work. Chef by default doesn't actually 'manage' the home directory, so we need to [explicitly set `manage_home true`][cmt-11] ([CI][ci-11]) when creating the user:

**`CI_FIX_HOME_2`**

### GitLab CI

Now we have it working locally, let's add our setup to [test this when we're pushing up to GitLab][cmt-12] ([CI][ci-12]), too:

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

You may notice that when running `kitchen test`, _[we actually fail][ci-12] **TODO: link**_. This is due to the `verifier` not being found, *explain*.

Notice that we've not actually got any cases where there is a different `user`, just `group`. Let's [tack it on with the `hello` case][cmt-13] ([CI][ci-13]), and _ensure that it works correctly_.

Let's [write some quick integration tests][cmt-14] ([CI][ci-14]):

*TODO: Remove TODOs*

**`Integration tests`**

[gitlab-new-project]: https://gitlab.com/projects/new
[chefdk]: https://downloads.chef.io/chefdk
[vagrant]: https://vagrantup.com
[docker]: https://docker.com
[docker-post-install-linux]: https://docs.docker.com/engine/installation/linux/linux-postinstall/


```bash
git rebase -i --exec 'git push origin HEAD:master; sleep 10' $rootcommit

git log --reverse --format=%H | cat -n | awk '{ \
printf "[cmt-" $1 "]: https://gitlab.com/jamietanna/user-cookbook/commit/" $2 "\n[ci-" $1 "]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}\n" \
}' | xclip
```

[cmt-1]: https://gitlab.com/jamietanna/user-cookbook/commit/a35132e30dfe51ffbc8374bac16dd5e0dba8e1b8
[ci-1]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-2]: https://gitlab.com/jamietanna/user-cookbook/commit/7566dbda74a4819b32b8a196651053fdea2d8b95
[ci-2]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-3]: https://gitlab.com/jamietanna/user-cookbook/commit/57ded223d14d9208196e04ad0d4ee6aeb90e7306
[ci-3]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-4]: https://gitlab.com/jamietanna/user-cookbook/commit/26b32e270d97961fe08cf538837c949b6aa63741
[ci-4]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-5]: https://gitlab.com/jamietanna/user-cookbook/commit/c7532efef2496b7b53b60c760c13df025781ac74
[ci-5]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-6]: https://gitlab.com/jamietanna/user-cookbook/commit/669609062d55db87239c9588e849ddd327570885
[ci-6]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-7]: https://gitlab.com/jamietanna/user-cookbook/commit/3806dd4c86a75be895393b60f91248f9d7af5be5
[ci-7]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-8]: https://gitlab.com/jamietanna/user-cookbook/commit/80a2c5e5fcb3dfabb27b4cca77ef9ae20cbe4231
[ci-8]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-9]: https://gitlab.com/jamietanna/user-cookbook/commit/2d221178b8c15f8f7cda6ac9bc2361d4641d14e3
[ci-9]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-10]: https://gitlab.com/jamietanna/user-cookbook/commit/0c881e50bdc603532a21ce403703bdc74ee10ad1
[ci-10]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-11]: https://gitlab.com/jamietanna/user-cookbook/commit/359954d76e1ecaadfbdf04cef6a77542e9f0371e
[ci-11]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-12]: https://gitlab.com/jamietanna/user-cookbook/commit/f5d858c3bccd41f2bf3b98a37be09db17df52df0
[ci-12]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-13]: https://gitlab.com/jamietanna/user-cookbook/commit/6c759fd225e2316548caa2152b9d76025d34bcec
[ci-13]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-14]: https://gitlab.com/jamietanna/user-cookbook/commit/88f134a1b7e9e6bc39be7bd0c1cb9a8d8e5b6ddf
[ci-14]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
