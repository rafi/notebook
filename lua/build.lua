-- Generates content/neovim from a vim-config checkout: one page per core
-- plugin/ file and per extra, plus the keymaps page.
-- Based on lazyvim.github.io's lua/build.lua (Apache-2.0):
-- https://github.com/LazyVim/lazyvim.github.io/blob/main/lua/build.lua

local render = require('render')
local source = require('source')

local M = {}

local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')

-- Seconds before a capture counts as hung.
local timeout = 30

---@param path string
---@return string
local function read(path)
	local f = assert(io.open(path, 'rb'))
	local s = f:read('*a')
	f:close()
	return s
end

---Every core plugin/ file and every extra, core files first, each sorted
---by name.
---@param config_dir string
---@return docs.FileInfo[]
function M.list(config_dir)
	-- rafi.config's top level only defines tables and functions.
	local config = dofile(config_dir .. '/lua/rafi/config/init.lua')
	local core, extras = {}, {}
	for _, path in ipairs(vim.fn.glob(config_dir .. '/plugin/*.lua', false, true)) do
		local name = vim.fn.fnamemodify(path, ':t:r')
		table.insert(core, {
			kind = 'core',
			name = name,
			path = 'plugin/' .. name .. '.lua',
			default_enabled = false,
			required = vim.list_contains(config.required, name),
		})
	end
	local glob = config_dir .. '/lua/rafi/extras/*/*.lua'
	for _, path in ipairs(vim.fn.glob(glob, false, true)) do
		local category, file = path:match('([^/]+)/([^/]+)%.lua$')
		local name = category .. '.' .. file
		table.insert(extras, {
			kind = 'extra',
			name = name,
			category = category,
			path = ('lua/rafi/extras/%s/%s.lua'):format(category, file),
			default_enabled = vim.list_contains(config.defaults, name),
			required = false,
		})
	end
	local by_name = function(a, b)
		return a.name < b.name
	end
	table.sort(core, by_name)
	table.sort(extras, by_name)
	return vim.list_extend(core, extras)
end

---Run lua/capture.lua for each file, a few at a time in parallel.
---@param config_dir string
---@param infos { path: string }[]
---@return table<string, docs.Capture> by path, {path: string, err: string}[] failures
function M.capture_all(config_dir, infos)
	local results, failures, raw = {}, {}, {}
	local max = #vim.uv.cpu_info()
	local next_i, running = 1, 0
	local function start()
		while running < max and next_i <= #infos do
			local info = infos[next_i]
			next_i = next_i + 1
			running = running + 1
			vim.system({
				'nvim',
				'--headless',
				'--clean',
				'-l',
				root .. '/lua/capture.lua',
				config_dir,
				config_dir .. '/' .. info.path,
			}, { text = true, timeout = timeout * 1000 }, function(res)
				raw[info.path] = res
				running = running - 1
			end)
		end
	end
	while next_i <= #infos or running > 0 do
		start()
		vim.wait(20, function()
			return running < max and next_i <= #infos
				or (next_i > #infos and running == 0)
		end)
	end
	for _, info in ipairs(infos) do
		local res = raw[info.path]
		local ok, data = false, nil
		if res.code == 0 then
			ok, data = pcall(vim.json.decode, res.stdout)
		end
		if ok then
			results[info.path] = data
		else
			local err = vim.trim(res.stderr or '')
			if res.signal ~= 0 then
				err = ('timed out after %ds\n%s'):format(timeout, err)
			elseif res.code == 0 then
				err = 'invalid JSON on stdout: ' .. tostring(data)
			end
			table.insert(failures, { path = info.path, err = err })
		end
	end
	return results, failures
end

---Whether a Markdown file's frontmatter has `generated: true`.
---@param path string
local function is_generated(path)
	local lines = vim.fn.readfile(path, '', 20)
	if lines[1] ~= '---' then
		return false
	end
	for i = 2, #lines do
		if lines[i] == '---' then
			return false
		elseif lines[i] == 'generated: true' then
			return true
		end
	end
	return false
end

---Write pages under out_dir, skipping unchanged files. Generated pages
---under core/ and extras/ that aren't in `pages` are deleted, so removed
---extras lose their page. Hand-written files are never deleted.
---@param out_dir string
---@param pages table<string, string> Relative path -> content
function M.write(out_dir, pages)
	for _, sub in ipairs({ 'core', 'extras' }) do
		local dir = out_dir .. '/' .. sub
		for name, type in vim.fs.dir(dir, { depth = 3 }) do
			local rel = sub .. '/' .. name
			if
				type == 'file'
				and name:match('%.md$')
				and not pages[rel]
				and is_generated(out_dir .. '/' .. rel)
			then
				print('del: ' .. rel)
				vim.uv.fs_unlink(out_dir .. '/' .. rel)
			end
		end
	end
	for rel, content in pairs(pages) do
		local path = out_dir .. '/' .. rel
		local old = vim.uv.fs_stat(path) and read(path)
		if old ~= content then
			vim.fn.mkdir(vim.fs.dirname(path), 'p')
			local f = assert(io.open(path, 'wb'))
			f:write(content)
			f:close()
		end
	end
end

---Page path of a file under content/neovim.
---@param info docs.FileInfo
local function page_path(info)
	if info.kind == 'core' then
		return 'core/' .. info.name .. '.md'
	end
	local file = info.name:sub(#info.category + 2)
	return ('extras/%s/%s.md'):format(info.category, file)
end

---The customize page: lua/templates/customize.md with its markers filled.
---`<!-- config:<name> -->` becomes tabs of the user template next to
---vim-config's default file, `<!-- examples -->` the blocks of
---lua/templates/examples.lua (as lazyvim.github.io does with recipes).
---@param config_dir string
---@return string
function M.customize(config_dir)
	local templates = root .. '/lua/templates'
	local page = read(templates .. '/customize.md')
	page = page:gsub('<!%-%- config:(%w+) %-%->', function(name)
		return table.concat(
			render.tabs({
				{
					label = ('Your lua/config/%s.lua'):format(name),
					lang = 'lua',
					code = read(('%s/config/%s.lua'):format(templates, name)),
				},
				{
					label = 'Default rafi.config.' .. name,
					lang = 'lua',
					code = read(('%s/lua/rafi/config/%s.lua'):format(config_dir, name)),
				},
			}),
			'\n'
		)
	end)
	local examples = {}
	for _, ex in ipairs(render.parse_examples(read(templates .. '/examples.lua'))) do
		table.insert(examples, '### ' .. ex.title)
		if ex.desc ~= '' then
			vim.list_extend(examples, { '', render.escape(ex.desc) })
		end
		vim.list_extend(examples, { '', '```lua', ex.code, '```', '' })
	end
	page = page:gsub('<!%-%- examples %-%->', function()
		return vim.trim(table.concat(examples, '\n'))
	end)
	return page
end

---Capture every file of vim-config and write all pages, or write nothing
---and error with every failing file.
---@param opts? { out_dir?: string }
function M.update(opts)
	opts = opts or {}
	local out_dir = opts.out_dir or (root .. '/content/neovim')
	local src = source.ensure()
	local infos = M.list(src.dir)
	local keymaps_path = 'lua/rafi/config/keymaps.lua'
	local files = vim.list_extend({ { path = keymaps_path } }, infos)
	local caps, failures = M.capture_all(src.dir, files)
	if #failures > 0 then
		local lines = { ('%d file(s) failed to capture:'):format(#failures) }
		for _, f in ipairs(failures) do
			table.insert(lines, ('\n%s\n%s'):format(f.path, f.err))
		end
		error(table.concat(lines, '\n'), 0)
	end

	local pages = {}
	for _, info in ipairs(infos) do
		local text = read(src.dir .. '/' .. info.path)
		pages[page_path(info)] = render.page(caps[info.path], info, text)
	end
	pages['keymaps.md'] = render.keymaps_page(caps[keymaps_path])
	pages['customize.md'] = M.customize(src.dir)
	pages['generated.json'] = vim.json.encode({ commit = src.sha }) .. '\n'
	M.write(out_dir, pages)
	print(('%d pages from vim-config@%s'):format(vim.tbl_count(pages), src.sha))
end

return M
