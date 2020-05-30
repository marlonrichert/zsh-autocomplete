# zsh-autocomplete
Find-as-you-type completion for the Z Shell!
* **Asynchronously** shows completions **as you type**.
  * With [IDE-like keybindings](#key-bindings) to choose and insert them.
* Automatically corrects misspelled words.
  * Don't like a correction? Press Undo to revert it.
* Integrates seamlessly with `fzf`, `zsh-autosuggestions` and `zsh-syntaxhighlighting`.


## Demo
[![asciicast](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN.svg)](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN)


## Key Bindings
Here's a list of key bindings that `zsh-autocomplete` adds to the command line.

| Key(s) | Action |
| --- | --- |
| any | List choices (automatic) |
| [<kbd>⇥</kbd>](# "tab") | Insert top completion[<sup>note</sup>](#with-zsh-autosuggestions) |
| [<kbd>⌃␣</kbd>](# "down") | Enter completion menu[<sup>note</sup>](#with-fzf) |
| [<kbd>⇤</kbd>](# "shift-tab") | List more choices/info |
| [<kbd>␣</kbd>](# "space") | Insert space and correct spelling or do history expansion |

### With `zsh-autosuggestions`
When you source
[`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) in your `.zshrc` file,
`zsh-autocomplete` modifies the following key binding:

| Key(s) | Action |
| --- | --- |
| [<kbd>⇥</kbd>](# "tab") | Accept autosuggested word (when available) or insert top completion |

### With `fzf`
When you source
[`fzf`'s shell extensions](https://github.com/junegunn/fzf#installation) in your `.zshrc` file,
`zsh-autocomplete` adds and modifies the following key bindings:

| Key(s) | Action |
| --- | --- |
| [<kbd>↓</kbd>](# "down") | Enter completion menu or (in multi-line buffer) move cursor down |
| [<kbd>↑</kbd>](# "up") | Do [fuzzy history search](#requirements) or (in multi-line buffer) move cursor up |
| [<kbd>⌃␣</kbd>](# "ctrl-space") | Do expansion, change directory (in empty buffer) or do [fuzzy file search](#requirements) |
| [<kbd>⌥↓</kbd>](# "alt-down") | Enter completion menu (also in multi-line buffer) |
| [<kbd>⌥↑</kbd>](# "alt-up") | Do [fuzzy history search](#requirements) (also in multi-line buffer) |

### Completion Menu
`zsh-autocomplete` adds the following key bindings to the completion menu:

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

Fzf integration:
* You  need to source `fzf`'s [**shell extensions**](https://github.com/junegunn/fzf#installation)
  in your `.zshrc` file to get the [full integration](#with-fzf). It's _not_ enough for `fzf` to be
  in your path!


## Installation
There are two ways to install `zsh-autocomplete`:

### As a Plugin
Please refer to your plugin manager's documentation for instructions.

**Note** for Prezto users: You need you load `zsh-autocomplete` _after or instead of_
Prezto's built-in `completion` module.

### Manually
1. `git clone` this repo.
1. Add the following to your `.zshrc` file:
   ```shell
   source path/to/zsh-autocomplete.plugin.zsh
   ```

To update, `cd` into `zsh-autocomplete`'s directory and do `git pull`.


## Configuration
The behavior of `zsh-autocomplete` can be customized through the `zstyle` system.

### Always show matches in named groups
By default, completion groups and duplicates matches are shown only when you press
[<kbd>⇤</kbd>](# "shift-tab") or [<kbd>⌃␣</kbd>](# "ctrl-space"). This allows the automatic listing
of completion matches to be as compact as possible.

To always show matches in groups (and thus show duplicate matches):
```shell
zstyle ':autocomplete:*' groups always
```

### Tune automatic corrections
By default, [<kbd>␣</kbd>](# "space") and [<kbd>/</kbd>](# "slash") both correct your spelling,
while [<kbd>␣</kbd>](# "space") also does history expansions.

To have space do history expansion, but no spelling correction:
```shell
zstyle ':autocomplete:space:*' magic expand-history
```

To disable all automatic corrections, including history expansion:
```shell
zstyle ':autocomplete:*' magic off
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
zstyle ':autocomplete:tab:*' completion cycle
```

To use [<kbd>⇥</kbd>](# "tab") and [<kbd>⇤</kbd>](# "shift-tab") to start menu
selection:
```shell
zstyle ':autocomplete:tab:*' completion select
```


## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)


## License
This project is licensed under the MIT License. See the [LICENSE](/marlonrichert/.config/LICENSE)
file for details.
