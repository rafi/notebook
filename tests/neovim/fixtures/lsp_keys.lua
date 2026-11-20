-- Fixture: Snacks LSP keymaps
Snacks.keymap.set(
	'n',
	'gd',
	'x',
	{ desc = 'Goto Definition', lsp = { method = 'textDocument/definition' } }
)
Snacks.keymap.set(
	'n',
	'gO',
	'x',
	{ desc = 'Organize', lsp = { name = 'gopls' } }
)
