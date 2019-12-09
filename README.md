# Vim note plugin

A very simple note taking vim plugin.

## USAGE

This plugin create some note files in current directory in following manners.

### Choose or Create a named note

    :CNote [{name}]

This will select `.note.{name}.md`.

If you omit {name} argument, then default note, `.note.md`, will be selected.

### Check current note file name

    :FNote

This will show you the current selected note file name.

### Open Selected Note

    :Note

This will open the selected note file in current window.

    :SNote

This will open the selected note file in horizontal splited  window.

    :VNote

This will open the selected note file in vertical splited  window.

#### LISENCE

MIT
