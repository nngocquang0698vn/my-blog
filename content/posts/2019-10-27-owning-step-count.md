---
title: "Owning My Step Count"
description: "Sharing the journey of starting to own my step counts and my technical solution."
tags:
- www.jvt.me
- steps
- google-fit
- indieweb
- micropub
- microformats
- fitness
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-10-27T22:27:20+0000
slug: "owning-step-count"
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/indieweb
  url: https://indieweb.xyz/en/indieweb
- text: '@JamieTanna on Twitter'
  url: https://twitter.com/jamietanna
- text: Lobsters
  url: https://lobste.rs
---
If you have visited my site since late September, you may have noticed [posts containing my step count data](/kind/steps). Surprisingly, I've not actually blogged about this, although at the request of <span class="h-card"><a class="u-url" href="https://jon.sprig.gs">Jon Spriggs</a></span> I thought I would do.

The project to actually own this data came out of <span class="h-card"><a class="u-url" href="https://annadodson.co.uk">Anna</a></span>'s [step-challenge project](https://github.com/AnnaDodson/step-challenge) that she was doing for work. [Last year at LincolnHack](https://2018.lincolnhack.org/) Anna was also in the middle of a step challenge at work and we were looking at the Google Fit API, which showed me how it seemed quite reasonable to be able to pull this data.

In the spirit of [own your data](https://indieweb.org/own_your_data), as well as get a bit more visibility for myself on how much I walk and maybe even add some accountability for days I don't walk as much, I thought I'd publish this data to my site.

The first thing to note is that since 2017 I've been using Google Fit on my Android devices, so I've got a constant source of data. This is quite key because it made it easy for me to grab it all and ensure it was of the same quality / format.

So how do I go from a step count on Google Fit to data on my website?

The first thing I started do was decide how to mark up the data with [Microformats2](https://microformats.io), because as part of owning my data I wanted to make it machine readable. I settled on the `h-measure` format, and set up the template in my site to allow the content to render the following parsed Microformats2 data:

```json
{
  "type": [
    "h-measure"
  ],
  "properties": {
    "start": [
      "2019-10-23 00:00:00Z"
    ],
    "end": [
      "2019-10-24 00:00:00Z"
    ],
    "num": [
      "5781"
    ],
    "unit": [
      "steps"
    ]
  }
}
```

I decided that because this wasn't any data that someone would want to read in a feed, I would not render it as an `h-entry` that contained an `h-measure`, as well as semantically it not feeling like an entry.

Once I had finalised the format of the data, with the help of looking at some of the historic data via the API, I needed to extend [my Micropub endpoint]({{< ref "2019-08-26-setting-up-micropub" >}}) to support an `h-measure` type, and perform the required validation. This was luckily straightforward due to the way I'd designed the implementation of my Micropub server.

With the support in my Micropub server, I now needed to populate this data. For this, I needed to hook into the [Google Fit API](https://developers.google.com/fit) automagically, daily, which meant I'd need to register an OAuth2 client for the Google Fit APIs.

I then stepped through the OAuth2 code flow manually with my personal account so I could grant consent to my new application, and I could get a long-lived refresh token. I decided that going through this authorization flow was likely a one time thing, so I didn't need to build it into my app as it would be wasted effort (even with Spring's OAuth2 libraries).

With this refresh token, I then started to write my code to integrate with the Google Fit SDK, and as I was writing out the many definitions for JSON request/response payloads, I wondered if anyone had written an SDK for this. This led me to find the [official Fitness Client Library for Java](https://developers.google.com/api-client-library/java/apis/fitness/v1), the biggest benefit of which was that it would handle the refreshing of the refresh token, which I also didn't want to do because I was being lazy!

Now I had the SDK, the authentication to Google Fit, and the ability to pull the data back from the API, I needed to see how to integrate this with my site via Micropub.

This was the first time I'd implemented my own Micropub client, and again I cut corners by not handling IndieAuth automagically, but instead worked on manually going through an OAuth2 authorization flow to get an IndieAuth access token which is hardcoded in the configuration for the deployed app.

With this token, I could then set up a scheduled task in the application to trigger (after midnight UTC), query the Fit API for the previous day's steps, and publish it to my Micropub endpoint with no intervention from me.

However, this did have issues in the beginning while trying to get the timings right, and I ended up setting the scheduled task to trigger at 8am, which gave plenty of time for timezones and anything else to ensure that I'd get the right data. Until I had it working perfectly, I decided that I should have an endpoint that would allow me to trigger the publishing of data manually.

Finally, once this was live, I decided that I should also backdate all my step count data, because there was no point ignoring all the interesting historic data I had. This required a little scripting to loop back through time to hit the API for a given date and construct the file format that my site uses.

I decided I'd do it this way because with three years of data, if I were to add each day automagically via my new API endpoint, it'd introduce 1075 commits to my repo, which I wasn't a fan of!

Building my API was a surprisingly straightforward process to get started with, as the API and the SDK made things much easier, and working with Micropub meant that I had a really nice API for publishing the data.

If you're interested in the code, you can find it inside [<i class="fa fa-gitlab"></i> jamietanna/www-api ](https://gitlab.com/jamietanna/www-api/tree/develop/www-api-web/google-fit).
