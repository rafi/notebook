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
---@field unreached integer[] Lines setting keymaps that never ran
---@field warnings? string What the file printed to stderr (set by build)

local plugins, plugin_seen = {}, {}
-- Recorded keymaps by identity (mode, normalized lhs, buffer filetype),
-- and the identity order of first set.
local maps, map_order = {}, {}
-- Filetype whose FileType autocmds are running, see fire_filetypes().
local current_ft ---@type string?
-- LSP server whose LspAttach is firing, see fire_lsp_attach().
local current_server ---@type string?
-- Code the config defers (vim.schedule, command stubs' loaders), run by
-- flush() after the events.
local deferred = {} ---@type fun()[]
-- Code that may set keymaps but runs only on demand: loaders a keymap
-- calls, hooks a plugin calls with a buffer. run_probes() tries each once
-- after the events, ignoring errors, since it runs with made-up arguments.
-- Keymap functions themselves never run: they do real user actions.
local probes, probe_seen = {}, {} ---@type fun()[], table<function, true>
local probing = false

---@param f function
local function add_probe(f)
	if not probe_seen[f] then
		probe_seen[f] = true
		table.insert(probes, f)
	end
end

---Whether keymap opts make a buffer-local map (`buffer` or `buf`).
---@param opts? table
local function is_buffer(opts)
	return opts ~= nil
		and ((opts.buffer ~= nil and opts.buffer ~= false) or opts.buf ~= nil)
end

---@param src string
local function record_plugin(src)
	if not plugin_seen[src] then
		plugin_seen[src] = true
		table.insert(plugins, src)
	end
end

-- Modes that stand for several: '' is n, v, o; v is x and s; ! is i, c.
local mode_parts = {
	[''] = { 'n', 'x', 's', 'o' },
	v = { 'x', 's' },
	['!'] = { 'i', 'c' },
}

---@param mode? string|string[]
---@return string[]
local function modes_of(mode)
	local ret = {}
	for _, m in ipairs(type(mode) == 'table' and mode or { mode or '' }) do
		vim.list_extend(ret, mode_parts[m] or { m })
	end
	return ret
end

---@param mode string
---@param lhs string
---@param ft? string[] Filetypes of a buffer-local map
---@param server? string LSP server of a buffer-local map
local function map_key(mode, lhs, ft, server)
	local keys = vim.api.nvim_replace_termcodes(lhs, true, true, true)
	local ft_key = ft and table.concat(ft, ',') or ''
	return table.concat({ mode, keys, ft_key, server or '' }, '\0')
end

---@param mode string|string[]
---@param lhs string
---@param opts? table
---@param extra? { server?: string, ft?: string[] }
local function record_map(mode, lhs, opts, extra)
	opts = opts or {}
	extra = extra or {}
	local buffer = is_buffer(opts)
	local ft = extra.ft or (buffer and current_ft and { current_ft }) or nil
	local server = extra.server or (buffer and current_server) or nil
	for _, m in ipairs(modes_of(mode)) do
		local key = map_key(m, lhs, ft, server)
		if opts.desc and opts.desc ~= '' then
			if not maps[key] then
				table.insert(map_order, key)
			end
			maps[key] = {
				mode = m,
				lhs = lhs,
				desc = opts.desc,
				ft = ft,
				server = server,
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
		local ft = buffer and current_ft and { current_ft } or nil
		maps[map_key(m, lhs, ft, buffer and current_server or nil)] = nil
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
---Whether a function in plugin options is a hook the plugin calls with a
---buffer: on_attach and other on_*, *hook*, or any function in a *hooks
---table (committia_hooks.edit_open).
---@param key string
---@param parent? string
local function is_hook(key, parent)
	return key:match('^on_') ~= nil
		or key:lower():find('hook', 1, true) ~= nil
		or (parent ~= nil and parent:lower():find('hooks', 1, true) ~= nil)
end

---Probe the hooks in options a plugin gets (setup) or in vim.g. Hooks take
---(client, buf), (buf) or (buf, win): try (buf, buf), then (buf, win).
---@param value any
---@param parent? string Key of the table holding `value`
---@param depth integer
local function collect_hooks(value, parent, depth)
	if type(value) ~= 'table' or getmetatable(value) == proxy_mt or depth > 3 then
		return
	end
	for k, v in pairs(value) do
		if type(k) == 'string' and type(v) == 'function' and is_hook(k, parent) then
			add_probe(function()
				local buf = vim.api.nvim_create_buf(true, true)
				if not pcall(v, buf, buf) then
					v(buf, vim.api.nvim_get_current_win())
				end
			end)
		elseif type(v) == 'table' then
			collect_hooks(v, type(k) == 'string' and k or parent, depth + 1)
		end
	end
end

---Probe the loaders a keymap function calls: its upvalues named load*
---(`local function load()` in an extra, or a helper's `.load`).
---@param rhs function
local function collect_loaders(rhs)
	for i = 1, math.huge do
		local name, value = debug.getupvalue(rhs, i)
		if not name then
			return
		end
		if type(value) == 'function' and name:match('^load') then
			add_probe(value)
		end
	end
end

proxy_mt.__call = function(_, ...)
	for i = 1, select('#', ...) do
		collect_hooks(select(i, ...), nil, 1)
	end
	return proxy()
end
-- A proxy concatenates as '', keeping the other side ('Status ' .. proxy).
proxy_mt.__concat = function(a, b)
	return (type(a) == 'table' and '' or tostring(a))
		.. (type(b) == 'table' and '' or tostring(b))
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
	-- Snacks.setup: its toggle.map option is the hook Snacks maps toggles
	-- with. Probe it once with a map that isn't recorded (no desc).
	rawset(snacks, 'setup', function(opts)
		collect_hooks(opts, nil, 1)
		local map = type(opts) == 'table'
			and type(opts.toggle) == 'table'
			and opts.toggle.map
		if type(map) == 'function' then
			add_probe(function()
				map('n', '<Plug>(docs-probe)', function() end, {})
			end)
		end
	end)
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
	-- Built-in ftplugins set keymaps (markdown's gO, ]] and [[) when the
	-- capture sets a filetype. They aren't the config's.
	vim.cmd('filetype plugin indent off')
	-- Pin what the config checks about the machine, so pages don't depend
	-- on where they're built: inside tmux, every tool installed.
	vim.env.TMUX = vim.env.TMUX or 'docs'
	vim.fn.executable = function()
		return 1
	end
	-- Deferred work runs after the events instead, see flush().
	vim.schedule = function(f)
		table.insert(deferred, f)
	end
	-- Hooks set in vim.g (committia_hooks.edit_open, rustaceanvim's
	-- server.on_attach) are probed like hooks in plugin options.
	local g = vim.g
	vim.g = setmetatable({}, {
		__index = function(_, k)
			return g[k]
		end,
		__newindex = function(_, k, v)
			collect_hooks(v, type(k) == 'string' and k or nil, 1)
			g[k] = v
		end,
	})
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
	-- Real stub commands, so a loader that deletes its stubs works.
	pack.command = function(names, load)
		names = type(names) == 'string' and { names } or names
		for _, name in ipairs(names) do
			vim.api.nvim_create_user_command(name, function() end, { nargs = '*' })
		end
		table.insert(deferred, load)
	end
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
		-- A plugin's function as rhs (gs.next_hunk) is a proxy here.
		if type(rhs) == 'table' then
			rhs = function() end
		elseif type(rhs) == 'function' then
			collect_loaders(rhs)
		end
		inside = true
		local ok, err = pcall(keymap_set, mode, lhs, rhs, opts)
		inside = false
		assert(ok, err)
	end
	vim.keymap.del = function(mode, lhs, opts)
		delete_map(mode, lhs, is_buffer(opts))
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
	-- callback to fail the capture instead. Event data fields the capture
	-- doesn't set (a plugin's User event payload) read as proxies.
	local data_mt = {
		__index = function(_, k)
			return type(k) ~= 'number' and proxy() or nil
		end,
	}
	local create_autocmd = api.nvim_create_autocmd
	api.nvim_create_autocmd = function(event, opts)
		local cb = opts.callback
		if type(cb) == 'function' then
			opts = vim.tbl_extend('force', opts, {
				callback = function(ev)
					if ev.data == nil or type(ev.data) == 'table' then
						ev.data = setmetatable(ev.data or {}, data_mt)
					end
					local ok, ret = xpcall(cb, debug.traceback, ev)
					if not ok then
						-- A probe's error is the probe's: let run_probes() drop it.
						if probing then
							error(ret, 0)
						end
						io.stderr:write(('%s: %s\n'):format(file, ret))
						os.exit(1)
					end
					return ret
				end,
			})
		end
		return create_autocmd(event, opts)
	end

	-- Plugins' Tree-sitter queries (textobjects…) aren't installed.
	local query_get = vim.treesitter.query.get
	vim.treesitter.query.get = function(lang, name)
		return query_get(lang, name) or proxy()
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

---Run deferred work until none is left (deferred code can defer more).
local function flush()
	for _ = 1, 10 do
		if #deferred == 0 then
			return
		end
		local queue = deferred
		deferred = {}
		for _, f in ipairs(queue) do
			f()
		end
	end
end

-- Filetypes with a parser bundled with Neovim, to fire FileType autocmds
-- that have no pattern (they often check for a parser first).
local any_filetypes = { 'c', 'vim', 'query', 'lua', 'markdown' }

---Set each filetype the file's FileType autocmds match on a scratch buffer,
---so buffer-local maps they set are recorded with that filetype. Autocmds
---without a pattern fire once more on a filetype none of the others match,
---and their buffer-local maps get no filetype.
local function fire_filetypes()
	local fts, any = {}, false
	for _, au in ipairs(vim.api.nvim_get_autocmds({ event = 'FileType' })) do
		for _, ft in ipairs(vim.split(au.pattern or '*', ',', { trimempty = true })) do
			if ft == '*' then
				any = true
			elseif not ft:find('*', 1, true) and not vim.list_contains(fts, ft) then
				table.insert(fts, ft)
			end
		end
	end
	table.sort(fts)
	local function set(ft, tag)
		local buf = vim.api.nvim_create_buf(true, true)
		current_ft = tag
		vim.api.nvim_buf_call(buf, function()
			vim.bo[buf].filetype = ft
		end)
		current_ft = nil
		flush()
	end
	for _, ft in ipairs(fts) do
		set(ft, ft)
	end
	if any then
		for _, ft in ipairs(any_filetypes) do
			if not vim.list_contains(fts, ft) then
				set(ft, nil)
				break
			end
		end
	end
end

---Fire LspAttach once per server the file registers, with a stand-in
---client of that name, so callbacks checking `client.name` set their
---keymaps. Buffer-local maps they set are recorded with the server.
local function fire_lsp_attach()
	local lang = package.loaded['rafi.util.lang']
	if not lang then
		return
	end
	local names =
		vim.tbl_keys(vim.tbl_extend('force', {}, lang.servers, lang.keys))
	table.sort(names)
	local clients = {}
	vim.lsp.get_client_by_id = function(id)
		return clients[id]
	end
	for i, name in ipairs(names) do
		local client = proxy()
		rawset(client, 'id', i)
		rawset(client, 'name', name)
		rawset(client, 'supports_method', function()
			return true
		end)
		clients[i] = client
		local buf = vim.api.nvim_create_buf(true, true)
		current_server = name
		vim.api.nvim_exec_autocmds('LspAttach', {
			buffer = buf,
			modeline = false,
			data = { client_id = i },
		})
		flush()
		current_server = nil
	end
end

-- User events already fired, see fire_user_events().
local fired_user = { RafiKeymaps = true }

---Fire each User event the config listens for (MiniFilesBufferCreate…)
---once, as the plugin would.
local function fire_user_events()
	for _, au in ipairs(vim.api.nvim_get_autocmds({ event = 'User' })) do
		if au.pattern and not fired_user[au.pattern] then
			fired_user[au.pattern] = true
			vim.api.nvim_exec_autocmds('User', {
				pattern = au.pattern,
				data = { buf_id = vim.api.nvim_get_current_buf() },
			})
			flush()
		end
	end
end

---Try each probe once (see `probes`), then fire User events and run work
---their code registered. Probes can add probes, so repeat a few rounds.
local function run_probes()
	local tried = 0
	for _ = 1, 3 do
		if tried == #probes then
			return
		end
		probing = true
		for i = tried + 1, #probes do
			pcall(probes[i])
			pcall(flush)
		end
		tried = #probes
		pcall(fire_user_events)
		probing = false
	end
end

local function fire_events()
	vim.api.nvim_exec_autocmds('User', { pattern = 'RafiKeymaps' })
	for _, event in ipairs({
		'VimEnter',
		'UIEnter',
		'BufReadPre',
		'BufReadPost',
		'BufNewFile',
		'BufEnter',
		'BufWinEnter',
		'InsertEnter',
		'CmdlineEnter',
		'LspAttach',
	}) do
		vim.api.nvim_exec_autocmds(
			event,
			event_opts(vim.api.nvim_get_current_buf())
		)
	end
	flush()
	fire_user_events()
	fire_lsp_attach()
	fire_filetypes()
	run_probes()
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

---Recorded maps, one row per lhs/desc/server with their modes and buffer
---filetypes merged. which-key's `which_key_ignore` marks hidden maps.
---@return docs.Keymap[]
local function keymaps()
	local rows, by_id = {}, {}
	for _, key in ipairs(map_order) do
		local m = maps[key]
		if m and m.desc ~= 'which_key_ignore' then
			local id = table.concat({
				m.lhs,
				m.desc,
				m.ft and 'ft' or '',
				m.server or '',
			}, '\0')
			local row = by_id[id]
			if not row then
				row = { lhs = m.lhs, desc = m.desc, server = m.server, mode = {} }
				by_id[id] = row
				table.insert(rows, row)
			end
			if not vim.list_contains(row.mode, m.mode) then
				table.insert(row.mode, m.mode)
				table.sort(row.mode)
			end
			for _, ft in ipairs(m.ft or {}) do
				row.ft = row.ft or {}
				if not vim.list_contains(row.ft, ft) then
					table.insert(row.ft, ft)
					table.sort(row.ft)
				end
			end
		end
	end
	return rows
end

---Record repository URLs quoted inside vim.pack.add() and pack.dev() calls,
---in source order, comments left out. Plugins a file adds inside a function
---that runs on first use (a keymap, a command) are never added during the
---capture. A quoted URL of exactly host/owner/repo is a plugin source.
local function record_quoted_repos()
	local lines = vim.tbl_map(function(line)
		return (line:gsub('%-%-.*$', ''))
	end, vim.fn.readfile(file))
	local text = table.concat(lines, '\n')
	local url = '[\'"](https://[%w%.%-]+/[%w%._%-]+/[%w%._%-]+)[\'"]'
	local calls = {} ---@type { pos: integer, args: string }[]
	for _, call in ipairs({ 'pack%.add%s*()(%b())', '%.dev%s*()(%b())' }) do
		for pos, args in text:gmatch(call) do
			table.insert(calls, { pos = pos, args = args })
		end
	end
	table.sort(calls, function(a, b)
		return a.pos < b.pos
	end)
	for _, call in ipairs(calls) do
		for src in call.args:gmatch(url) do
			record_plugin(src)
		end
	end
end

-- Lines of `file` that ran during the capture, see run_traced().
local ran = {} ---@type table<integer, true>

---Run f with a line hook that records which lines of `file` run.
---@param f fun()
local function run_traced(f)
	local source = '@' .. file
	debug.sethook(function(_, line)
		if debug.getinfo(2, 'S').source == source then
			ran[line] = true
		end
	end, 'l')
	local ok, err = pcall(f)
	debug.sethook()
	if not ok then
		error(err, 0)
	end
end

---Lines of `file` that set a keymap (vim.keymap.set, Snacks.keymap.set, a
---toggle's :map()) but never ran, so their keymaps aren't on the page. A
---call whose options are a table without `desc` is skipped: that keymap
---wouldn't be listed anyway.
---@return integer[]
local function unreached()
	local lines = vim.fn.readfile(file)
	local ret = {}
	for i, line in ipairs(lines) do
		if
			not ran[i]
			and not line:match('^%s*%-%-')
			and (line:find('keymap%.set%s*%(') or line:find(':map%s*%('))
		then
			local rest = table.concat(lines, '\n', i)
			local args = rest:match('keymap%.set%s*(%b())')
				or rest:match(':map%s*(%b())')
				or ''
			if not (args:find('{', 1, true) and not args:find('desc', 1, true)) then
				table.insert(ret, i)
			end
		end
	end
	return ret
end

local function main()
	local first = vim.fn.readfile(file, '', 1)[1] or ''
	if not first:match('^%-%-') then
		error('missing description line', 0)
	end
	setup_env()
	install_stubs()
	run_traced(function()
		dofile(file)
		fire_events()
	end)
	record_quoted_repos()
	local lang = read_lang()
	---@type docs.Capture
	local ret = {
		desc = vim.trim((first:gsub('^%-%-+', ''))),
		keymaps = keymaps(),
		plugins = plugins,
		lang = lang,
		unreached = unreached(),
	}
	io.stdout:write(vim.json.encode(ret))
end

local ok, err = xpcall(main, debug.traceback)
if not ok then
	io.stderr:write(('%s: %s\n'):format(file, err))
	os.exit(1)
end
os.exit(0)
