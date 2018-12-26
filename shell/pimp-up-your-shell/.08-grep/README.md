# `grep` is so Darn Slow

```bash
$ cd ~/code
$ time grep -ri bob * >/dev/null

real    1m48.005s
user    1m26.262s
sys     0m10.616s
```

---

## Introducing… `ag`

A code-searching tool similar to ack, but faster.

```bash
$ cd ~/code
$ time ag bob >/dev/null

real    0m1.120s
user    0m1.266s
sys     0m1.322s
```

Install [`ag`](https://github.com/ggreer/the_silver_searcher):

```bash
brew install the_silver_searcher
```

---

## What's so great about Ag?

* It is an order of magnitude faster than ack.
* It ignores file patterns from your .gitignore and .hgignore.
* If there are files in your source repo you don't want to search, just add
  their patterns to a .ignore file. (\*cough\* \*.min.js \*cough\*)
* The command name is 33% shorter than ack, and all keys are on the home row!

---
