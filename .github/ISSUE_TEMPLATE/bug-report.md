---
name: Bug report
about: Is something broken?
title: ''
labels: 'Bug report'
assignees: ''

---

### Describe the bug
<!-- A clear and concise description of what the bug is. -->

### To Reproduce
Steps to reproduce the behavior:

<!-- IMPORTANT: If you are not able to reproduce it by running `zsh -df` and sourcing the plugin
manually, it means there that the issue is caused by something in your local config file(s).
Paste lines from your `.zshrc` file into the subshell below until you narrow down exactly what is
causing the issue. -->

```shell
# *Always* test with the following three steps:
$ cd "$(mktemp -d)"  # Create a temp dir and enter it
$ ZDOTDIR=$PWD HOME=$PWD zsh -df  # Start a subshell without config files
% source path/to/zsh-autocomplete.plugin.zsh
% # Insert your steps here
```

### Expected behavior
<!-- A clear and concise description of what you expected to happen. -->

### Actual behavior
<!-- If applicable, add screenshots or other output to help explain your problem. -->

### Desktop
 - OS + distribution: <!-- e.g. Arch Linux 2019.07.01 -->
 - Zsh version: <!-- echo $ZSH_VERSION -->
 - Plugin version: <!-- git commit hash -->

### Additional context
<!-- Add any other context about the problem here. -->
