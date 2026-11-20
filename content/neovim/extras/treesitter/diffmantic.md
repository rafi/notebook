---
title: "treesitter.diffmantic"
description: "Semantic diff using Treesitter"
published: true
generated: true
kind: "extra"
category: "treesitter"
---

Semantic diff using Treesitter

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["treesitter.diffmantic"] }
```

## Plugins

- [diffmantic.nvim](https://github.com/HarshK97/diffmantic.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/treesitter/diffmantic.lua"
-- Semantic diff using Treesitter
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/HarshK97/diffmantic.nvim' })
	-- Setup only refreshes highlights on ColorScheme.
	require('diffmantic').setup({})
end)
```

</details>
