#!/bin/zsh -f
# Simulates Oh My Zsh's load order: `compinit` runs first and writes a comp dump, and only then is
# this plugin sourced, so the dump does not include our Completions/ functions. Checks that they are
# nevertheless available after our precmd hook has run.

cd -- ${0:A:h:h}

typeset -gi failures=0
fail() {
  print -u2 -- "FAIL: $1"
  (( failures++ ))
}

dumpdir=$HOME/omz-dump
mkdir -p -- $dumpdir

autoload -Uz compinit
compinit -d $dumpdir/compdump

[[ -v functions[_autocomplete__unambiguous] ]] &&
    fail 'function should not exist before the plugin is loaded'

source ./zsh-autocomplete.plugin.zsh
.autocomplete__compinit:precmd

for name in ${(@)$( print -l -- Completions/_autocomplete__*(N:t) )}; do
  [[ -v functions[$name] ]] ||
      fail "$name is not available after a pre-existing compinit"
done

(( failures == 0 ))
