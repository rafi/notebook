---
title: "colorscheme.tokyonight"
description: "Clean, dark Neovim theme"
published: true
generated: true
kind: "extra"
category: "colorscheme"
default_enabled: true
---

Clean, dark Neovim theme

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"colorscheme.tokyonight"` from `extras` in your `rafi.json`.

## Plugins

- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/tokyonight.lua"
-- Clean, dark Neovim theme

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/folke/tokyonight.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'tokyonight*',
	once = true,
	callback = function()
		require('tokyonight').setup({ style = 'moon' })
	end,
})
```

</details>
