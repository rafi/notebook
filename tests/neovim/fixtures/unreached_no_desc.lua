-- Fixture: unreached keymap calls with and without a possible desc
local opts = { desc = 'Maybe' }
if opts.never then
	vim.keymap.set('n', '<Esc>', '<cmd>quit<CR>', { buffer = 0 })
	vim.keymap.set('n', '<leader>m', '<Nop>', opts)
	vim.keymap.set('n', '<leader>n', '<Nop>', {
		desc = 'Multi-line',
	})
end
