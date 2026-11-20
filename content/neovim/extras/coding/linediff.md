---
title: "coding.linediff"
description: "Perform diffs on blocks of code"
published: true
generated: true
kind: "extra"
category: "coding"
---

Perform diffs on blocks of code

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["coding.linediff"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>m</kbd><kbd>d</kbd><kbd>f</kbd> | Line diff | 𝐗 |
| <kbd>leader</kbd><kbd>m</kbd><kbd>d</kbd><kbd>a</kbd> | Line diff add | 𝐗 |
| <kbd>leader</kbd><kbd>m</kbd><kbd>d</kbd><kbd>s</kbd> | Line diff show | 𝐍 |
| <kbd>leader</kbd><kbd>m</kbd><kbd>d</kbd><kbd>r</kbd> | Line diff reset | 𝐍 |

## Plugins

- [linediff.vim](https://github.com/AndrewRadev/linediff.vim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/linediff.lua"
-- Perform diffs on blocks of code
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/AndrewRadev/linediff.vim' })
end)

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map('x', '<leader>mdf', ':Linediff<CR>', 'Line diff')
map('x', '<leader>mda', ':LinediffAdd<CR>', 'Line diff add')
map('n', '<leader>mds', '<cmd>LinediffShow<CR>', 'Line diff show')
map('n', '<leader>mdr', '<cmd>LinediffReset<CR>', 'Line diff reset')
```

</details>
