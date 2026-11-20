-- Fixture: on_event callback reading <abuf>
require('rafi.pack').on_event('FileType', function()
	assert(tonumber(vim.fn.expand('<abuf>')), 'no <abuf>')
end)
