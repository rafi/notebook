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

return T
