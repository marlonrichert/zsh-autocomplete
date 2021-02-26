# `zsh-autocomplete`
`zsh-autocomplete` adds **real-time type-ahead autocompletion** to Zsh. Find as you type, then
press <kbd>Tab</kbd> to insert the top completion, <kbd>Shift</kbd><kbd>Tab</kbd> to insert the
bottom one, or <kbd>↓</kbd>/<kbd>PgDn</kbd> to select another completion.

[![file-search](.img/file-search.gif)](https://asciinema.org/a/377611)

* [Other Features](#other-features)
* [Key Bindings](#key-bindings)
* [Requirements](#requirements)
* [Installation](#installation)
* [Settings](#settings)
* [Author](#author)
* [License](#license)

## Other Features
Besides live autocompletion, `zsh-autocomplete` comes with many more useful completion features.

### Optimized completion config
Zsh's completion system is powerful, but hard to configure. So, `zsh-autocomplete` does it for you,
while providing a manageable list of [settings](#settings) for changing the defaults.

### Live history search
Press <kbd>Control</kbd><kbd>R</kbd> or <kbd>Control</kbd><kbd>S</kbd> to do an interactive,
multi-line, fuzzy history search.

[![history-search](.img/history-search.gif)](https://asciinema.org/a/379844)

### History menu
Press <kbd>↑</kbd> or <kbd>PgUp</kbd> to browse the last 16 history items. If the command line is
not empty, then it will instead list the 16 most recent fuzzy matches.

![history menu](.img/history-menu.png)

### Multi-selection
Press <kbd>Control</kbd><kbd>Space</kbd> in the completion menu or the history menu to insert more
than one item.

![multi-select](.img/multi-select.png)

### Recent dirs completion
Works out of the box with zero configuration, but also supports `zsh-z`, `zoxide`, `z.lua`,
`rupa/z.sh`, `autojump` and `fasd`.

![recent dirs](.img/recent-dirs.png)

### Additional, context-sensitive completions
Press <kbd>Shift</kbd><kbd>Tab</kbd> to insert:

![unambiguous](.img/unambiguous.png)

![requoted](.img/requoted.png)

![alias expansion](.img/alias-expansion.png)


## Key Bindings
| Key(s) | Action | <sub>[Widget](#change-other-key-bindings)</sub> |
| --- | --- | --- |
| <kbd>Tab</kbd> | Accept top completion | <sub>`complete-word`</sub> |
| <kbd>Shift</kbd><kbd>Tab</kbd> | Accept bottom completion | <sub>`expand-word`</sub> |
| <kbd>Control</kbd><kbd>Space</kbd> | Reveal hidden completions | <sub>`list-expand`</sub> |
| <kbd>↑</kbd> | Cursor up (if able) or history menu | <sub>`up-line-or-search`</sub> |
| <kbd>↓</kbd> | Cursor down (if able) or completion menu | <sub>`down-line-or-select`</sub> |
| <kbd>Alt</kbd><kbd>↑</kbd> | Cursor up (always) | <sub>`up-line`</sub> |
| <kbd>Alt</kbd><kbd>↓</kbd> | Cursor down (always) | <sub>`down-line`</sub> |
| <kbd>PgUp</kbd> | History menu (always) | <sub>`history-search`</sub> |
| <kbd>PgDn</kbd> | Completion menu (always) | <sub>`menu-select`</sub> |
| <kbd>Control</kbd><kbd>R</kbd> | Live history search, from newest to oldest | <sub>`history-incremental-search-backward`</sub> |
| <kbd>Control</kbd><kbd>S</kbd> | Live history search, from oldest to newest | <sub>`history-incremental-search-forward`</sub> |

### Completion Menu
| Key(s) | Action |
| --- | --- |
| <kbd>↑</kbd>/<kbd>↓</kbd>/<kbd>←</kbd>/<kbd>→</kbd> | Change selection |
| <kbd>Alt</kbd><kbd>↑</kbd> | Backward one group |
| <kbd>Alt</kbd><kbd>↓</kbd> | Forward one group |
| <kbd>PgUp</kbd>/<kbd>PgDn</kbd> | Page up/down |
| <kbd>Home</kbd>/<kbd>End</kbd> | Beginning/End of menu |
| <kbd>Control</kbd><kbd>Space</kbd> | Multi-select |
| <kbd>Tab</kbd> | Accept selection |
| <kbd>Shift</kbd><kbd>Tab</kbd> | Reject selection |
| <kbd>Enter</kbd> | Accept command line |

### History Menu
| Key(s) | Action |
| --- | --- |
| <kbd>↑</kbd>/<kbd>↓</kbd> | Change selection |
| <kbd>Home</kbd>/<kbd>End</kbd> | Beginning/End of menu |
| <kbd>Control</kbd><kbd>Space</kbd> | Multi-select |
| <kbd>←</kbd>/<kbd>→</kbd> | Accept selection & move cursor |
| <kbd>Tab</kbd> | Accept selection |
| <kbd>Shift</kbd><kbd>Tab</kbd> | Reject selection |
| <kbd>Enter</kbd> | Accept command line |

## Requirements
Recommended:
* **[Zsh](http://zsh.sourceforge.net) 5.8** or later.

Minimum:
* Zsh 5.3 or later.


## Installation
1.  `git clone` this repo.
1.  Add to your `~/.zshrc` file, _before_ any calls to `compdef`:
    ```zsh
    source path/to/zsh-autocomplete.plugin.zsh
    ```
1.  Remove any calls to `compinit` from your `~/.zshrc` file.

### Updating
1.  `cd` into `zsh-autocomplete`'s directory.
1.  Do `git pull`.

### As a Plugin
`zsh-autocomplete` should work as a plugin with most frameworks & plugin managers. Please refer to
your framework's/plugin manager's documentation for instructions.


## Settings
To change your settings, just copy-paste any of the code below to your `~/.zshrc` file.

⚠️ **Note** that while most of these settings use the `:autocomplete:` namespace, some of them use
`:completion:`. This is because the latter are managed by Zsh's own completion system, whereas the
former are unique to `zsh-autocomplete`.

* [Change Tab behavior](#change-tab-behavior)
* [Change other key bindings](#change-other-key-bindings)
* [Always start with live history search](#always-start-with-live-history-search)
* [Disable live history search](#disable-live-history-search)
* [Wait for a minimum amount of time](#wait-for-a-minimum-amount-of-time)
* [Wait for a minimum amount of input](#wait-for-a-minimum-amount-of-input)
* [Ignore certain inputs](#ignore-certain-inputs)
* [Disable certain completions](#disable-certain-completions)
* [Change the order of completions](#change-the-order-of-completions)
* [Change the "partial list" message](#change-the-partial-list-message)

### Change Tab behavior
By default, <kbd>Tab</kbd> inserts the top completion, <kbd>Shift</kbd><kbd>Tab</kbd> inserts the
bottom completion, and <kbd>↓</kbd> activates menu selection.

To make <kbd>Tab</kbd> first insert any common substring, before inserting full completions:
```zsh
zstyle ':autocomplete:tab:*' insert-unambiguous yes
```

To make <kbd>Tab</kbd> or <kbd>Shift</kbd><kbd>Tab</kbd> activate menu selection:
```zsh
zstyle ':autocomplete:tab:*' widget-style menu-select
```

To make <kbd>Tab</kbd> and <kbd>Shift</kbd><kbd>Tab</kbd> cycle completions _without_ using menu
selection:
```zsh
zstyle ':autocomplete:tab:*' widget-style menu-complete
```

To make <kbd>Tab</kbd> try Fzf's completion before using Zsh's:
```zsh
zstyle ':autocomplete:tab:*' fzf-completion yes
```

⚠️ **Note** that, unlike most other settings, changing `widget-style` at runtime has no effect and
changing `fzf-completion` at runtime will not function correctly. These settings can be changed in
your `~/.zshrc` file only.

The settings `widget-style`, `insert-unambiguous` and `fzf-completion` are mutually compatible and
can be used in parallel.

### Change other key bindings
Key bindings other than <kbd>Tab</kbd> or <kbd>Shift</kbd><kbd>Tab</kbd> can be overridden with
the `bindkey` command, if you do so _after_ sourcing `zsh-autocomplete`. To make this easier,
`zsh-autocomplete` defines an associative array `$key` that you can use:

```zsh
source path/to/zsh-autocomplete.plugin.zsh
# The following lines revert the given keys back to Zsh defaults:
bindkey $key[Up] up-line-or-history
bindkey $key[Down] down-line-or-history
bindkey $key[Control-Space] set-mark-command
bindkey -M menuselect $key[Return] accept-line
```

### Always start with live history search
To start each new command line as if <kbd>Control</kbd><kbd>R</kbd> has been pressed:
```zsh
zstyle ':autocomplete:*' default-context history-incremental-search-backward
```

### Disable live history search
To revert <kbd>Control</kbd><kbd>R</kbd> and <kbd>Control</kbd><kbd>S</kbd> to Zsh's default
behavior:
```zsh
zle -A .history-incremental-search-forward history-incremental-search-forward
zle -A .history-incremental-search-backward history-incremental-search-backward
```

### Wait for a minimum amount of time
To suppress autocompletion until you have stopped typing for a certain number of seconds:
```zsh
zstyle ':autocomplete:*' min-delay .3  # 300 milliseconds
```

### Wait for a minimum amount of input
To suppress autocompletion until a minimum number of characters have been typed:
```zsh
zstyle ':autocomplete:*' min-input 3  # characters
```

### Ignore certain inputs
To not trigger autocompletion for input that matches a pattern:
```zsh
# This example matches any input word consisting of two or more dots (and no other chars).
zstyle ':autocomplete:*' ignored-input '..##'
```
The pattern syntax supported here is that of [Zsh's extended glob
operators](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Operators).

### Disable certain completions
To disable, for example, ancestor directories, recent directories and recent files:
```zsh
zstyle ':completion:*:complete:*:' tag-order \
  '! ancestor-directories recent-directories recent-files' -
```
⚠️ **Note** the additional `:` at the end of the namespace selector and the `-` as the last value.

### Change the order of completions
To list certain completions in a particular order _before_ all other completions:
```zsh
zstyle ':completion:*:' group-order \
  options \
  executables directories suffix-aliases \
  aliases functions builtins reserved-words
```
⚠️ **Note** the additional `:` at the end of the namespace selector.

### Change the "partial list" message
To alter the message shown when the list of completions does not fit on screen:
```zsh
  local hint=$'%{\e[02;39m%}' kbd=$'%{\e[22;39m%}' end=$'%{\e[0m%}'
  zstyle ':autocomplete:*:too-many-matches' message \
    "${hint}(partial list; press ${kbd}Control${hint}-${kbd}Space$hint to expand)$end"
```

## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
