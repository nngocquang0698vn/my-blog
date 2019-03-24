---
title: "Automating Promotion of Jekyll Posts from Draft to Post"
description: "The handy script I've created to automate publishing a draft in Jekyll, with handy Zsh + Bash autocomplete."
categories:
- blogumentation
- jekyll
tags:
- blogumentation
- automation
- jekyll
- zsh
- bash
- shell
license_code: GPL-3.0-or-later
license_prose: CC-BY-NC-SA-4.0
date: 2019-01-11T00:00:00
slug: "jekyll-promote"
image: /img/vendor/jekyll-logo-2x.png
---
When I used to use Jekyll, I had a workflow where a post would start as a draft, sitting in the `_drafts` folder, and once it was ready, I would "promote" it to a full-blown post.

This started to get a bit painful, so I automated the process [with a little helper script](https://github.com/jamietanna/dotfiles-arch/blob/master/terminal/home/.jekyll-promote.zsh).

Although this is fairly straightforward, the bit that I was really proud of was being able to use my shell's auto-complete to make this an easier process for me.

For instance:

```sh
$ ls _drafts
test.md  test2.md
$ jekyll_promote <TAB>
# auto-completes the `test`
$ jekyll_promote test<TAB>
completing file
test2.md  test.md
```

You can see the below Asciicast for a more visual example of the flow:

<asciinema-player src="/casts/jekyll-promote.json"></asciinema-player>

Let's assume that we have a function `jekyll_promote` which performs the following:

```sh
jekyll_promote() {
	git mv "_drafts/$1" "_posts/$(date -I)-$1"
}
```

# Zsh

I'm running [Zsh](https://www.zsh.org) as my shell, which has a really straightforward autocomplete syntax which tells it to just autocomplete the files in the `_drafts` directory:

```zsh
compdef '_path_files -W $PWD/_drafts' jekyll_promote
```

# Bash

However, I know that lots of people are not using Zsh but instead use Bash, so I've also created the following autocomplete magic for Bash. This is a little more involved, and adapts [a StackOverflow answer of a similar type](https://askubuntu.com/a/707643):

```bash
# Adapted from https://askubuntu.com/a/707643
_jekyll_promote () {
	local cur
	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	k=0
	drafts_dir="$PWD/_drafts"
	for draft in $( compgen -f "$drafts_dir/$cur" ); do
		[[ -d "$draft" ]] && continue
		COMPREPLY[k++]=${draft#$drafts_dir/} # remove the directory prefix from the array
	done
	return 0
}

complete -o nospace -F _jekyll_promote jekyll_promote
```
