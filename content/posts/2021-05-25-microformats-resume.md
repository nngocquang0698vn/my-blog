---
title: "Marking up my Curriculum Vitae with Microformats2"
description: "Creating a public, metadata-rich Curriculum Vitae / Resume for myself\
  \ at https://hire.jvt.me."
date: "2021-05-25T10:11:26+0100"
syndication:
- "https://news.indieweb.org/en/www.jvt.me/posts/2021/05/25/microformats-resume/"
- https://lobste.rs/s/ygr5sf/marking_up_my_curriculum_vitae_with
- https://news.ycombinator.com/item?id=27274715
tags:
- "microformats"
- "cv"
- "interviewing"
- "hire.jvt.me"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: "/img/vendor/microformats-logo.png"
slug: "microformats-resume"
---
It's been a while since I've updated my CV, and I thought it'd be a good chance to look at my current skillset against what's currently being looked for on the job market.

In the IndieWeb community, we use the [Microformats](https://microformats.io) open standard to provide machine-readable metadata to human-readable content, and I'm a big fan of the improvements it can provide for content.

We've currently got a draft specification called [`h-resume`](https://microformats.org/wiki/h-resume) for marking up your resume/CV, but as it's a draft we're still looking for more implementations to see if there are gaps in the metadata commonly used. We've got a few examples of folks using it on the [Microformats wiki](https://microformats.org/wiki/h-resume#Examples_in_the_Wild) and the [IndieWeb wiki](https://indieweb.org/resum%C3%A9#IndieWeb_Examples), and I wanted to add my own name to the list!

While looking through the examples, I found <span class="h-card"><a class="u-url" href="https://lejenome.tik.tn/">Moez Bouhlel</a></span>'s [resume](https://lejenome.github.io/resume) and I really liked the way it was designed and structured.

Although it's been technically live for the last couple of weeks, as it's been deploying to [hire.jvt.me](https://hire.jvt.me), I'm now sharing it out for wider feedback, and if you don't have a Microformats2 parser handy, you can see the [the parsed data as Microformats2 JSON online](https://php.microformats.io/?url=https://hire.jvt.me).

I've found it to be a pretty fun experience going through my past experiences and thinking about all the stuff I've done over time.

As it's got a print stylesheet, from Moez' original project, it's been fun creating a slightly different output for printed output, by being a little less verbose with my wording, or removing sections altogether, whereas if you view it in a browser, it's got a lot more info.
