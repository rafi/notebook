---
title: "lang.reason"
description: "Reason syntax and indent"
published: true
generated: true
kind: "extra"
category: "lang"
---

Reason syntax and indent

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.reason"] }
```

## Plugins

- [vim-reason-plus](https://github.com/reasonml-editor/vim-reason-plus)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/reason.lua"
-- Reason syntax and indent

-- Added at startup so its filetype detection runs before files open.
vim.pack.add({ 'https://github.com/reasonml-editor/vim-reason-plus' })
```

</details>
