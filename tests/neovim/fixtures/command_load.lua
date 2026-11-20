-- Fixture: keymaps set after a command stub loads the plugin
local pack = require('rafi.pack')
pack.command('Foo', function()
	vim.api.nvim_create_autocmd('User', {
		pattern = 'FooReady',
		callback = function()
			vim.keymap.set('n', '<leader>fr', '<Nop>', { desc = 'Foo Ready' })
		end,
	})
end)
