---
title: "coding.tabout"
description: "Tab out of brackets and quotes"
published: true
generated: true
kind: "extra"
category: "coding"
---

Tab out of brackets and quotes

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["coding.tabout"] }
```

## Plugins

- [tabout.nvim](https://github.com/abecodes/tabout.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/tabout.lua"
-- Tab out of brackets and quotes
local pack = require('rafi.pack')

pack.on_event('InsertEnter', function()
	vim.pack.add({ 'https://github.com/abecodes/tabout.nvim' })
	-- Setup creates the insert-mode maps.
	require('tabout').setup({
		tabkey = '<C-l>',
		backwards_tabkey = '<S-C-L>',
	})
end)
```

</details>
