---
title: macOS provisioning
date: '2014-04-04'
featured: true
description:
categories:
- setup
search:
  keywords: ['osx', 'provision', 'mac', 'homebrew']
---
# Mac OSX provisioning

<!-- vim-markdown-toc GFM -->

* [Xcode](#xcode)
* [Homebrew](#homebrew)
* [Sensible hacker defaults](#sensible-hacker-defaults)
* [Homebrew](#homebrew)
* [Python Utilities](#python-utilities)
* [NodeJS Utilities](#nodejs-utilities)
* [Compile `neovim`](#compile-neovim)

<!-- vim-markdown-toc -->

## Xcode

* Install Xcode
* Install Xcode command line tools: `xcode-select --install`
* Agree to Xcode license in Terminal: `sudo xcodebuild -license`

## Sensible hacker defaults

```bash
sudo scutil --set HostName rafi-mac
```

Follow [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles/blob/master/.osx)
and use what ever you like.

## Homebrew

```bash
brew install \
  coreutils gnutls bash bash-completion@2 less z mas entr tmux bc \
  tmux-mem-cpu-load tmux-xpanes reattach-to-user-namespace tree \
  colordiff pstree jq urlview tcpdump nmap readline rsync aria2 \
  curl unrar netcat ttyrec ttygif ttyd the_silver_searcher id3lib \
  libexif libmms faad2 terminal-notifier figlet fortune gnu-sed \
  keychain p7zip tarsnap spark exiv2 lnav ncdu calc tidy-html5 \
  pngcrush watch pidof pinfo atool exif cloc gnupg grc pango bat \
  poppler icdiff git-cal git-extras pass peco ranger wget fd \
  xmlstarlet highlight shellcheck sshfs ccat editorconfig ctop \
  htop progress httpstat catimg fzf fzy ripgrep httpie pgcli \
  go node yarn zsh fish diff-so-fancy proselint subliminal yamllint \
  mpc ncmpcpp mpv neomutt jrnl rclone resty task vit tig glyr \
  kubernetes-cli kubernetes-helm kubectx stern gawk pineentry-mac

brew install libcaca --with-imlib2
brew install python python@2 pipenv --with-tcl-tk
brew install git --with-curl --with-openssl
brew install vim --with-lua --with-override-system-vi
brew install aspell --with-lang-he --without-lang-de --without-lang-es --without-lang-fr
brew install --HEAD neovim
brew install --HEAD universal-ctags/universal-ctags/universal-ctags

brew install rafi/tap/reg rafi/tap/yaml2json
brew install --HEAD diana cam

brew cask install transmission mpv atom bartender beyond-compare \
  clipy contexts dash docker iterm2 karabiner-elements keycastr licecap \
  marked slack spotify telegram typora whatsapp
```

## Python Utilities

```bash
pip3 install --user --upgrade pipsi

pipsi install pygments
pipsi install tmuxp
pipsi install vim-vint
pipsi install --python python2.7 gcalcli
```

## NodeJS Utilities

```bash
npm -g install mad tern write-good
npm -g install jshint jsxhint jsonlint stylelint markdownlint-cli sass-lint
npm -g install git+https://github.com/ramitos/jsctags.git
npm -g install resume-cli imagemin-cli raml-cop raml2html raml2md
```

## Docker completion

```bash
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion /usr/local/etc/bash_completion.d/docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion /usr/local/etc/bash_completion.d/docker-machine
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion /usr/local/etc/bash_completion.d/docker-compose
```

## Compile `neovim`

```bash
git clone git://github.com/neovim/neovim.git
cd neovim
make distclean
make CMAKE_BUILD_TYPE=Release DEPS_CMAKE_FLAGS=-DUSE_BUNDLED_BUSTED=OFF
make install
```
