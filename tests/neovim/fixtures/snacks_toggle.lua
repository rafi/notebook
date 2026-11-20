-- Fixture: Snacks toggles
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.line_number():map('<leader>ul')
Snacks.toggle.zoom():map('<leader>wm')
vim.keymap.del('n', '<leader>wm')
Snacks.keymap.set(
	{ 'n', 'x' },
	'<leader>cu',
	function() end,
	{ desc = 'Run Lua', ft = 'lua' }
)
