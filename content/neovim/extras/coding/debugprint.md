---
title: "coding.debugprint"
description: "Debugging in NeoVim the print() way"
published: true
generated: true
kind: "extra"
category: "coding"
---

Debugging in NeoVim the print() way

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["coding.debugprint"] }
```

## Plugins

- [debugprint.nvim](https://github.com/andrewferrier/debugprint.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/coding/debugprint.lua"
-- Debugging in NeoVim the print() way
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/andrewferrier/debugprint.nvim' })

	-- Setup creates the g?o g?O g?v g?V g?p g?P, g?sp g?sv g?so (surround)
	-- and [G ]G (first/last debug print) keymaps, skipping keys that are
	-- already mapped (coding.chainsaw's g?v/g?p).
	require('debugprint').setup({
		keymaps = {
			normal = {
				plain_below = 'g?p',
				plain_above = 'g?P',
				variable_below = 'g?v',
				variable_above = 'g?V',
				variable_below_alwaysprompt = false,
				variable_above_alwaysprompt = false,
				textobj_below = 'g?o',
				textobj_above = 'g?O',
				toggle_comment_debug_prints = false,
				delete_debug_prints = false,
				-- NOTE: Conflict: core gitsigns' ]g/[g (hunk aliases) win.
				jump_prev_debug_print = false, -- '[g'
				jump_next_debug_print = false, -- ']g'
				jump_first_debug_print = '[G',
				jump_last_debug_print = ']G',
			},
			insert = {
				plain = false, -- '<C-G>p',
				variable = false, -- '<C-G>v',
			},
			visual = {
				variable_below = false, -- 'g?v',
				variable_above = false, -- 'g?V',
			},
		},
	})
end)
```

</details>
