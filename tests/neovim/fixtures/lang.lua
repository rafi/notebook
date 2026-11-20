-- Fixture: language registry
require('rafi.util.lang').add({
	servers = { gopls = true, xls = false },
	tools = { 'gofumpt' },
	parsers = { templ = { url = 'u' } },
	keys = { gopls = { { 'gD', 'x', desc = 'Def' } } },
	formatters_by_ft = { go = { 'goimports', stop_after_first = true } },
})
