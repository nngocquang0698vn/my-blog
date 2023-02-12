---
title: Follow This Blog
aliases:
- /feeds
---
This page is inspired by <span class="h-card"><a class="u-url" href="https://marcus.io">Marcus Herrmann</a></span>'s post [Making RSS more visible again with a /feeds page](https://marcus.io/blog/making-rss-more-visible-again-with-slash-feeds), and <span class="h-card"><a class="u-url" href="https://boffosocko.com/">Chris Aldrich</a></span>'s [further thoughts on it](https://boffosocko.com/2020/05/31/making-rss-more-visible-again-with-a-feeds-page-marcus-herrmann/).

It's meant to be a single place to find out how to follow along with my blog, or any of the other content on the site.

# RSS

Each set of content has its own RSS feed, which is the most common feed format.

- To subscribe to my primary feed, which includes all posts from the front page https://www.jvt.me/feed.xml
- To subscribe to my articles https://www.jvt.me/kind/articles/feed.xml
- To subscribe to a specific tag, such as any IndieWeb-related content https://www.jvt.me/tags/indieweb/feed.xml
- To subscribe to literally everything on this site, https://www.jvt.me/all/feed.xml

# Microformats2

Within the [IndieWeb](https://indieweb.org) we have an open standard, built upon HTML, called [Microformats2](https://microformats.io).

If you have a supported [IndieWeb compatible reader](https://indieweb.org/reader) you can follow the blog by pointing it to the URL of a page, such as:

- To subscribe to my primary feed, which includes all posts from the front page https://www.jvt.me/
- To subscribe to my articles https://www.jvt.me/kind/articles/
- To subscribe to a specific tag, such as any IndieWeb-related content https://www.jvt.me/tags/indieweb/
- To subscribe to literally everything on this site, https://www.jvt.me/all/

# On the Fediverse

If you're on the Fediverse, such as Mastodon, you can follow me by searching for `@www.jvt.me@www.jvt.me` or by initiating a remote follow:

<form method="post" action="https://fed.brid.gy/remote-follow">
 <label for="follow-address">🐘 Follow
  <kbd>@www.jvt.me@www.jvt.me</kbd>:<br />
  enter your @-@ fediverse address:</label>
 <input id="follow-address" name="address" type="text" required="required"
        placeholder="@you@instance.social" alt="fediverse address" value="" />
 <input name="domain" type="hidden" value="www.jvt.me" />
 <button type="submit">Follow</button>
</form>
