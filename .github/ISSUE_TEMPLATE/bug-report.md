---
name: Bug report
about: Always include a minimal, reproducible test case. If I cannot reproduce it, then I cannot fix it!
title: ''
labels: type::bug report
assignees: ''

---


## Environment
<!-- Run the code below and share the output. -->
```zsh
% typeset -p1 VENDOR OSTYPE ZSH_PATCHLEVEL _autocomplete__funcfiletrace
<output>
% git -C ~autocomplete log --oneline -n1
<output>
```

* Operating system: <!-- for example, 'macOS Ventura 13.4' or 'Ubuntu 22.04.2 LTS' -->
* Terminal emulator: <!-- for example, 'Terminal.app' or 'Konsole' -->


## Steps to reproduce
<!-- Update the code below to create a test case that demonstrates the problem
in an isolated environment. -->
```zsh
% cd $(mktemp -d)
% git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
<output>
% > .zshrc <<EOF
setopt interactivecomments transientrprompt
PS1='%# '
PS2=
RPS2='%^'
source $PWD/zsh-autocomplete/zsh-autocomplete.plugin.zsh
EOF
% env -i HOME=$PWD PATH=$PATH TERM=$TERM ${TERMINFO:+TERMINFO=$TERMINFO} zsh -d
% <inputs>
<output>
```

<details>
<summary>Contents of <code>~autocomplete-log/YYYY-MM-DD.log</code> (click to expand)</summary>
<pre>
<!-- Replace this line with the contents of the above log file. -->
</pre>
</details>
