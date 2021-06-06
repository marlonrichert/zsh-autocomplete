---
name: Bug report
about: Is something broken?
title: ''
labels: 'bug'
assignees: ''

---

* `zsh-autocomplete` version: <!-- git -C ~zsh-autocomplete rev-parse @ -->
* Zsh version: <!-- print $ZSH_PATCHLEVEL -->
* Framework: <!-- Oh My Zsh, Prezto, Zimfw, etc. or just "none" -->
* Plugin manager: <!-- Znap, Zinit, Antigen, etc. or just "none" -->
* Operating system: <!-- print $OSTYPE -->

 1. Paste the following into your terminal and <kbd>Enter</kbd>:
    ```zsh
    cd $(mktemp -d)
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
    print '
    PS1="%# " PS2="  " RPS2="< %^"; setopt transientrprompt
    source zsh-autocomplete/zsh-autocomplete.plugin.zsh
    ' > .zshrc
    exec env -i HOME=$PWD TERM=$TERM SHELL=$SHELL $SHELL -d
    ```
 1. In the shell session created above, try to reproduce your problem and
    record all of it here:
    ```zsh
    % # Copy-paste your shell session here.
    ```
