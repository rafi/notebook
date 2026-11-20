-- Fixture: maps in deferred code and events
local pack = require('rafi.pack')
pack.later(function()
	vim.keymap.set('n', '<leader>l', '<Nop>', { desc = 'Later' })
end)
pack.on_event('BufReadPre', function()
	vim.keymap.set('n', '<leader>e', '<Nop>', { desc = 'Event' })
end)
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	callback = function()
		vim.keymap.set('n', '<leader>k', '<Nop>', { desc = 'Keymaps' })
	end,
})
