-- Fixture: User event callback reading plugin data
vim.api.nvim_create_autocmd('User', {
	pattern = 'CopilotStatus',
	callback = function(ev)
		local kind = ev.data.status.kind
		vim.keymap.set('n', '<leader>cs', '<Nop>', { desc = 'Status ' .. kind })
	end,
})
