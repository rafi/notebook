---
title: Aria2 - ultra fast download client & server
date: 2018-01-25
featured: true
---
# Aria2

Ultra fast download client & server utility that utilizes your maximum download
bandwidth. Aria2 supports HTTP(S), S(FTP), BitTorrent and Metalink.

* Official website: https://aria2.github.io/
* Source: https://github.com/aria2/aria2

## Installation

| OS        |                       |
|-----------|-----------------------|
| Archlinux | `pacman -S aria2`     |
| macOS     | `port install aria2`  |
| Ubuntu    | `apt install aria2`   |

## Usage

### Client

Download torrent via magnet link with 3 maximum connections per server:
```bash
aria2c -x3 http://oracle.com/downloads/jdk
```

Download torrent via magnet link:
```bash
aria2c magnet:?xt=urn:btih:1234...
```

### Server

```bash
aria2c --conf-path=$HOME/.config/aria2/daemon
```

Example configuration:

```
daemon=true
continue=true
check-integrity=true
dir=/mnt/media/tmp/dl
input-file=${HOME}/.cache/aria2/session.dat
save-session=${HOME}/.cache/aria2/session.dat

log=${HOME}/.cache/aria2/aria2.log
log-level=warn
enable-rpc=true
file-allocation=falloc
rpc-listen-all=true
rpc-allow-origin-all=true
rpc-save-upload-metadata=false
rpc-secret=verysecret

enable-dht=true
dht-listen-port=49164-49170
dht-file-path=${HOME}/.cache/aria2/dht.dat
dht-file-path6=${HOME}/.cache/aria2/dht6.dat

max-concurrent-downloads=5
max-overall-upload-limit=3K
max-connection-per-server=4

# BitTorrent
listen-port=49164-49170
bt-enable-lpd=true
bt-max-peers=50
bt-max-open-files=100
bt-request-peer-speed-limit=100K
enable-peer-exchange=true
enable-dht=true
enable-dht6=false
follow-torrent=mem
follow-metalink=mem
bt-detach-seed-only=true
```

### Web Clients

* Web interface for aria2, https://github.com/ziahamza/webui-aria2
* Modern web frontend for aria2, https://github.com/mayswind/AriaNg

### Tips

Cool bash function:

```bash
# Show active aria2 downloads with diana
da() {
  watch -ctn 3 "(echo '\033[32mGID\t\t Name\t\t\t\t\t\t\t%   Down   Size Speed    Up   S/L Time\033[36m'; \
    diana list| cut -c -112; echo '\033[37m'; diana stats)"
}
```
