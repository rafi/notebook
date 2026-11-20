---
title: "util.gh"
description: "GitHub code review inside Neovim (gh.nvim, needs the `gh` CLI)"
published: true
generated: true
kind: "extra"
category: "util"
---

GitHub code review inside Neovim (gh.nvim, needs the `gh` CLI)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["util.gh"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>leader</kbd><kbd>G</kbd><kbd>c</kbd><kbd>c</kbd> | Close | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>c</kbd><kbd>e</kbd> | Expand | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>c</kbd><kbd>o</kbd> | Open To | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>c</kbd><kbd>p</kbd> | Pop Out | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>c</kbd><kbd>z</kbd> | Collapse | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>i</kbd><kbd>p</kbd> | Preview | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>i</kbd><kbd>o</kbd> | Open | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>l</kbd><kbd>t</kbd> | Toggle Panel | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>p</kbd><kbd>c</kbd> | Close | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>p</kbd><kbd>d</kbd> | Details | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>p</kbd><kbd>e</kbd> | Expand | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>p</kbd><kbd>o</kbd> | Open | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>p</kbd><kbd>p</kbd> | PopOut | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>p</kbd><kbd>r</kbd> | Refresh | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>p</kbd><kbd>t</kbd> | Open To | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>p</kbd><kbd>z</kbd> | Collapse | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>r</kbd><kbd>b</kbd> | Begin | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>r</kbd><kbd>c</kbd> | Close | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>r</kbd><kbd>d</kbd> | Delete | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>r</kbd><kbd>e</kbd> | Expand | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>r</kbd><kbd>s</kbd> | Submit | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>r</kbd><kbd>z</kbd> | Collapse | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>t</kbd><kbd>c</kbd> | Create | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>t</kbd><kbd>n</kbd> | Next | 𝐍 |
| <kbd>leader</kbd><kbd>G</kbd><kbd>t</kbd><kbd>t</kbd> | Toggle | 𝐍 |

## Plugins

- [litee.nvim](https://github.com/ldelossa/litee.nvim)
- [gh.nvim](https://github.com/ldelossa/gh.nvim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/util/gh.lua"
-- GitHub code review inside Neovim (gh.nvim, needs the `gh` CLI)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/util/gh.lua

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/ldelossa/litee.nvim',
		'https://github.com/ldelossa/gh.nvim',
	})
	require('litee.lib').setup()
	require('litee.gh').setup({})
end

-- Commands come from setup(), so keys load the plugin first.
local function map(lhs, cmd, desc)
	vim.keymap.set('n', lhs, function()
		load()
		vim.cmd(cmd)
	end, { desc = desc })
end

-- stylua: ignore start
map('<leader>Gcc', 'GHCloseCommit',    'Close')
map('<leader>Gce', 'GHExpandCommit',   'Expand')
map('<leader>Gco', 'GHOpenToCommit',   'Open To')
map('<leader>Gcp', 'GHPopOutCommit',   'Pop Out')
map('<leader>Gcz', 'GHCollapseCommit', 'Collapse')
map('<leader>Gip', 'GHPreviewIssue',   'Preview')
map('<leader>Gio', 'GHOpenIssue',      'Open')
map('<leader>Glt', 'LTPanel',          'Toggle Panel')
map('<leader>Gpc', 'GHClosePR',        'Close')
map('<leader>Gpd', 'GHPRDetails',      'Details')
map('<leader>Gpe', 'GHExpandPR',       'Expand')
map('<leader>Gpo', 'GHOpenPR',         'Open')
map('<leader>Gpp', 'GHPopOutPR',       'PopOut')
map('<leader>Gpr', 'GHRefreshPR',      'Refresh')
map('<leader>Gpt', 'GHOpenToPR',       'Open To')
map('<leader>Gpz', 'GHCollapsePR',     'Collapse')
map('<leader>Grb', 'GHStartReview',    'Begin')
map('<leader>Grc', 'GHCloseReview',    'Close')
map('<leader>Grd', 'GHDeleteReview',   'Delete')
map('<leader>Gre', 'GHExpandReview',   'Expand')
map('<leader>Grs', 'GHSubmitReview',   'Submit')
map('<leader>Grz', 'GHCollapseReview', 'Collapse')
map('<leader>Gtc', 'GHCreateThread',   'Create')
map('<leader>Gtn', 'GHNextThread',     'Next')
map('<leader>Gtt', 'GHToggleThread',   'Toggle')
-- stylua: ignore end

require('rafi.util.mini').on_which_key(function()
	require('which-key').add({
		{ '<leader>G', group = 'Github' },
		{ '<leader>Gc', group = 'Commits' },
		{ '<leader>Gi', group = 'Issues' },
		{ '<leader>Gl', group = 'Litee' },
		{ '<leader>Gp', group = 'Pull Request' },
		{ '<leader>Gr', group = 'Review' },
		{ '<leader>Gt', group = 'Threads' },
	})
end)
```

</details>
