---
title: "coding.mini-trailspace"
description: "Trailing whitespace highlight and remove"
published: true
generated: true
kind: "extra"
category: "coding"
default_enabled: true
---

Trailing whitespace highlight and remove

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"coding.mini-trailspace"` from `extras` in your `rafi.json`.

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>c</kbd><kbd>w</kbd> | Erase Whitespace | 𝐍 |

## Plugins

- [mini.trailspace](https://github.com/nvim-mini/mini.trailspace)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/mini-trailspace.lua"
-- Trailing whitespace highlight and remove
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvim-mini/mini.trailspace' })
	require('mini.trailspace').setup({})
end

pack.on_event('BufReadPost,BufNewFile', load)

vim.keymap.set('n', '<leader>cw', function()
	load()
	MiniTrailspace.trim()
end, { desc = 'Erase Whitespace' })
```

</details>
