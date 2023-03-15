---
title: "Working out which Docker namespaces and images you most depend on"
description: "How to use dependency-management-data to visualise the most popular Docker namespaces and images you depend on."
tags:
- blogumentation
- docker
- dependency-management-data
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2023-03-15T21:44:03+0000
slug: "dmd-docker-usage"
image: https://media.jvt.me/2b06cbc075.png
---
With [the news yesterday that Docker Inc](https://news.ycombinator.com/item?id=35154025) is sunsetting the "Free Team" organisations, the engineering community at large is considering the ramifications.

Although some answers have been given, there's still a bit of uncertainty around what may happen to existing images that are in use, so being able to work out what images you depend on - before the 30 day timeline expires! - is a good way to get some indication of whether you need to re-host or proxy any images.

So how is best to work this out? As [I've recently mentioned](https://www.jvt.me/posts/2023/02/20/dmd-cli/), I've been working on tooling to make working with your dependency data much more effectively.

As of this evening, the [`dmd` CLI now supports](https://gitlab.com/tanna.dev/dependency-management-data/-/tags/v0.6.0) the ability to query the most used images, and registry namespaces, that are in use across projects.

This gives us an indication of the top 10 most popular Docker namespaces in use, followed by the top 10 most popular images.

When running the `mostPopularDockerImages` report, we can see:

```
dmd report mostPopularDockerImages --db dmd.db

Renovate
+----------------------------------------------+----+
| NAMESPACE                                    |  # |
+----------------------------------------------+----+
| _                                            | 10 |
| jenkins                                      |  2 |
| public.ecr.aws/nginx                         |  2 |
| 172025368201.dkr.ecr.eu-west-1.amazonaws.com |  2 |
| circleci                                     |  1 |
| ghcr.io/alphagov/verify                      |  1 |
| ghcr.io/yannh                                |  1 |
| alpine                                       |  1 |
+----------------------------------------------+----+
+------------------------------------------------------------+---+
| IMAGE                                                      | # |
+------------------------------------------------------------+---+
| eclipse-temurin                                            | 4 |
| jenkins/jenkins                                            | 2 |
| node                                                       | 2 |
| public.ecr.aws/nginx/nginx                                 | 2 |
| gradle                                                     | 1 |
| mysql                                                      | 1 |
| 172025368201.dkr.ecr.eu-west-1.amazonaws.com/asset-manager | 1 |
| ghcr.io/yannh/kubeconform                                  | 1 |
| golang                                                     | 1 |
| circleci/golang                                            | 1 |
| alpine/git                                                 | 1 |
| ghcr.io/alphagov/verify/java                               | 1 |
+------------------------------------------------------------+---+
```

This is based on the [example project](https://gitlab.com/tanna.dev/dependency-management-data-example/), alongside some additional public repositories from [the Government Digital Service (GDS)](https://github.com/alphagov/).

In this case, there's not a lot of data, but running this against my company's database gives some very interesting breakdowns 👀
