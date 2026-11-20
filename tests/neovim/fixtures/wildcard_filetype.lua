-- Fixture: FileType autocmd without a pattern
vim.api.nvim_create_autocmd('FileType', {
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
		if not lang or not vim.treesitter.language.add(lang) then
			return
		end
		vim.keymap.set(
			'n',
			']f',
			'<Nop>',
			{ buffer = ev.buf, desc = 'Next Function' }
		)
	end,
})
