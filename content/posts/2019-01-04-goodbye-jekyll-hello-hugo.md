---
title: "Goodbye Jekyll, Hello Hugo!"
description: My move from Jekyll to super speedy Hugo, and what I've needed to do to migrate.
categories:
- announcement
tags:
- jekyll
- hugo
- jvt.me
date: 2019-01-04T00:00:00
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
---
Those who will know me or know my site will know I'm a huge fan of Jekyll. I've been using it since this site began in this form in December 2015, and it's been a very trusty tool in the ease of publishing content to the Web.

However, I've had a few friends in the Tech community as well as colleagues at work who have been on to me about trying out Hugo and seeing what it's like.

I've been partly hesitant about starting on the investigation because I have enough stuff to do without a complete overhaul of the site, its theme, and structure. But as Christmas came around, I was at my parents' looking for something light on the brain but useful to play around with, and [after creating `blogroll.jvt.me` as my first microservice component for this site]({{< ref 2018-12-23-microservices-static-site >}}) with Hugo, I was in the mood to play around with Hugo on this site.

I set about changing the directory structures and getting the site building, and after seeing it took ~1 second to build my 88 posts + various pages, I was like "wait what? It can't be _that_ fast". My Jekyll-based site took ~15 seconds to build (in incremental mode), so I was thinking maybe it was due to the various things I'm doing in the theme that was slowing me down.

I started to use the [tale-hugo theme][tale-hugo], but as it still wasn't doing the same things I had been doing in my theme, such as generating page metadata, adding licensing information etc, I needed to tweak it more intensively. Once I had updated the theme to [work for my own means], I was surprised to see that it was still ~1 second to build.

With this intense speed, and major batteries-includedness that Hugo provides (such as the automagic taxonomy generation, reading JSON files from a remote URL and integration with Git) I decided to stick with the migration plan and moved to having it up and running.

What have I had to do to completely overhaul the site though?

- Remove Jekyll-specific post front matter
- Add default front matter (such as licenses) to posts
  - In [_Being More Explicit on Content Licensing_][explicit-licensing] I noted that I'd add default for posts, which was done in Jekyll. This wouldn't translate over to Hugo so I needed to update each post that inherited the site's default, and set it explicitly in the front matter.
  - I also needed to pull the `date` and `slug` from a post, so permalinks would look the same as the existing site.
- Update directory structure in line with Hugo
- Split the theme from the content, as previously the content and theme were in the same repo, for speed
  - This is something I've wanted to do for a while, but found it was a pain, so didn't!
  - This will also make it easier to upstream changes, as the theme and content in the site are now largely independent, especially licensing wise
- Pull the Blogroll from `blogroll.jvt.me` at build time
  - Very easy using `getJSON`, which Hugo provides as standard
- Full-width code snippets, which is something I chose my previous Jekyll theme for
- Re-indent my headers for the table of contents
  - These were previously starting at `<h2>` instead of `<h1>` as a personal choice, which was proved wrong!
- Re-work my build + deploy pipeline
  - This needed to be updated to build a Hugo image
  - The built site was published into the `public` folder, not `_site` as common with Jekyll
  - Create a new `test` Docker image for running post-build verification, which was previously the same image as the `builder`. However, as we're now building with Hugo, there's no need for any Ruby dependencies in the `builder` image.
  - Remove any Jekyll + Node.JS dependencies, as I don't need either to build or minify the site

What's great?

- Build time
  - I've gone from ~7 mins on average for a branch with Jekyll to ~5 mins for Hugo - quite a nice saving
- Docker image size
  - My builder has gone from ~450MB on Jekyll + Gulp to ~45MB fro Hugo - much quicker and eaiser, as well as meaning there's less that needs version bumping and maintaining
- Content types + ease of use
- Something new to play around with

What's not so great?

- `hugo import` didn't seem to quite pull out everything as I wanted it
- Trying to ensure that no permalinks back to the site were broken was quite a difficult one, as it required me to think carefully around keeping the same filenames, but then store the `date` and `slug` in the front matter to then be built correctly to the same URLs.
- Not realising that the version of Hugo I had locally (via Arch Linux's official package) was different to the version in i.e. the example Docker image for GitLab Pages. I spent a good couple of evenings banging my head against a wall, trying to work out why I could build locally, but not via Docker in the pipeline, or locally!

Notes:

- Design changes distributed in [my fork of the tale-hugo][fork] theme are licensed under the MIT, as per the theme's defaults, and I will not be changing anything around this
  - This will also make it easier for me to upstream changes I've made, as they then won't have issues around the licenses that have been used in the fork and vice versa
- Any other content in the repo for [jvt.me] will continue to be licensed under the GNU Affero General Public License Version 3, to ensure that anyone using it as a base will be required to distribute their changes, for the good of the community.
- I wrote some scripts to verify that the built site matched the existing post permalinks, as well as to tweak the required front matter

It's been a fun journey, and I'm really loving it!

[explicit-licensing]: {{< ref "2018-07-29-more-explicit-post-licensing.md" >}}
[tale-hugo]: https://github.com/EmielH/tale-hugo
[jvt.me]: https://gitlab.com/jamietanna/jvt.me
[fork]: https://gitlab.com/jamietanna/tale-hugo-jvt.me
