---
title: "ui.smear-cursor"
description: "Animates cursor movement with a smear effect (smear-cursor.nvim)"
published: true
generated: true
kind: "extra"
category: "ui"
---

Animates cursor movement with a smear effect (smear-cursor.nvim)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["ui.smear-cursor"] }
```

## Plugins

- [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/ui/smear-cursor.lua"
-- Animates cursor movement with a smear effect (smear-cursor.nvim)
-- Skipped in Neovide, which animates the cursor natively.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ui/smear-cursor.lua
if vim.g.neovide then
	return
end

require('rafi.pack').later(function()
	vim.pack.add({ 'https://github.com/sphamba/smear-cursor.nvim' })
	require('smear_cursor').setup({
		hide_target_hack = true,
		cursor_color = 'none',
	})
end)
```

</details>
