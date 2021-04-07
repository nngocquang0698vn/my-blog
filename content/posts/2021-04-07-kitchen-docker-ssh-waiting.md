---
title: "`Waiting for SSH service` on Test Kitchen with the Docker driver"
description: "How to resolve `Waiting for SSH service` when running kitchen-docker."
date: 2021-04-07T17:09:37+0100
tags:
- "blogumentation"
- "chef"
- "test-kitchen"
- "docker"
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
slug: "kitchen-docker-ssh-waiting"
image: /img/vendor/chef-logo.png
---
Although the Docker driver is no longer included by default in the Chef Workstation, with [kitchen-dokken](https://github.com/test-kitchen/kitchen-dokken) being recommended now, you may still want to use it.

I was trying to run one of my older cookbooks, which uses it for integration tests, and found that my container was just timing out trying to connect:

```
Waiting for SSH service on localhost:49156, retrying in 3 seconds
Waiting for SSH service on localhost:49156, retrying in 3 seconds
Waiting for SSH service on localhost:49156, retrying in 3 seconds
```

This is odd, because I could see the container running, but nothing was happening with it, so there shouldn't have been a timeout.

When running Kitchen with debug logs, I could see `Connection reset by peer`, which was increasingly odd:

```
D, [2021-04-07T13:46:32.165084 #122004] DEBUG -- default-debian: [SSH] connection failed (#<Errno::ECONNRESET: Connection reset by peer>)
I, [2021-04-07T13:46:32.165222 #122004]  INFO -- default-debian: Waiting for SSH service on localhost:49156, retrying in 3 seconds
```

It turns out that I was missing the `transport` configuration in my `kitchen.yml`:

```
transport:
  name: docker
```

Once I'd added this, the connection worked straight away, and my tests ran successfully.
