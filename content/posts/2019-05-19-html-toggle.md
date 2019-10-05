---
title: "Using `<details>` tags for HTML-only UI toggles"
description: "How using the `<details>` HTML tag can provide a toggleable UI element with only built-in HTML."
tags:
- blogumentation
- html
- www.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-05-19T10:04:38+0100
slug: "html-toggle"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/html
  url: https://indieweb.xyz/en/html
- text: 'Lobsters'
  url: https://lobste.rs
---
If you usually reach for JavaScript when trying to create show/hide toggle on elements, this post is for you.

This post is a reply to <a class="u-in-reply-to" href="https://twitter.com/jakevdp/status/992434838706638848">the tweet by Jake VanderPlas</a>:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Github tip: you can use &lt;detail&gt;&lt;/detail&gt; tags in <a href="https://twitter.com/github?ref_src=twsrc%5Etfw">@github</a> markdown to add collabsible/expandable content: <a href="https://t.co/Pco0KRx2De">pic.twitter.com/Pco0KRx2De</a></p>&mdash; Jake VanderPlas (@jakevdp) <a href="https://twitter.com/jakevdp/status/992434838706638848?ref_src=twsrc%5Etfw">May 4, 2018</a></blockquote>

As the comments in the tweet mention,  this is actually built into the HTML5.1 spec, not something that was specific to GitHub.

The other plus for this is that I would assume it's more accessible to users as it's built into the Browser / User Agent, so it'd be supported by accessibility tools.

But how do you actually use it? Let's say that we have a large list that only needs to be shown when necessary i.e a table of contents. All we need to do is wrap it in a `<details>` element:

```html
<details>
  <ul>
    <li>Lorem ipsum dolor sit amet, consectetur adipisicing elit</li>
    <li>sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</li>
    <li>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat</li>
    <li>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum </li>
    <li>dolore eu fugiat nulla pariatur</li>
  </ul>
</details>
```

Which then renders as:

<details>
  <ul>
    <li>Lorem ipsum dolor sit amet, consectetur adipisicing elit</li>
    <li>sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</li>
    <li>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat</li>
    <li>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum </li>
    <li>dolore eu fugiat nulla pariatur</li>
  </ul>
</details>

However, we may want to specify a title rather than the one that the browser decides for us, so we can add the `<summary` element inside our `<details`>:

```html
<details>
  <summary>lorem ipsum</summary>
  <ul>
    <li>Lorem ipsum dolor sit amet, consectetur adipisicing elit</li>
    <li>sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</li>
    <li>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat</li>
    <li>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum </li>
    <li>dolore eu fugiat nulla pariatur</li>
  </ul>
</details>
```

Which renders as:

<details>
  <summary>lorem ipsum</summary>
  <ul>
    <li>Lorem ipsum dolor sit amet, consectetur adipisicing elit</li>
    <li>sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</li>
    <li>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat</li>
    <li>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum </li>
    <li>dolore eu fugiat nulla pariatur</li>
  </ul>
</details>

You can read more on [the Mozilla Developer Network article _&lt;details&gt;: The Details disclosure element_](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details)

To commemorate this finding, I'm now over-using these toggles all over my website! This makes table of contents nicer, as well as the metadata about the post.
