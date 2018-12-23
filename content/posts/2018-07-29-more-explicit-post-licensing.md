---
title: Being More Explicit on Content Licensing
description: Why I'm re-licensing the code snippets and post content on my site is, and how I'm making it more obvious.
categories:
- thoughts
tags:
- thoughts
- site
- licensing
date: 2018-07-29
---
I was recently writing some code at work and remembered that I'd solved the issue before and had written a under [blogumentation][blogumentation] post about it. As I was about to copy-paste in the solution, I stopped myself, remembering that the site was explicitly licensed as GNU Affero General Public License V3. I share my blog with colleagues, and realised that they too were under the same risk. Therefore, I've decided a few changes:

## Make Code Snippets More Liberally Licensed

Although I'm a huge fan of Copyleft, in the case of supporting code snippets in articles, I'd prefer to be able to share my blog with colleagues. Therefore I'm conceding to relicense all code snippets (unless explicitly licensed otherwise) as Apache 2.0 for the ability to include it within commercial projects.

## License Post Content "Correctly"

Licensing the prose within my posts as AGPL3, which is a code license, doesn't quite work. Instead, I need to move to a content license - I've chosen the Creative Commons Attribution Non Commercial Share Alike 4.0 International license which allows me to have my articles shared, but remove the ability for others to make money off them, as well as ensuring, if modified, content is shared under the same license. This feels more Copyleft-y than the other licenses, with the exclusion of the "Non Commercial" because that restricts freedom. That being said, I would be happy to discuss Commercial usages of my articles if anyone is interested.

## Retain Copyleft Licensing on the Site Design + Code

I still wanted to have maximum Copyleft licensing for both the site design (based on design by the MIT licensed [Daktilo](https://github.com/kronik3r/daktilo) theme) and the supporting modifications and plugins I've written since, so they're still licensed as the AGPL3. The AGPL3 allows me to ensure that changes are contributed back to me, retaining the end-user freedoms.

## Allow Per-Post Licensing Overriding

There may be some posts that I want to license even more liberally (such as allowing commercial usage) or less liberally (such as enforcing the code be copyleft). This means I needed to configure my Jekyll setup to allow me to specify the licenses in the post, rather than on a site-wide specification.

## Making Licensing More Obvious to the Reader

I'm calling out the licensing in two places; at-a-glance in the post header, and more detailed in the footer. This makes it easier for a reader to know up front whether they'll be able to use any content/code in the post privately, instead of having to read all the way to the bottom of the page to understand licensing.

[blogumentation]: /posts/categories/blogumentation
