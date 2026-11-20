---
title: "org.telekasten"
description: "Markdown zettelkasten or wiki with telescope (telekasten.nvim)"
published: true
generated: true
kind: "extra"
category: "org"
---

Markdown zettelkasten or wiki with telescope (telekasten.nvim)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["org.telekasten"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>z</kbd><kbd>n</kbd> | New note | 𝐍 |
| <kbd>leader</kbd><kbd>z</kbd><kbd>N</kbd> | New templated note | 𝐍 |
| <kbd>leader</kbd><kbd>z</kbd><kbd>f</kbd> | Find notes | 𝐍 |
| <kbd>leader</kbd><kbd>z</kbd><kbd>g</kbd> | Search notes | 𝐍 |
| <kbd>leader</kbd><kbd>z</kbd><kbd>o</kbd> | Telekasten panel | 𝐍 |
| <kbd>leader</kbd><kbd>z</kbd><kbd>t</kbd> | Show tags | 𝐍 |
| <kbd>leader</kbd><kbd>z</kbd><kbd>d</kbd> | Daily notes | 𝐍 |
| <kbd>leader</kbd><kbd>z</kbd><kbd>b</kbd> | Backlinks | 𝐍 |
| <kbd>leader</kbd><kbd>z</kbd><kbd>l</kbd> | Find friends | 𝐍 |
| <kbd>leader</kbd><kbd>z</kbd><kbd>m</kbd> | Browse media | 𝐍 |

## Plugins

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [telekasten.nvim](https://github.com/nvim-telekasten/telekasten.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/org/telekasten.lua"
-- Markdown zettelkasten or wiki with telescope (telekasten.nvim)

local loaded = false
local function load()
	if not loaded then
		loaded = true
		vim.pack.add({
			'https://github.com/nvim-lua/plenary.nvim',
			'https://github.com/nvim-telescope/telescope.nvim',
			'https://github.com/nvim-telekasten/telekasten.nvim',
		})
		require('telekasten').setup({
			home = vim.fn.expand('~/notebook'),
		})
	end
	return require('telekasten')
end

-- Stub until setup() defines the real command.
require('rafi.pack').command('Telekasten', load)

-- NOTE: Conflict: org.obsidian, org.vimwiki and org.zk also map `<leader>z*`
-- keys.
-- stylua: ignore start
vim.keymap.set('n', '<leader>zn', function() load().new_note() end, { desc = 'New note' })
vim.keymap.set('n', '<leader>zN', function() load().new_templated_note() end, { desc = 'New templated note' })
vim.keymap.set('n', '<leader>zf', function() load().find_notes() end, { desc = 'Find notes' })
vim.keymap.set('n', '<leader>zg', function() load().search_notes() end, { desc = 'Search notes' })
vim.keymap.set('n', '<leader>zo', function() load().panel() end, { desc = 'Telekasten panel' })
vim.keymap.set('n', '<leader>zt', function() load().show_tags() end, { desc = 'Show tags' })
vim.keymap.set('n', '<leader>zd', function() load().find_daily_notes() end, { desc = 'Daily notes' })
vim.keymap.set('n', '<leader>zb', function() load().show_backlinks() end, { desc = 'Backlinks' })
vim.keymap.set('n', '<leader>zl', function() load().find_friends() end, { desc = 'Find friends' })
vim.keymap.set('n', '<leader>zm', function() load().browse_media() end, { desc = 'Browse media' })
-- stylua: ignore end
```

</details>
