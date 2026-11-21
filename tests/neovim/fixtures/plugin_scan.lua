-- Fixture: quoted URLs that aren't plugins
require('rafi.util.lang').add({
	parsers = { templ = { url = 'https://github.com/a/tree-sitter-templ' } },
})
-- vim.pack.add({ 'https://github.com/b/old' })
local function load()
	vim.pack.add({ 'https://github.com/c/real' })
end
local docs = 'https://github.com/d/notplugin'
vim.keymap.set('n', '<leader>l', load, { desc = 'Load' })
