---
title: "Navigating through the Vim Changelist with Intellij"
description: "How to use `g;` and `g,` using IntelliJ's IdeaVim plugin to cycle through changes in a file."
tags:
- blogumentation
- intellij
- vim
- ideavim
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2020-05-15T23:48:25+0100
slug: "intellij-vim-changelist"
image: https://media.jvt.me/ed986893eb.png
---
I'm a big fan of Vim - you can read about how I got started with it in my post [_Getting Started With Vim_]({{< ref 2019-11-12-getting-started-vim >}}) - but the reasons why are better left to another post.

Although I would prefer to be in Vim for most of the things I do, unfortunately there are a number of places that an IDE wins. While I was writing a lot of Ruby or Chef code, I was able to keep most of the resources and parameters in my head, but now I'm back to more Java code day-to-day, I need to use a full IDE for its autocomplete and intellisense.

The best choice for Java is IntelliJ, which fortunately has the [IdeaVim plugin](https://github.com/JetBrains/ideavim) which makes it possible to use a pretty good Vim-mode.

A couple of years ago while working with core Vim, I discovered [`g;`](https://vimhelp.org/motion.txt.html#g%3B) and [`g,`](https://vimhelp.org/motion.txt.html#g%2C), the two commands that allow you to cycle between the most recent changes in the file.

This has become part of my natural interactions with Vim since learning it, but became quite jarring when using IntelliJ and finding that IdeaVim doesn't support it, as evidenced in [VIM-542](https://youtrack.jetbrains.com/issue/VIM-542), [VIM-939](https://youtrack.jetbrains.com/issue/VIM-939) and [VIM-1237](https://youtrack.jetbrains.com/issue/VIM-1237).

However, thanks to [Han Pei-Ru's comment on the issue _go to last edit location using "g;"_](https://youtrack.jetbrains.com/issue/VIM-542#focus=streamItem-27-2390085.0-0), I finally have an answer!

We can add the following to the IdeaVim configuration file, `~/.ideavimrc`:

```vim
nnoremap g; :action JumpToLastChange<Enter>
nnoremap g, :action JumpToNextChange<Enter>
```

And now, after years of just not looking into it, I can go back to a pleasant experience of being able to navigate more easily between changes in my files.
