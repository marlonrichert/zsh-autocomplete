#!/bin/zsh -f
cd $( git rev-parse --show-toplevel )

git --version
print =zsh
typeset -p1 VENDOR OSTYPE ZSH_VERSION ZSH_PATCHLEVEL

env -i HOME=$( mktemp -d ) PATH=$PATH FPATH=$FPATH zsh -f -- \
    clitest/clitest --list-run --progress dot --prompt '%' --color always \
        -- $PWD/Tests/*.md

for test_script in $PWD/Tests/*.test.zsh(N); do
  print "=$test_script"
  env -i HOME=$( mktemp -d ) PATH=$PATH FPATH=$FPATH zsh -f -- "$test_script" ||
      exit 1
done
