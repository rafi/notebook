-- Fixture: visual/select and default modes
vim.keymap.set('v', '<leader>v', '<Nop>', { desc = 'Visual' })
vim.keymap.del('x', '<leader>v')
vim.keymap.set('', '<leader>e', '<Nop>', { desc = 'Every' })
vim.keymap.set('!', '<C-x>', '<Nop>', { desc = 'Bang' })
