---
title: "org.calendar"
description: "Calendar application with Google Calendar/Tasks sync (calendar.vim)"
published: true
generated: true
kind: "extra"
category: "org"
---

Calendar application with Google Calendar/Tasks sync (calendar.vim)

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["org.calendar"] }
```

## Plugins

- [calendar.vim](https://github.com/itchyny/calendar.vim)

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/org/calendar.lua"
-- Calendar application with Google Calendar/Tasks sync (calendar.vim)

vim.g.calendar_google_calendar = 1
vim.g.calendar_google_task = 1
vim.g.calendar_cache_directory = vim.fn.stdpath('state') .. '/calendar'

-- Stub until the plugin's own plugin/calendar.vim redefines it.
require('rafi.pack').command('Calendar', function()
	vim.pack.add({ 'https://github.com/itchyny/calendar.vim' })
end)
```

</details>
