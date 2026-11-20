---
title: "editor.helpful"
description: "Display vim version numbers in docs (:HelpfulVersion)"
published: true
generated: true
kind: "extra"
category: "editor"
---

Display vim version numbers in docs (:HelpfulVersion)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["editor.helpful"] }
```

## Plugins

- [helpful.vim](https://github.com/tweekmonster/helpful.vim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/helpful.lua"
-- Display vim version numbers in docs (:HelpfulVersion)
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/tweekmonster/helpful.vim' })
end)
```

</details>
