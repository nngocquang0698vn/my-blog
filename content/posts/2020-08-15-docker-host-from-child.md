---
title: "Connecting to the Docker Host from a Child Container"
description: "How to access ports from the host machine when running in a child container."
tags:
- blogumentation
- docker
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-08-15T15:19:34+0100
slug: "docker-host-from-child"
image: https://media.jvt.me/2b06cbc075.png
---
Yesterday I was working with a Docker configuration that was set up to use the TCP daemon rather than the Unix daemon. This led to a pretty frustrating day of fighting to get Docker-in-Docker working, as I needed to have the child containers accessing the parent socket, but as I had no control over the configuration, I needed to continue using the TCP socket.

While looking at it, I found several options for how to access the host from a child container, and I wanted to [document them for future reference](/posts/2017/06/25/blogumentation/).

In the below examples, I'll try and reach a Hugo server that I'm running (bound to all interfaces) by running:

```sh
hugo --bind 0.0.0.0
```

# Sharing the network

The simplest way to do this is to simply share the network between the host and the container, using `--net host` when running the container, which shares everything network-related between the host and child:

```sh
$ docker run --net host -ti alpine netstat -an
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
...
tcp        0      0 127.0.0.1:1313          0.0.0.0:*               LISTEN
...
```

However, the issue with this is because all networking is shared, you also run into port clashes. So if you wanted to run multiple containers that bind to port 8080, that won't work! This largely reduces the benefits of running Docker in a way that provides isolation, so I'd recommend not using this if possible.

# Using `-add-host`

Using `--add-host` updates the `/etc/hosts` file on the child to make it easier to refer to the host, but you still need some way to determine the host's IP address:

```sh
$ docker run --add-host the-host:172.17.0.1 -ti alpine cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.17.0.1      the-host
172.17.0.2      1e8c35ea6cf4
```

To work out the IP address for the host, we we can use the steps in the below section to determine the IP address.

# Connecting to the host via its gateway IP

When you're inside the child container, you can reach the host via the gateway IP:

It's by default on `172.17.0.1` for Docker, but if you want to script it in case you're not, you can follow [this advice on StackOverflow](https://serverfault.com/a/31179) from the child:

```sh
$ route -n | grep 'UG[ \t]' | awk '{print $2}'
```

Alternatively, if you want to do this from the host [via StackOverflow](https://stackoverflow.com/a/44956596/2257038):

```sh
docker network inspect --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}' bridge
```

# Using `host.docker.internal`

Depending on the version of Docker you're running, you may be able to refer to the host as `host.docker.internal`.
