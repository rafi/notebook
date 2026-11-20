---
title: "git.fugitive"
description: "Git client (vim-fugitive) and commit browser (gv.vim)"
published: true
generated: true
kind: "extra"
category: "git"
---

Git client (vim-fugitive) and commit browser (gv.vim)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["git.fugitive"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>g</kbd><kbd>d</kbd> | Git diff | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>b</kbd> | Git blame | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>l</kbd> | Git log viewer | 𝐍 |

## Plugins

- [vim-fugitive](https://github.com/tpope/vim-fugitive)
- [gv.vim](https://github.com/junegunn/gv.vim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/git/fugitive.lua"
-- Git client (vim-fugitive) and commit browser (gv.vim)
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- Neither plugin has a Lua setup(): loading them sources their own
	-- Vimscript plugin/ commands, replacing the stubs below.
	vim.pack.add({
		'https://github.com/tpope/vim-fugitive',
		'https://github.com/junegunn/gv.vim',
	})
end

---@param name string
---@param desc string
local function stub(name, desc)
	require('rafi.pack').command(
		name,
		load,
		{ bang = true, range = true, desc = desc }
	)
end

stub('G', 'Fugitive status')
stub('Git', 'Fugitive: run a Git command')
stub('Gfetch', 'Fugitive: fetch')
stub('Gpush', 'Fugitive: push')
stub('Gclog', 'Fugitive: commit log')
stub('Gdiffsplit', 'Fugitive: diff split')
stub('GV', 'Git commit browser (gv.vim)')

-- stylua: ignore start
vim.keymap.set('n', '<leader>gd', '<cmd>Gdiffsplit<CR>', { desc = 'Git diff' })
vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<CR>', { desc = 'Git blame' })
vim.keymap.set('n', '<leader>gl', '<cmd>GV<CR>', { desc = 'Git log viewer' })
-- stylua: ignore end

-- Jump straight into insert-append on a fugitive blame column, so typing a
-- commit hash prefix filters/jumps immediately.
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi.fugitive', {}),
	pattern = 'fugitiveblame',
	callback = function()
		vim.schedule(function()
			vim.cmd.normal('A')
		end)
	end,
})
```

</details>
