---
layout: post
title: Taking Containers from Development to Production
description: <
---
## docker
need to cut cost, move from VMs to containers
did a search - found docker

running a python + db project:
`docker run -p 5432:5432 postgres`

then running script (in the host)

to actually dev on it, then have to create container - i.e.`docker build && docker run`, as well as having `postgres` working!
becomes a compiled language of sorts - lose the perks of having python (interpreted)

## docker compose!
then it's the case of `docker-compose up`

##

need to orchestrate things better though

### docker-swarm

can use `docker-compose`, but _not as is_

### kubernetes

experience of 10 years of Google scale
huge community - largest project?


##

but lots of new concepts
want to use Kube - but don't want to redo `docker-compose`

## Kompose

minikube helps with getting things up and running

smaller application is easy - works well (for a time)


**but**:
- can't do single jobs
- can't do things like config and secrets

`docker-compose` is built for developers with single-node setups, `Kompose` is not

`restart: no` isn't deploy object, isn't quite the right mapping
