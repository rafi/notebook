---
title: 'Docker & Kubernetes 101'
date: '2018-12-20'
featured: true
categories:
- containers
search:
  keywords: ['docker', 'kubernetes', 'containers']
---

# Docker & Kubernetes 101


---

# Docker

> Docker is a tool designed to make it easier to create, deploy, and run
> applications by using containers. Containers allow a developer to package up
> an application with all of the parts it needs, such as libraries and other
> dependencies, and ship it all out as one package. — OpenSource.com, What is
> Docker?

---

# Infrastructure

Don't worry about the system your application will ultimately run on.

---

# Install Docker

Install at Docker's [getting-started](https://www.docker.com/get-started)

---

# Setup Docker

First, ensure you are using an up-to-date docker engine.
In the terminal,

1. Run `docker info` and check for any errors
1. Run `docker --version` and ensure you have version >=17.06

---

# Setup Docker Resources

Ensure you have set enough resources for Docker to run smoothly:
In the taskbar, click the whale icon → Preferences → Advanced

(I set 6 CPUs and 8GB RAM for Docker)

---

## Settings

![docker settings](./img/docker_engine_settings.png)

---
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
## My First Containerized Node Application

I recommend [Dockerfile documentation](https://docs.docker.com/engine/reference/builder/).
It's very well written.

---

## Dockerfile

Node service:

```Dockerfile
# creates a layer from the node:carbon Docker image
FROM node:8.14-alpine

# create the app directory for inside the Docker image
WORKDIR /usr/src/app

# copy and install app dependencies from the package.json (and the package-lock.json) into the root of the directory created above
COPY package*.json ./
RUN yarn install

# bundle app source inside Docker image
COPY . .

# expose port 8080 to have it mapped by Docker daemon
EXPOSE 3000

# define the command to run the app
CMD [ "yarn", "run", "start" ]
```

---

## app.js

```javascript
var express = require('express');
var app = express();

process.on('SIGINT', function () {
  process.exit();
});

app.get('/', function (req, res) {
  res.send("Hello World!
");
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
```

---

## package.json

```json
{
  "name": "docker-101-scene-02",
  "version": "1.0.0",
  "main": "index.js",
  "author": "Rafael Bodill",
  "license": "MIT",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.16.4"
  }
}
```

---

## Let's Build & Run

```bash
docker build -t test-node .
docker run -it --rm test-node
```

On a new terminal:

```bash
curl localhost:3000
```

Where's my service? :(

---

## Expose Ports to Host

```bash
docker run -it --rm -p 3000:3000 test-node
```

On a new terminal:

```bash
curl localhost:3000
```

Hooray!

---

## Let's Add a Route

Append to `app.js`:

```javascript
app.get('/healthz', function (req, res) { res.send('OK') })
```

Rebuild image:

```bash
docker build -t test-node .
docker run -it --rm test-node
```

---

## Docker Layer Caching

![Docker Caching](./img/docker-caching.png)

---

## Docker Layers

```bash
$ docker history test-node

IMAGE               CREATED          SIZE      CREATED BY
d17562ebd02e        27 minutes ago   0B        CMD ["yarn" "start"]
c24c2a8c7a2a        27 minutes ago   0B        EXPOSE 3000
001439668f54        27 minutes ago   1.78MB    COPY dir:0dc6500de44402cb2…
24e151c2462b        27 minutes ago   7.13MB    yarn install
9dd639668f68        27 minutes ago   226B      COPY file:b365e33dfa656564…
a93bcafb8a76        27 minutes ago   0B        WORKDIR /usr/src/app
```

.. Wait ..  Our `app.js` is 1.78MB?

---

## Ignoring Files

Create a `.dockerignore` file with:

```txt
.git
.dockerignore
*.md
*.png
Dockerfile
node_modules
```

Rebuild image:

```bash
docker build -t test-node .
docker history test-node
```

Now it's better.

---

![Bob poster child](./img/bob-poster.png)

---
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
# Kubernetes (K8S) 101

https://docs.google.com/presentation/d/1BhUfwkiRTQZsvN9kCpxpbT09kpWFTiuAprOfGemrf6Q

---

## Workstation Setup

```bash
brew install kubernetes-cli kubectx \
  fzf stern bash-completion@2 --with-short-names
```

Append to your `~/.bash_profile` for awesome shell completion:

```bash
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi
```

---

## Setup kubectl Context

_Cluster_ + _User_ = *Context*

```bash
# Integration
kubectl config set-cluster foobar-int-developer --server=https://1.2.3.4:6443 --certificate-authority=$HOME/.kube/int/ca.pem
kubectl config set-credentials int-developer --client-certificate=$HOME/.kube/int/developer.crt --client-key=$HOME/.kube/int/developer.key
kubectl config set-context foobar-int-developer --cluster=foobar-int-developer --user=int-developer

# Staging
kubectl config set-cluster foobar-stg-developer --server=https://5.6.7.8:6443 --certificate-authority=$HOME/.kube/stg/ca.pem
kubectl config set-credentials stg-developer --client-certificate=$HOME/.kube/stg/developer.crt --client-key=$HOME/.kube/stg/developer.key
kubectl config set-context foobar-stg-developer --cluster=foobar-stg-developer --user=stg-developer
```

---

## kctx

```bash
kubectl config use-context foobar-int-developer
kctx
kctx foobar-int-developer
kctx foobar-stg-developer
```

---

## kubectl Cheat-sheet

```bash
kubectl get namespaces
kubectl get deploy
kubectl get -n ingress-nginx deploy
kubectl get -n kube-system deploy
kubectl get --all-namespaces deploy
kubectl get pods -w
kubectl get pods -o wide
kubectl get events

kubectl get pods,svc,deploy
kubectl describe deploy push-service
kubectl top node
kubectl top pods
kubectl logs -f deploy/trips
kubectl logs -f deploy/trips -c trips
kubectl logs --previous trips-7d7f649996-nz876
kubectl exec -it trips-6c6887547d-lhbsb -- tail -f /var/log/myapp/api.log
```

---

## Examining Deployed Objects

```bash
kubectl get deploy
kubectl get pod
kubectl get svc
kubectl get deploy,pod,svc | grep myapp
kubectl get all | grep myapp
```

---

## Describe Deployment

```bash
kubectl describe deploy myapp
kubectl describe pod myapp-649887b547-fh7vw
kubectl top pod | grep myapp
```

---

## Analyze Logs

```bash
kubectl logs -f myapp-649887b547-fh7vw
kubectl exec -it myapp-649887b547-fh7vw -- tail -f /var/log/myapp/api.log
```

---

## Jump into Container

```bash
$ kubectl exec -it myapp-649887b547-fh7vw sh
> top
> free -h
> exit
```

---

![Mind blown.](./img/mindblown.png)

---
