---
title: Building Chef Cookbooks with GitLab (Part 1)
description: An introduction to how to build a cookbook using GitLab's Continuous Integration platform in conjunction with `kitchen-docker`.
tags:
- guide
- howto
- blogumentation
- gitlab
- chef
- test-kitchen
- docker
- gitlab-ci
image: /img/vendor/chef-logo.png
date: 2017-05-25T11:51:14+01:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: chef-gitlab-ci-kitchen-docker
series: chef-gitlab
---

# Foreword

**Want a TL;DR?** - Go to the [GitLab CI](#gitlab-ci) section, for the snippet you'll need to add to your `.gitlab-ci.yml` file to add integration test support.

The repository for this article can be found at [<i class="fa fa-gitlab"></i> jamietanna/user-cookbook][example-repo].

This tutorial expects you have the [Chef Development Kit (ChefDK)][chefdk] and [Docker Command Line tools][docker] installed, have an account on GitLab.com with a [repo created][gitlab-new-project].

Note: This tutorial is using `master` as the primary branch for development. This is not the method in which I normally work, which I will expand on in the next part of the series.

# Bootstrapping

We'll start by creating a new cookbook, by running `chef exec generate cookbook user-cookbook`. This is going to be a pretty boring cookbook which will create a user and optionally create a file in their home directory.

Let's start by [pushing the code up][cmt-1] to GitLab, i.e. `git remote add origin git@gitlab.com:jamietanna/user-cookbook.git && git push -u origin master`.

# Creating a Recipe

Now we have our empty cookbook available, let's start [adding some functionality][cmt-2]:

`recipes/default.rb`:

```rb
user 'create user jamie' do
  username 'jamie'
end
```

`spec/unit/recipes/default_spec.rb`:
```rb
require 'spec_helper'

describe 'user-cookbook::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the jamie user' do
      expect(chef_run).to create_user('create user jamie')
        .with(username: 'jamie')
    end
  end
end
```

Now let's push this to GitLab.

# Initial CI Setup

As we've not configured anything in GitLab CI to run, we won't actually have any automated means of determining whether the code we're pushing is correct or not.

In an ideal world, we'd want to at least have our pipeline set up to run our unit tests whenever we pushed a commit.

The easiest route we can go is to run on a Debian image, and install the ChefDK on top via the handy `.deb` package. At the time of writing, the latest version is 1.3.43, which is [done as follows][cmt-3]:

`.gitlab-ci.yml`:
```yaml
image: debian:jessie

test:
  script:
    - apt update && apt install -yq curl
    - curl https://packages.chef.io/files/stable/chefdk/1.3.43/debian/8/chefdk_1.3.43-1_amd64.deb -o /tmp/chefdk.deb
    - dpkg -i /tmp/chefdk.deb
    - chef exec rspec
```

Which now means that when we push to GitLab, our [CI][ci-3] process runs our unit tests against the code.

# Making Our Recipe More Useful

## Having a configurable user

Now, having a cookbook that only ever creates a single, hardcoded, user isn't actually very useful. So let's make it possible to configure it [via our cookbook's attributes][cmt-4] ([CI][ci-4]):

`attributes/default.rb`:
```rb
node.default['user'] = 'jamie'
```

`recipes/default.rb`:
```rb
user "create user #{node['user']}" do
  username node['user']
end
```

`spec/unit/recipes/default_spec.rb`:
```rb
require 'spec_helper'

describe 'user-cookbook::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    # ...

    it 'creates the jamie user' do
      expect(chef_run).to create_user('create user jamie')
        .with(username: 'jamie')
    end
  end

  context 'When the user attribute is set' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.automatic['user'] = 'test'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the test user' do
      expect(chef_run).to create_user('create user test')
        .with(username: 'test')
    end
  end
end
```

## Having a configurable group

So what if we want to [specify the `group` of the user][cmt-5] ([CI][ci-5])?

`recipes/default.rb`:
```rb
user "create user #{node['user']}" do
  username node['user']
  group node['group']
end
```

`spec/unit/recipes/default_spec.rb`:
```rb
require 'spec_helper'

describe 'user-cookbook::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    # ...

    it 'creates the jamie user' do
      expect(chef_run).to create_user('create user jamie')
        .with(username: 'jamie')
        .with(group: nil)
    end
  end

  context 'When the user attribute is set' do
    # ...

    it 'creates the test user' do
      expect(chef_run).to create_user('create user test')
        .with(username: 'test')
        .with(group: nil)
    end
  end

  context 'When the user and group attributes are set' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.automatic['user'] = 'test'
        node.automatic['group'] = 'users'
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the test user' do
      expect(chef_run).to create_user('create user test')
        .with(username: 'test')
        .with(group: 'users')
    end
  end
end
```

## Create a file for the user

Next, we will create a file, owned by the user, in their own home directory, [which is done as follows][cmt-6] ([CI][ci-6]):

`recipes/default.rb`:
```rb
file 'creates the hello.txt file' do
  path "~#{node['user']}/hello.txt"
  content "hello #{node['user']}"
  mode '0600'
  owner node['user']
  only_if { node['hello'] }
end
```

`spec/unit/recipes/default_spec.rb`:
```rb
require 'spec_helper'

describe 'user-cookbook::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    # ...

    it 'doesn\'t create the hello.txt file' do
      expect(chef_run).to_not create_file('creates the hello.txt file')
    end
  end

  context 'When the user attribute is set' do
    # ...

    it 'doesn\'t create the hello.txt file' do
      expect(chef_run).to_not create_file('creates the hello.txt file')
    end
  end

  context 'When the user and group attributes are set' do
    # ...

    it 'doesn\'t create the hello.txt file' do
      expect(chef_run).to_not create_file('creates the hello.txt file')
    end
  end

  context 'When the hello attribute is set' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.automatic['user'] = 'jamie'
        node.automatic['hello'] = true
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the hello.txt file' do
      expect(chef_run).to create_file('creates the hello.txt file')
        .with(path: '~jamie/hello.txt')
        .with(content: 'hello jamie')
        .with(mode: '0600')
        .with(owner: 'jamie')
    end
  end
end
```

# Integration Testing

As well as writing unit tests to ensure that at the component level we have a fully tested set of recipes, we also need to ensure that once the recipes are used in conjunction, everything still works. This is where we can bring in our integration tests.

Now, it's not often worth running integration tests against all combinations of machines you're going to run against, every time you commit. I prefer to run them when it gets to `develop`, or as it is on its way to `master`. However, we'll cover this workflow in the next part of the series, and for now, we'll run it on every commit.

## Local Testing

The most common method of integration testing cookbooks is by using [Vagrant][vagrant]. However, I've found that can be a little slow, as it has the overhead of requiring a full Virtual Machine. We can instead speed up our testing by using Docker (which conveniently means that we can use the same method of integration testing both locally and as part of our pipelines.

We can do this by using the [`kitchen-docker`][kitchen-docker] driver for [Test Kitchen][test-kitchen], which provides the same goodness that we can expect from Test Kitchen, but with the perk of it being run against a Docker image.

The first Docker-related changes we need to make in our `.kitchen.yml`:

```yaml
---
driver:
  name: docker
  # make kitchen detect the Docker CLI tool correctly, via
  # https://github.com/test-kitchen/kitchen-docker/issues/54#issuecomment-203248997
  use_sudo: false
  privileged: true
```

This ensures that we're using the `kitchen-docker` driver, and that we ensure that it can correctly hook into the `docker` CLI tools. Note that this process requires you to have set yourself up with the [`Manage Docker as a non-root user` steps][docker-post-install-linux].

Next, we need to tell `kitchen-docker` what platforms we want to be running against:

```yaml
platforms:
  - name: debian
    driver_config:
      image: debian:jessie
```

This will specify that we want to test against Debian Jessie. Adding another platform to test against is straightforward and won't be expanded on until the next post.

Next, we define our test suite to run against.

```yaml
suites:
  - name: default
    run_list:
      - recipe[user-cookbook::default]
    verifier:
      inspec_tests:
        - test/integration/default
    attributes:
      user: 'tester'
```

This lets us specify the recipes we want to run (our `run_list`) as well as any `attributes` we want to pass in to configure the node. For now, let's ignore the `verifier` section, which is [covered later](#so-it-converged-now-what).

These steps in full can be found in [this commit][cmt-7] ([CI][ci-7]).

To test this, we'll run `kitchen converge`. This will create our image if it's not already created, and then will run the cookbook on the new node.

Now that it works with basic settings, let's [add some more integration tests][cmt-8] ([CI][ci-8]) to cover some more combinations:

`.kitchen.yml`:
```yaml
suites:
  - name: default
    # ...
  - name: custom-group
    run_list:
      - recipe[user-cookbook::default]
    verifier:
      inspec_tests:
        - test/integration/custom-group
    attributes:
      group: 'test'
  - name: hello
    run_list:
      - recipe[user-cookbook::default]
    verifier:
      inspec_tests:
        - test/integration/hello
    attributes:
      hello: true
```

After running another `kitchen converge`, it turns out that _actually_ things aren't quite working!

## Fixing integration test issues

When we look at the errors returned by Chef, we can see a couple of glaring issues in the test suites.

### `custom_group` test suite

It looks like it's trying to add `jamie` to the `test` group, which is what we expected. But what we didn't know is that the group needs to be created _before_ we can add it to the group. This is the reason we do integration tests!

This is fixed [by adding][cmt-9] ([CI][ci-9]):

`recipes/default.rb`:
```rb
group 'create the group' do
  group_name node['group']
  not_if { node['group'].nil? }
end

# ...
```

`spec/unit/recipes/default_spec.rb`:
```rb
require 'spec_helper'

describe 'user-cookbook::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    # ...

    it 'doesn\'t create the users group' do
      expect(chef_run).to_not create_group('create the group')
    end

    # ...
  end

  context 'When the user attribute is set' do
    # ...

    it 'doesn\'t create the users group' do
      expect(chef_run).to_not create_group('create the group')
    end

    # ...
  end

  context 'When the user and group attributes are set' do
    # ...

    it 'creates the users group' do
      expect(chef_run).to create_group('create the group')
        .with(group_name: 'users')
    end

    # ...
  end

  context 'When the hello attribute is set' do
    # ...

    it 'doesn\'t create the users group' do
      expect(chef_run).to_not create_group('create the group')
    end

    # ...
  end
end
```

### `hello` test suite

This is a problem due to the expansion of the string `~jamie` not working, due to Chef not interpolating the `~` character as a special marker to denote a user's home directory.

The easiest (but not nicest) way of doing this, is to [update the home directory path][cmt-10] ([CI][ci-10]) to `/home/#{node['user']}`, which expands out to i.e. `/home/jamie`:

`recipes/default.rb`:
```rb
# ...

file 'creates the hello.txt file' do
  path "/home/#{node['user']}/hello.txt"
  content "hello #{node['user']}"
  mode '0600'
  owner node['user']
  only_if { node['hello'] }
end
```

`spec/unit/recipes/default_spec.rb`:
```rb
require 'spec_helper'

describe 'user-cookbook::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    # ...
  end

  context 'When the user attribute is set' do
    # ...
  end

  context 'When the user and group attributes are set' do
    # ...
  end

  context 'When the hello attribute is set' do
    # ...

    it 'creates the hello.txt file' do
      expect(chef_run).to create_file('creates the hello.txt file')
        .with(path: '/home/jamie/hello.txt')
        .with(content: 'hello jamie')
        .with(mode: '0600')
        .with(owner: 'jamie')
    end
  end
end
```

However, that still doesn't quite work. Chef by default doesn't actually 'manage' the home directory. This means that we don't actually have the directory created until we [explicitly set `manage_home true`][cmt-11] ([CI][ci-11]) when creating the user:

`recipes/default.rb`:
```rb
# ...

user "create user #{node['user']}" do
  username node['user']
  group node['group']
  manage_home true
end

# ...
```

`spec/unit/recipes/default_spec.rb`:
```rb
require 'spec_helper'

describe 'user-cookbook::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    # ...

    it 'creates the jamie user' do
      expect(chef_run).to create_user('create user jamie')
        .with(username: 'jamie')
        .with(group: nil)
        .with(manage_home: true)
    end

    # ...
  end

  context 'When the user attribute is set' do
    # ...

    it 'creates the test user' do
      expect(chef_run).to create_user('create user test')
        .with(username: 'test')
        .with(group: nil)
        .with(manage_home: true)
    end

    # ...
  end

  context 'When the user and group attributes are set' do
    # ...

    it 'creates the test user' do
      expect(chef_run).to create_user('create user test')
        .with(username: 'test')
        .with(group: 'users')
        .with(manage_home: true)
    end

    # ...
  end

  context 'When the hello attribute is set' do
    # ...

    it 'creates the hello.txt file' do
      expect(chef_run).to create_file('creates the hello.txt file')
        .with(path: '/home/jamie/hello.txt')
        .with(content: 'hello jamie')
        .with(mode: '0600')
        .with(owner: 'jamie')
    end
  end
end
```

## GitLab CI

Now we have it working locally, let's add our setup to [test this when we're pushing up to GitLab][cmt-12], too:

`.gitlab-ci.yml`:

```yaml
# ...
integration_test:
  image: docker:latest
  services:
  - docker:dind
  script:
    - 'echo gem: --no-document > $HOME/.gemrc'
    - apk update
    - apk add build-base git libffi-dev ruby-dev ruby-bundler
    - gem install kitchen-docker kitchen-inspec berkshelf
    - kitchen test
```

So there are a few things new here. Firstly, we're now using the `docker` image as our base. This is so we get access to the `docker` CLI tools, which are required by `kitchen-docker`. Next, we use the `dind`, or Docker in Docker, service which allows us to build and run another Docker image within our `docker` image.

We then need to install some dependencies such as the gems we need so we can actually run our tests, after which, we can run `kitchen test` to perform a full run of all our test suites.

And now, looking at our pipelines, we can see that [this commit][ci-12] has run the integration tests! **But**, the job is still failing...

# So it converged, now what?

You may notice that when running `kitchen test`, _[we actually fail][ci-12]_. This is due to [Inspec][inspec], a system verification tool, not finding the correct integration tests in the specified directories in our `.kitchen.yml`:

```yaml
---
driver:
  name: docker
  # make kitchen detect the Docker CLI tool correctly, via
  # https://github.com/test-kitchen/kitchen-docker/issues/54#issuecomment-203248997
  use_sudo: false
  privileged: true

provisioner:
  name: chef_zero
  # You may wish to disable always updating cookbooks in CI or other testing environments.
  # For example:
  #   always_update_cookbooks: <%= !ENV['CI'] %>
  always_update_cookbooks: true
  require_chef_omnibus: 12.19.36

verifier:
  name: inspec

platforms:
  - name: debian
    driver_config:
      image: debian:jessie

suites:
  - name: default
    # ...
    verifier:
      inspec_tests:
        - test/integration/default # <----
  - name: custom-group
    # ...
    verifier:
      inspec_tests:
        - test/integration/custom-group # <----
    # ...
  - name: hello
    run_list:
      - recipe[user-cookbook::default]
    verifier:
      inspec_tests:
        - test/integration/hello # <----
    attributes:
      # ...
```

Before we get to this, though, we notice as we're looking through the test suites that we've not actually got any cases where there is a different `user`, just `group`. Let's [tack it on with the `hello` case][cmt-13] ([CI][ci-13]), and run a quick `kitchen converge` to ensure that the cookbook still converges.

`.kitchen.yml`:
```yaml
---
# ...
suites:
  # ...
  - name: hello
    run_list:
      - recipe[user-cookbook::default]
    verifier:
      inspec_tests:
        - test/integration/hello
    attributes:
      user: 'everybody'
      hello: true
```

Now that's resolved, let's [write some quick integration tests][cmt-14] ([CI][ci-14]):

`test/integration/custom-group/default.rb`:
```rb
describe user('jamie') do
  it { should exist }
  its('groups') { should eq ['test'] }
end

describe group('test') do
  it { should exist }
end

describe directory('/home/jamie') do
  it { should exist }
end
```

`test/integration/default/default.rb`:
```rb
describe user('jamie') do
  it { should exist }
  its('groups') { should eq ['jamie'] }
end

describe group('jamie') do
  it { should exist }
end

describe directory('/home/jamie') do
  it { should exist }
end
```

`test/integration/hello/default.rb`:
```rb
describe user('everybody') do
  it { should exist }
  its('groups') { should eq ['everybody'] }
end

describe group('everybody') do
  it { should exist }
end

describe directory('/home/everybody') do
  it { should exist }
end

describe file('/home/everybody/hello.txt') do
  it { should exist }
  its('mode') { should cmp '0600' }
  its('owner') { should eq 'everybody' }
  its('content') { should eq 'hello everybody' }
end
```

# Conclusion

So we've seen how to build a basic cookbook from the ground up, taking care to unit test first, then work on integration tests after the functionality is complete.

Once our integration tests have worked locally, we've configured our GitLab CI pipelines to perform the same tests, so we know that when pushing code, we can ensure that it will have full integration coverage, too.

[gitlab-new-project]: https://gitlab.com/projects/new
[chefdk]: https://downloads.chef.io/chefdk
[vagrant]: https://vagrantup.com
[docker]: https://docker.com
[docker-post-install-linux]: https://docs.docker.com/engine/installation/linux/linux-postinstall/
[kitchen-docker]: https://github.com/test-kitchen/kitchen-docker
[test-kitchen]: http://kitchen.ci
[inspec]: https://inspec.io

[example-repo]: https://gitlab.com/jamietanna/user-cookbook
[cmt-1]: https://gitlab.com/jamietanna/user-cookbook/commit/a35132e30dfe51ffbc8374bac16dd5e0dba8e1b8
[ci-1]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-2]: https://gitlab.com/jamietanna/user-cookbook/commit/7566dbda74a4819b32b8a196651053fdea2d8b95
[ci-2]: https://gitlab.com/jamietanna/user-cookbook/pipelines/${PIPELINE}
[cmt-3]: https://gitlab.com/jamietanna/user-cookbook/commit/57ded223d14d9208196e04ad0d4ee6aeb90e7306
[ci-3]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517361
[cmt-4]: https://gitlab.com/jamietanna/user-cookbook/commit/26b32e270d97961fe08cf538837c949b6aa63741
[ci-4]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517364
[cmt-5]: https://gitlab.com/jamietanna/user-cookbook/commit/c7532efef2496b7b53b60c760c13df025781ac74
[ci-5]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517366
[cmt-6]: https://gitlab.com/jamietanna/user-cookbook/commit/669609062d55db87239c9588e849ddd327570885
[ci-6]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517369
[cmt-7]: https://gitlab.com/jamietanna/user-cookbook/commit/3806dd4c86a75be895393b60f91248f9d7af5be5
[ci-7]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517371
[cmt-8]: https://gitlab.com/jamietanna/user-cookbook/commit/80a2c5e5fcb3dfabb27b4cca77ef9ae20cbe4231
[ci-8]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517373
[cmt-9]: https://gitlab.com/jamietanna/user-cookbook/commit/2d221178b8c15f8f7cda6ac9bc2361d4641d14e3
[ci-9]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517374
[cmt-10]: https://gitlab.com/jamietanna/user-cookbook/commit/0c881e50bdc603532a21ce403703bdc74ee10ad1
[ci-10]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517376
[cmt-11]: https://gitlab.com/jamietanna/user-cookbook/commit/359954d76e1ecaadfbdf04cef6a77542e9f0371e
[ci-11]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517378
[cmt-12]: https://gitlab.com/jamietanna/user-cookbook/commit/f5d858c3bccd41f2bf3b98a37be09db17df52df0
[ci-12]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517379
[cmt-13]: https://gitlab.com/jamietanna/user-cookbook/commit/6c759fd225e2316548caa2152b9d76025d34bcec
[ci-13]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517381
[cmt-14]: https://gitlab.com/jamietanna/user-cookbook/commit/88f134a1b7e9e6bc39be7bd0c1cb9a8d8e5b6ddf
[ci-14]: https://gitlab.com/jamietanna/user-cookbook/pipelines/8517385
