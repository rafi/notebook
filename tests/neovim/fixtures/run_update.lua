-- Fixture: run build.update() into arg[1], exit 1 with the error on stderr.
package.path = ('%s/lua/?.lua;%s'):format(vim.uv.cwd(), package.path)
local ok, err = pcall(function()
	require('build').update({ out_dir = _G.arg[1] })
end)
if not ok then
	io.stderr:write(tostring(err) .. '\n')
	os.exit(1)
end
os.exit(0)
