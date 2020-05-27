# zsh-autocomplete
IntelliSense-like find-as-you-type completion for the Z Shell!
* Automatically lists completions as you type.
* Press [<kbd>⇥</kbd>](# "tab") to insert the top match…
* …or [<kbd>↓</kbd>](# "down") to select a different one.
* Press [<kbd>⇤</kbd>](# "shift-tab") to list more choices/info.
* Press [<kbd>␣</kbd>](# "space") to correct the last word or do history expansion.
* Press [<kbd>↑</kbd>](# "up") to search history.
* Press [<kbd>⌃␣</kbd>](# "ctrl-space") to change dir, do expansion or search dirs/files.


## Demo
[![asciicast](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN.svg)](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN)


## Key Bindings
`zsh-autocomplete` adds intuitive key bindings for Zsh completions, `zsh-autosuggestions` and
`fzf`.

### Command Line
| Key(s) | Action |
| --- | --- |
| any | List choices (automatic) |
| [<kbd>⇥</kbd>](# "tab") | Insert top completion |
| [<kbd>⇤</kbd>](# "shift-tab") | List more choices/info |
| [<kbd>␣</kbd>](# "space") | Correct spelling + history expansion + insert space |
| [<kbd>⌥␣</kbd>](# "alt-space") | Insert space (no correction or expansion) |

#### With `zsh-autosuggestions`
`zsh-autocomplete` adds these key binding when you source
[`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) in your `.zshrc` file:

| Key(s) | Action |
| --- | --- |
| [<kbd>⇥</kbd>](# "tab") | Accept autosuggested word (when available) or insert top completion |


#### With `fzf`
`zsh-autocomplete` adds these key bindings when you source
[`fzf`'s shell extensions](https://github.com/junegunn/fzf#installation) in your `.zshrc` file:

| Key(s) | Action |
| --- | --- |
| [<kbd>⌃␣</kbd>](# "ctrl-space") | Do expansion, change directory (in empty buffer) or do [fuzzy file search](#requirements) |
| [<kbd>↓</kbd>](# "down") | Enter completion menu or (in multi-line buffer) move cursor down |
| [<kbd>↑</kbd>](# "up") | Do [fuzzy history search](#requirements) or (in multi-line buffer) move cursor up |
| [<kbd>⌥↓</kbd>](# "alt-down") | Enter completion menu (also in multi-line buffer) |
| [<kbd>⌥↑</kbd>](# "alt-up") | Do [fuzzy history search](#requirements) (also in multi-line buffer) |

### Completion Menu
| Key(s) | Action |
| --- | --- |
| [<kbd>↑</kbd><kbd>←</kbd><kbd>↓</kbd><kbd>→</kbd>](# "arrow keys") | Change selection |
| [<kbd>↩︎</kbd>](# "enter") | Insert single match (exit menu) |
| [<kbd>⇥</kbd>](# "tab") | Insert multiple matches (stay in menu) |
| [<kbd>⇤</kbd>](# "shift-tab") | List more choices/info (does not work in "corrections" menu) |
| [<kbd>⌃␣</kbd>](# "ctrl-space") | Insert single match + [fuzzy file search](#requirements) |
| other | Insert single match + insert character (exit menu) |


## Requirements
Mandatory:
* [**Zsh**](http://zsh.sourceforge.net) needs to be your shell.

Recommended:
* [**Fzf**](https://github.com/junegunn/fzf) and
  [its **shell extensions**](https://github.com/junegunn/fzf#installation) are required for
  [<kbd>↑</kbd> fuzzy history search](#key-bindings) and
  [<kbd>⌃␣</kbd> fuzzy file search](#key-bindings).
  * **Note:** It's _not_ enough for `fzf` to be in your path! You will also need to source its
    shell extensions in your `.zshrc` file.


## Installation
There are two ways to install `zsh-autocomplete`:

### As a Plugin
Please refer to your plugin manager's documentation for instructions.

**Note** for Prezto users: You need you load `zsh-autocomplete` _after or instead of_
Prezto's built-in `completion` module.

### Manually
1. `git clone` this repo.
1. If you want to use [<kbd>↑</kbd> fuzzy history search](#key-bindings) and
   [<kbd>⌃␣</kbd> fuzzy file search](#key-bindings):
   1. Make sure you have [`fzf`](https://github.com/junegunn/fzf) installed.
   1. Source [`fzf`'s shell extensions](https://github.com/junegunn/fzf#installation).
1. Add the following to your `.zshrc` file:
   ```shell
   source path/to/zsh-autocomplete.plugin.zsh
   ```

To update, `cd` into `zsh-autocomplete`'s directory and do `git pull`.


## Configuration
The behavior of `zsh-autocomplete` can be customzied through the `zstyle` system.

### Always show matches in named groups
By default, completion groups and duplicates matches are shown only when you press
[<kbd>⇤</kbd>](# "shift-tab") or [<kbd>⌃␣</kbd>](# "ctrl-space"). This allows the automatic listing
of completion matches to be as compact as possible.

To always show matches in groups (and thus show duplicate matches):
```shell
zstyle ':autocomplete:*' groups 'always'
```

### Turn off automatic corrections
By default, [<kbd>␣</kbd>](# "space") and [<kbd>/</kbd>](# "slash") both correct your spelling,
while [<kbd>␣</kbd>](# "space") also does history expansions.

To have space do history expansion, but no spelling correction:
```shell
zstyle ':autocomplete:space:*' magic 'expand-history'
```

To disable all automatic corrections, including history expansion:
```shell
zstyle ':autocomplete:(slash|space):*' magic 'off'
```

### Change [<kbd>⇥</kbd>](# "tab") and [<kbd>⇤</kbd>](# "shift-tab") behavior
By default, [<kbd>⇥</kbd>](# "tab") insert the top match. The idea is that you just keep typing
until the match you want is
* _at_ the top, at which point you press [<kbd>⇥</kbd>](# "tab") to insert it immediately, or
* _near_ the top, at which point you press [<kbd>↓</kbd>](# "down") to start menu selection. Then,
  inside the menu:
  * [<kbd>↑</kbd><kbd>←</kbd><kbd>↓</kbd><kbd>→</kbd>](# "arrow keys") navigate the menu,
  * [<kbd>↩︎</kbd>](# "enter") does single selection,
  * [<kbd>⇥</kbd>](# "tab") does multi-selection and
  * [<kbd>⇤</kbd>](# "shift-tab") shows you more matches and/or more info (which also works from
    the command line).

To have [<kbd>⇥</kbd>](# "tab") and [<kbd>⇤</kbd>](# "shift-tab") cycle between matches (_without_
  starting menu selection):
```shell
zstyle ':autocomplete:tab:*' completion 'cycle'
```

To use [<kbd>⇥</kbd>](# "tab") and [<kbd>⇤</kbd>](# "shift-tab") to start menu
selection:
```shell
zstyle ':autocomplete:tab:*' completion 'select'
```


## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)


## License
This project is licensed under the MIT License. See the [LICENSE](/marlonrichert/.config/LICENSE)
file for details.
