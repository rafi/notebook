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
Follow https://github.com/mathiasbynens/dotfiles/blob/master/.osx and use what ever you like
Get rid of .DS_Store turds http://asepsis.binaryage.com/

# Ports
```
sudo port install coreutils bash bash-completion
sudo port install rxvt-unicode tmux tmux-pasteboard
sudo port install colordiff highlight htop rainbarf urlview terminus-font p5-image-exiftool unrar libcaca wget unclutter
sudo port install mpd mpc ncmpcpp
sudo port install git-core +svn +doc +bash_completion +credential_osxkeychain
sudo port install nodejs npm
sudo port install vim +huge +cscope +perl +python

defaults write org.macosforge.xquartz.X11 app_to_run "/opt/local/bin/urxvt -e /opt/local/bin/tmux"
```

# MPD
```
# Load on startup
sudo port load mpd
```

# NPM utils
```
sudo npm install -g mad
```

