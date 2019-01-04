---
title: Pimp Up Your Shell
date: 2018-12-23
featured: true
categories:
- shell
search:
  keywords: [shell, terminal, bash, linux]
---

# Pimp Up Your Shell


---

## How Do You Call Your Workstation?

Give your box a name please: (:warning: Change rafi-mac to something of yours)

```bash
hostname
export COMPUTER_NAME="rafi-mac"
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${COMPUTER_NAME}"
sudo scutil --set LocalHostName "${COMPUTER_NAME}"

sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${COMPUTER_NAME}"
```

You might need to reboot your laptop after this. :face_with_rolling_eyes:

Check-out [mths.be/macos](https://mths.be/macos) for awesome ways to configure
your macOS.

---

## Most Frequently Used Shells

1. **Bash** - (Bourne Again Shell) Default on many Linux distros.
2. **Tcsh** - Enhanced C shell.
3. **Ksh** - Korn shell.
4. **Zsh** - Incorporates many features of other Unix/GNU Linux shells.
5. **Fish** - Friendly interactive shell.

---

## Apple Packs Outdated Software

```bash
$ echo $BASH_VERSION
3.2.57(1)-release

$ git version
git version 2.17.1
```

On July 27, 2004, Chet Ramey released version 3 of Bash.

---

# Let's Install Newest Bash!

```bash
brew uninstall --force bash-completion
brew install readline bash bash-completion@2
```

---

## Set New Bash As Default Shell

```bash
echo "/usr/local/bin/bash" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash
```

Now, close all Terminal windows and open them again.

```bash
echo $BASH_VERSION
```

You should see the fresh new Bash version you've installed.

---
## GNU vs. BSD

POSIX is a set of standards to implement.

GNU tools are basically open versions of tools that already existed but were
redone to conform to principals of open software.

Unix and BSD are "older" implementations of POSIX that are various levels of
"closed source".

---

![Unix timeline](./img/unix_timeline.svg)

---

## GNU vs. BSD

Let's install some GNU tools!

```bash
brew install coreutils gnutls gawk gnu-sed gnu-tar gnu-which
```

```bash
brew ls coreutils
/usr/local/bin/gsort --help
/usr/bin/sort --help
```

---
# Init Scripts

Remember `autoexec.bat` and `config.sys` ?

```
@ECHO OFF
PROMPT $P$G
PATH C:\DOS;C:\WINDOWS
SET TEMP=C:\TEMP
SET BLASTER=A220 I7 D1 T2
LH SMARTDRV.EXE
LH DOSKEY
LH MOUSE.COM /Y
```

---

### `~/.bashrc` & `~/.bash_profile`

`.bash_profile` is executed for login shells, while `.bashrc` is executed for
interactive non-login shells.

When you login via console or ssh: `.bash_profile` is executed to configure
your shell before the initial command prompt.

But, if you've already logged into your machine and open a new terminal window
then `.bashrc` is executed before the window command prompt.

On macOS, Terminal by default runs a login shell every time,
so this is a little different to most other systems.

---

## Fresh New Shell Init Scripts

Let's backup our .bashrc and .bash_profile and start a new fresh beginning.

```bash
mv ~/.bashrc ~/.bashrc.old
mv ~/.bash_profile ~/.bash_profile.old
```

```bash
mkdir -p ~/.config/bash
touch ~/.config/bash/bashrc ~/.config/bash/profile
cd ~
ln -s .config/bash/bashrc .bashrc
ln -s .config/bash/profile .bash_profile
```

---

## Let's Architect This

```bash
cd ~/.config/bash
touch aliases completion exports inputrc utils

mkdir -p ~/.local/{share,bin} ~/.cache
```

In your new `~/.config/bash/exports`

```bash
# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export  XDG_CACHE_HOME="$HOME/.cache"
export   XDG_DATA_HOME="$HOME/.local/share"
```

---

## Let's Source 'em!

In your new `~/.bash_profile`:

```bash
source "$HOME/.config/bash/exports"
source "$XDG_CONFIG_HOME/bash/bashrc"
```

In your new `~/.bashrc`:

```bash
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source "$XDG_CONFIG_HOME/bash/completion"
source "$XDG_CONFIG_HOME/bash/aliases"
source "$XDG_CONFIG_HOME/bash/utils"
```

---

# Readline

> GNU Readline is a software library that provides line-editing and history
> capabilities for interactive programs with a command-line interface, such
> as Bash.

---

## Readline Config

Update `~/.config/bash/inpurc` with following:

```
# Ring the bell, let other programs handle it (urxvt, tmux, etc.)
set bell-style audible

# Ignore case when matching and completing paths
set completion-ignore-case On

# Treat underscores and hyphens the same way for completion purposes
set completion-map-case On

# Show me up to 5,000 completion items, don't be shy
set completion-query-items 5000

# Don't display control characters like ^C if I input them
set echo-control-characters Off

# Expand tilde to full path on completion
set expand-tilde On

# Preserve caret position while browsing through history lines
set history-preserve-point On

# When completing directories, add a trailing slash
set mark-directories On

# Do the same for symlinked directories
set mark-symlinked-directories On

# on menu-complete, first display the common prefix, then cycle through the
# options when hitting TAB
set menu-complete-display-prefix On

# Don't paginate possible completions
set page-completions Off

# Show multiple completions on first tab press
set show-all-if-ambiguous On

# Don't re-complete already completed text in the middle of a word
set skip-completed-text On

# Show extra file information when completing, like `ls -F` does
set visible-stats on
```

---

## Tell Shell Where to Find Things

Append to `~/.config/bash/exports`

```bash
# Local bin
export PATH="$HOME/.local/bin:$PATH:bin"

# Python per user site-packages directory
export PATH="$PATH:$HOME/Library/Python/3.7/bin"
export PATH="$PATH:$HOME/Library/Python/2.7/bin"

export INPUTRC="$XDG_CONFIG_HOME/bash/inputrc"

export HOMEBREW_GITHUB_API_TOKEN="yourtokenhere"

# Misc defaults
export LESS="-FiQMXR"
export LESSCHARSET="UTF-8"
```

Generate new token for Homebrew at
[github.com/settings/tokens](https://github.com/settings/tokens)

---

## Improve `ls`

Append to `~/.config/bash/aliases`

```bash
# Use GNU ls on macOS instead of BSD
hash gls 2>/dev/null && LS="gls" || LS="ls"

# Listing directory contents
alias ls='LC_COLLATE=C '$LS' --color=auto --group-directories-first'
alias l='ls -CFa'
alias ll='ls -alF'
alias lsd='ls -Gal | grep ^d'
unset LS
```

---

## Use GNU Tools

Remember we installed '`coreutils`'?

Let's append to `~/.config/bash/aliases`

```bash
hash gdircolors 2>/dev/null && alias dircolors=gdircolors
hash gsort 2>/dev/null && alias sort=gsort
```

---

## Have Fun With Aliases

Append to `~/.config/bash/aliases`

```bash
# Carry over aliases to the root account when using sudo
alias sudo='sudo '

alias grep="grep --color=auto --exclude-dir=.git"

# File find, if fd is not installed
if ! hash fd 2>/dev/null; then
	alias f='find . -iname '
	alias ff='find . -type f -iname '
	alias fd='find . -type d -iname '
fi

# Head and tail will show as much possible without scrolling
hash ghead 2>/dev/null && alias h='ghead -n $((${LINES:-12}-4))'
hash gtail 2>/dev/null && alias t='gtail -n $((${LINES:-12}-4)) -s.1'

# Shortcuts
alias c='clear'
alias diff='colordiff'

# Storage
alias dut="du -hsx * | sort -rh | head -10"
alias dfu="df -hT -x devtmpfs -x tmpfs"

# Processes
alias process='ps -ax'
alias psk='ps -ax | fzf | cut -d " " -f1 | xargs -o kill'
alias pst='pstree -g 3 -ws'

# Misc
alias cal='cal | grep -C6 "$(date +%e)"'
alias fontcache='fc-cache -f -v'
alias freq='cut -f1 -d" " "$HISTFILE" | sort | uniq -c | sort -nr | head -n 30'
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias multiopen='while read i; do open "$i"; done <<<'
alias ungzip='gzip -d'
alias untar='tar xvf'
alias ipinfo="curl -s ipinfo.io"
alias weather="curl -s wttr.in/Tel-Aviv"

# A quick way to get out of current directory
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# Kubernetes
alias k=kubectl
alias kctx=kubectx

# Git
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --cached'
alias gf='git fetch --prune'
alias gfa='git fetch --all --tags --prune'
alias gs='git status -sb'

# Docker
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{ .Ports }}\t{{.RunningFor}}\t{{.Command}}\t{{ .ID }}" | cut -c-$(tput cols)'
alias dls='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{ .Ports }}\t{{.RunningFor}}\t{{.Command}}\t{{ .ID }}" | cut -c-$(tput cols)'
alias dim='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedSince}}"'
alias dgc='docker rmi $(docker images -qf "dangling=true")'
alias dvc='docker volume ls -qf dangling=true | xargs docker volume rm'
alias dtop='docker stats $(docker ps --format="{{.Names}}")'
alias dnet='docker network ls && echo && docker inspect --format "{{\$e := . }}{{with .NetworkSettings}} {{\$e.Name}}
{{range \$index, \$net := .Networks}}  - {{\$index}}	{{.IPAddress}}
{{end}}{{end}}" $(docker ps -q)'
alias dtag='docker inspect --format "{{.Name}}
{{range \$index, \$label := .Config.Labels}}  - {{\$index}}={{\$label}}
{{end}}" $(docker ps -q)'
```

---

## Improve Bash Behavior

Prepend in your `~/.bashrc`

```bash
# Bash settings
shopt -s cdspell        # Auto-corrects cd misspellings
shopt -s checkwinsize   # Update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist        # Save multi-line commands in history as single line
shopt -s dotglob        # Include dotfiles in pathname expansion
shopt -s expand_aliases # Expand aliases
shopt -s extglob        # Enable extended pattern-matching features
shopt -s histreedit     # Add failed commands to the bash history
shopt -s histappend     # Append each session's history to $HISTFILE
shopt -s histverify     # Edit a recalled history line before executing

export HISTSIZE=3000
export HISTFILESIZE=1500000
export HISTTIMEFORMAT='[%F %T] '
export HISTIGNORE='pwd:jobs:ll:ls:l:fg:history:clear:exit'
export HISTCONTROL=ignoreboth
export HISTFILE="$XDG_CACHE_HOME/bash_history"
export VISUAL=vim
export EDITOR="$VISUAL"
export PAGER=less
```

---

## Completions!!!!!!

Append in your `~/.config/bash/completion`

```bash
# Load all completions Homebrew's bash-completion@2 has prepared
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi

# Kubernetes
complete -o default -F __start_kubectl k

# Extra macOS stuff
if [[ "$OSTYPE" == "darwin"* ]]; then
	# Add tab completion for `defaults read|write NSGlobalDomain`
	# You could just use `-g` instead, but I like being explicit
	complete -W "NSGlobalDomain" defaults

	# Add `killall` tab completion for common apps
	complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall
fi
```

---

## Docker Completions

Symlink Docker app Bash scripts:

```bash
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion /usr/local/etc/bash_completion.d/docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion /usr/local/etc/bash_completion.d/docker-machine
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion /usr/local/etc/bash_completion.d/docker-compose
```

---

# More Bash Trickery

Check-out my [Bash config](https://github.com/rafi/.config/tree/master/bash)

in my [github.com/rafi/.config](https://github.com/rafi/.config) repository.

---
# Know Your OS Package-Manager

Hello, my name is Homebrew

```bash
brew --version
```

Please treat & upgrade me nicely, I'm fighting against Apple's will:

```bash
$ brew docker
$ brew update
$ brew outdated
$ brew upgrade
$ brew cleanup
==> This operation has freed approximately 7.2GB of disk space.
```

:muscle:

---

## Install Everyone's Favorite Tools

```bash
brew install bc tree colordiff pstree jq urlview tcpdump nmap \
  curl unrar netcat the_silver_searcher figlet p7zip ncdu calc \
  watch pidof grc icdiff git-cal git-extras ranger wget rsync \
  yamllint spark tig htop fzf fzy

brew install go node yarn python python@2 pipenv
brew install git --with-curl --with-openssl
brew install vim --with-lua --with-override-system-vi
brew install neovim
brew install kubernetes-cli kubectx stern
brew install tmux tmux-mem-cpu-load tmux-xpanes reattach-to-user-namespace
brew install aria2 lnav pngcrush poppler peco diff-so-fancy
brew install fd bat shellcheck ctop httpie
brew install aspell --with-lang-he --without-lang-de --without-lang-es --without-lang-fr

brew install rafi/tap/gits rafi/tap/reg rafi/tap/yaml2json
```

---

## Use Homebrew to Install macOS Apps

Some of these are PAID apps!

```bash
brew cask install transmission mpv bartender beyond-compare \
  clipy contexts dash docker iterm2 karabiner-elements \
  keycastr licecap marked slack spotify telegram typora whatsapp
```

---

# Install Node Tools

```bash
npm -g install reveal-md mad tern write-good
npm -g install jsonlint markdownlint-cli
npm -g install resume-cli imagemin-cli
```

```bash
npm -g ls --depth=0
```

---
## Let's Fix Something

What's the most annoying thing when using many terminal windows/tabs?

![Many terminals](./img/terminals.png)

---

## Shell History

Remember '`shopt -s histappend`' from our `~/.bashrc` ?

This causes shell to append each session's history to $HISTFILE,
and not overwrite it.

Great!

But I want it now.™

---

## Use the PROMPT_COMMAND!

Preserve bash history in multiple terminal windows:

Insert lines in `~/.bashrc` **BEFORE** `$XDG_CONFIG_HOME/bash/utils` sourcing:

```bash
# Append to history and re-read new history lines immediately
PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
```

Want only to immediately append?

```bash
# Append to history immediately, but don't re-read history
PROMPT_COMMAND="history -a; ${PROMPT_COMMAND}"
```

Now open a few terminals, and test it!

---

![Great Success](./img/success.jpg)

---
## Let's Add Some Colors

Remember we've installed '`coreutils`'?

We've also aliased 'dircolors' to 'gdircolors'.

The program '`ls`' uses the environment variable `LS_COLORS` to determine the
colors in which the filenames are to be displayed.

---

## Find a Cool LS_COLORS Theme

[Find a cool theme](https://www.google.com/search?q=cool+LS_COLORS)
in the internet and move it to `~/.config/bash/dircolors`

```bash
curl -LO https://gist.github.com/clsn/1728412/raw/3f27dd4ece98f6ffa5ceba5bdcce536beba06b75/.dir_colors
mv .dir_colors ~/.config/bash/dircolors
```

---

## Apply LS_COLORS

Append to your `~/.bashrc`

```bash
# Load directory and file colors for GNU ls
eval "$(dircolors -b "$XDG_CONFIG_HOME/bash/dircolors")"
```

Open a new terminal and run:

```bash
ls -alp
```

You should see colorful filenames and directories.

---

## Pimp up `ls` Output

Use [`grc`](https://github.com/garabik/grc).

```bash
brew install grc
grc ls -alph
```

Use with netstat, ping, tail, ps, and more.

---
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
# SSH-Keys

You don't use passphrases for your keys?

With SSH keys, if someone gains access to your computer, they also gain access
to every system that uses that key. To add an extra layer of security, you can
add a passphrase to your SSH key. You can use ssh-agent to securely save your
passphrase so you don't have to reenter it.

---

## Use `ssh-agent` to Remember Your Passphrases

I don't use macOS keychain, I use a very popular one called [`keychain`](https://www.funtoo.org/Keychain).

```bash
brew info keychain
brew install keychain
```

Append to your `~/.bash_profile`

```bash
if hash keychain 2>/dev/null; then
  eval `keychain --eval --agents ssh --inherit any --quiet id_rsa`
fi
```

Read about '`--inherit any`' [here](https://www.funtoo.org/Keychain).

---

## `keychain`

Using the alternative [`keychain`](https://www.funtoo.org/Keychain), every
time you restart your computer, and open a new terminal, you will be asked
once for the passphrase of `id_rsa`.

---
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
## Other Great Tools

* [ranger](https://ranger.github.io)
* [entr](http://entrproject.org)
* [ttyd](https://github.com/tsl0922/ttyd)
* [pass](https://www.passwordstore.org) and [pineentry-mac](https://github.com/GPGTools/pinentry-mac)
* [fd](https://github.com/sharkdp/fd)
* [editorconfig](https://editorconfig.org)
* [rclone](https://rclone.org)
* [task](https://taskwarrior.org)
* [alacritty](https://github.com/jwilm/alacritty)
* [neovim](https://neovim.io)

---
