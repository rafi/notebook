---
title: "git.committia"
description: "Pleasant editing on Git commit messages"
published: true
generated: true
kind: "extra"
category: "git"
default_enabled: true
---

Pleasant editing on Git commit messages

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"git.committia"` from `extras` in your `rafi.json`.

## Plugins

- [committia.vim](https://github.com/rhysd/committia.vim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/git/committia.lua"
-- Pleasant editing on Git commit messages
if vim.fn.executable('git') == 0 then
	return
end

-- See: https://github.com/rhysd/committia.vim#variables
vim.g.committia_min_window_width = 30
vim.g.committia_edit_window_width = 75
vim.g.committia_hooks = {
	edit_open = function()
		vim.cmd.resize(10)
		local opts = {
			buffer = vim.api.nvim_get_current_buf(),
			silent = true,
		}
		local function map(mode, lhs, rhs)
			vim.keymap.set(mode, lhs, rhs, opts)
		end
		map('n', 'q', '<cmd>quit<CR>')
		map('i', '<C-d>', '<Plug>(committia-scroll-diff-down-half)')
		map('i', '<C-u>', '<Plug>(committia-scroll-diff-up-half)')
		map('i', '<C-f>', '<Plug>(committia-scroll-diff-down-page)')
		map('i', '<C-b>', '<Plug>(committia-scroll-diff-up-page)')
		map('i', '<C-j>', '<Plug>(committia-scroll-diff-down)')
		map('i', '<C-k>', '<Plug>(committia-scroll-diff-up)')
	end,
}

-- Its plugin/ opens on BufReadPost, and only while Vim is starting.
require('rafi.pack').on_event('BufReadPre~COMMIT_EDITMSG', function()
	vim.pack.add({ 'https://github.com/rhysd/committia.vim' })
end)
```

</details>
