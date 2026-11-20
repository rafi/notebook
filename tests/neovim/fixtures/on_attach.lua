-- Fixture: keymaps in an on_attach passed to a plugin
require('gitsigns').setup({
	on_attach = function(buffer)
		vim.keymap.set('n', ']h', '<Nop>', { buffer = buffer, desc = 'Next Hunk' })
	end,
})
