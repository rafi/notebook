local render = require('render')

local function eq(a, b, what)
	assert(
		vim.deep_equal(a, b),
		('%s: expected %s, got %s'):format(what, vim.inspect(b), vim.inspect(a))
	)
end

---@param fields? table
---@return docs.FileInfo
local function info(fields)
	return vim.tbl_extend('force', {
		kind = 'extra',
		name = 'ui.deadcolumn',
		category = 'ui',
		path = 'lua/rafi/extras/ui/deadcolumn.lua',
		default_enabled = false,
		required = false,
	}, fields or {})
end

---@param fields? table
---@return docs.Capture
local function cap(fields)
	return vim.tbl_extend('force', {
		desc = 'Show colorcolumn dynamically',
		keymaps = {},
		plugins = { 'https://github.com/Bekaboo/deadcolumn.nvim' },
	}, fields or {})
end

local T = {}

T.escapes_specials = function()
	eq(render.escape('a|b {c} <d>'), 'a&#124;b &#123;c&#125; &lt;d>', 'escape')
	local rows = render.keymap_table({
		{ mode = { 'n' }, lhs = '<leader>|', desc = 'Pipe {x}' },
	})
	local row = rows[#rows]
	local _, pipes = row:gsub('|', '')
	eq(pipes, 4, 'raw | in ' .. row)
	assert(not row:find('{', 1, true), 'raw { in ' .. row)
end

T.kbd_cases = function()
	eq(render.kbd('<C-n>'), '<kbd>C-n</kbd>', '<C-n>')
	eq(render.kbd('gD'), '<kbd>g</kbd><kbd>D</kbd>', 'gD')
	eq(
		render.kbd('<leader><space>'),
		'<kbd>leader</kbd><kbd>space</kbd>',
		'<leader><space>'
	)
	eq(render.kbd('<'), '<kbd>&lt;</kbd>', 'lone <')
	eq(render.kbd('g<'), '<kbd>g</kbd><kbd>&lt;</kbd>', 'g<')
end

T.tabs_syntax = function()
	eq(
		render.tabs({ { label = 'A', lang = 'lua', code = 'x' } }),
		{ ':::tabs', '```lua [A]', 'x', '```', ':::' },
		'tabs'
	)
end

T.keymap_notes = function()
	local rows = render.keymap_table({
		{ mode = { 'n', 'x' }, lhs = 'gD', desc = 'Def', server = 'gopls' },
		{ mode = { 'n' }, lhs = 'K', desc = 'Hover', server = '*' },
		{ mode = { 'n' }, lhs = '<leader>cj', desc = 'JSON', ft = { 'go' } },
	})
	assert(rows[3]:find('Def _(with gopls)_', 1, true), rows[3])
	assert(rows[3]:find('𝐍 𝐗', 1, true), rows[3])
	assert(rows[4]:find('Hover _(with any LSP)_', 1, true), rows[4])
	assert(rows[5]:find('JSON _(in go buffers)_', 1, true), rows[5])
end

T.page_sections = function()
	local default_extra =
		render.page(cap(), info({ default_enabled = true }), 'x')
	assert(default_extra:find('\n## Disable\n', 1, true), 'default: no Disable')
	assert(not default_extra:find('\n## Enable\n', 1, true), 'default: Enable')
	assert(default_extra:find('\ngenerated: true\n', 1, true), 'frontmatter')
	assert(default_extra:find('\ndefault_enabled: true\n', 1, true), 'default fm')
	assert(not default_extra:find('## Keymaps', 1, true), 'empty keymaps')

	local opt_in = render.page(cap(), info(), 'x')
	assert(opt_in:find('\n## Enable\n', 1, true), 'opt-in: no Enable')
	assert(opt_in:find('"extras": ["ui.deadcolumn"]', 1, true), 'opt-in json')

	local snacks = render.page(
		cap({ desc = 'QoL' }),
		info({
			kind = 'core',
			name = 'snacks',
			category = nil,
			path = 'plugin/snacks.lua',
			required = true,
		}),
		'x'
	)
	assert(snacks:find("can't be disabled", 1, true), 'required core')
	assert(not snacks:find('\ncategory:', 1, true), 'core has no category')

	local core = render.page(
		cap({ desc = 'Formatter' }),
		info({ kind = 'core', name = 'conform', path = 'plugin/conform.lua' }),
		'x'
	)
	assert(core:find('"disabled": ["conform"]', 1, true), 'core disable json')

	local with_maps = render.page(
		cap({ keymaps = { { mode = { 'n' }, lhs = 'gD', desc = 'Def' } } }),
		info(),
		'local x = 1'
	)
	assert(with_maps:find('\n## Keymaps\n', 1, true), 'keymaps section')
	assert(with_maps:find('<summary>Source</summary>', 1, true), 'source')
	assert(
		with_maps:find(
			'```lua title="lua/rafi/extras/ui/deadcolumn.lua"\nlocal x = 1\n```',
			1,
			true
		),
		'source fence'
	)
	assert(
		with_maps:find(
			'[deadcolumn.nvim](https://github.com/Bekaboo/deadcolumn.nvim)',
			1,
			true
		),
		'plugin link'
	)
end

T.language_section = function()
	local page = render.page(
		cap({
			lang = {
				servers = { 'gopls' },
				tools = { 'gofumpt' },
				parsers = { 'templ' },
				linters_by_ft = { go = { 'golangcilint' } },
				formatters_by_ft = { go = { 'goimports', 'gofumpt' } },
			},
		}),
		info({ name = 'lang.go', category = 'lang' }),
		'x'
	)
	assert(page:find('\n## Language support\n', 1, true), 'section')
	for _, s in ipairs({ 'gopls', 'gofumpt', 'templ', 'golangcilint' }) do
		assert(page:find(s, 1, true), 'missing ' .. s)
	end
end

T.examples_parse = function()
	local blocks = render.parse_examples(table.concat({
		'-- ## Add a plugin',
		'-- Install it with vim.pack.',
		'-- Then set it up.',
		"vim.pack.add({ 'x' })",
		'',
		'',
		'-- ## Second',
		'-- Desc.',
		'',
		'-- Code comment',
		'local a = 1',
		'',
	}, '\n'))
	eq(#blocks, 2, 'count')
	eq(blocks[1], {
		title = 'Add a plugin',
		desc = 'Install it with vim.pack. Then set it up.',
		code = "vim.pack.add({ 'x' })",
	}, 'first')
	eq(blocks[2], {
		title = 'Second',
		desc = 'Desc.',
		code = '-- Code comment\nlocal a = 1',
	}, 'second')
end

return T
