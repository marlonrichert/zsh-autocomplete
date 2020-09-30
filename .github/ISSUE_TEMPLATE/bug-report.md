---
name: Bug report
about: Is something broken?
title: ''
labels: 'Bug report'
assignees: ''

---

# Required reading

Try if the bug occurs without config files:
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


Try to reproduce the bug on the `dev` branch:
```zsh
$ cd path/to/zsh-autocomplete  # Go to the dir where you clone zsh-autocomplete.
$ git checkout dev  # Check out the dev branch.
% exec zsh  # Restart Zsh.
% # Try to reproduce your bug...
```
Does the bug occur on the `dev` branch?
* [ ] Yes
* [ ] No

If not, do still file a report, so I can make sure I don't break it again. :)


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


# Environment
* Zsh version: <!-- 5.3 or later should work, but I test with the latest version only. -->
* `zsh-autocomplete` commit: <!-- Paste the raw number here. GitHub will make a link out of it. -->
