-- Fixture: a loader that only runs from a keymap
local function load()
	vim.api.nvim_create_autocmd('User', {
		pattern = 'XReady',
		callback = function()
			vim.keymap.set('n', '<leader>xr', '<Nop>', { desc = 'Ready' })
		end,
	})
end
vim.keymap.set('n', '<leader>xo', function()
	load()
end, { desc = 'Open' })
vim.keymap.set('n', '<leader>q', function()
	vim.cmd('quit')
	vim.cmd.qa()
end, { desc = 'Quit' })
