---
title: "editor.key-analyzer"
description: "Visualize keyboard mappings for a prefix on a keyboard layout"
published: true
generated: true
kind: "extra"
category: "editor"
---

Visualize keyboard mappings for a prefix on a keyboard layout

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.key-analyzer"] }
```

## Plugins

- [key-analyzer.nvim](https://github.com/meznaric/key-analyzer.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/key-analyzer.lua"
-- Visualize keyboard mappings for a prefix on a keyboard layout
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/meznaric/key-analyzer.nvim' })
	-- Setup creates the :KeyAnalyzer command, replacing the stub below.
	require('key-analyzer').setup({})
end

require('rafi.pack').command('KeyAnalyzer', load, {
	nargs = '+',
	desc = 'Analyze keyboard mappings for a specific prefix and mode',
	complete = true,
})
```

</details>
