---
title: "coding.neogen"
description: "Annotation generator"
published: true
generated: true
kind: "extra"
category: "coding"
---

Annotation generator

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["coding.neogen"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>c</kbd><kbd>n</kbd> | Generate Annotations (Neogen) | 𝐍 |

## Plugins

- [neogen](https://github.com/danymat/neogen)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/neogen.lua"
-- Annotation generator
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/neogen.lua
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/danymat/neogen' })
	-- Setup creates the :Neogen command.
	require('neogen').setup({ snippet_engine = 'nvim' })
end)

vim.keymap.set('n', '<leader>cn', function()
	require('neogen').generate()
end, { desc = 'Generate Annotations (Neogen)' })
```

</details>
