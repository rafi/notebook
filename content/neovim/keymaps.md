---
title: "Keymaps"
description: "Keymaps vim-config sets, without any extras"
published: true
generated: true
---

These are set by `lua/rafi/config/keymaps.lua` on every install. Extras add their own: see each extra's page. Your `lua/config/keymaps.lua` loads after this file, so it can change or delete any of them.

| Key | Description | Mode |
| --- | --- | --- |
| <kbd>j</kbd> | Down | 𝐍 𝐗 |
| <kbd>Down</kbd> | Down | 𝐍 𝐗 |
| <kbd>k</kbd> | Up | 𝐍 𝐗 |
| <kbd>Up</kbd> | Up | 𝐍 𝐗 |
| <kbd>C-h</kbd> | Go to Left Window | 𝐍 |
| <kbd>C-j</kbd> | Go to Lower Window | 𝐍 |
| <kbd>C-k</kbd> | Go to Upper Window | 𝐍 |
| <kbd>C-l</kbd> | Go to Right Window | 𝐍 |
| <kbd>C-Up</kbd> | Increase Window Height | 𝐍 |
| <kbd>C-Down</kbd> | Decrease Window Height | 𝐍 |
| <kbd>C-Left</kbd> | Decrease Window Width | 𝐍 |
| <kbd>C-Right</kbd> | Increase Window Width | 𝐍 |
| <kbd>A-j</kbd> | Next Tab | 𝐍 |
| <kbd>A-k</kbd> | Previous Tab | 𝐍 |
| <kbd>A-j</kbd> | Move Down | 𝐈 𝐕 |
| <kbd>A-k</kbd> | Move Up | 𝐈 𝐕 |
| <kbd>[</kbd><kbd>b</kbd> | Prev Buffer | 𝐍 |
| <kbd>]</kbd><kbd>b</kbd> | Next Buffer | 𝐍 |
| <kbd>leader</kbd><kbd>b</kbd><kbd>b</kbd> | Switch to Other Buffer | 𝐍 |
| <kbd>leader</kbd><kbd>&#96;</kbd> | Switch to Other Buffer | 𝐍 |
| <kbd>leader</kbd><kbd>b</kbd><kbd>d</kbd> | Delete Buffer | 𝐍 |
| <kbd>leader</kbd><kbd>b</kbd><kbd>o</kbd> | Delete Other Buffers | 𝐍 |
| <kbd>leader</kbd><kbd>b</kbd><kbd>i</kbd> | Delete Invisible Buffers | 𝐍 |
| <kbd>leader</kbd><kbd>b</kbd><kbd>D</kbd> | Delete Buffer and Window | 𝐍 |
| <kbd>esc</kbd> | Escape and Clear hlsearch | 𝐈 𝐍 𝐒 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>r</kbd> | Redraw / Clear hlsearch / Diff Update | 𝐍 |
| <kbd>n</kbd> | Next Search Result | 𝐍 𝐎 𝐗 |
| <kbd>N</kbd> | Prev Search Result | 𝐍 𝐎 𝐗 |
| <kbd>C-s</kbd> | Save File | 𝐈 𝐍 𝐒 𝐗 |
| <kbd>leader</kbd><kbd>K</kbd> | Keywordprg | 𝐍 |
| <kbd>g</kbd><kbd>c</kbd><kbd>o</kbd> | Add Comment Below | 𝐍 |
| <kbd>g</kbd><kbd>c</kbd><kbd>O</kbd> | Add Comment Above | 𝐍 |
| <kbd>leader</kbd><kbd>f</kbd><kbd>n</kbd> | New File | 𝐍 |
| <kbd>leader</kbd><kbd>x</kbd><kbd>l</kbd> | Location List | 𝐍 |
| <kbd>leader</kbd><kbd>x</kbd><kbd>q</kbd> | Quickfix List | 𝐍 |
| <kbd>[</kbd><kbd>q</kbd> | Previous Quickfix | 𝐍 |
| <kbd>]</kbd><kbd>q</kbd> | Next Quickfix | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>d</kbd> | Line Diagnostics | 𝐍 |
| <kbd>]</kbd><kbd>d</kbd> | Next Diagnostic | 𝐍 |
| <kbd>[</kbd><kbd>d</kbd> | Prev Diagnostic | 𝐍 |
| <kbd>]</kbd><kbd>e</kbd> | Next Error | 𝐍 |
| <kbd>[</kbd><kbd>e</kbd> | Prev Error | 𝐍 |
| <kbd>]</kbd><kbd>w</kbd> | Next Warning | 𝐍 |
| <kbd>[</kbd><kbd>w</kbd> | Prev Warning | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>s</kbd> | Toggle Spelling | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>w</kbd> | Toggle Wrap | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>L</kbd> | Toggle Relative Number | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>d</kbd> | Toggle Diagnostics | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>l</kbd> | Toggle Line number | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>c</kbd> | Toggle Conceal Level | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>A</kbd> | Toggle Tabline | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>T</kbd> | Toggle Treesitter | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>b</kbd> | Toggle Dark Background | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>D</kbd> | Toggle Dim | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>a</kbd> | Toggle Animate | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>g</kbd> | Toggle Indent | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>S</kbd> | Toggle Scroll | 𝐍 |
| <kbd>leader</kbd><kbd>d</kbd><kbd>p</kbd><kbd>p</kbd> | Toggle Profiler | 𝐍 |
| <kbd>leader</kbd><kbd>d</kbd><kbd>p</kbd><kbd>h</kbd> | Toggle Profiler highlights | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>h</kbd> | Toggle Inlay hints | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>L</kbd> | Git Log (cwd) | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>b</kbd> | Git Blame Line | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>f</kbd> | Git Current File History | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>l</kbd> | Git Log | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>B</kbd> | Git Browse (open) | 𝐍 𝐗 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>Y</kbd> | Git Browse (copy) | 𝐍 𝐗 |
| <kbd>leader</kbd><kbd>q</kbd><kbd>q</kbd> | Quit All | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>i</kbd> | Inspect Pos | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>I</kbd> | Inspect Tree | 𝐍 |
| <kbd>leader</kbd><kbd>f</kbd><kbd>T</kbd> | Terminal (cwd) | 𝐍 |
| <kbd>leader</kbd><kbd>f</kbd><kbd>t</kbd> | Terminal (Root Dir) | 𝐍 |
| <kbd>c-/</kbd> | Terminal (Root Dir) | 𝐍 𝐓 |
| <kbd>c-_</kbd> | which_key_ignore | 𝐍 𝐓 |
| <kbd>leader</kbd><kbd>-</kbd> | Split Window Below | 𝐍 |
| <kbd>leader</kbd><kbd>&#124;</kbd> | Split Window Right | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>Z</kbd> | Toggle Zoom | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>z</kbd> | Toggle Zen | 𝐍 |
| <kbd>leader</kbd><kbd>tab</kbd><kbd>l</kbd> | Last Tab | 𝐍 |
| <kbd>leader</kbd><kbd>tab</kbd><kbd>o</kbd> | Close Other Tabs | 𝐍 |
| <kbd>leader</kbd><kbd>tab</kbd><kbd>f</kbd> | First Tab | 𝐍 |
| <kbd>leader</kbd><kbd>tab</kbd><kbd>tab</kbd> | New Tab | 𝐍 |
| <kbd>leader</kbd><kbd>tab</kbd><kbd>]</kbd> | Next Tab | 𝐍 |
| <kbd>leader</kbd><kbd>tab</kbd><kbd>d</kbd> | Close Tab | 𝐍 |
| <kbd>leader</kbd><kbd>tab</kbd><kbd>[</kbd> | Previous Tab | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>u</kbd> | Run Lua _(in lua buffers)_ | 𝐍 𝐗 |
| <kbd>localleader</kbd><kbd>f</kbd> | Find Files (Root Dir) | 𝐍 |
| <kbd>localleader</kbd><kbd>F</kbd> | Find Files (cwd) | 𝐍 |
| <kbd>localleader</kbd><kbd>g</kbd> | Grep (Root Dir) | 𝐍 |
| <kbd>localleader</kbd><kbd>G</kbd> | Grep (cwd) | 𝐍 |
| <kbd>localleader</kbd><kbd>b</kbd> | Switch Buffer | 𝐍 |
| <kbd>localleader</kbd><kbd>B</kbd> | Grep open buffers | 𝐍 |
| <kbd>localleader</kbd><kbd>l</kbd> | Buffer lines | 𝐍 |
| <kbd>localleader</kbd><kbd>h</kbd> | Help Pages | 𝐍 |
| <kbd>localleader</kbd><kbd>i</kbd> | Icons | 𝐍 |
| <kbd>localleader</kbd><kbd>H</kbd> | Search Highlight Groups | 𝐍 |
| <kbd>localleader</kbd><kbd>j</kbd> | Jumplist | 𝐍 |
| <kbd>localleader</kbd><kbd>m</kbd> | Jump to Mark | 𝐍 |
| <kbd>localleader</kbd><kbd>M</kbd> | Man Pages | 𝐍 |
| <kbd>localleader</kbd><kbd>n</kbd> | Notification History | 𝐍 |
| <kbd>localleader</kbd><kbd>o</kbd> | Options | 𝐍 |
| <kbd>localleader</kbd><kbd>t</kbd> | Goto Symbol | 𝐍 |
| <kbd>localleader</kbd><kbd>T</kbd> | Goto Symbol (Workspace) | 𝐍 |
| <kbd>localleader</kbd><kbd>v</kbd> | Registers | 𝐍 |
| <kbd>localleader</kbd><kbd>x</kbd> | Recent | 𝐍 |
| <kbd>localleader</kbd><kbd>X</kbd> | Recent (cwd) | 𝐍 |
| <kbd>localleader</kbd><kbd>;</kbd> | Command History | 𝐍 |
| <kbd>localleader</kbd><kbd>:</kbd> | Commands | 𝐍 |
| <kbd>localleader</kbd><kbd>/</kbd> | Search History | 𝐍 |
| <kbd>localleader</kbd><kbd>.</kbd> | Search for Plugin Spec | 𝐍 |
| <kbd>localleader</kbd><kbd>p</kbd> | Projects | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>g</kbd> | Visual selection or word (Root Dir) | 𝐍 𝐗 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>G</kbd> | Visual selection or word (cwd) | 𝐍 𝐗 |
| <kbd>g</kbd><kbd>h</kbd> | Jump to first screen character | 𝐍 |
| <kbd>g</kbd><kbd>l</kbd> | Jump to last screen character | 𝐍 |
| <kbd>CR</kbd> | Toggle Fold | 𝐍 |
| <kbd>S-Return</kbd> | Focus Fold | 𝐍 |
| <kbd>A-[</kbd> | Previous Tab | 𝐍 |
| <kbd>A-]</kbd> | Next Tab | 𝐍 |
| <kbd>C-Tab</kbd> | Next Tab | 𝐍 |
| <kbd>C-S-Tab</kbd> | Previous Tab | 𝐍 |
| <kbd>A-&#123;</kbd> | Tab Move Backwards | 𝐍 |
| <kbd>A-&#125;</kbd> | Tab Move Forwards | 𝐍 |
| <kbd>Leader</kbd><kbd>Leader</kbd> | Visual Mode | 𝐍 |
| <kbd>Leader</kbd><kbd>Leader</kbd> | Exit Visual Mode | 𝐗 |
| <kbd>v</kbd><kbd>s</kbd><kbd>p</kbd> | Select Paste | 𝐍 |
| <kbd>s</kbd><kbd>g</kbd> | Substitute Within Selection | 𝐗 |
| <kbd>C-r</kbd> | Replace Selection | 𝐗 |
| <kbd>Tab</kbd> | Indent Left | 𝐗 |
| <kbd>S-Tab</kbd> | Indent Right | 𝐗 |
| <kbd>I</kbd> | Blockwise Insert | 𝐗 |
| <kbd>g</kbd><kbd>I</kbd> | Blockwise Insert | 𝐗 |
| <kbd>A</kbd> | Blockwise Append | 𝐗 |
| <kbd>]</kbd><kbd>a</kbd> | Next Loclist | 𝐍 |
| <kbd>[</kbd><kbd>a</kbd> | Previous Loclist | 𝐍 |
| <kbd>]</kbd><kbd>z</kbd> | Next Whitespace | 𝐍 |
| <kbd>[</kbd><kbd>z</kbd> | Previous Whitespace | 𝐍 |
| <kbd>p</kbd> | Paste | 𝐗 |
| <kbd>Leader</kbd><kbd>y</kbd> | Yank relative path | 𝐍 |
| <kbd>Leader</kbd><kbd>Y</kbd> | Yank absolute path | 𝐍 |
| <kbd>Leader</kbd><kbd>v</kbd> | Comment Line | 𝐍 |
| <kbd>Leader</kbd><kbd>v</kbd> | Comment Selection | 𝐗 |
| <kbd>C-q</kbd> | Macro Prefix | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>i</kbd><kbd>d</kbd> | Dev | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>f</kbd> | Format | 𝐍 𝐗 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>i</kbd><kbd>f</kbd> | Formatter Info | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>f</kbd> | Toggle Auto Format (Global) | 𝐍 |
| <kbd>leader</kbd><kbd>u</kbd><kbd>F</kbd> | Toggle Auto Format (Buffer) | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>i</kbd><kbd>r</kbd> | Root | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>i</kbd><kbd>l</kbd> | LSP Info | 𝐍 |
| <kbd>leader</kbd><kbd>c</kbd><kbd>s</kbd> | Formatter Select | 𝐍 𝐗 |
| <kbd>S-Return</kbd> | Start Newline | 𝐈 |
| <kbd>]</kbd><kbd>Leader</kbd> | Newline | 𝐍 |
| <kbd>[</kbd><kbd>Leader</kbd> | Newline | 𝐍 |
| <kbd>Leader</kbd><kbd>k</kbd> | Move line up | 𝐍 |
| <kbd>Leader</kbd><kbd>j</kbd> | Move line down | 𝐍 |
| <kbd>Leader</kbd><kbd>k</kbd> | Move selection up | 𝐗 |
| <kbd>Leader</kbd><kbd>j</kbd> | Move selection down | 𝐗 |
| <kbd>Leader</kbd><kbd>d</kbd><kbd>d</kbd> | Duplicate line | 𝐍 |
| <kbd>Leader</kbd><kbd>d</kbd><kbd>d</kbd> | Duplicate selection | 𝐗 |
| <kbd>C-c</kbd> | Change Inner Word | 𝐍 |
| <kbd>BS</kbd> | Jump to Paren | 𝐍 𝐗 |
| <kbd>Leader</kbd><kbd>b</kbd><kbd>f</kbd> | Diff Windows in Tab | 𝐍 |
| <kbd>Leader</kbd><kbd>b</kbd><kbd>F</kbd> | Diff withbcompare | 𝐍 |
| <kbd>g</kbd><kbd>!</kbd> | Paste Command | 𝐍 |
| <kbd>Leader</kbd><kbd>Tab</kbd><kbd>c</kbd> | Change Tab Directory | 𝐍 |
| <kbd>Leader</kbd><kbd>w</kbd> | Save File | 𝐍 |
| <kbd>M-s</kbd> | Save File | 𝐍 |
| <kbd>Leader</kbd><kbd>c</kbd><kbd>e</kbd> | Line Diagnostics | 𝐍 |
| <kbd>leader</kbd><kbd>m</kbd><kbd>x</kbd> | Open Plugin Extras | 𝐍 |
| <kbd>Leader</kbd><kbd>m</kbd><kbd>l</kbd> | Append Modeline | 𝐍 |
| <kbd>g</kbd><kbd>C-i</kbd> | Jump to newer buffer | 𝐍 |
| <kbd>g</kbd><kbd>C-o</kbd> | Jump to older buffer | 𝐍 |
| <kbd>LocalLeader</kbd><kbd>c</kbd> | Context-aware menu | 𝐍 |
| <kbd>leader</kbd><kbd>6</kbd><kbd>4</kbd><kbd>e</kbd> | Base64 Encode | 𝐗 |
| <kbd>leader</kbd><kbd>6</kbd><kbd>4</kbd><kbd>d</kbd> | Base64 Decode | 𝐗 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>t</kbd> | Lazygit (Root Dir) | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>T</kbd> | Lazygit (cwd) | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>m</kbd> | Git Blame Line | 𝐍 |
| <kbd>leader</kbd><kbd>g</kbd><kbd>o</kbd> | Git Browse (open) | 𝐍 𝐗 |
| <kbd>C-g</kbd> | Enter Normal Mode | 𝐓 |
| <kbd>Leader</kbd><kbd>m</kbd><kbd>k</kbd> | Open todo.md | 𝐍 |
| <kbd>Leader</kbd><kbd>m</kbd><kbd>K</kbd> | Open todo.md | 𝐍 |
| <kbd>Leader</kbd><kbd>?</kbd> | Dictionary | 𝐍 |
| <kbd>s</kbd> | +screen | 𝐍 |
| <kbd>s</kbd><kbd>]</kbd> | Swap adjacent windows | 𝐍 |
| <kbd>s</kbd><kbd>b</kbd> | Alternate buffer | 𝐍 |
| <kbd>s</kbd><kbd>c</kbd> | Close window | 𝐍 |
| <kbd>s</kbd><kbd>d</kbd> | Buffer delete | 𝐍 |
| <kbd>s</kbd><kbd>v</kbd> | Split window horizontally | 𝐍 |
| <kbd>s</kbd><kbd>g</kbd> | Split window vertically | 𝐍 |
| <kbd>s</kbd><kbd>t</kbd> | New tab | 𝐍 |
| <kbd>s</kbd><kbd>o</kbd> | Close other windows | 𝐍 |
| <kbd>s</kbd><kbd>q</kbd> | Quit | 𝐍 |
| <kbd>s</kbd><kbd>z</kbd> | Toggle Zoom | 𝐍 |
| <kbd>s</kbd><kbd>Z</kbd> | Toggle Zen | 𝐍 |
| <kbd>s</kbd><kbd>x</kbd> | Delete buffer and open new | 𝐍 |
