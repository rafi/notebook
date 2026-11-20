---
title: "coding.mini-comment"
description: "Fast and feature-rich commenting (gc), with treesitter context"
published: true
generated: true
kind: "extra"
category: "coding"
---

Fast and feature-rich commenting (gc), with treesitter context

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["coding.mini-comment"] }
```

## Plugins

- [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
- [mini.comment](https://github.com/nvim-mini/mini.comment)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/mini-comment.lua"
-- Fast and feature-rich commenting (gc), with treesitter context
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/mini-comment.lua
local pack = require('rafi.pack')

-- NOTE: Conflict: mini.comment replaces native `gc`, used by core `<leader>v`.
-- Enable only one of coding.comment and coding.mini-comment. coding.ts-comments
-- is not needed with this.
pack.later(function()
	-- Only the module sets commentstring, not a CursorHold autocmd.
	vim.g.skip_ts_context_commentstring_module = true
	vim.pack.add({
		'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',
		'https://github.com/nvim-mini/mini.comment',
	})
	require('ts_context_commentstring').setup({ enable_autocmd = false })
	require('mini.comment').setup({
		options = {
			-- Treesitter-aware commentstring, e.g. JSX, Vue, embedded languages.
			custom_commentstring = function()
				return require('ts_context_commentstring.internal').calculate_commentstring()
					or vim.bo.commentstring
			end,
		},
	})
end)
```

</details>
