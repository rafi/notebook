---
title: "editor.kubectl"
description: "Browse and manage Kubernetes resources"
published: true
generated: true
kind: "extra"
category: "editor"
---

Browse and manage Kubernetes resources

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.kubectl"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>8</kbd> | Kubectl | 𝐍 |

## Plugins

- [blink.lib](https://github.com/saghen/blink.lib)
- [kubectl.nvim](https://github.com/ramilito/kubectl.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/kubectl.lua"
-- Browse and manage Kubernetes resources
-- A release tag lets blink.lib fetch the prebuilt kubectl_client
-- library on first setup (restart after it downloads), so no cargo build.
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/saghen/blink.lib',
		{
			src = 'https://github.com/ramilito/kubectl.nvim',
			version = vim.version.range('2.*'),
		},
	})
	-- Setup creates the commands, replacing the stubs below.
	require('kubectl').setup({})
end

require('rafi.pack').command(
	{ 'Kubectl', 'Kubectx', 'Kubens' },
	load,
	{ complete = true }
)

-- stylua: ignore start
vim.keymap.set('n', '<leader>8', function() load() vim.cmd.tabnew() require('kubectl').open() end, { desc = 'Kubectl' })
-- stylua: ignore end
```

</details>
