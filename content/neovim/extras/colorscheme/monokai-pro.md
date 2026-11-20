---
title: "colorscheme.monokai-pro"
description: "Monokai Pro colorscheme, with several filter variants"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Monokai Pro colorscheme, with several filter variants

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.monokai-pro"] }
```

## Plugins

- [monokai-pro.nvim](https://github.com/loctvl842/monokai-pro.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/monokai-pro.lua"
-- Monokai Pro colorscheme, with several filter variants

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/loctvl842/monokai-pro.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'monokai-pro*',
	once = true,
	callback = function()
		require('monokai-pro').setup({
			filter = 'pro', -- classic | octagon | pro | machine | ristretto | spectrum
			plugins = {
				bufferline = {
					underline_selected = false,
					underline_visible = false,
				},
				indent_blankline = {
					context_highlight = 'pro', -- default | pro
					context_start_underline = false,
				},
			},
		})
	end,
})
```

</details>
