---
title: "colorscheme.modus"
description: "Highly accessible themes conforming with WCAG AAA color contrast"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Highly accessible themes conforming with WCAG AAA color contrast

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.modus"] }
```

## Plugins

- [modus-themes.nvim](https://github.com/miikanissi/modus-themes.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/modus.lua"
-- Highly accessible themes conforming with WCAG AAA color contrast

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/miikanissi/modus-themes.nvim' })

-- Configure right before the colorscheme is first applied.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'modus*',
	once = true,
	callback = function()
		require('modus-themes').setup({
			style = 'auto', -- auto, modus_operandi, modus_vivendi
			transparent = false,
			dim_inactive = false,
		})
	end,
})
```

</details>
