---
title: "lang.stylus"
description: "Stylus syntax, indent and completion"
published: true
generated: true
kind: "extra"
category: "lang"
---

Stylus syntax, indent and completion

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.stylus"] }
```

## Plugins

- [vim-stylus](https://github.com/iloginow/vim-stylus)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/stylus.lua"
-- Stylus syntax, indent and completion

-- Its plugin/ is heavy, add on first stylus buffer (Neovim detects the ft).
require('rafi.pack').on_filetype('stylus', function()
	vim.pack.add({ 'https://github.com/iloginow/vim-stylus' })
	-- Re-apply the filetype to source its syntax/indent/ftplugin (scheduled,
	-- FileType doesn't nest).
	local buf = vim.api.nvim_get_current_buf()
	vim.schedule(function()
		if vim.api.nvim_buf_is_valid(buf) then
			vim.bo[buf].filetype = 'stylus'
		end
	end)
end)
```

</details>
