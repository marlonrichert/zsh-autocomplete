---
name: Bug report
about: Is something broken?
title: ''
labels: 'Bug report'
assignees: ''

---

## Environment
* `zsh-autocomplete` version: ???<!-- Paste the raw commit hash here. GitHub will link it. -->
* Zsh version: ???<!-- 5.3 or later should work, but I test with the latest version only. -->
* Framework: ??? <!-- Oh My Zsh, Prezto, Zimfw… or just "none" -->
* `~/.zshrc` file: ??? <!-- Link to your `~/.zshrc` file, if you have it online. -->

Please test if the bug occurs without config files:
```zsh
$ cd $(mktemp -d)  # Create a temp dir and enter it.
$ ZDOTDIR=$PWD HOME=$PWD zsh -f  # Start a subshell in it without config files.
% source path/to/zsh-autocomplete.plugin.zsh  # Source the plugin.
% # Try to reproduce your bug...
```
Does the bug occur without config files?
* ???<!-- Write your answer here. -->

If not, gradually add lines from your config file to the subshell until the bug appears.

Which combination of config causes the bug to appear?
* ???<!-- Write your answer here. -->

## Steps to reproduce
<!-- How can I reproduce the bug?
If I cannot reproduce it, then I cannot test it and thus cannot fix it.
Please provide concrete steps: -->
1. ???
2. ...

### Expected behavior
???<!-- What did you expect to happen? Why? -->

### Actual behavior
???<!-- What actually happened? Why is this a problem? -->
