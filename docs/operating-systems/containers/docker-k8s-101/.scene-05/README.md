## Simplifying Workspaces

Docker Compose offers a number of benefits over the Docker CLI in all stages of
development.

Essentially, what Docker Compose is, is a recipe card — it's a recipe of
services that make up an application and the docker-compose.yml dictates how
the services are mixed together.

---

## Simple Example

Let's inspect our `docker-compose.yml` file:

```yaml
version: "2"
services:

  myapp:
    image: artifactory.local/myapp
    environment:
      MYAPP_CFG_ROOT: /etc/myapp
    ports:
      - "3000:3000"
    volumes:
      - ./myconfig:/etc/myapp
```

---

## Running Your Composition

```bash
git clone git@git.local:mycompany/myconfig.git
docker-compose up
```

On a different terminal:

```bash
curl localhost:3000
```

---

## Let's Add (3rd)Parties!

```yaml
version: "2"
services:

  myapp:
    image: artifactory.local/myapp
    environment:
      MYAPP_CFG_ROOT: /etc/myapp
    ports:
      - "3000:3000"
    volumes:
      - ./myconfig:/etc/myapp

  redis:
    image: "redis:alpine"
```

Let's run it:

```bash
docker-compose up
```

Whoa!

---

## Give me morrrre!

```yaml
version: "2"
services:

  myapp:
    image: artifactory.local/myapp
    environment:
      MYAPP_CFG_ROOT: /etc/myapp
    ports:
      - "3000:3000"
    volumes:
      - ./myconfig:/etc/myapp

  redis:
    image: "redis:alpine"

  mysql:
    image: "mysql:5.7"
    environment:
      MYSQL_ROOT_PASSWORD: root
```

Let's run it:

```bash
docker-compose up
```

---

## Access Services

```bash
# Access MySQL:
docker exec -it scene-05_mysql_1 mysql -u root -p

# Access Redis:
docker exec -it scene-05_redis_1 redis-cli GET /
```

---

## More on Docker-Compose

* `docker-compose ps` - Lists all services in network.
* `docker-compose up` - Brings up the network & services.
* `docker-compose stop` - Stops the network, saves state of services.
* `docker-compose start` - Restarts the services.
* `docker-compose down` - Burn it all down! Destroy network & services.

---

![Bob and Lucy](./img/bob-and-lucy-beach.png)

---
