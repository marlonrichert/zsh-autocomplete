# `zsh-autocomplete`
`zsh-autocomplete` adds **real-time** type-ahead autocompletion to Zsh!

Additional features:
* Adds intuitive [keyboard shortcuts](#key-bindings) for choosing completions.
* Offers unique extra completions:
  * Completes lines and words from your command history.
  * Expands aliases, parameters and glob expressions.
  * Shows when multiple completions have a substring in common.
  * Completes dirs from dir jumping tools, including `zsh-z`, `zoxide`, `z.lua`, `rupa/z.sh`,
    `autojump`, `fasd` and `cdr`.
* Corrects spelling mistakes.
  * Don't like a correction? Just press Undo to revert it.

Compatible with `fzf`, `zsh-autosuggestions` and
`zsh-syntax-highlighting`/`zdharma/fast-syntax-highlighting`.

[![asciicast](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN.svg)](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN)

Table of Contents:
* [Key Bindings](#key-bindings)
* [Requirements](#requirements)
* [Installation](#installation)
* [Preferences](#preferences)
* [Author](#author)
* [License](#license)

# Key Bindings
| Key(s) | Action | <sub>[Widget](#advanced-choose-your-own-key-bindings)</sub> |
| --- | --- | --- |
| any | Show completions (asynchronously) | - |
| [<kbd>⇥</kbd>](# "tab") | Accept top completion or next autosuggestion word (with `zsh-autosuggestions`) | <sub>`complete-word`</sub> |
| [<kbd>⌃</kbd><kbd>␣</kbd>](# "ctrl-space") | Accept context-sensitive completion: history line, alias expansion, alternative quoting or common substring | <sub>`expand-word`</sub> |
| [<kbd>↓</kbd>](# "down") | Select another completion or (in multi-line buffer) move cursor down | <sub>`down-line-or-select`</sub> |
| [<kbd>⇟</kbd>](# "page down") | Select a completion (always) | <sub>`menu-select`</sub> |
| [<kbd>↑</kbd>](# "up") | Search history or (in multi-line buffer) move cursor up | <sub>`up-line-or-search`</sub> |
| [<kbd>⇞</kbd>](# "page up") | Search history (always) | <sub>`history-search`</sub> |
| [<kbd>⇤</kbd>](# "shift-tab") | Reveal hidden completions and additional info | <sub>`list-expand`</sub> |

## History Menu
| Key(s) | Action |
| --- | --- |
| [<kbd>↑</kbd><kbd>↓</kbd>](# "arrow keys") | Change selection |
| [<kbd>⇞</kbd>](# "page up") | Page up |
| [<kbd>⇟</kbd>](# "page down") | Page down |
| [<kbd>⌥</kbd><kbd><</kbd>](# "alt-<") | Beginning of menu |
| [<kbd>⌥</kbd><kbd>></kbd>](# "alt->") | End of menu |
| [<kbd>↩︎</kbd>](# "enter") | Accept selection, exit menu and substitute history expansions |
| [<kbd>⇥</kbd>](# "tab") | Accept selection, but stay in menu (multi-select) |
| other | Accept selection, exit menu and substitute history expansions (then execute the key just typed) |

## Completion Menu
| Key(s) | Action |
| --- | --- |
| [<kbd>↖︎</kbd>](# "home") | Beginning of line |
| [<kbd>↘︎</kbd>](# "end") | End of line |
| [<kbd>⌥</kbd><kbd>b</kbd>](# "alt-b") | Backward one group (if groups are shown) |
| [<kbd>⌥</kbd><kbd>f</kbd>](# "alt-f") | Forward one group (if groups are shown) |
| [<kbd>⇞</kbd>](# "page up") | Page up |
| [<kbd>⇟</kbd>](# "page down") | Page down |
| [<kbd>⌥</kbd><kbd><</kbd>](# "alt-<") | Beginning of menu |
| [<kbd>⌥</kbd><kbd>></kbd>](# "alt->") | End of menu |
| [<kbd>⌃</kbd><kbd>␣</kbd>](# "ctrl-space") | End of menu |
| [<kbd>↩︎</kbd>](# "enter") | Accept selection and exit menu |
| [<kbd>⇥</kbd>](# "tab") | Accept selection, but stay in menu (multi-select) |
| [<kbd>⇤</kbd>](# "shift-tab") | Reveal hidden completions and additional info (does not work in history menu) |
| other | Accept selection and exit menu (then execute the key just typed) |


# Requirements
Recommended:
* **[Zsh](http://zsh.sourceforge.net) 5.8** or later.

Minimum:
* Zsh 5.3 or later.


# Installation
There are two ways to install `zsh-autocomplete`:

## Manually
This is the **preferred way to install**.
1. `git clone` this repo. (You can optionally use a plugin manager for this.)
1. Add the following to your `.zshrc` file:
   ```shell
   source path/to/zsh-autocomplete.plugin.zsh
   ```

To update, `cd` into `zsh-autocomplete`'s directory and do `git pull` (or use your plugin manager's
update mechanism).

## As a Plugin
`zsh-autocomplete` should work as a plugin with most frameworks & plugin managers. Please refer to
your framework's/plugin manager's documentation for instructions.

**If you're experiencing problems**, please first install `zsh-autocomplete` manually instead. (See
previous section.)

Note for Oh My Zsh, Prezto and Zimfw users: `zsh-autocomplete` works best if you use it
_instead_ of your framework's supplied completion module.


# Preferences
The behavior of `zsh-autocomplete` can be customized through the `zstyle` system.

## Wait for a minimum amount of input
By default, `zsh-autocomplete` will show completions as soon as you start typing.

To make it stay silent until a minimum number of characters have been typed:
```shell
zstyle ':autocomplete:list-choices:*' min-input 3
```

## Shorten or lengthen the autocompletion list
By default, `zsh-autocomplete` limits the number of lines of completions listed to 50% of
[`$LINES`](http://zsh.sourceforge.net/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell)
minus
[`$BUFFERLINES`](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#User_002dDefined-Widgets)
to prevent the prompt from jumping around too much while you are typing.

To limit the list to a different height, use the following:
```shell
zstyle ':autocomplete:list-choices:*' max-lines 100%
```
You can set this to a percentage or to a fixed number of lines. Both work.

## Always show matches in named groups
By default, completion groups and duplicates matches are shown only in certain circumstances or
when you press [<kbd>⇤</kbd>](# "shift-tab"). This allows the automatic listing of completion
matches to be as compact and fast as possible.

To always show matches in groups (and thus show duplicate matches, too):
```shell
zstyle ':autocomplete:*' groups always
```
**WARNING:** Enabling this setting can potentially decrease autocompletion performance.

## Customize the autocompletion messages
You can customize the various completion messages shown.

This is shown when the number of lines needed to display all completions exceeds the number given
by
[`zstyle ':autocomplete:list-choices:*' max-lines`](#shorten-or-lengthen-the-autocompletion-list):
```shell
zstyle ':autocomplete:*:too-many-matches' message \
  '%F{yellow}Too long list. Press %B$ctrl-space%b %F{yellow}to open or type more to filter.'
```

This is shown when, for the given input, the completion system cannot find any matching completions
at all:
```shell
zstyle ':autocomplete:*:no-matches-at-all' message 'No matching completions found.'
```

## Change <kbd>⇥</kbd> and <kbd>⇤</kbd> behavior
By default, [<kbd>⇥</kbd>](# "tab") accepts the top match. The idea is that you keep typing until
the match you want is
* _at_ the top, at which point you press [<kbd>⇥</kbd>](# "tab") to accept it immediately, or
* _near_ the top, at which point you press [<kbd>⌃</kbd><kbd>␣</kbd>](# "ctrl-space") or (with
`fzf`) [<kbd>↓</kbd>](# "down") to start menu selection. Then, inside the menu, use
  * [<kbd>↑</kbd><kbd>←</kbd><kbd>↓</kbd><kbd>→</kbd>](# "arrow keys") to navigate the menu,
  * [<kbd>↩︎</kbd>](# "enter") to accept a single match,
  * [<kbd>⇥</kbd>](# "tab") to accept multiple matches, and
  * [<kbd>⇤</kbd>](# "shift-tab") to reveal hidden matches/info (which also works from the command
    line).
However, several alternative behaviors are available.

### Use <kbd>⇥</kbd> and <kbd>⇤</kbd> to select completions
```shell
zstyle ':autocomplete:tab:*' completion select
```
**Note** that this also changes [<kbd>⌃</kbd><kbd>␣</kbd>](# "ctrl-space") (since you no longer
need it for selecting completions) to expand an alias, insert a common substring or requote a
parameter expansion.

<sup>This uses the `menu-select`, `reverse-menu-select` and `expand-word`
[widgets](#advanced-choose-your-own-key-bindings).</sup>

### Use <kbd>⇥</kbd> and <kbd>⇤</kbd> to cycle between completions
```shell
zstyle ':autocomplete:tab:*' completion cycle
```
<sup>This uses the `menu-complete` and `reverse-menu-complete`
[widgets](#advanced-choose-your-own-key-bindings).</sup>

### Use <kbd>⇥</kbd> and <kbd>⇤</kbd> to insert a common substring (or cycle)
```shell
zstyle ':autocomplete:tab:*' completion insert
```
<sup>This uses the `insert-unambiguous` and `reverse-insert-unambiguous`
[widgets](#advanced-choose-your-own-key-bindings).</sup>

### Use `fzf`'s <kbd>⇥</kbd> completion
```shell
zstyle ':autocomplete:tab:*' completion fzf
```

## Disable recent dirs completion
If you have `zoxide`, `z.lua`, `z.sh`, `autojump` or `fasd` installed and have correctly configured
it to track your directory changes, then `zsh-autocomplete` will automatically list (f)recent
directories (and, in the case of `fasd`, also files) from this tool.

To _not_ include these:
```shell
zstyle ':autocomplete:*' recent-dirs off
```

## Advanced: Use your own completion config
`zsh-autocomplete` comes preconfigured with its own set of sophisticated completion settings, to
ensure you have the best possible out-of-the-box experience. However, some users might prefer to
build their own suite of completion settings, to fully customize the experience.

To disable the built-in config:
```shell
zstyle ':autocomplete:*' config off
```

## Advanced: Choose your own key bindings
`zsh-autocomplete` includes a set of intuitive [keyboard shortcuts](#key-bindings), mimicking those
offered by most IDEs. However, some users have their own very customized set of key bindings, into
which the defaults might not fit in.

To disable the default key bindings:
```shell
zstyle ':autocomplete:*' key-binding off
```

You can then use `zsh-autocomplete`'s [widgets](#key-bindings) to define your own key bindings.

# Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)

# License
This project is licensed under the MIT License. See the
[LICENSE](/marlonrichert/zsh-autocomplete/LICENSE) file for details.
