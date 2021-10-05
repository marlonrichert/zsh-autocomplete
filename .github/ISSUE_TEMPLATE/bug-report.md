---
name: Bug report
about: Is something broken?
title: ''
labels: 'bug'
assignees: ''

---

<!-- Describe your problem here, then complete the next two sections. -->

### Environment
<!-- Replace the contents of this block with the output of the commands below: -->
```zsh
git -C ~zsh-autocomplete log --oneline -n1
print -l $_autocomplete__funcfiletrace
print $VENDOR $OSTYPE $SHELL $ZSH_ARGZERO $ZSH_PATCHLEVEL
```

### Steps to reproduce
<!-- Run the following commands: -->
```zsh
cd $(mktemp -d)
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
> .zshrc <<EOF
PS1="%# " PS2="  "; setopt transientrprompt
source ~/zsh-autocomplete/zsh-autocomplete.plugin.zsh
EOF
env -i HOME=$PWD PATH=$PATH FPATH=$FPATH TERM=$TERM zsh -d
```
<!--
In the shell created above, try to reproduce your problem.
Once you're done, copy-paste your entire shell session into the block above.
-->
