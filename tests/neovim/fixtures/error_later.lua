-- Fixture: error in deferred code
require('rafi.pack').later(function()
	error('boom later')
end)
