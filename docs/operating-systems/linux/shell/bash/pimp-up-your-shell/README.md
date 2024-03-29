---
title: Pimp Up Your Shell
date: 2018-12-23
category: bash
search:
  keywords: [shell, terminal, bash, linux]
---

# Pimp Up Your Shell

A guide for boosting your macOS shell experience.

---

## How Do You Call Your Workstation?

Give your box a name please: (⚠️ Change `rafi-mac` )

```bash
hostname
export COMPUTER_NAME="rafi-mac"
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${COMPUTER_NAME}"
sudo scutil --set LocalHostName "${COMPUTER_NAME}"

sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${COMPUTER_NAME}"
```

You might need to reboot your laptop after this. 🙄

Check-out https://mths.be/macos for awesome ways to configure your macOS.

---

## Most Frequently Used Shells

1. **Bash** — (Bourne Again Shell) Default on many Linux distros.
2. **Tcsh** — Enhanced C shell.
3. **Ksh** — Korn shell.
4. **Zsh** — Incorporates many features of other Unix/GNU Linux shells.
5. **Fish** — Friendly interactive shell.

---

## Apple default shell is ZSH

Since around 2020, apple has switched to ZSH.

Continue with this tutorial **only** if you want to switch to Bash!

---

## Apple Packs Outdated Software

```bash
$ echo $BASH_VERSION
3.2.57(1)-release

$ git version
git version 2.17.1
```

On July 27, 2004, Chet Ramey released version 3 of Bash.
It's really old.

---

# Let's Install The Newest Bash!

Make sure first you uninstall a conflicting package,
if you have it installed.

```bash
brew uninstall --force bash-completion
brew install readline bash bash-completion@2
```

---

## Set New Bash As Default Shell

```bash
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash
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
/opt/homebrew/bin/gsort --help
/usr/bin/sort --help
```

Note the difference.

---

# Init Scripts

Remember `autoexec.bat` and `config.sys` ?

```dosbatch
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

### Bash Invocation

Bash behaviour can be altered depending on how it is invoked. If Bash is
spawned by login in a TTY, an SSH daemon, or similar, it is considered
a **login shell**. This mode can also be engaged using the `-l`/`--login`
option. Bash is considered an **interactive shell** when its standard input
and error are connected to a terminal, and it is not started with `-c` option.

All interactive shells source `~/.bashrc`, while interactive _login_ shells
also source `~/.bash_profile`. Your terminal emulator might be using
a _login_ shell via `-l`.

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

mkdir -p ~/.local/{share,state,bin} ~/.cache
```

In your new `~/.config/bash/exports` append:

```bash
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export  XDG_CACHE_HOME="$HOME/.cache"
export   XDG_DATA_HOME="$HOME/.local/share"
export  XDG_STATE_HOME="$HOME/.local/state"
```

(Change `en_US.UTF-8` to something else if needed)

---

## Let's Source 'em!

In your new `~/.bash_profile`:

```bash
source "$HOME/.config/bash/exports"
source "$XDG_CONFIG_HOME/bash/bashrc"
```

And in your new `~/.bashrc`:

```bash
# Abort if not running interactively
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

```readline
$include /etc/inputrc

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
# Local bin first, then PATH, and lastly the relative bin/ directory.
export PATH="$HOME/.local/bin:$PATH:bin"

export INPUTRC="$XDG_CONFIG_HOME/bash/inputrc"

export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"

export HOMEBREW_GITHUB_API_TOKEN=""       # Your token here

# Misc defaults
export LESS="-FiQMXR"
export LESSCHARSET="UTF-8"
```

ℹ️ Generate new token for Homebrew at https://github.com/settings/tokens

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
alias llh='ls -alFh'
alias lld='ls -Gal --color=always | grep ^d --colour=never'
unset LS
```

---

## Use GNU Tools

Remember we installed `coreutils`?

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

# Use Neovim
if hash nvim 2>/dev/null; then
  alias vim=nvim
  alias suvim='sudo -E nvim'
else
  alias suvim='sudo -E vim'
fi
alias v='vim $(fzf)'

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
alias cdf='cd "$(dirname "$(fzf)")"'
alias cdd='cd "$(fd --type d | fzf)"'
alias c=clear
alias diff=colordiff

# Storage
alias dut='du -hsx * | sort -rh | head -10'
alias dfu="df -hT -x devtmpfs -x tmpfs"

# Processes
alias process='ps -ax'
alias psk='ps -ax | fzf | cut -d " " -f1 | xargs -o kill'
alias pst='pstree -g 3 -ws'

# Misc
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
alias gap='git add -p'
alias gai='git add -i'
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
shopt -s cmdhist        # Save multi-line commands in history as single line
shopt -s dotglob        # Include dotfiles in pathname expansion
shopt -s expand_aliases # Expand aliases
shopt -s extglob        # Enable extended pattern-matching features
shopt -s histreedit     # Add failed commands to the bash history
shopt -s histappend     # Append each session's history to $HISTFILE
shopt -s histverify     # Edit a recalled history line before executing

if [[ $DISPLAY ]]; then
  shopt -s checkwinsize  # Update LINES and COLUMNS after each command
fi

export HISTFILE="$XDG_CACHE_HOME/bash_history"
export HISTSIZE=5000
export HISTFILESIZE=1500000
export HISTTIMEFORMAT='[%F %T] '
export HISTIGNORE='pwd:jobs:ll:ls:l:fg:history:clear:exit'
export HISTCONTROL=ignoreboth
export VISUAL=vim
export EDITOR="$VISUAL"
export PAGER=less
```

---

## Completions!!!!!!

Append in your `~/.config/bash/completion`

```bash
# Load all completions Homebrew's bash-completion@2 has prepared
if [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
  . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
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

# More Bash Trickery

Check-out my [Bash config](https://github.com/rafi/.config/tree/master/bash)

in my [github.com/rafi/.config](https://github.com/rafi/.config) repository.

---

# Know Your OS Package-Manager

Hello, my name is Homebrew

```bash
brew --version
```

Please upgrade me from time to time...

```bash
brew update
brew outdated
brew upgrade
```

---

## Install Everyone's Favorite Tools

Don't blindly install all these tools, pick & choose!

```bash
brew install bat colordiff coreutils curl diff-so-fancy fd gnutls findutils \
  lf fzf git gnupg gnu-sed gnu-tar grep htop jq kubernetes-cli kubectx less \
  moreutils neovim nmap tree pidof pinfo pstree pyenv pyenv-virtualenv \
  ripgrep rsync shellcheck socat stern tcpdump \
  telnet unrar unzip watch wget

brew install go node yarn python pipenv
brew install git diff-so-fancy
brew install neovim
brew install kubernetes-cli kubectx stern crane
brew install tmux tmux-mem-cpu-load tmux-xpanes reattach-to-user-namespace
brew install fd ripgrep bat shellcheck

brew install rafi/tap/gits
```

---

## Use Homebrew to Install macOS Apps

Some of these are PAID apps!

```sh
brew install --cask transmission mpv dozer beyond-compare \
  clipy docker iterm2 karabiner-elements \
  keycastr kitty licecap marked meetingbar \
  slack spotify telegram whatsapp
```

---

# Install Node Tools

```bash
yarn global add reveal-md
```

```bash
yarn global list
```

---

## Let's Fix Something

What's the most annoying thing when using many terminal windows/tabs?

![Many terminals](./img/terminals.png)

---

## Shell History

Remember `shopt -s histappend` from our `~/.bashrc` ?

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

Remember we've installed `coreutils`?

We've also aliased 'dircolors' to 'gdircolors'.

The program `ls` uses the environment variable `LS_COLORS` to determine the
colors in which the filenames are to be displayed.

---

## Find a Cool LS_COLORS Theme

[Find a cool theme](https://www.google.com/search?q=cool+LS_COLORS)
on the internet and move it to `~/.config/bash/dircolors`

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

Let's improve our speed of `cd` by a bazillion!

---

## Introducing… `zoxide`

After a short learning phase, zoxide will take you to the most 'frecent'
directory that matches ALL the regexes given on the command line, in
order.

```bash
brew info zoxide
brew install zoxide
```

Append to `~/.config/bash/utils`

```bash
# Must be loaded _after_ setting PROMPT_COMMAND
# See https://github.com/ajeetdsouza/zoxide
if command -v zoxide 1>/dev/null 2>&1; then
  export _ZO_ECHO=1
  eval "$(zoxide init bash)"
fi
```

---

# Train `zoxide`

`zoxide` has to be trained. `cd` into your favorite directories.

```bash
cd ~/code/work/ansible
cd ~/code/dev/myproject
cd ~/.config
cd ~/.vim
```

Check `zoxide`'s listing:

```bash
$ zoxide query -sl
112.274    /Users/rafi/code/tikal/dartagnan-infra
148.375    /Users/rafi/code/dev/acme/docker-k8s-101
275.512    /Users/rafi/code/dev/acme
311.72     /Users/rafi/code/acme/pimpupyourshell
663.29     /Users/rafi/code/work/foo/autobots
21717.8    /Users/rafi/code/work/foo/autobots-k8s-onprem
```

---

# Use `zoxide`

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

# SSH-Keys

You don't use passphrases for your keys?

With SSH keys, if someone gains access to your computer, they also gain access
to every system that uses that key. To add an extra layer of security, you can
add a passphrase to your SSH key. You can use ssh-agent to securely save your
passphrase, so you don't have to reenter it.

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

Read about `--inherit any` [here](https://www.funtoo.org/Keychain).

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

## Git has its own Aliases

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

### Better Git Diffs

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

* [kitty](https://github.com/kovidgoyal/kitty)
* [neovim](https://neovim.io)
* [lf](https://github.com/gokcehan/lf)
* [fd](https://github.com/sharkdp/fd)
* [ttyd](https://github.com/tsl0922/ttyd)
* [pass](https://www.passwordstore.org) and [pineentry-mac](https://github.com/GPGTools/pinentry-mac)
* [entr](http://entrproject.org)
* [editorconfig](https://editorconfig.org)
* [rclone](https://rclone.org)
* [task](https://taskwarrior.org)

---

Thank you.

Rafael Bodill

![Bob](./img/bob.png)

justRafi at da g mail dot com
