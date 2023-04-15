# `grep` is so Darn Slow

```bash
$ cd ~/code
$ time grep -ri bob * >/dev/null

real    1m48.005s
user    1m26.262s
sys     0m10.616s
```

---

## Introducing… `rg`

ripgrep recursively searches directories for a regex pattern while respecting
your gitignore and doing it fast.

```bash
$ cd ~/code
$ time rg bob >/dev/null

real    0m1.120s
user    0m1.266s
sys     0m1.322s
```

Install [`rg`](https://github.com/BurntSushi/ripgrep):

```bash
brew install ripgrep
```

---

## What's so great about Ripgrep?

* It is an order of magnitude faster than ack.
* It ignores file patterns from your .gitignore.
* If there are files in your source repo you don't want to search, just add
  their patterns to a .ignore file. (\*cough\* \*.min.js \*cough\*)

---
