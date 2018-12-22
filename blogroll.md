---
layout: page
title: Blogroll
---
If you like some of my blog posts, I'd recommend reading some of the following blogs, which I read regularly:

<ul>
  {% for blog in site.data.blogroll.data %}
  <li>
    <a href="{{ blog.url }}">{{ blog.url }}</a>
  </li>
  {% endfor %}
</ul>

I'll update this page as-and-when I find new content that I like to read and want to share. I may also look at creating a curated RSS feed for the above blogs for easier consumption.
