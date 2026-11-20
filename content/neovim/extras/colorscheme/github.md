---
title: "colorscheme.github"
description: "Github's Neovim themes"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Github's Neovim themes

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.github"] }
```

## Plugins

- [github-nvim-theme](https://github.com/projekt0n/github-nvim-theme)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/github.lua"
-- Github's Neovim themes

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/projekt0n/github-nvim-theme' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'github_*',
	once = true,
	callback = function()
		require('github-theme').setup({})
	end,
})
```

</details>
