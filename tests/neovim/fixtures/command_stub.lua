-- Fixture: a loader that deletes its command stubs
local function load()
	vim.api.nvim_del_user_command('FooIndex')
	vim.keymap.set('n', '<leader>fi', '<Nop>', { desc = 'Foo Index' })
end
require('rafi.pack').command({ 'FooIndex' }, load)
