-- Fixture: keymaps gated on the environment
if not vim.env.TMUX then
	return
end
if vim.fn.executable('no-such-binary-for-docs') == 1 then
	vim.keymap.set('n', '<leader>gt', '<Nop>', { desc = 'Tool' })
end
