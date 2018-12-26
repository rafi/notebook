# The Shell is The Best File-manager

Let's improve our speed of '`cd`' by a bazillion!

---

## Introducing… `z`

After a short learning phase, z will take you to the most 'frecent'
directory that matches ALL of the regexes given on the command line, in
order.

```bash
brew info z
brew install z
```

Append to `~/.config/bash/utils`

```bash
# https://github.com/rupa/z
# Must be loaded _after_ setting PROMPT_COMMAND
if [ -f "/usr/local/etc/profile.d/z.sh" ]; then
  . "/usr/local/etc/profile.d/z.sh"
fi
```

---

# Train `z`

`z` has to be trained. `cd` into your favorite directories.

```bash
cd ~/code/work/ansible
cd ~/code/dev/myproject
cd ~/.config
cd ~/.vim
```

Check `z`'s listing:

```bash
$ z
112.274    /Users/rafi/code/tikal/dartagnan-infra
148.375    /Users/rafi/code/dev/acme/docker-k8s-101
275.512    /Users/rafi/code/dev/acme
311.72     /Users/rafi/code/acme/pimpupyourshell
663.29     /Users/rafi/code/work/foo/autobots
21717.8    /Users/rafi/code/work/foo/autobots-k8s-onprem
```

---

# Use `z`

```bash
$ z foo auto
$ pwd
/Users/rafi/code/work/foo/autobots

$ z prem
$ pwd
/Users/rafi/code/work/foo/autobots-k8s-onprem

$ z dart.*infra
$ pwd
/Users/rafi/code/tikal/dartagnan-infra
```

---

![Very Nice!](./img/borat-very-nice.gif)

---
