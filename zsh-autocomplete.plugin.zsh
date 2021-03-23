#!/bin/zsh
setopt NO_singlelinezle
() {
  emulate -L zsh
  zmodload -F zsh/parameter p:functions

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-off] ]] &&
    .zinit-shade-off "${___mode:-load}"

  typeset -gHa _autocomplete__options=(
    clobber localoptions localtraps extendedglob rcquotes
    NO_aliases NO_banghist NO_listbeep NO_shortloops NO_warncreateglobal
  )
  setopt $_autocomplete__options

  local basedir=${${(%):-%x}:h}
  if ! [[ -n $basedir && -d $basedir ]]; then
    print -u2 -- 'zsh-autocomplete: Failed to find base dir. Aborting.'
    return 66
  fi
  hash -d zsh-autocomplete=$basedir

  local -a subdirs=( ~zsh-autocomplete/*(N-/) )
  if ! (( $#subdirs )); then
    print -u2 -- 'zsh-autocomplete: Failed to find sub dirs. Aborting.'
    return 66
  fi
  typeset -gU FPATH fpath=( $subdirs[@] $fpath[@] )

  local -a funcs=( $^subdirs/.autocomplete.*~*.zwc(N-.) )
  if ! (( $#funcs )); then
    print -u2 -- 'zsh-autocomplete: Failed to find functions. Aborting.'
    return 66
  fi
  builtin autoload -Uz $funcs[@]

  .autocomplete.__init__

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-on] ]] &&
    .zinit-shade-on "${___mode:-load}"

  return 0
}
