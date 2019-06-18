---
title: Test-Driven Chef Cookbook Development Using ChefSpec (and a sprinkling of InSpec)
description: Using the example of deploying and running a Java JAR file as a way to show the lifecycle of a fully test-driven Chef cookbook.
categories:
- blogumentation
- chef
- tdd
tags:
- howto
- blogumentation
- chef
- test-kitchen
- chefspec
- tdd
- testing
- guide
image: /img/vendor/chef-logo.png
date: 2018-09-04T14:52:10+01:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: tdd-chef-cookbooks-chefspec-inspec
---
For the example of how to create a Chef cookbook in a truly test-driven manner, we'll be building a _relatively_ simple Chef cookbook for downloading and running a Java JAR file. Note that this post won't be going into the intricacies of _why_ you would practice TDD, just _how_ you'd do it with Chef through ChefSpec.

This will require us to:

- Install Java
- Download the required JAR file
- Run that JAR file as a system service

We'll be following the [<i class="fa fa-gitlab"></i> jar-deploy-cookbook][jar-deploy-cookbook] for this blog post, and are using ChefDK version 3.1.0:

```
Chef Development Kit Version: 3.1.0
chef-client version: 14.2.0
delivery version: master (6862f27aba89109a9630f0b6c6798efec56b4efe)
berks version: 7.0.4
kitchen version: 1.22.0
inspec version: 2.1.72
```

I'll assume some familiarity with Chef and how we write recipes for it, but will not expect any knowledge of ChefSpec.

Also note that although this is a fairly Java-specific example, all the practices are transferable and hopefully make sense - if not, please contact me (via the details in the footer) and let me know.

Finally, you'll notice there is are no FoodCritic, CookStyle, or other checks that are performed as part of the cookbook written as part of this article. These definitely should be practiced, but for the purpose of this cookbook, we won't bother.

# A note about versioning

Chef cookbooks in and around the community are built with [Semantic Versioning] as their versioning scheme.

Although I'd recommend reading the specification in full, the TL;DR is:

- we start our version as 0.1.0
- the `1` in `0.1` is a minor release, which indicates functional changes
- as we're in a `0.x` release, we're able to push out breaking changes, as a `0.x` release does not promise backwards compatibility
- when we're happy with the API for the cookbook, we'll release it as `1.0`
- if you have any functional changes, that **are** backwards compatible, the cookbook will be released as a minor bump, i.e as `0.2.0`.
- if you have any bug/security fixes, that **are** backwards compatible, the cookbook will be released as a patch bump, i.e as `0.1.1`.

# jar-deploy-cookbook v0.1

## Bootstrapping our Cookbook

We want to start by generating our cookbook boilerplate:

```
$ chef generate cookbook jar-deploy-cookbook
```

This will give us the basic structure of our cookbook.

## Contract-Driven Tests with InSpec and Test Kitchen

In a very test-first manner, we'll write our smoke tests using InSpec to give us confidence that our cookbook converges successfully.

```ruby
# test/integration/default/default_test.rb

describe command('java -version') do
  its('exit_status') { should eq 0 }
  its('stderr') { should match(/openjdk version "1\.8\..*"/) }
end

describe service('jar') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(8080) do
  it { should be_listening }
  its('processes') { should include 'java' }
end
```

Notice that we're not checking every aspect of our converged node, as we can cover our core functionality in our unit tests. We then have our smoke tests to just verify that things look alright, as we've got a lot of confidence in our recipes through our unit tests.

We also want to set up our `.kitchen.yml` to specify how we want the attributes and recipe(s) to be used:

```yaml
run_list:
- recipe[jar-deploy-cookbook::default]
attributes:
  java:
    jdk_version: '8'
  jar:
    user: jar_user
    group: jar_group
    directory: /var/wibble/foo
    jar_uri: https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/2.18.0/wiremock-standalone-2.18.0.jar
```

This has helped us drive our contract for the cookbook and defines how it'll be consumed. While implementing the cookbook itself, we'll be able to find out if our contract isn't as clear/obvious as we thought.

## Installing Java

Now we've set up what our initial cookbook attributes and recipes should look like, we need perform our first piece of required functionality - installing Java.

### Manually installing the package

The quickest path to getting Java installed is to simply install package with the `package` resource:

```ruby
describe 'jar-deploy-cookbook::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'installs the OpenJDK' do
      expect(chef_run).to install_package('install OpenJDK')
        .with(package_name: 'openjdk-8-jre-headless')
    end

    # ...
  end

  context 'When all attributes are default, on CentOS 7.4.1708' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    it 'installs the OpenJDK' do
      expect(chef_run).to install_package('install OpenJDK')
        .with(package_name: 'java-1.8.0-openjdk-headless')
    end

    # ...
  end
end
```

Notice that we're supporting multiple platforms, which isn't necessarily a requirement, as that'll depend on your own reasoning for creating the cookbook. However, it does enable me to show how you'd interact with different platforms and in this case, install different packages per platform.

In true TDD fashion, we'll make sure we have failing (red) tests and then make them pass (green):

```
F.F.

Failures:

  1) jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 installs the OpenJDK
     Failure/Error:
       expect(chef_run).to install_package('install OpenJDK')
         .with(package_name: 'openjdk-8-jre-headless')

       expected "package[install OpenJDK]" with action :install to be in Chef run. Other package resources:



     # ./spec/unit/recipes/default_spec.rb:17:in `block (3 levels) in <top (required)>'

  2) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 installs the OpenJDK
     Failure/Error:
       expect(chef_run).to install_package('install OpenJDK')
         .with(package_name: 'java-1.8.0-openjdk-headless')

       expected "package[install OpenJDK]" with action :install to be in Chef run. Other package resources:



     # ./spec/unit/recipes/default_spec.rb:33:in `block (3 levels) in <top (required)>'

Finished in 0.67644 seconds (files took 2.52 seconds to load)
4 examples, 2 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:16 # jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 installs the OpenJDK
rspec ./spec/unit/recipes/default_spec.rb:32 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 installs the OpenJDK
```

And now we can implement it using [Ohai's] magic attributes to determine which platform we're on:

```ruby
package 'install OpenJDK' do
  case node['platform']
  when 'ubuntu'
    package_name 'openjdk-8-jre-headless'
  when 'centos'
    package_name 'java-1.8.0-openjdk-headless'
  end
end
```

These pass our tests - great stuff!

```
....

Finished in 0.68183 seconds (files took 2.51 seconds to load)
4 examples, 0 failures
```

### Supporting multiple platforms

As we can see, this is already getting a little complex, and will be made more difficult for each and every platform that we want to support. Not only that but there may be different versions of Java we want to install, or we may want to have different flavours, i.e. the Oracle JDK or the IBM JDK.

### Re-using the `java` community cookbook

To reduce the complexity within this cookbook, we can instead delegate the installation of the package to the [Java community cookbook], which is well-maintained and is much more configurable.

We have a few choices for how we'd want to pin the version:

```ruby
# pull in any changes, including breaking ones, after the version we've specified
depends 'java', '>= 2.1.1'
# pull in major version changes
depends 'java', '~> 2'
# pull in minor version changes
depends 'java', '~> 2.2'
# pull in patch version changes
depends 'java', '~> 2.2.0'
# pin to this exact version
depends 'java', '2.2.0'
```

In the interest of stability, we will opt for only pulling in patch bumps, and make it manual work to update for new functional changes.

We then, in each `context` block we have, ensure it matches `include_recipe`s, such as:

We want to test that the new recipe is used by our tests, so as per ['Testing `include_recipe`s with Chef and ChefSpec'][include_recipe], we can add the following in our spec:

```ruby
describe 'jar-deploy-cookbook::default' do
  context '...' do
    # ...

    before :each do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
        .with('java::default')
    end

    it 'installs Java using the java::default recipe' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('java::default')
      chef_run
    end
  end
end
```

This both allows us to verify that a recipe has been `include_recipe`d, as well as making sure that the ChefSpec run doesn't actually `include_recipe` that recipe, which would slow down our Chef run dramatically.

When running our tests, we get some expected red tests:

```
F.F.

Failures:

  1) jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 installs Java using the java::default recipe
     Failure/Error: DEFAULT_FAILURE_NOTIFIER = lambda { |failure, _opts| raise failure }
       Exactly one instance should have received the following message(s) but didn't: include_recipe
     #   (large stacktrace)
     #
     #   Showing full backtrace because every line was filtered out.
     #   See docs for RSpec::Configuration#backtrace_exclusion_patterns and
     #   RSpec::Configuration#backtrace_inclusion_patterns for more information.

  2) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 installs Java using the java::default recipe
     Failure/Error: DEFAULT_FAILURE_NOTIFIER = lambda { |failure, _opts| raise failure }
       Exactly one instance should have received the following message(s) but didn't: include_recipe
     #   (large stacktrace)
     #
     #   Showing full backtrace because every line was filtered out.
     #   See docs for RSpec::Configuration#backtrace_exclusion_patterns and
     #   RSpec::Configuration#backtrace_inclusion_patterns for more information.

Finished in 3.08 seconds (files took 2.42 seconds to load)
4 examples, 2 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:22 # jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 installs Java using the java::default recipe
rspec ./spec/unit/recipes/default_spec.rb:44 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 installs Java using the java::default recipe
```

Which can now be resolved by adding the following to our `default` recipe:

```ruby
include_recipe 'java::default'
```

Which gives us our passing tests again:

```
....

Finished in 6.56 seconds (files took 2.41 seconds to load)
4 examples, 0 failures
```

## Downloading the JAR

Now we've installed Java, we can go about getting our JAR file onto the box.

### Creating a directory structure

First, we need to create a directory for the JAR to be pulled into. Following the practice of least privileges, we'll also need a user to be created, which can then own the directory.

Notice that we're creating two sets of test cases for our new configurable attributes - we need one set of tests to test our defaults, and one where they're overridden. We have separate test cases for the defaults to catch any inadvertent breaking changes if someone were to make a change to the defaults, and accidentally break backwards compatibility. We also override it to make sure that we _can_ actually override it and we've not accidentally hardcoded it.

```ruby
describe 'jar-deploy-cookbook::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    # ...

    it 'creates the user and group' do
      expect(chef_run).to create_user('creates the user')
        .with(username: 'jar')
        .with(group: 'jar')
    end

    it 'creates the containing directory' do
      expect(chef_run).to create_directory('creates the containing directory')
        .with(path: '/var/jar')
        .with(owner: 'jar')
        .with(group: 'jar')
    end

    # ...
  end

  context 'When all attributes are default, on CentOS 7.4.1708' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    # ...

    it 'creates the user and group' do
      expect(chef_run).to create_user('creates the user')
        .with(username: 'jar')
        .with(group: 'jar')
    end

    it 'creates the containing directory' do
      expect(chef_run).to create_directory('creates the containing directory')
        .with(path: '/var/jar')
        .with(owner: 'jar')
        .with(group: 'jar')
    end

    # ...
  end

  context 'When overriding user and group, when the platform is irrelevant' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.automatic['jar']['user'] = 'jar_user'
        node.automatic['jar']['group'] = 'deployment'
      end
      runner.converge(described_recipe)
    end

    before :each do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
        .with('java::default')
    end

    it 'creates the user and group' do
      expect(chef_run).to create_user('creates the user')
        .with(username: 'jar_user')
        .with(group: 'deployment')
    end

    it 'creates the containing directory' do
      # notice we're not checking the `path`
      expect(chef_run).to create_directory('creates the containing directory')
        .with(owner: 'jar_user')
        .with(group: 'deployment')
    end
  end
end
```

Note that when we override the user/group, we only check that the `owner` and `group` on `directory[creates the containing directory]` is updated, as they're the only parameters we care about in that case. We can do this because we're confident that the other parameters are checked as part of the default cases.

Now we've used our test to define what the default should be for our attributes, we'd want to specify them within the `attributes/default.rb` file:

```ruby
node.default['jar']['user'] = 'jar'
node.default['jar']['group'] = 'jar'
```

These tests will then rightly fail, as we've not yet implemented the recipe:

```
...FF.FF

Failures:

  1) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates the user and group
     Failure/Error:
       expect(chef_run).to create_user('creates the user')
         .with(username: 'jar')
         .with(group: 'jar')

       expected "user[creates the user]" with action :create to be in Chef run. Other user resources:



     # ./spec/unit/recipes/default_spec.rb:50:in `block (3 levels) in <top (required)>'

  2) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates the containing directory
     Failure/Error:
       expect(chef_run).to create_directory('creates the containing directory')
         .with(path: '/var/jar')
         .with(owner: 'jar')
         .with(group: 'jar')

       expected "directory[creates the containing directory]" with action :create to be in Chef run. Other directory resources:



     # ./spec/unit/recipes/default_spec.rb:56:in `block (3 levels) in <top (required)>'

  3) jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates the user and group
     Failure/Error:
       expect(chef_run).to create_user('creates the user')
         .with(username: 'jar_user')
         .with(group: 'deployment')

       expected "user[creates the user]" with action :create to be in Chef run. Other user resources:



     # ./spec/unit/recipes/default_spec.rb:83:in `block (3 levels) in <top (required)>'

  4) jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates the containing directory
     Failure/Error:
       expect(chef_run).to create_directory('creates the containing directory')
         .with(owner: 'jar_user')
         .with(group: 'deployment')

       expected "directory[creates the containing directory]" with action :create to be in Chef run. Other directory resources:



     # ./spec/unit/recipes/default_spec.rb:90:in `block (3 levels) in <top (required)>'

Finished in 5.32 seconds (files took 2.49 seconds to load)
8 examples, 4 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:49 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates the user and group
rspec ./spec/unit/recipes/default_spec.rb:55 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates the containing directory
rspec ./spec/unit/recipes/default_spec.rb:82 # jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates the user and group
rspec ./spec/unit/recipes/default_spec.rb:88 # jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates the containing directory
```

Allowing us to add the following implementation into `recipes/default.rb`:


```ruby
# ...

directory 'creates the containing directory' do
  path '/var/jar'
  owner node['jar']['user']
  group node['jar']['group']
end
```

Which gives us passing tests:

```
..........

Finished in 6.44 seconds (files took 2.5 seconds to load)
10 examples, 0 failures
```

### Making that directory configurable

Now although we've created that directory for the JAR to be run from, consumers of the cookbook want to make it configurable, for instance provide some logging agent access to it. In fact, we'd even specified it should be configurable in our `.kitchen.yml`!

So let's update our tests to make it configurable. First, we add a new test, to check that when we do change the attribute, the `directory` resource is configured with the overriden directory attribute. We're only checking that `path` and `recursive` are set to the correct values, because we're using the default values of the `user` and `group`:

```ruby
describe 'jar-deploy-cookbook::default' do
  context 'When overriding jar.directory, when the platform is irrelevant' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.automatic['jar']['directory'] = '/var/jar-deploy'
      end
      runner.converge(described_recipe)
    end

    before :each do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
        .with('java::default')
    end

    it 'creates the containing directory' do
      # notice we're not checking `user` or `group`
      expect(chef_run).to create_directory('creates the containing directory')
        .with(path: '/var/jar-deploy')
        .with(recursive: true)
    end
  end
end
```

Next, we update our existing tests to ensure that we are creating the directory in a `recursive` fashion. This is because we don't know exactly _where_ the directory is going to be created, so it could be that the parent directory structure may not exist, so we need to make sure that we create it.

This is unfortunately not something that ChefSpec will warn you about - it's not until we get to integration testing with Test Kitchen that you'll see errors. I've preemptively put this change in as it's bitten me before!

```diff
 describe 'jar-deploy-cookbook::default' do
   context 'When all attributes are default, on Ubuntu 16.04' do
     # ...

     it 'creates the containing directory' do
       expect(chef_run).to create_directory('creates the containing directory')
         .with(path: '/var/jar')
         .with(owner: 'jar')
         .with(group: 'jar')
+        .with(recursive: true)
     end

     # ...
   end

   context 'When all attributes are default, on CentOS 7.4.1708' do
     # ...

     it 'creates the containing directory' do
       expect(chef_run).to create_directory('creates the containing directory')
         .with(path: '/var/jar')
         .with(owner: 'jar')
         .with(group: 'jar')
+        .with(recursive: true)
     end

     # ...
   end

   context 'When overriding user and group, when the platform is irrelevant' do
     # ...

     it 'creates the containing directory' do
-      # notice we're not checking the `path`
+      # notice we're not checking the `path` or `recursive`
       expect(chef_run).to create_directory('creates the containing directory')
         .with(owner: 'jar_user')
         .with(group: 'deployment')
     end

     # ...
   end
 end
```

And then set the default value of `jar.directory` in our `attributes/default.rb`:

```ruby
node.default['jar']['directory'] = '/var/jar'
```

Our tests will fail:

```
..F...F...F

Failures:

  1) jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 creates the containing directory
     Failure/Error:
       expect(chef_run).to create_directory('creates the containing directory')
         .with(path: '/var/jar')
         .with(owner: 'jar')
         .with(group: 'jar')
         .with(recursive: true)

       expected "directory[creates the containing directory]" to have parameters:

         recursive true, was false
     # ./spec/unit/recipes/default_spec.rb:34:in `block (3 levels) in <top (required)>'

  2) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates the containing directory
     Failure/Error:
       expect(chef_run).to create_directory('creates the containing directory')
         .with(path: '/var/jar')
         .with(owner: 'jar')
         .with(group: 'jar')
         .with(recursive: true)

       expected "directory[creates the containing directory]" to have parameters:

         recursive true, was false
     # ./spec/unit/recipes/default_spec.rb:70:in `block (3 levels) in <top (required)>'

  3) jar-deploy-cookbook::default When overriding jar.directory, when the platform is irrelevant creates the containing directory
     Failure/Error:
       expect(chef_run).to create_directory('creates the containing directory')
         .with(path: '/var/jar-deploy')

       expected "directory[creates the containing directory]" to have parameters:

         path "/var/jar-deploy", was "/var/jar"
     # ./spec/unit/recipes/default_spec.rb:127:in `block (3 levels) in <top (required)>'

Finished in 6.99 seconds (files took 2.53 seconds to load)
11 examples, 3 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:33 # jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 creates the containing directory
rspec ./spec/unit/recipes/default_spec.rb:69 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates the containing directory
rspec ./spec/unit/recipes/default_spec.rb:125 # jar-deploy-cookbook::default When overriding jar.directory, when the platform is irrelevant creates the containing directory
```

To make this tests green, we'll need to make `path` configurable and specify `recursive true`:

```diff
 directory 'creates the containing directory' do
-  path '/var/jar'
+  path node['jar']['directory']
   owner node['jar']['user']
   group node['jar']['group']
+  recursive true
 end
```

Which gives us passing tests!

```
...........

Finished in 6.89 seconds (files took 2.56 seconds to load)
11 examples, 0 failures
```

### What's the default JAR file?

It turns out that we can't actually default this cookbook to a JAR file, as there's no default generic JAR a consumer would want. Instead, we want to throw an error when no JAR is specified:

```ruby
describe 'jar-deploy-cookbook::default' do
  context 'When the jar.jar_uri is not specified, when the platform is irrelevant' do
    let(:runner) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      # note we don't converge here
    end

    before :each do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
        .with('java::default')
    end

    it 'raises an error' do
      expect { runner.converge(described_recipe) }.to raise_error('jar.jar_uri is not specified')
    end
  end
end
```

We need to make sure that we're explicitly defaulting the `jar.jar_uri` to `nil`, otherwise Chef will complain we don't have the attribute set:

```ruby
# attributes/default.rb
node.default['jar']['jar_uri'] = nil
```

Now when we run our tests, we get an expected test failure where we don't have an exception raised:

```
F...........

Failures:

  1) jar-deploy-cookbook::default When the jar.jar_uri is not specified, when the platform is irrelevant raises an error
     Failure/Error: expect { runner.converge(described_recipe) }.to raise_error('jar.jar_uri is not specified')
       expected Exception with "jar.jar_uri is not specified" but nothing was raised
     # ./spec/unit/recipes/default_spec.rb:22:in `block (3 levels) in <top (required)>'

Finished in 7.69 seconds (files took 2.56 seconds to load)
12 examples, 1 failure

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:21 # jar-deploy-cookbook::default When the jar.jar_uri is not specified, when the platform is irrelevant raises an error
```

We can update our `default` recipe to throw an error to get our tests passing:

```diff
+raise 'jar.jar_uri is not specified' if node['jar']['jar_uri'].nil?
+
 include_recipe 'java::default'

 # ...
```

However, when we run our tests now we've actually got a _tonne_ of failures! Oops.

```
.FFFFFFFFFFF

Failures:

  1) jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 installs Java using the java::default recipe
     Failure/Error: runner.converge(described_recipe)

     RuntimeError:
       jar.jar_uri is not specified
     # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
     # ./spec/unit/recipes/default_spec.rb:29:in `block (3 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:40:in `block (3 levels) in <top (required)>'

  2) jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 creates the user and group
     Failure/Error: runner.converge(described_recipe)

     RuntimeError:
       jar.jar_uri is not specified
     # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
     # ./spec/unit/recipes/default_spec.rb:29:in `block (3 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:44:in `block (3 levels) in <top (required)>'

  3) jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 creates the containing directory
     Failure/Error: runner.converge(described_recipe)

     RuntimeError:
       jar.jar_uri is not specified
     # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
     # ./spec/unit/recipes/default_spec.rb:29:in `block (3 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:50:in `block (3 levels) in <top (required)>'

  4) jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 converges successfully
     Failure/Error: expect { chef_run }.to_not raise_error

       expected no Exception, got #<RuntimeError: jar.jar_uri is not specified> with backtrace:
         # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
         # ./spec/unit/recipes/default_spec.rb:29:in `block (3 levels) in <top (required)>'
         # ./spec/unit/recipes/default_spec.rb:58:in `block (4 levels) in <top (required)>'
         # ./spec/unit/recipes/default_spec.rb:58:in `block (3 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:58:in `block (3 levels) in <top (required)>'

  5) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 installs Java using the java::default recipe
     Failure/Error: runner.converge(described_recipe)

     RuntimeError:
       jar.jar_uri is not specified
     # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
     # ./spec/unit/recipes/default_spec.rb:65:in `block (3 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:76:in `block (3 levels) in <top (required)>'

  6) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates the user and group
     Failure/Error: runner.converge(described_recipe)

     RuntimeError:
       jar.jar_uri is not specified
     # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
     # ./spec/unit/recipes/default_spec.rb:65:in `block (3 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:80:in `block (3 levels) in <top (required)>'

  7) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates the containing directory
     Failure/Error: runner.converge(described_recipe)

     RuntimeError:
       jar.jar_uri is not specified
     # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
     # ./spec/unit/recipes/default_spec.rb:65:in `block (3 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:86:in `block (3 levels) in <top (required)>'

  8) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 converges successfully
     Failure/Error: expect { chef_run }.to_not raise_error

       expected no Exception, got #<RuntimeError: jar.jar_uri is not specified> with backtrace:
         # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
         # ./spec/unit/recipes/default_spec.rb:65:in `block (3 levels) in <top (required)>'
         # ./spec/unit/recipes/default_spec.rb:94:in `block (4 levels) in <top (required)>'
         # ./spec/unit/recipes/default_spec.rb:94:in `block (3 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:94:in `block (3 levels) in <top (required)>'

  9) jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates the user and group
     Failure/Error: runner.converge(described_recipe)

     RuntimeError:
       jar.jar_uri is not specified
     # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
     # ./spec/unit/recipes/default_spec.rb:104:in `block (3 levels) in <top (required)>'
     # ./spec/unit/recipes/default_spec.rb:114:in `block (3 levels) in <top (required)>'

  10) jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates the containing directory
      Failure/Error: runner.converge(described_recipe)

      RuntimeError:
        jar.jar_uri is not specified
      # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
      # ./spec/unit/recipes/default_spec.rb:104:in `block (3 levels) in <top (required)>'
      # ./spec/unit/recipes/default_spec.rb:121:in `block (3 levels) in <top (required)>'

  11) jar-deploy-cookbook::default When overriding jar.directory, when the platform is irrelevant creates the containing directory
      Failure/Error: runner.converge(described_recipe)

      RuntimeError:
        jar.jar_uri is not specified
      # /tmp/chefspec20180903-26075-1fhni1tfile_cache_path/cookbooks/jar-deploy-cookbook/recipes/default.rb:6:in `from_file'
      # ./spec/unit/recipes/default_spec.rb:132:in `block (3 levels) in <top (required)>'
      # ./spec/unit/recipes/default_spec.rb:143:in `block (3 levels) in <top (required)>'

Finished in 7.31 seconds (files took 2.41 seconds to load)
12 examples, 11 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:38 # jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 installs Java using the java::default recipe
rspec ./spec/unit/recipes/default_spec.rb:43 # jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 creates the user and group
rspec ./spec/unit/recipes/default_spec.rb:49 # jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 creates the containing directory
rspec ./spec/unit/recipes/default_spec.rb:57 # jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 converges successfully
rspec ./spec/unit/recipes/default_spec.rb:74 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 installs Java using the java::default recipe
rspec ./spec/unit/recipes/default_spec.rb:79 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates the user and group
rspec ./spec/unit/recipes/default_spec.rb:85 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates the containing directory
rspec ./spec/unit/recipes/default_spec.rb:93 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 converges successfully
rspec ./spec/unit/recipes/default_spec.rb:113 # jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates the user and group
rspec ./spec/unit/recipes/default_spec.rb:119 # jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates the containing directory
rspec ./spec/unit/recipes/default_spec.rb:141 # jar-deploy-cookbook::default When overriding jar.directory, when the platform is irrelevant creates the containing directory
```

As we can see, we now need to set the `jar.jar_uri` in each of our other tests, otherwise the `raise` will be triggered as `jar.jar_uri` is defaulted to `nil`.

```diff
 require 'spec_helper'

 describe 'jar-deploy-cookbook::default' do
-  context 'When all attributes are default, on Ubuntu 16.04' do
+  context 'When all but the jar.jar_uri attributes are default, on Ubuntu 16.04' do
     let(:chef_run) do
-      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
+      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
+        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
+      end
       runner.converge(described_recipe)
     end

     # ...
   end

-  context 'When all attributes are default, on CentOS 7.4.1708' do
+  context 'When all all but the jar.jar_uri attributes are default, on CentOS 7.4.1708' do
     let(:chef_run) do
-      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
+      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708') do |node|
+        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
+      end
+
       runner.converge(described_recipe)
     end

     # ...
   end

   context 'When overriding user and group, when the platform is irrelevant' do
     let(:chef_run) do
       runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
+        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
         node.automatic['jar']['user'] = 'jar_user'
         node.automatic['jar']['group'] = 'deployment'
       end
     end

     # ...
   end

   context 'When overriding jar.directory, when the platform is irrelevant' do
     let(:chef_run) do
       runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
+        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
         node.automatic['jar']['directory'] = '/var/jar-deploy'
       end
       runner.converge(described_recipe)
     end

     # ...
   end
 end
```

Once this is in, our tests will pass successfully.

### Actually downloading it

Now, we've checked that there's a `jar.jar_uri`, but we don't actually pull that JAR. We can do that using the `remote_file` resource built in to Chef:

```ruby
describe 'jar-deploy-cookbook::default' do
  context 'When all but the jar.jar_uri attributes are default, on Ubuntu 16.04' do
    # ...

    it 'downloads the JAR' do
      expect(chef_run).to create_remote_file('download the JAR')
        .with(source: 'https://example.com/jar')
        .with(path: '/var/jar/jar.jar')
        .with(owner: 'jar')
        .with(group: 'jar')
    end
  end

  context 'When all all but the jar.jar_uri attributes are default, on CentOS 7.4.1708' do
    # ...

    it 'downloads the JAR' do
      expect(chef_run).to create_remote_file('download the JAR')
        .with(source: 'https://example.com/jar')
        .with(path: '/var/jar/jar.jar')
        .with(owner: 'jar')
        .with(group: 'jar')
    end
  end

  context 'When overriding user and group, when the platform is irrelevant' do
    # ...

    it 'downloads the JAR' do
      # notice we only care about `owner` and `group`
      expect(chef_run).to create_remote_file('download the JAR')
        .with(owner: 'jar_user')
        .with(group: 'deployment')
    end
  end

  context 'When overriding jar.directory, when the platform is irrelevant' do
    # ...

    it 'downloads the JAR' do
      # notice we only care about `path`
      expect(chef_run).to create_remote_file('download the JAR')
        .with(path: '/var/jar-deploy/jar.jar')
    end
  end
end
```

We'll find that we'll have some red tests as the `remote_file`s aren't matched:

```
....F....F...F.F

Failures:

  1) jar-deploy-cookbook::default When all but the jar.jar_uri attributes are default, on Ubuntu 16.04 downloads the JAR
     Failure/Error:
       expect(chef_run).to create_remote_file('download the JAR')
         .with(source: 'https://example.com/jar')
         .with(path: '/var/jar/jar.jar')
         .with(owner: 'jar')
         .with(group: 'jar')

       expected "remote_file[download the JAR]" with action :create to be in Chef run. Other remote_file resources:



     # ./spec/unit/recipes/default_spec.rb:60:in `block (3 levels) in <top (required)>'

  2) jar-deploy-cookbook::default When all all but the jar.jar_uri attributes are default, on CentOS 7.4.1708 downloads the JAR
     Failure/Error:
       expect(chef_run).to create_remote_file('download the JAR')
         .with(source: 'https://example.com/jar')
         .with(path: '/var/jar/jar.jar')
         .with(owner: 'jar')
         .with(group: 'jar')

       expected "remote_file[download the JAR]" with action :create to be in Chef run. Other remote_file resources:



     # ./spec/unit/recipes/default_spec.rb:107:in `block (3 levels) in <top (required)>'

  3) jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant downloads the JAR
     Failure/Error:
       expect(chef_run).to create_remote_file('download the JAR')
         .with(owner: 'jar_user')
         .with(group: 'deployment')

       expected "remote_file[download the JAR]" with action :create to be in Chef run. Other remote_file resources:



     # ./spec/unit/recipes/default_spec.rb:150:in `block (3 levels) in <top (required)>'

  4) jar-deploy-cookbook::default When overriding jar.directory, when the platform is irrelevant downloads the JAR
     Failure/Error:
       expect(chef_run).to create_remote_file('download the JAR')
         .with(path: '/var/jar-deploy/jar.jar')

       expected "remote_file[download the JAR]" with action :create to be in Chef run. Other remote_file resources:



     # ./spec/unit/recipes/default_spec.rb:180:in `block (3 levels) in <top (required)>'

Finished in 10.01 seconds (files took 2.42 seconds to load)
16 examples, 4 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:59 # jar-deploy-cookbook::default When all but the jar.jar_uri attributes are default, on Ubuntu 16.04 downloads the JAR
rspec ./spec/unit/recipes/default_spec.rb:106 # jar-deploy-cookbook::default When all all but the jar.jar_uri attributes are default, on CentOS 7.4.1708 downloads the JAR
rspec ./spec/unit/recipes/default_spec.rb:148 # jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant downloads the JAR
rspec ./spec/unit/recipes/default_spec.rb:178 # jar-deploy-cookbook::default When overriding jar.directory, when the platform is irrelevant downloads the JAR

```

Which we can implement with the following addition to our recipe:

```diff
 directory 'creates the containing directory' do
 # ...
 end

+remote_file 'download the JAR' do
+  source node['jar']['jar_uri']
+  path "#{node['jar']['directory']}/jar.jar"
+  owner node['jar']['user']
+  group node['jar']['group']
+end
```

Which gives us our green tests:

```
................

Finished in 9.87 seconds (files took 2.59 seconds to load)
16 examples, 0 failures
```

### Note about `remote_file`

`remote_file` is an awesome way to download artefacts from various locations, from [the Chef documentation][remote_file]:

> The location of the source file may be HTTP (`http://`), FTP (`ftp://`), SFTP (`sftp://`), local (`file:///`), or UNC (`\\host\share\file.tar.gz`).

This is useful for when you have locally cached dependencies i.e. in a VM share from your host, or if you want to pull from an external service.

It also allows for a vast amount of goodness such as being able to provide remote authentication, HTTP headers, and more.

### Splitting Complexity Out

When developing using TDD, if you encounter a method to a method/class being too complex, you look to refactor it as it feels painful to work with. We're also seeing that here, where due to the `raise`, we have to complicate the required attributes for the recipe.

```diff
 require 'spec_helper'

 describe 'jar-deploy-cookbook::default' do
-  context 'When the jar.jar_uri is not specified, when the platform is irrelevant' do
-    let(:runner) do
-      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
-    end
-
-    before :each do
-      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
-      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
-        .with('java::default')
-    end
-
-    it 'raises an error' do
-      expect { runner.converge(described_recipe) }.to raise_error('jar.jar_uri is not specified')
-    end
-  end
-
-  context 'When all but the jar.jar_uri attributes are default, on Ubuntu 16.04' do
+  context 'When all attributes are default, on Ubuntu 16.04' do
     let(:chef_run) do
       runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
-        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
       end
       runner.converge(described_recipe)
     end

     before :each do
       allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
+      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
+        .with('jar-deploy-cookbook::download_jar')
       allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
         .with('java::default')
     end
@@ -56,15 +41,19 @@ describe 'jar-deploy-cookbook::default' do
         .with(recursive: true)
     end

+    it 'downloads the JAR using the ::download_jar recipe' do
+      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('jar-deploy-cookbook::download_jar')
+      chef_run
+    end
+
     it 'converges successfully' do
       expect { chef_run }.to_not raise_error
     end
   end

-  context 'When all all but the jar.jar_uri attributes are default, on CentOS 7.4.1708' do
+  context 'When all attributes are default, on CentOS 7.4.1708' do
     let(:chef_run) do
       runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708') do |node|
-        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
       end

       runner.converge(described_recipe)
@@ -72,6 +61,8 @@ describe 'jar-deploy-cookbook::default' do

     before :each do
       allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
+      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
+        .with('jar-deploy-cookbook::download_jar')
       allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
         .with('java::default')
     end
@@ -95,6 +86,11 @@ describe 'jar-deploy-cookbook::default' do
         .with(recursive: true)
     end

+    it 'downloads the JAR using the ::download_jar recipe' do
+      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('jar-deploy-cookbook::download_jar')
+      chef_run
+    end
+
     it 'converges successfully' do
       expect { chef_run }.to_not raise_error
     end
@@ -103,7 +99,6 @@ describe 'jar-deploy-cookbook::default' do
   context 'When overriding user and group, when the platform is irrelevant' do
     let(:chef_run) do
       runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
-        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
         node.automatic['jar']['user'] = 'jar_user'
         node.automatic['jar']['group'] = 'deployment'
       end
@@ -112,6 +107,8 @@ describe 'jar-deploy-cookbook::default' do

     before :each do
       allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
+      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
+        .with('jar-deploy-cookbook::download_jar')
       allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
         .with('java::default')
     end
@@ -133,7 +130,6 @@ describe 'jar-deploy-cookbook::default' do
   context 'When overriding jar.directory, when the platform is irrelevant' do
     let(:chef_run) do
       runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
-        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
         node.automatic['jar']['directory'] = '/var/jar-deploy'
       end
       runner.converge(described_recipe)
@@ -141,6 +137,8 @@ describe 'jar-deploy-cookbook::default' do

     before :each do
       allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
+      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
+        .with('jar-deploy-cookbook::download_jar')
       allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
         .with('java::default')
     end
```

And create a new recipe, driven through a new spec file:

```ruby
require 'spec_helper'

describe 'jar-deploy-cookbook::download_jar' do
  context 'When the jar.jar_uri is not specified, when the platform is irrelevant' do
    let(:runner) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
    end

    it 'raises an error' do
      expect { runner.converge(described_recipe) }.to raise_error('jar.jar_uri is not specified')
    end
  end

  context 'When the jar.jar_uri is specified and other attributes are default, when the platform is irrelevant' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
      end
      runner.converge(described_recipe)
    end

    it 'downloads the JAR' do
      expect(chef_run).to create_remote_file('download the JAR')
        .with(source: 'https://example.com/jar')
        .with(path: '/var/jar/jar.jar')
        .with(user: 'jar')
        .with(group: 'jar')
    end
  end

  context 'When the jar.jar_uri is specified and user and group are overriden, when the platform is irrelevant' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
        node.automatic['jar']['user'] = 'abc'
        node.automatic['jar']['group'] = 'def'
      end
      runner.converge(described_recipe)
    end

    it 'downloads the JAR' do
      # notice we don't check for `path`
      expect(chef_run).to create_remote_file('download the JAR')
        .with(source: 'https://example.com/jar')
        .with(user: 'abc')
        .with(group: 'def')
    end
  end

  context 'When the jar.jar_uri is specified and jar.directory is overriden, when the platform is irrelevant' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.automatic['jar']['jar_uri'] = 'https://example.com/jar'
        node.automatic['jar']['directory'] = '/opt/directory'
      end
      runner.converge(described_recipe)
    end

    it 'downloads the JAR' do
      # notice we don't check `user` and `group`
      expect(chef_run).to create_remote_file('download the JAR')
        .with(source: 'https://example.com/jar')
        .with(path: '/opt/directory/jar.jar')
    end
  end
end
```

We update our `default` recipe to include the `download_jar` recipe:

```diff
@@ -3,8 +3,6 @@
 # Recipe:: default
 #
 # Copyright:: 2018, Jamie Tanna, Apache-2.0
-raise 'jar.jar_uri is not specified' if node['jar']['jar_uri'].nil?
-
 include_recipe 'java::default'

 # ...
+
+include_recipe 'jar-deploy-cookbook::download_jar'
```

Which in turn will `raise` if the `jar.jar_uri` is not specified:

```ruby
#
# Cookbook:: jar-deploy-cookbook
# Recipe:: download_jar
#
# Copyright:: 2018, Jamie Tanna, Apache-2.0
raise 'jar.jar_uri is not specified' if node['jar']['jar_uri'].nil?

remote_file 'download the JAR' do
  source node['jar']['jar_uri']
  path "#{node['jar']['directory']}/jar.jar"
  owner node['jar']['user']
  group node['jar']['group']
end
```

## Creating a systemd service

To create a systemd service to run our JAR file, we need to interact with a Chef `template` resource:

```ruby
describe 'jar-deploy-cookbook::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    # ...

    it 'creates a systemd service file' do
      expect(chef_run).to create_template('create a systemd service file')
        .with(source: 'unit.service.erb')
        .with(path: '/etc/systemd/system/jar.service')
        .with(owner: 'root')
        .with(group: 'root')
        .with(variables: {
                path_to_jar: '/var/jar/jar.jar',
                user: 'jar'
              })

      expect(chef_run).to(render_file('/etc/systemd/system/jar.service')
        .with_content do |content|
          expect(content).to match %r{^User=jar$}
          expect(content).to match %r{^ExecStart=/usr/bin/java -jar /var/jar/jar\.jar$}
        end)
    end
  end
  context 'When all attributes are default, on CentOS 7.4.1708' do
    # ...

    it 'creates a systemd service file' do
      expect(chef_run).to create_template('create a systemd service file')
        .with(source: 'unit.service.erb')
        .with(path: '/etc/systemd/system/jar.service')
        .with(owner: 'root')
        .with(group: 'root')
        .with(variables: {
                path_to_jar: '/var/jar/jar.jar',
                user: 'jar'
              })

      expect(chef_run).to(render_file('/etc/systemd/system/jar.service')
        .with_content do |content|
          expect(content).to match %r{^User=jar$}
          expect(content).to match %r{^ExecStart=/usr/bin/java -jar /var/jar/jar\.jar$}
        end)
    end
  end

  context 'When overriding user and group, when the platform is irrelevant' do
    # ...

    it 'creates a systemd service file' do
      expect(chef_run).to create_template('create a systemd service file')
        .with(variables: {
                path_to_jar: '/var/jar/jar.jar',
                user: 'jar_user'
              })

      expect(chef_run).to(render_file('/etc/systemd/system/jar.service')
        .with_content do |content|
          expect(content).to match %r{^User=jar_user$}
        end)
    end
  end

  context 'When overriding jar.directory, when the platform is irrelevant' do
    # ...

    it 'creates a systemd service file' do
      expect(chef_run).to create_template('create a systemd service file')
        .with(variables: {
                path_to_jar: '/var/jar-deploy/jar.jar',
                user: 'jar'
              })

      expect(chef_run).to(render_file('/etc/systemd/system/jar.service')
        .with_content do |content|
          expect(content).to match %r{^ExecStart=/usr/bin/java -jar /var/jar-deploy/jar\.jar$}
        end)
    end
  end
end
```

Notice how we're not currently verifying our systemd service file is all generated successfully, only the sections that are configuration-specific, and again, only testing where relevant.

This gives us the following failing tests:

```
....F.....F...F.F....

Failures:

  1) jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 creates a systemd service file
     Failure/Error:
       expect(chef_run).to create_template('create a systemd service file')
         .with(source: 'unit.service.erb')
         .with(path: '/etc/systemd/system/jar.service')
         .with(owner: 'root')
         .with(group: 'root')
         .with(variables: {
                 path_to_jar: '/var/jar/jar.jar',
                 user: 'jar'
               })

       expected "template[create a systemd service file]" with action :create to be in Chef run. Other template resources:



     # ./spec/unit/recipes/default_spec.rb:50:in `block (3 levels) in <top (required)>'

  2) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates a systemd service file
     Failure/Error:
       expect(chef_run).to create_template('create a systemd service file')
         .with(source: 'unit.service.erb')
         .with(path: '/etc/systemd/system/jar.service')
         .with(owner: 'root')
         .with(group: 'root')
         .with(variables: {
                 path_to_jar: '/var/jar/jar.jar',
                 user: 'jar'
               })

       expected "template[create a systemd service file]" with action :create to be in Chef run. Other template resources:



     # ./spec/unit/recipes/default_spec.rb:113:in `block (3 levels) in <top (required)>'

  3) jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates a systemd service file
     Failure/Error:
       expect(chef_run).to create_template('create a systemd service file')
         .with(variables: {
                 path_to_jar: '/var/jar/jar.jar',
                 user: 'jar_user'
               })

       expected "template[create a systemd service file]" with action :create to be in Chef run. Other template resources:



     # ./spec/unit/recipes/default_spec.rb:166:in `block (3 levels) in <top (required)>'

  4) jar-deploy-cookbook::default When overriding jar.directory, when the platform is irrelevant creates a systemd service file
     Failure/Error:
       expect(chef_run).to create_template('create a systemd service file')
         .with(variables: {
                 path_to_jar: '/var/jar-deploy/jar.jar',
                 user: 'jar'
               })

       expected "template[create a systemd service file]" with action :create to be in Chef run. Other template resources:



     # ./spec/unit/recipes/default_spec.rb:203:in `block (3 levels) in <top (required)>'

Finished in 13.02 seconds (files took 2.45 seconds to load)
21 examples, 4 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:49 # jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 creates a systemd service file
rspec ./spec/unit/recipes/default_spec.rb:112 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates a systemd service file
rspec ./spec/unit/recipes/default_spec.rb:165 # jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates a systemd service file
rspec ./spec/unit/recipes/default_spec.rb:202 # jar-deploy-cookbook::default When overriding jar.directory, when the platform is irrelevant creates a systemd service file
```

We use the `template` resource to create the file with its expected configuration:

```ruby
template 'create a systemd service file' do
  source 'unit.service.erb'
  path '/etc/systemd/system/jar.service'
  owner 'root'
  group 'root'
  variables path_to_jar: "#{node['jar']['directory']}/jar.jar",
            user: node['jar']['user']
end
```

Which needs a corresponding file in `templates/default/unit.service.erb`:

```eruby
[Unit]
Description=Run Java JAR

[Service]
User=<%= @user %>
Type=simple
ExecStart=/usr/bin/java -jar <%= @path_to_jar %>
```

However, once we've created the service file, we still need to start and enable the service:

```ruby
describe 'jar-deploy-cookbook::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    # ...

    it 'enables the service' do
      expect(chef_run).to enable_service('enables the jar service')
        .with(service_name: 'jar')
    end

    it 'starts the service' do
      expect(chef_run).to start_service('starts the jar service')
        .with(service_name: 'jar')
    end
  end

  context 'When all attributes are default, on CentOS 7.4.1708' do
    # ...

    it 'enables the service' do
      expect(chef_run).to enable_service('enables the jar service')
        .with(service_name: 'jar')
    end

    it 'starts the service' do
      expect(chef_run).to start_service('starts the jar service')
        .with(service_name: 'jar')
    end
  end
end
```

Which is then implemented with:

```ruby
service 'enables the jar service' do
  service_name 'jar'
  action :enable
end

service 'starts the jar service' do
  service_name 'jar'
  action :start
end
```

## Converging the Node

Wow, we're finally at the stage that we can converge our recipe on a node!

If you think of it, we've been able to iterate much quicker, allowing us to breeze through our unit test writing, without worrying how long it'll take to i.e. actually download and install Java.

If we run it in Test Kitchen, via `kitchen test`, you can see we hit some issues:

<asciinema-player src="/casts/tdd-chef/pre-group.json"></asciinema-player>

Which if you can't read the full error easily, it is:

```
Recipe: jar-deploy-cookbook::default
  * linux_user[creates the user] action create

    ================================================================================
    Error executing action `create` on resource 'linux_user[creates the user]'
    ================================================================================

    Mixlib::ShellOut::ShellCommandFailed
    ------------------------------------
    Expected process to exit with [0], but received '6'
    ---- Begin output of ["useradd", "-g", "jar_group", "-M", "jar_user"] ----
    STDOUT:
    STDERR: useradd: group 'jar_group' does not exist
    ---- End output of ["useradd", "-g", "jar_group", "-M", "jar_user"] ----
    Ran ["useradd", "-g", "jar_group", "-M", "jar_user"] returned 6

    Resource Declaration:
    ---------------------
    # In /opt/kitchen/cache/cookbooks/jar-deploy-cookbook/recipes/default.rb

      8: user 'creates the user' do
      9:   username node['jar']['user']
     10:   group node['jar']['group']
     11: end
     12:

    Compiled Resource:
    ------------------
    # Declared in /opt/kitchen/cache/cookbooks/jar-deploy-cookbook/recipes/default.rb:8:in `from_file'

    linux_user("creates the user") do
      action [:create]
      default_guard_interpreter :default
      username "jar_user"
      uid nil
      gid "jar_group"
      home nil
      iterations 27855
      declared_type :user
      cookbook_name "jar-deploy-cookbook"
      recipe_name "default"
    end

    System Info:
    ------------
    chef_version=14.4.56
    platform=ubuntu
    platform_version=18.04
    ruby=ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]
    program_name=/opt/chef/embedded/bin/chef-client
    executable=/opt/chef/embedded/bin/chef-client
```

### Creating the `jar.group` before we create the `jar.user`

Woops! It looks like the `jar.group` that we thought was created at the same time as the `jar.user` is configured was _not_.

It looks like instead we need to create the resource that will set up the `group`:

```ruby
describe 'jar-deploy-cookbook::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
      # ...

    it 'creates the user and group' do
      expect(chef_run).to create_group('creates the group')
        .with(group_name: 'jar')

      expect(chef_run).to create_user('creates the user')
        .with(username: 'jar')
        .with(group: 'jar')
    end
  end

  context 'When all attributes are default, on CentOS 7.4.1708' do
    it 'creates the user and group' do
      expect(chef_run).to create_group('creates the group')
        .with(group_name: 'jar')

      expect(chef_run).to create_user('creates the user')
        .with(username: 'jar')
        .with(group: 'jar')
    end
  end

  context 'When overriding user and group, when the platform is irrelevant' do
    it 'creates the user and group' do
      expect(chef_run).to create_group('creates the group')
        .with(group_name: 'deployment')

      expect(chef_run).to create_user('creates the user')
        .with(username: 'jar_user')
        .with(group: 'deployment')
    end
  end
end
```

And our implementation:

```diff
 include_recipe 'java::default'

+group 'creates the group' do
+  group_name node['jar']['group']
+end
+
 user 'creates the user' do
```

And now if we re-test:

<asciinema-player src="/casts/tdd-chef/post-group.json"></asciinema-player>

We can set that out as v0.1 happily!

# jar-deploy-cookbook v0.2

Wait, what about any run-time configuration?

Let us say that we have an application that we want to inject in certain configuration, such as running on different ports, or accessing a different S3 bucket for secrets.

In the Java world, we have a few choices:

- command-line arguments
- configuration via i.e. Spring
- Java System properties

In this example, we'll look at the command-line arguments, as the Wiremock JAR allows us to configure it as such. However, you may well want to allow for different use cases, for instance with the following example schema:

```yaml
attributes:
  jar:
    configuration:
      application.properties:
        key: value          # key=value
        integer_value: 1    # integer_value=1
        list:               # list=abc,def,ghi
        - abc
        - def
        - ghi
      commandline_arguments:
        port: 1234          # --port=1234
        hostname: abcd1234  # --hostname=abcd1234
      system_properties:
        skipTests: true      # -DskipTests=true
```

The exact mapping is likely language- or file-format-specific, but you can see that in this example, we've created three separate types of configuration which are mapped differently.

However, one use of this pattern for configuration, over the use of creating a set of specific attributes, is that i.e. 2 months down the road, we'll be able to add a new command-line flag that's added, without needing to update our cookbook. This benefit is obvious in this cookbook, which is written to be generic, but even in i.e. a wiremock cookbook, you'd gain extensibility without requiring maintenance of all the possible configuration values.

As with starting work on v0.1, we'll start v0.2 by defining the contract, in a new Test Kitchen test suite:

```yaml
suites:
- name: default
  # ...
- name: override-port
  attributes:
    jar:
      configuration:
        commandline_arguments:
          port: 9000
```

We'll then write our InSpec tests, which expect it to be up and running, but on a different port:

```ruby
describe command('java -version') do
  its('exit_status') { should eq 0 }
  its('stderr') { should match(/openjdk version "1\.8\..*"/) }
end

describe service('jar') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(9000) do
  it { should be_listening }
  its('processes') { should include 'java' }
end
```

As we need to update the arguments within our systemd service file, we'll need to update the tests around the `template` resource to note the new argument:

```diff
 context 'When all attributes are default, on Ubuntu 16.04' do
   # ...

  it 'creates a systemd service file' do
    expect(chef_run).to create_template('create a systemd service file')
      .with(source: 'unit.service.erb')
      .with(path: '/etc/systemd/system/jar.service')
      .with(owner: 'root')
      .with(group: 'root')
      .with(variables: {
+             commandline_arguments: {},
              path_to_jar: '/var/jar/jar.jar',
              user: 'jar'
            })

    expect(chef_run).to(render_file('/etc/systemd/system/jar.service')
      .with_content do |content|
        expect(content).to match %r{^User=jar$}
        expect(content).to match %r{^ExecStart=/usr/bin/java -jar /var/jar/jar\.jar$}
      end)
  end
 end
 context 'When all attributes are default, on CentOS 7.4.1708' do
   # ...

  it 'creates a systemd service file' do
    expect(chef_run).to create_template('create a systemd service file')
      .with(source: 'unit.service.erb')
      .with(path: '/etc/systemd/system/jar.service')
      .with(owner: 'root')
      .with(group: 'root')
      .with(variables: {
+             commandline_arguments: {},
              path_to_jar: '/var/jar/jar.jar',
              user: 'jar'
            })

    expect(chef_run).to(render_file('/etc/systemd/system/jar.service')
      .with_content do |content|
        expect(content).to match %r{^User=jar$}
        expect(content).to match %r{^ExecStart=/usr/bin/java -jar /var/jar/jar\.jar$}
      end)
  end
 end

 context 'When overriding user and group, when the platform is irrelevant' do
   # ...

  it 'creates a systemd service file' do
    expect(chef_run).to create_template('create a systemd service file')
      .with(variables: {
+             commandline_arguments: {},
              path_to_jar: '/var/jar/jar.jar',
              user: 'jar_user'
            })

    expect(chef_run).to(render_file('/etc/systemd/system/jar.service')
      .with_content do |content|
        expect(content).to match %r{^User=jar_user$}
      end)
  end
 end

 context 'When overriding jar.directory, when the platform is irrelevant' do
   # ...

  it 'creates a systemd service file' do
    expect(chef_run).to create_template('create a systemd service file')
      .with(variables: {
+             commandline_arguments: {},
              path_to_jar: '/var/jar-deploy/jar.jar',
              user: 'jar'
            })

    expect(chef_run).to(render_file('/etc/systemd/system/jar.service')
      .with_content do |content|
        expect(content).to match %r{^ExecStart=/usr/bin/java -jar /var/jar-deploy/jar\.jar$}
      end)
  end
 end
```

As well as adding the new test case:

```ruby
context 'When overriding jar.configuration.commandline_arguments, when the platform is irrelevant' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
      node.automatic['jar']['directory'] = '/var/jar-deploy'
      node.automatic['jar']['configuration']['commandline_arguments']['port'] = 1234
      node.automatic['jar']['configuration']['commandline_arguments']['version'] = nil
    end
    runner.converge(described_recipe)
  end

  before :each do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_raise('include_recipe not matched')
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
      .with('jar-deploy-cookbook::download_jar')
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
      .with('java::default')
  end

  it 'creates a systemd service file' do
    expect(chef_run).to create_template('create a systemd service file')
      .with(variables: {
              commandline_arguments: {
                'port' => 1234,
                'version' => nil
              },
              path_to_jar: '/var/jar-deploy/jar.jar',
              user: 'jar'
            })

    expect(chef_run).to(render_file('/etc/systemd/system/jar.service')
      .with_content do |content|
        expect(content).to match %r{^ExecStart=/usr/bin/java -jar /var/jar-deploy/jar\.jar --port=1234 --version$}
      end)
  end
end
```

As well as ensure that the `jar.configuration.commandline_arguments` is a Hash:

```ruby
node.default['jar']['configuration']['commandline_arguments'] = {}
```

If we run our tests, we'll see them going red:

```
....F.......F.....F.FF....

Failures:

  1) jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 creates a systemd service file
     Failure/Error:
       expect(chef_run).to create_template('create a systemd service file')
         .with(source: 'unit.service.erb')
         .with(path: '/etc/systemd/system/jar.service')
         .with(owner: 'root')
         .with(group: 'root')
         .with(variables: {
                 commandline_arguments: {},
                 path_to_jar: '/var/jar/jar.jar',
                 user: 'jar'
               })

       expected "template[create a systemd service file]" to have parameters:

         variables {:commandline_arguments=>{}, :path_to_jar=>"/var/jar/jar.jar", :user=>"jar"}, was {:path_to_jar=>"/var/jar/jar.jar", :user=>"jar"}
       Diff:
       @@ -1,4 +1,3 @@
       -:commandline_arguments => {},
        :path_to_jar => "/var/jar/jar.jar",
        :user => "jar",
     # ./spec/unit/recipes/default_spec.rb:53:in `block (3 levels) in <top (required)>'

  2) jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates a systemd service file
     Failure/Error:
       expect(chef_run).to create_template('create a systemd service file')
         .with(source: 'unit.service.erb')
         .with(path: '/etc/systemd/system/jar.service')
         .with(owner: 'root')
         .with(group: 'root')
         .with(variables: {
                 commandline_arguments: {},
                 path_to_jar: '/var/jar/jar.jar',
                 user: 'jar'
               })

       expected "template[create a systemd service file]" to have parameters:

         variables {:commandline_arguments=>{}, :path_to_jar=>"/var/jar/jar.jar", :user=>"jar"}, was {:path_to_jar=>"/var/jar/jar.jar", :user=>"jar"}
       Diff:
       @@ -1,4 +1,3 @@
       -:commandline_arguments => {},
        :path_to_jar => "/var/jar/jar.jar",
        :user => "jar",
     # ./spec/unit/recipes/default_spec.rb:130:in `block (3 levels) in <top (required)>'

  3) jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates a systemd service file
     Failure/Error:
       expect(chef_run).to create_template('create a systemd service file')
         .with(variables: {
                 commandline_arguments: {},
                 path_to_jar: '/var/jar/jar.jar',
                 user: 'jar_user'
               })

       expected "template[create a systemd service file]" to have parameters:

         variables {:commandline_arguments=>{}, :path_to_jar=>"/var/jar/jar.jar", :user=>"jar_user"}, was {:path_to_jar=>"/var/jar/jar.jar", :user=>"jar_user"}
       Diff:
       @@ -1,4 +1,3 @@
       -:commandline_arguments => {},
        :path_to_jar => "/var/jar/jar.jar",
        :user => "jar_user",
     # ./spec/unit/recipes/default_spec.rb:197:in `block (3 levels) in <top (required)>'

  4) jar-deploy-cookbook::default When overriding jar.directory, when the platform is irrelevant creates a systemd service file
     Failure/Error:
       expect(chef_run).to create_template('create a systemd service file')
         .with(variables: {
                 commandline_arguments: {},
                 path_to_jar: '/var/jar-deploy/jar.jar',
                 user: 'jar'
               })

       expected "template[create a systemd service file]" to have parameters:

         variables {:commandline_arguments=>{}, :path_to_jar=>"/var/jar-deploy/jar.jar", :user=>"jar"}, was {:path_to_jar=>"/var/jar-deploy/jar.jar", :user=>"jar"}
       Diff:
       @@ -1,4 +1,3 @@
       -:commandline_arguments => {},
        :path_to_jar => "/var/jar-deploy/jar.jar",
        :user => "jar",
     # ./spec/unit/recipes/default_spec.rb:235:in `block (3 levels) in <top (required)>'

  5) jar-deploy-cookbook::default When overriding jar.configuration.commandline_arguments, when the platform is irrelevant creates a systemd service file
     Failure/Error:
       expect(chef_run).to create_template('create a systemd service file')
         .with(variables: {
                 commandline_arguments: {
                   'port' => 1234,
                   'version' => nil
                 },
                 path_to_jar: '/var/jar-deploy/jar.jar',
                 user: 'jar'
               })

       expected "template[create a systemd service file]" to have parameters:

         variables {:commandline_arguments=>{"port"=>1234, "version"=>nil}, :path_to_jar=>"/var/jar-deploy/jar.jar", :user=>"jar"}, was {:path_to_jar=>"/var/jar-deploy/jar.jar", :user=>"jar"}
       Diff:
       @@ -1,4 +1,3 @@
       -:commandline_arguments => {"port"=>1234, "version"=>nil},
        :path_to_jar => "/var/jar-deploy/jar.jar",
        :user => "jar",
     # ./spec/unit/recipes/default_spec.rb:268:in `block (3 levels) in <top (required)>'

Finished in 16.2 seconds (files took 2.45 seconds to load)
26 examples, 5 failures

Failed examples:

rspec ./spec/unit/recipes/default_spec.rb:52 # jar-deploy-cookbook::default When all attributes are default, on Ubuntu 16.04 creates a systemd service file
rspec ./spec/unit/recipes/default_spec.rb:129 # jar-deploy-cookbook::default When all attributes are default, on CentOS 7.4.1708 creates a systemd service file
rspec ./spec/unit/recipes/default_spec.rb:196 # jar-deploy-cookbook::default When overriding user and group, when the platform is irrelevant creates a systemd service file
rspec ./spec/unit/recipes/default_spec.rb:234 # jar-deploy-cookbook::default When overriding jar.directory, when the platform is irrelevant creates a systemd service file
rspec ./spec/unit/recipes/default_spec.rb:267 # jar-deploy-cookbook::default When overriding jar.configuration.commandline_arguments, when the platform is irrelevant creates a systemd service file
```

Now we can update our recipe to pass in the `commandline_arguments` attribute to the `template`:

```diff
template 'create a systemd service file' do
   path '/etc/systemd/system/jar.service'
   owner 'root'
   group 'root'
-  variables path_to_jar: "#{node['jar']['directory']}/jar.jar",
+  variables commandline_arguments: node['jar']['configuration']['commandline_arguments'],
+            path_to_jar: "#{node['jar']['directory']}/jar.jar",
             user: node['jar']['user']
 end
```

We'll update our actual Erubis template to expand the arguments:

```diff
 [Unit]
 Description=Run Java JAR

+<%
+  arguments = @commandline_arguments.map do |k, v|
+    if v
+      "--#{k}=#{v}"
+    else
+      "--#{k}"
+    end
+  end
+%>
+
 [Service]
 User=<%= @user %>
 Type=simple
-ExecStart=/usr/bin/java -jar <%= @path_to_jar %>
+ExecStart=/usr/bin/java -jar <%= @path_to_jar %><%= ' ' + arguments.join(' ') unless arguments.length.zero? %>
```

Finally we need to verify in Test Kitchen:

<asciinema-player src="/casts/tdd-chef/arguments.json"></asciinema-player>

Now we're happy with it, we'll perform a minor bump on the cookbook version in our `metadata.rb`, resulting in `0.2.0`:

```diff
-version '0.1.0'
+version '0.2.0'
```

# Reflections

## Refactoring Choices

### Using `context` blocks more effectively

In a few places, we've got uses of Ubuntu / CentOS, but they're actually irrelevant to the tests, as there's nothing platform-specific. It'd be good to refactor this out, and make it more clear what is actually platform-specific.

### Making `context` block nest better

We could also update our context blocks:

```diff
-context 'When all attributes are default, on Ubuntu 16.04' do
+context 'On Ubuntu 16.04' do
+  context 'when all attributes are default' do
```

Which gives us the end result of i.e. `On Ubuntu 16.04 when all attributes are default installs Java using the java::default recipe`.

## Test Coverage

You'll notice that we've been making decisions about _where_ we test attributes and how they get passed into resources. There currently is no way to test your coverage of parameters to resources, which unfortunately means it's something you need to be conscious of while writing a cookbook.

I'm looking to write some tooling around it, but until then, it's something that needs to be remembered!

# Conclusion

We've discovered how best to test-drive a Chef cookbook, using ChefSpec as our main weapon of choice, but supported by Test Kitchen and InSpec to ensure that the converged cookbook works as expected. We've seen the power of unit testing in both speed and ease of use, and can see how we'd be able to apply the principles of TDD to developing Chef cookbooks.

[Semantic Versioning]: https://semver.org
[Java community cookbook]: https://supermarket.chef.io/cookbooks/java
[jar-deploy-cookbook]: https://gitlab.com/jamietanna/jar-deploy-cookbook
[remote_file]: https://docs.chef.io/resource_remote_file.html
[include_recipe]: {{< ref 2017-07-16-chef-testing-include_recipe >}}
[Ohai's]: https://github.com/chef/ohai
