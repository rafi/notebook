---
title: "colorscheme.onenord"
description: "Theme combining the Nord and Atom One Dark color palettes"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Theme combining the Nord and Atom One Dark color palettes

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.onenord"] }
```

## Plugins

- [onenord.nvim](https://github.com/rmehri01/onenord.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/onenord.lua"
-- Theme combining the Nord and Atom One Dark color palettes

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/rmehri01/onenord.nvim' })
```

</details>
