-- Fixture: a keymap call that never runs
local enabled = false
if enabled then
	vim.keymap.set('n', '<leader>u', '<Nop>', { desc = 'Never' })
end
vim.keymap.set('n', '<leader>y', '<Nop>', { desc = 'Always' })
