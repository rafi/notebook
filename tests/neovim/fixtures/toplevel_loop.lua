-- Fixture: top-level maps and a loop
vim.pack.add({ 'https://github.com/x/y' })
vim.keymap.set('n', '<leader>H', function() end, { desc = 'Add' })
for i = 1, 3 do
	vim.keymap.set(
		'n',
		'<localleader>' .. i,
		function() end,
		{ desc = 'File ' .. i }
	)
end
