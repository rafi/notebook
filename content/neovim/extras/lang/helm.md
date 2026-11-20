---
title: "lang.helm"
description: "Helm: helm-ls.nvim filetypes/ftplugin, and helm_ls language server"
published: true
generated: true
kind: "extra"
category: "lang"
---

Helm: helm-ls.nvim filetypes/ftplugin, and helm_ls language server

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.helm"] }
```

## Language support

- LSP servers: `helm_ls`

## Plugins

- [helm-ls.nvim](https://github.com/qvalentin/helm-ls.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/helm.lua"
-- Helm: helm-ls.nvim filetypes/ftplugin, and helm_ls language server

-- Eager: ftdetect must be sourced before files are read. Its setup() was
-- never called (conceal, indent hints and action highlight stay off).
vim.pack.add({ 'https://github.com/qvalentin/helm-ls.nvim' })

vim.filetype.add({
	pattern = {
		['.*/templates/.*%.ya?ml'] = 'helm',
		['.*/templates/.*%.tpl'] = 'helm',
	},
})

require('rafi.util.lang').add({ servers = { helm_ls = true } })
```

</details>
