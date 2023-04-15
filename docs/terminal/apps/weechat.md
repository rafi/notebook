---
date: '2014-10-26'
tags:
- weechat
- guide
---
# WeeChat Guide

# Key Bindings
Default: http://weechat.org/files/doc/devel/weechat_user.en.html#key_bindings

Some useful default keys in WeeChat you might not know:
- <kbd>Ctrl+s</kbd>, Ctrl+u: Set unread marker on all buffers
- <kbd>Ctrl+p/n</kbd>: Scroll to previous/next highlight in buffer
- <kbd>Alt+u</kbd>: Scroll to first unread line in buffer
- <kbd>Alt+Home/End</kbd>: Scroll to top/bottom of buffer
- <kbd>Ctrl+r</kbd>: Search text in buffer (up/down for previous/next match, Enter to exit search)
- <kbd>Shift+Tab</kbd>: Partial completion (or previous completion for a completion in progress)
- <kbd>Alt+j</kbd>, <kbd>Alt+l</kbd>: Jump to last buffer
- <kbd>Ctrl+_</kbd>: Undo last action on command line
- <kbd>Alt+_</kbd>: Redo last action on command line
- <kbd>Ctrl+Up/Down</kbd>: Previous/next command in global history
- <kbd>Alt+k</kbd>: Find a key code (For usage with /key bind)

# Nick Colors
When you change your nick colors (option `weechat.color.chat_nick_colors`),
you may want to see how it looks like. Easy! Open color buffer (/color) then
type <kbd>e</kbd>+<kbd>Return</kbd>. This will show extra info, like nick colors.

# Hotlist Levels
Script: [`buffer_autoset.py`]
Set maximum hotlist level for some nicks, per buffer or per group of buffers.
A new buffer property `hotlist_max_level_nicks`, can be set easily with the
script, see `/help autosetbuffer` for all the details and examples.

Possible levels are (default is -1):
- `-1`: No hotlist changes for nick
- ` 0`: Low priority (like join/part messages)
- ` 1`: Message
- ` 2`: Private
- ` 3`: Highlight (Useless, as it's the normal behavior)

Usage:
```
/autosetbuffer add irc.freenode.##nyutest hotlist_max_level_nicks_add tester:2
```

If you have already opened buffer, then script option will not apply
immediately to buffers. Then you can use /buffer command to manually set this
property on a buffer, for example to disable highlights from certain bots
on current buffer:
```
/buffer set hotlist_max_level_nicks_add Sentry:-1,GitHub:-1,JIRA:-1,Jenkins:-1,gitter:-1,Staging:-1,Production:-1
```

[buffer_autoset.py]: http://www.weechat.org/scripts/source/stable/buffer_autoset.py

# Need to remap
Alt+U   /window scroll_unread
Alt+Home/End  /window scroll_top  window scroll_bottom
Alt+J, Alt+L
Alt+K  /input grab_key_command
Alt+R  /input delete_line
Alt+S  /mute aspell toggle
Cltr+l /window refresh
F7/F8  /window -1   /window +1
Alt+a  /input jump_smart
Alt+h  /input hotlist_clear
alt+n,p  /window scroll_next_highlight  /window scroll_previous_highlight
Alt+/   Switch to last buffer displayed (before last jump to a buffer)   /input jump_last_buffer_displayed
Alt+=  Toggle filters on/off                   /filter toggle
Alt+-  Toggle filters on/off in current buffer /filter toggle @
