---
title: rsync tips
date: '2015-01-11'
description:
categories:
- setup
tags:
- rsync
- guide
- linux
---

Dry-Run
---
Try your command before doing it for real with the dry-run option:
- `-n`, `--dry-run` - Perform a trial run with no changes made

For example:
```sh
rsync -navh ~ rafi-desk:/mnt/backup/
```

Archiving
---
Simply using the `-a` option applies the sensible `rlptgoD` defaults:
- `-a`, `--archive` - Archive mode; equals `-rlptgoD` (no `-H`,`-A`,`-X`)
  - `-r`, `--recursive` - Recurse into directories
  - `-l`, `--links` - Copy symlinks as symlinks
  - `-p`, `--perms` - Preserve permissions
  - `-t`, `--times` - Preserve modification times
  - `-g`, `--group` - Preserve group
  - `-o`, `--owner` - Preserve owner (super-user only)
  - `-D` - same as --devices --specials:
    - `--devices` - Preserve device files (super-user only)
    - `--specials` - Preserve special files

Examining Result
---
Use the `--log-file` option to examine transfer. rsync might be trying to update all
the group names on destination directories, this is because you're using the
option `a` or `g` to preserve group. You could use the `--chmod` option to
override that:
```sh
rsync --log-file=my.log --chown=rafi:staff -navh rafi-desk:/mnt/media/music/ Music/
```

Synchronizing
---
Use the `--delete` option to delete extraneous files from destination
directories. **Use with caution!**

Filename Encoding
---
If you're syncing from a Mac running OSX to a Linux machine, you'll need to use
`--iconv=LOCAL,REMOTE` to convert the encoding:
```sh
rsync --iconv=UTF8-MAC,UTF-8 --chown=rafi:staff -avh rafi-desk:/mnt/media/music/ Music/
```

## File Matching
```
 -c, --checksum              skip based on checksum, not mod-time & size
 -u, --update                skip files that are newer on the receiver
     --existing              skip creating new files on receiver
     --ignore-existing       skip updating files that already exist on receiver
 -I, --ignore-times          don't skip files that match in size and mod-time
     --size-only             skip files that match in size
     --exclude=PATTERN       exclude files matching PATTERN
     --exclude-from=FILE     read exclude patterns from FILE
```

## Output
The `--verbose` option will apply certain `info` flags. You could also
use `--info` with your choice of output. Run `rsync --info=help` to get
a list of possible flags.
```
 -v, --verbose               increase verbosity
     --info=FLAGS            fine-grained informational verbosity
 -h, --human-readable        output numbers in a human-readable format
     --progress              show progress during transfer
 -i, --itemize-changes       output a change-summary for all updates
     --out-format=FORMAT     output updates using the specified FORMAT
     --log-file=FILE         log what we're doing to the specified FILE
     --log-file-format=FMT   log updates using the specified FMT
     --list-only             list the files instead of copying them
```
