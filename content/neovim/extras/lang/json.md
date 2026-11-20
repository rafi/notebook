---
title: "lang.json"
description: "JSON: language server with SchemaStore schemas (after/lsp/jsonls.lua)"
published: true
generated: true
kind: "extra"
category: "lang"
default_enabled: true
---

JSON: language server with SchemaStore schemas (after/lsp/jsonls.lua)

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"lang.json"` from `extras` in your `rafi.json`.

## Language support

- LSP servers: `jsonls`

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/json.lua"
-- JSON: language server with SchemaStore schemas (after/lsp/jsonls.lua)
require('rafi.util.lang').add({ servers = { jsonls = true } })
```

</details>
