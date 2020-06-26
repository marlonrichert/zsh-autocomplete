# zsh-autocomplete
Find-as-you-type completion for the Z Shell!
* **Asynchronously** shows completions **as you type**.
  * With [IDE-like keybindings](#key-bindings) to choose completions and insert them.
* Automagically corrects misspellings, expands aliases and does history expansions.
  * Don't like a correction/expansion? Just press Undo to revert it.
* Integrates seamlessly with `fzf`, `zsh-autosuggestions` and
  `zsh-syntax-highlighting`/`zdharma/fast-syntax-highlighting`.
* Includes completion results from `zoxide`, `z.lua`, `z.sh`, `autojump` and `fasd`.


## Demo
[![asciicast](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN.svg)](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN)


## Key Bindings
`zsh-autocomplete` adds the following key bindings to your command line:

| Key(s) | Action |
| --- | --- |
| any | List choices (automatic) |
| [<kbd>⇥</kbd>](# "tab") | Accept top match[<sup>note</sup>](#with-zsh-autosuggestions) |
| [<kbd>⌃</kbd><kbd>␣</kbd>](# "ctrl-space") | Select another match[<sup>note</sup>](#with-fzf) |
| [<kbd>⇤</kbd>](# "shift-tab") | List more choices/info |
| [<kbd>␣</kbd>](# "space") | Insert space and correct spelling or do history expansion |
| [<kbd>⌥</kbd><kbd>␣</kbd>](# "alt-space") | Insert space (_without_ correction or expansion) |

### With `zsh-autosuggestions`
When you source
[`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) in your `.zshrc` file,
`zsh-autocomplete` modifies the following key binding:

| Key(s) | Action |
| --- | --- |
| [<kbd>⇥</kbd>](# "tab") | Accept autosuggested word (when available) or top match |

### With `fzf`
When you source
[`fzf`'s shell extensions](https://github.com/junegunn/fzf#installation) in your `.zshrc` file,
`zsh-autocomplete` adds and modifies the following key bindings:

| Key(s) | Action |
| --- | --- |
| [<kbd>↓</kbd>](# "down") | Select a match or (in multi-line buffer) move cursor down |
| [<kbd>↑</kbd>](# "up") | Do fuzzy history search or (in multi-line buffer) move cursor up |
| [<kbd>⌃</kbd><kbd>␣</kbd>](# "ctrl-space") | Change directory (in empty buffer), expand alias, insert longest common prefix (on glob expressions) or do fuzzy file search |
| [<kbd>⌥</kbd><kbd>↓</kbd>](# "alt-down") | Select a match (also in multi-line buffer) |
| [<kbd>⌥</kbd><kbd>↑</kbd>](# "alt-up") | Do fuzzy history search (also in multi-line buffer) |

### In Completion Menu
`zsh-autocomplete` adds the following key bindings to the completion menu:

| Key(s) | Action |
| --- | --- |
| [<kbd>↑</kbd><kbd>←</kbd><kbd>↓</kbd><kbd>→</kbd>](# "arrow keys") | Change selection |
| [<kbd>⌥</kbd><kbd>↓</kbd>](# "alt-down") | Jump to next group of matches (if groups are shown) |
| [<kbd>⌥</kbd><kbd>↑</kbd>](# "alt-up") | Jump to previous group of matches (if groups are shown)  |
| [<kbd>↩︎</kbd>](# "enter") | Accept single match (exit menu) |
| [<kbd>⇥</kbd>](# "tab") | Accept multiple matches (stay in menu) |
| [<kbd>⇤</kbd>](# "shift-tab") | List more choices/info (does not work in "corrections" menu) |
| [<kbd>⌃</kbd><kbd>␣</kbd>](# "ctrl-space") | Accept single match + [do fuzzy file search](#requirements) |
| other | Accept single match + insert character (exit menu) |


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
Please refer to your framework's/plugin manager's documentation for instructions.

**Note** for Prezto users: You need to load `zsh-autocomplete` _after or instead of_ Prezto's
built-in `completion` module.

### Manually
1. `git clone` this repo.
1. Add the following to your `.zshrc` file:
   ```shell
   source path/to/zsh-autocomplete.plugin.zsh
   ```

To update, `cd` into `zsh-autocomplete`'s directory and do `git pull`.


## Configuration
The behavior of `zsh-autocomplete` can be customized through the `zstyle` system.


### Wait for minimum amount of input
By default, `zsh-autocomplete` will show completions as soon as you start typing.

To make it stay silent until a minimum number of characters have been typed:
```shell
zstyle ':autocomplete:list-choices:*' min-input 3
```

### Shorten the autocompletion list
By default, while you are typing, `zsh-autocomplete` lists as many completions as it can fit on
the screen.

To limit the list to a smaller height, use the following:
```shell
zstyle ':autocomplete:list-choices:*' max-lines 40%
```
You can set this to a percentage of the total screen height or to a fixed number of lines. Both
work.


### Always show matches in named groups
By default, completion groups and duplicates matches are shown only in certain circumstances or
when you press [<kbd>⇤</kbd>](# "shift-tab"). This allows the automatic listing of completion
matches to be as compact and fast as possible.

To always show matches in groups (and thus show duplicate matches, too):
```shell
zstyle ':autocomplete:*' groups always
```
**WARNING:** Enabling this setting can noticeably decrease autocompletion performance.


### Tweak or disable automagic corrections
By default, [<kbd>␣</kbd>](# "space") and [<kbd>/</kbd>](# "slash") both automagically correct
your spelling.

To have space do history expansion, instead of spelling correction:
```shell
zstyle ':autocomplete:space:*' magic expand-history
```

To make it do both:
```shell
zstyle ':autocomplete:space:*' magic correct-word expand-history
```

To disable all automagic corrections, including history expansion:
```shell
zstyle ':autocomplete:*' magic off
```

### Change [<kbd>⇥</kbd>](# "tab") and [<kbd>⇤</kbd>](# "shift-tab") behavior
By default, [<kbd>⇥</kbd>](# "tab") accepts the top match. The idea is that you just keep typing
until the match you want is
* _at_ the top, at which point you press [<kbd>⇥</kbd>](# "tab") to accept it immediately, or
* _near_ the top, at which point you press [<kbd>↓</kbd>](# "down") to start menu selection. Then,
  inside the menu, use
  * [<kbd>↑</kbd><kbd>←</kbd><kbd>↓</kbd><kbd>→</kbd>](# "arrow keys") to navigate the menu,
  * [<kbd>↩︎</kbd>](# "enter") to accept a single match,
  * [<kbd>⇥</kbd>](# "tab") to accept multiple matches, and
  * [<kbd>⇤</kbd>](# "shift-tab") to view more matches and/or more info (which also works from the
    command line).

To use [<kbd>⇥</kbd>](# "tab") and [<kbd>⇤</kbd>](# "shift-tab") to start menu selection:
```shell
zstyle ':autocomplete:tab:*' completion select
```

To have [<kbd>⇥</kbd>](# "tab") and [<kbd>⇤</kbd>](# "shift-tab") cycle between matches (_without_
starting menu selection):
```shell
zstyle ':autocomplete:tab:*' completion cycle
```

To have [<kbd>⇥</kbd>](# "tab") and [<kbd>⇤</kbd>](# "shift-tab") insert the longest string that
all matches listed have in common (and after that, behave as `cycle`):
```shell
zstyle ':autocomplete:tab:*' completion insert
```
**Note:** This last option also changes the listings slightly to not do completion to the left of
what you've typed (unless that would result in zero matches).

To have [<kbd>⇥</kbd>](# "tab") use [`fzf`'s completion feature](#requirements):
```shell
zstyle ':autocomplete:tab:*' completion fzf
```

### Disable `fzf` key bindings
If you source [`fzf`'s shell extensions](#requirements), then `zsh-autocomplete` adds [additional
key bindings](#with-fzf).

To _not_ use these:
```shell
zstyle ':autocomplete:*' fuzzy-search off
```


### Customize autocompletion messages
You can customize the various messages that the autocompletion feature shows.

This is shown when the number of lines needed to display all matches exceeds the available screen
space (or the number given by `zstyle ':autocomplete:list-choices:*' max-lines`):
```shell
zstyle ':autocomplete:*:too-many-matches' message \
  'Too many completions to fit on screen. Type more to filter or press Ctrl-Space to open the menu.'
```

This is shown when the completion system decides, for whatever reason, that it does not want to
show any completions yet, until you've typed more input:
```shell
zstyle ':autocomplete:*:no-matches-yet' message 'Type more...'
```

This is shown when, for the given input, the completion system cannot find any matching completions
at all:
```shell
zstyle ':autocomplete:*:no-matches-at-all' message 'No matching completions found.'
```


## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)


## License
This project is licensed under the MIT License. See the [LICENSE](/marlonrichert/.config/LICENSE)
file for details.
