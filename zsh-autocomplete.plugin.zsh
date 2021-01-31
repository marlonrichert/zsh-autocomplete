#!/bin/zsh
setopt alwayslastprompt NO_singlelinezle
() {
  emulate -L zsh
  zmodload -Fa zsh/parameter p:history p:funcstack p:functions
  zmodload -F zsh/zutil b:zstyle

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-off] ]] &&
    .zinit-shade-off "${___mode:-load}"

  typeset -gHa _autocomplete__options=(
    localoptions extendedglob rcquotes
    NO_aliases NO_banghist NO_caseglob NO_clobber NO_listbeep
  )
  setopt $_autocomplete__options

  typeset -gU FPATH fpath=( ${${(%):-%x}:A:h}/*(/) $fpath[@] )

  builtin autoload -Uz .autocomplete.__init__
  .autocomplete.__init__

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-on] ]] &&
    .zinit-shade-on "${___mode:-load}"

  return 0
}
