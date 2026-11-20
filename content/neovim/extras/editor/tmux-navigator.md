---
title: "editor.tmux-navigator"
description: "Seamless navigation between tmux panes and vim splits"
published: true
generated: true
kind: "extra"
category: "editor"
default_enabled: true
---

Seamless navigation between tmux panes and vim splits

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"editor.tmux-navigator"` from `extras` in your `rafi.json`.

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>C-h</kbd> | Go to Left Window | 𝐍 𝐓 |
| <kbd>C-j</kbd> | Go to Lower Window | 𝐍 𝐓 |
| <kbd>C-k</kbd> | Go to Upper Window | 𝐍 𝐓 |
| <kbd>C-l</kbd> | Go to Right Window | 𝐍 𝐓 |

## Plugins

- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/tmux-navigator.lua"
-- Seamless navigation between tmux panes and vim splits

if not vim.env.TMUX or vim.uv.os_uname().sysname == 'Windows_NT' then
	return
end

-- Eager: tiny, and the maps must work immediately.
vim.g.tmux_navigator_no_mappings = 1
vim.pack.add({ 'https://github.com/christoomey/vim-tmux-navigator' })

local function map()
	-- stylua: ignore start
	vim.keymap.set({ 'n', 't' }, '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { silent = true, desc = 'Go to Left Window' })
	vim.keymap.set({ 'n', 't' }, '<C-j>', '<cmd>TmuxNavigateDown<CR>', { silent = true, desc = 'Go to Lower Window' })
	vim.keymap.set({ 'n', 't' }, '<C-k>', '<cmd>TmuxNavigateUp<CR>', { silent = true, desc = 'Go to Upper Window' })
	vim.keymap.set({ 'n', 't' }, '<C-l>', '<cmd>TmuxNavigateRight<CR>', { silent = true, desc = 'Go to Right Window' })
	-- stylua: ignore end
end

map()
-- rafi.config.keymaps sets its own <C-h/j/k/l> window maps after startup,
-- re-apply after.
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = map,
})
```

</details>
