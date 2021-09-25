#!/bin/zsh

# Workaround for https://github.com/zdharma/zinit/issues/366
# NOTE: Needs to come before _everything_ else!
[[ -v functions[.zinit-shade-off] ]] &&
    .zinit-shade-off "${___mode:-load}"
[[ -v functions[.zinit-tmp-subst-off] ]] &&
    .zinit-tmp-subst-off "${___mode:-load}"

zmodload zsh/param/private
setopt NO_flowcontrol NO_singlelinezle

() {
  emulate -L zsh
  zmodload -F zsh/parameter p:funcfiletrace p:functions
  typeset -gH _autocomplete__funcfiletrace=${(F)funcfiletrace[2,-2]}

  typeset -gHa _autocomplete__func_opts=(
    localoptions extendedglob clobber
    NO_aliases localloops pipefail NO_shortloops NO_unset warncreateglobal warnnestedvar
  )
  setopt $_autocomplete__func_opts[@]

  typeset -gHa _autocomplete__comp_opts=( localoptions NO_banghist NO_completeinword NO_listbeep )
  typeset -gHa _autocomplete__ctxt_opts=( completealiases completeinword )

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

  builtin autoload -Uz ~zsh-autocomplete/scripts/.autocomplete.__init__
  {
    .autocomplete.__init__ "$@"
  } always {
    unfunction .autocomplete.__init__
  }
} "$@"

return 0
