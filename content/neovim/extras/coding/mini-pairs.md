---
title: "coding.mini-pairs"
description: "Auto pairs"
published: true
generated: true
kind: "extra"
category: "coding"
default_enabled: true
---

Auto pairs

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"coding.mini-pairs"` from `extras` in your `rafi.json`.

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>u</kbd><kbd>p</kbd> | Toggle Mini Pairs | 𝐍 |

## Plugins

- [mini.pairs](https://github.com/nvim-mini/mini.pairs)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/mini-pairs.lua"
-- Auto pairs
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/coding.lua
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/nvim-mini/mini.pairs' })
	require('rafi.util.mini').pairs({
		modes = { insert = true, command = true, terminal = false },
		-- skip autopair when next character is one of these
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		-- skip autopair when the cursor is inside these treesitter nodes
		skip_ts = { 'string' },
		-- skip autopair when next character is a closing pair and there are
		-- more closing pairs than opening ones
		skip_unbalanced = true,
		-- better deal with markdown code blocks
		markdown = true,
	})
end)
```

</details>
