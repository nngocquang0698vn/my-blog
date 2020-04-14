---
title: "GitLab Runner Runner Docker TCP Error"
description: "Fixing the `cannot connect to the Docker daemon` error with GitLab Runner and Docker."
tags:
- blogumentation
- gitlab
- docker
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-04-14T21:29:14+0100
slug: "gitlab-docker-runner-tcp-error"
image: /img/vendor/gitlab-wordmark.png
---
About a month or so ago, I tried to install the [GitLab Runner](https://docs.gitlab.com/runner/) for some personal project usage, and kept getting hit with similar errors to below:

```
cannot connect to the Docker daemon. Is 'docker daemon' running on this host?: dial tcp ...:2375: connect: connection refused
cannot connect to the docker daemon at tcp://docker:2375. is the docker daemon running?
error during connect: Post ... dial tcp: lookup docker on ...:53: no such host
```

I ended up leaving the issue for another day, and today managed to work out the issue.

The issue I was encountering is that the GitLab runner expected there to be a TCP socket available for the Docker process, whereas it appears that my installation (maybe due to how Docker is packaged for Debian?) by default only provided the file-based socket.

For additional context, I am running this on Debian Stretch (Debian 9), with GitLab Runner v12.9.0, and Docker v17.12.0-ce.

# Providing Privileges to Interact with Docker

If it doesn't already have access, the user that `gitlab-runner` is executing as needs to be in the Docker group. For instance, assuming that the user `gitlab` is used to execute the runner:

```sh
$ sudo gpasswd -a gitlab docker
```

You may need to restart the `gitlab-runner` service first.

# Creating the TCP Socket

Following [these steps on StackOverflow](https://stackoverflow.com/a/50566391), I was able to create a TCP socket using systemd:

```ini
[Unit]
Description=Docker Socket for the API
PartOf=docker.service

[Socket]
ListenStream=2375

BindIPv6Only=both
Service=docker.service

[Install]
WantedBy=sockets.target
```

This then exposes the TCP socket that to connect to Docker, and builds start working as soon as the new socket is available!
