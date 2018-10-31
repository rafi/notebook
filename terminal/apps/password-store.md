---
title: password-store
date: '2015-01-19'
description:
categories:
- secret
tags:
- password
- security
---

Store encrypted passwords using a GPG key. Supports the regular CRUD,
tree list, and optionally wraps around git for automatic commits and
human-readable history diff.

- Site: http://www.passwordstore.org/
- Man page: http://git.zx2c4.com/password-store/about/

Integration
---
Official integration offers:
[GUI client], an [Android app], an [iOS app], a [Firefox plugin],
a [dmenu script], and even an [emacs package].

Migration
---
There are official [contrib/importers] for all sorts of programs you'd
be wanting to migrate from.

Secure Editing
---
When editing multi-line entries with your favorite editor, make sure it
doesn't write swap/undo/backup data for `pass` temp files.
Here's a [vim script] that does just that.

OSX Browser Workflow
---
We'll create a global keyboard shortcut to grab Google Chrome's current
tab URL and show `pass` information, without the password. The password
is copied to clipboard for 45 seconds.

Run Automator, and create a new **service**:

1. Add "Run AppleScript" with:

```applescript
    on run {input, parameters}
      tell application "Google Chrome"
        return URL of active tab of first window
      end tell
    end run
```

  Note: For other browsers, see this [get_url gist]
2. Add "Run Shell Script", select "Pass input [as arguments]", with:

```bash
    ~/.local/bin/urlpass "$@"
```

3. Save service.
4. Assign keyboard shortcut in _System Preferences / Keyboard / Shortcuts_.
5. Create `~/.local/bin/urlpass`:

```bash
  #!/usr/bin/env bash

  # Import the gpg-agent-info variable and export it
  eval $(cat "~/.gpg-agent-info" | cut -d: -f 1)
  export GPG_AGENT_INFO

  for f in "$@"
  do
    # Filter out domain without 'www.' from url
    host=$(echo "$f" | awk -F/ '{print $3}' | sed 's/^www.//')
    # Copy password to clipboard
    if pass -c "sites/$host" 1>/dev/null; then
      # Show notification with all other info except the 1st line
      data=$(pass "sites/$host" | sed '1d')
      terminal-notifier -message "${data:-N/A}" -title "$host"
    fi
  done
```

6. Set execute permissions: `chmod ug+x ~/.local/bin/urlpass`

[GUI client]: http://ijhack.github.io/qtpass/
[Android app]: https://github.com/zeapo/Android-Password-Store
[iOS app]: https://github.com/rephorm/pass-ios#readme
[Firefox plugin]: https://github.com/jvenant/passff#readme
[dmenu script]: http://git.zx2c4.com/password-store/tree/contrib/dmenu
[emacs package]: http://git.zx2c4.com/password-store/tree/contrib/emacs
[get_url gist]: https://gist.github.com/vitorgalvao/5392178
[contrib/importers]: http://git.zx2c4.com/password-store/tree/contrib/importers
[vim script]: http://git.zx2c4.com/password-store/tree/contrib/vim
