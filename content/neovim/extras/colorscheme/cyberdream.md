---
title: "colorscheme.cyberdream"
description: "High-contrast, futuristic & vibrant colorscheme"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

High-contrast, futuristic & vibrant colorscheme

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.cyberdream"] }
```

## Plugins

- [cyberdream.nvim](https://github.com/scottmckendry/cyberdream.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/cyberdream.lua"
-- High-contrast, futuristic & vibrant colorscheme

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/scottmckendry/cyberdream.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'cyberdream*',
	once = true,
	callback = function()
		require('cyberdream').setup({
			transparent = true,
			italic_comments = true,
			hide_fillchars = false,
			borderless_telescope = true,
			terminal_colors = true,
		})
	end,
})
```

</details>
