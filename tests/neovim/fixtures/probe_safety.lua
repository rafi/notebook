-- Fixture: user-action callbacks probes must not run
require('ui').setup({
	on_click = function()
		vim.fn.writefile({ 'x' }, 'probe-click.txt')
	end,
	nested = {
		on_confirm = function()
			vim.fn.writefile({ 'x' }, 'probe-confirm.txt')
		end,
	},
})
local function load_session()
	vim.fn.writefile({ 'x' }, 'probe-session.txt')
end
vim.keymap.set('n', '<leader>s', function()
	load_session()
end, { desc = 'Session' })
