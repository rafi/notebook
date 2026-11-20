-- Fixture: LspAttach keymaps for one server
require('rafi.util.lang').add({ servers = { jdtls = false } })
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.name == 'jdtls' then
			vim.keymap.set(
				'n',
				'<leader>co',
				'<Nop>',
				{ buffer = ev.buf, desc = 'Organize Imports' }
			)
		end
	end,
})
