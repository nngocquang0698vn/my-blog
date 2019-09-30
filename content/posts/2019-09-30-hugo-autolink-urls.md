---
title: "Auto-linking URLs with Hugo"
description: "How to get URLs automagically converted to links in Hugo, using Regular Expressions."
tags:
- hugo
- www.jvt.me
- blogumentation
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-30T18:07:42+0200
slug: "hugo-autolink-urls"
---
[In May](/mf2/6b919e78-c46a-48e3-8866-9d9e9d41bb3d/), I decided that I would start to publish more content types on my site, such as short notes (similar to tweets) as well as bookmarks and replies.

This was fairly straightforward, but one issue I had with this was that my content was purely plaintext, which meant that if I were to include a URL in a post's body, it would not be converted to a clickable HTML link.

This was fine for a little bit, as I've been not doing too much with it, but over the last month or so I've been starting to publish a lot more on my site using my [Micropub server]({{< ref "2019-08-26-setting-up-micropub" >}}).

To make it possible to convert these to links for better user experience, both for automated parsing of the posts and humans viewing the posts, I needed to delve into some dark magic and use a regular expression (slight sarcasm!).

I managed to adapt [a JavaScript version of the regex](https://stackoverflow.com/a/29747837/2257038) to work with [Hugo's Regular Expressions functionality](https://gohugo.io/functions/replacere/), which led me to the following:

```go-html-template
{{ replaceRE "(https?://[a-zA-Z0-9\\-._~:/?#\\[\\]@!\\$&'()*\\+,;%=]+)" "<a href=\"$1\">$1</a>" .Content | safeHTML }}
```

Notice that we need to make sure that Hugo allows the HTML we've just injected, so add on a pipe to [`safeHTML`], otherwise it'll render the tags as text not HTML.

And that's it, you now have auto-linking URLs! You can see it in action in [my message to Aaron Parecki](/mf2/4d07b8b6-4f9c-4003-b3e3-00390c42ea86/).
