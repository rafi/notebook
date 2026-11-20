---
title: "editor.undotree"
description: "Visualize the undo history tree"
published: true
generated: true
kind: "extra"
category: "editor"
---

Visualize the undo history tree

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.undotree"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>g</kbd><kbd>u</kbd> | Undo Tree | 𝐍 |

## Plugins

- [undotree](https://github.com/mbbill/undotree)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/undotree.lua"
-- Visualize the undo history tree
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/mbbill/undotree' })
end)

vim.keymap.set(
	'n',
	'<leader>gu',
	'<cmd>UndotreeToggle<CR>',
	{ desc = 'Undo Tree' }
)
```

</details>
