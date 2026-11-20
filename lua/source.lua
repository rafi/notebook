-- Finds the vim-config checkout the docs are generated from.
--
-- $VIM_CONFIG_DIR wins (preview unpushed work). Otherwise a shallow clone of
-- rafi/vim-config master lives in .nvim/vim-config, updated on each call.

local M = {}

M.url = 'https://github.com/rafi/vim-config'

---@param cmd string[]
---@return string stdout
local function git(cmd)
	local res =
		vim.system(vim.list_extend({ 'git' }, cmd), { text = true }):wait()
	if res.code ~= 0 then
		error(('git %s: %s'):format(table.concat(cmd, ' '), res.stderr), 0)
	end
	return vim.trim(res.stdout)
end

---@return { dir: string, sha: string }
function M.ensure()
	local dir = vim.env.VIM_CONFIG_DIR
	if not dir or dir == '' then
		dir = vim.fs.joinpath(vim.uv.cwd(), '.nvim', 'vim-config')
		if vim.uv.fs_stat(dir) then
			git({ '-C', dir, 'fetch', '--quiet', '--depth', '1', 'origin', 'master' })
			git({ '-C', dir, 'reset', '--quiet', '--hard', 'origin/master' })
		else
			git({ 'clone', '--quiet', '--depth', '1', M.url, dir })
		end
	end
	return { dir = dir, sha = git({ '-C', dir, 'rev-parse', '--short', 'HEAD' }) }
end

return M
