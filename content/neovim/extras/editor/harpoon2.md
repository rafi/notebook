---
title: "editor.harpoon2"
description: "Marks for navigating your project"
published: true
generated: true
kind: "extra"
category: "editor"
---

Marks for navigating your project

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.harpoon2"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>H</kbd> | Add Location | 𝐍 |
| <kbd>leader</kbd><kbd>m</kbd><kbd>r</kbd> | Remove Location | 𝐍 |
| <kbd>C-n</kbd> | Next Location | 𝐍 |
| <kbd>C-p</kbd> | Previous Location | 𝐍 |
| <kbd>localleader</kbd><kbd>1</kbd> | Harpoon to File 1 | 𝐍 |
| <kbd>localleader</kbd><kbd>2</kbd> | Harpoon to File 2 | 𝐍 |
| <kbd>localleader</kbd><kbd>3</kbd> | Harpoon to File 3 | 𝐍 |
| <kbd>localleader</kbd><kbd>4</kbd> | Harpoon to File 4 | 𝐍 |
| <kbd>localleader</kbd><kbd>5</kbd> | Harpoon to File 5 | 𝐍 |
| <kbd>localleader</kbd><kbd>h</kbd> | List locations | 𝐍 |

## Plugins

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [harpoon](https://github.com/ThePrimeagen/harpoon)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/harpoon2.lua"
-- Marks for navigating your project
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/harpoon2.lua
local menu_width = vim.api.nvim_win_get_width(0) - 4

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- harpoon2 (the `harpoon2` branch) requires plenary.nvim (`plenary.path`)
	-- but doesn't declare it. Add it explicitly instead of relying on other
	-- core files happening to have added it first.
	vim.pack.add({
		'https://github.com/nvim-lua/plenary.nvim',
		{ src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
	})
	require('harpoon').setup({
		menu = { width = menu_width },
		settings = { save_on_toggle = true },
	})
end

-- Core keymaps (rafi.config.keymaps) map <localleader>h to Help Pages on
-- `later`, after this file runs. Re-apply on RafiKeymaps so harpoon wins,
-- while lua/config/keymaps.lua (which runs after) can still override it.
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = function()
		vim.keymap.set('n', '<localleader>h', function()
			load()
			local harpoon = require('harpoon')
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = 'List locations' })
	end,
})

-- stylua: ignore start
vim.keymap.set('n', '<leader>H', function() load() require('harpoon'):list():add() end, { desc = 'Add Location' })
vim.keymap.set('n', '<leader>mr', function() load() require('harpoon'):list():remove() end, { desc = 'Remove Location' })
vim.keymap.set('n', '<C-n>', function() load() require('harpoon'):list():next() end, { desc = 'Next Location' })
vim.keymap.set('n', '<C-p>', function() load() require('harpoon'):list():prev() end, { desc = 'Previous Location' })
-- stylua: ignore end

for i = 1, 5 do
	vim.keymap.set('n', '<localleader>' .. i, function()
		load()
		require('harpoon'):list():select(i)
	end, { desc = 'Harpoon to File ' .. i })
end
```

</details>
