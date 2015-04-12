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
sudo port -v selfupdate
sudo port install coreutils bash bash-completion htop wget tree colordiff ctags
sudo port install rxvt-unicode tmux tmux-pasteboard keychain the_silver_searcher
sudo port install id3lib urlview terminus-font p5-image-exiftool libcaca libexif
sudo port install git +svn +doc +bash_completion +credential_osxkeychain
sudo port install vim +huge +breakindent +cscope +perl +lua +python34
sudo port install ncmpcpp unrar MPlayer highlight xsel surfraw herbstluftwm
sudo port install poppler atool aria2 libmms faad2 pass nodejs npm

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

To start the `gpg-agent` on startup, run:
```sh
launchctl load -w /Library/LaunchAgents/org.macports.gpg-agent.plist
```

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
  --enable-lame-encoder \
  --enable-vorbis-encoder
make CFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib"
make install
```

### Compile mpc
Download `mpc` from http://www.musicpd.org/clients/mpc/
```sh
./configure \
  --prefix=/opt/local \
  --mandir=/opt/local/share/man \
  --disable-debug \
  --disable-dependency-tracking
make install
```

Compile mpdscribble
---
```sh
git clone git://git.musicpd.org/master/mpdscribble.git
cd mpdscribble
./autogen.sh --prefix="/opt/local" --sysconfdir="/opt/local/etc"
make install
```

Compile ympd
---
```sh
git clone git://github.com/notandy/ympd.git
cd ympd
# Add this to CMakeLists.txt: INCLUDE_DIRECTORIES(/opt/local/include)
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/opt/local
make
make install
```

Compile glyr
---
```sh
git clone git://github.com/sahib/glyr.git
cd glyr
cmake . -DCMAKE_EXE_LINKER_FLAGS="-L/opt/local/lib" -DCMAKE_SHARED_LINKER_FLAGS="-L/opt/local/lib"
make
make install
```

Compile `sxiv`
---
Compile from source:
```sh
git clone git://github.com/muennich/sxiv.git
cd sxiv
make CFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib"
make PREFIX="/opt/local" install
```

Compile `cam`
---
```
git clone git://github.com/itchyny/cam
cd ./cam
autoreconf -i
CFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib" ./configure --prefix=/opt/local --mandir=/opt/local/share/man
make CFLAGS="-I/opt/local/include" LDFLAGS="-L/opt/local/lib"
make install
```

sshfs
---
```sh
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

# Unmount:
# umount LOCAL_MOUNT_POINT
```

Development Environments
---

### Apache 2.2, PHP 5.6, and MySQL 5.5 or Percona
First disable built-in Apache: _System Preferences_ **->** _Sharing_
and uncheck the "Personal Web sharing". Or, from terminal:
```
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
```
PHP and Apache:
```
sudo port install php56 +apache2 php56-apache2handler php56-curl php56-exif php56-gd php56-geoip php56-gettext php56-http php56-iconv php56-mbstring php56-mcrypt  php56-openssl php56-pdflib php56-pear php56-posix php56-soap php56-sockets php56-solr php56-ssh2 php56-sqlite php56-xmlrpc php56-xsl php56-zip
sudo port install php56-xdebug
sudo port install cronolog
sudo port select php php56

# You can get a list of the available configuration settings for xdebug with the following command:
#
#   php56 --ri xdebug

# 1. Add to environment: export PATH=/opt/local/apache2/bin:$PATH
# 2. Use a configuration from /opt/local/etc/php56
# 3. Symlink conf: sudo ln -s ~/.config/php/php56.ini /opt/local/etc/php56/php.ini
sudo /opt/local/apache2/bin/apxs -a -e -n php5 /opt/local/apache2/modules/mod_php56.so
sudo port load apache2
```
Install PostgreSQL 9.3:
```
sudo port install postgresql93-server
sudo mkdir -p /opt/local/var/db/postgresql93/defaultdb
sudo chown postgres:postgres /opt/local/var/db/postgresql93/defaultdb
sudo su postgres -c '/opt/local/lib/postgresql93/bin/initdb -D /opt/local/var/db/postgresql93/defaultdb'
```
Install MySQL 5.5:
```
sudo port install mysql55-server
sudo port select mysql mysql55
sudo port install php56-mysql

# Add to PATH: export PATH=/opt/local/lib/mysql55/bin:$PATH

sudo -u _mysql mysql_install_db
sudo chown -R _mysql:_mysql /opt/local/var/db/mysql55/
sudo chown -R _mysql:_mysql /opt/local/var/run/mysql55/
sudo chown -R _mysql:_mysql /opt/local/var/log/mysql55/
sudo port load mysql55-server
/opt/local/lib/mysql55/bin/mysqladmin -u root -p password
/opt/local/bin/mysql_secure_installation

# To upgrade older existing database:
man mysql_upgrade  # details on the upgrade program (man page)
sudo port unload mysql55-server
sudo /opt/local/lib/mysql55/bin/mysql_upgrade -u root -p
sudo port load mysql55-server
```
Or, Percona:
```
sudo port install apr-util +percona percona +openssl percona-server intltool +perl5_16
sudo port install p5.16-dbd-mysql +percona percona-toolkit +perl5_16
sudo port select mysql percona
sudo port install php56-mysql +percona

# 1. Add to environment: export PATH=/opt/local/lib/percona/bin:$PATH
# 2. Generate my.cnf at https://tools.percona.com/wizard
# 3. Symlink conf: sudo ln -s ~/.config/percona/my.cnf /opt/local/etc/percona/my.cnf
# 4. php.ini update mysql.sock reflect /opt/local/var/run/percona/mysqld.sock
sudo -u _mysql /opt/local/lib/percona/bin/mysql_install_db
sudo port load percona-server
sudo /opt/local/lib/percona/bin/mysql_secure_installation

# Fix for php56-mysql
# Just for Mavericks (10.9)?
cd /opt/local/lib/percona/mysql
sudo ln -s libperconaserverclient.a libmysqlclient.a
sudo ln -s libperconaserverclient.dylib libmysqlclient.dylib
```
Reference: https://gist.github.com/jwcobb/4210358

### Python 2.7
```
sudo port install python27 py27-pip py27-flake8
sudo port install py27-virtualenv py27-virtualenvwrapper

sudo port select --set python python27
sudo port select --set pip pip27
sudo port select --set pep8 pep827
sudo port select --set pyflakes py27-pyflakes
sudo port select --set flake8 flake827
sudo port select --set virtualenv virtualenv27

# Macports doesn't create a python2 link
sudo ln -s /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/python2.7 /opt/local/bin/python2
```

### Python 3.4
```
sudo port install python34 py34-pip py34-flake8

# Macports doesn't create a python3 link
sudo ln -s /opt/local/Library/Frameworks/Python.framework/Versions/3.4/bin/python3.4 /opt/local/bin/python3
```

### Python utils
```
pip-2.7 install ss subliminal
sudo ln -s /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/subliminal /opt/local/bin/subliminal
sudo ln -s /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/ss /opt/local/bin/ss

pip-3.4 install Pygments python-mpd2
sudo ln -s /opt/local/Library/Frameworks/Python.framework/Versions/3.4/bin/pygmentize /opt/local/bin/pygmentize
```

### NPM utils
It is not recommended to install packages globally. But if you do so please
be aware that they won't get cleaned up when you deactivate or uninstall npm.
Globally installed packages will remain in `/opt/local/lib/node_modules/`
until you manually delete them.
```
npm install -g mad bower grunt-cli
```
