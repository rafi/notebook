local build = require('build')

local root = vim.uv.cwd()

local function eq(a, b, what)
	assert(
		vim.deep_equal(a, b),
		('%s: expected %s, got %s'):format(what, vim.inspect(b), vim.inspect(a))
	)
end

---@param path string
---@param content string
local function write(path, content)
	vim.fn.mkdir(vim.fs.dirname(path), 'p')
	vim.fn.writefile(vim.split(content, '\n'), path)
end

local T = {}

T.list_finds_both_kinds = function()
	local infos = build.list(vim.env.VIM_CONFIG_DIR)
	local by_name = {}
	local core = 0
	for _, info in ipairs(infos) do
		by_name[info.name] = info
		core = core + (info.kind == 'core' and 1 or 0)
	end
	assert(core >= 8, 'core files: ' .. core)
	eq(by_name.snacks and by_name.snacks.required, true, 'snacks required')
	eq(by_name.snacks.path, 'plugin/snacks.lua', 'snacks path')
	eq(by_name.conform and by_name.conform.required, false, 'conform')
	local blink = by_name['coding.blink']
	assert(blink, 'coding.blink missing')
	eq(blink.default_enabled, true, 'blink default')
	eq(blink.category, 'coding', 'blink category')
	eq(blink.path, 'lua/rafi/extras/coding/blink.lua', 'blink path')
	eq(by_name['lang.go'].default_enabled, false, 'lang.go default')
	eq(infos[1].kind, 'core', 'core files first')
end

T.deletes_only_stale_generated = function()
	local dir = vim.fn.tempname()
	write(dir .. '/extras/ui/old.md', '---\ngenerated: true\n---\nold')
	write(dir .. '/extras/ui/hand.md', '---\ntitle: Hand\n---\nhand')
	write(dir .. '/index.md', '---\ntitle: Neovim\n---\nhi')
	build.write(dir, { ['extras/ui/new.md'] = 'x\n' })
	assert(vim.uv.fs_stat(dir .. '/extras/ui/hand.md'), 'hand.md deleted')
	assert(vim.uv.fs_stat(dir .. '/index.md'), 'index.md deleted')
	assert(not vim.uv.fs_stat(dir .. '/extras/ui/old.md'), 'old.md kept')
	eq(vim.fn.readfile(dir .. '/extras/ui/new.md'), { 'x' }, 'new.md')
	vim.fn.delete(dir, 'rf')
end

T.failure_writes_nothing = function()
	local copy = vim.fn.tempname()
	local out = vim.fn.tempname()
	vim.fn.mkdir(out, 'p')
	local cp = vim.system({ 'cp', '-R', vim.env.VIM_CONFIG_DIR, copy }):wait()
	assert(cp.code == 0, cp.stderr)
	write(copy .. '/lua/rafi/extras/ui/zz-broken.lua', "-- Broken\nerror('boom')")
	local res = vim
		.system({
			'nvim',
			'--headless',
			'--clean',
			'-l',
			root .. '/tests/neovim/fixtures/run_update.lua',
			out,
		}, {
			text = true,
			env = { VIM_CONFIG_DIR = copy },
			timeout = 120000,
		})
		:wait()
	vim.fn.delete(copy, 'rf')
	local files = vim.fn.readdir(out)
	vim.fn.delete(out, 'rf')
	assert(res.code ~= 0, 'expected non-zero exit')
	assert(res.stderr:find('zz-broken.lua', 1, true), 'stderr: ' .. res.stderr)
	eq(files, {}, 'files written')
end

T.customize_has_tabs = function()
	local page = build.customize(vim.env.VIM_CONFIG_DIR)
	local _, groups = page:gsub('\n:::tabs\n', '')
	eq(groups, 3, ':::tabs groups')
	for _, name in ipairs({ 'options', 'keymaps', 'autocmds' }) do
		assert(
			page:find(('```lua [Your lua/config/%s.lua]'):format(name), 1, true),
			'user tab for ' .. name
		)
		assert(
			page:find(('```lua [Default rafi.config.%s]'):format(name), 1, true),
			'default tab for ' .. name
		)
	end
	assert(not page:find('<!--', 1, true), 'marker left in page')
	assert(page:find('\ngenerated: true\n', 1, true), 'frontmatter')
	assert(page:find('\n### ', 1, true), 'examples')
	assert(not page:lower():find('lazy.nvim', 1, true), 'lazy.nvim mention')
end

---@param name string
local function fixture(name)
	return { path = root .. '/tests/neovim/fixtures/' .. name }
end

T.timeout_is_a_failure = function()
	local saved = build.timeout
	build.timeout = 2
	local ok, results, failures =
		pcall(build.capture_all, vim.env.VIM_CONFIG_DIR, {
			fixture('hang.lua'),
		})
	build.timeout = saved
	assert(ok, results)
	eq(vim.tbl_count(results), 0, 'results')
	eq(#failures, 1, 'failures')
	assert(failures[1].err:find('timed out after 2s', 1, true), failures[1].err)
end

T.warnings_of_successful_captures_kept = function()
	local info = fixture('notify.lua')
	local results, failures = build.capture_all(vim.env.VIM_CONFIG_DIR, { info })
	eq(#failures, 0, 'failures')
	local warnings = results[info.path].warnings or ''
	assert(warnings:find('skipped, other extra is enabled', 1, true), warnings)
end

T.captures_run_outside_the_repo = function()
	local leaked = root .. '/docs-cwd-probe.txt'
	local _, failures =
		build.capture_all(vim.env.VIM_CONFIG_DIR, { fixture('cwd_write.lua') })
	local found = vim.uv.fs_stat(leaked) ~= nil
	vim.fn.delete(leaked)
	eq(#failures, 0, 'failures')
	eq(found, false, 'capture wrote into the repo')
end

return T
