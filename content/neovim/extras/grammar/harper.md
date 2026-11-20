---
title: "grammar.harper"
description: "Harper: grammar and prose checker LSP for Markdown (after/lsp/harper_ls.lua)"
published: true
generated: true
kind: "extra"
category: "grammar"
---

Harper: grammar and prose checker LSP for Markdown (after/lsp/harper_ls.lua)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["grammar.harper"] }
```

## Language support

- LSP servers: `harper_ls`
- Tools installed with Mason: `harper-ls`

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/grammar/harper.lua"
-- Harper: grammar and prose checker LSP for Markdown (after/lsp/harper_ls.lua)
require('rafi.util.lang').add({
	servers = { harper_ls = true },
	tools = { 'harper-ls' },
})
```

</details>
