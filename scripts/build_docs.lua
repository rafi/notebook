-- Builds content/neovim from rafi/vim-config. Run with `just neovim`.
-- Based on lazyvim.github.io's scripts/build_docs.lua (Apache-2.0):
-- https://github.com/LazyVim/lazyvim.github.io/blob/main/scripts/build_docs.lua

local root = vim.fn.fnamemodify('./.nvim', ':p')

-- Keep every stdpath inside .nvim/, for this Neovim and the capture
-- children it starts.
for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
	vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end

vim.opt.rtp:append('.')

local ok, err = xpcall(function()
	require('build').update()
end, debug.traceback)
if not ok then
	io.stderr:write(tostring(err) .. '\n')
	os.exit(1)
end
os.exit(0)
