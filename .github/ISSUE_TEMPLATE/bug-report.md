---
name: Bug report
about: Is something broken?
title: ''
labels: 'bug'
assignees: ''

---

* Operating system: <!-- print $OSTYPE -->
* Zsh version: <!-- print $ZSH_PATCHLEVEL -->
* Framework: <!-- Oh My Zsh, Prezto, Zimfw, etc. or just "none" -->
* Plugin manager: <!-- Znap, Zinit, Antigen, etc. or just "none" -->
* `zsh-autocomplete` version: <!-- git -C ~zsh-autocomplete rev-parse @ -->

<!-- ⚠️ DO NOT DELETE the template below. Instead, use it to put together a minimal test case with
which I can reproduce the bug. If I cannot reproduce the bug, then I cannot fix it! -->
```zsh
$ cd ~zsh-autocomplete
$ git switch main       # Make sure you test with the `main` branch.
$ git pull              # Update to the latest commit.
$ cd $(mktemp -d)       # Create a temp dir and enter it.
$ # Restart Zsh without config files or environment variables in this dir:
$ exec env -i HOME=$PWD PS1='%# ' TERM=$TERM zsh -f
% source /path/to/zsh-autocomplete/zsh-autocomplete.plugin.zsh
% ⚠️INSERT YOUR STEPS THAT REPRODUCE THE PROBLEM⚠️
```
<!-- ⚠️ Don't forget to add your steps to reproduce at the end of the template above. -->
