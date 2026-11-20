---
title: "editor.todo-comments"
description: "Highlight, list and search todo comments in your projects"
published: true
generated: true
kind: "extra"
category: "editor"
default_enabled: true
---

Highlight, list and search todo comments in your projects

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"editor.todo-comments"` from `extras` in your `rafi.json`.

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>]</kbd><kbd>t</kbd> | Next Todo Comment | 𝐍 |
| <kbd>[</kbd><kbd>t</kbd> | Previous Todo Comment | 𝐍 |
| <kbd>leader</kbd><kbd>x</kbd><kbd>t</kbd> | Todo (Trouble) | 𝐍 |
| <kbd>leader</kbd><kbd>x</kbd><kbd>T</kbd> | Todo/Fix/Fixme (Trouble) | 𝐍 |
| <kbd>leader</kbd><kbd>s</kbd><kbd>t</kbd> | Todo | 𝐍 |
| <kbd>leader</kbd><kbd>s</kbd><kbd>T</kbd> | Todo/Fix/Fixme | 𝐍 |

## Plugins

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/todo-comments.lua"
-- Highlight, list and search todo comments in your projects
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/nvim-lua/plenary.nvim',
		'https://github.com/folke/todo-comments.nvim',
	})
	require('todo-comments').setup({ signs = false })
end

pack.on_event('BufReadPost,BufNewFile', load)

-- Stubs until the plugin's own commands are sourced.
pack.command({ 'TodoTrouble', 'TodoTelescope' }, load)

local function map(lhs, rhs, desc)
	vim.keymap.set('n', lhs, rhs, { desc = desc })
end

-- Run a Trouble command after loading todo-comments.
local function cmd(command)
	return function()
		load()
		vim.cmd(command)
	end
end

local function pick(opts)
	return function()
		load()
		if _G.Snacks then
			Snacks.picker.todo_comments(opts)
		else
			vim.notify('snacks.nvim is not available', vim.log.levels.WARN)
		end
	end
end

-- stylua: ignore start
map(']t', function() load() require('todo-comments').jump_next() end, 'Next Todo Comment')
map('[t', function() load() require('todo-comments').jump_prev() end, 'Previous Todo Comment')
map('<leader>xt', cmd('Trouble todo toggle'), 'Todo (Trouble)')
map('<leader>xT', cmd('Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}'), 'Todo/Fix/Fixme (Trouble)')
map('<leader>st', pick(), 'Todo')
map('<leader>sT', pick({ keywords = { 'TODO', 'FIX', 'FIXME' } }), 'Todo/Fix/Fixme')
-- stylua: ignore end
```

</details>
