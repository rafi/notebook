---
title: "colorscheme.lackluster"
description: "Minimal, mostly monochrome colorscheme that's soft on the eyes"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Minimal, mostly monochrome colorscheme that's soft on the eyes

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.lackluster"] }
```

## Plugins

- [lackluster.nvim](https://github.com/slugbyte/lackluster.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/lackluster.lua"
-- Minimal, mostly monochrome colorscheme that's soft on the eyes

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/slugbyte/lackluster.nvim' })
```

</details>
