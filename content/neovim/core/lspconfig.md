---
title: "lspconfig"
description: "Quickstart configs for Nvim LSP, with mason-lspconfig and SchemaStore"
published: true
generated: true
kind: "core"
---

Quickstart configs for Nvim LSP, with mason-lspconfig and SchemaStore

## Disable

This core plugin always loads. To turn it off, add it to `disabled` in your `rafi.json`. You can then replace it with your own file in `lua/plugins/`.

```json
{ "disabled": ["lspconfig"] }
```

## Keymaps

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>g</kbd><kbd>d</kbd> | Goto Definition _(with any LSP)_ | 𝐍 |
| <kbd>g</kbd><kbd>r</kbd> | References _(with any LSP)_ | 𝐍 |
| <kbd>g</kbd><kbd>I</kbd> | Goto Implementation _(with any LSP)_ | 𝐍 |
| <kbd>g</kbd><kbd>y</kbd> | Goto T[y]pe Definition _(with any LSP)_ | 𝐍 |
| <kbd>g</kbd><kbd>D</kbd> | Goto Declaration _(with any LSP)_ | 𝐍 |
| <kbd>K</kbd> | Hover _(with any LSP)_ | 𝐍 |
| <kbd>g</kbd><kbd>K</kbd> | Signature Help _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>a</kbd> | Code Action _(with any LSP)_ | 𝐍 𝐗 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>c</kbd> | Run Codelens _(with any LSP)_ | 𝐍 𝐗 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>C</kbd> | Refresh & Display Codelens _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>R</kbd> | Rename File _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>r</kbd> | Rename _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>A</kbd> | Source Action _(with any LSP)_ | 𝐍 |
| <kbd>]</kbd><kbd>]</kbd> | Next Reference _(with any LSP)_ | 𝐍 |
| <kbd>[</kbd><kbd>[</kbd> | Prev Reference _(with any LSP)_ | 𝐍 |
| <kbd>a-n</kbd> | Next Reference _(with any LSP)_ | 𝐍 |
| <kbd>a-p</kbd> | Prev Reference _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>o</kbd> | Organize Imports _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>s</kbd><kbd>s</kbd> | LSP Symbols _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>s</kbd><kbd>S</kbd> | LSP Workspace Symbols _(with any LSP)_ | 𝐍 |
| <kbd>g</kbd><kbd>a</kbd><kbd>i</kbd> | C[a]lls Incoming _(with any LSP)_ | 𝐍 |
| <kbd>g</kbd><kbd>a</kbd><kbd>o</kbd> | C[a]lls Outgoing _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>l</kbd><kbd>i</kbd> | Incoming calls _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>l</kbd><kbd>o</kbd> | Outgoing calls _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>i</kbd><kbd>w</kbd><kbd>a</kbd> | Add Workspace Folders _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>i</kbd><kbd>w</kbd><kbd>r</kbd> | Remove Workspace Folder _(with any LSP)_ | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>i</kbd><kbd>w</kbd><kbd>l</kbd> | List Workspace Folders _(with any LSP)_ | 𝐍 |

## Plugins

- [mason.nvim](https://github.com/mason-org/mason.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim)
- [SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim)

<details>
<summary>Source</summary>

```lua title="plugin/lspconfig.lua"
-- Quickstart configs for Nvim LSP, with mason-lspconfig and SchemaStore
if require('rafi.config').disabled('lspconfig') then
	return
end

-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/snacks_picker.lua

-- Per-server settings live in after/lsp/<server>.lua, language servers and
-- their keys are registered by lua/rafi/extras/lang/<lang>.lua
local pack = require('rafi.pack')

pack.on_event('BufReadPre,BufNewFile', function()
	local lsp = require('rafi.util.lsp')
	-- mason prepends its bin directory to $PATH, before servers start.
	lsp.mason()
	vim.pack.add({
		'https://github.com/neovim/nvim-lspconfig',
		'https://github.com/mason-org/mason-lspconfig.nvim',
		-- Lua-only data, required from jsonls/yamlls before_init.
		'https://github.com/b0o/SchemaStore.nvim',
	})

	local icons = require('rafi.util.icons')
	local lang = require('rafi.util.lang')

	local function words_enabled()
		return Snacks.words.is_enabled()
	end

	-- stylua: ignore
	---@type rafi.lsp.Keys[]
	local keys = {
		{ 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition', has = 'definition' },
		{ 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
		{ 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
		{ 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
		{ 'gD', vim.lsp.buf.declaration, desc = 'Goto Declaration' },
		{ 'K', function() return vim.lsp.buf.hover() end, desc = 'Hover' },
		{ 'gK', function() return vim.lsp.buf.signature_help() end, desc = 'Signature Help', has = 'signatureHelp' },
		{ '<leader>ca', vim.lsp.buf.code_action, desc = 'Code Action', mode = { 'n', 'x' }, has = 'codeAction' },
		{ '<leader>cc', vim.lsp.codelens.run, desc = 'Run Codelens', mode = { 'n', 'x' }, has = 'codeLens' },
		{ '<leader>cC', vim.lsp.codelens.refresh, desc = 'Refresh & Display Codelens', mode = { 'n' }, has = 'codeLens' },
		{ '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File', mode = { 'n' }, has = { 'workspace/didRenameFiles', 'workspace/willRenameFiles' } },
		{ '<leader>cr', vim.lsp.buf.rename, desc = 'Rename', has = 'rename' },
		{ '<leader>cA', lsp.action.source, desc = 'Source Action', has = 'codeAction' },
		{ ']]', function() Snacks.words.jump(vim.v.count1) end, has = 'documentHighlight', desc = 'Next Reference', enabled = words_enabled },
		{ '[[', function() Snacks.words.jump(-vim.v.count1) end, has = 'documentHighlight', desc = 'Prev Reference', enabled = words_enabled },
		{ '<a-n>', function() Snacks.words.jump(vim.v.count1, true) end, has = 'documentHighlight', desc = 'Next Reference', enabled = words_enabled },
		{ '<a-p>', function() Snacks.words.jump(-vim.v.count1, true) end, has = 'documentHighlight', desc = 'Prev Reference', enabled = words_enabled },
		{
			'<leader>co',
			lsp.action['source.organizeImports'],
			desc = 'Organize Imports',
			has = 'codeAction',
			enabled = function(buf)
				local code_actions = vim.tbl_filter(function(action)
					return action:find('^source%.organizeImports%.?$')
				end, lsp.code_actions({ bufnr = buf }))
				return #code_actions > 0
			end,
		},
		{ '<leader>ss', function() Snacks.picker.lsp_symbols({ filter = icons.kind_filter }) end, desc = 'LSP Symbols', has = 'documentSymbol' },
		{ '<leader>sS', function() Snacks.picker.lsp_workspace_symbols({ filter = icons.kind_filter }) end, desc = 'LSP Workspace Symbols', has = 'workspace/symbols' },
		{ 'gai', function() Snacks.picker.lsp_incoming_calls() end, desc = 'C[a]lls Incoming', has = 'callHierarchy/incomingCalls' },
		{ 'gao', function() Snacks.picker.lsp_outgoing_calls() end, desc = 'C[a]lls Outgoing', has = 'callHierarchy/outgoingCalls' },
		{ '<leader>cli', vim.lsp.buf.incoming_calls, desc = 'Incoming calls' },
		{ '<leader>clo', vim.lsp.buf.outgoing_calls, desc = 'Outgoing calls' },
		{ '<leader>ciwa', vim.lsp.buf.add_workspace_folder, desc = 'Add Workspace Folders' },
		{ '<leader>ciwr', vim.lsp.buf.remove_workspace_folder, desc = 'Remove Workspace Folder' },
		{ '<leader>ciwl', '<cmd>lua =vim.lsp.buf.list_workspace_folders()<CR>', desc = 'List Workspace Folders' },
	}

	lsp.setup({
		diagnostics = {
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 4,
				source = true,
				prefix = 'icons',
			},
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
					[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
					[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
					[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
				},
			},
		},
		inlay_hints = {
			enabled = false,
			exclude = { 'vue' }, -- filetypes to not enable inlay hints
		},
		codelens = { enabled = false },
		folds = { enabled = true },
		-- Default config for all servers
		config = {
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
		},
		-- Enabled servers (mason-lspconfig installs them, if known).
		-- Disabled ones are excluded from mason-lspconfig's automatic_enable.
		servers = vim.tbl_extend('force', lang.servers, {
			lua_ls = true,
			stylua = false,
		}),
		-- Extras' '*' keys come after the core ones, so they win.
		keys = vim.tbl_extend('force', lang.keys, {
			['*'] = vim.list_extend(keys, lang.keys['*'] or {}),
		}),
	})
end)
```

</details>
