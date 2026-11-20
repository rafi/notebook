---
title: "editor.inc-rename"
description: "Incremental LSP renaming based on Neovim's command-preview feature"
published: true
generated: true
kind: "extra"
category: "editor"
---

Incremental LSP renaming based on Neovim's command-preview feature

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.inc-rename"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>c</kbd><kbd>r</kbd> | Rename (inc-rename.nvim) _(with any LSP)_ | 𝐍 |

## Plugins

- [inc-rename.nvim](https://github.com/smjonas/inc-rename.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/inc-rename.lua"
-- Incremental LSP renaming based on Neovim's command-preview feature
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/inc-rename.lua
local pack = require('rafi.pack')

pack.command('IncRename', function()
	vim.pack.add({ 'https://github.com/smjonas/inc-rename.nvim' })
	require('inc_rename').setup({})
end, { nargs = 1 })

-- Replaces `<leader>cr` on LSP buffers. Starts the command line with the
-- word under the cursor.
require('rafi.util.lang').add({
	keys = {
		['*'] = {
			{
				'<leader>cr',
				function()
					return ':IncRename ' .. vim.fn.expand('<cword>')
				end,
				expr = true,
				desc = 'Rename (inc-rename.nvim)',
				has = 'rename',
			},
		},
	},
})
```

</details>
