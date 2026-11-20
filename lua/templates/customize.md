---
title: 'Customize'
description: 'Change options, keymaps and autocmds, and add your own plugins and extras'
published: true
generated: true
---

vim-config loads your own files right after its own, so you can change
anything without editing the config itself. Every file below is optional:
create only the ones you need, in your config directory
(`~/.config/nvim`).

## Your config files

`lua/config/options.lua`, `lua/config/keymaps.lua` and
`lua/config/autocmds.lua` each load right after their Rafi counterpart, so
they can override it. An error in one of them shows a warning instead of
stopping Neovim.

### Options

Options load first, before any plugin.

<!-- config:options -->

### Keymaps

Keymaps load after startup. Delete a default keymap with `vim.keymap.del`,
or map the same keys again.

<!-- config:keymaps -->

### Autocmds

<!-- config:autocmds -->

## Extras and core plugins

`rafi.json` in your config directory lists the extras you enabled and the
core plugins you disabled. `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>)
edits it for you, or you can edit it by hand and restart Neovim:

```json
{
	"extras": ["editor.dial", "lang.go", "ui.deadcolumn"],
	"disabled": ["lualine"]
}
```

A core plugin in `disabled` doesn't load, so you can replace it with your
own file. `snacks` can't be disabled.

## Your plugins

Every `lua/plugins/*.lua` file is plain Lua, sourced after the extras. Add
plugins with `vim.pack.add()` and set them up right there. See the
examples below.

## Your extras

An extra of your own goes in `lua/plugins/extras/<category>/<name>.lua`.
Start it with a comment line describing it: `:RafiExtras` shows that line
and lists your extra next to Rafi's.

## LSP settings

Override a server's settings with `vim.lsp.config()` in one of your
plugin files, or in `after/lsp/<server>.lua`.

## Examples

<!-- examples -->
