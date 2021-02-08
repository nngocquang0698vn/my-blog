---
title: "Investigating Solutions for Private/Friends-Only Posts on a Static Website"
description: "Discussing the options available for posts that require authentication while using a static site, using my own personal requirements."
tags:
- www.jvt.me
- indieweb
- indieauth
- micropub
- www-private.jvt.me
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-08-26T22:08:28+0100
slug: "static-site-private-posts"
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
---
For some time now, I've been wanting to support private content on my website. That is to say, I've wanted to post things that only I can read, or post things that only nominated friends are allowed to read.

This is primarily for additions to my week notes for things that I don't necessarily want everyone to be able to read, or for personal thoughts I want to capture but don't want anyone else to see.

However, the biggest issue here is how to do it? The whole point of my static website is that the content is _static_, and generally publicly accessible.

# Requirements

Before we dig into the options, I want to cover my requirements for the solution I would feel comfortable with:

- I want to continue allowing my site to be a public Git repo, which means any private post data must be stored in the plain
- I want to be able to create posts that only I can read (private post)
- I want to be able to create posts that I can allow certain friends to read (friends-only post)
- I want to be able to create private remarks without necessarily creating a post
- I want to manage the access to the private contents using IndieAuth

A nice-to-have would be allowing someone to read content from within their Indie reader, but I've decided to not pursue this at this time.

# Options

## Basic Password Authentication

One solution is to use something like [.htpasswd](https://en.wikipedia.org/wiki/.htpasswd) to protect the posts. This is a great, known solution with lots of options, but unfortunately:

- means I have to manage passwords, for potentially very many people
- means I need some way to manage this within Netlify's build process
- this isn't managed by IndieAuth

## Netlify Identity

Netlify has this managed a little better through their [Identity offering](https://docs.netlify.com/visitor-access/identity/), which has different authentication providers. But this ties my service into using Netlify, which although true for now, won't necessarily be forever, and also leads to increased cost (as it's not a cheap offering for the likely limited use I'll get out of it).

## Perform Client-Side Decryption

A solution we could go for is to use the browser to decode the encrypted content, but that would mean running the whole process - encryption, decryption, and authentication flow. This isn't ideal, and I'd prefer to keep things server-side where possible.

## Intercept At Edge

A recommendation from <span class="h-card"><a class="u-url" href="https://tonyburns.net">Tony Burns</a></span> could be to use something like [CloudFlare Workers](https://workers.cloudflare.com/) to intercept requests to your site, performing rewrites / decryption in-place, or my suggestion for this would probably be [Lambda@Edge](https://aws.amazon.com/lambda/edge/).

This allows for some server-side processing, although it would require moving my CDN from Netlify, which I'm not really wanting to do quite yet without other benefits.

## Custom Built Service

Alternatively, I could look at a way to separate out this to a separate service. This doesn't necessarily keep this as a static site, but it does allow me to continue using my existing Git repo as a backend, which is the goal.

As it'll be custom built, I can manage it how I want, and build it for the exact requirements I want!

I could do this purely with Netlify functions, but I've decided to follow suit from my other projects, and build a custom Java service for it.

# Solution

I'm planning to go with a custom-built service, `www-private.jvt.me` which will handle the authorization checks for posts, and the encryption/decryption of the post.

I've got a few Key design decisions I've made for how this will work:

- the content will be stored in a [JWE](https://tools.ietf.org/html/rfc7516), issued and encrypted by `www-private`, and wrapped in a signed JOSE object which contains the following claims:
  - a boolean `audience_in_post` which will be `true` for posts, but `false` for arbitrary content
  - a list of `audience`s, which are a list of profile URLs, if `audience_in_post == true`
- the encrypted content for a post will not maintain any information about the profile URLs that are allowed to read it - as it is within my site's Git repo, I'm happy with the security profile of my site's access and also, because I want to have it visible in the site's content so profile URLs can be rendered to the reader
- my profile URL is implicitly allowed for any `audience` verification
- access to posts will be via a single-use authorization code, which is tied to the post / content that is being viewed

## Posts

Both friends-only posts and private posts will be built as unlisted posts by default. Although they will be present in my site, and its Git repo, they will not appear in feeds.

If the post is a friends-only post, a (public) Webmention will inform one of the intended recipients that they have been mentioned in a post.

Once opening the unlisted post, i.e. `/mf2/2020/08/private/`, there will be a link to i.e. `https://www-private.jvt.me/post?url=/mf2/2020/08/private/`, and a mention of the users who are allowed to access the post.

When following through the link to `www-private`, the service will perform a `q=source` on the post URL against my Micropub server, to retrieve:

- the post's `audience`s, which are a list of profile URLs
- the encrypted content

The user will be prompted to authenticate with IndieAuth, after which the (single use) authorization code will be used to determine the profile URL for the user. If that URL matches the post's intended `audience`, the post's content will be decrypted and presented to the user.

## Arbitrary content

As mentioned, I'd quite like to be able to augment other posts with private content. These will be slightly different because access settings won't be embedded in the post, as the post may not be aware of the private content.

For instance, within the blog post `/posts/2020/08/26/some-post/` there will be a link, hidden by CSS, to i.e. `https://www-private.jvt.me/content?content=eyJ...`.

When following through the link to `www-private`, the service will inspect the outer JWS and will determine the `audience` claim for profile URLs to allow.

The user will be prompted to authenticate with IndieAuth, after which the (single use) authorization code will be used to determine the profile URL for the user. If that URL matches the post's intended `audience`, the post's content will be decrypted and presented to the user.

## Publishing

Now, I need some way of publishing this content, right? `www-private` will become a Micropub client, and my Micropub server will understand only enough to pass through the contents of the encrypted content, and the `audience`:

```
 h=encrypted
&audience[]=https://someone.url/path/
&encrypted-content=eyJ...
```

# Feedback

What do you think? Is there something I've missed as an option, or haven't considered while looking at this?

Or am I trying to do too much to retain a static site, and should just embrace a dynamic site?
