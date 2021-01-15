#!/bin/zsh
setopt NO_singlelinezle
() {
  emulate -L zsh
  zmodload -Fa zsh/parameter p:history p:funcstack p:functions

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-off] ]] &&
    .zinit-shade-off "${___mode:-load}"

  typeset -gHa _autocomplete__options=(
    localoptions extendedglob rcquotes
    NO_aliases NO_banghist NO_clobber NO_listbeep
  )
  setopt $_autocomplete__options

  typeset -gU FPATH fpath=( ${${(%):-%x}:A:h}/*(/) $fpath[@] )

  # In case we're sourced _after_ `zsh-autosuggestions`
  builtin autoload -Uz add-zsh-hook
  add-zsh-hook -d precmd _zsh_autosuggest_start

  # In case we're sourced _before_ `zsh-autosuggestions`
  builtin autoload -Uz .autocomplete.patch
  .autocomplete.patch add-zsh-hook
  add-zsh-hook() {
    # Prevent `_zsh_autosuggest_start` from being added.
    local -i ret=0
    if (( ${@[(I)_zsh_autosuggest_start]} == 0 )); then
      .autocomplete.add-zsh-hook "$@"; ret=$?
    fi
    return 0
  }

  zmodload -F zsh/zutil b:zstyle
  builtin autoload -Uz .autocomplete.__init__
  .autocomplete.__init__
  local mod; for mod in compinit config widget key key-binding recent-dirs async; do
    if ! zstyle -t ':autocomplete:' $mod false no off 0; then
      mod=.autocomplete.$mod
      builtin autoload -Uz $mod
      $mod
    fi
  done

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-on] ]] &&
    .zinit-shade-on "${___mode:-load}"

  return 0
}
