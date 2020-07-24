# zsh-autocomplete
Modern, IDE-like autocompletion for the Z Shell:
* **Asynchronously** lists completions as you type.
  * Includes recent dirs from `zsh-z`, `zoxide`, `z.lua`, `rupa/z.sh`, `autojump`, `fasd` or `cdr`.
* Adds intuitive [key bindings](#key-bindings) to choose and insert completions
* Automatically corrects misspellings.
  * Don't like a correction? Just press Undo to revert it.
* Works seamlessly with `fzf`, `zsh-autosuggestions` and 
  `zsh-syntax-highlighting`/`zdharma/fast-syntax-highlighting`.

[![asciicast](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN.svg)](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN)

Table of Contents:
* [Key Bindings](#key-bindings)
    * [With zsh-autosuggestions](#with-zsh-autosuggestions)
    * [With fzf](#with-fzf)
    * [In Completion Menu](#in-completion-menu)
* [Requirements](#requirements)
* [Installation](#installation)
    * [Manually](#manually)
    * [As a Plugin](#as-a-plugin)
* [Configuration](#configuration)
    * [Wait for minimum amount of input](#wait-for-minimum-amount-of-input)
    * [Shorten or lengthen the autocompletion list](#shorten-or-lengthen-the-autocompletion-list)
    * [Always show matches in named groups](#always-show-matches-in-named-groups)
    * [Disable "frecent" dirs feature](#disable-frecent-dirs-feature)
    * [Customize autocompletion messages](#customize-autocompletion-messages)
    * [Change <kbd>⇥</kbd> and <kbd>⇤</kbd> behavior](#change--and--behavior)
    * [Change or disable automagic corrections and expansions](#change-or-disable-automagic-corrections-and-expansions)
    * [Disable fzf key bindings](#disable-fzf-key-bindings)
* [Author](#author)
* [License](#license)

## Key Bindings
`zsh-autocomplete` adds the following key bindings to your command line:

| Key(s) | Action |
| --- | --- |
| any | List choices (automatic) |
| [<kbd>⇥</kbd>](# "tab") | Accept top completion |
| [<kbd>⌃</kbd><kbd>␣</kbd>](# "ctrl-space") | Select another completion[<sup>note</sup>](#with-fzf) |
| [<kbd>⇤</kbd>](# "shift-tab") | Reveal hidden completions and additional info |
| [<kbd>␣</kbd>](# "space") | Insert space and correct spelling |
| [<kbd>⌥</kbd><kbd>␣</kbd>](# "alt-space") | Insert space only |

### With `zsh-autosuggestions`
When you source
[`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) in your `.zshrc` file,
`zsh-autocomplete` modifies the following key binding:

| Key(s) | Action |
| --- | --- |
| [<kbd>⇥</kbd>](# "tab") | Accept top completion or autosuggested word (at end of line) |

### With `fzf`
When you source
[`fzf`'s shell extensions](https://github.com/junegunn/fzf#installation) in your `.zshrc` file,
`zsh-autocomplete` adds and modifies the following key bindings:

| Key(s) | Action |
| --- | --- |
| [<kbd>↓</kbd>](# "down") | Select a completion or move cursor down (in multi-line buffer) |
| [<kbd>⌥</kbd><kbd>↓</kbd>](# "alt-down") | Select a completion (always) |
| [<kbd>↑</kbd>](# "up") | Do fuzzy history search or move cursor up (in multi-line buffer) |
| [<kbd>⌥</kbd><kbd>↑</kbd>](# "alt-up") | Do fuzzy history search (always) |
| [<kbd>⌃</kbd><kbd>␣</kbd>](# "ctrl-space") | Accept all suggestions (at end of line), change directory (in empty buffer), expand alias, insert common prefix or do fuzzy file search |

### In Completion Menu
`zsh-autocomplete` adds the following key bindings to the completion menu:

| Key(s) | Action |
| --- | --- |
| [<kbd>↑</kbd><kbd>←</kbd><kbd>↓</kbd><kbd>→</kbd>](# "arrow keys") | Change selection |
| [<kbd>⌥</kbd><kbd>↓</kbd>](# "alt-down") | Jump to next group of matches (if groups are shown) |
| [<kbd>⌥</kbd><kbd>↑</kbd>](# "alt-up") | Jump to previous group of matches (if groups are shown)  |
| [<kbd>↩︎</kbd>](# "enter") | Accept single match (exit menu) |
| [<kbd>⇥</kbd>](# "tab") | Accept multiple matches (stay in menu) |
| [<kbd>⇤</kbd>](# "shift-tab") | Reveal hidden completions and additional info (does not work in "corrections" menu) |
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

### Manually
This is the **preferred way to install**.
1. `git clone` this repo. (You can optionally use a plugin manager for this.)
1. Add the following to your `.zshrc` file:
   ```shell
   source path/to/zsh-autocomplete.plugin.zsh
   ```

To update, `cd` into `zsh-autocomplete`'s directory and do `git pull` (or use your plugin manager's
update mechanism).

### As a Plugin
`zsh-autocomplete` should work as a plugin with most frameworks & plugin managers. Please refer to
your framework's/plugin manager's documentation for instructions.

**If you're experiencing problems**, please first install `zsh-autocomplete` manually instead. (See
previous section.)

Note for Oh My Zsh, Prezto and Zimfw users: `zsh-autocomplete` works best if you use it
_instead_ of your framework's supplied completion module.


## Configuration
The behavior of `zsh-autocomplete` can be customized through the `zstyle` system.

### Wait for minimum amount of input
By default, `zsh-autocomplete` will show completions as soon as you start typing.

To make it stay silent until a minimum number of characters have been typed:
```shell
zstyle ':autocomplete:list-choices:*' min-input 3
```

### Shorten or lengthen the autocompletion list
By default, while you are typing, `zsh-autocomplete` limits the number of lines of completions
shown to 50% of
[`$LINES`](http://zsh.sourceforge.net/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell)
minus
[`$BUFFERLINES`](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#User_002dDefined-Widgets)
to prevent the prompt from jumping around too much while typing.

To limit the list to a different height, use the following:
```shell
zstyle ':autocomplete:list-choices:*' max-lines 100%
```
You can set this to a percentage or to a fixed number of lines. Both work.

### Always show matches in named groups
By default, completion groups and duplicates matches are shown only in certain circumstances or
when you press [<kbd>⇤</kbd>](# "shift-tab"). This allows the automatic listing of completion
matches to be as compact and fast as possible.

To always show matches in groups (and thus show duplicate matches, too):
```shell
zstyle ':autocomplete:*' groups always
```
**WARNING:** Enabling this setting can noticeably decrease autocompletion performance.

### Disable "frecent" dirs feature
If you have `zoxide`, `z.lua`, `z.sh`, `autojump` or `fasd` installed and have correctly configured
it to track your directory changes, then `zsh-autocomplete` will automatically list "frecent"
directories from this tool.

To _not_ include these:
```shell
zstyle ':autocomplete:*' frecent-dirs off
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
**Note** that this also changes [<kbd>⌃</kbd><kbd>␣</kbd>](# "ctrl-space") to expand an alias or
insert the longest common prefix of a glob expansion (since you don't need it anymore for selecting
matches).

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

To have [<kbd>⇥</kbd>](# "tab") use [`fzf`'s completion feature](#requirements):
```shell
zstyle ':autocomplete:tab:*' completion fzf
```

### Change or disable automagic corrections and expansions
By default, [<kbd>␣</kbd>](# "space") and [<kbd>/</kbd>](# "slash") automagically corrects
spelling mistakes.

To have space do history expansion, instead of spelling correction:
```shell
zstyle ':autocomplete:space:*' magic expand-history
```

To make it do both:
```shell
zstyle ':autocomplete:space:*' magic correct-word expand-history
```

To disable all automagic corrections and expansions:
```shell
zstyle ':autocomplete:*' magic off
```

### Disable `fzf` key bindings
If you source [`fzf`'s shell extensions](#requirements), then `zsh-autocomplete` adds [additional
key bindings](#with-fzf).

To _not_ use these:
```shell
zstyle ':autocomplete:*' fuzzy-search off
```


## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)


## License
This project is licensed under the MIT License. See the [LICENSE](/marlonrichert/.config/LICENSE)
file for details.
