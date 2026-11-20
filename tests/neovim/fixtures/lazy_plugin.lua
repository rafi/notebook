-- Fixture: plugins added only on first use
local function load()
	vim.pack.add({
		{ src = 'https://github.com/a/lazy.nvim', version = 'main' },
		'https://codeberg.org/b/dep',
	})
end
vim.pack.add({ 'https://github.com/c/eager' })
vim.keymap.set('n', '<leader>z', function()
	load()
end, { desc = 'Lazy' })
-- See https://github.com/d/not-a-plugin for docs
local url = 'https://github.com/e/repo/blob/main/README.md'
