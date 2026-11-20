---
title: "ui.ccc"
description: "Super powerful color picker/colorizer plugin"
published: true
generated: true
kind: "extra"
category: "ui"
---

Super powerful color picker/colorizer plugin

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["ui.ccc"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>Leader</kbd><kbd>m</kbd><kbd>c</kbd> | Color-picker | 𝐍 |

## Plugins

- [ccc.nvim](https://github.com/uga-rosa/ccc.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/ui/ccc.lua"
-- Super powerful color picker/colorizer plugin
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/uga-rosa/ccc.nvim' })
	require('ccc').setup({
		highlighter = {
			auto_enable = true,
			lsp = true,
			filetypes = {
				'html',
				'lua',
				'css',
				'scss',
				'sass',
				'less',
				'stylus',
				'javascript',
				'tmux',
				'typescript',
			},
			excludes = { 'lazy', 'mason', 'help', 'neo-tree' },
		},
	})
	-- Its `ccc-highlighter-auto-enable` FileType autocmd only attaches
	-- buffers opened after `setup()`, so re-fire it for buffers already open.
	pack.refire_filetype('ccc-highlighter-auto-enable')
end

pack.on_event('FileType', load)

-- setup() in load() defines the real command.
pack.command('CccPick', load)

vim.keymap.set('n', '<Leader>mc', function()
	load()
	vim.cmd('CccPick')
end, { desc = 'Color-picker' })
```

</details>
