-- Fixture: buffer-local map set on FileType
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'go',
	callback = function(ev)
		vim.keymap.set(
			'n',
			'<leader>cj',
			'<Nop>',
			{ buffer = ev.buf, desc = 'JSON to struct' }
		)
	end,
})
