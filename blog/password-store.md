---
title: Free and wonderful password management
path: free-password-management
date: '2017-12-25'
featured: true
description:
categories:
- apps
search:
  keywords: ['osx', 'apps', 'macos']
---
# Free and wonderful password management

I’ve started using the Internet back in ’96 and I have accumulated several
hundreds of password credentials for different sites. This entails my long
journey to integrate a comfortable workflow for managing credentials in my
day-to-day work, and pleasure.

## Other Password Managers

In-fact, I started using password managers way back when I was still stuck with
Windows and [Roboform](https://www.roboform.com/) in the early ’00s. When
transitioning to Linux and macOS, Roboform didn’t support these platforms back
then. And besides, it was becoming too corporate.

Cloud-based managers were out of the question, so I started testing
[1Password](https://1password.com/). With a slick design and comfortable
extensions for popular browsers — it was a nice experience, but 1Password
started becoming an expensive solution.

I dabbled with KeePass and KeePassX for a while until I gave up, browser
integration was far from perfect.

*****

## The Beauty of Password-Store

I then found [password-store](https://www.passwordstore.org/), the standard unix
password manager. Immediately, I fell in-love:

> Password management should be simple and follow [Unix
> philosophy](http://en.wikipedia.org/wiki/Unix_philosophy).

Pass (in short) stores passwords in
[gpg](http://en.wikipedia.org/wiki/GNU_Privacy_Guard) encrypt files whose
filename is the title of the website or resource that requires the password.
Using other Unix commands like tree, git, etc. pass provides an extremely easy &
secure workflow with passwords, and optionally wraps around git for automatic
commits and human-readable history diff. And it’s open-source.

* Site: [http://www.passwordstore.org/](http://www.passwordstore.org/)
* Man page:
[http://git.zx2c4.com/password-store/about/](http://git.zx2c4.com/password-store/about/)

### Tips

* [Official integrations](https://www.passwordstore.org/#migration) offer many
colorful clients, even for mobile.
* There are official [contrib
importers](http://git.zx2c4.com/password-store/tree/contrib/importers) for all
sorts of programs you’d<br> be wanting to migrate from.
* For the sticklers: When editing multi-line entries with your favorite editor,
make sure it doesn’t write swap/undo/backup data for `pass` temp files. Here’s a
[vim
script](https://git.zx2c4.com/password-store/tree/contrib/vim/noplaintext.vim)
that does just that.

### Getting Started With Password-Store

#### Setup GPG

1.  Download [gnupg.org](https://www.gnupg.org/download/) or
[gpgtools.org](https://gpgtools.org/).
1.  Depending which suite you download, you’ll need to generate a new key pair.
1.  I recommend to increase the key size to the maximum of 4096.
1.  Enter your real Email
1.  Use a secure passphrase

Use the graphical interface of [gnupg](https://www.gnupg.org/download/) or
[gpgtools](https://gpgtools.org/), **or** the command-line:

    gpg --gen-key
    gpg --list-secret-keys --keyid-format LONG

You can now copy the GPG key ID you’d like to use from the list, and for example
print the GPG key ID, in ASCII armor format:

    gpg --armor --export 

#### Setup Password-Store

Make sure to install `git` and `tree` if you don’t have them already. And,
depending on your operating-system, choose the **one** for you:

```sh
brew install pass      # Mac OSX with Homebrew
port install pass      # Mac OSX with Macports
apt-get install pass   # Linux with Ubuntu
pacman -S pass         # Linux with Archlinux
yum install pass       # Linux with CentOS/RedHat
```

#### Managing Passwords with Password-Store

`pass` is the only command you’ll need. You can `insert`, `edit`, `grep`, `mv`
and so much more. Here are a few examples:

```sh
pass insert joe/gmail.com    # Create a directory nested password
pass insert -m wallet/visa   # Create a multiline password
pass edit joe/gmail.com
pass grep gmail
pass find visa

# Show all password list:
pass

# Show password contents:
pass joe/gmail.com
```

Don’t forget to integrate and use `pass`'s bash/zsh completion support.

#### Password-Store Browser Integration

*password-store* has many [Client
integrations](https://www.passwordstore.org/#other), and even
[extensions](https://www.passwordstore.org/#extensions). The best browser
integration I found is
[browserpass](https://github.com/dannyvankooten/browserpass). You will need to
first install its package client, and then the Chrome or Firefox extension.

![](https://cdn-images-1.medium.com/max/1600/1*zC82z0wvVfJmP_sd1qOPQQ.png)
<span class="figcaption_hack">*browserpass* is smart enough to find multiple matches for current site.</span>

I bind `Alt`+ `k` to *browserpass*, so I can quickly search, filter, and apply
credentials to a form, and auto-submit.

![](https://cdn-images-1.medium.com/max/1600/1*T0Lax9n_zcdpiN5-Y4pnJQ.png)

#### Other Integrations

There are many clients for different devices out there.
[Here](https://www.passwordstore.org/#other) are a few.

#### Android App

“[Android Password Store](https://github.com/zeapo/Android-Password-Store)” is
amazing. It allows management of passwords and auto-typing into forms in my
mobile Chrome, what a pleasure!

![](https://cdn-images-1.medium.com/max/1600/1*qslarC0CPAz3l8BLLIFSuQ.png)
<span class="figcaption_hack">Android Password Store in action.</span>

#### iOS App

I don’t own an iOS, but [passforios](https://mssun.github.io/passforios/) looks
nice.

#### Pass Window (Mac) Integration

What about other windows? Browsers aren’t the only applications that require
passwords from the user at times.

We’ll create a global keyboard shortcut to grab current window’s *title* and
show pass entry information, without the password. The password is copied to
clipboard for 45 seconds.

Run Automator, and create a new **service**:

* Add “Run AppleScript” with:

```applescript
on run {input, parameters}

    global frontApp, frontAppName, windowTitle

    set windowTitle to ""
    tell application "System Events"
    set frontApp to first application process whose frontmost is true
    set frontAppName to name of frontApp
    tell process frontAppName
    tell (1st window whose value of attribute "AXMain" is true)
    set windowTitle to value of attribute "AXTitle"
    end tell
    end tell
    end tell

    return frontAppName
end run
```

* Add “Run Shell Script”, select “Pass input [as arguments]”, with:

    ~/.local/bin/urlpass “$@”

* Save service.
* Assign keyboard shortcut in *System Preferences* / *Keyboard* / *Shortcuts*.
* Create `~/.local/bin/urlpass`:

```sh
#!/usr/bin/env bash
# Import the gpg-agent-info variable and export it
eval $(cat "~/.gpg-agent-info" | cut -d: -f 1)
export GPG_AGENT_INFO
for app in "$@"
do
    # Copy password to clipboard
    if pass -c "apps/$app" 1>/dev/null; then
    # Show notification with all other info except the 1st line
    data=$(pass "apps/$app" | sed '1d')
    terminal-notifier -message "${data:-N/A}" -title "$app"
    fi
done
```

* Set execute permissions: `chmod ug+x ~/.local/bin/urlpass`

Try it out by saving a password called `apps/somename` and click your shortcut
once focused on the app. You’ll now find the password copied to your clipboard.

#### Closing Notes

password-store allows true control of your passwords in an extensible, open way.
Great amount of clients for different devices, start using `pass` today!
