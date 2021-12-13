---
title: "Debugging Chef Variables With Logs"
description: "How you can use different means of logging to make operations with Chef cookbook a little easier."
tags:
- blogumentation
- chef
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-12-13T20:01:06+0000
slug: "chef-logging"
image: /img/vendor/chef-logo.png
---
When you're developing Chef cookbooks, you're likely to need to debug things that aren't working as expected. One option to do this interactively is [using `chef-shell`](/posts/2018/08/29/debugging-chef-shell/) while developing, but this doesn't necessarily help when we're not developing interactively.

In this case, we can utilise Chef's first-class logging, but we need to consider the [two-pass process that Chef goes through](https://coderanger.net/two-pass/).

To illustrate this, consider the following Chef recipe:

```ruby
node.default['dynamic_property'] = 'This is set at the compile phase'

puts "This is a puts message, from the compile phase: #{node['dynamic_property']}"

ruby_block 'Update dynamic_property' do
  block do
    node.override['dynamic_property'] = 'This is set at the converge phase'
  end
  action :run
end

puts "This is a puts message, from the compile phase: #{node['dynamic_property']}"

log 'message -> compile' do
  message "This is a log message, from the compile phase: #{node['dynamic_property']}"
  level :info
end

log 'message -> converge' do
  message lazy { "This is a log message, from the converge phase: #{node['dynamic_property']}" }
  level :info
end

ruby_block 'block -> converge' do
  block do
    puts "This is a log message, from a ruby_block converge phase: #{node['dynamic_property']}"
  end
  action :run
end

ruby_block 'Chef::log -> converge' do
  block do
    Chef::Log.info "This is a log message, from a ruby_block in Chef::Log.info in the converge phase: #{node['dynamic_property']}"
  end
  action :run
end
```

We can see from the output of a Chef run of the above cookbook that the logs should be logged via a `log` resource, with `lazy` blocks to ensure the message is evaluated at converge time, or that we use a `ruby_block` with a `Chef::Log`:

```
Compiling Cookbooks...
This is a puts message, from the compile phase: This is set at the compile phase
This is a puts message, from the compile phase: This is set at the compile phase
Converging 5 resources
Recipe: example::default
  * ruby_block[Update dynamic_property] action run[2021-12-13T19:37:51+00:00] INFO: Processing ruby_block[Update dynamic_property] action run (example::default line 11)
[2021-12-13T19:37:51+00:00] INFO: ruby_block[Update dynamic_property] called

    execute the ruby block Update dynamic_property
  * log[message -> compile] action write[2021-12-13T19:37:51+00:00] INFO: Processing log[message -> compile] action write (example::default line 20)
[2021-12-13T19:37:51+00:00] INFO: This is a log message, from the compile phase: This is set at the compile phase

  * log[message -> converge] action write[2021-12-13T19:37:51+00:00] INFO: Processing log[message -> converge] action write (example::default line 25)
[2021-12-13T19:37:51+00:00] INFO: This is a log message, from the converge phase: This is set at the converge phase

  * ruby_block[block -> converge] action run[2021-12-13T19:37:51+00:00] INFO: Processing ruby_block[block -> converge] action run (example::default line 30)
This is a log message, from a ruby_block converge phase: This is set at the converge phase
[2021-12-13T19:37:51+00:00] INFO: ruby_block[block -> converge] called

    execute the ruby block block -> converge
  * ruby_block[Chef::log -> converge] action run[2021-12-13T19:37:51+00:00] INFO: Processing ruby_block[Chef::log -> converge] action run (example::default line 37)
[2021-12-13T19:37:51+00:00] INFO: This is a log message, from a ruby_block in Chef::Log.info in the converge phase: This is set at the converge phase
[2021-12-13T19:37:51+00:00] INFO: ruby_block[Chef::log -> converge] called

    execute the ruby block Chef::log -> converge
[2021-12-13T19:37:51+00:00] INFO: Chef Infra Client Run complete in 0.079342634 seconds
```

Although we can use `puts`, this doesn't give us the ability to use logging levels that can then be filtered more appropriately by Chef, and allow us to hone in on i.e. fatal errors.
