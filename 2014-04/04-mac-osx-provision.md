# Mac OSX provisioning

# Xcode
- Install Xcode and the Xcode Command Line Tools: https://www.macports.org/install.php
- Agree to Xcode license in Terminal: `sudo xcodebuild -license`

# Macports
- Install MacPorts for your version of OS X: https://www.macports.org/install.php

# Sensible hacker defaults
```
sudo scutil --set HostName rafi-mac
```
- Follow https://github.com/mathiasbynens/dotfiles/blob/master/.osx and use what ever you like
- Get rid of `.DS_Store` turds with http://asepsis.binaryage.com/
- Disable annoying animations:
```
defaults write com.apple.dock expose-animation-duration -float 0
```

# Ports
```
sudo port install coreutils bash bash-completion htop wget tree colordiff
sudo port install rxvt-unicode tmux tmux-pasteboard keychain the_silver_searcher
sudo port install id3lib urlview terminus-font p5-image-exiftool libcaca
sudo port install git +svn +doc +bash_completion +credential_osxkeychain
sudo port install vim +huge +cscope +perl +python27 +lua
sudo port install mpd mpc ncmpcpp unrar MPlayer highlight xsel herbstluftwm
sudo port install nodejs npm

defaults write org.macosforge.xquartz.X11 app_to_run ""
```

# Defaults
- The tools provided by GNU coreutils are prefixed with the character 'g'
  by default to distinguish them from the BSD commands. If you want to use
  the GNU tools by default, add this directory to the front of your PATH:
  `/opt/local/libexec/gnubin/`
- To use bash completion, add the following lines at the end of your .bash_profile:
  ```
    if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
        . /opt/local/etc/profile.d/bash_completion.sh
    fi
  ```
  The port bash-completion >=2.0 requires bash >=4.1; please make sure
  you are using /opt/local/bin/bash by changing the preferences of your
  terminal accordingly.
- To use the rsyncd server you must copy `/opt/local/etc/rsyncd.conf.example`
  to `rsyncd.conf` and add your modules there. See `man rsyncd.conf` for more
  information.

## Percona, Apache 2.2, and PHP 5.5
```
time sudo port install apr-util +percona percona +openssl percona-server intltool +perl5_16
time sudo port install p5.16-dbd-mysql +percona percona-toolkit +perl5_16
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

time sudo port install apr-util +percona php55 +apache2 php55-apache2handler php55-curl php55-exif php55-gd php55-geoip php55-gettext php55-http php55-iconv php55-mbstring php55-mcrypt php55-mysql +percona php55-openssl php55-pdflib php55-pear php55-posix php55-soap php55-sockets php55-solr php55-ssh2 php55-sqlite php55-xmlrpc php55-xsl php55-zip
time sudo port install php55-xdebug
time sudo port install cronolog
sudo port select php php55

You can get a list of the available configuration settings for xdebug with the following command:

    php55 --ri xdebug

# 1. Add to environment: export PATH=/opt/local/apache2/bin:$PATH
# 2. Use a configuration from /opt/local/etc/php55
# 3. Symlink conf: sudo ln -s ~/.config/php/php55.ini /opt/local/etc/php55/php.ini
# 4. php.ini update mysql.sock reflect /opt/local/var/run/percona/mysqld.sock
sudo /opt/local/apache2/bin/apxs -a -e -n php5 /opt/local/apache2/modules/mod_php55.so
sudo port load apache2
```
Credits:
- https://gist.github.com/jwcobb/4210358
- https://documentation.cpanel.net/display/CKB/How+to+Update+a+Percona+Installation

# Python 3.3
```
sudo port install python33 py33-flake8
port select --set python python33
port select --set pep8 pep833
port select --set pyflakes py33-pyflakes
port select --set flake8 flake833
```

# MPD
```
# Load on startup
sudo port load mpd

# Install mpdscribble manually
git clone git://git.musicpd.org/master/mpdscribble.git
./autogen.sh --prefix="/opt/local" --sysconfdir="/opt/local/etc"
sudo make install
```

# NPM utils
It is not recommended to install packages globally. But if you do so please
be aware that they won't get cleaned up when you deactivate or uninstall npm.
Globally installed packages will remain in `/opt/local/lib/node_modules/`
until you manually delete them.
```
sudo npm install -g mad bower grunt-cli
```

