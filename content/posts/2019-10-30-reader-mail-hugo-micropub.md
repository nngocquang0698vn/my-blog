---
title: "Reader Mail: Getting Started with Hugo and Micropub"
description: "Answering a question by a reader about how to get started with writing a Micropub endpoint for use with Hugo."
tags:
- www.jvt.me
- micropub
- hugo
- reader-mail
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-30T21:12:17+0000
slug: "reader-mail-hugo-micropub"
---
I received an email yesterday from <span class="h-card"><a class="u-url" href="https://www.barbersmith.com">Ben Barbersmith</a></span>, and with Ben's consent thought I would reply publicly.

The email in question:

> Hi Jamie,

> I've read a ton of your blog posts and hope you don't mind me emailing you!

> First up, thanks a ton for your posts about IndieWeb. I was completely unaware of this movement until I saw some of your blog posts on lobste.rs, but it seems really cool.

> I've recently migrated my own site to Hugo ([www.barbersmith.com](https://www.barbersmith.com)), and your posts about the micropub API caught my attention. I'd sorely love to be able to add to my hugo site from a decent mobile client, and micropub seems like the correct solution. You mentioned you had solved the problem already, but I guess the code is very specific to your setup.

> Any hints or tips for how I might set up a similar solution? I'm familiar with writing and deploying backend services, just wondering if there are any gotchas or words of wisdom you have specifically about implementing the micropub server API, using it to generate hugo files, trigger the site build or auto commit to git.

> If you do have any code to share, no matter how scrappy, I'd be grateful!

> Thanks in advance for any time or advice you can provide.

> All the best, Ben

A great email, I appreciate you getting in touch and am more than happy to chat more about my work.

> If you do have any code to share, no matter how scrappy, I'd be grateful!

Firstly, it turns out that I had not updated my [blog post announcing my Micropub support]({{< ref "2019-08-26-setting-up-micropub" >}}) to share the underlying source code - woops! That is now addressed.

My code can be found at [<i class="fa fa-gitlab"></i> jamietanna/www-api](https://gitlab.com/jamietanna/www-api/tree/master/www-api-web/micropub) and is available as Free Software, under the [GNU Affero General Public License v3](https://www.gnu.org/licenses/agpl-3.0.en.html) so please do use it, but remember to abide by the license terms.

> specific to your setup

It's true that a lot of this will be specific to the way that I create content, and that my content is made up, but there should be at least some ideas for what to implement yourself.

> Any hints or tips for how I might set up a similar solution?

Firstly, I would ask how the site's content is stored? Is it stored in a git repo and put into GitLab.com, GitHub.com, or some other source control offering? Or is it not tracked anywhere?

Once you know how it's stored, that'll determine what your underlying endpoint will need to work with.

From what I understand [nanopub](https://indieweb.org/nanopub) will publish to disk, which means that if you're not using source control it's a better fit.

If you are, you'll need to do some work to make it handle the authentication with their API, and programmatically creating content on your site from the API.

> any gotchas or words of wisdom you have specifically about implementing the micropub server API

My daily driver for Micropub interactions is [Indigenous for Android](https://github.com/swentel/indigenous-android), but I also publish content using [MicroPublish.net](https://micropublish.net) and [Quill](https://quill.p3k.io) as well as implementing my own client for my [step counts](/kind/steps/).

I found that being a well-formed [OAuth2 Resource Server](https://www.oauth.com/oauth2-servers/the-resource-server/) can be a bit of work, and then also being a well-formed IndieAuth Resource Server, too.

I found that one thing that tripped me up initially was that I didn't support both `x-www-form-urlencoded` and `multipart/form-data` content types.

> using it to generate hugo files

For this, I settled on my own JSON structure for a request, which was mapped very closely to the underlying Microformats2 data that the post would contain, with some extra properties for Hugo.

For instance, this is a like:

```json
{
  "kind" : "likes",
  "slug" : "2019/10/3NnXz",
  "client_id" : "https://micropublish.net",
  "date" : "2019-10-25T19:03:02.264+02:00",
  "h" : "h-entry",
  "properties" : {
    "name" : [ "Like of https://www.reddit.com/r/Eyebleach/comments/dmvrkl/smile_for_the_camera/" ],
    "like-of" : [ "https://www.reddit.com/r/Eyebleach/comments/dmvrkl/smile_for_the_camera/" ],
    "published" : [ "2019-10-25T19:03:02.264+02:00" ]
  }
}
```

I made it a JSON format because then it would be super easy to publish via an API, instead of having to create a mix of YAML/TOML and Markdown.

> trigger the site build

For this, because my site is using GitLab CI as its means to build/test/deploy the site, I didn't need to do anything special to get the site building. As soon as the commit arrived on `master`, it would start the process to build + deploy it.

> auto commit to git.

For this, I wanted to go API first and interact with GitLab.com's API (as I use GitLab.com for my repo hosting) rather than actually `git commit`ing locally, so I would recommend similar.

In terms of other recommendations:

- Read [the spec for Micropub](https://www.w3.org/TR/micropub/) and see if things make sense, if they don't, then [come and chat with the IndieWeb community](https://indieweb.org/discuss)
- I would recommend having a "stub" server set up that will allow you to test your Micropub endpoint with a Micropub client, without publishing content, as it'll make it easier to verify things work without testing in production (but it may also be OK if you don't mind)!
- Don't worry about implementing all the features, I've only got create functionality via forms, not via JSON, nor things like read/update/delete as I don't have a need yet for all the functionality
- Also, don't feel like you need to implement a media endpoint for now, as you may not be publishing anything media-wise!
