---
title: "Adding a Merge Request Checklist for new Articles"
description: "Adding a checklist for articles in my GitLab Merge Requests."
tags:
- workflow
- www.jvt.me
- gitlab
- nablopomo
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2019-11-17T22:10:57+0000
slug: "article-checklist"
image: /img/vendor/gitlab-wordmark.png
---
Since this site existed, it's been managed through [GitLab.com](https://gitlab.com/).

When I raise a Merge Request with a new article, I generally go through a mental checklist. But these have never never formalised, and as such, I can forget things.

So today I've added a [Merge Request template](https://docs.gitlab.com/ee/user/project/description_templates.html) to formalise these questions when I raise a new Merge Request:

- [ ] I have added appropriate `tags` to the article
  - [ ] I have tagged `nablopomo` / `blogumentation` appropriately
- [ ] I have update the article's commit date with the publish date
- [ ] I have checked the post for spelling and grammar
- [ ] I have added an appropriate post `image` to the metadata
- [ ] I have verified that any relevant issues are closed / referenced
- [ ] I have verified that this Merge Request is labelled appropriately

This will make it easier to pick up on issues with the changes ahead-of-time and help track new things in the checklist in the future.
