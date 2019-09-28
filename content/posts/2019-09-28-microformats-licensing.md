---
title: "Proposing a Microformats2 Markup for Licensing Information"
description: "Some recommendations for how to mark up licensing information with Microformats, for making license information machine-discoverable and machine-readable."
tags:
- microformats
- licensing
- indieweb
- indiewebcamp-amsterdam-2019
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-09-28T23:46:41+0200
slug: "microformats-licensing"
image: /img/vendor/microformats-logo.png
syndication:
- text: IndieNews
  url: https://news.indieweb.org/en
- text: /en/microformats
  url: https://indieweb.xyz/en/microformats
---
# Context

At [IndieWebCamp Amsterdam](https://indieweb.org/2019/Amsterdam), I facilitated a session about _Licensing and Owenrnship_.

One of the key conversations I wanted to have was around how we mark up licenses for our sites. This is not just to make it more obvious to an [Indie reader](https://indieweb.org/reader) what the license for a post is, but also to make it easier to comply with licenses when providing quotes for posts, or [reply-contexts](https://indieweb.org/reply-context), and a little about education on licenses.

I'm a fan of talking about software licenses, although I am not a lawyer and guarantee that I likely do not know enough to be completely legally watertight. However, it's something really interesting and fundamental for community longevity and learning.

My main angle for the session was a look back to [my post in 2018, _Being More Explicit on Content Licensing_]({{< ref "2018-07-29-more-explicit-post-licensing" >}}) in which I announced my decision to split my posts' licensing between code snippets in the post and the written prose that made up the post's content. This allowed me to use the right license for my written content, which did not make much sense being licensed with a license that was written for code.

I mentioned in today's session about how the current licensing markup, such as [`rel=license`](http://microformats.org/wiki/rel-license) were insufficient for multi-license content, as it relates to the page as a whole, not allowing for scoping certain areas for license information.

I've been considering this for [over six months now](https://gitlab.com/jamietanna/jvt.me/issues/412) but after chatting through it today I thought I'd publish my thoughts.

Another reason that I wanted to talk about this was around the risks that not considering licensing can cause, such as if you're rendering a reply-context and the quote you're using isn't abiding by the license of the post (although as <span class="h-card"><a class="u-url" href="https://zylstra.org/blog">Ton</a></span> mentioned, this may come under "fair use"). These subtleties could be fine for now, but risk legal issues if we're not careful and add some consideration about it up front.

This is especially a risk where there is no explicit license, which in lots of jurisdictions means that the license is All Rights Reserved, and the copyright is retained by the creator.

# Proposed Solution

With some of the comments from the session in mind, I want to officially propose my thoughts for what we could use to mark up content.

I was hoping that I'd be able to get some examples already available on this site, but we'll have to do with code snippets for now, as I've thought of a couple of options for how this could be marked up.

Note that as well as being able to license the whole post, I also want to consider using i.e. External images which may be licensed differently.

For the options below, I recommend utilising the Software Package Data Exchange (SPDX) identifier, which is a standardised identifier for all licenses.

I haven't yet thought about what the _parsed_ Microformats would look like, either, as that may be quite difficult on i.e. a per-element basis.

## `h-license`

For one option, I recommend that we create a new `h-license` container, which can then contain more information about the license, if we so wish to have, but at the least provide the SPDX ID.

### Adding a license for everything in a post

If all the content can be licensed under a single license, adding the `h-license` as a child element of the `h-entry` as below could be used:

```html
<article class="h-entry">
  <p class="p-content">This is the post's content</p>
  <aside class="h-license">
    <p>This post is licensed under a
      <a class="u-url" href="http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode">
        <data class="p-name" value="CC-BY-NC-SA-4">Creative Commons Attribution Non
          Commercial Share Alike 4.0 International</span> license
      </a>.
    </p>
  </aside>
</article>
```

Notice that the `p-name` is using the `<data>` tag to allow us to provide a friendlier identifier for human readers.

### Scoping a license to written content

Now, let's say that we want to license written content in a specific way, we could utilise the `role` tag for a given `h-license`:

```html
<article class="h-entry">
  <p class="p-content">This is the post's content</p>
  <aside class="h-license" role="prose">
    <p>This post's written content is licensed under a
      <a class="u-url" href="http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode">
        <data class="p-name" value="CC-BY-NC-SA-4">Creative Commons Attribution Non Commercial Share Alike 4.0 International</span> license
      </a>.
    </p>
  </aside>
</article>
```

### Licensing only code snippets

If we want to license written code in a specific way, we could utilise the `role` tag for a given `h-license`:

```html
<article class="h-entry">
  <code>print("hello")</code>
  <aside class="h-license" role="code">
    <p>This post's code is licensed under the
      <a class="u-url" href="https://www.apache.org/licenses/LICENSE-2.0">
        <data class="p-name" value="Apache-2.0">Apache License 2.0</span>
      </a>.
    </p>
  </aside>
</article>
```

### Licensing only media

If we want to license media in a specific way, we could utilise the `role` tag for a given `h-license`:

```html
<article class="h-entry">
  <code>print("hello")</code>
  <aside class="h-license" role="media">
    <p>This post's media is licensed under the
      <a class="u-url" href="http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode">
        <data class="p-name" value="CC-BY-NC-SA-4">Creative Commons Attribution Non Commercial Share Alike 4.0 International</span> license
      </a>.
    </p>
  </aside>
</article>
```

### Licensing multiple types of content

If you had the following entry which contained a mix of content, such as:

```html
<article class="h-entry">
  <div class="e-content">
    <p>This is the post's content</p>

    <pre>
    require 'JSON'
    puts JSON.parse('{"a": 1}');
    </pre>
  </div>
</article>
```

We could do this with multiple `h-license`s, each with a different `role`:


```html
<article class="h-entry">
  <div class="e-content">
    <p>This is the post's content</p>

    <pre>
    require 'JSON'
    puts JSON.parse('{"a": 1}');
    </pre>
    <aside class="h-license" role="prose">
      <p>This post's written content is licensed under a
        <a class="u-url" href="http://creativecommons.org/licenses/by-nc-sa/4.0/legalcode">
          <data class="p-name" value="CC-BY-NC-SA-4">Creative Commons Attribution Non Commercial Share Alike 4.0 International</span> license
        </a>.
      </p>
    </aside>
    <aside class="h-license" role="code">
      <p>This post's code is licensed under the
        <a class="u-url" href="https://www.apache.org/licenses/LICENSE-2.0">
          <data class="p-name" value="Apache-2.0">Apache License 2.0</span>
        </a>.
      </p>
    </aside>
  </div>
</article>
```


### Licensing only a specific element

If we wanted to license only the image in the below post:

```html
<article class="h-entry">
  <div class="e-content">
    <p>This is the post's content</p>

    <img src="https://example.com/url.jpg" alt="External image that is licensed" />
  </div>
</article>
```

We'd have a bit of a hard time, because there's no way to create a child element in the `<img />`. This may require a bit more thinking.


## `data-license=`

Alternatively we can create arbitrary `data-` tags for licensing information, which means we can attach it to existing elements, as well as making it possible to add other information such as attribution links, but this may not be as-Microformats-y.

### Adding a license for everything in a post

In this case, we have the whole post's content set as a specific license, we can mark up as:

```html
<article class="h-entry" data-license="CC-BY-NC-SA-4">
  <p class="p-content">This is the post's content</p>
</article>
```

### Scoping a license to written content

If we wanted to license just the written content in an entry, we could use `data-license-prose`:

```html
<article class="h-entry" data-license-prose="CC-BY-NC-SA-4">
  <p class="p-content">This is the post's content</p>
</article>
```

### Licensing only code snippets

If we wanted to license just the code snippets in an entry, we could use `data-license-code`:

```html
<article class="h-entry" data-license-code="Apache-2.0">
  <p class="p-content">This is the post's content</p>
</article>
```

### Licensing only media

If we wanted to license just the code snippets in an entry, we could use `data-license-media`:

```html
<article class="h-entry" data-license-media="CC-BY-NC-SA-4">
  <video ... />
</article>
```

### Licensing multiple types of content

If you had the following entry which contained a mix of content, you could use multiple `data-license-`s:

```html
<article class="h-entry" data-license-prose="CC-BY-NC-SA-4" data-license-code="Apache-2.0">
  <div class="e-content">
    <p>This is the post's content</p>

    <pre>
    require 'JSON'
    puts JSON.parse('{"a": 1}');
    </pre>
  </div>
</article>
```

### Licensing only a specific element

If you had the following, which contains some regular content that you're able to license yourself, but then are using an differently licensed i.e. image:

```html
<article class="h-entry">
  <div class="e-content">
    <p>This is the post's content</p>

    <img src="https://example.com/url.jpg" alt="External image that is licensed" />
  </div>
</article>
```

You could do something like:

```html
<article class="h-entry">
  <div class="e-content" data-license="CC-BY-NC-SA-4">
    <p>This is the post's content</p>

    <img src="https://example.com/url.jpg" alt="External image that is licensed"
      data-license="CC-BY-SA-4"
      data-license-attribution="https://example.com/" />
  </div>
</article>
```

# Feedback

I am looking for lots of feedback on this, so please reply via my contact details in my footer, or by sending a Webmention reply with your response.
