-- Fixture: plugin Ex commands
vim.cmd('EmmetInstall')
vim.cmd.Neogit()
vim.keymap.set('n', '<leader>q', '<Nop>', { desc = 'After commands' })
