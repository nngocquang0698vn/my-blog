---
title: "Replacing Text in Vim with the Output of a Command"
description: "How to replace text under the cursor with the output of a command."
tags:
- blogumentation
- vim
- command-line
license_code: Apache-2.0
license_prose: CC-BY-NC-SA-4.0
date: 2022-02-01T14:42:56+0000
slug: vim-replace-with-command-execution
image: https://media.jvt.me/efa7085abe.jpeg
---
Let's say that we've got a buffer in Vim, and we want to replace some of the text with the output of a command.

For instance, we may have found a JSON Web Token (JWT), like the below:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

If we have a handy executable called `jwt`, we'd be able to select the text, then execute the following command:

```
'<,'>!jwt
```

Which can also be seen in the following Asciicast:

<asciinema-player src="/casts/vim-replace-with-command-execution.json"></asciinema-player>
