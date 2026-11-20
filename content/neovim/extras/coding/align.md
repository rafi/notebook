---
title: "coding.align"
description: "Align text interactively"
published: true
generated: true
kind: "extra"
category: "coding"
---

Align text interactively

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["coding.align"] }
```

## Plugins

- [mini.align](https://github.com/nvim-mini/mini.align)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/align.lua"
-- Align text interactively
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/nvim-mini/mini.align' })
	require('mini.align').setup({
		mappings = {
			start = 'gb',
			start_with_preview = 'gB',
		},
	})
end)
```

</details>
