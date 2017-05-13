---
title: Kickstarting your Automated Build and Continuous Delivery platform with GitLab CI
layout: talk
type:
- workshop
description:
  In this workshop, I'll take you through the basics of GitLab's Continuous Integration platform, with a very simple web application. This will go through local development to production deployments in a controlled fashion, with automated builds through to deployment.
---

We'll look at how we can get set up with deployment of a very basic web application from our local machine through to deploying it to production. This will take advantage of a number of GitLab features such as [GitLab CI][gitlab-ci], [Environments][environments] and [Review Apps][review-apps]. This will highlight aspects of the GitLab platform that excel compared to other platforms, and talk about how it can be better engrained in your workflow.

The application itself will be a simple web application that provides a frontend as well as some basic backend processing. We will work on getting it pushed to GitLab, and then having it integrated with GitLab CI. This will ensure that we've got our application unit tested, and allow us to only accept Merge Requests when our builds pass.

But unit tests can only tell you so much - so we need to get our integration tests up and running - this will be our next step, taking advantage of the Docker-based infrastructure, and letting us run our application and test it fully.

Next, we'll look at how to get the application deployed easily using Environments, such that `master` continually deploys to our Staging environment, followed by manual deployments into our Production environment. We'll also see how GitLab provides Git `ref`s to help us track the _exact commit_ pushed to an environment.

However, what if we want to see what a new UI change on a Merge Request looks like? Well, here come Review Apps, to let us try out the new changes without even needing to set it up locally.

[gitlab-ci]: https://about.gitlab.com/gitlab-ci/
[review-apps]: https://about.gitlab.com/features/review-apps/
[environments]: https://docs.gitlab.com/ce/ci/environments.html
