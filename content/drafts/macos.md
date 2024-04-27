---
title: macOS provisioning
date: '2014-04-04'
featured: true
description:
categories:
- setup
search:
  keywords: ['osx', 'provision', 'mac', 'macports']
---
# Mac OSX provisioning

<!-- vim-markdown-toc GFM -->

* [Xcode](#xcode)
* [Macports](#macports)
* [Sensible hacker defaults](#sensible-hacker-defaults)
* [X11 .serverauth files](#x11-serverauth-files)
* [Base Ports](#base-ports)
* [Custom Ports](#custom-ports)
* [Defaults](#defaults)
* [Python Utilities](#python-utilities)
* [NodeJS Utilities](#nodejs-utilities)
* [Compile `neovim`](#compile-neovim)
* [Development Environments](#development-environments)
  * [Apache 2.2, PHP 5.6, and MySQL 5.5 or Percona](#apache-22-php-56-and-mysql-55-or-percona)
* [Dependency Reference](#dependency-reference)

<!-- vim-markdown-toc -->

## Xcode

- Install Xcode (see [help](https://www.macports.org/install.php))
- Install Xcode command line tools: `xcode-select --install`
- Agree to Xcode license in Terminal: `sudo xcodebuild -license`

## Macports

Install [MacPorts](https://www.macports.org/install.php), choose version.

## Sensible hacker defaults

```sh
sudo scutil --set HostName rafi-mac
```

Follow [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles/blob/master/.osx)
and use what ever you like.

## Base Ports

```sh
sudo port -v selfupdate
sudo port install \
  coreutils gnutls bash bash-completion less z mas entr \
  tmux tmux-pasteboard tmux-mem-cpu-load fish \
  bc tree colordiff pstree jq urlview tcpdump nmap readline \
  rsync aria2 curl unrar gnetcat ttyrec the_silver_searcher \
  id3lib libcaca libexif libmms faad2 terminal-notifier \
  figlet fortune keychain mpc p7zip sshpass tarsnap spark exiv2 \
  lnav ncdu calc tidy pngcrush watch watchman pidof pinfo hstr \
  atool p5-image-exiftool cloc aspell aspell-dict-en aspell-dict-he \
  go gnupg2 grc ncmpcpp pango poppler icdiff \
  git git-cal git-extras colout pass peco ranger xmlstarlet \
  wget texlive nodejs8 npm5 highlight mpv shellcheck sshfs xsel \
  vim +cscope+lua+perl+python27+python36 \
  MacVim +cscope+lua+perl+python27+python36 \
  neomutt +gpgme+headercache+homespool+sidebar+smtp
```

## Custom Ports

Install local Macports repository, i.e. [rafi/portfiles](https://github.com/rafi/portfiles)

```sh
sudo port install ctop-bin fd-bin diff-so-fancy diana dry-bin \
  htop-vim progress py36-httpstat ttyd timg glyr fzf fzy \
  migrate-bin ripgrep-bin universal-ctags
```

## Defaults

The tools provided by GNU coreutils are prefixed with the character 'g'
by default to distinguish them from the BSD commands. If you want to use
the GNU tools by default, add this directory to the front of your PATH:
`/opt/local/libexec/gnubin/`

To use bash completion, add the following lines at the end of your .bash_profile:

```sh
  if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
      . /opt/local/etc/profile.d/bash_completion.sh
  fi
```

The port bash-completion >=2.0 requires bash >=4.1; please make sure
you are using /opt/local/bin/bash by changing the preferences of your
terminal accordingly.

To start the `gpg-agent` on startup, run:

```sh
launchctl load -w /Library/LaunchAgents/org.macports.gpg-agent.plist
```

## Python Utilities

```sh
sudo port install \
  python27 py27-gnureadline py27-pip py27-virtualenv py27-flake8 \
  python36 py36-gnureadline py36-pip py36-virtualenv py36-flake8

# Set default versions
sudo port select --set python3 python36
sudo port select --set python2 python27
sudo port select --set python python36
sudo port select --set pip pip36
sudo port select --set virtualenv virtualenv36
sudo port select --set pycodestyle pycodestyle-py36
sudo port select --set pyflakes py36-pyflakes
sudo port select --set flake8 flake8-36

# Install packages
pip2 install --user vim-vint
pip3 install --user Pygments python-mpd2 pipdeptree proselint yamllint

pipenv httpie
pipenv subliminal
pipenv pgcli
pipenv tmuxp
pipenv git+https://github.com/rachmadaniHaryono/we-get
pipenv percol   # Python 2
pipenv gcalcli  # Python 2
pipenv git+https://github.com/ralphbean/bugwarrior.git@develop  # Python 2
```

## NodeJS Utilities

```sh
npm -g install mad tern write-good
npm -g install jshint jsxhint jsonlint stylelint markdownlint-cli sass-lint
npm -g install git+https://github.com/ramitos/jsctags.git
npm -g install resume-cli imagemin-cli raml-cop raml2html raml2md
```

## Compile `neovim`

```sh
git clone git://github.com/neovim/neovim.git
cd neovim
make distclean
make CMAKE_BUILD_TYPE=Release DEPS_CMAKE_FLAGS=-DUSE_BUNDLED_BUSTED=OFF CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=/opt/local"
make install
```

## Development Environments

### Apache 2.2, PHP 5.6, and MySQL 5.5 or Percona

First disable built-in Apache: _System Preferences_ **->** _Sharing_
and uncheck the "Personal Web sharing". Or, from terminal:

```sh
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
```

PHP and Apache:

```sh
sudo port install php56 +apache2 php56-apache2handler php56-curl php56-exif \
  php56-gd php56-geoip php56-gettext php56-http php56-iconv php56-mbstring \
  php56-mcrypt  php56-openssl php56-pdflib php56-pear php56-posix php56-soap \
  php56-sockets php56-solr php56-ssh2 php56-sqlite php56-xmlrpc php56-xsl \
  php56-zip
sudo port install php56-xdebug
sudo port install cronolog
sudo port select php php56

# You can get a list of the available configuration settings for xdebug with
# the following command:
#
#   php56 --ri xdebug

# 1. Add to environment: export PATH=/opt/local/apache2/bin:$PATH
# 2. Use a configuration from /opt/local/etc/php56
# 3. Symlink conf: sudo ln -s ~/.config/php/php56.ini /opt/local/etc/php56/php.ini
sudo /opt/local/apache2/bin/apxs -a -e -n php5 /opt/local/apache2/modules/mod_php56.so
sudo port load apache2
```
