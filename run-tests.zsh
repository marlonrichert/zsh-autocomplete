#!/bin/zsh -f
cd $( git rev-parse --show-toplevel )

git --version
print =zsh
typeset -p1 PWD VENDOR OSTYPE ZSH_VERSION ZSH_PATCHLEVEL
env -i HOME=$( mktemp -d ) PATH=$PATH FPATH=$FPATH zsh -f -- \
    =clitest --list-run --progress dot --prompt '%' --color always \
        -- $PWD/Tests/*.md
