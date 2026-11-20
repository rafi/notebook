---
title: "coding.ts-comments"
description: "Enhance Neovim's native comments with treesitter context"
published: true
generated: true
kind: "extra"
category: "coding"
default_enabled: true
---

Enhance Neovim's native comments with treesitter context

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"coding.ts-comments"` from `extras` in your `rafi.json`.

## Plugins

- [ts-comments.nvim](https://github.com/folke/ts-comments.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/ts-comments.lua"
-- Enhance Neovim's native comments with treesitter context
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/folke/ts-comments.nvim' })
	require('ts-comments').setup({})
end)
```

</details>
