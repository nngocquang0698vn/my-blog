---
title: "Running a command on a visual selection in Vim"
description: "How to pipe the text in a visual selection to a command, either to run it, or to replace the text in the seletion."
tags:
- blogumentation
- vim
- neovim
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-03-03T09:35:45+0000
slug: vim-command-visual-selection
image: https://media.jvt.me/efa7085abe.jpeg
syndication:
- "https://brid.gy/publish/twitter"
---
As noted in [Replacing Text in Vim with the Output of a Command](/posts/2022/02/01/vim-replace-with-command-execution/), it can be handy to pipe a bit of text into another command.

For instance, we may have found a JSON Web Token (JWT), like the below:

```json
{
  "client_assertion": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
}
```

If we have a handy executable called `jwt`, we'd want to create a visual selection inside the quotes around the JWT, and then:

# Running

If you just want to just run the command, leaving the JWT in the buffer untouched, you can do the following:

```vim
y:echo system('jwt', @")
```

For example:

<asciinema-player src="/casts/vim-command-visual-selection/running.json"></asciinema-player>

# Replacing

If you just want to replace the JWT with the unpacked header and payload (if a JWS), you can do the following:

```vim
c<C-R>=system('jwt', @")<CR><ESC>
```

For example:

<asciinema-player src="/casts/vim-command-visual-selection/replacing.json"></asciinema-player>

You may want to toggle `:set paste` before and after, so the text doesn't get autoformatted by Vim when being inserted.
