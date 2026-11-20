---
title: "treesitter.autotag"
description: "Automatically add closing tags for HTML and JSX"
published: true
generated: true
kind: "extra"
category: "treesitter"
default_enabled: true
---

Automatically add closing tags for HTML and JSX

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"treesitter.autotag"` from `extras` in your `rafi.json`.

## Plugins

- [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/treesitter/autotag.lua"
-- Automatically add closing tags for HTML and JSX
local pack = require('rafi.pack')

pack.on_event('BufReadPre,BufNewFile', function()
	vim.pack.add({ 'https://github.com/windwp/nvim-ts-autotag' })
	require('nvim-ts-autotag').setup({})
	-- Setup only attaches on FileType, attach buffers already open.
	pack.refire_filetype('nvim_ts_xmltag')
end)
```

</details>
