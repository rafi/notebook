---
title: "colorscheme.oxocarbon"
description: "Dark and light theme inspired by IBM Carbon"
published: true
generated: true
kind: "extra"
category: "colorscheme"
---

Dark and light theme inspired by IBM Carbon

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["colorscheme.oxocarbon"] }
```

## Plugins

- [oxocarbon.nvim](https://github.com/nyoom-engineering/oxocarbon.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/colorscheme/oxocarbon.lua"
-- Dark and light theme inspired by IBM Carbon

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({ 'https://github.com/nyoom-engineering/oxocarbon.nvim' })
```

</details>
