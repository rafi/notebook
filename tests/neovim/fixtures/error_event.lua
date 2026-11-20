-- Fixture: error in a User RafiKeymaps callback
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	callback = function()
		error('boom event')
	end,
})
