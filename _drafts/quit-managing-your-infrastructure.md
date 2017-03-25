---
layout: post
categories: fosdem
tags:
title: Managing Infrastructure with OpsTheatre
description:
---
Managing infrastructure with OpsTheatre
Full self hosted solutions

Mattermost integrated with GitLab ce
Communication is so important - doesn't happen nearly enough

Infrastructure not important
Auto message via mattermost

Not about making the tools themselves - integrate, out-of-the-box

Want combination of publicly acknowledged best practices w open source software glued together using puppet

Quite a bit of overhead - is it worth it?
Not great for non-puppet shops - new stuff to learn and integrate
Works on AWS, but not the "amazon way"
" retrofitting is a bitch"

Not going to be proprietary
Cool stuff!

Uses Vagrant Oscar to provide the actual Vagrant definition, but nicer
Adds updates to hosts file - if all within a group, does fake DNS resolution

