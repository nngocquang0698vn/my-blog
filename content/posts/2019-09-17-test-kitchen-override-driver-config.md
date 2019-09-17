---
title: "Overriding Test Kitchen Driver Configuration"
description: "How to override specific configuration in Test Kitchen's project-specific `.kitchen.yml`."
tags:
- test-kitchen
- blogumentation
license_code: GPL-3.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-17T13:32:26+01:00
slug: "test-kitchen-override-driver-config"
image: /img/vendor/test-kitchen-logo.png
---
When working with [Test Kitchen](https://kitchen.ci), you have a couple of locations that you can set configuration.

The first is in your "global" configuration, stored in `$HOME/.kitchen/config.yml`, which is the base configuration that is used for any Test Kitchen interactions for that user. In a CI/CD setup, you may not have any control over this file.

The second option is actually available in your `.kitchen.yml` in your project.

Within the `.kitchen.yml`, you again have two options, globally and per-suite.

For instance, if we take the following example configuration:

```yaml
---
driver:
  name: docker
  use_sudo: false
  provision_command:
    - /usr/bin/apt-get update -y
    - /usr/bin/apt-get install -y net-tools build-essential
  run_command: /bin/systemd
  cap_add:
    - SYS_ADMIN
  volume:
    - /sys/fs/cgroup

verifier:
  name: inspec

platforms:
  - name: debian
    driver_config:
      image: debian:jessie

suites:
  - name: default
    run_list:
      - recipe[cookbook-spectat::default]
    attributes:
      spectat:
        authorized_keys: ['fake-ssh-public-key']
  - name: another
  # ...
```

If, for some reason, we needed to override the `use_sudo` property for specifically the `default` suite, we could make the following change:

```diff
 suites:
   - name: default
+    driver:
+      use_sudo: true
     run_list:
       - recipe[cookbook-spectat::default]
     attributes:
       spectat:
         authorized_keys: ['fake-ssh-public-key']
```

In another example, we could be provisioning some software that has certain hardware requirements on AWS, at which point we could specific the AWS instance type in the configuration:

```yaml
suites:
  - name: default
    driver:
      instance_type: m4.large
    run_list:
      - recipe[cookbook-spectat::default]
    attributes:
      spectat:
        authorized_keys: ['fake-ssh-public-key']
```
