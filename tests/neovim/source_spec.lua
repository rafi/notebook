local T = {}

---Run git, erroring with its stderr on failure.
---@param args string[]
local function git(args)
	local res =
		vim.system(vim.list_extend({ 'git' }, args), { text = true }):wait()
	assert(res.code == 0, res.stderr)
	return vim.trim(res.stdout)
end

T.env_dir_wins = function()
	-- A throwaway repository, so the test doesn't depend on a local config.
	local dir = vim.fn.tempname()
	vim.fn.mkdir(dir, 'p')
	git({ '-C', dir, 'init', '--quiet' })
	git({
		'-C',
		dir,
		'-c',
		'user.name=t',
		'-c',
		'user.email=t@t',
		'commit',
		'--quiet',
		'--allow-empty',
		'-m',
		'init',
	})
	local saved = vim.env.VIM_CONFIG_DIR
	vim.env.VIM_CONFIG_DIR = dir
	local ok, res = pcall(function()
		return require('source').ensure()
	end)
	vim.env.VIM_CONFIG_DIR = saved
	vim.fn.delete(dir, 'rf')
	assert(ok, res)
	assert(res.dir == dir, 'dir: ' .. tostring(res.dir))
	assert(res.sha:match('^%x+$'), 'sha: ' .. tostring(res.sha))
end

return T
