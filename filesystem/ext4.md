---
title: Provision partition with Ext4
path: filesystem/ext4
date: '2013-12-02'
description:
categories:
- setup
tags:
- ext4
---

First, delete the existing partition and create a new
Linux partition using `fdisk`:

`fdisk /dev/sdb`

Assuming `/dev/sdb` is the external hard disk. Use d to delete the partition and use n to create a new partition. 83 is the ID of the native Linux partition.

Then, format the partition with ext4 using `mkfs` which is just a unified front-end for the different `mkfs.fstype` tools:

`mkfs -t ext4 /dev/sdb1`

Finally, use `tune2fs` to adjust some parameters:
```
tune2fs -m 0 /dev/sdb1
tune2fs -L bakap01 /dev/sdb1
```
The `-m` option is for adjusting the percentage of reserved blocks. The reserved blocks are used by privileged processes which is by default 5% of the hard disk size. Since I'm using the external hard disk solely as a storage, I set this to 0 so I can also use those 5% for storage. The -L option is for labeling the filesystem.

Source: http://blag.borap.net/2011/08/10/formatting-an-external-hard-disk-with-ext4/
