---
title: 'Automagically formatting on save, with Neovim and Language Server Protocol (LSP)'
description: "How to use Neovim's Language Server Protocol (LSP) support to autoformat code on a file's save."
tags:
- blogumentation
- neovim
date: 2022-03-01T09:45:45+0000
license_prose: CC-BY-NC-SA-4.0
license_code: Apache-2.0
slug: neovim-format-on-save
image: https://media.jvt.me/e80aa374d6.png
syndication:
- "https://brid.gy/publish/twitter"
---
Moving to Neovim, one of the really key benefits of the move was the native Language Server Protocol (LSP) support.

After being quite used to the way that I could get [my Java projects to autoformat on build](/posts/2020/05/15/gradle-spotless/), I did, however, want a little more from Neovim's configuration.

The Neovim docs actually highlight this:

```vim
autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
" or
autocmd BufWritePre * lua vim.lsp.buf.format()
```

Or if you're using the Lua configuration:

```lua
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
-- or
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
```

Or if you want to write Lua, but haven't yet fully migrated to a Lua-only configuration, you'll want the following:

```vim
lua <<EOF
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
EOF
```

Then, every time you save your file(s), they'll attempt to format using the registered LSP, and if none exist, it'll be a no-op.
