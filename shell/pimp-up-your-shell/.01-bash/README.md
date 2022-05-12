# Pimp Up Your Shell

{{ URL }}

A guide for boosting your macOS shell experience.

---

## How Do You Call Your Workstation?

Give your box a name please: (:warning: Change `rafi-mac` to something of yours)

```bash
hostname
export COMPUTER_NAME="rafi-mac"
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${COMPUTER_NAME}"
sudo scutil --set LocalHostName "${COMPUTER_NAME}"

sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${COMPUTER_NAME}"
```

You might need to reboot your laptop after this. :face_with_rolling_eyes:

Check-out https://mths.be/macos for awesome ways to configure your macOS.

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
