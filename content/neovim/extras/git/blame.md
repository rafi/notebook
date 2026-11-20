---
title: "git.blame"
description: "Show git blame annotations inline, or in a scrollable window"
published: true
generated: true
kind: "extra"
category: "git"
---

Show git blame annotations inline, or in a scrollable window

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["git.blame"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>g</kbd><kbd>b</kbd> | Git blame | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>B</kbd> | Git blame (window) | 𝐍 |

## Plugins

- [blame.nvim](https://github.com/FabijanZulj/blame.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/git/blame.lua"
-- Show git blame annotations inline, or in a scrollable window
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/FabijanZulj/blame.nvim' })
	-- Setup creates the real :BlameToggle command, replacing the stub below.
	require('blame').setup({
		date_format = '%Y-%m-%d %H:%M',
		merge_consecutive = false,
		max_summary_width = 30,
		mappings = {
			commit_info = 'K',
			stack_push = '>',
			stack_pop = '<',
			show_commit = '<CR>',
			close = { '<Esc>', 'q' },
		},
	})
end

require('rafi.pack').command('BlameToggle', load, { desc = 'Toggle Git blame' })

vim.keymap.set(
	'n',
	'<leader>gb',
	'<cmd>BlameToggle virtual<CR>',
	{ desc = 'Git blame' }
)
vim.keymap.set(
	'n',
	'<leader>gB',
	'<cmd>BlameToggle window<CR>',
	{ desc = 'Git blame (window)' }
)
```

</details>
