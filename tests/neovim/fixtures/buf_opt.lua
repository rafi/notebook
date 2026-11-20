-- Fixture: buffer-local map with the `buf` option
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'go',
	callback = function()
		vim.keymap.set('n', 'gO', '<Nop>', { buf = 0, desc = 'Outline' })
	end,
})
