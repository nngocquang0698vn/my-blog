---
title: "Installing Gems From Your `Gemfile` When Developing Chef Cookbooks using the ChefDK / Chef Workstation"
description: "How to install Ruby Gems in local development using your `Gemfile`."
tags:
- blogumentation
- chef
- ruby
- chefdk
- chef-workstation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-02-22T21:51:24+0000
slug: "chefdk-gemfile"
image: /img/vendor/chef-logo.png
---
One of the great things I've found about working with Chef is the ChefDK / Chef Workstation setup, which ensures that you need just one install to be able to get up-and-running in a way that allows you to easily coordinate with others on version of core tools and libraries. This also translates nicely to [running it in Docker]({{< ref 2018-12-05-chefdk-testing-docker >}}), but something that's always been painful, and has plagued me for several years, is working with Ruby Gems.

When running your code against an actual node, i.e. using [the `chef_gem` resource](https://docs.chef.io/resources/chef_gem/) works wonderfully, but as [someone who strongly believes in test-driven development with Chef]({{< ref 2018-09-04-tdd-chef-cookbooks-chefspec-inspec>}}), this doesn't solve the local testing issue.

The "best" solution I've got to is to create a Gem that packages the versions of the key Chef dependencies required, and then deal with the poor developer experience that running `chef exec bundle exec rspec` everywhere. This at least means we're not going to have to manually install gems locally, but has been a pretty poor experience, and makes Chef upgrades that bit harder.

Fortunately today I've found that we can use Bundler to install our Gems globally, which works transparently and allows us to utilise our Gems for tests without causing issues.

**Note**: I recommend this when you're either running on ephemeral infrastructure, like in a (Docker) container or on a non-persisted build agent, or when using this on your local machine. Please do not use this when you're i.e. using the same Jenkins agent as other people, as it can seriously mess things up!

For instance, when we've got a `Gemfile` in our repo:

```sh
$ chef exec rspec               # fails, as it can't find the Gem(s)
$ bundle config set system true # using `--system` is deprecated
$ bundle install
$ chef exec rspec               # works!
```
