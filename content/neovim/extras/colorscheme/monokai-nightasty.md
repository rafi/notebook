---
title: "colorscheme.monokai-nightasty"
description: "Dark/light theme based on the Monokai color palette"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Dark/light theme based on the Monokai color palette

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.monokai-nightasty"] }
```

## Plugins

- [monokai-nightasty.nvim](https://github.com/polirritmico/monokai-nightasty.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/monokai-nightasty.lua"
-- Dark/light theme based on the Monokai color palette

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/polirritmico/monokai-nightasty.nvim' })
```

</details>
