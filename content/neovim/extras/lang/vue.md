---
title: "lang.vue"
description: "Vue: vue_ls (hybrid mode) plus vtsls with @vue/typescript-plugin"
published: true
generated: true
kind: "extra"
category: "lang"
---

Vue: vue_ls (hybrid mode) plus vtsls with @vue/typescript-plugin

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.vue"] }
```

## Language support

- LSP servers: `vtsls`, `vue_ls`
- Tools installed with Mason: `vue-language-server`

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/vue.lua"
-- Vue: vue_ls (hybrid mode) plus vtsls with @vue/typescript-plugin
-- The vtsls plugin and `vue` filetype are set in after/lsp/vtsls.lua. Enable
-- lang.typescript too for vtsls keymaps.
require('rafi.util.lang').add({
	servers = {
		vue_ls = true,
		vtsls = true,
	},
	tools = { 'vue-language-server' },
})
```

</details>
