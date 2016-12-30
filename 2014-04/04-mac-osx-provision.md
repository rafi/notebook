---
title: Mac OSX provisioning
date: '2014-04-04'
description:
categories:
- setup
tags:
- osx
- provision
- mac
- macports
---
# Mac OSX provisioning

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

## X11 .serverauth files

```sh
sudo -E vim /opt/X11/bin/startx
# Change path for .serverauth
```

## Fix screen terminfo

See [information](https://github.com/neovim/neovim/issues/2048#issuecomment-78045837)

```sh
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti
```

## Base Ports

```sh
sudo port -v selfupdate
sudo port install coreutils bash bash-completion rxvt-unicode \
  tmux tmux-pasteboard keychain wget tree colordiff pstree jq \
  bc ctags the_silver_searcher urlview terminus-font tcpdump \
  curl git xsel xdotool unrar pass gnetcat sshfs grc ttyrec \
  neomutt +gpgme+headercache+homespool+sidebar+smtp \
  vim +cscope+lua+perl+x11+python27+python34 \
  MacVim +cscope+lua+perl+python27+python34 \
  id3lib p5-image-exiftool libcaca libexif highlight unclutter \
  ranger ncmpcpp MPlayer mpv libmms faad2 mpc pango poppler \
  atool aria2 spark nodejs6 npm3 git-extras git-cal tarsnap \
  lnav peco colout cloc ncdu calc tidy pngcrush icat watch \
  exiv2 terminal-notifier aspell aspell-dict-en aspell-dict-he \
  figlet fortune p7zip pidof pinfo xmlstarlet \
  postgresql95 shellcheck

sudo port install \
  python27 py27-pip py27-virtualenv py27-flake8 py27-readline
  python34 py34-pip py34-virtualenv py34-flake8 py34-readline #py34-pygments

npm -g install mad bower grunt-cli jshint
npm -g install stylelint jsonlint jsxhint markdownlint-cli sass-lint

pip-2.7 install --user vim-vint
pip-3.4 install --user python-mpd2 pipdeptree proselint yamllint

defaults write org.macosforge.xquartz.X11 app_to_run /usr/bin/true
defaults write org.macosforge.xquartz.X11 no_quit_alert -boolean true

FIXME
---
py34-pygments
ERRORS: shellcheck telegram-cli
```

## Custom Ports

Install local Macports repository, i.e. [rafi/portfiles](https://github.com/rafi/portfiles)

```sh
sudo port install bspwm sxhkd z diff-so-fancy entr glyr diana \
  htop-vim icdiff lemonade m-cli progress py34-httpstat sxiv \
  docker-bash-completion docker-compose-bash-completion \
  fzf gopass QSyncthingTray telegram-cli tmux-mem-cpu-load
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

## Compile `neovim`

```sh
git clone git://github.com/neovim/neovim.git
cd neovim
make distclean
make CMAKE_BUILD_TYPE=Release DEPS_CMAKE_FLAGS=-DUSE_BUNDLED_BUSTED=OFF CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=/opt/local"
make install
```

## Python Utilities

```sh

# Set default version
sudo port select --set python python27
sudo port select --set python2 python27
sudo port select --set pip pip27
sudo port select --set virtualenv virtualenv27
sudo port select --set pycodestyle pycodestyle-py27
sudo port select --set pyflakes py27-pyflakes
sudo port select --set flake8 flake8-27

mkdir "$XDG_DATA_HOME/python/utils"
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

## Dependency Reference

```txt
- coreutils - gettext expat libiconv gperf ncurses gmp xz
- htop - autoconf automake libtool
- wget - gnutls curl-ca-bundle perl5 perl5.22 libidn libtasn1 nettle p11-kit
  desktop-file-utils glib2 libffi pcre bzip2 libedit zlib pkgconfig popt
  libxslt libxml2
- rxvt-unicode - Xft2 fontconfig freetype libpng xrender xorg-libX11
  xorg-bigreqsproto xorg-inputproto xorg-kbproto xorg-libXau xorg-xproto
  xorg-libXdmcp xorg-libxcb python27 db48 openssl python2_select python_select
  sqlite3 xorg-libpthread-stubs xorg-xcb-proto xorg-util-macros
  xorg-xcmiscproto xorg-xextproto xorg-xf86bigfontproto xorg-xtrans
  xorg-renderproto
- tmux - libevent
- jq - bison bison-runtime m4
- terminus-font - bdftopcf xorg-libXfont xorg-fontsproto xorg-libfontenc
  mkfontdir mkfontscale
- libcaca - freeglut cmake curl libarchive lzo2 libGLU mesa flex indent
  py27-libxml2 xorg-dri2proto xorg-glproto xorg-libXdamage xorg-damageproto
  xorg-libXfixes xorg-fixesproto xorg-libXext xorg-libXi xorg-libXmu xorg-libXt
  xorg-libsm xorg-libice xorg-libXrandr xorg-randrproto xorg-libXxf86vm
  xorg-xf86vidmodeproto imlib2 giflib jpeg libid3tag tiff
- git - p5.22-authen-sasl p5.22-digest-hmac p5.22-digest-sha1 p5.22-gssapi
  kerberos5 libcomerr p5.22-cgi p5.22-html-parser p5.22-html-tagset
  p5.22-test-deep p5.22-test-simple p5.22-test-nowarnings p5.22-test-warn
  p5.22-sub-uplevel p5.22-error p5.22-net-smtp-ssl p5.22-io-socket-ssl
  p5.22-io-socket-inet6 p5.22-io p5.22-socket6 p5.22-io-socket-ip
  p5.22-net-libidn p5.22-net-ssleay p5.22-test-exception p5.22-term-readkey
  rsync
- vim - lua readline
- MacVim - gnutar help2man p5.22-locale-gettext
- ncmpcpp - boost icu fftw-3 libmpdclient doxygen taglib
- MPlayer - lame libass fribidi yasm libmad libogg liboil libopus libtheora
  libvorbis openjpeg15 jbigkit lcms2
- xdotool - xorg-libXinerama xorg-xineramaproto xorg-libXtst xorg-recordproto
- pango - cairo libpixman xorg-xcb-util gobject-introspection py27-mako
  py27-beaker py27-setuptools py27-markupsafe harfbuzz graphite2
- atool - gsed
- pass - getopt gnupg2 gpg-agent libassuan libgpg-error pth libgcrypt libksba
  pinentry-mac libusb-compat libusb openldap cyrus-sasl2 db46 tcp_wrappers
  pwgen
- shellcheck - ghc ghc-bootstrap llvm-3.5 libcxx llvm_select hs-json hs-mtl
  hs-parsec hs-text hs-syb hs-quickcheck-devel hs-tf-random hs-primitive
  hs-random hs-regex-tdfa hs-regex-base
```
