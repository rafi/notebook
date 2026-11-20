---
title: "lang.nix"
description: "Nix: nil language server, nixfmt formatter and statix linter"
published: true
generated: true
kind: "extra"
category: "lang"
---

Nix: nil language server, nixfmt formatter and statix linter

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.nix"] }
```

## Language support

- LSP servers: `nil_ls`
- Tools installed with Mason: `nixfmt`, `statix`
- Linters: `statix` _(nix)_
- Formatters: `nixfmt` _(nix)_

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/nix.lua"
-- Nix: nil language server, nixfmt formatter and statix linter
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/nix.lua
require('rafi.util.lang').add({
	servers = { nil_ls = true },
	tools = { 'nixfmt', 'statix' },
	linters_by_ft = { nix = { 'statix' } },
	formatters_by_ft = { nix = { 'nixfmt' } },
})
```

</details>
