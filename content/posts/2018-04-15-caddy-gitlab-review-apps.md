---
title: Serving Branches on a Subdomain using Caddy and GitLab Review Apps
description: How to dynamically serve a branch on a subdomain for GitLab Review Apps using Caddy Labels.
categories:
- guide
tags:
- guide
- gitlab
- review-apps
- caddy
- howto
- deploy
image: /img/vendor/gitlab-wordmark.png
date: 2018-04-15
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: caddy-gitlab-review-apps
---
This post describes how to work with Caddy. I've previously written about how to use [GitLab Review Apps with Capistrano and Nginx][gitlab-review-apps-capistrano], which may be of interest.

Although this example uses GitLab Review Apps, it could much as easily be used for any other branch-based deployments.

I've recently been wanting to move to Caddy, for a number of reasons, but mostly its ability to manage the [Let's Encrypt Lifecycle][caddy-https], as well as being a single static (Go) binary.

However, one of the big concerns I had with moving from Nginx to Caddy was the configuration for my Review Apps configuration. I currently am able to publish a branch, `example/review-apps`, to an FQDN, `example-review-apps.www.review.jvt.me`, where `example-review-apps` is provided to me by GitLab CI in the variable [`CI_COMMIT_REF_SLUG`][gitlab-ci-vars].

My Nginx configuration was quite simple, utilising nginx's [regular expression names][nginx-regex]:

```nginx
# /etc/nginx/sites-enabled/review.jvt.me
server {
    listen 80;
    server_name ~^(www\.)?(?<sname>.+?).review.jvt.me$;
    root /srv/www/review.jvt.me/review.jvt.me/review/$sname/current/site;

    index index.html index.htm index.php;
    error_page 404 /404.html;

    charset utf-8;

    access_log /var/log/nginx/review.jvt.me-access.log;
    error_log  /var/log/nginx/review.jvt.me-error.log debug;
}
```

The ease of this solution made me concerned that I would not be able to easily migrate to the same automagic redirection using Caddy. However, in [Caddy 0.10.12], this was included using the concept of [Caddy labels], [via confirmation in the Caddy Community forums][caddy-community-review-apps]:

```
https://*.review.jvt.me {
  root /srv/www/review.jvt.me
  rewrite {
    to /{label1}{uri}
  }
}
```

Let us take the example above, and we come in on `https://example-review-apps.www.review.jvt.me/test`:

- Caddy passes the value of the wildcard into `label1`, which with the `rewrite` rule expands out to `/example-review-apps/test`
- Caddy combines this with the `root` directive to expand this out on disk to `/srv/www/review.jvt.me/example-review-apps/test`

[caddy-community-review-apps]: https://caddy.community/t/serving-different-roots-from-a-wildcard-host/3510/7?u=jamietanna

[gitlab-review-apps-capistrano]: {{< ref 2017-07-18-gitlab-review-apps-capistrano >}}
[caddy-https]: https://caddyserver.com/docs/automatic-https
[gitlab-ci-vars]: https://docs.gitlab.com/ce/ci/variables/README.html
[nginx-regex]: https://nginx.org/en/docs/http/server_names.html#regex_names
[Caddy labels]: https://github.com/mholt/caddy/pull/2072
[Caddy 0.10.12]: https://github.com/mholt/caddy/milestone/16
