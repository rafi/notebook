---
title: "lang.yaml"
description: "YAML: yamlls with SchemaStore and Kubernetes schemas (after/lsp/yamlls.lua)"
published: true
generated: true
kind: "extra"
category: "lang"
default_enabled: true
---

YAML: yamlls with SchemaStore and Kubernetes schemas (after/lsp/yamlls.lua)

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"lang.yaml"` from `extras` in your `rafi.json`.

## Language support

- LSP servers: `yamlls`

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/yaml.lua"
-- YAML: yamlls with SchemaStore and Kubernetes schemas (after/lsp/yamlls.lua)
-- SchemaStore.nvim is added with lspconfig, jsonls needs it too.
require('rafi.util.lang').add({ servers = { yamlls = true } })
```

</details>
