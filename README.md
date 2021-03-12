# `zsh-autocomplete`
`zsh-autocomplete` adds **real-time type-ahead autocompletion** to Zsh. Find as you type, then
press <kbd>Tab</kbd> to insert the top completion, <kbd>Shift</kbd><kbd>Tab</kbd> to insert the
bottom one, or <kbd>↓</kbd>/<kbd>PgDn</kbd> to select another completion.

[![file-search](.img/file-search.gif)](https://asciinema.org/a/377611)

* [Other Features](#other-features)
* [Key Bindings](#key-bindings)
* [Requirements](#requirements)
* [Installing & Updating](#installing--updating)
* [Settings](#settings)
* [Author](#author)
* [License](#license)

## Other Features
Besides live autocompletion, `zsh-autocomplete` comes with many other useful completion features.

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


## Key Bindings
| Key(s) | Action | <sub>[Widget](#change-other-key-bindings)</sub> |
| --- | --- | --- |
| <kbd>Tab</kbd> | Accept top completion | <sub>`complete-word`</sub> |
| <kbd>Shift</kbd><kbd>Tab</kbd> | Accept bottom completion | <sub>`complete-word`</sub> |
| <kbd>Control</kbd><kbd>Space</kbd> | Show additional completions | <sub>`list-expand`</sub> |
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

## Installing & Updating
To install:
1.  Clone the repo:
    ```zsh
    % cd ~/git  # or wherever you keep your Git repos/Zsh plugins
    % git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
    ```
1.  Add to your `~/.zshrc` file, _before_ any calls to `compdef`:
    ```zsh
    source ~/git/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    ```
1.  Remove any calls to `compinit` from your `~/.zshrc` file.

To update:
```zsh
git -C ~/git/zsh-autocomplete pull
```

### As a Plugin
Instead of following the instructions above, you can also install `zsh-autocomplete` through
whichever Zsh frameworks or plugin manager you use. Please refer to your framework's/plugin
manager's documentation for instructions.

## Settings
The code below shows all of `zsh-autocomplete`'s settings with their default values. To adjust a
 setting, copy-paste it into your `.zshrc` file and change the value there.
```zsh
zstyle ':autocomplete:*' default-context ''
# '': Start each new command line with normal autocompletion.
# history-incremental-search-backward: Start in live history search mode.

zstyle ':autocomplete:*' min-delay 0.0  # number of seconds (float)
# 0.0: Start autocompletion immediately when you stop typing.
# 0.4: Wait 0.4 seconds for more keyboard input before showing completions.

zstyle ':autocomplete:*' min-input 0  # number of characters (integer)
# 0: Show completions immediately on each new command line.
# 1: Wait for at least 1 character of input.

zstyle ':autocomplete:*' ignored-input '' # extended glob pattern
# '':     Always show completions.
# '..##': Don't show completions when the input consists of two or more dots.

# When completions don't fit on screen, show up to this many lines:
zstyle ':autocomplete:*' list-lines 16  # (integer)
# NOTE: The actual amount shown can be less.

# If any of the following are shown at the same time, list them in the order given:
zstyle ':completion:*:' group-order \
  expansions history-words options \
  aliases functions builtins reserved-words \
  executables local-directories directories suffix-aliases
# NOTE: This is NOT the order in which they are generated.

zstyle ':autocomplete:tab:*' insert-unambiguous no
# no:  (Shift-)Tab inserts top (bottom) completion.
# yes: Tab first inserts substring common to all listed completions (if any).

zstyle ':autocomplete:tab:*' widget-style complete-word
# complete-word: (Shift-)Tab inserts top (bottom) completion.
# menu-complete: Press again to cycle to next (previous) completion.
# menu-select:   Same as `menu-complete`, but updates selection in menu.
# NOTE: Can NOT be changed at runtime.

zstyle ':autocomplete:tab:*' fzf-completion no
# no:  Tab uses Zsh's completion system only.
# yes: Tab first tries Fzf's completion, then falls back to Zsh's.
# NOTE 1: Can NOT be changed at runtime.
# NOTE 2: Requires that you have installed Fzf's shell extensions.

# Add a space after these completions:
zstyle ':autocomplete:*' add-space executables aliases functions builtins reserved-words commands

source path/to/zsh-autocomplete.plugin.zsh
#
# NOTE: All settings below should come AFTER sourcing zsh-autocomplete!
#

bindkey $key[Up]    up-line-or-search
# up-line-or-search:  Open history menu.
# up-line-or-history: Cycle to previous history line.

bindkey $key[Down]  down-line-or-select
# down-line-or-select:  Open completion menu.
# down-line-or-history: Cycle to next history line.

bindkey $key[Control-Space] list-expand
# list-expand:      Reveal hidden completions.
# set-mark-command: Activate text selection.

bindkey -M menuselect $key[Return] .accept-line
# .accept-line: Accept command line.
# accept-line:  Accept selection and exit menu.

# Uncomment the following lines to disable live history search:
# zle -A {.,}history-incremental-search-forward
# zle -A {.,}history-incremental-search-backward
```

## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
