---
title: "Inheriting the Proxy from the Jenkins Host in Docker"
description: "How to pass proxy variables from your Jenkins host to your Docker containers."
tags:
- blogumentation
- docker
- jenkins
- proxy
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-04-14T13:09:21+0100
slug: "docker-proxy-host-jenkins"
image: https://media.jvt.me/b0bf1d8c2f.png
---
If you're working in a corporate environment, it's likely you're working with a proxy to restrict outbound traffic.

This can complicate things a little if you're using containerised builds in Jenkins, as they won't, by default, know how to reach outbound via the proxy, unless you add some extra configuration to your images.

You _could_ hardcode them, but then you would need to go round updating all these variables in the future, when settings change, so it's worth always pulling what the host provides.

Fortunately, we can follow the instructions in [_Inheriting the Environment Variables from the Jenkins Host in Docker_]({{< ref 2020-04-14-inherit-environment-docker-host-jenkins >}}), providing the argument:

```
-e http_proxy=$http_proxy -e https_proxy=$https_proxy -e no_proxy=$no_proxy
```
