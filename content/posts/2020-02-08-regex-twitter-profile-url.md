---
title: "How to Extract a Twitter Profile URL (But Not Status URL) with a Regex"
description: "A regular expression to match Twitter Profile URLs, but not Status URLs."
tags:
- blogumentation
- twitter
- regex
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-02-08T12:24:24+0000
slug: "regex-twitter-profile-url"
---
I've [fairly recently](https://gitlab.com/jamietanna/jvt.me/-/merge_requests/658) added support within my site to replace URLs to Twitter profiles with @-username, so when the note was syndicated to Twitter it would be correct. However, because this is within the site's theme it depends completely on what is being used to render my site. This is less than ideal, and means if I were to move themes in the future, it would need to be reimplemented.

On Thursday, I noticed that the regex I'd been using hadn't quite worked:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/WiTNotts?src=hash&amp;ref_src=twsrc%5Etfw">#WiTNotts</a> is kicking off with the wonderful <a href="https://twitter.com/anna_hax?ref_src=twsrc%5Etfw">@anna_hax</a> and <a href="https://t.co/0gfGqPg3Q4">https://twitter.com/CarolSaysThings</a> (<a href="https://t.co/OuhIIDsBjO">https://t.co/OuhIIDsBjO</a>) <a href="https://t.co/erJejo6Un3">pic.twitter.com/erJejo6Un3</a></p>&mdash; Jamie Tanna | www.jvt.me (@JamieTanna) <a href="https://twitter.com/JamieTanna/status/1225494506558164992?ref_src=twsrc%5Etfw">February 6, 2020</a></blockquote>

In this case the URL hadn't been caught as it didn't handle the URL being at the end of line, and with the two of these reasons in mind, I sought to rewrite it.

My goal was to match only the profile URLs i.e. `https://twitter.com/JamieTanna`, not status URLs such as `https://twitter.com/JamieTanna/status/1225494506558164992`.

The Regex I've come up with is:

```
(https:\/\/twitter.com\/(?![a-zA-Z0-9_]+\/)([a-zA-Z0-9_]+))
```

In my case, I've implemented this with a negative lookahead, which allows me to ignore the whole match if it ends with a `/`, as that would indicate it's a status URL.

You can see it in action at [regexr.com/4tsfr](https://regexr.com/4tsfr).
