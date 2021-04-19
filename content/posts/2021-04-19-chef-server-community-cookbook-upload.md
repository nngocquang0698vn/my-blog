---
title: "Uploading Community Cookbooks from Supermarket to Chef Server"
description: "How to upload a given community cookbook from Chef Supermarket to Chef Server, using Berkshelf."
date: 2021-04-19T09:02:39+0100
tags:
- "blogumentation"
- "chef"
- "berkshelf"
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
slug: "chef-dependency-graph"
image: /img/vendor/chef-logo.png
---
As I've mentioned recently, I'm working on rebuilding our Chef pipelines at work.

As we're running a Chef Server, we need some way to sync from our [public Supermarket](https://supermarket.chef.io) to our Chef Server, so we can take advantage of the wonderful work that the community has done with their Free and Open Source cookbooks.

As I'd mentioned in [_Constructing an Ordered Dependency Graph for Chef Cookbooks, using Berkshelf_]({{< ref 2021-04-18-chef-dependency-graph >}}), this can cause issues due to dependency trees, as a cookbook can't be uploaded to the Chef Server unless a dependency is present already uploaded.

While looking into it, [a Chef Friend in the Community Slack](https://www.jvt.me/mf2/2021/04/segnf/) mentioned that the solution is generally to use `berks upload`.

For instance, to use the `consul` cookbook at version `4.5.0`, we'd create the `Berksfile`:

```ruby
source 'https://supermarket.chef.io'

cookbook 'consul', '4.5.0'
```

Then we would run:

```sh
# if it exists, we should remove it so we re-calculate any dependency graphs
rm -f Berksfile.lock
berks install
berks upload
```

Where `berks upload` will use the Chef configuration (i.e. in `config.rb`) and upload to the given Chef Server.

Note that this will only pull the latest versions of cookbooks - I'm looking at what we can do to be more conservative against what's available in the Chef Server.
