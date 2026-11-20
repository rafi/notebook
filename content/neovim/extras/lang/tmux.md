---
title: "lang.tmux"
description: "Tmux: Tmuxfile filetype, and `gK` opens `man tmux` at the word"
published: true
generated: true
kind: "extra"
category: "lang"
---

Tmux: Tmuxfile filetype, and `gK` opens `man tmux` at the word

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.tmux"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>g</kbd><kbd>K</kbd> | Tmux Man Page _(in tmux buffers)_ | 𝐍 |

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/tmux.lua"
-- Tmux: Tmuxfile filetype, and `gK` opens `man tmux` at the word

vim.filetype.add({ filename = { Tmuxfile = 'tmux' } })

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi.ftplugin.tmux', {}),
	pattern = 'tmux',
	callback = function(ev)
		-- Open 'man tmux' with the word under cursor.
		local function open_doc()
			local cword = vim.fn.expand('<cword>')
			require('man').open_page(0, { silent = true }, { 'tmux' })
			vim.fn.search(cword)
		end

		vim.opt_local.iskeyword:append('-')

		vim.b[ev.buf].undo_ftplugin = (vim.b[ev.buf].undo_ftplugin or '')
			.. '\nsetlocal iskeyword<'
			.. '\nsil! nunmap <buffer> gK'

		-- stylua: ignore start
		vim.keymap.set('n', 'gK', open_doc, { buffer = ev.buf, desc = 'Tmux Man Page' })
		-- stylua: ignore end
	end,
})
```

</details>
