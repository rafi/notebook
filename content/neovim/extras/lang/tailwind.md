---
title: "lang.tailwind"
description: "Tailwind CSS: language server (after/lsp/tailwindcss.lua)"
published: true
generated: true
kind: "extra"
category: "lang"
---

Tailwind CSS: language server (after/lsp/tailwindcss.lua)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.tailwind"] }
```

## Language support

- LSP servers: `tailwindcss`

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/tailwind.lua"
-- Tailwind CSS: language server (after/lsp/tailwindcss.lua)
-- Color highlighting in buffers comes from editor.mini-hipatterns.
require('rafi.util.lang').add({ servers = { tailwindcss = true } })
```

</details>
