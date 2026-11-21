-- Fixture: unreached calls the skip rule must keep
local opts = { desc = 'D' }
local t = {}
if t.never then
	vim.keymap.set({ 'n', 'x' }, '<leader>y', '<Nop>', opts)
	Snacks.toggle.option('wrap'):map('<leader>uw')
end
vim.keymap.set('n', '<leader>z', '<Nop>', { buffer = 0 })
