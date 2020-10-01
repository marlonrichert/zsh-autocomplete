---
name: Bug report
about: Is something broken?
title: ''
labels: 'Bug report'
assignees: ''

---

# Environment
* Zsh version: <!-- 5.3 or later should work, but I test with the latest version only. -->
* `zsh-autocomplete` commit: <!-- Paste the raw number here. GitHub will make a link out of it. -->

Please report if the bug occurs without config files:
```zsh
$ cd $(mktemp -d)  # Create a temp dir and enter it.
$ ZDOTDIR=$PWD HOME=$PWD zsh -f  # Start a subshell without config files.
% source path/to/zsh-autocomplete.plugin.zsh  # Source the plugin.
% # Try to reproduce your bug...
```
Does the bug occur without config files?
* [ ] Yes
* [ ] No

If not, which combination of config causes the bug to appear?

... <!-- Write your answer here. -->

# Steps to reproduce
How can I reproduce the bug? If I cannot reproduce it, then I cannot test it and thus cannot fix
it.

Please provide concrete steps:
1. ...
2. ...

## Expected behavior
What did you expect to happen? Why?

## Actual behavior
What actually happened? Why is this a problem?
