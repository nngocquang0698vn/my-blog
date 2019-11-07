---
title: "Chef Attributes and `default.rb` - it's in the name"
description: "Why you should only be setting defaults in your Chef attributes, and moving heavy lifting elsewhere."
tags:
- nablopomo
- chef
- chefspec
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-07T18:49:56+0000
slug: "chef-default-attributes"
---
I've written a fair bit in the past about how I work with Chef as a configuration management tool a lot every day.

However, some folks don't use Chef as much as my team did which means some of the subtleties or best practices aren't picked up on. It happens, but I hope that this post can help to make some more folks see if they also need to think about how they do things.

Because the team I worked on was very quality-heavy, we wanted to [unit test our cookbooks]({{< ref "2018-09-04-tdd-chef-cookbooks-chefspec-inspec" >}}). This meant that as we started to depend on other cookbooks, we found that there were some issues that the folks who built it won't have seen, specifically around the way that they set up their [attributes](https://docs.chef.io/attributes.html).

Before I go any further, I want to clarify that I know I have also been culpable to this in the past, so my angle on this isn't a "boo, you suck", but a "we can all do better, here's what I've learned".

The issue with making you cookbook configurable through attributes is that some creators will set up some complex configuration in their `attributes/` directory in their cookbook which although they see as the right thing to do isn't quite true.

For instance, the below crafted example shows the use of the currently running EC2's `instance_id` to set up the logging directory:

```ruby
node.default['nginx_load_balancer']['logs'] = "/var/log/nginx/#{node['ec2']['instance_id']}/logs/"
```

This works absolutely fine on the deployed instance in AWS, but wouldn't run well when running in ChefSpec, or even in a local Vagrant instance because the `ec2` metadata will not be set.

With this code in the `default.rb`, all consumers of your cookbook now have the following snippets littered in their ChefSpec code, even when you're not actually using a recipe from that cookbook, your own cookbook just depends on it:

```ruby
runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '8.7') do |node|
  node.automatic['ec2']['instance_id'] = 'wibble'
  # ...
end
```

This is quite painful, and scales poorly depending on what other information the cookbook expects to be there, or how it processes things.

The attributes are meant to be used for setting defaults that can then be overridden by a consumer, instead of being a place to perform lots of processing to set things up.

So what do I recommend instead? Think about whether the thing you're doing is truly a default, or a convenient place to process something for your cookbook. If it's more for convenience, put it into the recipe that requires it, or your `default` recipe, but provide a sane default in your attributes, or `nil` to show that it needs to be set.

If you do need to do conditional setup, please only rely on the [Automtic Attributes that Ohai sets](https://docs.chef.io/ohai.html#automatic-attributes) which make things safer. As above, if there's anything you need to do a bit more automagic, do it inside the recipe so it's self-contained and will be easier to mock when it needs to be.

__Please__ don't execute HTTP requests, read files from disk, or run some arbitrary Ruby code when processing the attributes configuration - that is not the place to do it! I've had this before and it's so painful because it's very hard to mock, but also because it gets executed potentially many times and isn't the right place to be.

To horribly misquote _Jurassic Park_:

> Your developers were so preoccupied with whether or not they could, they didn't stop to think if they should.

Just because it's valid Ruby code doesn't mean you should do it!
