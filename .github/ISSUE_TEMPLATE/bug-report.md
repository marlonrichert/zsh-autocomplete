---
name: Bug report
about: Is something broken?
title: ''
labels: 'bug'
assignees: ''

---

<!--
Please read all of the steps below very carefully and follow them to the letter.
If I cannot reproduce your problem, then I cannot fix it.
-->

### Environment
<!-- Replace the contents of this block with the output of the commands below: -->
```zsh
print $VENDOR $OSTYPE $SHELL $ZSH_ARGZERO $ZSH_PATCHLEVEL
print -l $_autocomplete__funcfiletrace
git -C ~zsh-autocomplete log --oneline -n1
```

### Steps to reproduce
<!-- Run the following commands: -->
```zsh
cd $(mktemp -d)
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
> .zshrc <<EOF
PS1='%# ' PS2= RPS2='%^'; setopt transientrprompt interactivecomments
source ~/zsh-autocomplete/zsh-autocomplete.plugin.zsh
EOF
env -i HOME=$PWD PATH=$PATH TERM=$TERM ${TERMINFO:+TERMINFO=$TERMINFO} zsh -d
```
<!--
In the shell created above, try to reproduce your problem.
Once you're done, copy-paste your entire shell session into the block above.
-->
