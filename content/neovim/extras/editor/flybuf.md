---
title: "editor.flybuf"
description: "List buffers in a float window (flybuf.nvim)"
published: true
generated: true
kind: "extra"
category: "editor"
---

List buffers in a float window (flybuf.nvim)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.flybuf"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>s</kbd><kbd>f</kbd> | Flybuf | 𝐍 |

## Plugins

- [flybuf.nvim](https://github.com/nvimdev/flybuf.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/flybuf.lua"
-- List buffers in a float window (flybuf.nvim)
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvimdev/flybuf.nvim' })
	require('flybuf').setup({})
end

pack.later(load)

vim.keymap.set('n', 'sf', function()
	load()
	require('flybuf').toggle()
end, { desc = 'Flybuf' })
```

</details>
