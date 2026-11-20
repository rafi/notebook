-- Turns captured vim-config files (see lua/capture.lua) into mdsvex 1.0
-- Markdown pages for content/neovim/.

local M = {}

---@class docs.FileInfo
---@field kind 'extra'|'core'
---@field name string 'ui.deadcolumn' or 'snacks'
---@field category? string 'ui', extras only
---@field path string Repo-relative, 'lua/rafi/extras/ui/deadcolumn.lua'
---@field default_enabled boolean Extra enabled on a fresh install
---@field required boolean Core file that can't be disabled

local mode_letters = {
	n = '𝐍',
	v = '𝐕',
	x = '𝐗',
	s = '𝐒',
	i = '𝐈',
	o = '𝐎',
	c = '𝐂',
	t = '𝐓',
}

local specials = {
	['|'] = '&#124;',
	['{'] = '&#123;',
	['}'] = '&#125;',
	['<'] = '&lt;',
}

---Escape text that Markdown tables or Svelte would read as syntax: | ends a
---cell, { } start a Svelte expression, < starts a tag. `code spans` are
---left alone, mdsvex escapes those itself.
---@param text string
---@return string
function M.escape(text)
	local parts = vim.split(text, '`', { plain = true })
	for i = 1, #parts, 2 do
		parts[i] = parts[i]:gsub('[|{}<]', specials)
	end
	return table.concat(parts, '`')
end

local kbd_chars = vim.tbl_extend('force', specials, {
	['>'] = '&gt;',
	['`'] = '&#96;',
})

---Render a keymap's lhs as <kbd> keys: <C-n> is one key, other characters
---are one key each.
---@param lhs string
---@return string
function M.kbd(lhs)
	local out = {}
	local i = 1
	while i <= #lhs do
		local name = lhs:match('^<([^<>%s]+)>', i)
		local key
		if name then
			key = name
			i = i + #name + 2
		else
			-- One UTF-8 character.
			local len = vim.str_utf_end(lhs, i) + 1
			key = lhs:sub(i, i + len - 1)
			i = i + len
		end
		out[#out + 1] = '<kbd>' .. key:gsub('[|{}<>`]', kbd_chars) .. '</kbd>'
	end
	return table.concat(out)
end

---@param map docs.Keymap
---@return string
local function describe(map)
	local desc = M.escape(map.desc)
	if map.ft then
		desc = ('%s _(in %s buffers)_'):format(desc, table.concat(map.ft, ', '))
	end
	if map.server then
		local server = map.server == '*' and 'any LSP' or map.server
		desc = ('%s _(with %s)_'):format(desc, server)
	end
	return desc
end

---@param maps docs.Keymap[]
---@return string[] lines Table header, separator and one row per keymap
function M.keymap_table(maps)
	local lines = { '| Key | Description | Mode |', '| --- | --- | --- |' }
	for _, map in ipairs(maps) do
		local modes = vim.tbl_map(function(m)
			return mode_letters[m] or m
		end, map.mode)
		lines[#lines + 1] = ('| %s | %s | %s |'):format(
			M.kbd(map.lhs),
			describe(map),
			table.concat(modes, ' ')
		)
	end
	return lines
end

---A :::tabs code group, one tab per item, labelled in the fence.
---@param items { label: string, lang: string, code: string }[]
---@return string[]
function M.tabs(items)
	local lines = { ':::tabs' }
	for _, item in ipairs(items) do
		vim.list_extend(lines, {
			('```%s [%s]'):format(item.lang, item.label),
			(item.code:gsub('\n+$', '')),
			'```',
		})
	end
	lines[#lines + 1] = ':::'
	return lines
end

---YAML frontmatter. Strings are JSON-encoded, which YAML reads as
---double-quoted strings.
---@param fields [string, any][]
---@return string[]
local function frontmatter(fields)
	local lines = { '---' }
	for _, f in ipairs(fields) do
		local k, v = f[1], f[2]
		if v ~= nil then
			if type(v) == 'string' then
				v = vim.json.encode(v)
			end
			lines[#lines + 1] = ('%s: %s'):format(k, tostring(v))
		end
	end
	lines[#lines + 1] = '---'
	return lines
end

local extras_cmd = '`:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>)'

---@param info docs.FileInfo
---@return string[]
local function toggle_section(info)
	if info.kind == 'core' then
		if info.required then
			return {
				'## Disable',
				'',
				("`%s` can't be disabled: keymaps, the statusline and many extras use it."):format(
					info.name
				),
			}
		end
		return {
			'## Disable',
			'',
			'This core plugin always loads. To turn it off, add it to `disabled` in'
				.. ' your `rafi.json`. You can then replace it with your own file in'
				.. ' `lua/plugins/`.',
			'',
			'```json',
			('{ "disabled": ["%s"] }'):format(info.name),
			'```',
		}
	end
	if info.default_enabled then
		return {
			'## Disable',
			'',
			('This extra is enabled on a fresh install. Turn it off with %s, or'):format(
				extras_cmd
			)
				.. (' remove `"%s"` from `extras` in your `rafi.json`.'):format(
					info.name
				),
		}
	end
	return {
		'## Enable',
		'',
		('Turn it on with %s, or add it to `extras` in your `rafi.json`:'):format(
			extras_cmd
		),
		'',
		'```json',
		('{ "extras": ["%s"] }'):format(info.name),
		'```',
	}
end

---@param list string[]
local function codes(list)
	return table.concat(
		vim.tbl_map(function(s)
			return '`' .. s .. '`'
		end, list),
		', '
	)
end

---@param by_ft table<string, string[]>
local function codes_by_ft(by_ft)
	local fts = vim.tbl_keys(by_ft)
	table.sort(fts)
	return table.concat(
		vim.tbl_map(function(ft)
			return ('%s _(%s)_'):format(codes(by_ft[ft]), ft)
		end, fts),
		', '
	)
end

---@param lang table
---@return string[]
local function lang_section(lang)
	local lines = { '## Language support', '' }
	local function item(label, value)
		if value ~= '' then
			lines[#lines + 1] = ('- %s: %s'):format(label, value)
		end
	end
	item('LSP servers', codes(lang.servers))
	item('Tools installed with Mason', codes(lang.tools))
	item('Tree-sitter parsers', codes(lang.parsers))
	item('Linters', codes_by_ft(lang.linters_by_ft))
	item('Formatters', codes_by_ft(lang.formatters_by_ft))
	return lines
end

---@param plugins string[]
---@return string[]
local function plugins_section(plugins)
	local lines = { '## Plugins', '' }
	for _, url in ipairs(plugins) do
		local name = url:gsub('%.git$', ''):match('([^/]+)$')
		lines[#lines + 1] = ('- [%s](%s)'):format(name, url)
	end
	return lines
end

---@param path string
---@param source string
---@return string[]
local function source_section(path, source)
	local fence = source:find('```', 1, true) and '````' or '```'
	return {
		'<details>',
		'<summary>Source</summary>',
		'',
		('%slua title="%s"'):format(fence, path),
		(source:gsub('\n+$', '')),
		fence,
		'',
		'</details>',
	}
end

---A page for one extra or core plugin file.
---@param cap docs.Capture
---@param info docs.FileInfo
---@param source string The file's contents
---@return string
function M.page(cap, info, source)
	local is_extra = info.kind == 'extra'
	local sections = {
		frontmatter({
			{ 'title', info.name },
			{ 'description', cap.desc },
			{ 'published', true },
			{ 'generated', true },
			{ 'kind', info.kind },
			{ 'category', is_extra and info.category or nil },
			{ 'default_enabled', is_extra and info.default_enabled or nil },
		}),
		{ M.escape(cap.desc) },
		toggle_section(info),
	}
	if #cap.keymaps > 0 then
		local lines = { '## Keymaps', '' }
		sections[#sections + 1] =
			vim.list_extend(lines, M.keymap_table(cap.keymaps))
	end
	if cap.lang then
		sections[#sections + 1] = lang_section(cap.lang)
	end
	if #cap.plugins > 0 then
		sections[#sections + 1] = plugins_section(cap.plugins)
	end
	sections[#sections + 1] = source_section(info.path, source)
	return M.join(sections)
end

---Join sections of lines with a blank line between them, ending in a
---newline. The frontmatter block is the first section.
---@param sections string[][]
---@return string
function M.join(sections)
	return table.concat(
		vim.tbl_map(function(lines)
			return table.concat(lines, '\n')
		end, sections),
		'\n\n'
	) .. '\n'
end

---The core keymaps page, from a capture of lua/rafi/config/keymaps.lua.
---@param cap docs.Capture
---@return string
function M.keymaps_page(cap)
	return M.join({
		frontmatter({
			{ 'title', 'Keymaps' },
			{ 'description', 'Keymaps vim-config sets, without any extras' },
			{ 'published', true },
			{ 'generated', true },
		}),
		{
			'These are set by `lua/rafi/config/keymaps.lua` on every install.'
				.. " Extras add their own: see each extra's page. Your"
				.. ' `lua/config/keymaps.lua` loads after this file, so it can'
				.. ' change or delete any of them.',
		},
		M.keymap_table(cap.keymaps),
	})
end

---Split a Lua file into examples. Each starts at a `-- ## Title` line; the
---comment lines right after it are the description, the rest up to the next
---title is the code.
---@param src string
---@return { title: string, desc: string, code: string }[]
function M.parse_examples(src)
	local blocks = {}
	local block ---@type { title: string, desc: string[], code: string[] }?
	local in_desc = false
	for _, line in ipairs(vim.split(src, '\n', { plain = true })) do
		local title = line:match('^%-%- ## (.+)$')
		if title then
			block = { title = vim.trim(title), desc = {}, code = {} }
			blocks[#blocks + 1] = block
			in_desc = true
		elseif block then
			local comment = in_desc and line:match('^%-%- ?(.*)$')
			if comment then
				table.insert(block.desc, vim.trim(comment))
			else
				in_desc = false
				table.insert(block.code, line)
			end
		end
	end
	return vim.tbl_map(function(b)
		return {
			title = b.title,
			desc = table.concat(b.desc, ' '),
			code = (table.concat(b.code, '\n'):gsub('^\n+', ''):gsub('\n+$', '')),
		}
	end, blocks)
end

return M
