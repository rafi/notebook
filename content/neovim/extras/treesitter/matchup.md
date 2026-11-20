---
title: "treesitter.matchup"
description: "Modern matchit and matchparen"
published: true
generated: true
kind: "extra"
category: "treesitter"
default_enabled: true
---

Modern matchit and matchparen

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"treesitter.matchup"` from `extras` in your `rafi.json`.

## Plugins

- [vim-matchup](https://github.com/andymass/vim-matchup)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/treesitter/matchup.lua"
-- Modern matchit and matchparen
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- Options are read by plugin/, set them first.
	vim.g.matchup_matchparen_offscreen = vim.empty_dict()
	-- Its plugin/ runs `au! matchparen` to disable the builtin, which is now
	-- plugin/matchparen.lua (not .vim) and disabled here, so the group never
	-- exists. Create it so the caught E216 doesn't land in v:errmsg.
	vim.api.nvim_create_augroup('matchparen', { clear = false })
	vim.pack.add({ 'https://github.com/andymass/vim-matchup' })
	-- plugin/ only attaches on FileType, init buffers already open.
	pack.refire_filetype('matchup_filetype')
end

pack.on_event('BufReadPre,BufNewFile', load)
pack.later(load)
```

</details>
