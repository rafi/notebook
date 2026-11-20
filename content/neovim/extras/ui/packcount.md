---
title: "ui.packcount"
description: "Count plugins with pending vim.pack updates for the statusline"
published: true
generated: true
kind: "extra"
category: "ui"
default_enabled: true
---

Count plugins with pending vim.pack updates for the statusline

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"ui.packcount"` from `extras` in your `rafi.json`.

## Plugins

- [packcount.nvim](https://github.com/rafi/packcount.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/ui/packcount.lua"
-- Count plugins with pending vim.pack updates for the statusline

-- Eager: the plugin/ file only defines :Packcount and starts its background
-- check loop on UIEnter (Neovim 0.13+). The count is read by lualine.
require('rafi.pack').dev(
	'packcount.nvim',
	'https://github.com/rafi/packcount.nvim'
)
```

</details>
