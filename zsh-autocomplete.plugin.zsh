#!/bin/zsh
zmodload zsh/param/private
setopt NO_flowcontrol NO_singlelinezle

zsh-autocomplete() {
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

  private basedir=${${(%):-%x}:P:h}
  if ! [[ -n $basedir && -d $basedir ]]; then
    print -u2 -- 'zsh-autocomplete: Failed to find base dir. Aborting.'
    return 66
  fi
  hash -d zsh-autocomplete=$basedir
  typeset -gU FPATH fpath=( ~zsh-autocomplete/functions/completion $fpath[@] )

  private -a funcs=(
      ~zsh-autocomplete/functions{,/widget}/.autocomplete.*~*.zwc(N-.:a)
  )
  if ! (( $#funcs )); then
    print -u2 -- 'zsh-autocomplete: Failed to find functions. Aborting.'
    return 66
  fi
  unfunction $funcs[@]:t 2> /dev/null
  builtin autoload -Uz $funcs[@]

  autoload -Uz ~zsh-autocomplete/scripts/.autocomplete.__init__
  {
    .autocomplete.__init__ "$@"
  } always {
    unfunction .autocomplete.__init__
  }

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-on] ]] &&
    .zinit-shade-on "${___mode:-load}"

  return 0
}

{
  zsh-autocomplete "$@"
} always {
  unfunction zsh-autocomplete
}
