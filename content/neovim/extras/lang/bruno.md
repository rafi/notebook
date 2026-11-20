---
title: "lang.bruno"
description: "Bruno: .bru filetype and its tree-sitter parser"
published: true
generated: true
kind: "extra"
category: "lang"
---

Bruno: .bru filetype and its tree-sitter parser

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.bruno"] }
```

## Language support

- Tree-sitter parsers: `bruno`

## Plugins

- [tree-sitter-bruno](https://github.com/Scalamando/tree-sitter-bruno)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/bruno.lua"
-- Bruno: .bru filetype and its tree-sitter parser

vim.filetype.add({ extension = { bru = 'bruno' } })

-- Built with the repo's queries by arborist (first bruno buffer) or
-- nvim-treesitter (installed on load).
require('rafi.util.lang').add({
	parsers = {
		bruno = { url = 'https://github.com/Scalamando/tree-sitter-bruno' },
	},
})
```

</details>
