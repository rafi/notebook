---
title: "ui.mini-map"
description: "Window with buffer text overview, scrollbar and highlights"
published: true
generated: true
kind: "extra"
category: "ui"
---

Window with buffer text overview, scrollbar and highlights

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["ui.mini-map"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>Leader</kbd><kbd>m</kbd><kbd>n</kbd> | Mini map | 𝐍 |

## Plugins

- [mini.map](https://github.com/nvim-mini/mini.map)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/ui/mini-map.lua"
-- Window with buffer text overview, scrollbar and highlights
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvim-mini/mini.map' })
	require('mini.map').setup({
		-- See: `:h MiniMap.gen_integration`
		-- If enabled, increase (or remove) width setting.
		-- integrations = {
		-- 	minimap.gen_integration.diagnostic(),
		-- 	minimap.gen_integration.builtin_search(),
		-- 	minimap.gen_integration.gitsigns(),
		-- },
		symbols = {
			scroll_line = '⎕', -- '⎕', '█', '🮚', '▶'
			scroll_view = '┊', -- '⎮', '╎', '┋', '┊'
		},
		window = {
			show_integration_count = false,
			width = 1,
			winblend = 40,
		},
	})
	MiniMap.open()
end

pack.on_event('BufReadPost,BufNewFile', load)

-- The first press only loads, since loading opens the map.
vim.keymap.set('n', '<Leader>mn', function()
	if not loaded then
		return load()
	end
	MiniMap.toggle()
end, { desc = 'Mini map' })
```

</details>
