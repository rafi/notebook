# `git` is Glorious.

![Borat Kazak](./img/borat-kazak.jpg)

---

## `git log` is Ugly

Teach git some new pretty formats, append to `~/.gitconfig`

```ini
[pretty]
	log = %C(240)%h%C(reset) -%C(auto)%d%Creset %s %C(242)(%an %ar)
	detailed = %C(cyan)%h %C(red)%ad %C(blue)[%an]%C(magenta)%d %C(white)%s
	shorter = %C(auto)%D %C(240)--%C(242)%gD%N %ad by %C(white)%cn%C(reset)
```

---

## Git Has It's Own Aliases

Teach git some new tricks: (append to `~/.gitconfig`)

```ini
[alias]
	log  = log --pretty=log
	lb   = log --graph --simplify-by-decoration --pretty=shorter --all --notes --date-order --relative-date
	lg   = log --graph --pretty=log --all
	lgd  = log --graph --pretty=log
	lgw  = !sh -c '"while true; do clear; git lg -15; sleep 5; done"'
```

Let's add some Bash aliases: (append to `~/.config/bash/aliases`)

```bash
alias gfl='git fetch --prune && git lg -15'
alias gl='git lg -15'
alias gll='git lg'
alias gld='git lgd -15'
```

---

# Try it Out

```bash
gl
gll
gld
git lb
git lgw
```

Great visibility, great benefits. Understand repository history better.

---

## Mooooore Git Aliases

```ini
[alias]
	s  = status -sb
	f  = fetch --prune
	c  = commit -v
	cm = commit -vm
	br = branch -v
	st = status
	ck = checkout
	t  = tag --column
	tn = tag -n
	d  = diff
	ds = diff --staged
	dw = diff --color-words
	dh = diff --color-words HEAD
	dp = !git log --pretty=oneline | fzf | cut -d ' ' -f1 | xargs -o git show
	lcrev = log --reverse --no-merges --stat @{1}..
	lcp   = diff @{1}..
	patch = !git --no-pager diff --no-color
	prune = fetch --prune
	stash-all = stash save --include-untracked
	sm    = submodule
	smu   = submodule foreach git pull origin master
	snapshot = !git stash save "snapshot: $(date)" && git stash apply "stash@{0}"
	snapshots = !git stash list --grep snapshot
	w  = whatchanged --decorate
	wp = whatchanged --decorate -p
```

---

## Better Git Diffs

Use [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)

![Diff-so-fancy comparison](./img/diff-so-fancy.png)

---

## Diff So Fancy

```bash
brew info diff-so-fancy
brew install diff-so-fancy
```

Edit your `~/.gitconfig`

```ini
[pager]
	show-branch = true
	status = true
	diff = diff-so-fancy | less --tabs=1,3
	show = diff-so-fancy | less --tabs=1,3
```

---

# More Git Trickery

Check-out my [git/config](https://github.com/rafi/.config/blob/master/git/config)

in my [github.com/rafi/.config](https://github.com/rafi/.config) repository.

---
