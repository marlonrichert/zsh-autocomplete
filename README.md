# zsh-autocomplete

IntelliSense-like find-as-you-type completion for the Z Shell

[![asciicast](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN.svg)](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN)


## Features
* Automatic, find-as-you-type completion menu
* Automatic spelling correction
* Intuitive key bindings


### Key bindings

| Key(s) | Action |
| --- | --- |
| any | List choices (automatic) |
| [⇥](# "tab") | Complete word |
| [⇧⇥](# "shift + tab") | List more choices/info |
| [↓](# "down arrow") | Select a choice (or down line) |
| [↑](# "up arrow") | [Fuzzy history search](#requirements) (or up line) |
| [␣](# "space") | Correct spelling + insert space |
| [⌃␣](# "ctrl + space") | [Fuzzy file search](#requirements) or expand alias |
| [⌥␣](# "alt/esc + space") | Insert space (no correction) |
| [⌥↓](# "alt/esc + down arrow") | Down line (no selection) |
| [⌥↑](# "alt/esc + up arrow") | Up line (no search) |


### Key bindings in completion menu

| Key(s) | Action |
| --- | --- |
| [↑ ↓ ← →](# "arrow keys") | Change selection |
| [↩︎](# "enter") | Accept selection and exit menu |
| [⇥](# "tab") | Accept selection (but stay in menu) |
| [⇧⇥](# "shift + tab") | List more choices/info |
| [⌃␣](# "ctrl + space") | Accept selection + [fuzzy file search](#requirements) |


## Requirements
Mandatory:
* You need to run [`zsh`](http://zsh.sourceforge.net) as your shell.

Optional:
* [↑ fuzzy history search](#key-bindings "up arrow") and [⌃␣ fuzzy file search](#key-bindings "ctrl + space") require that you have [`fzf`](https://github.com/junegunn/fzf) installed and have sourced its
[completion](https://github.com/junegunn/fzf/blob/master/shell/completion.zsh) and
[key-bindings](https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh) in your `.zshrc` file.

## Installation
Clone this repo and then
```
source path/to/zsh-autocomplete.plugin.zsh
```
in your `.zshrc` file —or add `marlonrichert/zsh-autocomplete` as a plugin through your favorite
framework or plugin manager.

`zsh-autocomplete` should be sourced *after* plugins that change key bindings (such as `fzf` or
`zsh-autopair`), but *before* plugins that wrap existing key binding widgets (such as
`zsh-syntax-highlighting` and `zsh-syntax-highlighting`).

## Author
© 2020 [Marlon Richert](/marlonrichert)


## License

This project is licensed under the MIT License - see the [LICENSE](/marlonrichert/.config/LICENSE)
file for details
