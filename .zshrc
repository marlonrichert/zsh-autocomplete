#!/bin/zsh

# The code below sets all of `zsh-autocomplete`'s settings to their default values. To change a
# setting, copy it into your `.zshrc` file.


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


source /path/to/zsh-autocomplete.plugin.zsh
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
