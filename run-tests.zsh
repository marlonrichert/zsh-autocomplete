#!/bin/zsh -f
cd $( git rev-parse --show-toplevel )

git --version
typeset -p1 PWD VENDOR OSTYPE =zsh ZSH_VERSION ZSH_PATCHLEVEL
env -i HOME=$( mktemp -d ) PATH=$PATH FPATH=$FPATH zsh -f -- \
    =clitest --list-run --progress dot --prompt '%' --color always \
        -- $PWD/Tests/*.md
