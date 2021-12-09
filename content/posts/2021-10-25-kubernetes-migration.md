---
title: "Things I Learned Migrating My Personal APIs To Kubernetes"
description: "What I learned while migrating from a number of Java applications on Virtual Private Servers (VPS) to a Kubernetes cluster."
tags:
- kubernetes
- personal-infrastructure
- sysadmin
- java
- spring-boot
date: 2021-10-25T14:47:26+0100
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: kubernetes-migration
image: https://media.jvt.me/735ffcb6bd.png
syndication:
- https://news.ycombinator.com/item?id=29185457
---
I run a number of personal API services, such as a service for [tracking my step counts](/posts/2019/10/27/owning-step-count/), a [Micropub server](/posts/2019/08/26/setting-up-micropub/), and an [IndieAuth Server](/posts/2020/12/09/personal-indieauth-server/) which are all pretty key for my online identity.

As a Software Engineer primarily working with Java, it was a good fit to invest in some personal Java Spring Boot services.

Until recently, these were on a single VPS on [Heztner](https://hetzner.cloud). However, as is common with Java, I ended up starting to hit memory limits, and needed to up the memory on the server.

As there were 5 services running from `www-api.jvt.me`, 1 from `www-editor.jvt.me` and 1 from `indieauth.jvt.me`, I couldn't easily split the services equally between two VPS instances. I'd tried to split the two separate services out, but it didn't relieve too much pressure on the memory, so I had to decide whether I needed to set up proper load balancing, keep scaling up the memory, or do something else.

I'd been interested in learning a bit more about Kubernetes generally, and with an opportunity to start using Kubernetes at work (at the time), as well as [starting to look around at other jobs](/posts/2021/08/19/joining-cabinet-office/), I thought it'd be good to have a bit more understanding of how it all works.

Naturally, I thought I'd blog about the things I'd learned, and hopefully get some feedback on things I can do better.

If you're interested, you can [see this Merge Request for the changes initially required](https://gitlab.com/jamietanna/www-api/-/merge_requests/268) as part of the migration to Kubernetes. Further changes have been made, but this was what got me started.

You'll notice as you read below, that my VPS setup wasn't ideal:

- I had 2 VPS set up for hosting Java apps, with an uneven split between which services run on which
- Configuration files needed to be edited by hand when new config / secrets were needed
- No downtimeless deploys
- No memory configuration, so services would use as much memory as available, fighting each other
- Had to manually manage which ports each service was being hosted on, so Caddy could be used as a reverse proxy
- Had to SSH on to check logs

It's a much nicer experience to be on Kubernetes now, after 8-9 weeks of ongoing work. This post is a few months late compared to the release of the migration, but the information is still relevant.

# Spring Boot's Containerised Build Tooling

I was very impressed with the way that Spring Boot's ability to build Open Container Initiative (OCI) images (i.e. [with Gradle](https://docs.spring.io/spring-boot/docs/2.5.x/gradle-plugin/reference/htmlsingle/#build-image)), as I meant I didn't need to think about setting up the build process, nor work out the best base image to run off.

Not only did it make it handy to get up and running, but it manages better layering of images, and runs as an unprivileged user. Being able to more easily build and publish images is pretty great, and made the CI/CD configuration straightforward.

And it helps that by the time I finished, the Spring Boot team had released a number of changes to make it even better.

# I don't know how Java memory works

The biggest thing I've learned is that I know very little around how memory management works with Java.

On my VPS, each JVM was running with default `JAVA_OPTS`, which meant that each service would be seeing they had 1GB of memory, but then would fight each other to actually use it. This only caught me out a few times, fortunately, so I just kinda left it to itself.

Now, moving to containerised applications, I had the same problem, and needed to appropriately limit the containers.

Unfortunately, it wasn't as simple as giving each application a 1/5 slice of 1GB to mirror what was likely in use on the VPS, because the [CloudFoundry Java Buildpack](https://github.com/cloudfoundry/java-buildpack/) which is used to build the images has an inbuilt [memory calculator](https://github.com/cloudfoundry/java-buildpack-memory-calculator). It's pretty cool, because it makes sure that you're running it on a configuration which will fit within the memory constraints that best practices highlight as necessary for the application.

_However_ this meant that I was ending up needing between 500MB-900MB per service, which meant I needed to provision a lot more infrastructure to get things fitting nicely.

As mentioned in the "Costs More" section below, I eventually switched off of GKE because the cost was very high, and onto Digital Ocean. I still hit the same issues though, and it wasn't until I found [this StackOverflow answer](https://stackoverflow.com/a/62335341/2257038) which highlighted that:

- I was using `JVM_OPTS` instead of `JAVA_OPTS`, which wasn't helping!
- I needed to tweak i.e. `Xms` and `ReservedCodeCacheSize`

Once I'd taken this into account, I managed to get most of the apps running in a much more comfortable position, leading to a not massive overhead.

It definitely humbled me by reminding me that I've still got a lot to learn!

# Vendor-specific

I'd originally started with Google Cloud's Kubernetes Engine (GKE) as I had some free credits to burn, and I thought if anyone is going to be a good platform to start with Kubernetes on, it's gonna be Google.

One thing I did find a bit frustrating was trying to set up TLS certificates on the Ingress point for GKE, as it required using the GKE Kubernetes configuration, whereas a lot of the public documentation / StackOverflow answers talk about the Nginx Ingress.

I eventually started reading enough of the answers - instead of blindly copy-pasting and getting frustrated when things worked - to understand _why_ it wasn't working.

# Logz.io's fluentd configuration

I've used Logz.io at work, and found it to be a really great hosted ELK offering. Given they had a free tier, I thought I'd give it a go for my own services.

I was really quite impressed by how easy it was to get Logz.io set up, and their [super handy configuration](https://github.com/logzio/logzio-k8s) made it incredibly easy to get up and running.

While I did the migration, I took the opportunity to migrate to [structured logging](/posts/2021/05/31/spring-boot-structured-logging/), albeit it did require [some tweaking to make it work with fluentd](/posts/2021/09/29/fluentd-inner-json/).

I've more recently found that this was made more difficult by there being the non-containerd and the containerd configuration for Kubernetes, and after an upgrade of Kubernetes, I needed the latter configured. Took me a fair bit of puzzling why things weren't working!

# Costs more

The TL;DR here is that, if you're not using vendor-specific configuration for your clusters, you can probably move fairly easily between providers.

I started with GKE, and despite the difficulties with Ingress, was able to move over to Digital Ocean in a pretty clear path, which also gave me the chance to rearchitect the namespaces, and do a few other things like re-configure fluentd from scratch.

I moved from €15/month to £180/month while on Google Cloud. Fortunately I was only on for a couple of months, but it was _hugely_ wasteful, and I really should've just got rid of it and not cost myself so much money, and it was a good reminder that running production quality services - which I don't _really_ need for personal projects - is very expensive.

On Digital Ocean, I now pay ~$40/month, which is still significant, especially compared to €15/month, so I want to see what I can do to further reduce this cost, and make it more applicable.

# Running other apps on the platform

Although I was only doing the migration for Java apps, I'd found that I could replace a third Hezner VPS (€5/mo). This VPS was functioning as a self-hosted GitLab CI runner that was used to speed up deployments of my site and was purely its own VPS to simplify the management of resources compared to those Java apps.

Because I now had a handy platform, with some spare compute, and the ease of autoscaling, I've set up a GitLab CI runner on Kubernetes, which was nice and straightforward!

I've got a VPS on Scaleway running [Matomo analytics](https://matomo.org/) that I can also move onto Kubernetes when I get a chance, saving some cost there too.

# (Managing) State Is Hard

For one of my services, I have a database that's needed to persist a fair bit of data. As I could rely on the filesystem being persisted, and I didn't fancy running a full database, I decided to instead use [SQLite](https://sqlite.org/), which worked really nicely. Now, I'm running MySQL in a container, with no backups, as any lost data is fine to re-create, but it does result in another container + extra complexity required.

I also had a couple of services that needed to allow for persistent storage of a refresh token (that on each refresh would be re-issued). Again, storing these to the filesystem made sense, but when containerised, the filesystem doesn't persist, so I needed to investigate storing it in a Secret.

# Reading/Writing Secrets

As mentioned above, I also needed to handle the management of secrets that are both static and those that change during the running of the service.

Static secrets were easily handled through an Opaque secret, but to manage secrets such as refresh tokens that are issued as part of an OAuth2 consent flow while running the app, I needed to set up some runtime access.

I didn't want to deploy Hashicorp Vault, although that would be the best solution, so instead looked into how to manage it using the Kubernetes secrets APIs.

As mentioned in [_Updating a Secret in Kubernetes with the Java Client_](/posts/2021/10/23/kubernetes-java-patch-secret/), this wasn't super simple, but I got there in the end.

## Kubernetes API Client configuration issues

Unfortunately I do seem to still be hitting intermittent issues with the Kubernetes Java client not getting the right configuration, which leads to runtime secrets not being retrievable:

```json
{
  "@timestamp": "2021-09-28T08:00:00.482+00:00",
  "@version": 1,
  "exception": {
    "exception_class": "java.lang.IllegalStateException",
    "exception_message": "io.kubernetes.client.openapi.ApiException: java.net.ConnectException: Failed to connect to localhost/[0:0:0:0:0:0:0:1]:80",
    "stacktrace": "java.lang.IllegalStateException: io.kubernetes.client.openapi.ApiException: java.net.ConnectException: Failed to connect to localhost/[0:0:0:0:0:0:0:1]:80\n\tat me.jvt.www.indieauthcontroller.store.kubernetes.KubernetesSecretTokenStore.get(KubernetesSecretTokenStore.java:53)"
  },
  "level": "ERROR",
  "logger_name": "org.springframework.scheduling.support.TaskUtils$LoggingErrorHandler",
  "message": "Unexpected error occurred in scheduled task",
  "source_host": "google-fit-7bbcb4ddc7-n26qn",
  "thread_name": "scheduling-1"
}
```

# Safer upgrades

When I was on my VPS setup, I was overwriting the existing JAR on the server and restarting the app, which can cause problems with the running app, while copying, and also leads to the risk of downtime if I had forgotten to SSH on and update a config file / add a secret.

# Easier Java Upgrades

Now I've got containerised Java applications, it's now super straightforward for me to change the Java runtimes for either an individual or all services.

Although I could've done this using a `JAVA_HOME` hack, by having multiple JVMs installed, I decided I'd rather make a jump to JDK9 as a whole project + set of services.

# No dev while migrating

While I was working on the replatforming, I ended up doing very little development work on these services.

It made it easier to manage, as although I'd switched over the DNS to the Kubernetes cluster, I'd not yet got the changes merged into my main branch, as I'd not yet finalised commit history, because I also hadn't got things working.

# Cleanup

While I was doing the migration, there were some services I realised weren't actually providing any benefit to me like an service for producing metrics about my site's analytics to then show on my blog. I took this chance to get rid of it, at least from the running platform, even if the code's still available.

# `kube-linter`

Just today I've seen the [kube-linter project](https://github.com/stackrox/kube-linter) which has [picked up on several issues](https://gitlab.com/jamietanna/www-api/-/issues/379) that can be improved.

# Was it worth it?

It's definitely been worth it for the state of my APIs now, and the ease of deployment + operability have already made a good difference. Although the cost is still higher than I'd have hoped, I'll work to reduce that over time.

I've learned a fair bit about Kubernetes, and got a bit more experience with something that I could've been using more, and I feel like it's something that quite a lot of people will end up needing to have at least a little understanding of at some point.
