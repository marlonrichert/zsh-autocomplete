#!/bin/zsh -f
print $OSTYPE $SHELL $ZSH_VERSION $ZSH_PATCHLEVEL =clitest
local +h -a fpath=( ${0:h}/*(-/) $fpath )
FPATH=$FPATH $SHELL -f =clitest --list-run --progress dot --prompt '%' -- ${0:h}/.clitest/*.md
