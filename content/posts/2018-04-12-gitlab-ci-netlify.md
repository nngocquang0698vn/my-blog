---
title: Deploying to Netlify using GitLab CI
description: 'How adding two lines to my `.gitlab-ci.yml` migrated my existing site from GitLab Pages to Netlify.'
categories: guide
tags: netlify gitlab-ci automation continuous-deployment ci deploy howto
no_toc: true
image: /img/vendor/netlify-full-logo-white.png
---
**Update** The code snippet below has been updated to point to `netlifyctl` rather than the `netlify` Node CLI, as `netlifyctl` is now the recommended CLI interface.

Since I migrated my [meetups + conference talks repo][gl-talks] to Reveal.JS, I've found that I've been wanting to have a branch spun up with the talk's content at a publically accessible URL, exactly how [I have configured Review Apps][review-apps] for my personal site.

However, as I was using GitLab pages, I wasn't able to get this functionality working (and it [likely will not be configured upstream][gl-pages-review]). Recently I've been hearing a lot about [Netlify], which made this a perfect opportunity to see what everyone was raving about.

The first step I needed to take was to move from GitLab Pages to Netlify, which I detail below, followed by configuring Netlify for Review Apps / Deploy Preview. I'll be [covering that in a later article][netlify-review-apps], once I've worked out how to do it, as at first glance, the URL structure for branch deploys doesn't work quite as nicely out-of-the-box with GitLab Review Apps.

As building the talks require a few tools to exist on the box, I would prefer to continue using GitLab CI as my platform to build the content. Note that I'm trying to [make the process better][package-deps] but I'd still like to retain GitLab as the owner of the build process.

While looking at how to transition, I couldn't find anything explicitly sharing how to get this up and running. That may have been because it's incredibly simple to bake in using the [`netlify-cli`][netlify-cli] tool.

I simply had to change my `.gitlab-ci.yml` to add the following:

```diff
 stages:
   - deploy

 netlify:
   stage: deploy
   image: registry.gitlab.com/jamietanna/jvt.me/builder:master
   script:
     - "./.ci/build-reveal-site.sh chef-infrastructure-as-cake"
     - "./.ci/build-reveal-site.sh came-for-the-campus-stayed-for-the-community"
     - "mkdir public"
     - "touch public/index.html"
     - "./.ci/deploy-reveal-site.sh chef-infrastructure-as-cake 'Chef: Infrastructure as Cake'"
     - "./.ci/deploy-reveal-site.sh came-for-the-campus-stayed-for-the-community 'Came for the Campus, Stayed for the Community'"
+    - apk add --update curl
+    - curl https://github.com/netlify/netlifyctl/releases/download/v0.4.0/netlifyctl-linux-amd64-0.4.0.tar.gz -LO
+    - tar xvf netlifyctl-linux-amd64-0.4.0.tar.gz
+    - ./netlifyctl deploy -s b758cf8f-9eeb-4770-ba63-ce7defafe8f6 -P public -A $NETLIFY_ACCESS_TOKEN
   artifacts:
     paths:
       - public
   only:
     - master
```

Next, I needed to create a personal access token to authorize myself to the Netlify API. I did this by browsing to [`Account Settings`, then the `OAuth Applications` tab][appl] and clicking `New access token`.

I set this as the secret variable `NETLIFY_ACCESS_TOKEN` in the GitLab repo's `CI/CD` subsection under the `Settings`, and that was it, ready to go!

Then, [we can see a deploy succeeds][deploy], and you can now access the site at [https://talks.jvt.me](https://talks.jvt.me), with certificates managed by Netlify, and provisioned by [Let's Encrypt][le].

[netlify]: https://netlify.com
[review-apps]: {% post_url 2017-07-18-gitlab-review-apps-capistrano %}
[package-deps]: https://gitlab.com/jamietanna/talks/issues/13
[netlify-cli]: https://www.netlify.com/docs/cli/
[appl]: https://app.netlify.com/account/applications
[le]: https://letsencrypt.org/
[gl-talks]: https://gitlab.com/jamietanna/talks
[deploy]: https://gitlab.com/jamietanna/talks/-/jobs/79611358
[netlify-review-apps]: https://gitlab.com/jamietanna/jvt.me/issues/247
[gl-pages-review]: https://gitlab.com/gitlab-org/gitlab-ce/issues/26621
