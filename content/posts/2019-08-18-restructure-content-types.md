---
title: "Restructuring The Way That My Site's Content Types Work"
description: "How I've restructured my content to map more closely to Microformats for any Indie content types."
tags:
- www.jvt.me
- indieweb
- microformats
- hugo
- micropub
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-08-18T16:46:21+01:00
slug: "restructure-content-types"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
---
# Why?

[In May I announced that I was extending my website to work with other post types](/mf2/6b919e78-c46a-48e3-8866-9d9e9d41bb3d/), on this [Hugo website](https://gohugo.io/).

When I first set it up, I decided to have a different content type in Hugo per content type, which meant I had folders such as `content/replies` and `content/rsvps`.

This worked for a time, and gave me an easy way to [determine posting stats]({{< ref 2019-07-09-post-visualisation >}}) as I could just loop through the content types, and I would know how to display a reply as it's in `/replies/`.

However, as I've been looking to create a [Micropub endpoint](https://indieweb.org/Micropub) to allow me to more easily publish these content types from my phone / my social reader, I've found that this complicated the logic within my Micropub server. This is because I'd need to take the incoming request, parse the Microformats data from it, and then publish it to my site with the right content type.

I've made this simpler now, as there is only the `mf2` content type to publish to, as I'm not planning to make it possible to publish blog posts like these via Micropub.

This new content type allows me to store in source control the Microformats representation of an entry, which makes it much easier to take the Micropub request and put it into the format my site needs, as well as making it easier to read the source format, too. Prior to the refactor, I would have to open the existing format, and do some mental translations to make it into the expected Microformats representation, which wasn't always the most fun.

I've decided to call this content type `mf2` as it's for anything that has the source format of a Microformats entry. I was originally thinking I'd called it `indieweb` or `indie`, but that doesn't map as well, as I could use it for non-Indie post types.

Unfortunately the approach of having a single content type for Microformats means that I've now got a much harder job rendering the content, as there needs to be logic in there to determine what a post's type is. I feel that this complexity makes more sense to be in the theme and how it renders content, rather than in the Micropub endpoint, but I'm still not 100% sure about it so I may revert this in the future!

# What did I have to do?

To perform this refactor, I needed to first look at what the content should look like for Hugo. To do this, I ran my content through the [microformats-ruby](https://github.com/microformats/microformats-ruby) library to parse out the rendered `h-entry`.

With this, I then added some extra metadata that was required by Hugo, such as the tags and date.

For RSVPs, I had a bit more work, due to [the work I did to create an iCalendar feed for my RSVPs]({{< ref "2019-07-27-rsvp-calendar" >}}), which means that I've got a bit more metadata that I'm storing for each of these events I'm RSVPing to. This required a bit more manual workaround to get it working.

As mentioned above, I had the harder work of adding a lot of logic into my templates to render the content type correctly depending on what the underlying type was. Before I could do it based on which content type it was in (i.e. is it in the `content/likes/` folder?) but now we have to do a bit more work.

The largest piece of work was to sort out the [posting frequency statistics]({{< ref 2019-07-09-post-visualisation >}}), as they needed to change how they worked, as it used to loop through all content types, but now that is impossible due to them being all the same content type. After some time I managed to get around it, and it's now functionally the same as the existing view.

Finally, there was a bit of restructure of the project and how things worked, and getting all the templates being called correctly.

# Testing

As with other large refactors of the site, I've wanted to make sure that I don't break anything, especially permalinks from others' sites to this one.

To check permalinks, I pulled the RSS feed from my live site, extracted all the links, and checked if they resolved with this new site. I found that obviously, no they didn't, as I've restructured the site - good! I wanted this to fail.

Then, I used [Hugo's alias functionality](https://gohugo.io/content-management/urls/#aliases) to match the old URLs and redirect them to the new post. This means that anyone following the links will get redirected - awesome!

I also wanted to make sure that the Microformats representation of the site was still valid, so I didn't break any social readers / parsers who were trying to read the site.

Fortunately, I had a lot of the existing work already done, using [HTMLProofer](https://github.com/gjtorikian/html-proofer), but I needed to rework it to understand what a like looks like compared to a reply, as it could no longer rely on the directory structure.

This testing again saved me, because I found that I'd not correctly set up my new bookmarks template, so that would've broken anyone wanting to read bookmarks, as well as noticing that I'd accidentally added a nested `h-entry` which broke the parsing, too.

That's the whole reason we test things, so it's great to catch it!

I use [Kwalify](http://www.kuwata-lab.com/kwalify/) as a schema validation tool, to make sure that all content for the site is well-formed, checking that i.e. my description has a full stop, and that I have at least one tag on a piece of content. However, as I move to Micropub, I didn't want to duplicate the schema validation across both this site and the Micropub endpoint, so I decided to remove it from my Kwalify checks.

This is largely because I don't want to be writing any of these Indie post types manually, as they should be written through my Micropub endpoint. The longer I leave it the more painful it will be, so the more I'll be forced to _finally write it_. (As an aside, it was mostly written, it just didn't have the right schema to create the files in this repo).

Note to self - try not to do vast refactors of your site!
