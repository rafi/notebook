Mac OSX provisioning
===

Xcode
---
- Install Xcode and the Xcode Command Line Tools: https://www.macports.org/install.php
- Agree to Xcode license in Terminal: `sudo xcodebuild -license`

Macports
---
- Install MacPorts for your version of OS X: https://www.macports.org/install.php

Sensible hacker defaults
---
```
sudo scutil --set HostName rafi-mac
```
- Follow https://github.com/mathiasbynens/dotfiles/blob/master/.osx and use what ever you like
- Get rid of `.DS_Store` turds with http://asepsis.binaryage.com/
- Disable annoying animations:
```
defaults write com.apple.dock expose-animation-duration -float 0
```

Base Ports
---
```
sudo port install coreutils bash bash-completion htop wget tree colordiff ctags
sudo port install rxvt-unicode tmux tmux-pasteboard keychain the_silver_searcher
sudo port install id3lib urlview terminus-font p5-image-exiftool libcaca
sudo port install git +svn +doc +bash_completion +credential_osxkeychain
sudo port install vim +huge +cscope +perl +python27 +lua
sudo port install ncmpcpp unrar MPlayer highlight xsel herbstluftwm
sudo port install nodejs npm

defaults write org.macosforge.xquartz.X11 app_to_run ""
```

Defaults
---
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

To use the rsyncd server you must copy `/opt/local/etc/rsyncd.conf.example`
to `rsyncd.conf` and add your modules there. See `man rsyncd.conf` for more
information.

MPD
---
Instal via Macports or compile manually.

### Macports
```
sudo port install mpd mpc

# Load on startup
sudo port load mpd
```

### Compile mpd
Download `mpd` from http://www.musicpd.org/download.html
```
sudo port install boost icu sqlite3 yajl libmpdclient libsamplerate
./configure \
  --prefix=/opt/local \
  --mandir=/opt/local/share/man \
  --disable-debug \
  --disable-dependency-tracking \
  --disable-ffmpeg \
  --disable-jack \
  --disable-mpc \
  --disable-mpg123 \
  --disable-libwrap \
  --enable-ao \
  --enable-bzip2 \
  --enable-mad \
  --enable-vorbis-encoder
make CFLAGS="-I/opt/local/include"
make install
```

### Compile mpc
Download `mpc` from http://www.musicpd.org/clients/mpc/
```
./configure \
  --prefix=/opt/local \
  --mandir=/opt/local/share/man \
  --disable-debug \
  --disable-dependency-tracking
make install
```

### Compile mpdscribble
```
git clone git://git.musicpd.org/master/mpdscribble.git
./autogen.sh --prefix="/opt/local" --sysconfdir="/opt/local/etc"
make install
```

sshfs
---
```
sudo port install sshfs
```
When upgrading `sshfs`, unmount all FUSE filesystems and then unload the kernel extension.
Unloading can be done via: `sudo kextunload -b com.github.osxfuse.filesystems.osxfusefs`
Alternatively (or if this fails), just reboot your computer.

Usage:
```
# Mount:
# sshfs USERNAME@HOSTNAME_OR_IP:/PATH LOCAL_MOUNT_POINT SSH_OPTIONS
sshfs rafi@rafi-desk:/mnt/media /mnt/media -C -p 9876
```

Development Environments
---

### Percona, Apache 2.2, and PHP 5.5
First disable built-in Apache: _System Preferences_ **->** _Sharing_
and uncheck the "Personal Web sharing". Or, from terminal:
```
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
```
Now install the whole stack:
```
sudo port install apr-util +percona percona +openssl percona-server intltool +perl5_16
sudo port install p5.16-dbd-mysql +percona percona-toolkit +perl5_16
sudo port select mysql percona

# 1. Add to environment: export PATH=/opt/local/lib/percona/bin:$PATH
# 2. Generate my.cnf at https://tools.percona.com/wizard
# 3. Symlink conf: sudo ln -s ~/.config/percona/my.cnf /opt/local/etc/percona/my.cnf
sudo -u _mysql /opt/local/lib/percona/bin/mysql_install_db
sudo port load percona-server
sudo /opt/local/lib/percona/bin/mysql_secure_installation

# Fix for php55-mysql
# Just for Mavericks (10.9)?
cd /opt/local/lib/percona/mysql
sudo ln -s libperconaserverclient.a libmysqlclient.a
sudo ln -s libperconaserverclient.dylib libmysqlclient.dylib

sudo port install apr-util +percona php55 +apache2 php55-apache2handler php55-curl php55-exif php55-gd php55-geoip php55-gettext php55-http php55-iconv php55-mbstring php55-mcrypt php55-mysql +percona php55-openssl php55-pdflib php55-pear php55-posix php55-soap php55-sockets php55-solr php55-ssh2 php55-sqlite php55-xmlrpc php55-xsl php55-zip
sudo port install php55-xdebug
sudo port install cronolog
sudo port select php php55

# You can get a list of the available configuration settings for xdebug with the following command:
#
#   php55 --ri xdebug

# 1. Add to environment: export PATH=/opt/local/apache2/bin:$PATH
# 2. Use a configuration from /opt/local/etc/php55
# 3. Symlink conf: sudo ln -s ~/.config/php/php55.ini /opt/local/etc/php55/php.ini
# 4. php.ini update mysql.sock reflect /opt/local/var/run/percona/mysqld.sock
sudo /opt/local/apache2/bin/apxs -a -e -n php5 /opt/local/apache2/modules/mod_php55.so
sudo port load apache2
```
Credits: https://gist.github.com/jwcobb/4210358

### Python 2.7
```
sudo port install python27 py27-pip py27-flake8
sudo port install py27-virtualenv py27-virtualenvwrapper

# Macports doesn't create a python2 link
sudo ln -s /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/python2.7 /opt/local/bin/python2
```

### Python 3.4
```
sudo port install python34 py34-pip py34-flake8

sudo port select --set python python34
sudo port select --set pip pip34
sudo port select --set pep8 pep834
sudo port select --set pyflakes py34-pyflakes
sudo port select --set flake8 flake834

# Macports doesn't create a python3 link
sudo ln -s /opt/local/Library/Frameworks/Python.framework/Versions/3.4/bin/python3.4 /opt/local/bin/python3
```

### NPM utils
It is not recommended to install packages globally. But if you do so please
be aware that they won't get cleaned up when you deactivate or uninstall npm.
Globally installed packages will remain in `/opt/local/lib/node_modules/`
until you manually delete them.
```
sudo npm install -g mad bower grunt-cli
```

