---
title: "lang.log-highlighting"
description: "Syntax highlighting for log files"
published: true
generated: true
kind: "extra"
category: "lang"
---

Syntax highlighting for log files

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.log-highlighting"] }
```

## Plugins

- [vim-log-highlighting](https://github.com/MTDL9/vim-log-highlighting)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/log-highlighting.lua"
-- Syntax highlighting for log files

-- Added at startup so its filetype detection runs before files open.
vim.pack.add({ 'https://github.com/MTDL9/vim-log-highlighting' })
```

</details>
