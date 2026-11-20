---
title: "editor.guess-indent"
description: "Hint and fix deviating indentation"
published: true
generated: true
kind: "extra"
category: "editor"
default_enabled: true
---

Hint and fix deviating indentation

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"editor.guess-indent"` from `extras` in your `rafi.json`.

## Plugins

- [guess-indent.nvim](https://github.com/nmac427/guess-indent.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/guess-indent.lua"
-- Hint and fix deviating indentation

-- Eager: setup only registers BufReadPost/BufNewFile autocmds, and must run
-- before files passed on the command-line are read.
vim.pack.add({ 'https://github.com/nmac427/guess-indent.nvim' })
require('guess-indent').setup({})
```

</details>
