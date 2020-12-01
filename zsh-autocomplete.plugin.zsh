#!/bin/zsh
() {
  emulate -L zsh -o extendedglob

  zmodload -Fa zsh/parameter p:history p:funcstack p:functions

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-off] ]] &&
    .zinit-shade-off "${___mode:-load}"

  compinit() { : }
  typeset -gHa _autocomplete__compdef=()
  compdef() {
    _autocomplete__compdef+=( "${(q)*}" )
  }

  typeset -gU FPATH fpath=( ${${(%):-%x}:A:h}/*(/) $fpath[@] )

  # In case we're sourced _after_ `zsh-autosuggestions`
  builtin autoload -Uz add-zsh-hook
  add-zsh-hook -d precmd _zsh_autosuggest_start

  # In case we're sourced _before_ `zsh-autosuggestions`
  builtin autoload -Uz .autocomplete.patch
  .autocomplete.patch add-zsh-hook
  add-zsh-hook() {
    # Prevent `_zsh_autosuggest_start` from being added.
    [[ ${@[(ie)_zsh_autosuggest_start]} -gt $# ]] &&
      .autocomplete.add-zsh-hook "$@"
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
