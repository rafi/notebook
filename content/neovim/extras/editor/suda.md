---
title: "editor.suda"
description: "Read or write files with sudo (:SudaRead, :SudaWrite)"
published: true
generated: true
kind: "extra"
category: "editor"
---

Read or write files with sudo (:SudaRead, :SudaWrite)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.suda"] }
```

## Plugins

- [vim-suda](https://github.com/lambdalisue/vim-suda)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/suda.lua"
-- Read or write files with sudo (:SudaRead, :SudaWrite)
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/lambdalisue/vim-suda' })
end)
```

</details>
