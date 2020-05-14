# zsh-autocomplete
IntelliSense-like find-as-you-type completion for the Z Shell!
* Automatically lists completions as you type.
* Press [`⇥`](# "tab") to insert the top match or press [`↓`](# "down arrow") to select a different one.
* Press [`⇤`](# "shift + tab") for more choices/info.
* Press [`␣`](# "space") to correct the last word or do
  [history expansion](http://zsh.sourceforge.net/Doc/Release/Expansion.html#History-Expansion).
* Press [`↑`](# "up arrow") to search history.
* Press [`⌃␣`](# "ctrl + space") to search dirs/files.


## Demo
[![asciicast](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN.svg)](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN)


## Key Bindings
`zsh-autocomplete` adds intuitive key bindings for both the command line and the completion menu.

### On Command Line
| Key(s) | Action |
| --- | --- |
| any character | List choices (automatic) |
| [`⇥`](# "tab") | Insert top match |
| [`⇤`](# "shift + tab") | List more choices/info |
| [`↓`](# "down arrow") | Menu select or down line |
| [`↑`](# "up arrow") | [Fuzzy history search](#requirements) or up line |
| [`␣`](# "space") | Correct spelling + history expansion + insert space |
| [`⌃␣`](# "ctrl + space") | [Fuzzy file search](#requirements) or expand alias |
| [`⌥␣`](# "alt/esc + space") | Insert space (no correction or expansion) |
| [`⌥↓`](# "alt/esc + down arrow") | Down line (no select) |
| [`⌥↑`](# "alt/esc + up arrow") | Up line (no search) |

### In Completion Menu
| Key(s) | Action |
| --- | --- |
| [`↑ ↓ ← →`](# "arrow keys") | Change selection |
| any character | Insert single match + insert character (exit menu) |
| [`␣`](# "space") | Insert single match + insert space (exit menu) |
| [`↩︎`](# "enter") | Insert single match (exit menu) |
| [`⇥`](# "tab") | Insert multiple matches (stay in menu) |
| [`⇤`](# "shift + tab") | List more choices/info (does not work in "corrections" menu) |
| [`⌃␣`](# "ctrl + space") | Insert single match + [fuzzy file search](#requirements) |


## Requirements
Mandatory:
* [**zsh**](http://zsh.sourceforge.net) needs to be your shell.

Recommended:
* [**fzf**](https://github.com/junegunn/fzf) and
  [its **shell extensions**](https://github.com/junegunn/fzf#installation) are required for
  [↑ fuzzy history search](#key-bindings "up arrow") and
  [⌃␣ fuzzy file search](#key-bindings "ctrl + space").
  * **Note:** It's _not_ enough for `fzf` to be in your path! You will also need to source its
    shell extensions in your `.zshrc` file.


## Installation

There's three ways to install `zsh-autocomplete`:

### Plug and Play
Choose this if you want that **It Just Works**.
1. `git clone` this repo.
1. If you want to use [↑ fuzzy history search](#key-bindings "up arrow") and
   [⌃␣ fuzzy file search](#key-bindings "ctrl + space"):
   1. Make sure you have [fzf](https://github.com/junegunn/fzf) installed.
   1. Source [`fzf`'s shell extensions](https://github.com/junegunn/fzf#installation).
1. Add the following to your `.zshrc` file :
   ```shell
   source path/to/zsh-autocomplete.plugin.zsh
   ```
   **Note** that the file name has the word **plugin** in it.

If you use any form of syntax highlighting, you have to source it _after_ `zsh-autocomplete`.

To update, `cd` into your local repo and do `git pull`.

### As a Plugin
Installing `zsh-autocomplete` as a plugin through a Zsh framework or plugin manager leads to the
same results as using [Plug and Play installation](#plug-and-play). Please refer to your framework
or plugin manager's documentation for instructions.

### Manual Override
Choose this if you want total control over everything.

1. Complete [steps 1 and 2 of the Plug and Play instructions](#plug-and-play).
1. Add the following to your `.zshrc` file:
   ```shell
   source path/to/zsh-autocomplete.zsh
   ```
   **Note** that the file name does **not** have the word plugin in it.
1. In that file, look at `_zsh_autocomplete__main()` to see how to get started.


## Configuration

The behavior of `zsh-autocomplete` can be customized greatly. Here are just some of the things that
are commonly requested.

**Note:** To use these, add them in your `.zshrc` file **after** sourcing `zsh-autocomplete`.

### Turn off automatic spelling correction
By default, [␣](# "space")
* corrects your spelling and
* does history expansions.

To remove the spell-checking part, use this:
```shell
zstyle ':completion:correct-word:*' tag-order '-'
```

### Use [⇥](# "tab") to cycle matches
By default, [⇥](# "tab") inserts the top match. The idea is that you just keep typing until the
match you want is
* at the top, at which point you press [⇥](# "tab") to insert it, or
* ([if you have `fzf` installed](#requirements)) near the top, at which point you press
  [↓](# "down arrow") to enter the menu, navigate to it with [↑ ↓ ← →](# "arrow keys") and press
  [↩︎](# "enter") to insert it.

If instead you want [⇥](# "tab") to cycle between matches _without_ entering the menu, use this:
```shell
zle -N complete-word && complete-word() { zle .complete-word; }
```

### Use [⇥](# "tab") and [⇤](# "shift + tab") to navigate the menu
By default,
* [↑ ↓ ← →](# "arrow keys") navigate the menu,
* [⇥](# "tab") does multi-selection and
* [⇤](# "shift + tab") shows you more matches and/or more info.

If you want to use [⇥](# "tab") and [⇤](# "shift + tab") to navigate the menu, use this:
```shell
add-zle-hook-widget -d line-init _zsh_autocomplete__h__keymap-specific_keys
bindkey -M menuselect $key[Tab] menu-complete
bindkey -M menuselect $key[BackTab] reverse-menu-complete
```


## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)


## License
This project is licensed under the MIT License. See the [LICENSE](/marlonrichert/.config/LICENSE)
file for details.
