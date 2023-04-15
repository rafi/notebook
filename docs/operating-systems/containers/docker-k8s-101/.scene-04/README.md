# Private Services

```bash
docker run --rm -p 3000:3000 artifactory.local/myapp
```

Oh oh. What's missing here?

---

## Mount Volumes

Let's mount our configuration from a different Git repository:

```bash
git clone git@git.local:mycompany/myconfig.git

docker run --rm -v $PWD/myconfig:/etc/myapp \
  -p 3000:3000 artifactory.local/myapp
```

Dog-gone it. What else are we missing?

---

## Environment Variables

Oh. Our environment variable! It tells the configuration where to read from:

```bash
docker run --name bob -v $PWD/myconfig:/etc/myapp \
  -e MYAPP_CFG_ROOT=/etc/myapp -p 3000:3000 \
  artifactory.local/myapp
```

---

## Viewing Logs

In a different terminal,

```bash
docker logs -f bob
docker exec -it bob tail -f /var/log/myapp/api.log
```

---

![Bob the beach](./img/bob-beach.png)

---
