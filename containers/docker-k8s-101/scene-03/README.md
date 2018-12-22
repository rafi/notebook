# Linux Containers

## Images vs. Containers

Docker **images** are executable packages that include everything needed to run
an application — the code, a runtime, libraries, environment variables, etc.

Docker **containers** are a runtime instance of an image — what the image
becomes in memory when executed.

---

Examples of Docker containers. Each one comes from a specific Docker image.

![Docker containers](./img/docker-containers.png)

---

## Entering Container's Shell

```bash
docker run -d --name bob -p 3000:3000 test-node
docker exec -it bob sh
```

You are now INSIDE the ~~matrix~~ container!

```bash
> netstat -ntulp
> wget -q -O- localhost:3000
> top
> free -m
> exit
```

---

## Running Different Commands

```bash
docker run --rm -it test-node sh
docker run --rm -it test-node ls -alp
```

---

## View Container Information

```bash
docker inspect bob | less
docker logs -f bob
docker stats bob
```

---

## Manage State

```bash
docker stop bob
docker start bob
docker restart bob
docker rm -f bob
```

---

![Dylan small man](./img/dylan-small-man.png)

---
