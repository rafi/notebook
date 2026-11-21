-- Fixture: the same buffer map for two filetypes
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'go', 'templ' },
	callback = function(ev)
		vim.keymap.set(
			'n',
			'<leader>cj',
			'<Nop>',
			{ buffer = ev.buf, desc = 'JSON' }
		)
	end,
})
