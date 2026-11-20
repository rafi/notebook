---
title: 'Customize'
description: 'Change options, keymaps and autocmds, and add your own plugins and extras'
published: true
generated: true
---

vim-config loads your own files right after its own, so you can change
anything without editing the config itself. Every file below is optional:
create only the ones you need, in your config directory
(`~/.config/nvim`).

## Your config files

`lua/config/options.lua`, `lua/config/keymaps.lua` and
`lua/config/autocmds.lua` each load right after their Rafi counterpart, so
they can override it. An error in one of them shows a warning instead of
stopping Neovim.

### Options

Options load first, before any plugin.

:::tabs
```lua [Your lua/config/options.lua]
-- Options load right after rafi.config.options, before any plugin.
-- Defaults that are always set:
-- https://github.com/rafi/vim-config/blob/master/lua/rafi/config/options.lua
-- Add your own options here.

-- For example (default values are shown):

-- Auto format on save
-- vim.g.autoformat = false

-- Elite-mode (hjkl mode, arrow-keys resize window)
-- vim.g.elite_mode = false

-- <Tab> selects completion items, jumps in snippets and opens completion
-- (coding.blink). false keeps <Tab> for snippet jumps and AI actions only.
-- vim.g.cmp_supertab = true

-- External file diff program
-- vim.g.diffprg = 'bcompare'
```
```lua [Default rafi.config.options]
-- Rafi's Neovim options
-- https://github.com/rafi/vim-config
-- ===
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- This file is automatically loaded by rafi.config.setup() (init.lua)

-- Keyboard leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- Add user pack directory
vim.opt.packpath:append(vim.fn.stdpath('data') .. '/site')

-- Auto format on save (rafi.util.format)
vim.g.autoformat = false

-- Elite-mode (hjkl mode, arrow-keys resize window), off by default.
vim.g.elite_mode = false

-- Snacks animations. Set to `false` to disable all of them.
vim.g.snacks_animate = true

-- Use the AI completion source instead of inline suggestions, when the
-- completion engine supports it
vim.g.ai_cmp = true

-- <Tab> selects completion items, jumps in snippets and opens completion.
-- false keeps <Tab> for snippet jumps and AI actions only.
vim.g.cmp_supertab = true

-- External file diff program
vim.g.diffprg = 'bcompare'

-- Root dir detection (rafi.util.root)
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

-- LSP servers ignored by root detection
vim.g.root_lsp_ignore = { 'copilot' }

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Show document symbols location from Trouble in lualine.
-- Disable per buffer with `vim.b.trouble_lualine = false`.
vim.g.trouble_lualine = true

-- Skip clipboard over SSH, so the OSC 52 integration works.
vim.opt.clipboard = vim.env.SSH_CONNECTION and '' or 'unnamedplus' -- Sync with system clipboard
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'indent'
vim.opt.foldtext = ''
vim.opt.formatoptions = 'jcroqlnt' -- tcqj
vim.opt.formatexpr = "v:lua.require'rafi.util.format'.formatexpr()"
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.ignorecase = true -- Ignore case
vim.opt.inccommand = 'nosplit' -- preview incremental substitute
vim.opt.jumpoptions = 'view'
vim.opt.laststatus = 3 -- global statusline
vim.opt.linebreak = true -- Wrap lines at convenient points
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.ruler = false -- Disable the default ruler
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sessionoptions = {
	'curdir',
	'tabpages',
	'winsize',
	'help',
	'globals',
	'skiprtp',
	'folds',
}
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.smoothscroll = true
vim.opt.spelllang = { 'en' }
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = 'screen'
vim.opt.splitright = true -- Put new windows right of current
vim.opt.statuscolumn = [[%!v:lua.require'rafi.util'.statuscolumn()]]
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = 'longest:full,full' -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
-- Disable markdown.vim [[/]] keymaps, the built-in ftplugin sets them
vim.g.no_markdown_maps = 1

-- Neovim built in filetype plugins settings.
vim.g.yaml_indent_multiline_scalar = 1 -- $VIMRUNTIME/indent/yaml.vim
vim.g.no_gitrebase_maps = 1 -- See $VIMRUNTIME/ftplugin/gitrebase.vim
vim.g.no_man_maps = 1 -- See $VIMRUNTIME/ftplugin/man.vim

-- Disable unused builtin plugins
for _, name in ipairs({
	'gzip',
	'matchit',
	'matchparen',
	'tarPlugin',
	'netrwPlugin',
	'zipPlugin', -- plugin/zipPlugin.vim (Neovim 0.12)
	'python3_provider',
	'perl_provider',
	'ruby_provider',
	'node_provider',
}) do
	vim.g['loaded_' .. name] = 1
end
-- Guard names that differ from the file names above.
vim.g.loaded_tutor_mode_plugin = 1 -- plugin/tutor.vim
vim.g.loaded_nvim_zip_plugin = 1 -- plugin/zip.lua (Neovim 0.13+)

vim.opt.autowrite = false
vim.opt.expandtab = false
vim.opt.number = false
vim.opt.relativenumber = false

vim.opt.title = true
vim.opt.titlestring = '%<%F%=%l/%L - nvim'
vim.opt.textwidth = 80 -- Text width maximum chars before wrapping
vim.opt.mouse = 'nv' -- Enable mouse in normal and visual modes only
vim.opt.mousescroll = 'ver:1,hor:1'
vim.opt.spelloptions:append('camel')
vim.opt.diffopt:append({
	'indent-heuristic',
	'algorithm:patience',
	'context:999999',
})

if not vim.g.vscode then
	-- Faster timeout on mapped/key-code sequence to complete.
	vim.opt.timeoutlen = vim.g.vscode and 1000 or 300
	vim.opt.ttimeoutlen = 10
end

if vim.fn.has('nvim-0.11') == 1 then
	vim.opt.tabclose:append('uselast')
end

vim.opt.breakindent = true
vim.opt.showcmd = false -- Don't show command in status line
vim.opt.numberwidth = 2 -- Minimum number of columns for the line number
vim.opt.cmdheight = 0
vim.opt.colorcolumn = '+0' -- Align text at 'textwidth'
vim.opt.showtabline = 2 -- Always show the tabs line
vim.opt.helpheight = 0 -- Disable help window resizing
vim.opt.winwidth = 30 -- Minimum width for active window
vim.opt.winheight = 1 -- Minimum height for active window
vim.opt.winminheight = 1 -- Minimum height for inactive window
vim.opt.winborder = 'rounded' -- Default border style of floating windows

if vim.fn.has('nvim-0.13') == 1 then
	vim.opt.shortmess:append('u')
end

vim.opt.showbreak = '⤷  ' -- ↪	⤷
vim.opt.listchars = {
	tab = '  ',
	extends = '⟫',
	precedes = '⟪',
	conceal = '',
	nbsp = '␣',
	trail = '·',
}
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 15
-- vim.wo.foldcolumn = '1'
vim.opt.fillchars = {
	foldopen = '', --  󰅀▾
	foldclose = '', --  󰅂▸
	fold = ' ', -- ⸱
	foldsep = ' ',
	foldinner = ' ',
	diff = '╱',
	eob = ' ',
	horiz = '━',
	horizup = '┻',
	horizdown = '┳',
	vert = '┃',
	vertleft = '┫',
	vertright = '┣',
	verthoriz = '╋',
}

-- If sudo, disable vim swap/backup/undo/shada writing
local USER = vim.env.USER or ''
local SUDO_USER = vim.env.SUDO_USER or ''
if
	SUDO_USER ~= ''
	and USER ~= SUDO_USER
	and vim.env.HOME ~= vim.fn.expand('~' .. USER, true)
	and vim.env.HOME == vim.fn.expand('~' .. SUDO_USER, true)
then
	vim.opt_global.modeline = false
	vim.opt_global.undofile = false
	vim.opt_global.swapfile = false
	vim.opt_global.backup = false
	vim.opt_global.writebackup = false
	vim.opt_global.shadafile = 'NONE'
end

vim.filetype.add({
	filename = {
		Brewfile = 'ruby',
		justfile = 'just',
		Justfile = 'just',
		['.buckconfig'] = 'toml',
		['.flowconfig'] = 'ini',
		['.jsbeautifyrc'] = 'json',
		['.jscsrc'] = 'json',
		['.watchmanconfig'] = 'json',
		['helmfile.yaml'] = 'yaml',
		['todo.txt'] = 'todotxt',
		['yarn.lock'] = 'yaml',

		-- NEW
		['.envrc'] = 'bash',
		['.env'] = 'dotenv',
		['.stylelintrc'] = 'json',
		['.stylelintignore'] = 'gitignore',
		['.eslintrc.json'] = 'json5',
		['.luarc.json'] = 'json5',
		['turbo.json'] = 'json5',
		['nx.json'] = 'json5',
	},
	pattern = {
		['%.config/git/users/.*'] = 'gitconfig',
		['%.kube/config'] = 'yaml',
		['.*%.js%.map'] = 'json',
		['.*%.postman_collection'] = 'json',
		['Jenkinsfile.*'] = 'groovy',

		-- JSON with comments
		['[jt]sconfig*.json'] = 'json5',

		-- INFO: Match filenames like - ".env.example", ".env.local" and so on
		-- needed to make dotenv-linter with null-ls works correctly
		['%.env%.[%w_.-]+'] = 'dotenv',
		['.*%.gradle'] = 'groovy',
		['.*/%.github/.*%.y*ml'] = 'yaml.github',

		-- For docker compose language
		-- ['compose.y.?ml'] = 'yaml.docker-compose',
		-- ['docker%-compose%.y.?ml'] = 'yaml.docker-compose',
	},
})

-- The clipboard is set after startup in rafi.config.setup(), so that a
-- user override in lua/config/options.lua is kept.

-- vim: set ts=2 sw=0 tw=80 noet :
```
:::

### Keymaps

Keymaps load after startup. Delete a default keymap with `vim.keymap.del`,
or map the same keys again.

:::tabs
```lua [Your lua/config/keymaps.lua]
-- Keymaps load after startup, right after rafi.config.keymaps.
-- Defaults that are always set:
-- https://github.com/rafi/vim-config/blob/master/lua/rafi/config/keymaps.lua
-- Add your own keymaps here.

-- For example:

-- Delete a default keymap
-- vim.keymap.del('n', '<leader>uw')

-- Map keys again to change what they do
-- vim.keymap.set('n', '<Leader>w', '<cmd>update<CR>', { desc = 'Save File' })
```
```lua [Default rafi.config.keymaps]
-- Rafi's Neovim keymaps
-- https://github.com/rafi/vim-config
-- ===
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- This file is automatically loaded by rafi.config.setup() (init.lua)

local map = vim.keymap.set

-- stylua: ignore start

-- General keymaps. Rafi's keymaps further below override these.
-- ===

-- better up/down (elite mode below replaces it)
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window' })

-- Resize window using <ctrl> arrow keys
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- Move Lines
map('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
map('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
map('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down', silent = true })
map('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up', silent = true })

-- buffers
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
map('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
map('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
map('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Delete Other Buffers' })
map('n', '<leader>bi', function() Snacks.bufdelete.invisible() end, { desc = 'Delete Invisible Buffers' })
map('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })

-- Clear multicursor sessions
vim.keymap.set('n', '<C-[>', function()
	local mc_ns = vim.api.nvim_create_namespace('nvim.multicursor')
	vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
end)

-- Clear search and stop snippet on escape
map({ 'i', 'n', 's' }, '<esc>', function()
	vim.cmd('noh')
	if vim.snippet then
		vim.snippet.stop()
	end
	return '<esc>'
end, { expr = true, desc = 'Escape and Clear hlsearch' })

-- Clear search, multi-cursor marks, diff update and redraw
-- See |CTRL-L-default| ($VIMRUNTIME/lua/vim/_core/defaults.lua)
map(
	'n',
	'<leader>ur',
	'<Cmd>nohlsearch<Bar>diffupdate'
		.. '<Bar>call nvim_buf_clear_namespace(0, nvim_create_namespace("nvim.multicursor"), 0, -1)'
		.. '<Bar>normal! <C-L><CR>',
	{ desc = 'Redraw / Clear hlsearch / Diff Update' }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- save file
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

--keywordprg
map('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

-- better indenting
map('x', '<', '<gv')
map('x', '>', '>gv')

-- commenting
map('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
map('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

-- new file
map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

-- location list
map('n', '<leader>xl', function()
	local success, err = pcall(
		vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose
			or vim.cmd.lopen
	)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = 'Location List' })

-- quickfix list
map('n', '<leader>xq', function()
	local success, err = pcall(
		vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose
			or vim.cmd.copen
	)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = 'Quickfix List' })

map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- formatting
-- map({ 'n', 'x' }, '<leader>cf', function()
-- 	require('rafi.util.format').format({ force = true })
-- end, { desc = 'Format' })

-- diagnostic
local diagnostic_goto = function(next, severity)
	return function()
		vim.diagnostic.jump({
			count = (next and 1 or -1) * vim.v.count1,
			severity = severity and vim.diagnostic.severity[severity] or nil,
			float = true,
		})
	end
end
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- toggle options
-- <leader>uf / <leader>uF (format toggles) are mapped in the rafi section.
Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.line_number():map('<leader>ul')
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = 'Conceal Level' }):map('<leader>uc')
Snacks.toggle.option('showtabline', { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = 'Tabline' }):map('<leader>uA')
Snacks.toggle.treesitter():map('<leader>uT')
Snacks.toggle.option('background', { off = 'light', on = 'dark' , name = 'Dark Background' }):map('<leader>ub')
Snacks.toggle.dim():map('<leader>uD')
Snacks.toggle.animate():map('<leader>ua')
Snacks.toggle.indent():map('<leader>ug')
Snacks.toggle.scroll():map('<leader>uS')
Snacks.toggle.profiler():map('<leader>dpp')
Snacks.toggle.profiler_highlights():map('<leader>dph')

if vim.lsp.inlay_hint then
	Snacks.toggle.inlay_hints():map('<leader>uh')
end

map('n', '<leader>gL', function() Snacks.picker.git_log() end, { desc = 'Git Log (cwd)' })
map('n', '<leader>gb', function() Snacks.picker.git_log_line() end, { desc = 'Git Blame Line' })
map('n', '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = 'Git Current File History' })
map('n', '<leader>gl', function() Snacks.picker.git_log({ cwd = require('rafi.util.root').git() }) end, { desc = 'Git Log' })
map({ 'n', 'x' }, '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Git Browse (open)' })
map({'n', 'x' }, '<leader>gY', function()
	Snacks.gitbrowse({ open = function(url) vim.fn.setreg('+', url) end, notify = false })
end, { desc = 'Git Browse (copy)' })

-- quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

-- highlights under cursor
map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })
map('n', '<leader>uI', function() vim.treesitter.inspect_tree() vim.api.nvim_input('I') end, { desc = 'Inspect Tree' })

-- floating terminal
map('n', '<leader>fT', function() Snacks.terminal() end, { desc = 'Terminal (cwd)' })
map('n', '<leader>ft', function() Snacks.terminal(nil, { cwd = require('rafi.util.root')() }) end, { desc = 'Terminal (Root Dir)' })
map({'n','t'}, '<c-/>',function() Snacks.terminal.focus(nil, { cwd = require('rafi.util.root')() }) end, { desc = 'Terminal (Root Dir)' })
map({'n','t'}, '<c-_>',function() Snacks.terminal.focus(nil, { cwd = require('rafi.util.root')() }) end, { desc = 'which_key_ignore' })

-- windows
map('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below' })
map('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right' })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window' })
Snacks.toggle.zoom():map('<leader>wm'):map('<leader>uZ')
Snacks.toggle.zen():map('<leader>uz')

-- tabs
map('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
map('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'Close Other Tabs' })
map('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
map('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })

-- lua (Snacks.keymap.set understands the `ft` option, vim.keymap.set does
-- not)
Snacks.keymap.set({'n', 'x'}, '<leader>cu', function() Snacks.debug.run() end, { desc = 'Run Lua', ft = 'lua' })

-- stylua: ignore end

-- Rafi's keymaps
-- ===
local unmap = function(modes, lhs, opts)
	modes = type(modes) == 'string' and { modes } or modes
	lhs = type(lhs) == 'string' and { lhs } or lhs
	for _, mode in pairs(modes) do
		for _, l in pairs(lhs) do
			-- pcall(vim.keymap.del, mode, l)
			vim.keymap.del(mode, l, opts)
		end
	end
end

-- stylua: ignore start

-- Picker {{{

-- Bind localleader to common picker (telescope/fzf/snacks) keymaps
map('n', '<localleader>f', '<leader>ff', { remap = true, desc = 'Find Files (Root Dir)' })
map('n', '<localleader>F', '<leader>fF', { remap = true, desc = 'Find Files (cwd)' })
map('n', '<localleader>g', '<leader>sg', { remap = true, desc = 'Grep (Root Dir)' })
map('n', '<localleader>G', '<leader>sG', { remap = true, desc = 'Grep (cwd)' })
map('n', '<localleader>b', '<leader>,',  { remap = true, desc = 'Switch Buffer' })
map('n', '<localleader>B', '<leader>sB', { remap = true, desc = 'Grep open buffers' })
map('n', '<localleader>l', '<leader>sb', { remap = true, desc = 'Buffer lines' })
map('n', '<localleader>h', '<leader>sh', { remap = true, desc = 'Help Pages' })
map('n', '<localleader>i', '<leader>si', { remap = true, desc = 'Icons' })
map('n', '<localleader>H', '<leader>sH', { remap = true, desc = 'Search Highlight Groups' })
map('n', '<localleader>j', '<leader>sj', { remap = true, desc = 'Jumplist' })
map('n', '<localleader>m', '<leader>sm', { remap = true, desc = 'Jump to Mark' })
map('n', '<localleader>M', '<leader>sM', { remap = true, desc = 'Man Pages' })
map('n', '<localleader>n', '<leader>n', { remap = true, desc = 'Notification History' })
map('n', '<localleader>o', '<leader>so', { remap = true, desc = 'Options' })
map('n', '<localleader>t', '<leader>ss', { remap = true, desc = 'Goto Symbol' })
map('n', '<localleader>T', '<leader>sS', { remap = true, desc = 'Goto Symbol (Workspace)' })
map('n', '<localleader>v', '<leader>s"', { remap = true, desc = 'Registers' })
map('n', '<localleader>x', '<leader>fr', { remap = true, desc = 'Recent' })
map('n', '<localleader>X', '<leader>fR', { remap = true, desc = 'Recent (cwd)' })
map('n', '<localleader>;', '<leader>sc', { remap = true, desc = 'Command History' })
map('n', '<localleader>:', '<leader>sC', { remap = true, desc = 'Commands' })
map('n', '<localleader>/', '<leader>s/', { remap = true, desc = 'Search History' })
map('n', '<localleader>.', '<leader>sp', { remap = true, desc = 'Search for Plugin Spec' })
map('n', '<localleader>p', '<leader>fp', { remap = true, desc = 'Projects' })
map({ 'n', 'x' }, '<leader>gg', '<leader>sw', { remap = true, desc = 'Visual selection or word (Root Dir)' })
map({ 'n', 'x' }, '<leader>gG', '<leader>sW', { remap = true, desc = 'Visual selection or word (cwd)' })

-- }}}
-- Navigation {{{

if vim.F.if_nil(vim.g.elite_mode, false) then
	-- Elite-mode: Arrow-keys resize window
	map('n', '<Up>', '<cmd>resize +1<cr>', { desc = 'Increase Window Height' })
	map('n', '<Down>', '<cmd>resize -1<cr>', { desc = 'Decrease Window Height' })
	map('n', '<Left>', '<cmd>vertical resize +1<cr>', { desc = 'Increase Window Width' })
	map('n', '<Right>', '<cmd>vertical resize -1<cr>', { desc = 'Decrease Window Width' })
	unmap('n', { '<C-Up>', '<C-Down>', '<C-Left>', '<C-Right>' })
end

unmap('n', { '<S-h>', '<S-l>' })

-- Easier line-wise movement
map('n', 'gh', 'g^', { desc = 'Jump to first screen character' })
map('n', 'gl', 'g$', { desc = 'Jump to last screen character' })

-- Navigation in command line
map('c', '<C-h>', '<Home>')
map('c', '<C-l>', '<End>')
map('c', '<C-f>', '<Right>')
map('c', '<C-b>', '<Left>')

-- Scroll step sideways
map('n', 'zl', 'z4l')
map('n', 'zh', 'z4h')

-- Toggle fold or select option from popup menu
map('n', '<CR>', function()
	if vim.fn.pumvisible() == 1 then
		return '<CR>'
	end
	if vim.fn.foldclosed('.') > -1 then
		return 'zA'
	end
	return 'za'
end, { expr = true, desc = 'Toggle Fold' })

-- Focus the current fold by closing all others
map('n', '<S-Return>', 'zMzv', { remap = true, desc = 'Focus Fold' })

-- Tabs: Many ways to navigate them
unmap('n', { '<A-j>', '<A-k>' })
map('n', '<A-j>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<A-k>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
map('n', '<A-[>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })
map('n', '<A-]>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<C-Tab>', '<cmd>tabnext<CR>', { desc = 'Next Tab' })
map('n', '<C-S-Tab>', '<cmd>tabprevious<CR>', { desc = 'Previous Tab' })

-- Moving tabs
map('n', '<A-{>', '<cmd>-tabmove<CR>', { desc = 'Tab Move Backwards' })
map('n', '<A-}>', '<cmd>+tabmove<CR>', { desc = 'Tab Move Forwards' })

-- }}}
-- Selection {{{

map('n', '<Leader><Leader>', 'V', { desc = 'Visual Mode' })
map('x', '<Leader><Leader>', '<Esc>', { desc = 'Exit Visual Mode' })

-- Select last paste
map('n', 'vsp', "'`['.strpart(getregtype(), 0, 1).'`]'", { expr = true, desc = 'Select Paste' })

-- Quick substitute within selected area
map('x', 'sg', ':s//gc<Left><Left><Left>', { desc = 'Substitute Within Selection' })

-- C-r: Easier search and replace visual/select mode
map(
	'x',
	'<C-r>',
	":<C-u>%s/\\V<C-R>=v:lua.get_visual_selection()<CR>"
		.. '//gc<Left><Left><Left>',
	{ desc = 'Replace Selection' }
)

-- Use tab for indenting in visual/select mode
map('x', '<Tab>', '>', { remap = true, desc = 'Indent Left' })
map('x', '<S-Tab>', '<', { remap = true, desc = 'Indent Right' })

-- Better block-wise operations on selected area
local blockwise_force = function(key)
	local c_v = vim.api.nvim_replace_termcodes('<C-v>', true, false, true)
	local keyseq = {
		I  = { v = '<C-v>I',  V = '<C-v>^o^I', [c_v] = 'I' },
		A  = { v = '<C-v>A',  V = '<C-v>0o$A', [c_v] = 'A' },
		gI = { v = '<C-v>0I', V = '<C-v>0o$I', [c_v] = '0I' },
	}
	return function()
		return keyseq[key][vim.fn.mode()]
	end
end
map('x', 'I',  blockwise_force('I'),  { expr = true, noremap = true, desc = 'Blockwise Insert' })
map('x', 'gI', blockwise_force('gI'), { expr = true, noremap = true, desc = 'Blockwise Insert' })
map('x', 'A',  blockwise_force('A'),  { expr = true, noremap = true, desc = 'Blockwise Append' })

-- }}}
-- Jump to {{{

map('n', ']a', '<cmd>lnext<CR>', { desc = 'Next Loclist' })
map('n', '[a', '<cmd>lprev<CR>', { desc = 'Previous Loclist' })

-- Whitespace jump (see plugin/whitespace.vim)
map('n', ']z', function() whitespace_jump(1) end, { desc = 'Next Whitespace' })
map('n', '[z', function() whitespace_jump(-1) end, { desc = 'Previous Whitespace' })

-- }}}
-- Clipboard {{{
-- ===

-- Paste in visual-mode without pushing to register
map('x', 'p', 'P', { silent = true, desc = 'Paste' })

-- Yank buffer's relative path to clipboard
map('n', '<Leader>y', function()
	local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.') or ''
	vim.fn.setreg('+', path)
	vim.notify(path, vim.log.levels.INFO, { title = 'Yanked relative path' })
end, { silent = true, desc = 'Yank relative path' })

-- Yank absolute path
map('n', '<Leader>Y', function()
	local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p') or ''
	vim.fn.setreg('+', path)
	vim.notify(path, vim.log.levels.INFO, { title = 'Yanked absolute path' })
end, { silent = true, desc = 'Yank absolute path' })

-- }}}
-- Coding {{{

-- Comment
unmap('n', { 'gra', 'gri', 'grr', 'grn' })
map('n', '<Leader>v', 'gcc', { remap = true, desc = 'Comment Line' })
map('x', '<Leader>v', 'gc', { remap = true, desc = 'Comment Selection' })

-- Macros
map('n', '<C-q>', 'q', { desc = 'Macro Prefix' })

-- Formatting
map('n', '<leader>cid', '<cmd>LazyDev<CR>', { silent = true, desc = 'Dev' })
map({ 'n', 'x' }, '<leader>cf', function() require('rafi.util.format').format({ force = true }) end, { desc = 'Format' })
map('n', '<leader>cif', function() require('rafi.util.format').info() end, { desc = 'Formatter Info' })
require('rafi.util.format').snacks_toggle():map('<leader>uf')
require('rafi.util.format').snacks_toggle(true):map('<leader>uF')
vim.api.nvim_create_user_command('RafiRoot', function()
	require('rafi.util.root').info()
end, { desc = 'Roots for the current buffer' })
map('n', '<leader>cir', '<cmd>RafiRoot<CR>', { silent = true, desc = 'Root' })
map('n', '<leader>cil', function() Snacks.picker.lsp_config() end, { desc = 'LSP Info' })
map({ 'n', 'x' }, '<leader>cs', function() formatter_select() end, { desc = 'Formatter Select' })

-- Start new line from any cursor position in insert-mode
map('i', '<S-Return>', '<C-o>o', { desc = 'Start Newline' })
map('n', ']<Leader>', ':set paste<CR>m`o<Esc>``:set nopaste<CR>', { silent = true, desc = 'Newline' })
map('n', '[<Leader>', ':set paste<CR>m`O<Esc>``:set nopaste<CR>', { silent = true, desc = 'Newline' })

-- Drag current line(s) vertically and auto-indent
map('n', '<Leader>k', '<cmd>move-2<CR>==', { silent = true, desc = 'Move line up' })
map('n', '<Leader>j', '<cmd>move+<CR>==', { silent = true, desc = 'Move line down' })
map('x', '<Leader>k', ":move'<-2<CR>gv=gv", { silent = true, desc = 'Move selection up' })
map('x', '<Leader>j', ":move'>+<CR>gv=gv", { silent = true, desc = 'Move selection down' })

-- Duplicate lines without affecting PRIMARY and CLIPBOARD selections.
map('n', '<Leader>dd', 'm`""Y""P``', { desc = 'Duplicate line' })
map('x', '<Leader>dd', '""Y""Pgv', { desc = 'Duplicate selection' })

-- }}}
-- Search, substitute, diff {{{

-- Switch */g* and #/g#
map('n', '*', 'g*')
map('n', 'g*', '*')
map('n', '#', 'g#')
map('n', 'g#', '#')

map('n', '<C-c>', 'ciw', { desc = 'Change Inner Word' })

-- Use backspace key for matching pairs
map({ 'n', 'x' }, '<BS>', '%', { remap = true, desc = 'Jump to Paren' })

-- Toggle diff on all windows in current tab
map('n', '<Leader>bf', function()
	vim.cmd('windo diff' .. (vim.wo.diff and 'off' or 'this'))
end, { desc = 'Diff Windows in Tab' })

-- External diff
map('n', '<Leader>bF', '<cmd>!' .. vim.g.diffprg .. ' % #<CR>', { desc = 'Diff with' .. vim.g.diffprg })

-- }}}
-- Command & History {{{

-- Put vim command output into buffer
map('n', 'g!', ":put=execute('')<Left><Left>", { desc = 'Paste Command' })

-- Switch history search pairs, matching my bash shell
map('c', '<Up>', '<C-p>')
map('c', '<Down>', '<C-n>')
map('c', '<C-p>', function()
	return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
end, { expr = true })
map('c', '<C-n>', function()
	return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
end, { expr = true })

-- }}}
-- File operations {{{

-- Switch (tab) to the directory of the current opened buffer
map('n', '<Leader><Tab>c', function()
	local bufdir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:h')
	if bufdir ~= nil and vim.uv.fs_stat(bufdir) then
		vim.cmd.tcd(bufdir)
		vim.notify(bufdir)
	end
end, { desc = 'Change Tab Directory' })

-- Fast saving from all modes
unmap('n', { '<leader>wd', '<leader>wm' })
map('n', '<Leader>w', '<cmd>write<CR>', { desc = 'Save File' })
map('n', '<M-s>', '<cmd>write<CR>', { desc = 'Save File' })

-- }}}
-- Diagnostics {{{

map('n', '<Leader>ce', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Set locations with diagnostics and open the list.
-- map('n', '<Leader>a', function()
-- 	if vim.bo.filetype ~= 'qf' then
-- 		vim.diagnostic.setloclist({ open = false })
-- 	end
-- 	toggle_list('loclist')
-- end, { desc = 'Open Location List' })

-- }}}
-- Plugins & Tools {{{

-- Package-manager
map('n', '<leader>mx', '<cmd>RafiExtras<cr>', { desc = 'Open Plugin Extras' })

-- Append mode-line to current buffer
map('n', '<Leader>ml', function() append_modeline() end, { desc = 'Append Modeline' })

-- Jump entire buffers throughout jumplist
map('n', 'g<C-i>', function() jump_buffer(1) end, { desc = 'Jump to newer buffer' })
map('n', 'g<C-o>', function() jump_buffer(-1) end, { desc = 'Jump to older buffer' })

-- Context aware menu. See lua/rafi/config/autocmds.lua
map('n', '<LocalLeader>c', function()
	-- Only right-click fires MenuPopup, so fire it here
	vim.api.nvim_exec_autocmds('MenuPopup', { pattern = 'n', modeline = false })
	pcall(vim.cmd.popup, 'PopUp')
end, { desc = 'Context-aware menu' })

-- Base64 encode/decode
map('x', '<leader>64e', function() base64() end, { desc = 'Base64 Encode' })
map('x', '<leader>64d', function() base64(false) end, { desc = 'Base64 Decode' })

-- Lazygit
if vim.fn.executable('lazygit') == 1 then
	---@diagnostic disable-next-line: missing-fields
	map('n', '<leader>gt', function() Snacks.lazygit( { cwd = require('rafi.util.root').git() }) end, { desc = 'Lazygit (Root Dir)' })
	map('n', '<leader>gT', function() Snacks.lazygit() end, { desc = 'Lazygit (cwd)' })
end

map('n', '<leader>gm', function() Snacks.picker.git_log_line() end, { desc = 'Git Blame Line' })
map({ 'n', 'x' }, '<leader>go', function() Snacks.gitbrowse() end, { desc = 'Git Browse (open)' })

-- Terminal Mappings
map('t', '<C-g>', '<C-\\><C-n>', { desc = 'Enter Normal Mode' })

-- todo.md
map('n', '<Leader>mk', function() require('rafi.util.todo-md').open() end, { desc = 'Open todo.md' })
map('n', '<Leader>mK', function() require('rafi.util.todo-md').find_snacks() end, { desc = 'Open todo.md' })

if vim.fn.has('mac') then
	-- Open the macOS dictionary on current word
	map('n', '<Leader>?', '<cmd>silent !open dict://<cword><CR>', { desc = 'Dictionary' })
end

-- }}}
-- Windows and buffers {{{

-- When enabled, 'q' closes any window.
if vim.F.if_nil(vim.g.window_q_mapping, false) then
	map('n', 'q', function()
		local plugins = {
			'blame',
			'checkhealth',
			'dbout',
			'fugitive',
			'fugitiveblame',
			'gitsigns-blame',
			'grug-far',
			'help',
			'httpResult',
			'lspinfo',
			'neotest-output',
			'neotest-output-panel',
			'neotest-summary',
			'notify',
			'PlenaryTestPopup',
			'qf',
			'spectre_panel',
			'startuptime',
			'tsplayground',
		}
		local buf = vim.api.nvim_get_current_buf()
		if vim.tbl_contains(plugins, vim.bo[buf].filetype) then
			vim.bo[buf].buflisted = false
			pcall(vim.api.nvim_buf_delete, buf)
		else
			-- Find non-floating windows
			local wins = vim.fn.filter(vim.api.nvim_list_wins(), function(_, win)
				if vim.api.nvim_win_get_config(win).zindex then
					return nil
				end
				return win
			end)
			-- If last window, quit
			if #wins > 1 then
				vim.api.nvim_win_close(0, false)
			else
				vim.cmd[[quit]]
			end
		end
	end, { desc = 'Close window' })
end

map('n', 's', '<Nop>', { desc = '+screen' })
map('n', 's]', '<C-w>x<C-w>w', { remap = true, desc = 'Swap adjacent windows' })
map('n', 'sb', '<cmd>buffer#<CR>', { desc = 'Alternate buffer' })
map('n', 'sc', '<cmd>close<CR>', { desc = 'Close window' })
map('n', 'sd', '<cmd>bdelete<CR>', { desc = 'Buffer delete' })
map('n', 'sv', '<cmd>split<CR>', { desc = 'Split window horizontally' })
map('n', 'sg', '<cmd>vsplit<CR>', { desc = 'Split window vertically' })
map('n', 'st', '<cmd>tabnew<CR>', { desc = 'New tab' })
map('n', 'so', '<cmd>only<CR>', { desc = 'Close other windows' })
map('n', 'sq', '<cmd>quit<CR>', { desc = 'Quit' })
Snacks.toggle.zoom():map('sz')
Snacks.toggle.zen():map('sZ')
map('n', 'sx', function()
	Snacks.bufdelete({ wipe = true })
	vim.cmd.enew()
end, { desc = 'Delete buffer and open new' })

-- }}}

-- FUNCTIONS
-- ===

-- Get visually selected lines.
-- Source: https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/utils.lua
---@return string
function _G.get_visual_selection() -- {{{
	-- This exits visual mode. Use 'gv' to reselect the text.
	local _, csrow, cscol, cerow, cecol
	local mode = vim.fn.mode()
	local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, mode)
	if is_visual then
		-- if we are in visual mode use the live position
		_, csrow, cscol, _ = unpack(vim.fn.getpos('.') or { 0, 0, 0, 0 })
		_, cerow, cecol, _ = unpack(vim.fn.getpos('v') or { 0, 0, 0, 0 })
		if mode == 'V' then
			-- visual line doesn't provide columns
			cscol, cecol = 0, 999
		end
	else
		-- otherwise, use the last known visual position
		_, csrow, cscol, _ = unpack(vim.fn.getpos("'<") or { 0, 0, 0, 0 })
		_, cerow, cecol, _ = unpack(vim.fn.getpos("'>") or { 0, 0, 0, 0 })
	end
	-- swap vars if needed
	if cerow < csrow then
		csrow, cerow = cerow, csrow
	end
	if cecol < cscol then
		cscol, cecol = cecol, cscol
	end
	local lines = vim.fn.getline(csrow, cerow)
	-- local n = cerow-csrow+1
	local n = #lines
	if n <= 0 or type(lines) ~= 'table' then
		return ''
	end
	lines[n] = string.sub(lines[n], 1, cecol)
	lines[1] = string.sub(lines[1], cscol)
	return table.concat(lines, '\n')
end -- }}}

--- Base64 encode/decode
---@param encode? boolean
function _G.base64(encode) -- {{{
	vim.cmd('normal! c')
	encode = encode == nil and true or encode
	local txt = vim.fn.getreg()
	if not encode then
		txt = vim.trim(txt)
	end
	local out = ''
	if vim.base64 then
		out = encode and vim.base64.encode(txt) or vim.base64.decode(txt)
	else
		out = vim.fn.system(encode and 'base64' or 'base64 --decode', txt)
	end
	vim.api.nvim_paste(out, false, -1)
end -- }}}

-- Append modeline at end of file.
function _G.append_modeline() -- {{{
	local modeline = string.format(
		'vim: set ts=%d sw=%d tw=%d %set :',
		vim.bo.tabstop,
		vim.bo.shiftwidth,
		vim.bo.textwidth,
		vim.bo.expandtab and '' or 'no'
	)
	local cs = vim.bo.commentstring
	local ok, tccs = pcall(require, 'ts_context_commentstring.internal')
	if ok then
		local ts_cs = tccs.calculate_commentstring()
		if ts_cs then
			cs = ts_cs
		end
	end
	if not cs then
		vim.notify('No commentstring found', vim.log.levels.WARN)
		return
	end
	modeline = string.gsub(cs, '%%s', modeline)
	vim.api.nvim_buf_set_lines(0, -1, -1, false, { modeline })
end -- }}}

-- Go to newer/older buffer through jumplist.
---@param direction 1 | -1
function _G.jump_buffer(direction) -- {{{
	local jumplist, curjump = unpack(vim.fn.getjumplist() or { 0, 0 })
	if #jumplist == 0 then
		return
	end
	local cur_buf = vim.api.nvim_get_current_buf()
	local jumpcmd = direction > 0 and '<C-i>' or '<C-o>'
	local searchrange = {}
	curjump = curjump + 1
	if direction > 0 then
		searchrange = vim.fn.range(curjump + 1, #jumplist)
	else
		searchrange = vim.fn.range(curjump - 1, 1, -1)
	end

	for _, i in ipairs(searchrange) do
		local nr = jumplist[i]['bufnr']
		if nr ~= cur_buf and vim.fn.bufname(nr):find('^%w+://') == nil then
			local n = tostring(math.abs(i - curjump))
			vim.notify('Executing ' .. jumpcmd .. ' ' .. n .. ' times')
			jumpcmd = vim.api.nvim_replace_termcodes(jumpcmd, true, true, true)
			vim.cmd.normal({ n .. jumpcmd, bang = true })
			break
		end
	end
end -- }}}

-- Jump to next/previous whitespace error.
---@param direction 1 | -1
function _G.whitespace_jump(direction) -- {{{
	local opts = 'wz'
	if direction < 1 then
		opts = opts .. 'b'
	end

	-- Whitespace pattern: Trailing whitespace or mixed tabs/spaces.
	local pat = '\\s\\+$\\| \\+\\ze\\t'
	vim.fn.search(pat, opts)
end -- }}}

-- Toggle list window
---@param name "quickfix" | "loclist"
function _G.toggle_list(name) -- {{{
	for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(win) and vim.fn.win_gettype(win) == name then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	if name == 'loclist' then
		vim.cmd([[ botright lopen ]])
	else
		vim.cmd([[ botright copen ]])
	end
end -- }}}

-- Display a list of formatters and apply the selected one.
function _G.formatter_select() -- {{{
	local buf = vim.api.nvim_get_current_buf()
	local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, vim.fn.mode())
	local cur_start, cur_end
	if is_visual then
		cur_start = vim.fn.getpos('.')
		cur_end = vim.fn.getpos('v')
	end

	-- Collect various sources of formatters.
	---@class rafi.Formatter
	---@field kind string
	---@field name string
	---@field client rafi.util.format.Resolved

	---@type rafi.Formatter[]
	local sources = {}
	local fmts = require('rafi.util.format').resolve(buf)
	for _, fmt in ipairs(fmts) do
		vim.tbl_map(function(resolved)
			table.insert(sources, {
				kind = fmt.name,
				name = resolved,
				client = fmt,
			})
		end, fmt.resolved)
	end

	local total_sources = #sources

	-- Apply formatter source on buffer.
	---@param bufnr number
	---@param source rafi.Formatter
	local apply_source = function(bufnr, source)
		if source == nil then
			return
		end
		local ok, err = pcall(source.client.format, bufnr)
		if not ok then
			vim.notify(
				'Formatter `' .. source.name .. '` failed\n' .. tostring(err),
				vim.log.levels.ERROR
			)
		end
	end

	if total_sources == 1 then
		apply_source(buf, sources[1])
	elseif total_sources > 1 then
		-- Display a list of sources to choose from
		vim.ui.select(sources, {
			prompt = 'Select a formatter',
			format_item = function(item)
				return item.name .. ' (' .. item.kind .. ')'
			end,
		}, function(selected)
			if is_visual then
				-- Restore visual selection
				vim.fn.setpos('.', cur_start)
				vim.cmd([[normal! v]])
				vim.fn.setpos('.', cur_end)
			end
			apply_source(buf, selected)
		end)
	else
		vim.notify(
			'No configured formatters for this filetype.',
			vim.log.levels.WARN
		)
	end
end -- }}}

-- vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
```
:::

### Autocmds

:::tabs
```lua [Your lua/config/autocmds.lua]
-- Autocmds load right after rafi.config.autocmds.
-- Defaults that are always set:
-- https://github.com/rafi/vim-config/blob/master/lua/rafi/config/autocmds.lua
-- Add your own autocmds here.

-- For example, turn spell checking off in Markdown buffers:
-- vim.api.nvim_create_autocmd('FileType', {
-- 	group = vim.api.nvim_create_augroup('user.markdown', {}),
-- 	pattern = 'markdown',
-- 	callback = function()
-- 		vim.opt_local.spell = false
-- 	end,
-- })
```
```lua [Default rafi.config.autocmds]
-- Rafi's Neovim autocmds
-- https://github.com/rafi/vim-config
-- ===
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- This file is automatically loaded by rafi.config.setup() (init.lua)

local function augroup(name)
	return vim.api.nvim_create_augroup('rafi.' .. name, { clear = true })
end

-- General autocmds
-- ===

-- Reload the file when it changed outside Neovim
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
	group = augroup('checktime'),
	callback = function()
		if vim.o.buftype ~= 'nofile' then
			vim.cmd('checktime')
		end
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
	group = augroup('highlight_yank'),
	callback = function()
		if vim.fn.has('nvim-0.13') == 1 then
			vim.hl.hl_op()
		else
			---@diagnostic disable-next-line: deprecated
			(vim.hl or vim.highlight).on_yank()
		end
	end,
})

-- Resize splits when the window is resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
	group = augroup('resize_splits'),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd('tabdo wincmd =')
		vim.cmd('tabnext ' .. current_tab)
	end,
})

-- Close some filetypes with <q>. Includes rafi's (blame, fugitive,
-- fugitiveblame, httpResult).
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('close_with_q'),
	pattern = {
		'PlenaryTestPopup',
		'blame',
		'checkhealth',
		'dap-float',
		'dbout',
		'fugitive',
		'fugitiveblame',
		'gitsigns-blame',
		'grug-far',
		'help',
		'httpResult',
		'lspinfo',
		'neotest-output',
		'neotest-output-panel',
		'neotest-summary',
		'notify',
		'qf',
		'spectre_panel',
		'startuptime',
		'tsplayground',
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set('n', 'q', function()
				vim.cmd('close')
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = 'Quit buffer',
			})
		end)
	end,
})

-- Make man pages opened inline easier to close
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('man_unlisted'),
	pattern = { 'man' },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})

-- Wrap and check spelling in text filetypes
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('wrap_spell'),
	pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
	group = augroup('json_conceal'),
	pattern = { 'json', 'jsonc', 'json5' },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory
-- does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	group = augroup('auto_create_dir'),
	callback = function(event)
		if event.match:match('^%w%w+:[\\/][\\/]') then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
	end,
})

-- Rafi's autocmds
-- ===

-- Go to last loc when opening a buffer, see ':h last-position-jump'
vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup('last_loc'),
	callback = function(event)
		local exclude = { 'gitcommit', 'commit', 'gitrebase' }
		local buf = event.buf
		if
			vim.tbl_contains(exclude, vim.bo[buf].filetype)
			or vim.b[buf].rafi_last_loc
		then
			return
		end
		vim.b[buf].rafi_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Show cursor line only in active window
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
	group = augroup('auto_cursorline_show'),
	callback = function(event)
		if vim.bo[event.buf].buftype == '' then
			vim.opt_local.cursorline = true
		end
	end,
})
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
	group = augroup('auto_cursorline_hide'),
	callback = function()
		vim.opt_local.cursorline = false
	end,
})

-- Disable swap/undo/backup files in temp directories or shm
vim.api.nvim_create_autocmd('BufWritePre', {
	group = augroup('undo_disable'),
	pattern = { '/tmp/*', '*.tmp', '*.bak', 'COMMIT_EDITMSG', 'MERGE_MSG' },
	callback = function(event)
		vim.opt_local.undofile = false
		if event.file == 'COMMIT_EDITMSG' or event.file == 'MERGE_MSG' then
			vim.opt_local.swapfile = false
		end
	end,
})

-- Disable swap/undo/backup files in temp directories or shm
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
	group = augroup('secure'),
	pattern = {
		'/tmp/*',
		'$TMPDIR/*',
		'$TMP/*',
		'$TEMP/*',
		'/dev/shm/*',
		'/private/var/*',
		'/private/tmp/*',
	},
	callback = function()
		vim.opt_local.undolevels = -1 -- Disables undo entirely
		vim.opt_local.undofile = false -- Prevents writing undo history to disk
		vim.opt_local.swapfile = false -- Disables swap file creation
		vim.opt_local.backup = false -- Disables backup file creation
		vim.opt_local.shada = '' -- Prevents history from being saved to ShAda
		vim.opt_local.writebackup = false
		vim.opt_local.shelltemp = false
		vim.opt_local.history = 0
		-- vim.opt_global.backup = false
		-- vim.opt_global.writebackup = false
	end,
})

-- Context-aware popup menu (Overrides $VIMRUNTIME/lua/vim/_defaults.lua)
vim.api.nvim_create_autocmd('MenuPopup', {
	group = augroup('popupmenu'),
	pattern = '*',
	callback = function()
		local cword = vim.fn.expand('<cword>')
		vim.cmd([[
			aunmenu PopUp
			autocmd! nvim.popupmenu

			anoremenu PopUp.Inspect                 <cmd>Inspect<CR>
			anoremenu PopUp.Definition              <cmd>lua vim.lsp.buf.definition()<CR>
			anoremenu PopUp.References              <cmd>lua vim.lsp.buf.references()<CR>
			anoremenu PopUp.Implementation          <cmd>lua vim.lsp.buf.implementation()<CR>
			anoremenu PopUp.Declaration             <cmd>lua vim.lsp.buf.declaration()<CR>
			anoremenu PopUp.-1-                     <Nop>
			anoremenu PopUp.Diagnostics\ (Trouble)  <cmd>Trouble diagnostics<CR>
			anoremenu PopUp.Show\ Diagnostics       <cmd>lua vim.diagnostic.open_float()<CR>
			anoremenu PopUp.Show\ All\ Diagnostics  <cmd>lua vim.diagnostic.setqflist()<CR>
			anoremenu PopUp.Configure\ Diagnostics  <cmd>help vim.diagnostic.config()<CR>
			anoremenu PopUp.-2-                     <Nop>
			anoremenu PopUp.Find\ symbol            <cmd>lua require'telescope.builtin'.lsp_workspace_symbols({default_text = vim.fn.expand('<cword>')})<CR>
			anoremenu PopUp.Grep                    <cmd>lua require('rafi.util.pick')('live_grep', { pattern = vim.fn.expand('<cword>') })()<CR>
			anoremenu PopUp.TODOs                   <cmd>TodoTrouble<CR>
			anoremenu PopUp.Bookmarks               <cmd>lua require'bookmarks'.bookmark_list()<CR>
			anoremenu PopUp.LazyGit                 <cmd>lua Snacks.lazygit()<CR>
			anoremenu PopUp.Open\ Git\ in\ browser  <cmd>lua Snacks.gitbrowse()<CR>
			anoremenu PopUp.Open\ in\ web\ browser  gx
			anoremenu PopUp.-3-                     <Nop>
			vnoremenu PopUp.Cut                     "+x
			vnoremenu PopUp.Copy                    "+y
			anoremenu PopUp.Paste                   "+gP
			vnoremenu PopUp.Paste                   "+P
			vnoremenu PopUp.Delete                  "_x
			nnoremenu PopUp.Select\ All             ggVG
			vnoremenu PopUp.Select\ All             gg0oG$
			inoremenu PopUp.Select\ All             <C-Home><C-O>VG
		]])

		-- LSP
		-- ===

		if
			cword == ''
			or not vim.lsp.get_clients({
				bufnr = 0,
				method = 'textDocument/definition',
			})
		then
			vim.cmd([[amenu disable PopUp.Definition]])
		end
		if
			cword == ''
			or not vim.lsp.get_clients({
				bufnr = 0,
				method = 'textDocument/references',
			})
		then
			vim.cmd([[amenu disable PopUp.References]])
		end
		if
			cword == ''
			or not vim.lsp.get_clients({
				bufnr = 0,
				method = 'textDocument/implementation',
			})
		then
			vim.cmd([[amenu disable PopUp.Implementation]])
		end
		if
			cword == ''
			or not vim.lsp.get_clients({
				bufnr = 0,
				method = 'textDocument/declaration',
			})
		then
			vim.cmd([[amenu disable PopUp.Declaration]])
		end

		-- Plugins
		-- ===

		if cword == '' or not require('rafi.pack').has('telescope.nvim') then
			vim.cmd([[amenu disable PopUp.Find\ symbol]])
		end
		if cword == '' then
			vim.cmd([[amenu disable PopUp.Grep]])
		end
		if not require('rafi.pack').has('trouble.nvim') then
			vim.cmd([[amenu disable PopUp.Diagnostics\ (Trouble)]])
		end
		if not require('rafi.pack').has('todo-comments.nvim') then
			vim.cmd([[amenu disable PopUp.TODOs]])
		end
		if not require('rafi.pack').has('bookmarks.nvim') then
			vim.cmd([[amenu disable PopUp.Bookmarks]])
		end
		if not _G.Snacks then
			vim.cmd([[
				amenu disable PopUp.LazyGit
				amenu disable PopUp.Open\ Git\ in\ browser
			]])
		end
	end,
})
```
:::

## Extras and core plugins

`rafi.json` in your config directory lists the extras you enabled and the
core plugins you disabled. `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>)
edits it for you, or you can edit it by hand and restart Neovim:

```json
{
	"extras": ["editor.dial", "lang.go", "ui.deadcolumn"],
	"disabled": ["lualine"]
}
```

A core plugin in `disabled` doesn't load, so you can replace it with your
own file. `snacks` can't be disabled.

## Your plugins

Every `lua/plugins/*.lua` file is plain Lua, sourced after the extras. Add
plugins with `vim.pack.add()` and set them up right there. See the
examples below.

## Your extras

An extra of your own goes in `lua/plugins/extras/<category>/<name>.lua`.
Start it with a comment line describing it: `:RafiExtras` shows that line
and lists your extra next to Rafi's.

## LSP settings

Override a server's settings with `vim.lsp.config()` in one of your
plugin files, or in `after/lsp/<server>.lua`.

## Examples

### Add a plugin

Save it as lua/plugins/gruvbox.lua. vim.pack installs it on the next start, and `:colorscheme gruvbox` switches to it.

```lua
vim.pack.add({ 'https://github.com/ellisonleao/gruvbox.nvim' })
require('gruvbox').setup({ contrast = 'hard' })
```

### Load a plugin on first use

rafi.pack runs the code on the first event, filetype or command, so the plugin doesn't slow down startup.

```lua
local pack = require('rafi.pack')

pack.on_event('InsertEnter', function()
	vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' })
	require('nvim-autopairs').setup()
end)

pack.on_filetype('csv', function()
	vim.pack.add({ 'https://github.com/hat0uma/csvview.nvim' })
	require('csvview').setup()
end)
```

### Replace a core plugin

Add "lualine" to `disabled` in rafi.json, then load your own statusline in lua/plugins/lightline.lua.

```lua
vim.pack.add({ 'https://github.com/itchyny/lightline.vim' })
vim.g.lightline = { colorscheme = 'wombat' }
```

### Write your own extra

Save it as lua/plugins/extras/editor/zen.lua and turn it on with `:RafiExtras`. The first line is the description it shows.

```lua
-- Distraction-free writing
local pack = require('rafi.pack')

pack.command('ZenMode', function()
	vim.pack.add({ 'https://github.com/folke/zen-mode.nvim' })
	require('zen-mode').setup({ window = { width = 90 } })
end)
vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<CR>', { desc = 'Zen Mode' })
```

### Change LSP settings

In a lua/plugins/*.lua file, or as `after/lsp/<server>.lua` returning the table.

```lua
vim.lsp.config('yamlls', {
	filetypes = { 'yaml', 'yaml.ansible', 'yaml.docker-compose' },
})
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			workspace = { checkThirdParty = false },
			completion = { callSnippet = 'Replace' },
		},
	},
})
```
