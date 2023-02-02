#!/bin/zsh -f
cd $( git rev-parse --show-toplevel )

env -i HOME=$( mktemp -d ) PATH=$PATH FPATH=$FPATH zsh -f -- \
    =clitest  --list-run --progress dot --prompt '%' \
        --pre-flight 'git --version; print $PWD $VENDOR $OSTYPE =zsh $ZSH_VERSION $ZSH_PATCHLEVEL' \
        -- $PWD/.clitest/*.md
