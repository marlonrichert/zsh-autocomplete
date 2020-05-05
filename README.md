# zsh-autocomplete
IntelliSense-like find-as-you-type completion for the Z Shell!
* Automatically lists completions as you type.
* Press Tab to insert the top match or press Down to select a different one.
* Press Shift-Tab for more choices/info.
* Press Space to correct the last word.
* Press Up to search history.
* Press Ctrl-Space to search dirs/files.

## Demo
[![asciicast](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN.svg)](https://asciinema.org/a/ZKC8EXNp1Xw1z8wjs9kVqRoJN)

## Key bindings
| Key(s) | Action |
| --- | --- |
| any | List choices (automatic) |
| [⇥](# "tab") | Complete word |
| [⇤](# "shift + tab") | List more choices/info |
| [↓](# "down arrow") | Select a choice (or down line) |
| [↑](# "up arrow") | [Fuzzy history search](#requirements) (or up line) |
| [␣](# "space") | Correct spelling + insert space |
| [⌃␣](# "ctrl + space") | [Fuzzy file search](#requirements) or expand alias |
| [⌥␣](# "alt/esc + space") | Insert space (no correction) |
| [⌥↓](# "alt/esc + down arrow") | Down line (no selection) |
| [⌥↑](# "alt/esc + up arrow") | Up line (no search) |


### Key bindings in completion menu
| Key(s) | Action |
| --- | --- |
| [↑ ↓ ← →](# "arrow keys") | Change selection |
| [↩︎](# "enter") | Insert selection and exit menu |
| [⇥](# "tab") | Insert selection and select next choice |
| [⇤](# "shift + tab") | List more choices/info |
| [⌃␣](# "ctrl + space") | Insert selection + [fuzzy file search](#requirements) |


## Requirements
Mandatory:
* You need to run [**zsh**](http://zsh.sourceforge.net) as your shell and you need to have enabled "new style" completions a.k.a. `compinit`.

Optional:
* [↑ fuzzy history search](#key-bindings "up arrow") and [⌃␣ fuzzy file search](#key-bindings "ctrl + space") require that you have [**fzf**](https://github.com/junegunn/fzf) installed and source its
[completion](https://github.com/junegunn/fzf/blob/master/shell/completion.zsh) and
[key-bindings](https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh) in your `.zshrc` file.


## Installation

1. `git clone` this repo.
1. Add the following to your `.zshrc` file:
   ```shell
   zmodload -i zsh/complist
   autoload -U compinit && compinit
   source path/to/zsh-autocomplete.plugin.zsh
   ```
   * If you already have `compinit` in your `.zshrc`, then just source `zsh-autocomplete` right after it.
   * Make sure you load `zsh/complist` _before_ `compinit`.
   * If you use any form of syntax highlighting, make sure you source it _after_ `zsh-autocomplete`.

To update, `cd` into your local repo and do `git pull`.

### Prezto
Make sure you source `zsh-autocomplete` **after** the `completion` module. You might get \
unexpected results otherwise.

## Author
© 2020 [Marlon Richert](/marlonrichert)


## License
This project is licensed under the MIT License - see the [LICENSE](/marlonrichert/.config/LICENSE)
file for details
