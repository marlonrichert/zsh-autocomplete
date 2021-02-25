---
name: Bug report
about: Is something broken?
title: ''
labels: 'bug'
assignees: ''

---

* `zsh-autocomplete` version: <!-- `git -C /path/to/zsh-autocomplete rev-parse --short HEAD` -->
* Zsh version: <!-- `print $ZSH_PATCHLEVEL` -->
* Framework: <!-- Oh My Zsh, Prezto, Zimfw, etc. or just "none" -->
* Plugin manager: <!-- Znap, Zinit, Antigen, etc. or just "none" -->

<!-- Please use the following template to put together a minimal test case with which I can
reproduce the bug. If I cannot reproduce the bug, then I cannot fix it! -->
```zsh
# Go to your clone of the `zsh-autocomplete` repo.
$ cd /path/to/zsh-autocomplete

 # Make sure you always test with the `main` branch.
$ git checkout main

# Update to the latest commit.
$ git pull

# Create a temp dir and enter it.
$ cd $(mktemp -d)

# Restart Zsh without config files in this dir.
$ ZDOTDIR=$PWD HOME=$PWD exec zsh -f

# Source the plugin.
% source /path/to/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Test and document the steps that reproduce the problem.
% <steps to reproduce>
```
