---
title: "colorscheme.kanagawa"
description: "Colorscheme inspired by Katsushika Hokusai's famous painting"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Colorscheme inspired by Katsushika Hokusai's famous painting

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.kanagawa"] }
```

## Plugins

- [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/kanagawa.lua"
-- Colorscheme inspired by Katsushika Hokusai's famous painting

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/rebelot/kanagawa.nvim' })
```

</details>
