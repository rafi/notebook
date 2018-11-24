---
title: Package Managers, part 1
date: 2017-06-03
updated:
description:
categories:
tags:
---
# Package Managers

Until Vim8, the ecosystem of plugin managers offered numerous unofficial
solutions with popular ones like:

* [Dein]
* [Vundle]
* [NeoBundle]
* [vim-plug]
* [Pathogen]

With Vim 8, native third-party package loading has been introduced.

See [vim-startuptime-benchmark] for a comparison of startup times.

## Vim8 Native Package Loading

Inside Vim, run `:h packages` to read the original documentation.

### Directory layout

Directory layout for packages is given as the following.

```
start/foobar/plugin/foo.vim       " always loaded, defines commands
start/foobar/plugin/bar.vim       " always loaded, defines commands
start/foobar/autoload/foo.vim     " loaded when foo command used
start/foobar/doc/foo.txt          " help for foo.vim
start/foobar/doc/tags             " help tags
opt/fooextra/plugin/extra.vim     " optional plugin, defines commands
opt/fooextra/autoload/extra.vim   " loaded when extra command used
opt/fooextra/doc/extra.txt        " help for extra.vim
opt/fooextra/doc/tags             " help tags
```

## Unofficial Package-Managers

Unofficial package-managers that keep track and setup plugins from your .vimrc

### Dein

Simple and faster than NeoBundle.

* No commands, Functions only to simplify the implementation
* Easy to test and maintain
* No Vundle/NeoBundle compatibility
* Neovim/Vim8 asynchronous API installation support
* Local plugin support
* Non-github plugins support
* Go like clone directory name, i.e. "github.com/{user}/{repository}"
* Merge the plugins directories automatically to avoid long `runtimepath`

### Vundle

Stable & simple solution, good for beginners.

* Update configured plugins
* Search by name all available Vim scripts
* Clean unused plugins up
* Run the above actions in a single key-press with interactive mode
* Regenerates help tags after installing and updating

### NeoBundle

_Warning:_ Active development on NeoBundle has stopped around February 2016.

* Complex
* Early development (may break compatibility)
* Good for plugin power users
* Can only accepts "https" or "ssh" protocols

### vim-plug

Easier to setup: Single file. No boilerplate code required.

* Super-fast parallel installation/update (with any of `+job`, `+python`, `+python3`, `+ruby`, or Neovim)
* Creates shallow clones to minimize disk space usage and download time
* On-demand loading for faster startup time
* Can review and rollback updates
* Branch/tag/commit support
* Post-update hooks
* Support for externally managed plugins

### Pathogen

A minimal solution that only:

* Auto-load plugins from a folder
* Generate help tags for these plugins

Cons:

* No install/update/remove management
* No lazy loading

#### Pathogen Tricks

* [Synchronizing plugins with git submodules and pathogen](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/)
* [Vimpyre] is a Python plugin manager for Pathogen and Git

### Notable Mentions

https://github.com/pchynoweth/vim-plugin-minimal
https://github.com/itchyny/miv
https://github.com/MarcWeber/vim-addon-manager
https://github.com/kamichidu/go-hariti
https://github.com/egalpin/apt-vim
https://github.com/mikejsavage/vim-git-puller
https://github.com/bohrshaw/vundle
https://github.com/rkulla/vimogen
https://github.com/airblade/voom
https://github.com/KevinSjoberg/vpm
https://github.com/xsc/microbe-vim
https://github.com/selectnull/vimanage
https://github.com/Carpetsmoker/packman.vim

[Dein]: https://github.com/Shougo/dein.vim
[Pathogen]: https://github.com/tpope/vim-pathogen
[NeoBundle]: https://github.com/Shougo/neobundle.vim
[vim-plug]: https://github.com/junegunn/vim-plug
[Vundle]: https://github.com/VundleVim/Vundle.vim
[vim-startuptime-benchmark]: https://github.com/junegunn/vim-startuptime-benchmark
[Vimpyre]: https://github.com/pct/vimpyre
