---
layout: post
title: Saving Repetition with Git Commit Templates
description:
categories: findings
tags: tools git workflow automation
---
## Creating Your Commit Template

Do you find that you have difficulty remembering what your commits should look like? And how to best ensure that you're following best practices[[1]][beams-commit][[2]][tpope-commit][[3]][jvt-talk]? Do you wish there was a way to make yourself remember how to do it, for instance in the `$EDITOR` you're using to write the commits?

In comes `git config commit.template` and the ability [to specify a template][git-commit-doc] to be used when editing the commit message. This allows you to specify a file which contains the body of the commit message template. For instance, if following [Chris Beams' example][beams-commit], you could have the following text in your template:

```
$ cat ~/.gitmessage
Summarize changes in around 50 characters or less

More detailed explanatory text, if necessary. Wrap it to about 72
characters or so. In some contexts, the first line is treated as the
subject of the commit and the rest of the text as the body. The
blank line separating the summary from the body is critical (unless
you omit the body entirely); various tools like `log`, `shortlog`
and `rebase` can get confused if you run the two together.

Explain the problem that this commit is solving. Focus on why you
are making this change as opposed to how (the code explains that).
Are there side effects or other unintuitive consequences of this
change? Here's the place to explain them.

Further paragraphs come after blank lines.

 - Bullet points are okay, too

 - Typically a hyphen or asterisk is used for the bullet, preceded
   by a single space, with blank lines in between, but conventions
   vary here

If you use an issue tracker, put references to them at the bottom,
like this:

Resolves: #123
See also: #456, #789
```

However, to then get this working, you need to make Git aware of this file, which can be done with either of the following commands:

```bash
# either:
$ git config --global commit.template ~/.gitmessage
# or:
$ cat ~/.gitconfig
[commit]
  template = ~/.gitmessage
```

This means that when you next run `git commit` (note the lack of `-m`, which is recommended against in [_5 Useful Tips For A Better Commit Message_][thoughtbot-commit]) your `$EDITOR` will be filled with the above message. This will then give you the reminder of what to put, and to help you edit it to your heart's content. Additionally, using an editor such as Vim or Emacs will provide automatic syntax highlighting that auto wraps the content to 72 characters, and highlight the summary line when greater than 50 characters.

## Using a Snippet

However, I personally don't like using a big block of text to remind me this, as I'm a bit more used to verbose commits. Instead, what I want is to easily create my commit template and be able to `<TAB>` through it.

I use [UltiSnips][ultisnips] as my snippet engine, which at work, has the following snippet:

```
snippet cmt "Git commit message"
${1:First line of commit}

${2:Multi-line, 72 char}

${3:Issue: #$4}
endsnippet
```

Which is then within my global template file:

```
$ cat ~/.gitmessage
cmt
```

Once hitting `<TAB>` in the file, I can then move around the file quickly, adding a message as follows:

**TODO: Asciinema**



<div class="divider"></div>

[beams-commit]: https://chris.beams.io/posts/git-commit/
[tpope-commit]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[jvt-talk]: https://github.com/jamietanna/gittalk15/releases/tag/v2
[thoughtbot-commit]: https://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message
[ultisnips]: https://github.com/SirVer/ultisnips
[git-commit-doc]: https://git-scm.com/docs/git-commit
