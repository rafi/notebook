---
title: "editor.mini-visits"
description: "Track and reuse file system visits"
published: true
generated: true
kind: "extra"
category: "editor"
---

Track and reuse file system visits

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.mini-visits"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>H</kbd> | Add Location | 𝐍 |
| <kbd>leader</kbd><kbd>m</kbd><kbd>r</kbd> | Remove Location | 𝐍 |
| <kbd>C-n</kbd> | Next Location | 𝐍 |
| <kbd>C-p</kbd> | Previous Location | 𝐍 |
| <kbd>localleader</kbd><kbd>1</kbd> | Visits to File 1 | 𝐍 |
| <kbd>localleader</kbd><kbd>2</kbd> | Visits to File 2 | 𝐍 |
| <kbd>localleader</kbd><kbd>3</kbd> | Visits to File 3 | 𝐍 |
| <kbd>localleader</kbd><kbd>4</kbd> | Visits to File 4 | 𝐍 |
| <kbd>localleader</kbd><kbd>5</kbd> | Visits to File 5 | 𝐍 |
| <kbd>localleader</kbd><kbd>h</kbd> | Visits | 𝐍 |

## Plugins

- [mini.visits](https://github.com/nvim-mini/mini.visits)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/mini-visits.lua"
-- Track and reuse file system visits
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/nvim-mini/mini.visits' })
	require('mini.visits').setup()
end)

-- Core keymaps (rafi.config.keymaps) map <localleader>h to Help Pages on
-- `later`, after this file runs. Re-apply on RafiKeymaps so Visits wins,
-- while lua/config/keymaps.lua (which runs after) can still override it.
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = function()
		vim.keymap.set(
			'n',
			'<localleader>h',
			'<cmd>lua MiniVisits.select_path()<CR>',
			{ desc = 'Visits' }
		)
	end,
})

-- Harpoon-like marks: files labeled "core" in the current cwd, sorted by
-- path so the numbered keys and next/prev keep a stable order (the default
-- sort reorders by visit recency and frequency).
local label = 'core'

local function sort_by_path(path_data)
	table.sort(path_data, function(a, b)
		return a.path < b.path
	end)
	return path_data
end

local function iterate(direction)
	MiniVisits.iterate_paths(
		direction,
		nil,
		{ filter = label, sort = sort_by_path, wrap = true }
	)
end

-- Open the i-th core path of the cwd, if there is one.
local function select(i)
	local paths =
		MiniVisits.list_paths(nil, { filter = label, sort = sort_by_path })
	if paths[i] then
		vim.cmd.edit(vim.fn.fnameescape(paths[i]))
	end
end

-- stylua: ignore start
vim.keymap.set('n', '<leader>H', function() MiniVisits.add_label(label) end, { desc = 'Add Location' })
vim.keymap.set('n', '<leader>mr', function() MiniVisits.remove_label(label) end, { desc = 'Remove Location' })
vim.keymap.set('n', '<C-n>', function() iterate('forward') end, { desc = 'Next Location' })
vim.keymap.set('n', '<C-p>', function() iterate('backward') end, { desc = 'Previous Location' })
-- stylua: ignore end

for i = 1, 5 do
	vim.keymap.set('n', '<localleader>' .. i, function()
		select(i)
	end, { desc = 'Visits to File ' .. i })
end
```

</details>
