---
title: "editor.auto-session"
description: "Automatically save and restore sessions"
published: true
generated: true
kind: "extra"
category: "editor"
default_enabled: true
---

Automatically save and restore sessions

## Disable

This extra is enabled on a fresh install. Turn it off with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or remove `"editor.auto-session"` from `extras` in your `rafi.json`.

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>localleader</kbd><kbd>s</kbd> | Session search | 𝐍 |

## Plugins

- [auto-session](https://github.com/rmagatti/auto-session)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/editor/auto-session.lua"
-- Automatically save and restore sessions

if vim.g.started_by_firenvim or vim.g.vscode then
	return
end

-- Eager: session restore happens on VimEnter.
vim.pack.add({ 'https://github.com/rmagatti/auto-session' })

---@module "auto-session"
---@type AutoSession.Config
require('auto-session').setup({
	-- allowed_dirs = { '~/**' },
	suppressed_dirs = { vim.env.TMPDIR or '/tmp', '/private/tmp' },
	root_dir = vim.fn.stdpath('state') .. '/sessions/',
	session_lens = {
		session_control = {
			control_dir = vim.fn.stdpath('state') .. '/auto_session/',
		},
	},
})

-- stylua: ignore start
vim.keymap.set('n', '<localleader>s', '<cmd>AutoSession search<CR>', { desc = 'Session search' })
-- stylua: ignore end
```

</details>
