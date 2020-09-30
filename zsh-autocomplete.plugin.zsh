#!/bin/zsh
() {
  emulate -L zsh -o extendedglob

  # Get access to `functions` & `commands` arrays.
  zmodload -i zsh/parameter

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-off] ]] && .zinit-shade-off "${___mode:-load}"

  typeset -gU FPATH fpath=( ${${(%):-%x}:A:h}/*(/) $fpath )

  .autocomplete.no-op() {
    :
  }

  zmodload -i zsh/complist
  functions[compinit]=$functions[.autocomplete.no-op]
  autoload -Uz .autocomplete.compinit
  compdef() {
    emulate -L zsh -o extendedglob
    .autocomplete.compinit
    compdef $@
  }

  autoload -Uz .autocomplete.patch
  .autocomplete.patch add-zsh-hook

  # In case we're sourced _after_ `zsh-autosuggestions`
  add-zsh-hook -d precmd _zsh_autosuggest_start

  # In case we're sourced _before_ `zsh-autosuggestions`
  add-zsh-hook() {
    # Prevent `_zsh_autosuggest_start` from being added.
    [[ ${@[(ie)_zsh_autosuggest_start]} -gt ${#@} ]] && .autocomplete.add-zsh-hook "$@"
  }

  autoload -Uz .autocomplete.__init__ && .autocomplete.__init__
  local module mod
  for module in config widget key key-binding recent-dirs async; do
    mod=.autocomplete.$module
    if ! zstyle -t ':autocomplete:' $module false no off 0; then
      autoload -Uz $mod && $mod
    fi
  done

  # Workaround for https://github.com/zdharma/zinit/issues/366
  [[ -v functions[.zinit-shade-on] ]] && .zinit-shade-on "${___mode:-load}"
}
