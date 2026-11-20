-- Examples for the customize page. Each starts at a `-- ## Title` line, the
-- comment lines right after it are its description, and the code follows.

-- ## Add a plugin
-- Save it as lua/plugins/gruvbox.lua. vim.pack installs it on the next
-- start, and `:colorscheme gruvbox` switches to it.
vim.pack.add({ 'https://github.com/ellisonleao/gruvbox.nvim' })
require('gruvbox').setup({ contrast = 'hard' })

-- ## Load a plugin on first use
-- rafi.pack runs the code on the first event, filetype or command, so the
-- plugin doesn't slow down startup.
local pack = require('rafi.pack')

pack.on_event('InsertEnter', function()
	vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' })
	require('nvim-autopairs').setup()
end)

pack.on_filetype('csv', function()
	vim.pack.add({ 'https://github.com/hat0uma/csvview.nvim' })
	require('csvview').setup()
end)

-- ## Replace a core plugin
-- Add "lualine" to `disabled` in rafi.json, then load your own statusline
-- in lua/plugins/lightline.lua.
vim.pack.add({ 'https://github.com/itchyny/lightline.vim' })
vim.g.lightline = { colorscheme = 'wombat' }

-- ## Write your own extra
-- Save it as lua/plugins/extras/editor/zen.lua and turn it on with
-- `:RafiExtras`. The first line is the description it shows.

-- Distraction-free writing
local pack = require('rafi.pack')

pack.command('ZenMode', function()
	vim.pack.add({ 'https://github.com/folke/zen-mode.nvim' })
	require('zen-mode').setup({ window = { width = 90 } })
end)
vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<CR>', { desc = 'Zen Mode' })

-- ## Change LSP settings
-- In a lua/plugins/*.lua file, or as `after/lsp/<server>.lua` returning the
-- table.
vim.lsp.config('yamlls', {
	filetypes = { 'yaml', 'yaml.ansible', 'yaml.docker-compose' },
})
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			workspace = { checkThirdParty = false },
			completion = { callSnippet = 'Replace' },
		},
	},
})
