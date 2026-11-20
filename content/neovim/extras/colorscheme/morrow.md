---
title: "colorscheme.morrow"
description: "Modern dark colorscheme, hybrid improved"
published: true
generated: true
kind: "extra"
category: "colorscheme"
default_enabled: true
---

Modern dark colorscheme, hybrid improved

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"colorscheme.morrow"` from `extras` in your `rafi.json`.

## Plugins

- [morrow.nvim](https://github.com/rafi/morrow.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/morrow.lua"
-- Modern dark colorscheme, hybrid improved

-- Start with morrow when nothing was saved yet, unless
-- lua/config/options.lua picked another initial colorscheme.
if not require('rafi.config').disabled('theme-loader') then
	local opts = vim.g.theme_loader or {}
	if type(opts) == 'table' and opts.initial_colorscheme == nil then
		opts.initial_colorscheme = 'morrow'
		vim.g.theme_loader = opts
	end
end

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
require('rafi.pack').dev('morrow.nvim', 'https://github.com/rafi/morrow.nvim')
```

</details>
