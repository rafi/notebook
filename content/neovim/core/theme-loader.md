---
title: "theme-loader"
description: "Use last-used colorscheme"
published: true
generated: true
kind: "core"
---

Use last-used colorscheme

## Disable

This core plugin always loads. To turn it off, add it to `disabled` in your `rafi.json`. You can then replace it with your own file in `lua/plugins/`.

```json
{ "disabled": ["theme-loader"] }
```

## Plugins

- [theme-loader.nvim](https://github.com/rafi/theme-loader.nvim)

<details>
<summary>Source</summary>

```lua title="plugin/theme-loader.lua"
-- Use last-used colorscheme
if require('rafi.config').disabled('theme-loader') then
	return
end

-- Save the colorscheme in rafi.json, unless lua/config/options.lua set
-- another file.
local opts = vim.g.theme_loader or {}
if type(opts) == 'table' then
	opts.json_file_path = opts.json_file_path
		or require('rafi.config').json_path()
	vim.g.theme_loader = opts
end

-- Eager: the plugin restores the colorscheme on VimEnter, before the UI
-- draws, so every colorscheme file, core or extra, adds its colors/ to
-- runtimepath first.
require('rafi.pack').dev(
	'theme-loader.nvim',
	'https://github.com/rafi/theme-loader.nvim'
)
```

</details>
