---
title: "ui.incline"
description: "Floating statuslines"
published: true
generated: true
kind: "extra"
category: "ui"
---

Floating statuslines

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["ui.incline"] }
```

## Plugins

- [incline.nvim](https://github.com/b0o/incline.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/ui/incline.lua"
-- Floating statuslines
local pack = require('rafi.pack')

pack.on_event('FileType', function()
	vim.pack.add({ 'https://github.com/b0o/incline.nvim' })
	require('incline').setup({
		ignore = {
			filetypes = { 'gitcommit' },
		},
	})
end)
```

</details>
