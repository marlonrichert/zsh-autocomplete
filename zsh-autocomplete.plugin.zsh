#!/bin/zsh
() {
  emulate -LR zsh -o noshortloops -o warncreateglobal -o extendedglob

  # Workaround for https://github.com/zdharma/zinit/issues/366
  zmodload -i zsh/parameter  # Get access to `functions` & `commands` arrays.
  [[ -v functions[.zinit-shade-off] ]] && .zinit-shade-off "${___mode:-load}"

  local dir=${${(%):-%x}:A:h}
  typeset -gU FPATH fpath=(
    $dir/completion
    $dir/module
    $dir/utility
    $dir/widget
    $fpath
  )

  .autocomplete.no-op() {
    :
  }

  zmodload -i zsh/complist
  functions[compinit]=$functions[.autocomplete.no-op]
  autoload -Uz .autocomplete.compinit
  compdef() {
    emulate -LR zsh -o noshortloops -o warncreateglobal -o extendedglob
    .autocomplete.compinit
    compdef $@
  }

  # In case we're sourced _after_ `zsh-autosuggestions`
  unfunction add-zsh-hook
  autoload +X -Uz add-zsh-hook
  add-zsh-hook -d precmd _zsh_autosuggest_start

  # In case we're sourced _before_ `zsh-autosuggestions`
  functions[.autocomplete.add-zsh-hook]=$functions[add-zsh-hook]
  add-zsh-hook() {
    # Prevent `_zsh_autosuggest_start` from being added.
    if [[ ${@[(ie)_zsh_autosuggest_start]} -gt ${#@} ]]; then
      .autocomplete.add-zsh-hook "$@" > /dev/null
    fi
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
