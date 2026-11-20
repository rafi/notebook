---
title: "editor.dbee"
description: "Interactive database client"
published: true
generated: true
kind: "extra"
category: "editor"
---

Interactive database client

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.dbee"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>c</kbd><kbd>b</kbd> | DBee | 𝐍 |

## Plugins

- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- [nvim-dbee](https://github.com/kndndrj/nvim-dbee)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/dbee.lua"
-- Interactive database client

-- Fetch the dbee backend binary (with curl, wget, bitsadmin or go) on
-- install and update, or at startup when stdpath('data')/dbee/bin/dbee is
-- missing. Registered at startup, so updates before first use still install.
-- nui goes first: dbee's plugin/ requires its UI, which needs nui.
require('rafi.pack').build('nvim-dbee', {
	deps = { 'nui.nvim' },
	build = function()
		require('dbee').install()
	end,
	is_built = function()
		local bin = vim.fn.stdpath('data') .. '/dbee/bin/dbee'
		return vim.uv.fs_stat(bin) ~= nil or vim.uv.fs_stat(bin .. '.exe') ~= nil
	end,
})

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/MunifTanjim/nui.nvim',
		'https://github.com/kndndrj/nvim-dbee',
	})
	require('dbee').setup()
end

-- stylua: ignore start
vim.keymap.set('n', '<leader>cb', function() load() require('dbee').toggle() end, { desc = 'DBee' })
-- stylua: ignore end
```

</details>
