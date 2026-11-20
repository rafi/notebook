-- Fixture: plugin function as a keymap's rhs
local gs = require('gitsigns')
vim.keymap.set('n', ']h', gs.next_hunk, { desc = 'Next Hunk' })
