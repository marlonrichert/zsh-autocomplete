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


## Key bindings on the command line
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

### Key bindings in the completion menu
| Key(s) | Action |
| --- | --- |
| [↑ ↓ ← →](# "arrow keys") | Change selection |
| [↩︎](# "enter") | Insert selection and exit menu |
| [⇥](# "tab") | Insert selection and select next choice |
| [⇤](# "shift + tab") | List more choices/info |
| [⌃␣](# "ctrl + space") | Insert selection + [fuzzy file search](#requirements) |


## Requirements
Mandatory:
* [**zsh**](http://zsh.sourceforge.net) needs to be your shell.

Optional:
* [**fzf**](https://github.com/junegunn/fzf) and
  [its **shell extensions**](https://github.com/junegunn/fzf#installation) are required for
  [↑ fuzzy history search](#key-bindings "up arrow") and
  [⌃␣ fuzzy file search](#key-bindings "ctrl + space").
  * **Note:** It's _not_ enough for `fzf` to be in your path! You will also need to source its
    shell extensions in your `.zshrc` file.


## Installation

1. `git clone` this repo.
1. Add the following to your `.zshrc` file:
   ```shell
   source path/to/zsh-autocomplete.plugin.zsh
   ```
   * If you use any form of syntax highlighting, make sure you source it _after_
     `zsh-autocomplete`.
   * If you want to use [↑ fuzzy history search](#key-bindings "up arrow") and
     [⌃␣ fuzzy file search](#key-bindings "ctrl + space"), make sure you also source
     [`fzf`'s shell extensions](https://github.com/junegunn/fzf#installation).

To update, `cd` into your local repo and do `git pull`.

### Prezto
Make sure you source `zsh-autocomplete` **after** the `completion` module. You might get \
unexpected results otherwise.


## Author
© 2020 [Marlon Richert](/marlonrichert)


## License
This project is licensed under the MIT License - see the [LICENSE](/marlonrichert/.config/LICENSE)
file for details
