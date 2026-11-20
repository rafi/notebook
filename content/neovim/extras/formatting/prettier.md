---
title: "formatting.prettier"
description: "Formatter: prettier, for web, markdown, yaml and more (only if it has a parser)"
published: true
generated: true
kind: "extra"
category: "formatting"
---

Formatter: prettier, for web, markdown, yaml and more (only if it has a parser)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["formatting.prettier"] }
```

## Language support

- Tools installed with Mason: `prettier`
- Formatters: `prettier` _(css)_, `prettier` _(graphql)_, `prettier` _(handlebars)_, `prettier` _(html)_, `prettier` _(javascript)_, `prettier` _(javascriptreact)_, `prettier` _(json)_, `prettier` _(jsonc)_, `prettier` _(less)_, `prettier` _(markdown)_, `prettier` _(markdown.mdx)_, `prettier` _(scss)_, `prettier` _(typescript)_, `prettier` _(typescriptreact)_, `prettier` _(vue)_, `prettier` _(yaml)_

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/formatting/prettier.lua"
-- Formatter: prettier, for web, markdown, yaml and more (only if it has a parser)
-- Set `vim.g.prettier_needs_config = true` in lua/config/options.lua to only
-- format when a prettier config file is found.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/formatting/prettier.lua
local format = require('rafi.util.format')
local lang = require('rafi.util.lang')

---@class rafi.prettier.Ctx
---@field buf integer
---@field filename string
---@field dirname string

-- Filetypes prettier always supports without asking the prettier CLI.
local supported = {
	'css',
	'graphql',
	'handlebars',
	'html',
	'javascript',
	'javascriptreact',
	'json',
	'jsonc',
	'less',
	'markdown',
	'markdown.mdx',
	'scss',
	'typescript',
	'typescriptreact',
	'vue',
	'yaml',
}

-- Cache results per file, since each check runs the prettier CLI.
---@param fn fun(ctx: rafi.prettier.Ctx): any
---@return fun(ctx: rafi.prettier.Ctx): any
local function memoize(fn)
	local cache = {}
	return function(ctx)
		local key = ctx.filename
		if cache[key] == nil then
			cache[key] = { fn(ctx) }
		end
		return unpack(cache[key])
	end
end

-- Is there a prettier config file for this file?
local has_config = memoize(function(ctx)
	vim.fn.system({ 'prettier', '--find-config-path', ctx.filename })
	return vim.v.shell_error == 0
end)

-- Can prettier format this file? Asks the prettier CLI for filetypes
-- not in `supported`.
local has_parser = memoize(function(ctx)
	local ft = vim.bo[ctx.buf].filetype
	if vim.tbl_contains(supported, ft) then
		return true
	end
	local ret = vim.fn.system({ 'prettier', '--file-info', ctx.filename })
	local ok, parser = pcall(function()
		return vim.fn.json_decode(ret).inferredParser
	end)
	return ok and parser and parser ~= vim.NIL
end)

-- Append prettier to each supported filetype's formatters.
local by_ft = {}
for _, ft in ipairs(supported) do
	local current = lang.formatters_by_ft[ft]
		or format.opts.formatters_by_ft[ft]
		or {}
	local list = vim.list_extend({}, type(current) == 'table' and current or {})
	if not vim.tbl_contains(list, 'prettier') then
		table.insert(list, 'prettier')
	end
	by_ft[ft] = list
end

lang.add({
	tools = { 'prettier' },
	formatters_by_ft = by_ft,
})

format.opts.formatters = format.opts.formatters or {}
format.opts.formatters.prettier = {
	condition = function(_, ctx)
		return has_parser(ctx)
			and (vim.g.prettier_needs_config ~= true or has_config(ctx))
	end,
}
```

</details>
