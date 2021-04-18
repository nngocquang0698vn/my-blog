---
title: "Constructing an Ordered Dependency Graph for Chef Cookbooks, using Berkshelf"
description: "How to create a dependency graph for a given cookbook's dependencies to understand the order to install them in."
date: 2021-04-18T11:51:21+0100
tags:
- "blogumentation"
- "chef"
- "test-kitchen"
- "berkshelf"
- "ruby"
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
slug: "chef-dependency-graph"
image: /img/vendor/chef-logo.png
---
As I've mentioned recently, I'm working on rebuilding our Chef pipelines at work.

As we're running a Chef Server, we need some way to sync from our [public Supermarket](https://supermarket.chef.io) to our Chef Server, so we can take advantage of the wonderful work that the community has done with their Free and Open Source cookbooks.

However, one thing that makes this difficult is when cookbooks have dependencies, as an upload of a cookbook to Server that doesn't have its dependency present will fail:

```sh
$ knife cookbook upload chef_server -d
Uploading chef_server    [...]
ERROR: Cookbook chef_server depends on cookbooks which are not currently
ERROR: being uploaded and cannot be found on the server.
ERROR: The missing cookbook(s) are: 'chef-ingredient' version '>= 0.0.0', 'ssh_keygen' version '>= 0.0.0'
```

This means we need to get the dependencies uploaded, in the right order, so our dependencies are always present.

To make this easier, I've been looking at how to script the retrieval of dependencies for a given cookbook to return an ordered list of dependencies.

Note that, at this time, this will show whatever the latest version of a cookbook that satisfies the dependency. However, I'll be looking in a future blog post at how to marry up the dependencies requested, and what's currently on the Chef Server to make sure we don't add any unnecessary cookbook version bumps.

(As an aside, this may not be required, as [noted by a Chef Friend in the Community Slack](https://www.jvt.me/mf2/2021/04/segnf/), as we can use `berks upload` instead - however, this is still an interesting problem, and I'd written the solution by the point I heard this!)

For the below code, I've used [Ferry Boender's _Dependency Resolving Algorithm_](https://www.electricmonk.nl/docs/dependency_resolving_algorithm/dependency_resolving_algorithm.html) to remind me how graph traversal works, because if I'm honest, I couldn't remember much from my degree's Algorithms and Data Structures module 😅.

Fortunately, we can take advantage of Berkshelf's initial dependency resolution, but then need to do a bit more work to create this as an ordered graph, so we know what needs to be retrieved first.

```ruby
require 'berkshelf'

class Node
  attr_accessor :name, :version, :edges

  def initialize(name, version)
    @name = name
    @version = version
    @edges = []
  end

  def ==(other)
    name == other.name &&
      version == other.version
  end

  def to_s
    "#{@name} #{@version}"
  end
end

def to_graph(dependencies, versions, cookbook)
  node = Node.new(cookbook, versions[cookbook])

  node.edges = dependencies[cookbook].map do |v|
    to_graph(dependencies, versions, v)
  end

  node
end

def resolve(node, resolved)
  node.edges.each do |edge|
    resolve(edge, resolved) unless resolved.include? edge
  end
  resolved << node
end

cookbook_name = ARGV[0]

File.open('Berksfile', 'w') do |f|
  contents = <<-BERKSFILE
  source 'https://supermarket.chef.io'

  cookbook '#{cookbook_name}'
  BERKSFILE

  f.write(contents)
end

berksfile = Berkshelf::Berksfile.from_options
berksfile.install # trigger the download of dependencies

versions = {}
dependencies = {}

berksfile.lockfile.graph.each do |g|
  versions[g.name] = g.version
  dependencies[g.name] = g.dependencies.map(&:first)
end

graph = to_graph(dependencies, versions, cookbook_name)

resolved = []
resolve(graph, resolved)
jj resolved
```

For example, we can run this script to resolve the `consul` cookbook's dependencies like so:

```sh
chef exec ruby resolve.rb consul
```

This results in a JSON array with the versions which provides the list of cookbooks, in order of how they need to be installed so the final entry, in this case `consul`, can be correctly uploaded to Chef Server:

```
Resolving cookbook dependencies...
Using ark (5.1.0)
Using build-essential (8.2.1)
Using consul (4.5.0)
Using golang (4.1.1)
Using mingw (2.1.1)
Using nssm (4.0.1)
Using poise (2.8.2)
Using poise-archive (1.5.0)
Using poise-service (1.5.2)
Using seven_zip (3.2.0)
Using windows (7.0.2)
[
  "windows@7.0.2",
  "seven_zip@3.2.0",
  "mingw@2.1.1",
  "build-essential@8.2.1",
  "nssm@4.0.1",
  "ark@5.1.0",
  "golang@4.1.1",
  "poise@2.8.2",
  "poise-archive@1.5.0",
  "poise-service@1.5.2",
  "consul@4.5.0"
]
```

Which we can compare to the output of `berks viz` which shows the same dependency graph:

![A directed graph which visualises a similar dependency graph, but showing each cookbook's other dependencies, with annotations showing the dependency constraints](https://media.jvt.me/2be2c78499.png)
