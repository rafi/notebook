---
title: "coding.chainsaw"
description: "Create log statements on the fly"
published: true
generated: true
kind: "extra"
category: "coding"
---

Create log statements on the fly

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["coding.chainsaw"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>g</kbd><kbd>?</kbd><kbd>v</kbd> | Variable log statement | 𝐍 |
| <kbd>g</kbd><kbd>?</kbd><kbd>p</kbd> | Message log statement | 𝐍 |

## Plugins

- [nvim-chainsaw](https://github.com/chrisgrieser/nvim-chainsaw)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/chainsaw.lua"
-- Create log statements on the fly
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/chrisgrieser/nvim-chainsaw' })
	require('chainsaw').setup()
end

-- NOTE: Conflict: coding.chainsaw wins over coding.debugprint's g?v/g?p
-- when both are enabled. These maps exist when the file loads, and
-- debugprint's setup (on `later`) skips keys that are already mapped.
-- stylua: ignore start
vim.keymap.set('n', 'g?v', function() load() require('chainsaw').variableLog() end, { desc = 'Variable log statement' })
vim.keymap.set('n', 'g?p', function() load() require('chainsaw').messageLog() end, { desc = 'Message log statement' })
-- stylua: ignore end
```

</details>
