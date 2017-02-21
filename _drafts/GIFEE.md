---
layout: post
categories: fosdem
title: GIFEE - Google Infrastructure for Everyone
description:
categories:
tags: containers docker kubernetes
---
> This article is developed from a talk by [Brandon Philips at FOSDEM 2017][GIFEE-fosdem].




## Why Containers?

Kubernetes, on the other hand, is all about having your distribution running as lightweight as possible. This is in part due to the fact that getting everything to the right version can be difficult. By containerising your application, you can avoid the need for special steps for deployment and configuration management, as it's then all done within a single container. This avoids the issues of trying to get certain versions of libraries playing nicely, on the distribution you're deploying to - for instance, if you use RHEL7.1, and want to be running a very new version of __??__, then you would have to install it via a third-party or from source. This is not ideal, and therefore means that __??__.

On the other hand, the container will contain the pre-packaged environment that is required to run your application, and allows for running multiple __??__. Note that this does, of course, have some drawbacks which I have detailed previously in [Resurrecting Dinosaurs][resurrecting-dinosaurs].

This container can be run on a hardened host, such as a RHEL7.1 image, but the base image could be something like [Alpine Linux][alpine].



Another perk of using containers is knowing that the same image (minus issues like proxies) will work exactly the same way whether it's running in development, continuous integration, on the end environment, and anywhere in between. This increases the confidence the developers can have within their application, and not have to worry even about any differences between their staging and production environments.

## So What's Kubernetes?


```markdown
- get everything bundled perfectly, will work everywhere

- clustering = botnet
- if a server goes down, you have to remember what's on it, what needs to be on it, if you have or haven't copied latest stuff
- set of control servers that manage things for you - they know when to replicate ie if something dies

- API for control clusters
- has an API server cluster that is the frontend used by CLI
- shouldn't have to care when each server goes down (and nor should the users notice!)
- CoreOS manages who becomes leader (RAFT protocol/algo)
- play.etcd.io - show how things break

- can run infrastructure consistently across different providers - cloud or bare metal!
- avoid fragmentation of cloud platforms - run on k8s instead of AWS
- handles things like LB for you

- federation - k8s but instead of machines, it's clusters
- k8s to manage DCs that manage machines
- would mean we can hit multi-cloud so much easier
- but still not there yet (40% current api works so far)

- "who deployed _these_ containers?"
- label them with what they are ie backend, prod, by Manthan

- db deployment is easy - but how do you scale it? Distribute it?
- operators - human knowledge -> software
- operator will manage a lot of things like health of a cluster

- prometheus - can monitor stats
- get nice graphs
- can see LB -> instance
- can go through containers to actual hardware (ie what kernel version is c1ps' first cluster instance's host image running?)
- can do searches to get more details

- next steps - Openid Connect, prepackaged, RBAC

- CoreOS all about securing the internet
- our responsibility to ensure people's data is safe
- "self driving infrastructure"
- don't need to be an expert in patching every component
- ie app, OS, db

- dancing on the edge of secure and insecure
- need to be able to patch and update systems so quickly
```

[GIFEE-fosdem]: https://fosdem.org/2017/schedule/event/kubernetes/
[alpine]: https://alpinelinux.org/
[resurrecting-dinosaurs]: {% post_url 2017-02-15-resurrecting-dinosaurs %}
