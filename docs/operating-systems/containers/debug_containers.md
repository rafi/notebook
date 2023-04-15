---
title: Debug Containers
category: containers
---

# Debug Containers

## List container id's

```sh
docker ps --format "{{.ID}} {{.Names}}"

docker ps -aqf "name=^containername$"

docker inspect -f '{{.State.Pid}}' <container id>

DID=$(docker inspect -f '{{.State.Pid}}' <Container ID>);ps --ppid $DID -o pid,ppid,cmd

systemd-cgls

systemd-cgtop
```

Sort by CPU or memory:

```sh
docker stats --no-stream --format "table {{.Name}}\t{{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | sort -k 4 -h
docker stats --no-stream --format "table {{.Name}}\t{{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | sort -k 3 -h
```
