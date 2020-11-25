#!/bin/zsh
() {
  emulate -L zsh -o extendedglob

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-off] ]] &&
    .zinit-shade-off "${___mode:-load}"

  zmodload zsh/complist
  zmodload -F zsh/parameter p:functions
  zmodload -Fa zsh/parameter p:funcstack p:history
  zmodload -Fa zsh/terminfo b:echoti
  zmodload -F zsh/zutil b:zstyle

  typeset -gU FPATH fpath=( ${${(%):-%x}:A:h}/*(/) $fpath[@] )
  autoload -Uz add-zle-hook-widget add-zsh-hook
  autoload -Uz .autocomplete.mathfunc; .autocomplete.mathfunc
  autoload -Uz .autocomplete.compinit .autocomplete.patch

  .autocomplete.no-op() { : }
  functions[compinit]=$functions[.autocomplete.no-op]

  typeset -gHa _autocomplete__compdef=()
  compdef() {
    emulate -L zsh -o extendedglob -o NO_shortloops -o warncreateglobal
    _autocomplete__compdef+=( "${(q)*}" )
  }

  # In case we're sourced _after_ `zsh-autosuggestions`
  add-zsh-hook -d precmd _zsh_autosuggest_start

  # In case we're sourced _before_ `zsh-autosuggestions`
  .autocomplete.patch add-zsh-hook
  add-zsh-hook() {
    # Prevent `_zsh_autosuggest_start` from being added.
    [[ ${@[(ie)_zsh_autosuggest_start]} -gt ${#@} ]] &&
      .autocomplete.add-zsh-hook "$@"
  }

  autoload -Uz .autocomplete.__init__ && .autocomplete.__init__
  local mod; for mod in config widget key key-binding recent-dirs async; do
    if ! zstyle -t ':autocomplete:' $mod false no off 0; then
      mod=.autocomplete.$mod
      autoload -Uz $mod && $mod
    fi
  done

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-on] ]] &&
    .zinit-shade-on "${___mode:-load}"

  return 0
}
