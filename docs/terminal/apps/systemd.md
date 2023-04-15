---
title: systemd
date: '2014-10-28'
tags:
- systemd
- guide
- linux
---

Running `systemctl`, optionally specify `--system` or `--user`.

## Services
## Sockets
## Control
## List
See everything systemd controls: `systemctl` or `systemctl --user`. Add `--all`
to see everything, running or not.

List all available services:
```bash
# System-wide:
sudo systemctl list-units -t service --all

# User:
systemctl --user list-units -t service --all
```

Listing running processes with `ps` and cgroups:
```bash
ps xawf -eo pid,user,cgroup,args
```

## Analyze
Like `systemctl`, optionally specify `--system` or `--user`.

- Boot process duration: `systemd-analyze`
- Critical chain time tree: `systemd-analyze --critical-chain`
- Diagnose processes: `systemd-analyze blame`

# journald

- View logs: `journalctl`
- Boot logs: `journalctl -b`
- Follow logs in real-time: `journalctl -f`

# Appendix: `hostnamectl`
Nifty "who's this computer?".
```
$ hostnamectl

   Static hostname: rafi-desk
         Icon name: computer-desktop
           Chassis: desktop
        Machine ID: 3329fhkrj2dj923jr38dj3983jd83rj3
           Boot ID: 4f2jf8sbx834xgjs298fjs9rh1f8s328
  Operating System: Arch Linux
            Kernel: Linux 3.17.1-1-ARCH
      Architecture: x86-64
```
