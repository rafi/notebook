-- Test runner for the Neovim docs generator.
-- Usage: nvim --headless --clean -l tests/neovim/run.lua [spec files...]
--
-- Each tests/neovim/*_spec.lua returns a table of test name -> function.
-- A test fails when its function errors. Exits 1 on any failure.

local root = vim.uv.cwd()
package.path = ('%s/lua/?.lua;%s'):format(root, package.path)

-- Specs read the vim-config checkout from $VIM_CONFIG_DIR, and child
-- Neovims they start inherit it. An existing .nvim/vim-config is used as
-- is (no network); it's cloned only when missing.
if not vim.env.VIM_CONFIG_DIR then
	local checkout = root .. '/.nvim/vim-config'
	if vim.uv.fs_stat(checkout) then
		vim.env.VIM_CONFIG_DIR = checkout
	else
		vim.env.VIM_CONFIG_DIR = require('source').ensure().dir
	end
end

local files = _G.arg and #_G.arg > 0 and _G.arg
	or vim.fn.glob(root .. '/tests/neovim/*_spec.lua', false, true)

local failed, passed = 0, 0
for _, file in ipairs(files) do
	local tests = dofile(file)
	local names = vim.tbl_keys(tests)
	table.sort(names)
	for _, name in ipairs(names) do
		local ok, err = xpcall(tests[name], debug.traceback)
		if ok then
			passed = passed + 1
			print('PASS ' .. name)
		else
			failed = failed + 1
			print(('FAIL %s: %s'):format(name, err))
		end
	end
end

print(('%d passed, %d failed'):format(passed, failed))
os.exit(failed > 0 and 1 or 0)
