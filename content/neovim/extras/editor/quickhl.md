---
title: "editor.quickhl"
description: "Highlight words quickly"
published: true
generated: true
kind: "extra"
category: "editor"
---

Highlight words quickly

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.quickhl"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>m</kbd><kbd>t</kbd> | Highlight word | 𝐍 𝐗 |

## Plugins

- [vim-quickhl](https://github.com/t9md/vim-quickhl)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/quickhl.lua"
-- Highlight words quickly
local loaded = false
local function load()
	if not loaded then
		loaded = true
		vim.pack.add({ 'https://github.com/t9md/vim-quickhl' })
	end
end

-- The <Plug> maps only exist once the plugin is sourced, so load it first
-- and then feed the <Plug> map (still in visual mode for 'x').
vim.keymap.set({ 'n', 'x' }, '<leader>mt', function()
	load()
	vim.api.nvim_feedkeys(vim.keycode('<Plug>(quickhl-manual-this)'), 'm', false)
end, { desc = 'Highlight word' })
```

</details>
