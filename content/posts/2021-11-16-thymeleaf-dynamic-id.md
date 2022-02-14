---
title: "Generating Dynamic Identifiers with Thymeleaf"
description: "How to generate a dynamic `id`s for elements in Thymeleaf."
tags:
- blogumentation
- java
- thymeleaf
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2021-11-16T21:54:08+0000
slug: "thymeleaf-dynamic-id"
image: https://media.jvt.me/349bb3ff25.png
---
If you're working with Thymeleaf templating, you may end up with the case where you're iterating through a set of elements, and want to add a dynamic `id` attribute to each one, so you can i.e. interact with them using JavaScript.

Although there are quite a few questions on StackOverflow, it turns out that it's not super well documented how to do this.

In Thymeleaf 3, we can use `ids.seq` for this, as [noted in the documentation](https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#ids):

```html
<ul>
  <li
    th:each="property: ${postType.getProperties()}"
    th:id="${#ids.seq('property')}"
    th:text="${property.getDisplayName()}"
    ></li>
</ul>
```

This then produces the following HTML:

```html
<ul>
  <li id="property1">content</li>
  <li id="property2">Date Published</li>
  <li id="property3">Category / tag</li>
  <li id="property4">Whether the post is `published` or `draft`</li>
  <li id="property5">Syndication URL</li>
</ul>
```
