---
layout: post
title: GitLab Review Apps with Capistrano and Nginx
description: Spinning up a version of your application on every push.
categories: guide
tags: guide gitlab review-apps capistrano
---
I very recently set up [GitLab's Review Apps][review-apps] for this site, meaning that I can very easily spin up a copy of my site for visual review. **What does this mean?**
**Link to a review-apps (i.e. for this article? A fake one, to show how it looks?)**

## Changes for Capistrano

For my site, I'm using [Capistrano][capistrano] as the deployment tool, which means that when I want to perform a deploy, I can run something like `cap production deploy`.

However, I'd want to have a separate state for the review apps.

I decided to have `review` as the stage name, so we can simply run `cap review deploy`. This is easy to do, by creating the file `config/deploy/review.rb`:

```
{ include src/gitlab-review-apps-capistrano/config-deploy-review.rb }
```

Next, we want to have the ability to tear down the environment once we're finished with it. This can be done by creating our own Rake task file, in `lib/capistrano/tasks/review.rake`, and allows us to run `cap review:stop`.

```
{ include src/gitlab-review-apps-capistrano/lib-capistrano-tasks-review.rake }
```

## Changes for GitLab CI

GitLab details the steps required to set up the app in the [Review Apps documentation][review-apps-doc]. The first step required is to add a new entry in the `deploy` stage, which deploys into a `review/...` environment:

```yaml
review_deploy:
  image: $CONTAINER_DEPLOY_IMAGE
  stage: deploy
  script:
    - eval $(ssh-agent -s)
    # ...
    - ssh-add key
    - cap review deploy
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    url: http://$CI_COMMIT_REF_SLUG.review.jvt.me
    on_stop: review_stop
  only:
    - branches
  except:
    - master
```

Note the `on_stop` attribute - **TODO**.


However, this only does half of the work - so we have the

```yaml
review_stop:
  image: $CONTAINER_DEPLOY_IMAGE
  stage: deploy
  script:
    - eval $(ssh-agent -s)
    # ...
    - ssh-add key
    - cap review deploy
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    action: stop
  when: manual
  only:
    - branches
  except:
    - master
# }}}
```


## Changes for Nginx

As I'm using Nginx, I can take advantage of **regex replacement**, which means I can add the following to my config:

```
{ include src/gitlab-review-apps-capistrano/nginx }
```

## Points for Improvements

**TODO link to label:review-apps**

- GitLab changes
- Capistrano config
  - Adding new tasks
  - Adding new stage
- Server config
  - Nginx wildcard bits

[review-apps]: https://about.gitlab.com/features/review-apps/
[review-apps-doc]: https://docs.gitlab.com/ee/ci/review_apps/
[capistrano]: http://capistranorb.com/
