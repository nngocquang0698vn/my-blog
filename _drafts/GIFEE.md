---
layout: post
categories: fosdem
tags:
title: GIFEE
description:
---
- run your distros as lightweight
- because it's difficult to make sure all right versions
- don't need special deployment + config management - all done in-container
- get everything bundled perfectly, will work everywhere
- devs know will work on ci, server, etc

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
