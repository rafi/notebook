-- Fixture: plugin values used as lists
for _ in ipairs(require('foo').list) do
end
local n = #require('foo').x
require('foo').setup({ n = n })
