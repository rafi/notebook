---
title: 'apt: Keeping software versions intact'
date: '2013-10-30'
description:
categories:
- setup
tags:
- ubuntu
- debian
- apt
- install
---

`apt` is the package manager that installs and removes software from your OS, Ubuntu, and Debian too. It's 100% compatible software, and it performs upgrades easily. Fedora/Centos/Redhat use yum, Arch uses pacman, Apple has the AppStore, and so on..

Side-effects? 
Automatic upgrades can cause version-specific dependency breakage.
As software developers, we use precise versions that offer an intricate interface we use to communicate at server and client-side.

Versions do matter, unfortunately, but they don't need to be a hassle.
Here's an excellent thread on how to freeze packages.

Run these following commands to "hold" important packages:

```
echo "php5 hold" | sudo dpkg --set-selections
echo "php5-cli hold" | sudo dpkg --set-selections
echo "php5-common hold" | sudo dpkg --set-selections
echo "php5-dev hold" | sudo dpkg --set-selections
echo "apache2 hold" | sudo dpkg --set-selections
echo "apache2-utils hold" | sudo dpkg --set-selections
echo "apache2.2-bin hold" | sudo dpkg --set-selections
echo "apache2.2-common hold" | sudo dpkg --set-selections
echo "mysql-common hold" | sudo dpkg --set-selections
echo "mysql-server hold" | sudo dpkg --set-selections
echo "mysql-server-5.5 hold" | sudo dpkg --set-selections
echo "mysql-server-core-5.5 hold" | sudo dpkg --set-selections
```

While you're at it, learn a few apt commands!
```
apt-cache search php5
apt-cache search apache | grep php
apt-cache show php5
apt-get install php5
apt-get remove php5  -- Don't run this 
```

apt uses dpkg as its backend. To see if you have, say, 'postgres' installed locally, run:
```
dpkg --get-selections | grep postgres
```

Did you know? Cydia on the iPhone is based on apt, ported to iOS.
