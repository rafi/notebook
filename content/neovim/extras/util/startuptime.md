---
title: "util.startuptime"
description: "Measure startup time (vim-startuptime)"
published: true
generated: true
kind: "extra"
category: "util"
---

Measure startup time (vim-startuptime)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["util.startuptime"] }
```

## Plugins

- [vim-startuptime](https://github.com/dstein64/vim-startuptime)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/util/startuptime.lua"
-- Measure startup time (vim-startuptime)
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.g.startuptime_tries = 10
	vim.pack.add({ 'https://github.com/dstein64/vim-startuptime' })
end

-- The stub only loads the plugin, which defines :StartupTime.
require('rafi.pack').command('StartupTime', load, {
	nargs = '*',
	range = true,
	bang = true,
})
```

</details>
