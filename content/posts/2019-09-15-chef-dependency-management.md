---
title: "How Many Gadgets Does the Kitchen Need?! The Many Tools for Chef Dependency Management"
description: "Looking at the different dependency management solutions of Chef, and how, where and why you would use each one."
tags:
- blogumentation
- chef
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-15T14:59:28+01:00
slug: "chef-dependency-management"
image: /img/vendor/chef-logo.png
---
I hear a question a fair bit when working with teams on Chef - "do I need to put this cookbook dependency into my `Berksfile` or my `metadata.rb`?"

This has come up several times with teams I work with, who rightfully so, are a bit confused about where Chef's various dependency management tools are used, and what all those files are for.

I thought I'd go into the main two that we use - `Berksfile` and `metadata.rb`, but also touch on a couple of other methods. This will hopefully bust some myths and provide a little more clarity.

Note that I won't be going into the benefits of each model, just describing what they are and where they're used.

# What type of Chef are you running?

I've explained these examples in mind of how you use them and what flavour of Chef is used to run them, so before we dive in we should check what method you're using.

## Chef Client (w/ Chef Server)

This is most likely the version you'll be running (using the `chef-client` command), where you've got a set of Chef Servers that your node will check into and execute against.

Note that even if you run Chef Client in your Production environment, you may need to a non-Server connection to validate cookbooks for local development (i.e. with Test Kitchen) as you may not have enough licenses for arbitrary executions of Chef.

## Chef Client (local mode)

If you want to use the full Chef Client, but don't want to be managing Chef Servers, you can run `chef-client --local-mode`.

## Chef Solo

This is now effectively the same as the above Chef Client in `--local-mode`, but in the past had a few differences.

# Where are we storing the built cookbooks?

Now we know how we're running Chef, we've got to verify where our cookbooks are stored.

This is dependent on how we run Chef, and these methods can't be mixed. That means that if you have a mix of usages of Chef, you'll need to have the cookbooks in different formats.

## Chef Server

This is only available while you're running a full Chef Client run (i.e. not solo/local mode) as the Chef Server requires extra authentication from the client, as well as having licensing implications.

With Chef Server, you'll be uploading cookbooks to the Server itself, which allows the Chef Server administrators to manage versions and compliance a little better.

You'll also likely have it configured to perform regular Chef runs to ensure that there is no configuration drift.

## Chef Supermarket / Artifactory / On Disk / In Source Control

The Supermarket is a pure artifact storage server, and allows you to upload the cookbook to its servers.

It is common to also see an [Artifactory](https://jfrog.com/artifactory/) instance in corporate environment which can be configured to support the Chef Supermarket API.

You can also store them effectively anywhere, including on disk somewhere or via some public/private source control.

This is only used when we're not performing a full Chef Client run against a Chef Server, because Chef has no idea where to get its dependencies in this method.

# Files

## `metadata.rb` / `metadata.json`

The [`metadata.rb`](https://docs.chef.io/config_rb_metadata.html) is a Ruby file that sits within your cookbook. It is the source of truth for the dependencies of the cookbook it is in, and is how Chef understands what cookbooks it needs in a Chef run.

This also allows you to store information such as any cookbooks, resources, or Gem dependencies you may have for the cookbook, so it can expand the `run_list` at compile/converge time, as it needs to be able to know where the recipes/resources are defined.

Chef then converts this to a `metadata.json` for internal use only, which you may see in an uploaded cookbook in your Chef Server / Chef Supermarket.

Used with:

- [x] Chef Client (w/ Chef Server)
- [x] Chef Client (local mode)
- [x] Chef Solo

## `Berksfile` and `Berksfile.lock`

Both of these files are used for the [Berkshelf](https://github.com/berkshelf/berkshelf) command-line tool, which is one of the most common dependency management tool for your Chef dependencies.

You'll likely see it in your cookbooks for use with Test Kitchen, but also we've got it in a few places for setting up local services' dependencies for use with Vagrant.

Used with:

- [ ] Chef Client (w/ Chef Server)
- [x] Chef Client (local mode)
- [x] Chef Solo

## Chef JSON files

This is a JSON file that describes to Chef what you want to converge, and how. It contains a list of all attributes and recipes you want to use on the Chef run, and is a nice, self-contained way to set things up for Chef.

An alternative is to use a role, or more likely a wrapper cookbook which allows you to store all this configuration in one handy cookbook, so all you need to do when actually running Chef is include i.e. a single recipe.

- [x] Chef Client (w/ Chef Server)
- [x] Chef Client (local mode)
- [x] Chef Solo

## `Policyfile.rb`

The `Policyfile.rb` is a fairly new way to make it easier to hard pin versions and safely promote configurations between development and production.

The [Chef docs site](https://docs.chef.io/policyfile.html) has a good explanation in a bit more depth on what it's used for.

It is similar to the Chef JSON file, but is much more careful in terms of restricting mutability between runs, which is unfortunately possible with Chef JSON files (i.e. if someone re-uploads a cookbook with the same version but new functionality).

Used with:

- [x] Chef Client (w/ Chef Server)
- [ ] Chef Client (local mode)
- [ ] Chef Solo

## `Gemfile` and `Gemfile.lock`

The `Gemfile` and the `Gemfile.lock` are only for development Gem dependencies, used with the [Bundler dependency management tool](https://bundler.io).

If your cookbook depends on a Gem, you need to add it to your `metadata.rb`.

Used with:

- [ ] Chef Client (w/ Chef Server)
- [ ] Chef Client (local mode)
- [ ] Chef Solo
