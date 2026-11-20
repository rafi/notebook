---
title: "lang.svelte"
description: "Svelte: language server, plus the vtsls plugin (after/lsp/vtsls.lua)"
published: true
generated: true
kind: "extra"
category: "lang"
---

Svelte: language server, plus the vtsls plugin (after/lsp/vtsls.lua)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.svelte"] }
```

## Language support

- LSP servers: `svelte`

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/svelte.lua"
-- Svelte: language server, plus the vtsls plugin (after/lsp/vtsls.lua)
require('rafi.util.lang').add({ servers = { svelte = true } })
```

</details>
