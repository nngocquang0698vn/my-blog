---
title: "Making Hugo Generate Case Sensitive URLs"
description: "How to make your Hugo URLs case sensitive."
tags:
- blogumentation
- nablopomo
- hugo
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-10T16:14:28+0000
slug: "hugo-case-sensitive-urls"
series: nablopomo-2019
image: /img/vendor/hugo-logo.png
---
A few weeks ago I changed the permalink structure for my Indie post types, changing URLs such as `/mf2/00276d65-8767-40fe-bb37-59fc075a4942/` to `/mf2/2019/08/SMfBV/` to make them more citable, as well as make it nicer to read and i.e. see what year + month the content was from.

The last portion of the URLs I was randomly generating were short case-sensitive, alphanumeric strings which had no meaning other than being a unique URL. But on [Monday I noticed that the URLs were not being treated with case sensitivity](https://gitlab.com/jamietanna/www-api/issues/66).

This was not ideal as it was meaning that I was effectively losing some of the randomness in URLs, and would increase the risk of conflicts in filenames.

I was going to [amend my Micropub endpoint to generate lowercase slugs](https://gitlab.com/jamietanna/www-api/issues/66), but I've now found that it's a [straightforward configuration change in Hugo](https://discourse.gohugo.io/t/disable-hugo-case-sensitive-url-matching/2498) to make this work natively in Hugo.

To make this change, we need to amend our `config.toml` and set the `disablePathToLower` flag to ensure that it will render the URLs for the built site in the case that they were generated:

```toml
# i.e. another top-level parameter, for reference, not required
title = "Jamie Tanna | Software (Quality) Engineer"

disablePathToLower = true
```

And that's it!

To make this work with my site I've also updated all URLs on existing /mf2/ content to redirect the lowercase URLs to the original ones, so any permalinks will remain valid.

**NOTE**: This unfortunately did _not_ work well, as [Netlify has decided to only serve files from lowercase paths](https://community.netlify.com/t/my-url-paths-are-forced-into-lowercase/1659/2), which is not very clear. I'll be having to treat all paths as lowercase, and redirect them from uppercase, so it will effectively mean I have lost the randomness afforded by using case-sensitive strings - not cool!

This was tested with Hugo version `v0.58.3/extended`.
