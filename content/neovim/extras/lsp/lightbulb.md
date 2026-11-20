---
title: "lsp.lightbulb"
description: "VSCode 💡 for neovim's built-in LSP"
published: true
generated: true
kind: "extra"
category: "lsp"
---

VSCode 💡 for neovim's built-in LSP

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lsp.lightbulb"] }
```

## Plugins

- [nvim-lightbulb](https://github.com/kosayoda/nvim-lightbulb)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lsp/lightbulb.lua"
-- VSCode 💡 for neovim's built-in LSP

require('rafi.pack').on_event('LspAttach', function()
	vim.pack.add({ 'https://github.com/kosayoda/nvim-lightbulb' })
	require('nvim-lightbulb').setup({
		autocmd = { enabled = true },
		ignore = {
			clients = { 'null-ls' },
		},
	})
end)
```

</details>
