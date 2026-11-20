-- Fixture: keymap set in vim.schedule
vim.schedule(function()
	vim.keymap.set('n', '<leader>sc', '<Nop>', { desc = 'Scheduled' })
end)
