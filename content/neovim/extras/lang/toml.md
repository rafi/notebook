---
title: "lang.toml"
description: "TOML: taplo language server"
published: true
generated: true
kind: "extra"
category: "lang"
default_enabled: true
---

TOML: taplo language server

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"lang.toml"` from `extras` in your `rafi.json`.

## Language support

- LSP servers: `taplo`

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/toml.lua"
-- TOML: taplo language server
require('rafi.util.lang').add({ servers = { taplo = true } })
```

</details>
