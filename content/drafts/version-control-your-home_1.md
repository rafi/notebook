---
title: Version Control /home with Git
date: 2013-10-26
category: version-control
tags:
- git
- dotfiles
---

# Version Control /home with Git

We'll create a detached bare repository somewhere tucked inside, point the work tree to your home, and more:

Create a bare repository in .config/config.git:
`git init --bare`

Now, let's change our minds and set a working tree:

```bash
git config core.bare false
git config core.worktree /home/rafi   ; NO TRAILING SLASH!
```

Make sure to create ~/.gitignore that will at least include `/.config/config.git` among other garbage you don't want collected by Git.

Prepare an alias in ~/.bash_aliases or ~/.bashrc:

```bash
alias gith='git --git-dir=/home/rafi/.config/config.git'
```

Now cd into your home folder, and run `gith status`, notice the *h* ;).
You can now start treating your home folder like a Git repository, using `gith`.
