---
title: "Programatically Determining the Version of a Chef Cookbook"
description: "How to determine a Chef cookbook's version programatically, using Ruby."
tags:
- blogumentation
- chef
- ruby
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-03-23T22:04:18+0000
slug: "chef-cookbook-version"
image: /img/vendor/chef-logo.png
---
If you're scripting around your Chef cookbooks, you may want to do things like work out the version of the cookbook, so you can i.e. use it for reporting, check if the cookbook is already uploaded, etc.

You may think, well, it's in the following format, why don't I just parse it with i.e. a regex:

```ruby
version '2.1.0'
```

Well, unfortunately this won't work (aside from [if you generally avoid regex](https://xkcd.com/1171/)) as the `metadata.rb` file, which stores the cookbook's metadata, is just plain Ruby, so it allows you to execute any Ruby code, such as looking it up from file, performing a long-running HTTP request, or anything really.

Fortunately, we can use the [utility class `Chef::Cookbook::Metadata`](https://www.rubydoc.info/github/opscode/chef/Chef/Cookbook/Metadata) to parse the metadata, resolve any arbitrary Ruby code, and give us the version number:

```ruby
require 'chef'

m = Chef::Cookbook::Metadata.new
m.from_file 'metadata.rb'
puts m.version
```

This also works for any other metadata of the cookbook we want to retrieve.
