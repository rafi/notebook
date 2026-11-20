---
title: "coding.sibling-swap"
description: "Swap sibling treesitter nodes"
published: true
generated: true
kind: "extra"
category: "coding"
---

Swap sibling treesitter nodes

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["coding.sibling-swap"] }
```

## Plugins

- [sibling-swap.nvim](https://github.com/Wansmer/sibling-swap.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/sibling-swap.lua"
-- Swap sibling treesitter nodes
local pack = require('rafi.pack')

-- No setup needed, default keymaps are only created by setup().
pack.later(function()
	vim.pack.add({ 'https://github.com/Wansmer/sibling-swap.nvim' })
end)

vim.keymap.set('n', '<C-.>', function()
	require('sibling-swap').swap_with_right()
end)
vim.keymap.set('n', '<C-,>', function()
	require('sibling-swap').swap_with_left()
end)
```

</details>
