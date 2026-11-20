-- Runs ONE vim-config file (an extra, a plugin/ file or config/keymaps.lua)
-- with plugins faked, and prints what it sets up as JSON on stdout.
--
-- Usage: nvim --headless --clean -l lua/capture.lua <config_dir> <file>
--
-- Nothing is installed: vim.pack.add only records its sources, rafi.pack's
-- deferred loaders run their code right away, and any plugin module is a
-- "proxy" that accepts every use. Real code runs, so keymaps set through
-- helpers, loops and event callbacks are all recorded. Any error, even in
-- deferred code or an event callback, exits 1 with the file on stderr.

local config_dir, file = _G.arg[1], _G.arg[2]

---@class docs.Keymap
---@field mode string[]
---@field lhs string
---@field desc string
---@field ft? string[]
---@field server? string

---@class docs.Capture
---@field desc string
---@field keymaps docs.Keymap[]
---@field plugins string[]
---@field lang? table

local plugins, plugin_seen = {}, {}
-- Recorded keymaps by identity (mode, normalized lhs, buffer filetype),
-- and the identity order of first set.
local maps, map_order = {}, {}
-- Filetype whose FileType autocmds are running, see fire_filetypes().
local current_ft ---@type string?

---@param src string
local function record_plugin(src)
	if not plugin_seen[src] then
		plugin_seen[src] = true
		table.insert(plugins, src)
	end
end

---@param mode string|string[]
---@return string[]
local function modes_of(mode)
	if mode == '' or mode == nil then
		return { 'n', 'v', 'o' }
	end
	return type(mode) == 'string' and { mode } or mode
end

---@param mode string
---@param lhs string
---@param ft? string[] Filetypes of a buffer-local map
local function map_key(mode, lhs, ft)
	local keys = vim.api.nvim_replace_termcodes(lhs, true, true, true)
	return table.concat({ mode, keys, ft and table.concat(ft, ',') or '' }, '\0')
end

---@param mode string|string[]
---@param lhs string
---@param opts? table
---@param extra? { server?: string, ft?: string[] }
local function record_map(mode, lhs, opts, extra)
	opts = opts or {}
	extra = extra or {}
	local buffer = opts.buffer ~= nil and opts.buffer ~= false
	local ft = extra.ft or (buffer and current_ft and { current_ft }) or nil
	for _, m in ipairs(modes_of(mode)) do
		local key = map_key(m, lhs, ft)
		if opts.desc and opts.desc ~= '' then
			if not maps[key] then
				table.insert(map_order, key)
			end
			maps[key] = {
				mode = m,
				lhs = lhs,
				desc = opts.desc,
				ft = ft,
				server = extra.server,
			}
		else
			maps[key] = nil
		end
	end
end

---@param mode string|string[]
---@param lhs string
---@param buffer boolean
local function delete_map(mode, lhs, buffer)
	for _, m in ipairs(modes_of(mode)) do
		maps[map_key(m, lhs, buffer and current_ft and { current_ft } or nil)] = nil
	end
end

-- Proxy for any plugin module: indexing with a string, calling, arithmetic
-- and concatenation all succeed. Numeric keys are nil, so ipairs() and
-- other list loops over a proxy end at once.
local proxy_mt = {}
local function proxy()
	return setmetatable({}, proxy_mt)
end
proxy_mt.__index = function(t, k)
	if type(k) == 'number' then
		return nil
	end
	local p = proxy()
	rawset(t, k, p)
	return p
end
proxy_mt.__call = proxy
proxy_mt.__concat = function()
	return ''
end
proxy_mt.__tostring = function()
	return ''
end
proxy_mt.__len = function()
	return 0
end
for _, op in ipairs({
	'__add',
	'__sub',
	'__mul',
	'__div',
	'__mod',
	'__pow',
	'__unm',
}) do
	proxy_mt[op] = function()
		return 0
	end
end
proxy_mt.__lt = function()
	return false
end
proxy_mt.__le = function()
	return false
end

-- Snacks.toggle objects map `:map(lhs)` for real (so the config can delete
-- it later), recorded as "Toggle <name>".
---@param name string
local function toggle(name)
	local t = proxy()
	rawset(t, 'map', function(self, lhs, mopts)
		mopts = mopts or {}
		vim.keymap.set(mopts.mode or 'n', lhs, function() end, {
			desc = 'Toggle ' .. name,
		})
		return self
	end)
	return t
end

---@param kind string e.g. 'line_number'
local function humanize(kind)
	local s = kind:gsub('_', ' ')
	return s:sub(1, 1):upper() .. s:sub(2)
end

local function make_snacks()
	local snacks = proxy()
	rawset(
		snacks,
		'toggle',
		setmetatable({}, {
			__call = function(_, opts)
				return toggle(type(opts) == 'table' and opts.name or 'Toggle')
			end,
			__index = function(_, kind)
				return function(a, opts)
					opts = type(a) == 'table' and a or opts
					local name = type(opts) == 'table' and opts.name
						or (kind == 'option' and type(a) == 'string' and a)
						or humanize(kind)
					return toggle(name)
				end
			end,
		})
	)
	local keymap = proxy()
	-- Snacks.keymap.set's `lsp` maps on LspAttach for matching clients, and
	-- `ft` makes buffer-local maps for those filetypes.
	rawset(keymap, 'set', function(mode, lhs, rhs, opts)
		opts = opts or {}
		local ft = type(opts.ft) == 'string' and { opts.ft } or opts.ft
		if opts.lsp then
			record_map(mode, lhs, opts, { server = opts.lsp.name or '*', ft = ft })
			return
		elseif ft then
			record_map(mode, lhs, opts, { ft = ft })
			return
		end
		vim.keymap.set(mode, lhs, rhs, opts)
	end)
	rawset(snacks, 'keymap', keymap)
	return snacks
end

---Options to fire an event on `buf`. LspAttach callbacks read
---ev.data.client_id; client 0 doesn't exist, so they find no client.
---@param buf integer
local function event_opts(buf)
	return { buffer = buf, modeline = false, data = { client_id = 0 } }
end

---Point rafi.config at a fresh-install state and the checkout's extras.
local function setup_env()
	vim.opt.rtp:prepend(config_dir)
	local defaults = require('rafi.config').defaults
	local json = vim.fn.tempname()
	vim.fn.writefile(
		{ vim.json.encode({ extras = defaults, disabled = {} }) },
		json
	)
	vim.g.rafi_json = json
	vim.g.rafi_extras_dirs = { config_dir .. '/lua/rafi/extras' }
	require('rafi.config.options')
end

local function install_stubs()
	-- rafi.pack adds mini.misc for itself at load: let that go unrecorded
	-- and uninstalled, with a mini.misc that just runs the code.
	package.loaded['mini.misc'] = {
		safely = function(_, f)
			f()
		end,
	}
	vim.pack.add = function() end
	local pack = require('rafi.pack')

	vim.pack.add = function(specs)
		for _, spec in ipairs(specs) do
			record_plugin(type(spec) == 'string' and spec or spec.src)
		end
	end
	local run = function(...)
		local f = select(select('#', ...), ...)
		f()
	end
	pack.now, pack.later, pack.on_filetype = run, run, run
	-- Run in the event it waits for (first of the list, without its
	-- `~pattern`), so <abuf> and ev.data work as in a real session.
	pack.on_event = function(spec, f)
		local event = (vim.split(spec, ',')[1]:gsub('~.*', ''))
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_create_autocmd(event, {
			buffer = buf,
			once = true,
			callback = function()
				f()
			end,
		})
		vim.api.nvim_exec_autocmds(event, event_opts(buf))
	end
	pack.command = function() end
	pack.build = function() end
	pack.has = function()
		return true
	end
	pack.dev = function(_, src)
		record_plugin(src)
	end

	-- vim.keymap.set/del call the nvim_*keymap API themselves; `inside`
	-- keeps those inner calls from being recorded twice.
	local inside = false
	local keymap_set, keymap_del = vim.keymap.set, vim.keymap.del
	vim.keymap.set = function(mode, lhs, rhs, opts)
		record_map(mode, lhs, opts)
		inside = true
		local ok, err = pcall(keymap_set, mode, lhs, rhs, opts)
		inside = false
		assert(ok, err)
	end
	vim.keymap.del = function(mode, lhs, opts)
		delete_map(mode, lhs, opts ~= nil and opts.buffer ~= nil)
		inside = true
		local ok, err = pcall(keymap_del, mode, lhs, opts)
		inside = false
		assert(ok, err)
	end
	local api = vim.api
	local set, buf_set = api.nvim_set_keymap, api.nvim_buf_set_keymap
	local del, buf_del = api.nvim_del_keymap, api.nvim_buf_del_keymap
	api.nvim_set_keymap = function(mode, lhs, rhs, opts)
		if not inside then
			record_map(mode, lhs, opts)
		end
		return set(mode, lhs, rhs, opts)
	end
	api.nvim_buf_set_keymap = function(buf, mode, lhs, rhs, opts)
		if not inside then
			record_map(mode, lhs, vim.tbl_extend('force', opts, { buffer = buf }))
		end
		return buf_set(buf, mode, lhs, rhs, opts)
	end
	api.nvim_del_keymap = function(mode, lhs)
		if not inside then
			delete_map(mode, lhs, false)
		end
		return del(mode, lhs)
	end
	api.nvim_buf_del_keymap = function(buf, mode, lhs)
		if not inside then
			delete_map(mode, lhs, true)
		end
		return buf_del(buf, mode, lhs)
	end

	-- nvim_exec_autocmds only reports errors in Lua callbacks, so wrap each
	-- callback to fail the capture instead.
	local create_autocmd = api.nvim_create_autocmd
	api.nvim_create_autocmd = function(event, opts)
		local cb = opts.callback
		if type(cb) == 'function' then
			opts = vim.tbl_extend('force', opts, {
				callback = function(ev)
					local ok, ret = xpcall(cb, debug.traceback, ev)
					if not ok then
						io.stderr:write(('%s: %s\n'):format(file, ret))
						os.exit(1)
					end
					return ret
				end,
			})
		end
		return create_autocmd(event, opts)
	end

	-- Ex commands of plugins don't exist without the plugins, skip them.
	local cmd = vim.cmd
	local function check(ok, err)
		local msg = tostring(err)
		if
			not ok
			and not msg:find('E492', 1, true)
			and not msg:find('Command not found', 1, true)
		then
			error(err, 0)
		end
	end
	vim.cmd = setmetatable({}, {
		__call = function(_, ...)
			check(pcall(cmd, ...))
		end,
		__index = function(_, name)
			return function(...)
				check(pcall(cmd[name], ...))
			end
		end,
	})

	-- Any module not found, outside rafi.* and vim.*, is a plugin: a proxy.
	-- So are undefined globals starting with a capital, like MiniMap.
	_G.Snacks = make_snacks()
	setmetatable(_G, {
		__index = function(_, k)
			if type(k) == 'string' and k:match('^%u') then
				local p = proxy()
				rawset(_G, k, p)
				return p
			end
		end,
	})
	table.insert(package.loaders, function(name)
		if name:match('^rafi%.') or name:match('^vim%.') then
			return nil
		end
		return function()
			return name == 'snacks' and _G.Snacks or proxy()
		end
	end)
end

---Set each filetype the file's FileType autocmds match on a scratch buffer,
---so buffer-local maps they set are recorded with that filetype.
local function fire_filetypes()
	local fts = {}
	for _, au in ipairs(vim.api.nvim_get_autocmds({ event = 'FileType' })) do
		for _, ft in ipairs(vim.split(au.pattern or '', ',', { trimempty = true })) do
			if not ft:find('*', 1, true) and not vim.list_contains(fts, ft) then
				table.insert(fts, ft)
			end
		end
	end
	table.sort(fts)
	for _, ft in ipairs(fts) do
		local buf = vim.api.nvim_create_buf(true, true)
		current_ft = ft
		vim.api.nvim_buf_call(buf, function()
			vim.bo[buf].filetype = ft
		end)
		current_ft = nil
	end
end

local function fire_events()
	vim.api.nvim_exec_autocmds('User', { pattern = 'RafiKeymaps' })
	for _, event in ipairs({
		'VimEnter',
		'UIEnter',
		'BufReadPre',
		'BufNewFile',
		'InsertEnter',
		'CmdlineEnter',
		'LspAttach',
	}) do
		vim.api.nvim_exec_autocmds(
			event,
			event_opts(vim.api.nvim_get_current_buf())
		)
	end
	fire_filetypes()
end

---What the file registered with rafi.util.lang, if anything.
---@return table?
local function read_lang()
	local lang = package.loaded['rafi.util.lang']
	if not lang then
		return
	end
	local servers = {}
	for name, on in pairs(lang.servers) do
		if on then
			table.insert(servers, name)
		end
	end
	table.sort(servers)
	local parsers = vim.tbl_keys(lang.parsers)
	table.sort(parsers)
	local formatters = {}
	for ft, list in pairs(lang.formatters_by_ft) do
		formatters[ft] = { unpack(list) }
	end
	local server_names = vim.tbl_keys(lang.keys)
	table.sort(server_names)
	for _, server in ipairs(server_names) do
		for _, k in ipairs(lang.keys[server]) do
			record_map(k.mode or 'n', k[1], k, { server = server })
		end
	end
	local ret = {
		servers = servers,
		tools = lang.tools,
		parsers = parsers,
		linters_by_ft = lang.linters_by_ft,
		formatters_by_ft = formatters,
	}
	if
		#servers + #lang.tools + #parsers == 0
		and vim.tbl_isempty(lang.linters_by_ft)
		and vim.tbl_isempty(formatters)
	then
		return nil
	end
	return ret
end

---Recorded maps, one row per lhs/desc/ft/server with their modes merged.
---@return docs.Keymap[]
local function keymaps()
	local rows, by_id = {}, {}
	for _, key in ipairs(map_order) do
		local m = maps[key]
		if m then
			local id = table.concat({
				m.lhs,
				m.desc,
				m.ft and m.ft[1] or '',
				m.server or '',
			}, '\0')
			local row = by_id[id]
			if not row then
				row = { lhs = m.lhs, desc = m.desc, ft = m.ft, server = m.server }
				row.mode = {}
				by_id[id] = row
				table.insert(rows, row)
			end
			if not vim.list_contains(row.mode, m.mode) then
				table.insert(row.mode, m.mode)
				table.sort(row.mode)
			end
		end
	end
	return rows
end

---Record repository URLs quoted in the file, in source order. Plugins a
---file adds inside a function that runs on first use (a keymap, a command)
---are never added during the capture. A quoted URL of exactly
---host/owner/repo is a plugin source; longer URLs and comments are not.
local function record_quoted_repos()
	local text = table.concat(vim.fn.readfile(file), '\n')
	local pattern = '[\'"](https://[%w%.%-]+/[%w%._%-]+/[%w%._%-]+)[\'"]'
	for url in text:gmatch(pattern) do
		record_plugin(url)
	end
end

local function main()
	local first = vim.fn.readfile(file, '', 1)[1] or ''
	if not first:match('^%-%-') then
		error('missing description line', 0)
	end
	setup_env()
	install_stubs()
	dofile(file)
	fire_events()
	record_quoted_repos()
	local lang = read_lang()
	---@type docs.Capture
	local ret = {
		desc = vim.trim((first:gsub('^%-%-+', ''))),
		keymaps = keymaps(),
		plugins = plugins,
		lang = lang,
	}
	io.stdout:write(vim.json.encode(ret))
end

local ok, err = xpcall(main, debug.traceback)
if not ok then
	io.stderr:write(('%s: %s\n'):format(file, err))
	os.exit(1)
end
os.exit(0)
