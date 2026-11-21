-- Fixture: keymaps in hooks the plugin would call
vim.g.myplugin_hooks = {
	edit_open = function()
		vim.keymap.set('n', '<leader>eo', '<Nop>', { buffer = 0, desc = 'Hook' })
	end,
}
vim.g.rusty = {
	server = {
		on_attach = function(_, bufnr)
			vim.keymap.set(
				'n',
				'<leader>cR',
				'<Nop>',
				{ buffer = bufnr, desc = 'Action' }
			)
		end,
	},
}
require('goto').setup({
	post_open_hook = function(buf)
		vim.keymap.set('n', '<Esc>', '<Nop>', { buffer = buf, desc = 'Close' })
	end,
})
