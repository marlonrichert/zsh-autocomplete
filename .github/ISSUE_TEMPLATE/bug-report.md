---
name: Bug report
about: Always include a minimal, reproducible test case. If I cannot reproduce it, then I cannot fix it!
title: ''
labels: 'bug'
assignees: ''

---

- [ ] I have carefully read all of the instructions in this issue template.
- [ ] I have carried them out to the letter.

Failure to do so can result in your issue being closed.

## Environment
```zsh
typeset -p1 VENDOR OSTYPE SHELL ZSH_ARGZERO ZSH_PATCHLEVEL _autocomplete__funcfiletrace
git -C ~autocomplete log --oneline -n1
```

* Operating system: <!-- e.g. macOS, Ubuntu -->
* Terminal emulator: <!-- e.g. Terminal.app, Konsole -->

- [ ] I have filled out the fields above.
- [ ] I have ran the commands in the code block above.
- [ ] I have pasted their output into the same block.

## Steps to reproduce
```zsh
cd $(mktemp -d)
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
> .zshrc <<EOF
PS1='%# ' PS2= RPS2='%^'; setopt transientrprompt interactivecomments
source ~/zsh-autocomplete/zsh-autocomplete.plugin.zsh
EOF
env -i HOME=$PWD PATH=$PATH TERM=$TERM ${TERMINFO:+TERMINFO=$TERMINFO} zsh -d
```
- [ ] I have run the code block above to create a test environment.
- [ ] I have reproduced my problem in this environment in the most minimal way possible.
- [ ] I have copy-pasted my entire test session into the same code block.
- [ ] I have copy-pasted the content of the log files found in the `~autocomplete-log` dir of the above session into
  their respective sections below.

<details>
<summary><code>YYYY-MM-DD.log</code> (click to expand)</summary>
<pre>
<!-- Replace this line with the contents of the above log file. -->
</pre>
</details>

<details>
<summary><code>YYYY-MM-DD_async.log</code> (click to expand)</summary>
<pre>
<!-- Replace this line with the contents of the above log file. -->
</pre>
</details>

<details>
<summary><code>YYYY-MM-DD_pty.log</code> (click to expand)</summary>
<pre>
<!-- Replace this line with the contents of the above log file. -->
</pre>
</details>
