---
title: "coding.comment"
description: "Powerful line and block-wise commenting"
published: true
generated: true
kind: "extra"
category: "coding"
---

Powerful line and block-wise commenting

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["coding.comment"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>V</kbd> | Comment | 𝐍 𝐗 |

## Plugins

- [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
- [Comment.nvim](https://github.com/numToStr/Comment.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/comment.lua"
-- Powerful line and block-wise commenting
local pack = require('rafi.pack')

pack.later(function()
	-- Only the pre_hook sets commentstring, not a CursorHold autocmd.
	vim.g.skip_ts_context_commentstring_module = true
	vim.pack.add({
		'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',
		'https://github.com/numToStr/Comment.nvim',
	})
	require('ts_context_commentstring').setup({ enable_autocmd = false })
	local ok, tcc =
		pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
	require('Comment').setup({
		-- Keep native gc and mini.align's gb. Only <Plug> maps are used.
		mappings = false,
		pre_hook = ok and tcc.create_pre_hook() or nil,
	})
end)

-- stylua: ignore start
vim.keymap.set('n', '<leader>V', '<Plug>(comment_toggle_blockwise_current)', { desc = 'Comment' })
vim.keymap.set('x', '<leader>V', '<Plug>(comment_toggle_blockwise_visual)', { desc = 'Comment' })
-- stylua: ignore end
```

</details>
