-- Fixture: FileType autocmd for a filetype with a runtime ftplugin
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'markdown',
	callback = function() end,
})
