---
layout: post
title: GitLab Review Apps with Capistrano and Nginx
description: Spinning up a version of your application on every push, so others don't have to manually get the code up and running locally.
categories: guide
tags: guide gitlab review-apps capistrano
---
## Wait, What are Review Apps?

I very recently set up [GitLab's Review Apps][review-apps] for this site, meaning that I can very easily spin up a copy of my site for visual review.

For example, the [`example/review-apps`][review-apps-branch] branch is deployed under the [`review/example/review-apps`][review-apps-environment] environment to <http://example-review-apps.review.jvt.me/>:

![`example/review-apps` environment]({{ site.url }}/assets/img/gitlab-review-apps-capistrano/example-review-apps.png)

This means that each branch I push to will spin up a new instance of my site under the `review.jvt.me` subdomain.

Being a static site, this hasn't got a lot of overhead, especially as each Review App is going to have minimal traffic, due to it only being used by me in review. However, for a larger static site, or even a fully fledged web application, it can be understood why you may not want to be having each and every branch being built and deployed. This can be changed by setting it to be a `manual` task, rather than on each and every push.

## Changes for Capistrano

For my site, I'm using [Capistrano][capistrano] as the deployment tool, which means that when I want to perform a deploy, I can run something like `cap production deploy`. I'd ideally want to follow the same structure, and have a new stage so I can run `cap review deploy`.

This is easy to do, by creating the file `config/deploy/review.rb`:

```ruby
# config/review/deploy.rb
{% include src/gitlab-review-apps-capistrano/config-deploy-review.rb %}
```

Next, we want to have the ability to tear down the environment once we're finished with it. This can be done by creating our own Rake task file, in `lib/capistrano/tasks/review.rake`, and allows us to run `cap review stop`.

```ruby
# lib/capistrano/tasks/review.rake
{% include src/gitlab-review-apps-capistrano/lib-capistrano-tasks-review.rake %}
```

## Changes for GitLab CI

GitLab has the full steps required for setting up Review Apps in the [Review Apps documentation][review-apps-doc]. The first step required is to add a new entry in the `deploy` stage, which deploys into a `review/...` environment:

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

Note the `on_stop` attribute, which is the name of the stage that is to be called once we tear down a Review App.

This does half of the work - we've spun up our Review App, but we haven't yet specified how to tear it down. For instance, if you're deploying a site with lots of images, or an application that may require resources such as CPU or memory to run, you may not always want to have the Review App always there.

Additionally, if you're deploying a sufficiently large Git repo, or a site with a number of images, the disk space on your server may start to run out.

Therefore, to run a stop action, we use the name of the stage from the `environment.on_stop` attribute:

```yaml
review_stop:
  image: $CONTAINER_DEPLOY_IMAGE
  stage: deploy
  script:
    - eval $(ssh-agent -s)
    # ...
    - ssh-add key
    - cap review stop
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    action: stop
  when: manual
  only:
    - branches
  except:
    - master
```

Note that the only significant changes to the above are that we now:

- use the previously created `cap review stop` command
- change `environment.action` to `stop`
- make it run as a `manual` action, instead of it being automagically run (and therefore removing our Review App before we can view it!)

## Changes for Nginx

While investigating the easiest way of setting up Nginx to work with this, I stumbled upon the [regular expression names][nginx-regex] functionality in Nginx, which allows you to define regular expressions for a DNS name. This was perfect, allowing me to add the following to my config:

```nginx
# /etc/nginx/sites-enabled/review.jvt.me
{% include src/gitlab-review-apps-capistrano/nginx %}
```

## Points for Improvements

I've not yet got this configured yet as I fully want, and have been collecting future improvements and other useful thoughts in the [`~review-apps`][review-apps-label] label in my site's issue tracker. I'm sure I'll be tweaking it over the coming weeks as I find out what I like and want to have done with it.

[review-apps]: https://about.gitlab.com/features/review-apps/
[review-apps-doc]: https://docs.gitlab.com/ee/ci/review_apps/
[capistrano]: http://capistranorb.com/
[review-apps-branch]: https://gitlab.com/jamietanna/jvt.me/commits/example/review-apps
[review-apps-url]: http://example-review-apps.review.jvt.me/
[review-apps-label]: https://gitlab.com/jamietanna/jvt.me/issues?label_name%5B%5D=review-apps
[nginx-regex]: https://nginx.org/en/docs/http/server_names.html#regex_names
