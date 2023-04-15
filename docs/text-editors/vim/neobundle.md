---
title: 'Spec''ing: NeoBundle - VIM plugin manager'
date: '2014-10-16'
category: vim
tags:
- plugin
- guide
---

## Install
### Dependencies
* Vim 7.2.051 or above.
* `git` command in $PATH (if you want to install github or vim.org plugins)

### Simple
```bash
$ mkdir -p ~/.vim/bundle
$ git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

# Add to your .vimrc:
set runtimepath+=~/.vim/bundle/neobundle.vim
```

### Advanced Auto-Install
```vim
let $VAR=expand('$XDG_CACHE_HOME/vim')
let s:plugins_dir = expand('$VAR/plugins')
let g:neobundle#types#git#default_protocol = 'git'

if ! isdirectory(expand($VAR))
	" Create the cache dir and the undo dir, too
	call mkdir(expand('$VAR/undo'), 'p')
endif

if has('vim_starting')
	set nocompatible
	" Load NeoBundle for package management
	if &runtimepath !~ '/neobundle.vim'
		if ! isdirectory(s:plugins_dir.'/neobundle.vim')
			" Clone NeoBundle if not found
			execute printf('!git clone %s://github.com/Shougo/neobundle.vim.git',
						\ (exists('$http_proxy') ? 'https' : 'git'))
						\ s:plugins_dir.'/neobundle.vim'
		endif

		execute 'set runtimepath^='.s:plugins_dir.'/neobundle.vim'
	endif
endif
```
* _Credits_: [Shougo](https://github.com/Shougo)

## Manage Plugins
**Please Note**: When specifying `[name...]`, you must use the plugin name, not
the repository. E.g.: 'vim-fugitive', 'neobundle.vim'.

### Searching
Search vimpusher.com and vim-scripts.org: `:Unite neobundle/search`

### Installing

#### Manual
- Somewhere in `.vimrc`: `NeoBundle [name...]`
- Within VIM: `:NeoBundleInstall [name...]`

#### Unite
Run `:Unite neobundle/search` with a keyword, and choose the 'install' action.

#### Initial Install
- From terminal: `vim +NeoBundleInstall +q`

#### Lazy-loading
Register a plugin, but don't add it to the `runtimepath`, load only when it's
needed.
Loading the plugin can be triggered by mappings, commands, functions, and even
manually: `:NeoBundleSource [name...]`

### Updating
Updating adheres to the outdated interval.
- Update plugins: `:NeoBundleUpdate [name...]`
- or, with Unite: `:Unite neobundle/update`

## Maintenance
- List all configured plugins: `:NeoBundleList`
- Generate documentation: `:NeoBundleDocs`
- Remove non-configured bundles: `:NeoBundleClean[!] [name...]`

  `!` will force remove, and if specifying names, remove only those.

### Logs
- Print previous install logs: `:NeoBundleLog`
- Print previous update logs: `:NeoBundleUpdatesLog`


## Unknown
`:NeoBundleLocal`
