---
title: "Determining missing translation keys from gettext `.po` files"
description: "Creating a Go command to check for missing translation keys across gettext `.po` files."
date: 2023-02-01T09:40:19+0000
tags:
- "blogumentation"
- "go"
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
slug: missing-translations
---
If you're working with applications that require translations, you may be using [gettext's `.po` format](https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html) to store your translations.

One issue I've found with this is that sometimes it can be hard to quickly audit whether there are any missing translations, especially in larger applications.

In December I'd put together a tool to check for this, but hadn't ended up pushing it anywhere and adding an associated blog post, so here it is!

Say we have `en.po`:

```
msgid "error"
msgstr "Something went wrong"

msgid "success"
msgstr "Operation failed successfully"
```

And `es.po`:

```
msgid "error"
msgstr "¡algo salió mal!"
```

In this example, we can clearly see that the `success` key is missing from `es.po`.

By following [the instructions to install `missing-translations`](https://gitlab.com/tanna.dev/missing-translations), we can then run:

```sh
missing-translations -po '*.po'
```

At which point we'll be told:

```
Key `success` does not have a translation in every locale, missing: [es.po]
```
