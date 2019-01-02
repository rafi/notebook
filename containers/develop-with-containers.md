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

[[toc]]

## Dockerfile Best Practices

Every line in your `Dockerfile` is an independent cached layer so it's important
to understand the mechanics of cache-busting and manual garbage collection.

### Separate Dependency Step

Almost every project has dependencies. It's important to separate the
installation of these dependencies from your actual project, and have it run
before your own project installation. To understand why, follow to the next
section on [leveraging docker cache](#leverage-docker-cache).

Here are a few examples of dependency separation:

#### Go

```docker
FROM golang:alpine
RUN go get -u -v github.com/golang/dep/cmd/dep
RUN go get -d -v golang.org/x/net/html
COPY . /go/src/github.com/golang/example/outyet
RUN go install github.com/golang/example/outyet
```

#### Python 3

```docker
FROM python:3.7-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN pip install -e .
```

#### NodeJS

```docker
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

```docker
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

```docker
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

```yaml
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

```yaml
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

## 10 Tips for Better `Dockerfile`s

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

So we've learned the power of containers in development by spinning up quickly
3rd-party services and our own projects for usage, but what about actual
development? During which we make a lot of changes and restart our application
to reload the changes repeatedly…

Writing your own code and using containers as runtime can surprisingly ease
development in certain situations.

### Exercise 1: Python Container with Debugging Support

Let's take Python for example. In-order to reload your code changes you must
reload your runtime server. Many frameworks and interpreters have a reload
option, e.g. [bottle](https://bottlepy.org/docs/dev/tutorial.html#auto-reloading),
[flask](http://flask.pocoo.org/docs/latest/server),
[gunicorn](https://docs.gunicorn.org/en/latest/settings.html?highlight=reload#debugging),
etc. However we can achieve this with restarting containers as-well.

Consider this application:

```py
import sys
import signal
import falcon


class HealthResource:
    def on_get(self, req, resp):
        resp.media = {'status': 'OK', 'health': 1.0}


def sigterm_handler(signum, frame):
    sys.exit(1)


def main(args):
    from wsgiref import simple_server
    signal.signal(signal.SIGTERM, sigterm_handler)
    httpd = simple_server.make_server('0.0.0.0', 8080, api)
    httpd.serve_forever()


api = falcon.API()
api.add_route('/healthz', HealthResource())

if __name__ == '__main__':
    main(sys.argv[1:])
```

A `Dockerfile`:

```docker
FROM python:3.7-slim
RUN pip install --no-cache-dir falcon
ENTRYPOINT ["python", "app.py"]
WORKDIR /app
COPY . .
```

And a `docker-compose.yml`:

```yaml
version: '2'

services:
  api:
    build: .
    image: myapp/api
    container_name: myapp-api
    ports:
      - 8080:8080
    volumes:
      - .:/app
```

Let's build our image:

```bash
$ docker-compose build
Building api
…
Successfully built d39e1a19c0d0
Successfully tagged myapp/api:latest

$ docker-compose up -d
Starting myapp-api ... done
```

With `curl` or [HTTPie](https://httpie.org) let's send a `/healthz` request:

```bash
$ curl localhost:8080/healthz
{"status": "OK", "health": 1.0}
```

Hooray.

[pdb](https://docs.python.org/3/library/pdb.html) is the most commonly-used
debugger for Python because it is built into the standard library.  Let's add
a breakpoint and see what happens:

```diff
class HealthResource:
    def on_get(self, req, resp):
+       import pdb; pdb.set_trace()
        resp.media = { 'status': 'OK', 'health': 1.0 }
```

Reload the container and run `curl` again:

```bash
$ docker-compose restart
Restarting myapp-api ... done

$ curl localhost:8080/healthz
A server error occurred.  Please contact the administrator.
```

Oh oh. We have an error. Let's examine the logs with `docker logs -f myapp-api`

```
172.23.0.1 - - [01/Jan/2019 19:53:44] "GET /healthz HTTP/1.1" 200 31
> /app/app.py(9)on_get()
-> resp.media = {'status': 'OK', 'health': 1.0}
172.23.0.1 - - [01/Jan/2019 20:00:39] "GET / HTTP/1.1" 404 0
Traceback (most recent call last):
  File "/usr/local/lib/python3.7/wsgiref/handlers.py", line 137, in run
    self.result = application(self.environ, self.start_response)
  File "/usr/local/lib/python3.7/site-packages/falcon/api.py", line 244, in __call__
    responder(req, resp, **params)
  File "app.py", line 9, in on_get
    resp.media = {'status': 'OK', 'health': 1.0}
  File "app.py", line 9, in on_get
    resp.media = {'status': 'OK', 'health': 1.0}
  File "/usr/local/lib/python3.7/bdb.py", line 88, in trace_dispatch
    return self.dispatch_line(frame)
  File "/usr/local/lib/python3.7/bdb.py", line 113, in dispatch_line
    if self.quitting: raise BdbQuit
bdb.BdbQuit
```

We need an interactive tty in-order for [pdb](https://docs.python.org/3/library/pdb.html)
to interact with us at the breakpoint. Let's stop this container and run our
api interactively:

```bash
$ docker-compose stop
Stopping myapp-api ... done

$ docker-compose run --rm --service-ports api
```

On a different terminal, let's `curl` again:

```bash
$ curl localhost:8080/healthz
```

This time, the request is frozen and the terminal window running docker-compose
initiated an interactive shell:

```
> /app/app.py(9)on_get()
-> resp.media = {'status': 'OK', 'health': 1.0}
(Pdb) list
  4
  5
  6     class HealthResource:
  7         def on_get(self, req, resp):
  8             import pdb; pdb.set_trace()
  9  ->         resp.media = {'status': 'OK', 'health': 1.0}
 10
 11
 12     def sigterm_handler(signum, frame):
 13         sys.exit(1)
 14

(Pdb) args
self = <__main__.HealthResource object at 0x7f82b947dd30>
req = <Request: GET 'http://localhost:8080/healthz'>
resp = <Response: 200 OK>

(Pdb) cont
```

Excellent! We can run containers with debugging support, but it's quite tiresome
to constantly restart our containers.

### Exercise 2: Auto-Reloading

For auto-reloading our containers, we can use a special little tool called
`entr`. You can install it with Homebrew on macOS:

```bash
$ brew install entr
…
==> Pouring entr-4.1.mojave.bottle.tar.gz
🍺  /usr/local/Cellar/entr/4.1: 7 files, 40.7KB
```

[`entr`](http://eradman.com/entrproject/) helps running arbitrary commands when
files change. This will help restarting container:

```bash
$ find . -name '*py' | entr -r docker-compose up
Starting myapp-api ... done
Attaching to myapp-api
```

Now let's change `OK` to `SEVERE` in `app.py`, to see if container restarts:

```diff
class HealthResource:
    def on_get(self, req, resp):
-       import pdb; pdb.set_trace()
-       resp.media = {'status': 'OK', 'health': 1.0}
+       resp.media = {'status': 'SEVERE', 'health': 1.0}
```

You will notice that our container has been restarted:

```bash
$ find . -name '*py' | entr -r docker-compose up
Starting myapp-api ... done
Attaching to myapp-api
Gracefully stopping... (press Ctrl+C again to force)
Stopping myapp-api ... done
Starting myapp-api ... done
Attaching to myapp-api
```

On a different terminal, let's test it:

```bash
$ curl localhost:8080/healthz
{"status": "SEVERE", "health": 1.0}
```

Hooray, no manual restarts! :smiley:

[The Silver Searcher](https://github.com/ggreer/the_silver_searcher) is a much
better tool than `find`, we can use it as-well:

```bash
ag -l --py | entr -r docker-compose up
```

### Exercise 3: Automating Docker-Compose

`make` is an old trusted build system. We can easily abuse it to make our
work-flow with docker-compose even more easier.

Consider the following `Makefile`:

```makefile
default: menu

menu:
	@echo "# MYAPP Makefile"
	@echo
	@echo "## docker-compose shortcuts:"
	@echo
	@echo "  * make bash - Execute bash in 'api' container"
	@echo "  * make clean - Delete composed container and lock files"
	@echo "  * make debug - Run app with an interactive tty"
	@echo "  * make develop - Install development requirements"
	@echo "  * make install - Build, create, and start app"
	@echo "  * make logs - Tail app containers logs"
	@echo "  * make ps - List all containers including load-stats"
	@echo "  * make stat - Start containers"
	@echo "  * make stop - Stop composed containers"
	@echo "  * make test - Run tests within 'api' container"
	@echo "  * make watch - Watch file changes and restarts 'api' container"
	@echo

bash:
	docker-compose exec api bash

clean: stop
	docker-compose down; \
	find . -name __pycache__ -type d | xargs rm -rf; \
	rm -rf *.egg-info dist .cache

debug:
	docker-compose run --rm --service-ports api

develop: install
	docker-compose exec api pip install -r dev-requirements.txt

install: stop
	docker-compose build

logs:
	docker-compose logs --tail 15 -f

ps:
	@docker-compose ps
	@echo
	@docker stats --no-stream $(docker-compose ps | grep '^\w' | awk '{print $1}')

start:
	docker-compose up -d

stop:
	docker-compose stop -t 5

test:
	docker-compose exec api py.test -v -s

watch:
	find . -name '*py' | entr -r docker-compose up --build api

.PHONY: menu bash clean debug develop install logs ps start stop test
```

Once saved, as `Makefile`, you can quickly run work-flow commands quickly,
for example:

```bash
make install
make start
```

Pretty useful when starting to learn docker/compose, it serves as a reference
card as-well.
