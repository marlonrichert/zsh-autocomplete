---
name: Bug report
about: Is something broken?
title: ''
labels: 'bug'
assignees: ''

---

* `zsh-autocomplete` version: <!-- `git rev-parse HEAD` -->
* Zsh version: <!-- `print $ZSH_PATCHLEVEL` -->
* Framework: <!-- Oh My Zsh, Prezto, Zimfw... or just "none" -->
* Plugin manager: <!-- Znap, Zinit, Antigen... or just "none" -->

<!-- Please use the following template to put together a minimal test case with which I can
reproduce the bug. If I cannot reproduce the bug, then I cannot fix it! -->
```zsh
$ cd $(mktemp -d)  # Create a temp dir and enter it.
$ ZDOTDIR=$PWD HOME=$PWD zsh -f  # Start a subshell in it without config files.
% source path/to/zsh-autocomplete.plugin.zsh  # Source the plugin.
% <steps to reproduce>
```
