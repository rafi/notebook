---
title: "coding.mini-splitjoin"
description: "Split and join arguments"
published: true
generated: true
kind: "extra"
category: "coding"
default_enabled: true
---

Split and join arguments

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"coding.mini-splitjoin"` from `extras` in your `rafi.json`.

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>s</kbd><kbd>j</kbd> | Join arguments | 𝐍 𝐗 |
| <kbd>s</kbd><kbd>k</kbd> | Split arguments | 𝐍 𝐗 |

## Plugins

- [mini.splitjoin](https://github.com/nvim-mini/mini.splitjoin)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/mini-splitjoin.lua"
-- Split and join arguments
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvim-mini/mini.splitjoin' })
	require('mini.splitjoin').setup({
		mappings = { toggle = '' },
	})
end

pack.later(load)

vim.keymap.set({ 'n', 'x' }, 'sj', function()
	load()
	MiniSplitjoin.join()
end, { desc = 'Join arguments' })

vim.keymap.set({ 'n', 'x' }, 'sk', function()
	load()
	MiniSplitjoin.split()
end, { desc = 'Split arguments' })
```

</details>
