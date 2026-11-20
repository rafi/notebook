---
title: "lsp.actions-preview"
description: "Fully customizable previewer for LSP code actions"
published: true
generated: true
kind: "extra"
category: "lsp"
---

Fully customizable previewer for LSP code actions

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lsp.actions-preview"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>c</kbd><kbd>a</kbd> | Code Action _(with any LSP)_ | 𝐍 𝐗 |

## Plugins

- [actions-preview.nvim](https://github.com/aznhe21/actions-preview.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lsp/actions-preview.lua"
-- Fully customizable previewer for LSP code actions
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/aznhe21/actions-preview.nvim' })
	require('actions-preview').setup({})
end

-- Registered as an LSP '*' key so it replaces lspconfig's buffer-local
-- <leader>ca, since extras' '*' keys are applied after the core ones.
require('rafi.util.lang').add({
	keys = {
		['*'] = {
			{
				'<leader>ca',
				function()
					load()
					require('actions-preview').code_actions()
				end,
				desc = 'Code Action',
				mode = { 'n', 'x' },
				has = 'codeAction',
			},
		},
	},
})
```

</details>
