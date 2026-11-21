-- Fixture: Snacks toggle.map hook
require('snacks').setup({
	toggle = {
		map = function(mode, lhs, rhs, opts)
			Snacks.keymap.set(mode, lhs, rhs, opts)
		end,
	},
})
