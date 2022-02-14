---
title: "Using Middleman Redirects with a Custom, Non-HTML Content Type"
description: "How to get Middleman's `redirect` to work with files that are not HTML."
date: 2021-10-28T11:34:59+0100
tags:
- "blogumentation"
- "middleman"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: "middleman-redirect-content-type"
image: https://media.jvt.me/5a4be89ccd.png
---
The [`security.txt` standard](https://securitytxt.org/) is a great one for managing security policies for websites.

If you manage multiple websites, you may want to point all of them to a central `security.txt`, rather than managing the metadata on each site.

As I manage a few sites that run on Middleman, we were looking at managing them centrally using Middleman's redirects.

We started by using Middleman's `redirect` (after being hit by [this gotcha](https://github.com/middleman/middlemanapp.com/pull/854)), resulting in this:

```ruby
redirect "security.txt", to: "https://security-redirect.example.com/.well-known/security.txt"
```

This then produces the following HTML in `build/security.txt`, which looks great:

```html
<html>
  <head>
    <link rel="canonical" href="https://security-redirect.example.com/.well-known/security.txt" />
    <meta http-equiv=refresh content="0; url=https://security-redirect.example.com/.well-known/security.txt" />
    <meta name="robots" content="noindex,follow" />
    <meta http-equiv="cache-control" content="no-cache" />
  </head>
<body>
</body>
</html>
```

Unfortunately, when this is served by the local Middleman server, it is rendered as `Content-Type: text/plain`, so the browser doesn"t actually perform the redirect.

To handle this correctly for our local server, we can tell it to render the `security.txt` as HTML, by using th `content_type`:

```ruby
page "/security.txt", content_type: "text/html"
redirect "security.txt", to: "https://security-redirect.example.com/.well-known/security.txt"
```

This works for local, but then doesn't let this work when we're hosting it, as the `content_type` doesn't get translated into the built files.

To manage this, we then need to add a `redirect` for the `.html` extension:

```ruby
page "/security.txt", content_type: "text/html"
redirect "security.txt", to: "https://security-redirect.example.com/.well-known/security.txt"
redirect "security.txt.html", to: "https://security-redirect.example.com/.well-known/security.txt"
```

I've tested that this works on GitHub Pages, Netlify and GitLab, but if you run on a different hosting platform, the stripping of the trailing `.html` may not work.

In cases where your deployment provider may have problems if both `Security.txt` nad `security.txt.html` are present, when requesting `/security.txt`, you can make it optional:

```ruby
def external_redirect(from, to)
  configure :development do
  page "/security.txt", content_type: "text/html"
  redirect "security.txt", to: "https://security-redirect.example.com/.well-known/security.txt"
end

redirect "security.txt.html", to: "https://security-redirect.example.com/.well-known/security.txt"
```

And for duplication:

```ruby
def external_redirect(from, to)
  configure :development do
    page "/#{from}", content_type: "text/html"
    redirect from, to: to
  end

  redirect "#{from}.html", to: to
end

external_redirect("security.txt", "https://security-redirect.example.com/.well-known/security.txt")
```

Alternatively, we can get it working with just this:

```ruby
redirect "security.txt/index.html", to: "https://vdp.cabinetoffice.gov.uk/.well-known/security.txt"
import_file File.expand_path("_config.yml", config[:source]), "/_config.yml"
```

Making sure to include `source/_config.yml` for GitHub Pages, which seems to be required, even if you're not using Jekyll, which `_config.yml` comes from:

```yaml
include:
- '.well-known'
```
