---
layout: post
title:  Continuous Delivery for Docker with GitLab Continuous Integration
description: TODO
categories:
---

One of the great things about [GitLab CI][gitlab-ci], that is not available in something like [Travis CI][travis-ci], is that you can provide your own Docker images to be run as part of the CI infrastructure. This, coupled with the `*registry*` that GitLab provides on a per-project basis, means that you can pack all the dependencies required for your application into one built image (`image vs container`).

