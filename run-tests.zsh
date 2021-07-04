#!/bin/zsh -f
print $VENDOR $OSTYPE =zsh $ZSH_VERSION $ZSH_PATCHLEVEL =clitest
local +h -a fpath=( ${0:h}/*(-/) $fpath )
FPATH=$FPATH zsh -f =clitest --list-run --progress dot --prompt '%' -- ${0:h}/.clitest/*.md
