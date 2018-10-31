---
title: Mac OSX MPD and MPC
date: '2014-04-09'
description:
categories:
- setup
tags:
- osx
- provision
- mac
- macports
- mpd
- mpc
- musicpd
---

MPD and MPC
---
Instal via Macports or compile manually.

### Macports
```bash
sudo port install mpd mpc

# Load on startup
sudo port load mpd
```

### Compile `mpd`
Download `mpd` from http://www.musicpd.org/download.html

```bash
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

### Compile `mpc`
Download `mpc` from http://www.musicpd.org/clients/mpc/

```bash
./configure \
  --prefix=/opt/local \
  --mandir=/opt/local/share/man \
  --disable-debug \
  --disable-dependency-tracking
make install
```

Compile `mpdscribble`
---
```bash
git clone git://git.musicpd.org/master/mpdscribble.git
cd mpdscribble
./autogen.sh --prefix="/opt/local" --sysconfdir="/opt/local/etc"
make install
```

Compile `ympd`
---
```bash
git clone git://github.com/notandy/ympd.git
cd ympd
# Add this to CMakeLists.txt: INCLUDE_DIRECTORIES(/opt/local/include)
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/opt/local
make
make install
```

Compile `ncmpcpp`
---
```bash
port install boost
env LIBS=-L/opt/local/lib BOOST_LIB_SUFFIX="-mt" \
  CPPFLAGS=-I/opt/local/include LDFLAGS=-s \
  ./configure --prefix=/opt/local
```

