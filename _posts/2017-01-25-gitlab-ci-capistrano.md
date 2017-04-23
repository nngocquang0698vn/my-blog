---
layout: post
title:  Continuous Delivery with Capistrano and GitLab Continuous Integration
description: How to get up and running with using GitLab CI and the Capistrano deploy tool
categories: guide
tags: capistrano deploy ci gitlab docker
---

[Capistrano][capistrano-rb] is a deploy tool written in Ruby that I adopted last year, and started use with `jvt.me`, `hacknotts.com` and `inspirewit.com`.

## Continuous Delivery

### What's the Point?

Continuous Delivery is a brilliant method of ensuring that your software is pushed to (ideally) the production environment, to increase the confidence you have with your deployment process, and to help unlock functionality and value for the end user much, much more quickly.

As you would expect, this ties in very nicely with Continuous Integration.

## A Brief Introduction to Capistrano

### Why use Capistrano?

Capistrano employs a powerful Domain Specific Language in which you can describe the method of which your deployments should occur.

Capistrano provides the ability to perform a deployment to a given environment or host, as well as orchestrating rollbacks if needed, too.

Capistrano also has a concept called roles which provides the ability to describe whether a given host is a web server, a database server, or some other given part of infrastructure. As part of this, you can ensure that only the required hosts are touched with the latest changes, instead of the whole deployment infrastructure being updated.

Although this functionality can all be done with a set of shell scripts (or indeed one of the many other deploy tools), Capistrano's simplicity makes it an ideal tool for simple and complex applications alike. My choice to use Capistrano was due to my use of Jekyll, and its ability to work with many different ecosystems, such as the ability to run `grunt` for `hacknotts.com`.

## How to Hook into GitLab Continuous Integration

Now we understand why we would want to use Capistrano, let's look at how to integrate the process into GitLab's CI.

### CI Images + Dependencies

One of the great things about [GitLab CI][gitlab-ci], that is not available in something like [Travis CI][travis-ci], is that you can provide your own Docker images to be run as part of the CI infrastructure. For instance, instead of having a set image in Travis, which may or may not have dependencies, which you then need to install, you can leverage this and specify what you want your tests to run on.

For instance, we want to be using Capistrano, which is a Ruby tool. Therefore, we would want to have Ruby preinstalled. This can be done with the following line in our `.gitlab-ci.yml` file, which specifies a Docker image that can be grabbed straight from the Docker hub.

```yml
image: ruby:2.3
```

Next, we need to specify Capistrano as a dependency. We can do this one of two ways; firstly, we can use the `before_script` directive, which will install `capistrano` before _each and every_ stage within our CI run. This means that if there are several stages for the CI pipeline, there will be several installs, too.

```yml
image: ruby:2.3
before_script:
  - gem install capistrano
```

Alternatively, we can install dependencies solely when we're deploying the image. As you would imagine, this is the preferable choice, and will save us unnecessary downloads.

```yml
image: ruby:2.3

stages:
  - deploy

deploy_application:
  stage: deploy
  script:
    - gem install capistrano
```

This now allows us the opportunity to run Capistrano as part of our deploy job. For instance:

```yml
deploy_application:
  stage: deploy
  script:
    - gem install capistrano
    - cap production deploy
```

This would perform the `deploy` job for the `production` stage. However, we don't always want to deploy to production, and will instead want to perform a deployment dependent on the branch. For instance, the following snippet will deploy the `develop` branch to the `staging` environment, and the `master` branch to the `production` environment.

```yml
staging_deploy:
  stage: deploy
  script:
    - gem install capistrano
    - cap staging deploy
  only:
    - develop

production_deploy:
  stage: deploy
  script:
    - gem install capistrano
    - cap production deploy
  only:
    - master
```

Note that this isn't always the best pattern; for true Continuous Delivery, we would be using short-lived branches, and for Eventual Integration projects, this could be updated to deploy separate branches into respective stages.

### Capistrano Secrets

However, there is an issue; Capistrano won't work! Due to the method it uses SSH keys for deployment, we need to bake in an SSH key for the deploy job to be able to communicate with the end server.

However, due to the way that key-based authentication works, this will require the saving of the private key for the job. As such, this needs to be carefully done; if the private key is at any point exposed in the logs, this will compromise the security of the server.

Therefore, the best method is to use `ssh-agent`, as outlined in [the GitLab docs][ssh-keys-in-gitlab-ci]. Note that these steps will only work on a Debian-based host. If running on a different Operating System, you will need to install `ssh-agent` through your package manager.

```yml
staging_deploy:
  stage: deploy
  script:
    - which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )
    - eval $(ssh-agent -s)
    # add ssh key stored in SSH_PRIVATE_KEY variable to the agent store
    - ssh-add <(echo -e "$SSH_PRIVATE_KEY")
    - gem install capistrano
    - cap staging deploy
  only:
    - develop
```

This requires that we have added our SSH key into the `Variables` section in the GitLab project. A workaround that fixes a bug where the private key isn't interpreted correctly can be done by replacing each of the newlines with a literal `\n`.

```bash
# http://stackoverflow.com/a/1252191
sed ':a;N;$!ba;s/\n/ /g' /path/to/private_key
```

With this in place, our deploy will now correctly authenticate to the end server, and perform our deploy as requested!

Now, when we perform a push to our `master` or `develop` branches, we'll be able to push through to our `production` or `staging` environment respectively.


[travis-ci]: http://travis-ci.org/
[gitlab-ci]: https://about.gitlab.com/gitlab-ci/
[capistrano-rb]: http://www.capistranorb.com/
[ssh-keys-in-gitlab-ci]: https://docs.gitlab.com/ce/ci/ssh_keys/README.html
[ssh-keys-in-gitlab-ci-workaround]: https://gitlab.com/jamietanna/gitlab-ce/commits/patch-6
