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
* You need to run [`zsh`](http://zsh.sourceforge.net) as your shell and you need to have enabled "new style" completions a.k.a. `compinit`.

Optional:
* [↑ fuzzy history search](#key-bindings "up arrow") and [⌃␣ fuzzy file search](#key-bindings "ctrl + space") require that you have [`fzf`](https://github.com/junegunn/fzf) installed and have sourced its
[completion](https://github.com/junegunn/fzf/blob/master/shell/completion.zsh) and
[key-bindings](https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh) in your `.zshrc` file. `zsh-autocomplete` should be sourced _after_ these.


## Installation

**Important:**
* `zsh-autocomplete` should be sourced *after* plugins that change key bindings (such as `fzf`'s completion and key-binding plugins), but *before* plugins that wrap key binding widgets (such as
`zsh-syntax-highlighting` and `zsh-autosuggest`).
* `zsh-autocomplete` should be sourced *after* calling `compinit`.

### Manual installation
1. Clone or download this repo
1. Add the following to your `.zshrc` file:
```shell
autoload compinit && compinit
source path/to/zsh-autocomplete.plugin.zsh
```

### Using a plugin manager
Add `marlonrichert/zsh-autocomplete` as a plugin. See your plugin manager's documentation for more info.

For example, using `zinit`, add the following to your `.zshrc` file:
```shell
autoload compinit && compinit
zinit light-mode for marlonrichert/zsh-autocomplete
```

### Prezto
When using `zsh-autocomplete`, it's recommended that you do _not_ use Prezto's `completion` module. However, if you really do want to keep it, then `zsh-autocomplete` should be sourced _after_ it. See [Manual installation](#manual-installation) for further instructions.


## Author
© 2020 [Marlon Richert](/marlonrichert)


## License
This project is licensed under the MIT License - see the [LICENSE](/marlonrichert/.config/LICENSE)
file for details
