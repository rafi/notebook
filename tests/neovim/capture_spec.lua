local root = vim.uv.cwd()
local fixtures = root .. '/tests/neovim/fixtures/'

---Run lua/capture.lua on a fixture.
---@param name string Fixture file name
---@param opts? vim.SystemOpts Extra vim.system options, e.g. env
---@return integer code, table? capture, string stderr
local function capture(name, opts)
	local res = vim
		.system({
			'nvim',
			'--headless',
			'--clean',
			'-l',
			root .. '/lua/capture.lua',
			vim.env.VIM_CONFIG_DIR,
			fixtures .. name,
		}, vim.tbl_extend('force', { text = true, timeout = 30000 }, opts or {}))
		:wait()
	local ok, data = pcall(vim.json.decode, res.stdout or '')
	return res.code, ok and data or nil, res.stderr or ''
end

---@return table capture
local function ok_capture(name, opts)
	local code, data, stderr = capture(name, opts)
	assert(code == 0, ('exit %d: %s'):format(code, stderr))
	assert(data, 'no JSON on stdout')
	return data
end

---@param maps table[]
---@return table<string, table> by lhs
local function by_lhs(maps)
	local ret = {}
	for _, m in ipairs(maps) do
		ret[m.lhs] = ret[m.lhs] or {}
		table.insert(ret[m.lhs], m)
	end
	return ret
end

local function eq(a, b, what)
	assert(
		vim.deep_equal(a, b),
		('%s: expected %s, got %s'):format(what, vim.inspect(b), vim.inspect(a))
	)
end

local T = {}

T.records_toplevel_and_loop = function()
	local c = ok_capture('toplevel_loop.lua')
	eq(c.desc, 'Fixture: top-level maps and a loop', 'desc')
	eq(c.plugins, { 'https://github.com/x/y' }, 'plugins')
	local lhs = vim.tbl_map(function(m)
		return m.lhs
	end, c.keymaps)
	eq(
		lhs,
		{ '<leader>H', '<localleader>1', '<localleader>2', '<localleader>3' },
		'lhs'
	)
	eq(c.keymaps[1].desc, 'Add', 'desc of <leader>H')
	eq(c.keymaps[1].mode, { 'n' }, 'mode')
end

T.deferred_and_events = function()
	local m = by_lhs(ok_capture('deferred.lua').keymaps)
	assert(m['<leader>l'], 'pack.later map missing')
	assert(m['<leader>e'], 'pack.on_event map missing')
	assert(m['<leader>k'], 'User RafiKeymaps map missing')
end

T.filetype_buffer_maps = function()
	local m = by_lhs(ok_capture('filetype.lua').keymaps)
	assert(m['<leader>cj'], 'FileType map missing')
	eq(m['<leader>cj'][1].ft, { 'go' }, 'ft')
	eq(m['<leader>cj'][1].desc, 'JSON to struct', 'desc')
end

T.lang_registry = function()
	local c = ok_capture('lang.lua')
	assert(c.lang, 'lang missing')
	eq(c.lang.servers, { 'gopls' }, 'servers')
	eq(c.lang.tools, { 'gofumpt' }, 'tools')
	eq(c.lang.parsers, { 'templ' }, 'parsers')
	eq(c.lang.formatters_by_ft, { go = { 'goimports' } }, 'formatters')
	local m = by_lhs(c.keymaps)
	assert(m.gD, 'lang key missing')
	eq(m.gD[1].server, 'gopls', 'server')
	eq(m.gD[1].desc, 'Def', 'desc')
end

T.snacks_toggle_names = function()
	local m = by_lhs(ok_capture('snacks_toggle.lua').keymaps)
	eq(m['<leader>uw'] and m['<leader>uw'][1].desc, 'Toggle Wrap', 'wrap')
	eq(
		m['<leader>ul'] and m['<leader>ul'][1].desc,
		'Toggle Line number',
		'line_number'
	)
end

T.snacks_maps_are_real_and_ft = function()
	local m = by_lhs(ok_capture('snacks_toggle.lua').keymaps)
	eq(m['<leader>wm'], nil, 'deleted toggle map')
	local cu = m['<leader>cu'] and m['<leader>cu'][1]
	assert(cu, 'Snacks.keymap.set ft map missing')
	eq(cu.ft, { 'lua' }, 'ft')
	eq(cu.mode, { 'n', 'x' }, 'mode')
end

T.remap_and_delete = function()
	local m = by_lhs(ok_capture('remap_delete.lua').keymaps)
	eq(#(m['<leader>a'] or {}), 2, 'rows for <leader>a in n and x')
	eq(#(m['<leader>b'] or {}), 1, 'rows for remapped <leader>b')
	eq(m['<leader>b'][1].desc, 'Last B', 'remapped desc')
	eq(m['<leader>c'], nil, 'deleted map')
end

T.no_desc_omitted = function()
	local m = by_lhs(ok_capture('no_desc.lua').keymaps)
	eq(m['<leader>z'], nil, 'map without desc')
	assert(m['<leader>y'], 'map with desc missing')
end

T.proxy_iteration_terminates = function()
	ok_capture('proxy_iter.lua')
end

T.error_in_event_fails = function()
	for _, name in ipairs({ 'error_later.lua', 'error_event.lua' }) do
		local code, _, stderr = capture(name)
		assert(code ~= 0, name .. ': expected non-zero exit')
		assert(stderr:find(name, 1, true), name .. ': stderr: ' .. stderr)
	end
end

T.missing_description_fails = function()
	local code, _, stderr = capture('no_description.lua')
	assert(code ~= 0, 'expected non-zero exit')
	assert(stderr:find('missing description line', 1, true), stderr)
end

-- Patterns found running vim-config's real files.

T.lsp_attach_has_data = function()
	ok_capture('lsp_attach.lua')
end

T.on_event_runs_in_event = function()
	ok_capture('abuf_event.lua')
end

T.plugin_globals_are_proxies = function()
	ok_capture('plugin_global.lua')
end

T.snacks_lsp_keys_record_server = function()
	local m = by_lhs(ok_capture('lsp_keys.lua').keymaps)
	eq(m.gd and m.gd[1].server, '*', 'any-LSP key')
	eq(m.gO and m.gO[1].server, 'gopls', 'named-LSP key')
end

T.plugin_commands_are_ignored = function()
	local m = by_lhs(ok_capture('plugin_cmd.lua').keymaps)
	assert(m['<leader>q'], 'code after plugin commands did not run')
end

T.lazy_plugins_listed = function()
	eq(ok_capture('lazy_plugin.lua').plugins, {
		'https://github.com/c/eager',
		'https://github.com/a/lazy.nvim',
		'https://codeberg.org/b/dep',
	}, 'plugins')
end

-- Findings of the final review.

T.runtime_ftplugin_maps_not_recorded = function()
	eq(ok_capture('ftplugin.lua').keymaps, {}, 'keymaps')
end

T.environment_is_pinned = function()
	local env = { PATH = vim.env.PATH, HOME = vim.env.HOME }
	local c = ok_capture('env_gated.lua', { env = env, clear_env = true })
	assert(by_lhs(c.keymaps)['<leader>gt'], 'TMUX/executable-gated map missing')
end

T.on_attach_is_called = function()
	local m = by_lhs(ok_capture('on_attach.lua').keymaps)
	assert(m[']h'], 'on_attach map missing')
end

T.command_load_runs_and_user_events_fire = function()
	local m = by_lhs(ok_capture('command_load.lua').keymaps)
	assert(m['<leader>fr'], 'map from command load + User event missing')
end

T.wildcard_filetype_fires = function()
	local m = by_lhs(ok_capture('wildcard_filetype.lua').keymaps)
	assert(m[']f'], 'pattern-less FileType map missing')
	eq(m[']f'][1].ft, nil, 'no filetype note for any-filetype map')
end

T.lsp_attach_per_server = function()
	local m = by_lhs(ok_capture('lsp_client.lua').keymaps)
	assert(m['<leader>co'], 'jdtls LspAttach map missing')
	eq(m['<leader>co'][1].server, 'jdtls', 'server')
end

T.scheduled_callbacks_run = function()
	assert(by_lhs(ok_capture('scheduled.lua').keymaps)['<leader>sc'], 'missing')
end

T.buf_option_is_buffer_local = function()
	local m = by_lhs(ok_capture('buf_opt.lua').keymaps)
	eq(m.gO and m.gO[1].ft, { 'go' }, 'ft')
end

T.unreached_keymap_calls_reported = function()
	eq(ok_capture('unreached.lua').unreached, { 4 }, 'unreached lines')
end

T.proxy_rhs_is_mapped = function()
	assert(by_lhs(ok_capture('proxy_rhs.lua').keymaps)[']h'], 'missing')
end

T.user_event_data_is_a_proxy = function()
	assert(by_lhs(ok_capture('user_data.lua').keymaps)['<leader>cs'], 'missing')
end

T.command_stubs_exist_for_loader = function()
	assert(
		by_lhs(ok_capture('command_stub.lua').keymaps)['<leader>fi'],
		'missing'
	)
end

T.missing_treesitter_query_is_a_proxy = function()
	assert(by_lhs(ok_capture('ts_query.lua').keymaps)[']m'], 'missing')
end

-- Deferred minors of the first review.

T.which_key_ignore_omitted = function()
	local m = by_lhs(ok_capture('which_key_ignore.lua').keymaps)
	eq(m['<c-_>'], nil, 'which_key_ignore row')
	assert(m['<leader>k'], 'other map missing')
end

T.filetype_rows_merged = function()
	local m = by_lhs(ok_capture('ft_rows.lua').keymaps)
	eq(#(m['<leader>cj'] or {}), 1, 'rows')
	eq(m['<leader>cj'][1].ft, { 'go', 'templ' }, 'filetypes')
end

T.visual_and_default_modes_split = function()
	local m = by_lhs(ok_capture('modes.lua').keymaps)
	eq(m['<leader>v'] and m['<leader>v'][1].mode, { 's' }, 'v minus x')
	eq(m['<leader>e'] and m['<leader>e'][1].mode, { 'n', 'o', 's', 'x' }, "''")
	eq(m['<C-x>'] and m['<C-x>'][1].mode, { 'c', 'i' }, '!')
end

T.plugins_only_from_pack_calls = function()
	eq(
		ok_capture('plugin_scan.lua').plugins,
		{ 'https://github.com/c/real' },
		'plugins'
	)
end

T.keymap_loaders_run = function()
	local m = by_lhs(ok_capture('rhs_loader.lua').keymaps)
	assert(m['<leader>xr'], 'map set after a keymap-run loader missing')
	assert(m['<leader>q'], 'quitting rhs ended the capture')
end

T.hooks_are_called = function()
	local c = ok_capture('hooks.lua')
	local m = by_lhs(c.keymaps)
	assert(m['<leader>eo'], 'vim.g hook map missing')
	assert(m['<leader>cR'], 'vim.g server.on_attach map missing')
	assert(m['<Esc>'], 'setup hook map missing')
	eq(c.unreached, {}, 'unreached')
end

T.snacks_toggle_map_hook_runs = function()
	local c = ok_capture('snacks_hook.lua')
	eq(c.unreached, {}, 'unreached')
	eq(c.keymaps, {}, 'probe recorded as a keymap')
end

T.unreached_ignores_maps_without_desc = function()
	eq(ok_capture('unreached_no_desc.lua').unreached, { 5, 6 }, 'unreached')
end

T.unreached_keeps_mode_lists_and_toggles = function()
	eq(ok_capture('unreached_shapes.lua').unreached, { 5, 6 }, 'unreached')
end

T.probes_skip_user_action_callbacks = function()
	local dir = vim.fn.tempname()
	vim.fn.mkdir(dir, 'p')
	ok_capture('probe_safety.lua', { cwd = dir })
	local written = vim.fn.readdir(dir)
	vim.fn.delete(dir, 'rf')
	eq(written, {}, 'files written by probes')
end

return T
