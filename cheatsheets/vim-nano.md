# ✏️ Vim & Nano Cheatsheet

## VIM

### Modes
| Mode | Enter | Purpose |
|------|-------|---------|
| Normal | `Esc` | Navigate, commands |
| Insert | `i` | Type text |
| Visual | `v` | Select text |
| Command | `:` | Save, quit, search |

### Navigation (Normal Mode)
```
h j k l         Left, Down, Up, Right
w / b           Next / Previous word
0 / $           Start / End of line
gg / G          Top / Bottom of file
:n              Go to line n
Ctrl+d          Half page down
Ctrl+u          Half page up
```

### Editing
```
i               Insert before cursor
a               Insert after cursor
o               New line below
O               New line above
x               Delete character
dd              Delete line
yy              Copy (yank) line
p               Paste below
u               Undo
Ctrl+r          Redo
.               Repeat last command
```

### Search & Replace
```
/text           Search forward
?text           Search backward
n / N           Next / Previous match
:%s/old/new/g   Replace all in file
:s/old/new/g    Replace in current line
```

### Save & Quit
```
:w              Save
:q              Quit
:wq             Save & quit
:q!             Quit without saving
:wqa            Save & quit all
ZZ              Save & quit (shortcut)
```

### Visual Mode
```
v               Character select
V               Line select
Ctrl+v          Block select
y               Yank selected
d               Delete selected
>               Indent right
<               Indent left
```

### Multi-file
```
:e file         Open file
:sp file        Horizontal split
:vsp file       Vertical split
Ctrl+w w        Switch window
:tabnew file    Open in new tab
gt / gT         Next / Previous tab
```

---

## NANO

### Basic Shortcuts (^ = Ctrl, M = Alt)
```
^O              Save (Write Out)
^X              Exit
^R              Open file
^W              Search
^\              Search & Replace
^K              Cut line
^U              Paste
^/              Go to line number
^A / ^E         Start / End of line
^G              Help
```

### Navigation
```
^F / ^B         Forward / Backward one character
^P / ^N         Previous / Next line
^Y / ^V         Previous / Next page
M-\             Go to first line
M-/             Go to last line
```

### Selection & Edit
```
M-A             Start selection (mark)
^K              Cut selected / line
^U              Paste
M-U             Undo
M-E             Redo
^T              Spell check (if installed)
```

### Search
```
^W              Open search
M-W             Find next
M-R             Toggle regex in search
```

### Display
```
M-N             Toggle line numbers
M-P             Toggle whitespace display
M-X             Toggle help bar
M-C             Toggle cursor position
```
