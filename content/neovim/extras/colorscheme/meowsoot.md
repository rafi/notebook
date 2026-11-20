---
title: "colorscheme.meowsoot"
description: "Pink-cyan-lavender colorscheme, where green never reaches code"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Pink-cyan-lavender colorscheme, where green never reaches code

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.meowsoot"] }
```

## Plugins

- [meowsoot.nvim](https://github.com/marekh19/meowsoot.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/meowsoot.lua"
-- Pink-cyan-lavender colorscheme, where green never reaches code

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/marekh19/meowsoot.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'meowsoot*',
	once = true,
	callback = function()
		require('meowsoot').setup({
			style = 'night', -- 'night' (dark) | 'dawn' (light)
			transparent = false,
		})
	end,
})
```

</details>
