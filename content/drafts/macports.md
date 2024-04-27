---
title: Macports provisioning
date: '2018-09-30'
search:
  keywords: ['osx', 'provision', 'mac', 'macports']
---
# Macports

<!-- vim-markdown-toc GFM -->

* [Base Ports](#base-ports)
* [Custom Ports](#custom-ports)
* [Defaults](#defaults)
* [Python Utilities](#python-utilities)
* [Development Environments](#development-environments)
  * [Apache 2.2, PHP 5.6, and MySQL 5.5 or Percona](#apache-22-php-56-and-mysql-55-or-percona)

<!-- vim-markdown-toc -->

Install [MacPorts](https://www.macports.org/install.php), choose version.

## Base Ports

```bash
sudo port -v selfupdate
sudo port install \
  coreutils gnutls bash bash-completion less z mas entr \
  tmux tmux-pasteboard tmux-mem-cpu-load \
  bc tree colordiff pstree jq urlview tcpdump nmap readline \
  rsync aria2 curl unrar gnetcat ttyrec the_silver_searcher \
  id3lib libcaca libexif libmms faad2 terminal-notifier \
  figlet fortune keychain mpc p7zip sshpass tarsnap spark exiv2 \
  lnav ncdu calc tidy pngcrush watch pidof pinfo \
  atool p5-image-exiftool cloc aspell aspell-dict-en aspell-dict-he \
  go gnupg2 grc ncmpcpp pango poppler icdiff bat \
  git git-cal git-extras colout pass peco ranger xmlstarlet \
  wget nodejs8 npm5 highlight mpv shellcheck sshfs xsel \
  vim +cscope+lua+perl+python27+python36 \
  MacVim +cscope+lua+perl+python27+python36 \
  neomutt +gpgme+headercache+homespool+sidebar+smtp \
  cam ccat editorconfig-core-c jrnl pipsi rclone resty task tig \
  tmux-xpanes ttygif vit yarn hstr zsh fish
```

## Custom Ports

Install local Macports repository, i.e. [rafi/portfiles](https://github.com/rafi/portfiles)

```bash
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

```bash
  if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
      . /opt/local/etc/profile.d/bash_completion.sh
  fi
```

The port bash-completion >=2.0 requires bash >=4.1; please make sure
you are using /opt/local/bin/bash by changing the preferences of your
terminal accordingly.

To start the `gpg-agent` on startup, run:

```bash
launchctl load -w /Library/LaunchAgents/org.macports.gpg-agent.plist
```

## Python Utilities

```bash
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
```

## Development Environments

### Apache 2.2, PHP 5.6, and MySQL 5.5 or Percona

First disable built-in Apache: _System Preferences_ **->** _Sharing_
and uncheck the "Personal Web sharing". Or, from terminal:

```bash
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
```

PHP and Apache:

```bash
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
