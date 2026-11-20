---
title: "lsp.gtd"
description: "LSP's go-to definition or file, with findup/walk fallbacks (nvim-gtd)"
published: true
generated: true
kind: "extra"
category: "lsp"
---

LSP's go-to definition or file, with findup/walk fallbacks (nvim-gtd)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lsp.gtd"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>g</kbd><kbd>f</kbd> | Go to definition or file | 𝐍 |

## Plugins

- [nvim-gtd](https://github.com/hrsh7th/nvim-gtd)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lsp/gtd.lua"
-- LSP's go-to definition or file, with findup/walk fallbacks (nvim-gtd)
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/hrsh7th/nvim-gtd' })
	require('gtd').setup({
		sources = {
			{ name = 'findup' },
			{
				name = 'walk',
				root_markers = {
					'.git',
					'.neoconf.json',
					'Makefile',
					'package.json',
					'tsconfig.json',
				},
				ignore_patterns = { '/node_modules', '/.git' },
			},
			{ name = 'lsp_definition' },
		},
	})
end

pack.on_event('BufReadPre,BufNewFile', load)

-- NOTE: Conflict: lsp.gtd wins over native `gf` when enabled.
vim.keymap.set('n', 'gf', function()
	load()
	require('gtd').exec({ command = 'split' })
end, { desc = 'Go to definition or file' })
```

</details>
