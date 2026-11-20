---
title: "editor.namu"
description: "Flexible symbol navigation (LSP, treesitter, ctags, diagnostics)"
published: true
generated: true
kind: "extra"
category: "editor"
default_enabled: true
---

Flexible symbol navigation (LSP, treesitter, ctags, diagnostics)

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"editor.namu"` from `extras` in your `rafi.json`.

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>s</kbd><kbd>e</kbd> | Namu symbols | 𝐍 |
| <kbd>leader</kbd><kbd>s</kbd><kbd>E</kbd> | Namu workspace symbols | 𝐍 |
| <kbd>leader</kbd><kbd>o</kbd> | Namu sidebar | 𝐍 |

## Plugins

- [namu.nvim](https://github.com/bassamsdata/namu.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/namu.lua"
-- Flexible symbol navigation (LSP, treesitter, ctags, diagnostics)
-- Setup eagerly requires several modules, so it runs on first use.
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true

	vim.pack.add({ 'https://github.com/bassamsdata/namu.nvim' })
	require('namu').setup({
		namu_symbols = {
			enable = true,
			---@type NamuConfig
			options = {
				movement = {
					next = { '<C-n>', '<C-j>', '<DOWN>' },
					previous = { '<C-p>', '<C-k>', '<UP>' },
				},
			},
		},
	})
end

require('rafi.pack').command('Namu', load, {
	nargs = '+',
	desc = 'Namu plugin command with subcommands',
	complete = true,
})

-- stylua: ignore start
vim.keymap.set('n', '<leader>se', '<cmd>Namu symbols<CR>', { desc = 'Namu symbols' })
vim.keymap.set('n', '<leader>sE', '<cmd>Namu workspace<CR>', { desc = 'Namu workspace symbols' })
-- NOTE: Conflict: editor.outline maps <leader>o too.
vim.keymap.set('n', '<leader>o', '<cmd>Namu sidebar symbols<CR>', { desc = 'Namu sidebar' })
-- stylua: ignore end
```

</details>
