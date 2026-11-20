-- Fixture: keymaps set only when a plugin's query exists
vim.api.nvim_create_autocmd('FileType', {
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
		if not lang or not vim.treesitter.query.get(lang, 'textobjects') then
			return
		end
		vim.keymap.set(
			'n',
			']m',
			'<Nop>',
			{ buffer = ev.buf, desc = 'Next Method' }
		)
	end,
})
