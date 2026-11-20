---
title: "editor.mini-move"
description: "Move lines and selections with Alt-h/j/k/l"
published: true
generated: true
kind: "extra"
category: "editor"
---

Move lines and selections with Alt-h/j/k/l

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.mini-move"] }
```

## Plugins

- [mini.move](https://github.com/nvim-mini/mini.move)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/mini-move.lua"
-- Move lines and selections with Alt-h/j/k/l
local pack = require('rafi.pack')

local function setup()
	vim.pack.add({ 'https://github.com/nvim-mini/mini.move' })
	require('mini.move').setup({})
end

pack.later(setup)

-- NOTE: Conflict: mini.move wins over core `<A-j>`/`<A-k>` when enabled.
-- Re-applied after core keymaps load. Insert-mode maps stay core.
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = setup,
})
```

</details>
