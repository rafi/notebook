---
title: 'Neovim'
description: "Rafael Bodill's Neovim config: lean, fast, with opt-in extras"
published: true
---

Lean mean Neovim machine, 30-45ms startup time. Plugins are managed by
Neovim's built-in [vim.pack](https://neovim.io/doc/user/pack.html#vim.pack),
and almost all of them load lazily.

I started this configuration in 2014, when Vim became my primary editor.
Use it as is, or fork it and make it your own: it's at
[github.com/rafi/vim-config](https://github.com/rafi/vim-config).

## Prerequisites

- [git](https://git-scm.com/) ≥ 2.19.0
- [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim) ≥ 0.12,
  for `vim.pack`

Optional, but highly recommended:
[bat](https://github.com/sharkdp/bat),
[fd](https://github.com/sharkdp/fd),
[fzf](https://github.com/junegunn/fzf),
[ripgrep](https://github.com/BurntSushi/ripgrep) and
[zoxide](https://github.com/ajeetdsouza/zoxide).

## Install

1. Clone the repository to `~/.config/nvim`:

   ```bash
   mkdir -p ~/.config
   git clone git@github.com:rafi/vim-config.git ~/.config/nvim
   ```

2. Run `nvim`. It installs all plugins on the first start. Then run
   `:checkhealth` to make sure your system meets the requirements.

3. Run `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), press
   <kbd>Enter</kbd> on the extras you want, and restart Neovim. Your
   choices are saved in `rafi.json`.

## Upgrade

Update the config, and move plugins to the versions locked in its
`nvim-pack-lock.json`:

```bash
cd ~/.config/nvim
make update
```

To update plugins beyond that, review pending updates with `:Packman`
(<kbd>Space</kbd><kbd>l</kbd>) and apply them with <kbd>U</kbd>. Update
Mason packages with `:Mason` and <kbd>U</kbd>.

Coming from the lazy.nvim version? The
[upgrade notes](https://github.com/rafi/vim-config#upgrade-from-the-lazynvim-version)
list what changed.
