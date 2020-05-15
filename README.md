# zsh-autocomplete
IntelliSense-like find-as-you-type completion for the Z Shell!
* Automatically lists completions as you type.
* Press **`⇥`tab** to insert the top match or press **`↓`down to select a different
  one.
* Press **`⇤`shift-tab** for more choices/info.
* Press **`␣`space** to correct the last word or do
  [history expansion](http://zsh.sourceforge.net/Doc/Release/Expansion.html#History-Expansion).
* Press **`↑`up** to search history.
* Press **`⌃␣`ctrl-space** to search dirs/files.


## Demo
[![asciicast](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN.svg)](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN)


## Key Bindings
`zsh-autocomplete` adds intuitive key bindings for both the command line and the completion menu.

### On Command Line
| Key(s) | Action |
| --- | --- |
| any | List choices (automatic) |
| `⇥`tab | Insert top match |
| `⇤`shift-tab | List more choices/info |
| `↓`down | Menu select or down line |
| `↑`up | [Fuzzy history search](#requirements) or up line |
| `␣`space | Correct spelling + history expansion + insert space |
| `⌃␣`ctrl-space | [Fuzzy file search](#requirements) or expand alias |
| `⌥␣`alt-space | Insert space (no correction or expansion) |
| `⌥↓`alt-down | Menu select in multi-line buffer |
| `⌥↑`alt-up | [Fuzzy history search](#requirements) in multi-line buffer |

### In Completion Menu
| Key(s) | Action |
| --- | --- |
| `↑ ↓ ← →` | Change selection |
| `␣`space | Insert single match + insert space (exit menu) |
| `↩︎`enter | Insert single match (exit menu) |
| `⇥`tab | Insert multiple matches (stay in menu) |
| `⇤`shift-tab | List more choices/info (does not work in "corrections" menu) |
| `⌃␣`ctrl-space | Insert single match + [fuzzy file search](#requirements) |
| other | Insert single match + insert character (exit menu) |


## Requirements
Mandatory:
* [**zsh**](http://zsh.sourceforge.net) needs to be your shell.

Recommended:
* [**fzf**](https://github.com/junegunn/fzf) and
  [its **shell extensions**](https://github.com/junegunn/fzf#installation) are required for
  [**`↑`** fuzzy history search](#key-bindings) and
  [**`⌃␣`** fuzzy file search](#key-bindings).
  * **Note:** It's _not_ enough for `fzf` to be in your path! You will also need to source its
    shell extensions in your `.zshrc` file.


## Installation

There's two ways to install `zsh-autocomplete`:

### As a Plugin
Please refer to your plugin manager's documentation for instructions.

**Note** for Prezto users: You need you load `zsh-autocomplete` _after or instead of_
Prezto's built-in `completion` module.

### Manually
1. `git clone` this repo.
1. If you want to use [**`↑`** fuzzy history search](#key-bindings) and
   [**`⌃␣`** fuzzy file search](#key-bindings):
   1. Make sure you have [`fzf`](https://github.com/junegunn/fzf) installed.
   1. Source [`fzf`'s shell extensions](https://github.com/junegunn/fzf#installation).
  1. Add the following to your `.zshrc` file:
   ```shell
   source path/to/zsh-autocomplete.zsh
   _zsh_autocomplete__main
   ```
     **Note** that you should source the file that does **not** have the word d`plugin` in its name.

If you use any form of syntax highlighting, you have to source that _after_ `zsh-autocomplete`.

To update, `cd` into `zsh-autocomplete`'s directory and do `git pull`.


## Customization

The behavior of `zsh-autocomplete` is highly configurable. Here are just some of the modifications
that are commonly requested.

**Note:** To use these, add them in your `.zshrc` file **after** sourcing `zsh-autocomplete`.

### Always show group names
By default, group names and duplicate entries are shown only when you press **`⇤`shift-tab**.
This allows the automatic listing of completion matches to be as compact as possible.

If instead, you want group names (and thus duplicate entries) to always be shown, use the
following:
```shell
zstyle ':completion:*' format '%F{yellow}%d:%f'
zstyle ':completion:*' group-name ''
```
You can replace `yellow` with `black`, `red`, `green`, `blue`, `magenta`, `cyan`, `white` or a
3-digit `#hex` value.

### Turn off automatic spelling correction
By default, **`␣`space** corrects your spelling and does history expansions.

To remove the spell-checking part, use this:
```shell
zstyle ':completion:correct-word:*' max-errors 0
```

### Use `⇥`tab to cycle matches
By default, **`⇥`tab** inserts the top match. The idea is that you just keep typing until the
match you want is
* at the top, at which point you press **`⇥`tab** to insert it, or
* near the top, ([if you have `fzf` installed](#requirements),) at which point you press
  **`↓`down** to enter the menu, navigate to it with the **`↑ ↓ ← →`arrow keys** and
  press **`↩︎`enter** to insert it.

If instead you want **`⇥`tab** to cycle between matches _without_ entering the menu, use this:
```shell
zle -N complete-word && complete-word() { zle .complete-word; }
```

### Use `⇥`tab and `⇤`shift-tab to navigate the menu
By default,
* **`↑ ↓ ← →`arrow keys** navigate the menu,
* **`⇥`tab** does multi-selection and
* **`⇤`shift-tab** shows you more matches and/or more info.

If you want to use **`⇥`tab** and **`⇤`shift-tab** to navigate the menu, use this:
```shell
add-zsh-hook -d precmd _zsh_autocomplete__h__keymap-specific_keys
bindkey -M menuselect $key[Tab] menu-complete
bindkey -M menuselect $key[BackTab] reverse-menu-complete
```


## Author
© 2020 [Marlon Richert](https://github.com/marlonrichert)


## License
This project is licensed under the MIT License. See the [LICENSE](/marlonrichert/.config/LICENSE)
file for details.
