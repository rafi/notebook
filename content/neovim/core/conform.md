---
title: "conform"
description: "Lightweight yet powerful formatter plugin"
published: true
generated: true
kind: "core"
---

Lightweight yet powerful formatter plugin

## Disable

This core plugin always loads. To turn it off, add it to `disabled` in your `rafi.json`. You can then replace it with your own file in `lua/plugins/`.

```json
{ "disabled": ["conform"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>c</kbd><kbd>F</kbd> | Format Injected Langs | 𝐍 𝐗 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>i</kbd><kbd>c</kbd> | Conform Info | 𝐍 |

## Plugins

- [conform.nvim](https://github.com/stevearc/conform.nvim)

<details>
<summary>Source</summary>

```lua title="plugin/conform.lua"
-- Lightweight yet powerful formatter plugin
if require('rafi.config').disabled('conform') then
	return
end

-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/formatting.lua

local format = require('rafi.util.format')
local pack = require('rafi.pack')

-- Autoformat on save and :Format/:FormatInfo, conform loads on first use.
format.setup()
pack.later(format.load)

local function conform_info()
	format.load()
	require('conform.health').show_window()
end

-- Same as conform's own command, which replaces it once sourced.
vim.api.nvim_create_user_command('ConformInfo', conform_info, {
	desc = 'Show information about Conform formatters',
})

vim.keymap.set({ 'n', 'x' }, '<leader>cF', function()
	format.load()
	require('conform').format({ formatters = { 'injected' }, timeout_ms = 3000 })
end, { desc = 'Format Injected Langs' })

vim.keymap.set(
	'n',
	'<leader>cic',
	conform_info,
	{ silent = true, desc = 'Conform Info' }
)
```

</details>
