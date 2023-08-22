#!/bin/zsh
unsetopt listbeep

() {
  zmodload -F zsh/parameter p:funcfiletrace
  zmodload zsh/param/private

  typeset -ga _autocomplete__func_opts=(
    localoptions extendedglob clobber
    NO_aliases localloops pipefail NO_shortloops NO_unset warncreateglobal
  )
  setopt $_autocomplete__func_opts[@]

  typeset -ga _autocomplete__funcfiletrace=( $funcfiletrace )

  local basedir=${${(%):-%x}:P:h}
  hash -d autocomplete=$basedir zsh-autocomplete=$basedir

  builtin autoload +X -Uz ~autocomplete/Functions/**/.autocomplete__*~*.zwc(D-:)
  .autocomplete__main "$@"
}
