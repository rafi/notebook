---
title: ArchLinux Install
date: 2013-09-27
tags:
- archlinux
- linux
- pacman
---

# ArchLinux Installation

## Preparation

- Download latest image and very GPG key from
  [archlinux.org/download](https://www.archlinux.org/download)
- Burn latest install image on USB/SD card with `dd`

```bash
dd bs=4M if=archlinux-2019.09.01-x86_64.iso of=/dev/disk2 status=progress oflag=sync
```

## Boot

Boot from USB/SD card and establish internet connection.

## Filesystem

Partition table:

| Device    | Size | Type
|-----------|------|------------
| /dev/sda1 | 512M | EFI System
| /dev/sda2 |  30G | Linux root (x86-64)
| /dev/sda2 |   4G | Linux swap
| /dev/sda2 | 897G | Linux home

```bash
fdisk /dev/sda

# Partition devices:
# g:  create new empty GPT partition table
# n, 1, default, +512M    (sda1 /boot)
# n, 2, default, +30G     (sda2 /)
# n, 2, default, +4G      (sda3 swap)
# n, 2, default, default  (sda4 /home)

# t, 1, 1
# t, 2, 24
# t, 3, 19
# t, 4, 28

# Format
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda4
mkswap /dev/sda3
swapon /dev/sda3

# Mount
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir /mnt/home
mount /dev/sda4 /mnt/home
```

## Installation

```bash
pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
# Verify for any errors!
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Jerusalem /etc/localtime
hwclock --systohc

# Locale
vi /etc/locale.gen
# Uncomment en_US.UTF-8 UTF-8 and other needed locales
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# Hostname
echo rafi-desk > /etc/hostname

# Network
vi /etc/hosts
# Add proper localhost entries
systemctl enable dhcpcd.service
passwd

# GRUB boot-loader
pacman -S intel-ucode grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Reboot
exit
umount -R /mnt
reboot
```

(Be sure to remove the installation media)

## Post-installation

```bash
# Update system
pacman -Syyu
pacman -S --needed base-devel

# Create local user
useradd -m -g users -G wheel,storage,power -s /bin/bash rafi
chfn rafi
passwd rafi
pacman -S sudo
visudo
# rafi ALL=(ALL) ALL

# Setup audio
pacman -Sy alsa-utils
aplay -l
alsamixer  # Unmute with 'm' and raise volume with 'Up'
speaker-test -c 2

# Install X-Server and SSH
pacman -S xorg-server xorg-xinit xorg-xinput xorg-xset ttf-dejavu xterm
pacman -S openssh sshfs rsync
systemctl enable sshd
exit

# login as user
# copy configuration
git clone git@github.com:rafi/.config.git
startx
```

## Software

```bash
# Window manager and terminal
pacman -S alacritty i3-gaps i3lock i3status perl-json-xs perl-anyevent-i3

# Essentials
pacman -S curl wget git keychain vim xcape htop xclip z unrar bc
pacman -S gnupg pass bash-completion grc colordiff tree ack tmux tmuxp
pacman -S the_silver_searcher rofi diff-so-fancy bat chafa fd entr
pacman -S fzf fzy jq tcpdump nmap gnu-netcat id3lib p7zip tarsnap
pacman -S exiv2 ncdu calc pngcrush pinfo atool poppler aria2
pacman -S xmlstarlet ripgrep httpie rclone
pacman -S syncthing mpc mpd mpv neomutt task vit tig glyr ncmpcpp

# Languages
pacman -S go
pacman -S python python2 python-pip python2-pip
pacman -S nodejs npm yarn

# Programming
pacman -S cloc shellcheck proselint yamllint vint

# Platforms
pacman -S kubectl kubectx minikube docker docker-compose

# Various Shells
pacman -S zsh fish

# Aur packages
yay -S google-chrome termsyn-font neovim-git urlview lf-git
yay -S tmux-mem-cpu-load-git tmux-xpanes tidy-html5-git
yay -S ttyrec ttyd icdiff git-cal-git git-extras
yay -S unversal-ctags-git yaml2json
```

- git-extras-git (aur)
- vim-spell-en
- ntfs-3g
- mediainfo
- xsel # or xclip?
- dstat
- sysstat
- hdparm
- iotop
- weechat
  - bitlbee (custom PKGBUILD with patch for hipchat)
  - libotr3
  - python2-notify (for notify.py plugin)
  - pyfribidi (aur)
- hwdetect
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
- fb-client
- mad (aur)
- surfraw
- etckeeper (aur)
- glances
- jsctags-tern-git (aur)
- pkgbuild-introspection
- par (aur)
- archey3-git (aur)
- flake8
- gdrive-cli-git (aur)
- sassc (aur)
- dnsutils
- python2-pygments
- python-ansi2html
- perl-text-markdown
- nmh-git (aur)
- mercurial
- asciiquarium (aur)
- diana-git (aur)

### Graphical

- vdpau/vaapi:
  - ati-dri
  - vdpauinfo
  - xvba-video
  - libvdpau-va-gl
  - libva-vdpau-driver
- rxvt-unicode-patched (aur)
- qt4 (amdcccle depends on it)
- gksu (pulls loads of depends. incl. gtk2/3)
- gksu amdcccle
  - setup monitors
- xcb-util-cursor-git (aur)
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
- keepassx-git (aur)
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
- python-i3-git (aur)
- zeal-git (aur)
- compton-git (aur)
- tidy-html5-git (aur)
- libotr
- python-pafy-git (aur)
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

### Fonts, Icons, Cursors, Themes

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

### Media

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

### bitlbee

Configuration

```txt
/secure passphrase <pass>
/secure set bitlbeepass <pass>
/secure set tikalpass <pass>

/set irc.server_default.nicks rafi
/server add bitlbee localhost -autoconnect
/connect -all

acc add jabber rafaelb@pitput.tikal.io ${sec.data.tikalpass}
chat add 0 nsfw@conference.pitput.tikal.io
chan 1 set auto_join true
/join #nsfw

account add slack rbodill@mycwt.com
account slack set api_token xoxp-132804510225-266629488839-1025351239287-d517ba5c0781496613b6c380d141b9ef
account slack on

account add hangouts justrafi@gmail.com
```

```txt
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

```txt
# see your sound devices: aplay -l
nano /etc/modprobe.d/alsa-base.conf
# options snd slots=snd_hda_intel
# options snd_hda_intel index=0
# options snd_usb_audio index=-2

# Catalyst
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

- Check datetime, sync if needed:
  - pacman -S ntp
    - ntpd -qg
    - hwclock -w
```
