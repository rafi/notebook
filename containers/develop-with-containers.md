---
title: Developing with Docker containers
date: 2018-12-31
featured: true
categories:
- containers
search:
  keywords: ['docker', 'containers', 'develop']
---

# Developing with Docker containers

As a programmer I often use many different technologies and frameworks.
It's a pain installing all the different dependencies, and that's why Docker
has become such a valuable tool, not only in production.

I'll start with analyzing `Dockerfile`s and then continue to talk about
developing with containers.

## Dockerfile Best Practices

Every line in your `Dockerfile` is an independent cached layer so it's important
to understand the mechanics of cache-busting and manual garbage collection.

### Separate Dependency Step

Almost every project has dependencies. It's important to separate the
installation of these dependencies from your actual project, and have it run
before your own project installation. To understand why, follow to the next
section on [Cache-Busting](#cache-busting).

Here are a few examples of dependency separation:

#### Go

```Dockerfile
FROM golang:alpine
RUN go get -u -v github.com/golang/dep/cmd/dep
RUN go get -d -v golang.org/x/net/html
COPY . /go/src/github.com/golang/example/outyet
RUN go install github.com/golang/example/outyet
```

#### Python 3

```Dockerfile
FROM python:3.7-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN pip install -e .
```

#### NodeJS

```Dockerfile
FROM node:10.13-alpine
WORKDIR /app
COPY package.json .
RUN yarn install
COPY . .
RUN yarn build
```

### Leverage Docker Cache

Cached layers offer great speed improvement for continuous builds. Of course,
your own code changes every single build, but your dependencies don't change
so often.

That is why the order in which you write your `Dockerfile` has much meaning.
Docker will detect changes, whether it's a change in the `Dockerfile` itself,
or a file change when using `ADD` or `COPY`. Once a change is detected, all
lower layers will be rebuilt, meaning a change in a layer causes all other
layers below it to lose their cache.

Some people would argue that using cached layers isn't sterile. If you really
want continuous-integration to slowly re-build every layer in each build, you
can use the `--no-cache` flag with `docker build`. However I advise on still
leveraging Docker's cache in development.

### Garbage Collection

With Docker, each layer can introduce new files that will weigh in the image
size forever. This is why projects like [Makisu](https://github.com/uber/makisu)
appeared, offering more control for layer commits.

Back to Docker, each layer has a size that weighs in forever. For example,
the following example is BAD practice of installing cython & ujson:

```Dockerfile
FROM python:3.7-slim
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential
RUN pip install cython ujson
RUN apt-get purge -y build-essential
RUN apt-get autoremove -y
RUN apt-get autoclean -y
RUN rm -rf /var/lib/{apt,dpkg,cache,log} /tmp/* ~/.cache
RUN rm -rf /usr/src/python /usr/share/doc /usr/share/man
RUN rm -f /var/cache/apt/archives/*.deb
```

If we inspect our image after a `docker build -t test1 .`, we can see each
layer's size:

```bash
$ docker images
REPOSITORY  TAG      IMAGE ID       SIZE
test1       latest   72f07c204ff6   375MB

$ docker history test1
IMAGE             CREATED BY                                      SIZE
72f07c204ff6      /bin/sh -c rm -f /var/cache/apt/archives/*.d…   0B
14600e43ad38      /bin/sh -c rm -rf /usr/src/python /usr/share…   0B
a4fe8c374984      /bin/sh -c rm -rf /var/lib/{apt,dpkg,cache,l…   0B
b2b4c3b72b25      /bin/sh -c apt-get autoclean -y                 0B
4f0ce2c2e625      /bin/sh -c apt-get autoremove -y                1.36MB
b529b6b0c31c      /bin/sh -c apt-get purge -y build-essential     1.38MB
3e670b77c1ac      /bin/sh -c pip install cython ujson             17.7MB
2d3e5fe7403b      /bin/sh -c apt-get install -y build-essential   195MB
4df21d8298f1      /bin/sh -c apt-get update                       16.3MB
```

We in-fact created many layers that are like snapshots in time. If we have
combined them, or "squashed" them, the overall layer size will be more
efficient, aggregated:

```Dockerfile
FROM python:3.7-slim
RUN apt-get update && \
  apt-get install -y --no-install-recommends build-essential && \
  pip install cython ujson && \
  apt-get purge -y build-essential && \
  apt-get autoremove -y && \
  apt-get autoclean -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log} /tmp/* ~/.cache && \
  rm -rf /usr/src/python /usr/share/doc /usr/share/man && \
  rm -f /var/cache/apt/archives/*.deb
```

After building this again, we can see our single layer has been really cleaned!

```bash
$ docker images
REPOSITORY  TAG      IMAGE ID       SIZE
test2       latest   457ed321603d   189MB
test1       latest   72f07c204ff6   375MB

$ docker history test2
IMAGE             CREATED BY                                      SIZE
457ed321603d      /bin/sh -c apt-get update &&   apt-get insta…   46.1MB
```

As you can see, we've improved the image size by 186mb by squashing multiple
layers into one.

## 3rd-Party Dependencies and Docker Compose

Programming today involves a developer to use many different persistency
services such as MySQL, PostgreSQL, Redis, Elasticsearch, Kafka, RabbitMQ etc.

Running all these services on your personal workstation can be very cumbersome
and complex. Just imagine project A needs MongoDB 2.x and project B needs
MongoDB 4.x -- this used to be a real pain until Docker made it real easy.

Docker-compose is an invaluable tool for development, it defines a composition
of services that can be created & destroyed in matter of seconds. Let's review
the following example:

```yaml.docker-compose
version: '2'

services:
  db:
    image: postgres:11-alpine
    container_name: myapp-db
    ports:
      - 5432:5432
    environment:
      POSTGRES_DB: myappdb
      POSTGRES_USER: bob
      POSTGRES_PASSWORD: thedog

  redis:
    image: redis:5-alpine
    container_name: myapp-db
    ports:
      - 6379:6379
```

Now a simple `docker-compose up` will run PostgreSQL & Redis in the exact
versions we need and accessible on ports 5432 and 6379.

If your project has a `Dockerfile`, we can automate our project as-well:

```yaml.docker-compose
version: '2'

services:
  myapp:
    build:
      context: .
      args:
        APP_DEBUG: 'true'
        APP_ENV: 'development'
        DATABASE_URL: 'postgresql://bob:thedog@db/myappdb'
    image: myapp/api
    container_name: myapp-api
    ports:
      - 8080:8080
    depends_on:
      - db
      - redis
    volumes:
      - .:/app

  db:
    image: postgres:11-alpine
    container_name: myapp-db
    ports:
      - 5432:5432
    environment:
      POSTGRES_DB: myappdb
      POSTGRES_USER: bob
      POSTGRES_PASSWORD: thedog

  redis:
    image: redis:5-alpine
    container_name: myapp-db
    ports:
      - 6379:6379
```

With the above `docker-compose.yml` file, running `docker-compose build` will
build your project's image via `Dockerfile` in current directory, and running
`docker-compose up` will run your project and be accessible via port 8080.

Docker-compose is like porcelain on-top of docker commands, it's written in
Python and is open-sourced.

Find pre-built images in [Docker Hub](https://hub.docker.com/).

## 10 Tips for `Dockerfile`s

1. Combine `RUN` statements.
1. Clean after yourself.
1. Don't copy your entire application directory in one line. Separate the
   dependencies before.
1. Use `.dockerignore` file to reduce the context Docker needs to copy.
1. Use `COPY` instead of `ADD`. `COPY` is simple, `ADD` has some magic
   under-hood.
1. Create a non-root user. A good preventive security practice.
1. Don't run multiple services in one container.
1. Don't use external services during build e.g. database migration.
1. Declare cheap commands as late as possible (`EXPOSE`, `ENV`, `ARG`, etc.).
1. Pin software versions. Never, ever, use `:latest` tags. It can lead to
   unexpected disasters.

## Developing Alongside Containers
