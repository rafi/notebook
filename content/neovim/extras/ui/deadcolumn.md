---
title: "ui.deadcolumn"
description: "Show colorcolumn dynamically"
published: true
generated: true
kind: "extra"
category: "ui"
---

Show colorcolumn dynamically

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["ui.deadcolumn"] }
```

## Plugins

- [deadcolumn.nvim](https://github.com/Bekaboo/deadcolumn.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/ui/deadcolumn.lua"
-- Show colorcolumn dynamically
local pack = require('rafi.pack')

pack.on_event('BufReadPre,BufNewFile', function()
	-- Its plugin/ calls setup() with defaults, so call it again with opts.
	vim.pack.add({ 'https://github.com/Bekaboo/deadcolumn.nvim' })
	require('deadcolumn').setup({ scope = 'visible' })
end)
```

</details>
