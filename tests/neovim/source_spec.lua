local T = {}

T.env_dir_wins = function()
	local saved = vim.env.VIM_CONFIG_DIR
	local dir = vim.fn.expand('~/.config/nvim')
	vim.env.VIM_CONFIG_DIR = dir
	local ok, res = pcall(function()
		return require('source').ensure()
	end)
	vim.env.VIM_CONFIG_DIR = saved
	assert(ok, res)
	assert(res.dir == dir, 'dir: ' .. tostring(res.dir))
	assert(res.sha:match('^%x+$'), 'sha: ' .. tostring(res.sha))
end

return T
