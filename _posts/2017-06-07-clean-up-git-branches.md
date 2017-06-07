---
layout: post
title: Clean up your Git branches
description: Remove any merged local or branches from your local Git repository
categories: findings
tags: findings git
---
## Intro

I follow the [Git Flow][gitflow] practice for my branches, both personally and professionally, making heavy use of feature branches. This branch structure means that I will have aptly named feature branches, such as `feature/404-page` or `feature/readme_screenshot`.

However, I've recently found that I'm running into having quite a few branches stored locally, such as:

```bash
$ git branch
article/chef_gitlab
article/commit_templates
article/clean-up-branches
...
defect/font_awesome
defect/gem-lockfile
defect/incorrect_deploy_image
defect/inline-code-readability
...
defect/title
feature/404-page
feature/all_posts_rss
...
feature/talks
feature/tech_enumeration
fix/categories
...
fix/site-cleanup
fix/styled_monospace_link
revert-0f7ef013
revert-dda5c692
```

This means that whenever I'm trying to use my tab completion, I have a load of options to scroll through, which is a less than ideal user experience as it increases the number of characters needed to type before a branch can be autocompleted. To this end, I've recently been looking at how to clean up the number of branches I have.

Each time I've [DuckDuckGo'd][ddg] the commands, the last time of which made me think I should document it somewhere that I can easily browse to in future. And in the light of wanting to [document my findings for everyone to consume][blog-as-documentation], I've rolled it into a blog post.

## Removing Local Checked-Out Branches

Credit to [StackOverflow][so-merge], we can use the following pipeline to delete any merged branches, except the _current_ branch, and the `master` and `develop` branches:

```bash
$ git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d
# ^ list all the branches that have been merged
                      # ^ except from our current branch (`*`)
                      # ^ and `master` and `develop`
                                                        # ^ and then delete them all
```

This can obviously be updated to reflect the branching scheme you use, and whether there are any other branches you don't want to have deleted.

I'd also advise running `git branch --merged` on its own, _before_ running the full command, in order to just check that you're not going to delete something you didn't mean to! This is important, as you won't be able to undo any branch deletions!

## Removing Branches from Remotes

So now that we've deleted all the local branches, we're done, right? Not quite.

Git, being decentralised in nature, downloads the full state of a remote repository, meaning that any branch stored in the remote will also be stored locally. This means, that when you run the following command, you should see roughly the same number of branches, but with `remotes/origin/` prepended:

```bash
$ git branch -a
* article/clean-up-branches
  master
  remotes/origin/HEAD -> origin/master
  remotes/origin/article/openssl_cert_extraction
  remotes/origin/article/verbose-commits
  remotes/origin/feature/newer_docker
  remotes/origin/feature/separate_builder_image
  remotes/origin/feature/space-jekyll-theme
  remotes/origin/feature/update_gems
  remotes/origin/master
```

Luckily this is a bit easier to do, and doesn't require remembering the full pipeline:

```bash
$ git remote prune origin
 * [pruned] origin/article/openssl_cert_extraction
 * [pruned] origin/article/verbose-commits
 * [pruned] origin/feature/separate_builder_image
```

[gitflow]: https://datasift.github.io/gitflow/IntroducingGitFlow.html
[so-merge]: https://stackoverflow.com/a/6127884
[ddg]: https://duckduckgo.com/
[blog-as-documentation]: https://gitlab.com/jamietanna/jvt.me/issues/124
