# Preparation
- Burn latest install iso on usb with `dd`

# Installation
- Establish internet connection
- Prepare the storage drive (MBR)
  - fdisk /dev/sda
  - o
  - n, p, 1, default first, +72G
  - n, p, 2, default first, default last
  - t, 2, 82
  - a, 1
  - p
  - w
- Create filesystems
  - mkfs.ext4 /dev/sda1
  - mkswap /dev/sda2
  - swapon /dev/sda2
- Mount the partitions
  - lsblk /dev/sda
  - mount /dev/sda1 /mnt
- Install the base system
  - pacstrap /mnt base
- Generate an fstab
  - genfstab -U -p /mnt >> /mnt/etc/fstab
  - nano /mnt/etc/fstab
- Chroot and configure the base system
  - arch-chroot /mnt
  - Locale
    - nano /etc/locale.gen
      - en_US.UTF-8 UTF-8
      - he_IL.UTF-8 UTF-8
    - locale-gen
    - echo LANG=en_US.UTF-8 > /etc/locale.conf
    - export LANG=en_US.UTF-8
  - Console font and keymap
    - setfont Lat2-Terminus16
    - echo "FONT=Lat2-Terminus16" > /etc/vconsole.conf
  - Time zone
    - ln -s /usr/share/zoneinfo/Asia/Jerusalem /etc/localtime
  - Hardware clock
    - hwclock --systohc --utc
  - Hostname
    - echo rafi-desk > /etc/hostname
  - Configure the network
    - systemctl enable dhcpcd.service
  - Set the root password
    - passwd
  - Install and configure a bootloader (Syslinux)
    - pacman -S syslinux
    - syslinux-install_update -i -a -m
    - Configure syslinux.cfg to point to the right root partition
      - nano /boot/syslinux/syslinux.cfg
  - exit
  - umount -R /mnt
  - reboot
  - Be sure to remove the installation media

# Post-installation
- pacman -Syu
- useradd -m -g users -s /bin/bash rafi
- chfn rafi
- passwd rafi
- pacman -S sudo
- nano /etc/sudoers
  - rafi ALL=(ALL) ALL
- pacman -S alsa-utils
- see your sound devices: aplay -l
- nano /etc/modprobe.d/alsa-base.conf
  - options snd slots=snd_hda_intel
  - options snd_hda_intel index=0
  - options snd_usb_audio index=-2
- alsamixer (unmute with 'm')
- speaker-test -c 2
- Catalyst
  - /etc/pacman.conf
    - [catalyst]
    - Server = http://catalyst.wirephire.com/repo/catalyst/$arch
  - pacman-key --keyserver pgp.mit.edu --recv-keys 0xabed422d653c3094
  - pacman-key --lsign-key 0xabed422d653c3094
  - linux-headers (for generator)
  - base-devel (for generator)
  - catalyst-libgl catalyst-utils catalyst-generator
  - nano /boot/syslinux/syslinux.cfg
    - Add 'nomodeset' in the APPEND line, eg:
    - APPEND root=/dev/sda1 rw nomodeset
  - aticonfig --initial=dual-head --screen-layout=left
  - nano /etc/modprobe.d/modprobe.conf
    - blacklist radeon
  - reboot
- pacman -S xorg-server xorg-server-utils xorg-xinit xorg-xrdb xorg-xev xorg-xclock xorg-xprop xorg-xwininfo xterm
- exit
- login as user
- startx
- Check datetime, sync if needed:
  - pacman -S ntp
    - ntpd -qg
    - hwclock -w

# Software
## Console
- wget
- ack
- the_silver_searcher
- rsync
- curl
- vim-spell-en gvim
- expac for pacaur and cower (all from aur)
- ntfs-3g
- python2
- ranger (pulls python 3)
  - libcaca
  - highlight
  - atool
  - mediainfo
  - poppler
- git
- git-extras-git (aur)
- openssh
- keychain
- xsel
- bc
- htop
- dstat
- sysstat
- tcpdump
- hdparm
- iotop
- colordiff
- bash-completion
- tmux-git (aur)
- pacman -S --needed base-devel
- weechat
  - bitlbee (custom PKGBUILD with patch for hipchat)
  - libotr3
  - python2-notify (for notify.py plugin)
  - pyfribidi (aur)
- hwdetect
- tree
- multitail
- jre (aur)
- virtualbox virtualbox-guest-iso
  - gpasswd -a rafi vboxusers
  - echo "vboxdrv" > /etc/modules-load.d/virtualbox.conf
  - modprobe vboxdrv
- nfs-utils
  - net-tools
  - systemctl start rpc-idmapd rpc-mountd
  - modprobe -a vboxnetadp vboxnetflt
- rainbarf-git (aur)
- urlview (for tmux)
- unrar
- zip
- fb-client
- mad (aur)
- surfraw
- tarsnap
- packer-io (aur)
- etckeeper (aur)
- z-git (aur)
- glances
- go
- gnu-netcat
- ctags-php-git (aur)
- jsctags-tern-git (aur)
- sshfs
- pkgbuild-introspection
- httpie
- grc
- par (aur)
- archey3-git (aur)
- ttyrec, ttygif, termrec (aur)
- flake8
- p7zip
- gdrive-cli-git (aur)
- sassc (aur)
- dnsutils
- python2-pygments
- python-ansi2html
- perl-text-markdown
- task
- nmh-git (aur)
- neovim-git (aur)
- calc
- mercurial
- asciiquarium (aur)
- aria2
- diana-git (aur)

## Graphical
- vdpau/vaapi:
  - ati-dri
  - vdpauinfo
  - xvba-video
  - libvdpau-va-gl
  - libva-vdpau-driver
- rxvt-unicode-patched (aur)
- xcape-git (aur)
- qt4 (amdcccle depends on it)
- gksu (pulls loads of depends. incl. gtk2/3)
- gksu amdcccle
  - setup monitors
- xcb-util-cursor-git (aur)
- i3-git (aur)
  - i3lock-git (aur)
  - i3status-git (aur)
  - perl-json-xs
  - perl-anyevent-i3 (aur)
- dunst-git (aur)
- dmenu2 (aur)
- tk (for gitk)
- unclutter
- mimi-git (aur)
- google-chrome (aur)
  - gpasswd -a rafi video
- firefox (pulls libnotify)
- icu
- meld
- pygtksourceview2
- keepassx2-git (aur)
- libgphoto2 (for usb camera)
  - gphoto2
- gitg
- ghex
- xdotool
- redshift
- teiler-git (aur)
  - maim (aur)
  - slop (aur)
- spacefm
- libmtp (for android)
- simple-mtpfs (for android)
- syncthing
- python-i3-git (aur)
- zeal-git (aur)
- compton-git (aur)
- tidy-html5-git (aur)
- libotr
- python-pafy-git (aur)
- rofi-git (aur)
- antiword
- termite-git (aur)
- sshpass
- graphviz
- wmctrl
- keymon (aur)
- fontforge
- gpaste-daemon (aur)
- byzanz-git (aur)
- qrencode

## Fonts, Icons, Cursors, Themes
- gnome-icon-theme
- gnome-themes-standard
- ttf-pragmatapro (personal PKGBUILD)
- terminus-font
- ttf-bitstream-vera ttf-dejavu ttf-inconsolata ttf-liberation ttf-ubuntu-font-family
- envypn-font (aur)
- erusfont (aur)
- gohufont (aur)
- artwiz-fonts
- ohsnap (aur)
- xcursor-neutral
- xcursor-premium
- xcursor-simpleandsoft
- gtk2-theme-dust (aur)
- gtk2-theme-dyne (aur)
- faience-icon-theme

## Media
- pulseaudio-alsa
- pavucontrol
- mpd
- mpc
- ncmpcpp (aur)
  - fftw
- mplayer
- beets
  - python2-pyacoustid
  - python2-pylast
  - mp3gain
  - python2-pyechonest (aur)
  - python2-requests (for beets-lastimport)
- python2-mpd (for clerk)
- python-mpd2 (aur)
- clerk-git
- mppc-git
- perl-image-exiftool
- sxiv-git (aur)
  - exiv2
  - imagemagick
- zathura
  - zathura-pdf-poppler
- gloobus-preview
- mpv-git (aur)
- gimp
- ncmpc-git (aur)
- id3ted (aur)
- gifsicle
- rtorrent
- pngcrush (aur)
- ponymix
- id3v2
- mps-youtube-git (aur)

## LAMP
- sudo pacman -S mariadb apache
- sudo usermod -aG http rafi
- sudo pacman -S php php-apache php-gd php-geoip php-mcrypt php-pgsql php-pear php-tidy php-intl xdebug
- sudo mkdir /srv/http/test
- sudo chown rafi:http /srv/http/test
- sudo pacman -S postgresql
  - sudo su
  - systemd-tmpfiles --create postgresql.conf
  - mkdir /var/lib/postgres/data
  - chown -c -R postgres:postgres /var/lib/postgres
  - sudo su - postgres -c "initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'"
  - systemctl start postgresql
  - createuser -s -U postgres --interactive
    - name it same as your user
  - createdb somedbname
  - Restore dbs if needed:
  - `pg_restore -i -h localhost -p 5432 -U postgres -d old_db -v "/usr/local/backup/10.70.0.61.backup"`
- sudo pacman -Sdd apache-ant (Completely ignoring deps because of jre/open-jre conflict)

## Nginx, memcached, message-queue
- nginx
  - php-fpm
- memcached
- php-memcache
- beanstalkd (aur)

## Node.js
- nodejs
- sudo npm install -g bower grunt-cli requirejs

## Ruby
- ruby
- gem install sass compass gu--no-ri --no-rdoc

## bitlbee
```
acc add jabber justRafi@gmail.com
acc gtalk set oauth on
acc gtalk on
# Perform oauth dance with 'jabber_oauth'
account gtalk set nick_format %full_name
# help nick_format
# help nick_format2
# help set nick_format

account add hipchat your@email.com <password>
account hipchat on

set strip_html always
save
```
