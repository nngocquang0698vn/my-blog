---
title: "Explaining Networking and Packet Switching with LEGO and the Postal Service"
description: "A recap of how I've explained the concept of packet switching through the use of LEGO and the postal service."
tags:
- networking
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-06-17T19:51:54+01:00
slug: "explain-networking-lego"
---
A couple of months ago I spoke at an internal event called Tech School, which is all about teaching not-as-technical folks about tech.

My session was about the physical infrastructure we have, such as data centres and the millions of wires, which fed in from the group's earlier sessions on Software and Hardware.

One section of the talk was about networking infrastructure and how computers actually talk to each other via a packet-switching network.

I came up with a pretty good example or how to explain this better, and as I was quite chuffed with it I thought I'd share it, especially after <a href="https://twitter.com/rothgar/status/1140362663597346816" class="u-in-reply-to">Justin Garrison's tweet</a>.

But that's enough preamble - how did I actually go about explaining it?

<div class="divider">&#42;&#42;&#42;</div>

Imagine you have just bought a really cool LEGO set, and you want to show your friend it in person. A video call won't cut it, it has to be in person. But she lives half way across the world, and can't really make the journey just for that. So how do we show it to her?

It's a big set, and you can't really just shove it in a parcel as-is because it'd break in transit and, worse, you'd probably pay a huge amount of shipping costs.

Instead, what you can do is break down the set into smaller groups (packets) so that instead of sending one big parcel of data, there are many (hundreds, or thousands even!) smaller ones. These packets of LEGO pieces fit in an envelope, which is cheap to send.

You write your friend's name and address on it, and then drop it into to your nearest postbox. A few hours later, the post is collected, and maybe taken to a facility. Sorting through the addresses, the facility puts it in a post van and ships it off to the next facility, a bit closer to your friend. This repeats until it ends up at your friend's house - awesome!

Notice that at no point does any of the postal staff need to know anything about the contents of the envelopes - all they need to know is that they need to deliver it to a given address.

Now your friend has received all the envelopes, and can re-assemble the set... Or can they? You could tell her that the pieces will be arriving in a certain order and that she needs to reassemble the set in the order they arrive. Unfortunately that won't work because you have no guarantee that the envelope will get there in the right order (and sometimes even may never arrive at all).

So what you can do instead is add a number in each of the envelopes, and then your friend can reassemble the set when the right envelopes come through.

<div class="divider">&#42;&#42;&#42;</div>

The group found it to be a good explanation, but if you've got any feedback, let me know!
