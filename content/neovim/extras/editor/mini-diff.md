---
title: "editor.mini-diff"
description: "Git diff signs and hunk overlay (mini.diff)"
published: true
generated: true
kind: "extra"
category: "editor"
---

Git diff signs and hunk overlay (mini.diff)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.mini-diff"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>u</kbd><kbd>G</kbd> | Toggle Mini Diff Signs | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>o</kbd> | Toggle mini.diff overlay | 𝐍 |

## Plugins

- [mini.diff](https://github.com/nvim-mini/mini.diff)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/mini-diff.lua"
-- Git diff signs and hunk overlay (mini.diff)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/mini-diff.lua
local pack = require('rafi.pack')

-- NOTE: Conflict: git.gitsigns also draws signs. Enable only one.
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvim-mini/mini.diff' })
	require('mini.diff').setup({
		view = {
			style = 'sign',
			signs = { add = '▎', change = '▎', delete = '' },
		},
	})
	if _G.Snacks then
		Snacks.toggle({
			name = 'Mini Diff Signs',
			get = function()
				return vim.g.minidiff_disable ~= true
			end,
			set = function(state)
				vim.g.minidiff_disable = not state
				if state then
					require('mini.diff').enable(0)
				else
					require('mini.diff').disable(0)
				end
				-- Redraw to update the signs.
				vim.defer_fn(function()
					vim.cmd([[redraw!]])
				end, 200)
			end,
		}):map('<leader>uG')
	end
end

pack.on_event('BufReadPost,BufNewFile', load)

-- NOTE: Conflict: mini.diff wins over core snacks `<leader>go` (Git Browse).
-- Set on RafiKeymaps because core keymaps load later.
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = function()
		vim.keymap.set('n', '<leader>go', function()
			load()
			require('mini.diff').toggle_overlay(0)
		end, { desc = 'Toggle mini.diff overlay' })
	end,
})
```

</details>
