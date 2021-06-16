---
name: Bug report
about: Is something broken?
title: ''
labels: 'bug'
assignees: ''

---

* `zsh-autocomplete` version: <!-- git -C ~zsh-autocomplete rev-parse @ -->
* Zsh version: <!-- print =zsh $ZSH_PATCHLEVEL -->
* Framework: <!-- Oh My Zsh, Prezto, Zimfw, etc. or just "none" -->
* Plugin manager: <!-- Znap, Zinit, Antigen, etc. or just "none" -->
* Operating system: <!-- print $OSTYPE -->

 1. Paste the following into your terminal and press <kbd>Enter</kbd>:
    ```zsh
    cd $(mktemp -d)
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
    print 'PS1="%# " PS2="  " RPS2="< %^"; setopt transientrprompt
    source ~/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    ' > .zshrc
    SHELL==zsh
    exec -c zsh -fc "HOME=$PWD SHELL=$SHELL TERM=$TERM exec $SHELL -d"
    ```
 1. Once you're able to reproduce your problem in the shell session created
    above, copy-paste the contents of your terminal here:
    ```zsh
    % # Copy-paste your shell session here.
    ```
