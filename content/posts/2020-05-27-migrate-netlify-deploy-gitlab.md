---
title: "Migrating to Netlify's Deployments from GitLab CI"
description: "Moving to avoid flaky deployments, and trying to reduce deployment times."
tags:
- gitlab-ci
- netlify
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-27T19:18:58+0100
slug: "migrate-netlify-deploy-gitlab"
image: /img/vendor/netlify-full-logo-white.png
---
# Webmention Sending

I've mentioned in the past that this site is static site which is built on Hugo. Because it is static, it can't automagically send Webmentions when posts are published.

However, [I did set up]({{< ref 2019-09-10-webmentions-on-deploy >}}) the ability to send a post-deployment notification to a service I've written, which on deployments of my site, would send webmentions to any links referenced.

Because I was all-in on GitLab CI, I had it so after a GitLab deployment I would receive a webhook to say that the build had completed, and after doing some validation to make sure it was definitely a successful deployment from `master`, I would continue with processing.

Unfortunately over the last 3-4 months, I've noticed an increasing frequency of deploys "failing". It appears that `netlifyctl`, the tool I was using to upload the built HTML, was timing out/failing when sending requests to Netlify, which subsequently made the execution fail, and then GitLab would see it as a failed deploy. However, Netlify _was_ still processing the deployment, and so the changes would go live.

Because of this, post-deployment triggers wouldn't work, and I wouldn't send Webmentions. What's the harm though? Couldn't they just be picked up later?

Not really. It meant that interactions with i.e. Twitter would maybe not be sent for 30 minutes (or [longer](/mf2/2020/04/knfnz/)) and as well as being annoying, it was a little embarrassing!

I decided that one way I could simplify this is to replace the GitLab notifications with Netlify's, because that should, really, be the source of truth for validating that the site has deployed successfully.

At [last Homebrew Website Club Nottingham](https://events.indieweb.org/2020/05/online-homebrew-website-club-nottingham-j91sUdJVM1bh) I moved my site to build purely on Netlify, and then on Monday, I _finally_ got the [code sorted](https://gitlab.com/jamietanna/www-api/-/merge_requests/158) (nicely) to handle the new webhook format on Monday.

# Speed

However, the other reason I wanted to migrate away is that I was finding GitLab CI builds a little slow. On top of the maybe 2-3 minutes that actually is required to upload, there's between 1-6 minutes waiting for a GitLab CI runner to spin up and then download the required Docker images. That's a tonne of time lost, and when it's that long between trying to have semi-realtime conversations on i.e. Twitter, that's not ideal.

## Self-Hosted GitLab CI Runners

I'd spent a while on-and-off looking into running a self-hosted GitLab CI running, noting that I didn't really care if I was spending a bit of my own money to make sure that my site deployed quicker - it was almost certainly worth it!

I thought that, really, the time cost of downloading containers would be the issue here, and that if I self-hosted, I'd be able to save that cost.

Unfortunately, that isn't the case, as seen in [the issue raised with GitLab, _Caching for docker-in-docker builds_](https://gitlab.com/gitlab-org/gitlab-foss/-/issues/17861).

I'll continue to work at it, to see if it's something I can get working, as it appears other folks have done it, too.

# Caveats

But am I happy with this? Not really.

Between last Homebrew Website Club Nottingham (Wednesday) and that Sunday, I'd burned through half of my free minutes on Netlify. To date, I've used 499/300 build minutes (incurring $7 of extra usage so far) and am still seeing a bit of slow-ness while Netlify downloads various build tools, when all I need is `git` and `hugo`.

I'm also wondering if I'm outgrowing Netlify, and maybe need to look at something that I can update much quicker. I've thought about maybe an S3 bucket, fronted by CloudFront.

Got thoughts? Let me know!
