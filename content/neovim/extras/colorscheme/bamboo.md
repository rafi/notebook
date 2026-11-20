---
title: "colorscheme.bamboo"
description: "Warm green theme"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Warm green theme

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.bamboo"] }
```

## Plugins

- [bamboo.nvim](https://github.com/ribru17/bamboo.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/bamboo.lua"
-- Warm green theme

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/ribru17/bamboo.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'bamboo*',
	once = true,
	callback = function()
		require('bamboo').setup({})
	end,
})
```

</details>
