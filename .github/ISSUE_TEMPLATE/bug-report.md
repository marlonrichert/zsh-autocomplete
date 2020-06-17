---
name: Bug report
about: If you think something is broken
title: ''
labels: 'Bug report'
assignees: ''

---

### Describe the bug
<!-- A clear and concise description of what the bug is. -->

### To Reproduce
Steps to reproduce the behavior:

<!-- If you are not able to reproduce it by running `zsh -df` and sourcing the plugin manually, it
means there that the issue is caused by something in your local config file(s). Temporarily comment
out or remove sections of your config and restart `zsh` until you narrow down exactly what is
causing the issue. -->

```sh
% cd "$(mktemp -d)" # Creates a temp dir and enters it.
% ZDOTDIR=$PWD HOME=$PWD zsh -df # Starts a subshell without config files.
% source path/to/zsh-autocomplete.plugin.zsh
% ... # What do you do to reproduce?
```

### Expected behavior
<!-- A clear and concise description of what you expected to happen. -->

### Screenshots
<!-- If applicable, add screenshots to help explain your problem. -->

### Desktop
 - OS + distribution: <!-- e.g. Arch Linux 2019.07.01 -->
 - Zsh version: <!-- `echo $ZSH_VERSION` -->
 - Plugin version: <!-- git commit hash -->

### Additional context
<!-- Add any other context about the problem here. -->
