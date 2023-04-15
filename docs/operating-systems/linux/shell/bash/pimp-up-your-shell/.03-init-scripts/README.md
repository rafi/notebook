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

mkdir -p ~/.local/{share,bin} ~/.cache
```

In your new `~/.config/bash/exports` append:

```bash
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export  XDG_CACHE_HOME="$HOME/.cache"
export   XDG_DATA_HOME="$HOME/.local/share"
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

```
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

# Python per user site-packages directory
export PATH="$PATH:$HOME/Library/Python/3.7/bin"
export PATH="$PATH:$HOME/Library/Python/2.7/bin"

export INPUTRC="$XDG_CONFIG_HOME/bash/inputrc"

export HOMEBREW_GITHUB_API_TOKEN=""       # Your token here

# Misc defaults
export LESS="-FiQMXR"
export LESSCHARSET="UTF-8"
```

:information_source: Generate new token for Homebrew at https://github.com/settings/tokens

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
alias dps='docker ps --format "table {{.Names}}\\t{{.Image}}\\t{{.Status}}\\t{{ .Ports }}\\t{{.RunningFor}}\\t{{.Command}}\\t{{ .ID }}" | cut -c-$(tput cols)'
alias dls='docker ps -a --format "table {{.Names}}\\t{{.Image}}\\t{{.Status}}\\t{{ .Ports }}\\t{{.RunningFor}}\\t{{.Command}}\\t{{ .ID }}" | cut -c-$(tput cols)'
alias dim='docker images --format "table {{.Repository}}\\t{{.Tag}}\\t{{.ID}}\\t{{.Size}}\\t{{.CreatedSince}}"'
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
if [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
	. "/usr/local/etc/profile.d/bash_completion.sh"
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
