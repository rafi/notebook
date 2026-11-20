---
title: "ui.bufferline"
description: "Snazzy tab/bufferline"
published: true
generated: true
kind: "extra"
category: "ui"
default_enabled: true
---

Snazzy tab/bufferline

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"ui.bufferline"` from `extras` in your `rafi.json`.

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>b</kbd><kbd>p</kbd> | Toggle Pin | 𝐍 |
| <kbd>leader</kbd><kbd>b</kbd><kbd>P</kbd> | Delete Non-Pinned Buffers | 𝐍 |
| <kbd>leader</kbd><kbd>b</kbd><kbd>r</kbd> | Delete Buffers to the Right | 𝐍 |
| <kbd>leader</kbd><kbd>b</kbd><kbd>l</kbd> | Delete Buffers to the Left | 𝐍 |
| <kbd>[</kbd><kbd>b</kbd> | Prev Buffer | 𝐍 |
| <kbd>]</kbd><kbd>b</kbd> | Next Buffer | 𝐍 |
| <kbd>[</kbd><kbd>B</kbd> | Move buffer prev | 𝐍 |
| <kbd>]</kbd><kbd>B</kbd> | Move buffer next | 𝐍 |
| <kbd>leader</kbd><kbd>b</kbd><kbd>j</kbd> | Pick Buffer | 𝐍 |

## Plugins

- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/ui/bufferline.lua"
-- Snazzy tab/bufferline
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua
if vim.g.started_by_firenvim then
	return
end

local pack = require('rafi.pack')

local function bufdelete(n)
	if _G.Snacks then
		Snacks.bufdelete(n)
	else
		vim.cmd.bdelete(n)
	end
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/akinsho/bufferline.nvim' })
	local icons = require('rafi.util.icons')
	require('bufferline').setup({
		options = {
			mode = 'tabs',
			separator_style = 'slant',
			show_close_icon = false,
			show_buffer_close_icons = false,
			always_show_bufferline = true,
			close_command = bufdelete,
			right_mouse_command = bufdelete,
			diagnostics = 'nvim_lsp',
			diagnostics_indicator = function(_, _, diag)
				local i = icons.diagnostics
				local ret = (diag.error and i.Error .. diag.error .. ' ' or '')
					.. (diag.warning and i.Warn .. diag.warning or '')
				return vim.trim(ret)
			end,
			custom_areas = {
				right = function()
					local result = {}
					local root = require('rafi.util.root')()
					table.insert(result, {
						text = '%#BufferLineTab# ' .. vim.fn.fnamemodify(root, ':t'),
					})

					-- Session indicator
					if vim.v.this_session ~= '' then
						table.insert(result, { text = '%#BufferLineTab#  ' })
					end
					return result
				end,
			},
			offsets = {
				{
					filetype = 'snacks_layout_box',
					text = '󰙅  File Explorer',
					separator = true,
				},
				{
					filetype = 'neo-tree',
					text = 'Neo-tree',
					separator = true,
					highlight = 'Directory',
					text_align = 'center',
				},
			},
			---@param opts bufferline.IconFetcherOpts
			get_element_icon = function(opts)
				return icons.ft[opts.filetype]
			end,
		},
	})
	-- Fix bufferline when restoring a session
	vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
		group = vim.api.nvim_create_augroup('rafi.bufferline', {}),
		callback = function()
			vim.schedule(function()
				pcall(nvim_bufferline)
			end)
		end,
	})
end

pack.later(load)

-- Load first, since setup creates the commands.
local function map(lhs, cmd, desc)
	vim.keymap.set('n', lhs, function()
		load()
		vim.cmd(cmd)
	end, { desc = desc })
end

map('<leader>bp', 'BufferLineTogglePin', 'Toggle Pin')
map('<leader>bP', 'BufferLineGroupClose ungrouped', 'Delete Non-Pinned Buffers')
map('<leader>br', 'BufferLineCloseRight', 'Delete Buffers to the Right')
map('<leader>bl', 'BufferLineCloseLeft', 'Delete Buffers to the Left')
map('[b', 'BufferLineCyclePrev', 'Prev Buffer')
map(']b', 'BufferLineCycleNext', 'Next Buffer')
map('[B', 'BufferLineMovePrev', 'Move buffer prev')
map(']B', 'BufferLineMoveNext', 'Move buffer next')
map('<leader>bj', 'BufferLinePick', 'Pick Buffer')
```

</details>
