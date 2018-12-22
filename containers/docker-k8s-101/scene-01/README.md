## World Smallest Image

Every single Docker container begins as a pure vanilla Linux machine that
knows nothing.

![know nothing](./img/knownothing.png)

---

## Where It All Begins

A Docker image consists of read-only layers each of which represents a
Dockerfile instruction. The layers are stacked and each one is a delta of the
changes from the previous layer.

Images start as a fresh, isolated machine and the very same dependencies
get added to it. Every. Single. Time.

```Dockerfile
FROM scratch

ADD hello /

CMD ["/hello"]
```

---

## Build your First Image

```bash
docker build -t tiny-hello-world .
docker images
```

---

## Run your First Container

```bash
docker run tiny-hello-world
docker ps -a
```

---

## Clean After Yourself

Delete a container:

```bash
docker rm condescending_ptolemy
```

Next time, run container & delete after exit:

```bash
docker run --rm tiny-hello-world
```

---

## Advanced

Delete all stopped containers:

```bash
docker container prune
```

Delete all dangling images:

```bash
docker image prune
```

---

![Bob and Dylan](./img/bob-and-dylan.png)

---
