---
layout: post
title: 'Running `service` resources in Kitchen-Docker'
description: How to get up and running with `service` resources when running Test Kitchen with the Docker driver, in this example for use with GitLab CI.
categories: findings chef kitchen docker
tags: findings chef kitchen docker howto
image: /assets/img/vendor/chef-logo.png
---

When writing cookbooks, you need to actually test that they work. This is often done using [Test Kitchen][test-kitchen], a tool that allows you to converge your cookbooks on a real machine. There are a number of drivers that can be used, such as [kitchen-vagrant][kitchen-vagrant] and [kitchen-docker][kitchen-docker].

For instance, I run against Docker due to its incredible speed compared to running on a virtual machine, and also due to the fact that this means I can use [Docker with GitLab CI][chef-docker-gitlab-ci-article].

## Getting kitchen-docker set up

For instance, let's assume we have a `.kitchen.yml` configured to use Vagrant as a driver:

```yaml
driver:
  name: docker

provisioner:
  name: chef_zero
  # You may wish to disable always updating cookbooks in CI or other testing environments.
  # For example:
  #   always_update_cookbooks: <%= !ENV['CI'] %>
  always_update_cookbooks: true

verifier:
  name: inspec

platforms:
  - name: debian
    driver_config:
      image: debian:jessie

suites:
  - name: default
    run_list:
      - recipe[cookbook::default]
    verifier:
      inspec_tests:
        - test/smoke/default
    attributes:
```

However, when running any of the kitchen commands, you _may_ encounter the following error:

```
$ kitchen list
>>>>>> ------Exception-------
>>>>>> Class: Kitchen::UserError
>>>>>> Message: You must first install the Docker CLI tool http://www.docker.io/gettingstarted/
>>>>>> ----------------------
>>>>>> Please see .kitchen/logs/kitchen.log for more details
>>>>>> Also try running `kitchen diagnose --all` for configuration
```

This is due to the Docker driver not being able to correctly find the CLI tool. An easy fix is to add the following to our `driver` section in the `.kitchen.yml`:

```diff
 driver:
   name: docker
+  # make kitchen detect the Docker CLI tool correctly, via
+  # https://github.com/test-kitchen/kitchen-docker/issues/54#issuecomment-203248997
+  use_sudo: false
```

## Running service commands

Next, we want to be able to interact with services via Chef's [`service` resources][chef-service-resource]. Trying to interface with a service in a Docker container results in the following error:

```
$ sudo systemctl restart mysql
Failed to get D-Bus connection: Operation not permitted
```

This is due to the whole point of docker containers running a single application. When trying to interface with a `service`, this requires a full [init system][init], with multiple processes running on top of it. This means that you're using Docker for something it's not built for (out of the box).

Therefore, you need to extend the Docker container to have its own init system, as well as giving it root access across the host system: that is, this new container that is meant to be separate, and have its own nicely sandboxed resources will have [**root access to your machine**][cap-sys-admin-lwn]. Be aware of the security risks this can cause on your machine - I have no responsibility for issues caused.

Following the advice in [Stack Overflow: Kitchen-Docker and Systemd][so-kitchen-docker-systemd]:

```diff
 driver:
   name: docker
   # make kitchen detect the Docker CLI tool correctly, via
   # https://github.com/test-kitchen/kitchen-docker/issues/54#issuecomment-203248997
   use_sudo: false
+  run_command: /bin/systemd
+  cap_add:
+    - SYS_ADMIN
+  volume:
+    - /sys/fs/cgroup

```

`run_command` defines what command should be run by the container, which in this case would be systemd, the init system used by Debian Jessie.

As mentioned, we also need to give it the `SYS_ADMIN` capability, which gives it root access across the machine.

Finally, we also need to give it access to the [cgroups][cgroups] config, which is an [expectation of systemd][systemd-mounted-cgroups].


[test-kitchen]: http://kitchen.ci
[so-kitchen-docker-systemd]: https://stackoverflow.com/questions/42852457/kitchen-docker-and-systemd
[kitchen-vagrant]: https://github.com/test-kitchen/kitchen-vagrant
[kitchen-docker]: https://github.com/test-kitchen/kitchen-docker
[chef-service-resource]: https://docs.chef.io/resource_service.html
[chef-docker-gitlab-ci-article]: {% post_url 2017-05-25-chef-gitlab-ci-kitchen-docker %}
[init]: https://en.wikipedia.org/wiki/Init
[cap-sys-admin-lwn]: https://lwn.net/Articles/486306/
[cgroups]: https://en.wikipedia.org/wiki/Cgroups
[systemd-mounted-cgroups]: https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/
