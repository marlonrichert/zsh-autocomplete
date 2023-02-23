# Autocomplete for Zsh
Autocomplete for Zsh adds **real-time type-ahead autocompletion** to Zsh.  Find
as you type, then press <kbd>Tab</kbd> to insert the top completion or
<kbd>↓</kbd>to select another completion.

> Enjoy using this software?
[Become a sponsor!](https://github.com/sponsors/marlonrichert) 💝

[![file-search](.img/file-search.gif)](https://asciinema.org/a/377611)

<sub>(The look and feel shown in images here might not be up to date.</sub>

## Other Features
Besides autocompletion, Autocomplete comes with many other useful completion
features.

### Optimized completion config
Zsh's completion system is powerful, but hard to configure.  So, let
Autocomplete [do it for you](scripts/.autocomplete.config), while providing a
manageable list of [configuration settings](#configuration) for changing the
defaults.

### Fuzzy multi-line history search
Press <kbd>Ctrl</kbd><kbd>R</kbd> to do a real-time history search listing
multiple results.

[![history-search](.img/history-search.gif)](https://asciinema.org/a/379844)

### History menu
Press <kbd>↑</kbd> to open a menu with the last 16 history items.  If the
command line is not empty, then the contents of the command line are used to
perform a fuzzy history search.

![history menu](.img/history-menu.png)

### Multi-selection
Press <kbd>Ctrl</kbd><kbd>Space</kbd> in the completion menu or the history menu
to insert more than one item.

![multi-select](.img/multi-select.png)

### Recent dirs completion
Works out of the box with zero configuration, but also supports `zsh-z`,
`zoxide`, `z.lua`, `rupa/z.sh`, `autojump` and `fasd`.

![recent dirs](.img/recent-dirs.png)

## Key Bindings
Note that, depending on your terminal, not all keybindings might be available to
you.  Also note that, instead of <kbd>Alt</kbd>, your terminal might require you
to press <kbd>Escape</kbd>, <kbd>Option</kbd> or <kbd>Meta</kbd>.  Likewise, in
most terminals, <kbd>Enter</kbd> is interchangeable with <kbd>Return</kbd>, but
in some terminals, it is not.

On the command line:
| Key(s) | Action | <sub>[Widget](.zshrc)</sub> |
| ------ | ------ | --- |
| <kbd>Tab</kbd> | Insert top completion | <sub>`complete-word`</sub> |
| <kbd>Shift</kbd><kbd>Tab</kbd> | Insert bottom completion | <sub>`complete-word`</sub> |
| <kbd>↓</kbd> | Cursor down (if able) or completion menu | <sub>`down-line-or-select`</sub> |
| <kbd>PgDn</kbd> / <kbd>Alt</kbd><kbd>↓</kbd> | Completion menu (always) | <sub>`menu-select`</sub> |
| <kbd>↑</kbd> | Cursor up (if able) or [history menu](#history-menu) | <sub>`up-line-or-search`</sub> |
| <kbd>PgUp</kbd> / <kbd>Alt</kbd><kbd>↑</kbd> | [History menu](#history-menu) (always) | <sub>`history-search-backward`</sub> |
| <kbd>Ctrl</kbd><kbd>R</kbd> | [Live history search](#live-history-search), newest to oldest | <sub>`history-incremental-search-backward`</sub> |
| <kbd>Ctrl</kbd><kbd>S</kbd> | [Live history search](#live-history-search), oldest to newest | <sub>`history-incremental-search-forward`</sub> |

In the completion menu:
| Key(s) | Action |
| ------ | ------ |
| <kbd>↑</kbd> / <kbd>↓</kbd> / <kbd>←</kbd> / <kbd>→</kbd> | Change selection |
| <kbd>Alt</kbd><kbd>↑</kbd> | Backward one group |
| <kbd>Alt</kbd><kbd>↓</kbd> | Forward one group |
| <kbd>PgUp</kbd> / <kbd>PgDn</kbd> | Page up/down |
| <kbd>Ctrl</kbd><kbd>R</kbd> | Find text forward |
| <kbd>Ctrl</kbd><kbd>S</kbd> | Find text backward |
| <kbd>Tab</kbd> | Insert selection and exit menu |
| <kbd>Ctrl</kbd><kbd>Space</kbd> | Insert selection, but stay in menu |
| <kbd>Shift</kbd><kbd>Tab</kbd> | Insert bottom completion and exit menu |
| <kbd>Ctrl</kbd><kbd>-</kbd><br><kbd>Ctrl</kbd><kbd>/</kbd> | Undo and exit menu |
| <kbd>Enter</kbd> | Submit command line |
| other keys | Zsh [default behavior](https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#Menu-selection) |

In the history menu:
| Key(s) | Action |
| --- | --- |
| <kbd>↑</kbd> / <kbd>↓</kbd> | Change selection |
| <kbd>Tab</kbd> | Insert selection and exit menu |
| <kbd>Ctrl</kbd><kbd>Space</kbd> | Insert selection, but stay in menu |
| <kbd>Ctrl</kbd><kbd>-</kbd><br><kbd>Ctrl</kbd><kbd>/</kbd> | Undo and exit menu |
| <kbd>Enter</kbd> | Submit command line |
| other keys | Zsh [default behavior](https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#Menu-selection) |

## Requirements
Recommended:
* Tested to work with [Zsh](http://zsh.sourceforge.net) 5.8 and newer.

Minimum:
* Should theoretically work with Zsh 5.4, but I'm unable to test that.

## Installing & Updating
If you use [Znap](https://github.com/marlonrichert/zsh-snap), simply add the
following to your `.zshrc` file:
```zsh
znap source marlonrichert/zsh-autocomplete
```
Then restart your shell.

To update, do
```zsh
% znap pull
```

To uninstall, remove `znap source marlonrichert/zsh-autocomplete` from your
`.zshrc` file, then run
```zsh
% znap uninstall
```

### Manual installation
 1. Clone the repo:
    ```zsh
    % cd ~/Git  # ...or wherever you keep your Git repos/Zsh plugins
    % git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
    ```
 1.  Add at or near the top of your `.zshrc` file (_before_ any calls to
    `compdef`):
    ```zsh
    source ~/Git/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    ```
 1. Remove any calls to `compinit` from your `.zshrc` file.
 1. Restart your shell.

To update, do:
```zsh
% git -C ~zsh-autocomplete pull
```

To uninstall, simply undo the installation steps above in reverse order:
 1. Restore the lines you deleted in step 3.
 1. Delete the line you added in step 2.
 1. Delete the repo you created in step 1.
 1. Restart your shell.

### Other frameworks/plugin managers
To install with another Zsh framework or plugin manager, please refer to your
framework's/plugin manager's documentation for instructions.  When in doubt,
install [manually](#manually).

### Additional step for Ubuntu
If you're using Ubuntu, you additionally need to add the following to your
`.zshenv` file:
```zsh
skip_global_compinit=1
```

## Troubleshooting
Try the steps in the
[bug report template](.github/ISSUE_TEMPLATE/bug-report.md).

## Configuration
The following are the most commonly requested ways to configure Autocomplete's
behavior.  Add these to your `.zshrc` file to use them.

```zsh
# The code below sets all of Autocomplete's settings to their default values. To
# change a setting, copy it into your `.zshrc` file and modify it there.


zstyle ':autocomplete:*' default-context ''
# '': Start each new command line with normal autocompletion.
# history-incremental-search-backward: Start in live history search mode.

zstyle ':autocomplete:*' min-delay 0.05  # seconds (float)
# Wait this many seconds for typing to stop, before showing completions.

zstyle ':autocomplete:*' min-input 1  # characters (int)
# Wait until this many characters have been typed, before showing completions.

zstyle ':autocomplete:*' ignored-input '' # extended glob pattern
# '':     Always show completions.
# '..##': Don't show completions for the current word, if it consists of two
#         or more dots.

zstyle ':autocomplete:*' list-lines 16  # int
# If there are fewer than this many lines below the prompt, move the prompt up
# to make room for showing this many lines of completions (approximately).

zstyle ':autocomplete:history-search:*' list-lines 16  # int
# Show this many history lines when pressing ↑.

zstyle ':autocomplete:history-incremental-search-*:*' list-lines 16  # int
# Show this many history lines when pressing ⌃R or ⌃S.

zstyle ':autocomplete:*' insert-unambiguous no
# no:  Tab inserts the top completion.
# yes: Tab first inserts a substring common to all listed completions, if any.

zstyle ':autocomplete:*' fzf-completion no
# no:  Tab uses Zsh's completion system only.
# yes: Tab first tries Fzf's completion, then falls back to Zsh's.
# ⚠️ NOTE: This setting can NOT be changed at runtime and requires that you
# have installed Fzf's shell extensions.

# Add a space after these completions:
zstyle ':autocomplete:*' add-space \
    executables aliases functions builtins reserved-words commands


##
# Config in this section should come BEFORE sourcing Autocomplete and cannot be
# changed at runtime.
#

# Autocomplete automatically selects a backend for its recent dirs completions.
# So, normally you won't need to change this.
# However, you can set it if you find that the wrong backend is being used.
zstyle ':autocomplete:recent-dirs' backend cdr
# cdr:  Use Zsh's `cdr` function to show recent directories as completions.
# no:   Don't show recent directories.
# zsh-z|zoxide|z.lua|z.sh|autojump|fasd: Use this instead (if installed).
# ⚠️ NOTE: This setting can NOT be changed at runtime.

zstyle ':autocomplete:*' widget-style complete-word
# complete-word: (Shift-)Tab inserts the top (bottom) completion.
# menu-complete: Press again to cycle to next (previous) completion.
# menu-select:   Same as `menu-complete`, but updates selection in menu.
# ⚠️ NOTE: This setting can NOT be changed at runtime.


source /path/to/zsh-autocomplete.plugin.zsh


##
# Config in this section should come AFTER sourcing Autocomplete.
#

# Up arrow:
bindkey '\e[A' up-line-or-search
bindkey '\eOA' up-line-or-search
# up-line-or-search:  Open history menu.
# up-line-or-history: Cycle to previous history line.

# Down arrow:
bindkey '\e[B' down-line-or-select
bindkey '\eOB' down-line-or-select
# down-line-or-select:  Open completion menu.
# down-line-or-history: Cycle to next history line.

# Uncomment the following lines to disable live history search:
# zle -A {.,}history-incremental-search-forward
# zle -A {.,}history-incremental-search-backward

# Return key in completion menu & history menu:
bindkey -M menuselect '\r' .accept-line
# .accept-line: Accept command line.
# accept-line:  Accept selection and exit menu.

```

## Author
© 2020-2023 [Marlon Richert](https://github.com/marlonrichert)

## License
This project is licensed under the MIT License.  See the [LICENSE](LICENSE) file
for details.
