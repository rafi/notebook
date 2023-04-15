# Linux Processes

## Process Parent

```sh
ps -o ppid= -p <pid>
```

## Process information

```sh
ps -Flww -p <pid>
```

On Linux, `top` actually supports focusing on a single process, although it naturally doesn't have a history graph:

```sh
top -p <pid>
```

This is also available on Mac OS X with a different syntax:

```sh
top -pid <pid>
```

See also pidstat. (part of sysstat package)
