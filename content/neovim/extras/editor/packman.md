---
title: "editor.packman"
description: "vim.pack plugin manager picker (snacks.nvim)"
published: true
generated: true
kind: "extra"
category: "editor"
default_enabled: true
---

vim.pack plugin manager picker (snacks.nvim)

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"editor.packman"` from `extras` in your `rafi.json`.

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>l</kbd> | Plugin Updates | 𝐍 |

## Plugins

- [packman.nvim](https://github.com/rafi/packman.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/packman.lua"
-- vim.pack plugin manager picker (snacks.nvim)

-- Eager: the plugin/ file only defines :Packman and <Plug> maps. The picker
-- loads on first use.
require('rafi.pack').dev('packman.nvim', 'https://github.com/rafi/packman.nvim')

vim.keymap.set('n', '<leader>l', '<Plug>(Packman)', { desc = 'Plugin Updates' })
```

</details>
