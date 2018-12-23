---
title: My editorial workflow for blog posts
description: Taking you through the journey I go on when writing blog posts, from ideation to publishing the post.
categories:
- blogumentation
- jvt.me
tags:
- jvt.me
- website
- workflow
- ci
- gitlab
- git
- automation
- cli
- shell
- gitlab-ci
- review-apps
date: 2018-09-12
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
---
I'm a big fan of code review. We practice it heavily at Capital One, and [I strive to self-review personal/private projects][personal-code-review]. But when working on articles that I'm writing for my blog I also want to make sure that I've gone through a similar review process before publishing.

I've developed a flow for how I write the articles, which I find really effective for my use cases.

## Creating an issue on my backlog

Firstly, I like to use my [repo's issue tracker][issues] to track the various article ideas I have. In its most basic form I'll create an issue, such as [this blog post's issue][this-post-issue], with the title being somewhat descriptive i.e. `Article: MRs and blog posts`, and then expand the description if it's not self explanatory.

I often jot down these ideas on-the-go, so don't provide lots of detail, but at a later point I'll look to add enough detail for me to pick up the article next time and then add the `To Do` label.

Using GitLab's issue boards concept, I'll prioritise it on my [articles issue board][articles-issue-board], ranking the order of execution among the list of other topics I'd like to cover.

## Tracking the work

When I've got time to work on article writing, I'll browse to my [articles issue board][articles-issue-board], and move the issue across from `To Do` to `Doing`, which will update the labels and make it clear I'm working on it. I'll also assign myself to make it show up properly in GitLab's tracking that it's now officially being worked on.

## Git Flows

I have two main Git models for writing articles, but regardless of which flow I follow for a given article, I will _always_ raise a MR and review the content before merge - I'll never push straight to `master`, just like I wouldn't on any other project! I don't follow [gitflow], instead preferring a `master`-based Git model to reduce any unnecessary overhead of extra mainline branches.

All post drafts are stored in Jekyll's `_drafts` folder, which ensures that posts that aren't yet ready to build will not be published, ensuring tests won't be run, nor incomplete content accidentally published.

### Trunk-based development

In this model, I commit directly to `master` by updating posts in the `_drafts` folder. This is a great flow for being at i.e. a meetup or conference where I know I won't have the chance to immediately write up the blog posts, but want the notes/draft to be tracked somewhere easy to access, rather than on some long-lived branch.

### Branch-based development

In cases where I know I'll be able to work on the article in a shorter period of time, I'll just create a feature branch off `master`, named appropriately i.e. `article/blog-post-editorial-process`.

In this model, because I have a non-mainline branch, I'm able to rewrite history as-and-when I like, which is great because instead of having multiple `Updating <article name> content` commits, I can then have a single commit for the article content _if I wish_.

## Marking posts as "Ready for Publishing"

Once I've written the draft's content, I'll then need a branch to be created which promotes the draft to being a fully-blown post. As mentioned, this happens regardless of the Git-based flow I follow as I always want to review new content before publishing it.

In Jekyll, this is achieved by moving the file from `_drafts` to `_posts`. With the branch pushed to GitLab, I then raise a Merge Request (MR) on the GitLab UI, tagging the MR with the label `article`.

I've automated the promotion of drafts to posts with a [handy little shell script][jekyll-promote]:

```zsh
jekyll_promote() {
	set -x
	git mv "_drafts/$1" "_posts/$(date -I)-$1"
	set +x
}

compdef '_path_files -W $PWD/_drafts' jekyll_promote
```

This has a little sugar for ZSH (the shell I use) to autocomplete filenames from the `_drafts` folder:

<asciinema-player src="/casts/blog-post-editorial-workflow/jekyll-promote.json"></asciinema-player>

I realise that this one-liner looks rather innocuous, but at first, I wasn't aware of `date -I`, so would be writing:

```diff
-git mv "_drafts/code-is-for-computers.md" "_posts/$(date +%Y-%m-%d)-code-is-for-computers.md"
+git mv "_drafts/code-is-for-computers.md" "_posts/$(date -I)-code-is-for-computers.md"
```

Which was slower to type, and required better memory.

Secondly, this becoming more of an occurrence as I started to blog more, so I wanted to make sure that I was reducing the overhead of writing out the command each time in a reusable fashion.

## Critiquing

Now I've got a MR raised, I'd follow the link in the GitLab UI through to the [GitLab review app][review-apps], i.e. `https://example-review-apps.www.review.jvt.me/`, once the branch has deployed. This is something I've [configured myself][review-apps-caddy] to allow me to spin up each branch on a personal server of mine, allowing me to see my changes in a production-like environment.

With each of the following areas to look at, I can either raise a comment on the MR and then address them locally, or just address them locally. For speed, I address them locally, but for some level of auditability, I feel I should start commenting on MRs again.

Again, if the Git flow matches, I'll address these comments in the form of rebasing and amending commits locally, rather than creating new commits, which again loses some auditability, but is purely personal preference.

### Review App

With the deployed Review App, I check a few things on the content:

- do media such as images and asciicasts load correctly?
- does the layout look alright?
- does the content read OK? Is spelling/grammar OK?
- is the table of contents needed, as in some short articles, it doesn't actually make sense

I'll also perform a couple of full read-throughs to make sure that I'm happy with the flow and wording of the content.

### Merge Request / Code Review

With the Merge Request itself:

- have I specified an `image` if appropriate?
  - i.e. Chef articles should have sharing metadata display the Chef logo
- are there any glaring issues in terms of filenames, paths, etc?

### Automated testing

I also have some tests that run in my pipeline which  include, but are not limited to:

- do all links resolve, or have they broken?
- have I used the correct case for `GitLab` and `GitHub`?
- do images have `alt` tags for accessibility?

## Publishing

Once I'm happy with the content, I'll set GitLab to either merge the Merge Request, or if I've recently pushed changes that haven't yet had GitLab-CI run on them, I'll set it to "merge when pipeline succeeds".

In the case that the pipeline does not succeed I'll get an email, and a browser notification if I'm still on the page, and will be able to go in and fix-forward, squashing commits in where possible.

When it does finally succeed, I'll receive a push notification via PushBullet to say that that site has deployed, allowing me to start on marketing the post(s).

## Post Marketing

Once I've either seen the PushBullet notification or waited long enough for the site to deploy, I'll then look to start promoting the blog post. I've a few channels I like to choose:

- `#blog` channel in the TechNottingham Slack
- sharing via my personal Twitter account
- sharing via my personal LinkedIn account
- the Chef Community Slack, if I feel the post is worth sharing there
- various channels on the internal Capital One Slack

As I run my own analytics using [Matomo (née Piwik)][matomo], I like to obsess over the page hits I receive. I've recently started looking at using UTM codes such as `utm_medium` and marketing campaigns to try and track down exactly where a hit comes in from.

If I manage to publish a post later in the evening, as sometimes I do, I'll leave the promotion of the article on my regular channels until the next day, waiting until we reach UK friendly hours, where it's more likely to get picked up by people I care about.

## Conclusion

As we can see, there are four key components which make this flow work really nicely for me:

### Jekyll's concept of drafts

Without this, there would be no way to work in a trunk-based flow, as I'd never be able to commit an unfinished post. This would therefore mandate branch-based workflow, which can be harder and require more overhead for every post I'm writing, especially where I would have multiple drafts that aren't being actively worked on. As with all branches, the longer they're left unmerged, the harder it'll be to merge them.

### Git branches

Because of Jekyll's concepts of drafts I can now use branches more effectively - I can place new articles on their own branches and work on them in one go, or I can keep drafts in `master` and chip away at them over time.

### GitLab Merge Requests

In my current workflow, I'm using GitLab, but this part of the flow could as easily be done via GitHub, BitBucket, Gogs/Gitea or many of the other SCM hosting providers. I find having a stage to enforce "code review" of the article is great, as it makes sure I have checked it reads well, I've got the right post metadata, and has all the relevant media committed.

### GitLab Review Apps

Although possible in other flows, such as via [Netlify's Branch Previews][netlify-branch-preview], I've found the workflow really great with GitLab's offering. Having a production-like deployment makes it really easy to spot any issues compared to local development, as well as make it easy to verify all the right media has been committed correctly.

&nbsp;

Hopefully this helps share some light on what's working for me and whether there's anything you can adopt yourself. Let me know (via contact details below) if there's anything I can take on board to make my process easier!

[issues]: https://gitlab.com/jamietanna/jvt.me/issues
[personal-code-review]: https://gitlab.com/jamietanna/jvt.me/issues/182
[this-post-issue]: https://gitlab.com/jamietanna/jvt.me/issues/130
[articles-issue-board]: https://gitlab.com/jamietanna/jvt.me/boards/320660
[jekyll-promote]: https://gitlab.com/jamietanna/dotfiles-arch/commit/821acdfcbe70776a6f67db71f0023c3e4402d96d
[review-apps]: https://about.gitlab.com/features/review-apps/
[review-apps-caddy]: {{< ref 2018-04-15-caddy-gitlab-review-apps >}}
[matomo]: https://matomo.org/
[gitflow]: https://github.com/nvie/gitflow
[netlify-branch-preview]: https://www.netlify.com/docs/continuous-deployment/
