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

<!-- ⚠️ DO NOT DELETE the template below. Instead, use it to put together a minimal test case with
which I can reproduce the bug. If I cannot reproduce the bug, then I cannot fix it! -->
```zsh
$ git -C ~zsh-autocomplete switch main  # Make sure you test with the `main` branch.
$ git -C ~zsh-autocomplete pull         # Update to the latest commit.
$ cd $(mktemp -d)                       # Create a temp dir and enter it.
$ unset _comp_dumpfile ZDOTDIR XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME
$ HOME=$PWD exec zsh -f       # Restart Zsh without config files in this dir.
% source /path/to/zsh-autocomplete/zsh-autocomplete.plugin.zsh
% 👉YOUR STEPS TO REPRODUCE👈  # Test and document the steps to reproduce the problem.
```
<!-- ⚠️ Don't forget to add your steps to reproduce at the end of the template above. -->
