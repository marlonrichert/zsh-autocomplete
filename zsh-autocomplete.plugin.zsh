#!/bin/zsh

setopt NO_flowcontrol NO_singlelinezle
() {
  emulate -L zsh -o NO_aliases
  zmodload -Fa zsh/parameter p:functions

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-off] ]] &&
    .zinit-shade-off "${___mode:-load}"

  typeset -gHa _autocomplete__options=(
    localoptions extendedglob clobber
    NO_banghist NO_listbeep NO_shortloops NO_warncreateglobal
  )
  setopt $_autocomplete__options

  local basedir=${${(%):-%x}:h}
  if ! [[ -n $basedir && -d $basedir ]]; then
    print -u2 -- 'zsh-autocomplete: Failed to find base dir. Aborting.'
    return 66
  fi
  hash -d zsh-autocomplete=$basedir
  typeset -gU FPATH fpath=( ~zsh-autocomplete/completion $fpath[@] )

  local -a funcs=( ~zsh-autocomplete/{utility,widget}/.autocomplete.*~*.zwc(N-.:a) )
  if ! (( $#funcs )); then
    print -u2 -- 'zsh-autocomplete: Failed to find functions. Aborting.'
    return 66
  fi
  builtin autoload -Uz $funcs[@]

  source ~zsh-autocomplete/module/.autocomplete.__init__

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-on] ]] &&
    .zinit-shade-on "${___mode:-load}"

  return 0
}
