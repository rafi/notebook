---
title: "colorscheme.material"
description: "Colorscheme based on the Material Design color palette"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Colorscheme based on the Material Design color palette

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.material"] }
```

## Plugins

- [material.nvim](https://github.com/marko-cerovac/material.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/material.lua"
-- Colorscheme based on the Material Design color palette

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/marko-cerovac/material.nvim' })
```

</details>
