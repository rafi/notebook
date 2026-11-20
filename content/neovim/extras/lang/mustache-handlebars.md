---
title: "lang.mustache-handlebars"
description: "Mustache and Handlebars syntax, indent and ftplugin"
published: true
generated: true
kind: "extra"
category: "lang"
---

Mustache and Handlebars syntax, indent and ftplugin

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.mustache-handlebars"] }
```

## Plugins

- [vim-mustache-handlebars](https://github.com/mustache/vim-mustache-handlebars)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/mustache-handlebars.lua"
-- Mustache and Handlebars syntax, indent and ftplugin

-- Added at startup so its filetype detection runs before files open.
vim.pack.add({ 'https://github.com/mustache/vim-mustache-handlebars' })
```

</details>
