---
title: "editor.dial"
description: "Increment and decrement numbers, dates, and more"
published: true
generated: true
kind: "extra"
category: "editor"
default_enabled: true
---

Increment and decrement numbers, dates, and more

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"editor.dial"` from `extras` in your `rafi.json`.

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>C-a</kbd> | Increment | 𝐍 𝐕 |
| <kbd>C-x</kbd> | Decrement | 𝐍 𝐕 |
| <kbd>g</kbd><kbd>C-a</kbd> | Increment | 𝐍 𝐗 |
| <kbd>g</kbd><kbd>C-x</kbd> | Decrement | 𝐍 𝐗 |

## Plugins

- [dial.nvim](https://github.com/monaqa/dial.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/dial.lua"
-- Increment and decrement numbers, dates, and more
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/dial.lua
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/monaqa/dial.nvim' })
	require('rafi.util.dial').setup()
end)

-- Fall back to native keys if pressed before 'later' has run.
local function dial(increment, g)
	return function()
		if not package.loaded['dial.config'] then
			return (g and 'g' or '') .. (increment and '<C-a>' or '<C-x>')
		end
		return require('rafi.util.dial').dial(increment, g)
	end
end

-- stylua: ignore start
vim.keymap.set({ 'n', 'v' }, '<C-a>', dial(true), { expr = true, desc = 'Increment' })
vim.keymap.set({ 'n', 'v' }, '<C-x>', dial(false), { expr = true, desc = 'Decrement' })
vim.keymap.set({ 'n', 'x' }, 'g<C-a>', dial(true, true), { expr = true, desc = 'Increment' })
vim.keymap.set({ 'n', 'x' }, 'g<C-x>', dial(false, true), { expr = true, desc = 'Decrement' })
-- stylua: ignore end
```

</details>
