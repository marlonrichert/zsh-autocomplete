#!/bin/zsh -f
print $ZSH_PATCHLEVEL
local +h -a fpath=( ${0:h}/*(-/) $fpath )
FPATH=$FPATH zsh -f =clitest --list-run --progress dot --prompt '%' -- ${0:h}/.clitest/*.md
