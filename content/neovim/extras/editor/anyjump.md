---
title: "editor.anyjump"
description: "Jump to any definition and references without overhead (any-jump.vim)"
published: true
generated: true
kind: "extra"
category: "editor"
---

Jump to any definition and references without overhead (any-jump.vim)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.anyjump"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>i</kbd><kbd>i</kbd> | Any Jump | 𝐍 𝐗 |
| <kbd>leader</kbd><kbd>i</kbd><kbd>b</kbd> | Any Jump Back | 𝐍 |
| <kbd>leader</kbd><kbd>i</kbd><kbd>l</kbd> | Any Jump Resume | 𝐍 |

## Plugins

- [any-jump.vim](https://github.com/pechorin/any-jump.vim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/anyjump.lua"
-- Jump to any definition and references without overhead (any-jump.vim)
local pack = require('rafi.pack')

vim.g.any_jump_disable_default_keybindings = 1

-- Its plugin/ file only defines commands, so it loads on `later`.
pack.later(function()
	vim.pack.add({ 'https://github.com/pechorin/any-jump.vim' })
end)

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi.any-jump', {}),
	pattern = 'any-jump',
	callback = function()
		vim.opt.cursorline = true
	end,
})

-- stylua: ignore start
vim.keymap.set('n', '<leader>ii', '<cmd>AnyJump<CR>', { desc = 'Any Jump' })
vim.keymap.set('x', '<leader>ii', '<cmd>AnyJumpVisual<CR>', { desc = 'Any Jump' })
vim.keymap.set('n', '<leader>ib', '<cmd>AnyJumpBack<CR>', { desc = 'Any Jump Back' })
vim.keymap.set('n', '<leader>il', '<cmd>AnyJumpLastResults<CR>', { desc = 'Any Jump Resume' })
-- stylua: ignore end
```

</details>
