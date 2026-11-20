-- Fixture: remaps, modes and deletes
vim.keymap.set('n', '<leader>a', '<Nop>', { desc = 'Normal A' })
vim.keymap.set('x', '<leader>a', '<Nop>', { desc = 'Visual A' })
vim.keymap.set('n', '<leader>b', '<Nop>', { desc = 'First B' })
vim.keymap.set('n', '<leader>b', '<Nop>', { desc = 'Last B' })
vim.keymap.set('n', '<leader>c', '<Nop>', { desc = 'Gone' })
vim.keymap.del('n', '<leader>c')
