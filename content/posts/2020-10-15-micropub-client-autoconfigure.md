---
title: "Creating an Auto-configuring Micropub Client"
description: "Announcing support for my Micropub Client configuring itself based on support in my server."
tags:
- www.jvt.me
- micropub
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-10-15T22:19:31+0100
slug: "micropub-client-autoconfigure"
image: /img/vendor/micropub-rocks-icon.png
syndication:
- https://news.indieweb.org/en
- https://indieweb.xyz/en/indieweb
---
[Micropub](https://micropub.spec.indieweb.org/) is an awesome standard, and I've really enjoyed building for it. The best thing about using an open standard is [the abundance of clients](https://indieweb.org/Micropub/Clients).

But one thing that has made it slightly painful to use is where I want to do things which are more me-specific than the general-purpose functionality that most clients implement.

Although I'm hugely appreciative of the community and their work they _rightfully so_ don't support the special workflow I want for my own site. This was partly what led to me [creating my own personal Micropub client]({{< ref 2020-06-28-personal-micropub-client >}}).

Something that particularly interested me in the Micropub community extensions is the ability to [query the server for supported vocabulary](https://github.com/indieweb/micropub-extensions/issues/1). Although most folks had been looking at this as a way to disable certain parts of their rich editor, I've been thinking about it slightly differently.

I'm more interested in making it possible to auto-configure my editor for everything that my Micropub server supports. This means that I no longer need to either add support to existing clients, or update my editor at the same time as I update my Micropub server.

I've now set this up on my editor, which lists the Micropub post types for my staging/production server (in case they're different):

![A screenshot of a listing of all the post types that are supported on Jamie's staging server](https://media.jvt.me/6c71060fe4.png)

And then allows providing the properties for that specific type, such as `photo`:

![A screenshot of the fields possible to be used with a photo post, with an asterisk denoting a required field](https://media.jvt.me/a0e79232a3.png)

I'm really looking forward to using this a little more, and building new post types that are more me-centric.

So now I've got that set up - what's next? Currently, I don't really have a super helpful user experience - you can see they're just plain text boxes.

I'll be adding support for [providing a hint to a client what a property does](https://gitlab.com/jamietanna/www-api/-/issues/270), such as whether it's a date, URL, or can be looked up from the result of a query.

I'll also be making it look a bit nicer - it's currently very much MVP as I'm the only one using it, and I don't exactly mind a poor UX if it's something I'm using.

Another thing to note is that I've only implemented this as a form POST request for now, so some types of post may be more difficult to post.
