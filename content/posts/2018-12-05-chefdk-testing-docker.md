---
title: How to run tests from the ChefDK in Docker
description: How to get up and running with the ChefDK to perform common tests, such as unit tests and linting.
categories:
- blogumentation
- chef
tags:
- blogumentation
- chef
- chefdk
- docker
image: /img/vendor/chef-logo.png
date: 2018-12-05
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
---
It can be really helpful to run your local ChefDK setup using Docker, rather than installing it on your workstation, to ensure that everything works with a clean ChefDK.

I'll be taking you through this process, while avoiding editing the existing upstream image, instead overriding specific functionality using command-line flags on the host.

## Getting it running

Let us assume that we're using ChefDK version v3.5.13, but this should be valid for any other ChefDK version. We can start this off by checking the versions of the core ChefDK tools by running:

```
$ docker run --rm -ti chef/chefdk:3.5.13 chef --version
Chef Development Kit Version: 3.5.13
chef-client version: 14.7.17
delivery version: master (6862f27aba89109a9630f0b6c6798efec56b4efe)
berks version: 7.0.6
kitchen version: 1.23.2
inspec version: 3.0.52
```

## Running our unit tests + linting

We'll use the [Java cookbook](https://github.com/sous-chefs/java) in this example, as it's got all aspects of cookbook workflow to try out.

Assuming we have the following directory structure:

```
$ pwd
~/cookbooks
$ ls ~/cookbooks
java
```

We make sure that we mount our cookbook into a known path, such as `/cookbook`, which helps with mapping a consistent structure:

```
$ docker run --rm -v $PWD/java:/cookbook -ti chef/chefdk:3.5.13 ls /cookbook
attributes    CODE_OF_CONDUCT.md  LICENSE      resources  TESTING.md
Berksfile     CONTRIBUTING.md     metadata.rb  spec
CHANGELOG.md  Dangerfile          README.md    templates
chefignore    libraries           recipes      test
```

As we're mounting the cookbook into a new folder, we want to set Docker's `WORKDIR` to automagically `cd` into that directory, instead of us running that each time:

```
$ docker run --rm -w=/cookbook -v $PWD/java:/cookbook -ti chef/chefdk:3.5.13 ls
attributes    CODE_OF_CONDUCT.md  LICENSE      resources  TESTING.md
Berksfile     CONTRIBUTING.md     metadata.rb  spec
CHANGELOG.md  Dangerfile          README.md    templates
chefignore    libraries           recipes      test
```

### Cookstyle

Now we have our setup ready, we want to run our code style checks through `cookstyle`:

```
$ docker run --rm -w=/cookbook -v $PWD/java:/cookbook -ti chef/chefdk:3.5.13 cookstyle
Inspecting 68 files
....................................................................

68 files inspected, no offenses detected
```

### FoodCritic

For our Chef-specific linting, we run `foodcritic`:

```
$ docker run --rm -w=/cookbook -v $PWD/java:/cookbook -ti chef/chefdk:3.5.13 foodcritic .
Checking 11 files
...........
```

### ChefSpec

If we want to check that our unit tests pass successfully, we'd run `rspec`:

```
$ docker run --rm -w=/cookbook -v $PWD/java:/cookbook -ti chef/chefdk:3.5.13 rspec
..........................................WARNING: you must specify a 'platform' and optionally a 'version' for your ChefSpec Runner and/or Fauxhai constructor, in the future omitting the platform will become a hard error. A list of available platforms is available at https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
.WARNING: you must specify a 'platform' and optionally a 'version' for your ChefSpec Runner and/or Fauxhai constructor, in the future omitting the platform will become a hard error. A list of available platforms is available at https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
.WARNING: you must specify a 'platform' and optionally a 'version' for your ChefSpec Runner and/or Fauxhai constructor, in the future omitting the platform will become a hard error. A list of available platforms is available at https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
.WARNING: you must specify a 'platform' and optionally a 'version' for your ChefSpec Runner and/or Fauxhai constructor, in the future omitting the platform will become a hard error. A list of available platforms is available at https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
.WARNING: you must specify a 'platform' and optionally a 'version' for your ChefSpec Runner and/or Fauxhai constructor, in the future omitting the platform will become a hard error. A list of available platforms is available at https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
.WARNING: you must specify a 'platform' and optionally a 'version' for your ChefSpec Runner and/or Fauxhai constructor, in the future omitting the platform will become a hard error. A list of available platforms is available at https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
.WARNING: you must specify a 'platform' and optionally a 'version' for your ChefSpec Runner and/or Fauxhai constructor, in the future omitting the platform will become a hard error. A list of available platforms is available at https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
.WARNING: you must specify a 'platform' and optionally a 'version' for your ChefSpec Runner and/or Fauxhai constructor, in the future omitting the platform will become a hard error. A list of available platforms is available at https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
.WARNING: you must specify a 'platform' and optionally a 'version' for your ChefSpec Runner and/or Fauxhai constructor, in the future omitting the platform will become a hard error. A list of available platforms is available at https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
.WARNING: you must specify a 'platform' and optionally a 'version' for your ChefSpec Runner and/or Fauxhai constructor, in the future omitting the platform will become a hard error. A list of available platforms is available at https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
.....

Finished in 0.69453 seconds (files took 2.4 seconds to load)
56 examples, 0 failures
```

## Test Kitchen

Depending on which driver you're using, this step may or not be possible - for instance, getting a Vagrant instance running from a Docker image _may not_ be possible.


### Kitchen-EC2

Depending on how you have the [EC2 driver for Test-Kitchen, kitchen-ec2][kitchen-ec2] configured, you _may_ have a configuration file in your home directory (`~/.kitchen/config.yml`) which has configuration such as default tags for an instance. This will need to be mounted into the image:

```
$ docker run --rm -w=/cookbook -v ~/.kitchen/config.yml:/root/.kitchen/config.yml -v $PWD/java:/cookbook -ti chef/chefdk:3.5.13 kitchen test
```

Note that this all should work as long as the docker image can access the EC2 metadata endpoint (see [Not using the proxy for the EC2 Metadata Endpoint](#not-using-the-proxy-for-the-ec2-metadata-endpoint) below), you're good to go!

## Hey, what about internal setups?

You may be running in an environment where your services are not publicly accessible, or are having to route through a proxy. The following changes may be required:

### Trusting Internal Certificates

Following the steps in [_Trusting Self-Signed Certificates from the Chef Development Kit_]({{< ref 2017-08-17-self-signed-certs-chefdk >}}), we would want to modify Chef's certificates to trust the internal certificate. However, if we want to use our upstream images as-is, we can instead mount a custom CA certs bundle into the image, otherwise we would receive an error similar to:

```
$ docker run --rm -w=/cookbook -v $PWD/java:/cookbook -ti chef/chefdk:3.5.13 berks
[2018-12-05T19:00:28+00:00] ERROR: SSL Validation failure connecting to host: supermarket.example.com - SSL_connect returned=1 errno=0 state=error: certificate verify failed
#<Thread:0x00000000023ae308@/opt/chefdk/embedded/lib/ruby/gems/2.5.0/gems/berkshelf-7.0.6/lib/berkshelf/installer.rb:21 run> terminated with exception (report_on_exception is true):
Traceback (most recent call last):
        8: from /opt/chefdk/embedded/lib/ruby/gems/2.5.0/gems/berkshelf-7.0.6/lib/berkshelf/installer.rb:24:in `block (2 levels) in build_universe'
        7: from /opt/chefdk/embedded/lib/ruby/gems/2.5.0/gems/berkshelf-7.0.6/lib/berkshelf/source.rb:85:in `build_universe'
        6: from /opt/chefdk/embedded/lib/ruby/gems/2.5.0/gems/berkshelf-7.0.6/lib/berkshelf/api_client/connection.rb:47:in `universe'
        5: from /opt/chefdk/embedded/lib/ruby/gems/2.5.0/gems/berkshelf-7.0.6/lib/berkshelf/ridley_compat.rb:37:in `get'
        4: from /opt/chefdk/embedded/lib/ruby/gems/2.5.0/gems/chef-14.7.17/lib/chef/http.rb:115:in `get'
        3: from /opt/chefdk/embedded/lib/ruby/gems/2.5.0/gems/chef-14.7.17/lib/chef/http.rb:149:in `request'
        2: from /opt/chefdk/embedded/lib/ruby/gems/2.5.0/gems/chef-14.7.17/lib/chef/http.rb:365:in `send_http_request'
        1: from /opt/chefdk/embedded/lib/ruby/gems/2.5.0/gems/chef-14.7.17/lib/chef/http.rb:408:in `retrying_http_errors'
/opt/chefdk/embedded/lib/ruby/gems/2.5.0/gems/chef-14.7.17/lib/chef/http.rb:451:in `rescue in retrying_http_errors': SSL Error connecting to https://supermarket.example.com/universe - SSL_connect returned=1 errno=0 state=error: certificate verify failed (OpenSSL::SSL::SSLError)
OpenSSL::SSL::SSLError SSL Error connecting to https://supermarket.example.com/universe - SSL_connect returned=1 errno=0 state=error: certificate verify failed
```

This can be avoided with the following mount:

```
$ ls
custom_cacert.pem
java
# with our custom CA certs bundle
$ docker run --rm -w=/cookbook -v $PWD/custom_cacert.pem:/opt/chefdk/embedded/ssl/certs/cacert.pem -v $PWD/java:/cookbook -ti chef/chefdk:3.5.13 berks
Fetching cookbook index from https://supermarket.example.com...
Installing homebrew (5.0.8)
Using java (3.1.2) from source at .
Installing windows (5.2.2)
Using test (0.1.0) from source at test/fixtures/cookbooks/test
```

### Not using proxy for internal hosts

If we've got an internal Supermarket and are operating behind a proxy, we'd want to follow the steps within [_`SSLError` When Running Berkshelf Behind a Proxy_]({{< ref 2018-02-16-berkshelf-proxy-workaround >}}) and add our Supermarket's FQDN to our `no_proxy`. I.e. when we're running our ChefSpec tests:

```
$ docker run --rm -e no_proxy=supermarket.example.com -w=/cookbook -v $PWD/java:/cookbook -ti chef/chefdk:3.5.13 rspec
```

### Not using the proxy for the EC2 Metadata Endpoint

If you're using i.e. kitchen-ec2 as a Test Kitchen driver, you'll also need to add the EC2 metadata endpoint to your `no_proxy` list:

```
$ docker run --rm -e no_proxy=169.254.169.254 -w=/cookbook -v $PWD/java:/cookbook -ti chef/chefdk:3.5.13 kitchen test
```

Without this, you'll receive errors around not being able to access credentials.
