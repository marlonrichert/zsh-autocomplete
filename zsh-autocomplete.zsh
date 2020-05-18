_autocomplete.main() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  _autocomplete.init.dependencies
  _autocomplete.init.environment-variables
  _autocomplete.init.completion-styles
  _autocomplete.init.key-bindings
  _autocomplete.init.auto-list-choices
}

_autocomplete.init.environment-variables() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  [[ ! -v _autocomplete__options ]] && export _autocomplete__options=(
    ALWAYS_TO_END COMPLETE_ALIASES EXTENDED_GLOB GLOB_COMPLETE GLOB_DOTS LIST_PACKED
    no_CASE_GLOB no_COMPLETE_IN_WORD no_LIST_BEEP
  )

  # Configuration for Fzf's shell extensions
  [[ ! -v FZF_COMPLETION_TRIGGER ]] && export FZF_COMPLETION_TRIGGER=''
  [[ ! -v fzf_default_completion ]] && export fzf_default_completion='list-more'
  [[ ! -v FZF_DEFAULT_OPTS ]] && export FZF_DEFAULT_OPTS='--bind=ctrl-space:abort,ctrl-k:kill-line'
}

_autocomplete.init.dependencies() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  # Initialize completion system, if it hasn't been done yet.
  # `zsh/complist` is required for `menuselect` keymap and `menu-select` widget.
  # `zsh/complist` should be loaded _before_ `compinit`.
  if ! zmodload -e zsh/complist
  then
    zmodload -i zsh/complist
    autoload -Uz compinit
    compinit
  elif ! [[ -v compprefuncs && -v comppostfuncs ]]
  then
    autoload -Uz compinit
    compinit
  fi

  if ! zmodload -e zsh/terminfo
  then
    zmodload -i zsh/terminfo
  fi

  if ! zmodload -e zsh/zutil
  then
    zmodload -i zsh/zutil
  fi

  autoload -Uz add-zsh-hook
  autoload -Uz add-zle-hook-widget

  autoload -Uz zmathfunc
  zmathfunc
}

_autocomplete.init.completion-styles() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  # Remove incompatible styles.
  zstyle -d ':completion:*' format
  zstyle -d ':completion:*:descriptions' format
  zstyle -d ':completion:*' group-name
  zstyle -d '*' single-ignored

  zstyle ':completion:*' completer _oldlist _list _expand _complete _ignored
  zstyle ':completion:*' menu 'select=long-list'
  zstyle ':completion:*' matcher-list 'r:|[./]=* l:?|=**' 'r:|?=** m:{[:lower:]}={[:upper:]}'
  zstyle ':completion:*' tag-order "! all-expansions" "-"
  zstyle ':completion:*:-command-:*' tag-order "! all-files"
  zstyle -e ':completion:*' max-errors '
    reply="$(( min(7, (${#PREFIX} + ${#SUFFIX}) / 3) )) numeric"'

  # Ignore completions starting with punctuation, unless that punctuation has been typed.
  zstyle -e ':completion:*' ignored-patterns '
    local currentword=$PREFIX$SUFFIX
    reply=( "(*/)#([[:punct:]]~^[^${currentword[1]}])*" )'

  zstyle ':completion:*' list-suffixes false
  zstyle ':completion:*' path-completion false
  zstyle ':completion:*:(-command-|cd|z):*' list-suffixes true
  zstyle ':completion:*:(-command-|cd|z):*' path-completion true

  zstyle ':completion:*' file-patterns \
    '*(#q^-/):all-files:file *(-/):directories:directory' '%p:globbed-files:"file or directory"'
  zstyle ':completion:*:-command-:*' file-patterns \
    '*(-/):directories:directory %p(#q^-/):globbed-files:executable' '*:all-files:file'
  zstyle ':completion:*:z:*' file-patterns '%p(-/):directories:directory'

  local directory_tags=( local-directories directory-stack named-directories directories )
  zstyle ':completion:*' group-order all-files ${(@)directory_tags} globbed-files
  zstyle ':completion:*:-command-:*' group-order globbed-files ${(@)directory_tags} all-files
  zstyle ':completion:*:('${(j:|:)directory_tags}')' group-name ''
  zstyle ':completion:*:(all-files|globbed-files)' group-name ''

  zstyle ':completion:*:corrections' format '%F{green}%d:%f'
  zstyle ':completion:*:original' format '%F{yellow}%d:%f'
  zstyle ':completion:*:warnings' format '%F{red}%D%f'

  zstyle ':completion:*' add-space true
  zstyle ':completion:*' use-cache true

  zstyle ':completion:(complete-word|menu-select):*' old-list always

  zstyle -e ':completion:(correct-word|list-choices):*' tag-order '
    if [[ $PREFIX == "-" ]]
    then
      reply=( "options" "-" )
    else
      reply=( "! *remote*" "-" )
    fi'
  zstyle ':completion:(correct-word|list-choices):*:brew-*:argument-rest:*' tag-order \
    "! argument-rest" "-"

  zstyle ':completion:correct-word:*' accept-exact true
  zstyle ':completion:correct-word:*' completer _correct
  zstyle ':completion:correct-word:*' glob false
  zstyle ':completion:correct-word:*' matcher-list ''

  zstyle ':completion:list-choices:*' glob false
  zstyle ':completion:list-choices:*' menu ''

  zstyle ':completion:expand-word:*' completer _expand_alias _expand
  zstyle ':completion:expand-word:*' tag-order ''
  zstyle ':completion:expand-word:*' format '%F{yellow}%d:%f'
  zstyle ':completion:expand-word:*' group-name ''

  zstyle ':completion:list-more:*' completer _expand _complete _match _ignored _approximate
  zstyle ':completion:list-more:*' matcher-list 'r:|?=** m:{[:lower:]}={[:upper:]}'
  zstyle ':completion:list-more:*' list-suffixes true
  zstyle ':completion:list-more:*' path-completion true
  zstyle ':completion:list-more:*' format '%F{yellow}%d:%f'
  zstyle ':completion:list-more:*' group-name ''
}

_autocomplete.init.key-bindings() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  if [[ ! -v key ]]
  then
    # This file can be generated with `autoload -U zkbd && zkbd`.
    # See http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Keyboard-Definition
    if [[ -r ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR} ]]
    then
      source ${ZDOTDIR:-$HOME}/.zkbd/${TERM}-${VENDOR}
    fi

    if [[ ! -v key ]]
    then
      typeset -g -A key
    fi

  fi

  if [[ -z $key[Up] ]]; then
    if [[ -n $terminfo[kcuu1] ]]; then key[Up]=$terminfo[kcuu1]; else key[Up]='^[OA'; fi
  fi

  if [[ -z $key[Down] ]]; then
    if [[ -n $terminfo[kcud1] ]]; then key[Down]=$terminfo[kcud1]; else key[Down]='^[OB'; fi
  fi

  if [[ -z $key[Tab] ]]; then
    if [[ -n $terminfo[ht] ]]; then key[Tab]=$terminfo[ht]; else key[Tab]='^I'; fi
  fi

  if [[ -z $key[BackTab] ]]; then
    if [[ -n $terminfo[kcbt] ]]; then key[BackTab]=$terminfo[kcbt]; else key[BackTab]='^[[Z'; fi
  fi

  # These are not generated by `zkbd` nor defined in `terminfo`.
  if [[ -z $key[Return] ]]; then key[Return]='^M'; fi
  if [[ -z $key[LineFeed] ]]; then key[LineFeed]='^J'; fi
  if [[ -z $key[ControlSpace] ]]; then key[ControlSpace]='^@'; fi
  if [[ -z $key[DeleteList] ]]; then key[DeleteList]='^D'; fi

  zle -C correct-word menu-select _autocomplete.completion-widget.correct-word

  bindkey ' ' magic-space
  bindkey -M menuselect -s ' ' '^[ '
  zle -N magic-space _autocomplete.widget.magic-space

  bindkey '/' magic-slash
  zle -N magic-slash _autocomplete.widget.magic-slash

  bindkey $key[ControlSpace] expand-word
  zle -C expand-word complete-word _autocomplete.completion-widget.expand-word
  bindkey -M menuselect -s $key[ControlSpace] $key[LineFeed]$key[ControlSpace]

  # Make `terminfo` codes work.
  add-zle-hook-widget line-init _autocomplete.hook.application-mode
  add-zle-hook-widget line-finish _autocomplete.hook.raw-mode

  # Work around the fact that fzf can be sourced/main keymap can be changed in .zshrc _after_
  # zsh-autocomplete has been sourced.
  _autocomplete.hook.bindkey-workaround
  add-zsh-hook precmd _autocomplete.hook.bindkey-workaround
}

_autocomplete.init.auto-list-choices() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  typeset -g _autocomplete__lastwarning
  zle -C list-choices list-choices _autocomplete.completion-widget.list-choices
  add-zle-hook-widget line-pre-redraw _autocomplete.hook.list-choices
}

_autocomplete.hook.application-mode() {
  echoti smkx
}

_autocomplete.hook.raw-mode() {
  echoti rmkx
}

_autocomplete.hook.bindkey-workaround() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  local keymap_main=$( bindkey -lL main )

  if [[ $keymap_main == *emacs* ]]
  then
    if [[ ! -v key[ListChoices] ]]; then key[ListChoices]='^[^D'; fi
    if [[ ! -v key[Undo] ]]; then key[Undo]='^_'; fi

  elif [[ $keymap_main == *viins* ]]
  then
    [[ ! -v key[ListChoices] ]] || key[ListChoices]='^D'
    [[ ! -v key[Undo] ]] || key[Undo]='u'
  fi

  if [[ -v key[ListChoices] ]]
  then
    bindkey -M menuselect -s $key[Return] $key[LineFeed]$key[ListChoices]
  fi

  if zle -l fzf-history-widget
  then
    bindkey $key[Tab] complete-word
    bindkey -M menuselect $key[Tab] accept-and-hold
    zle -C complete-word complete-word _autocomplete.completion-widget.complete-word

    bindkey $key[BackTab] list-more
    zle -C list-more list-choices _autocomplete.completion-widget.list-more

    if [[ -v key[Undo] ]]
    then
      bindkey -M menuselect -s $key[BackTab] $key[DeleteList]$key[Undo]$key[BackTab]
    fi

    bindkey $key[Up] up-line-or-fuzzy-history
    zle -N up-line-or-fuzzy-history _autocomplete.widget.up-line-or-fuzzy-history

    bindkey '^['$key[Up] fzf-history-widget

    bindkey $key[Down] down-line-or-menu-select
    zle -N down-line-or-menu-select _autocomplete.widget.down-line-or-menu-select

    bindkey '^['$key[Down] menu-select
    zle -C menu-select menu-select _autocomplete.completion-widget.menu-select
  fi

  if zle -l fzf-completion && zle -l fzf-cd-widget
  then
    bindkey $key[ControlSpace] expand-or-fuzzy-find
    zle -N expand-or-fuzzy-find _autocomplete.widget.expand-or-fuzzy-find
  fi

  # Remove itself after being called.
  add-zsh-hook -d precmd $0
}

_autocomplete.hook.list-choices() {
  setopt localoptions $_autocomplete__options

  local safechars='\-\#\:'
  local histexpansion="${(q)histchars[1]}([$safechars](#c0,1))[^$safechars]*"
  if [[ "${LBUFFER}" == ${~histexpansion} || "${${(z)LBUFFER}[-1]}" == ${~histexpansion} ]]
  then
    return 0
  fi

  zle list-choices 2> /dev/null

  return 0
}

_autocomplete.widget.down-line-or-menu-select() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext $WIDGET

  if (( ${#RBUFFER} == 0 || BUFFERLINES == 1 ))
  then
    zle menu-select $@
  else
    zle -M ''
    zle .down-line $@ || zle .end-of-line $@
  fi
}

_autocomplete.widget.expand-or-fuzzy-find() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext $WIDGET

  if [[ $BUFFER == [[:IFS:]]# ]]
  then
    zle fzf-cd-widget $@
    return
  fi

  if zle expand-word $@
  then
    return 0
  fi

  while [[ $RBUFFER[1] == [[:graph:]] ]]
  do
    zle .forward-word
  done
  zle fzf-completion $@
}

_autocomplete.widget.magic-space() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext $WIDGET

  LBUFFER=$LBUFFER' '
  if [[ $LBUFFER[-2] == [\ \/] ]]
  then
    return 0
  fi

  zle .split-undo
  (( CURSOR-- ))

  local lbuffer=$LBUFFER
  zle .expand-history $@
  if [[ $LBUFFER[-1] == [\ \/] || $lbuffer != $LBUFFER ]]
  then
    (( CURSOR++ ))
    return 0
  fi

  zle correct-word
  if [[ $LBUFFER[-1] == ' ' ]]
  then
    zle .auto-suffix-remove
  else
    zle .auto-suffix-retain
  fi
  (( CURSOR++ ))

  return 0
}

_autocomplete.widget.magic-slash() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext $WIDGET

  local lbuffer=$LBUFFER
  LBUFFER=$LBUFFER'/'
  if [[ $LBUFFER[-2] == [\ \/]# ]]
  then
    return 0
  fi

  zle .split-undo

  LBUFFER=$LBUFFER[1,-2]
  zle correct-word
  if [[ $LBUFFER[-1] == '/' ]]
  then
    zle .auto-suffix-retain
  else
    zle .auto-suffix-remove
    LBUFFER=$LBUFFER'/'
  fi

  [[ $lbuffer != $LBUFFER ]]
}

_autocomplete.widget.menu-space() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext $WIDGET

  local lbuffer=$LBUFFER
  zle .auto-suffix-retain
  if [[ $LBUFFER[-1] != $KEYS[-1] ]]
  then
    zle .self-insert $@
  fi

  [[ $lbuffer != $LBUFFER ]]
}

_autocomplete.widget.up-line-or-fuzzy-history() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext $WIDGET

  if (( ${#LBUFFER} == 0 || BUFFERLINES == 1 ))
  then
    zle fzf-history-widget $@
  else
    zle -M ''
    zle .up-line $@ || zle .beginning-of-line $@
  fi
}

_autocomplete.completion-widget.complete-word() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext complete-word

  _main_complete $@
  local ret=$?

  if [[ -n compstate[old_list] ]]
  then
    compstate[insert]='1 '
    return 0
  fi

  if _autocomplete.completion.is_too_long_list
  then
    compstate[insert]='menu'
  fi

  return ret
}

_autocomplete.completion-widget.correct-word() {
  setopt localoptions $_autocomplete__options
  unsetopt GLOB_COMPLETE

  local curcontext
  _autocomplete.completion.curcontext correct-word

  if (( ${#PREFIX} == 0 || ${#SUFFIX} > 0 ))
  then
    return 1
  fi

  _main_complete _match
  if (( compstate[nmatches] > 0 ))
  then
    compstate[insert]=''
    compstate[list]=''
    return 1
  fi

  _main_complete $@
  if (( compstate[nmatches] == 0 ))
  then
    compstate[list]=''
    return 1
  fi

  _main_complete _complete
  compstate[exact]='accept'
  if [[ ${compstate[unambiguous]} == $PREFIX$SUFFIX ]]
  then
    compstate[insert]=''
    compstate[list]=''
    return 1
  fi

  if _autocomplete.completion.is_too_long_list
  then
    compstate[insert]='menu'
  fi

  return 0
}

_autocomplete.completion-widget.expand-word() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext expand-word

  _main_complete $@

  if _autocomplete.completion.is_too_long_list
  then
    compstate[insert]='menu'

  elif (( compstate[nmatches] > 1 ))
  then
    compstate[insert]=''
  fi

  (( compstate[nmatches] > 0 ))
}

_autocomplete.completion-widget.list-choices() {
  setopt localoptions $_autocomplete__options
  unsetopt GLOB_COMPLETE

  local curcontext
  _autocomplete.completion.curcontext list-choices

  if (( (PENDING + KEYS_QUEUED_COUNT) > 0 ))
  then
    return 1
  fi

  _main_complete $@
  local ret=$?

  if _autocomplete.completion.is_too_long_list
  then
    compstate[list]=''
    zle -M ''
  fi

  return ret
}

_autocomplete.completion-widget.list-more() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext list-more

  _main_complete $@
  local ret=$?

  if _autocomplete.completion.is_too_long_list
  then
    compstate[insert]='menu'
  else
    compstate[insert]=''
  fi

  return ret
}

_autocomplete.completion-widget.menu-select() {
  setopt localoptions $_autocomplete__options

  local curcontext
  _autocomplete.completion.curcontext menu-select

  _main_complete $@
  local ret=$?

  if _autocomplete.completion.is_too_long_list
  then
    compstate[insert]='menu'
  fi

  return ret
}

_autocomplete.completion.curcontext() {
  emulate -LR zsh -o noshortloops

  curcontext="${curcontext:-}"
  if [[ -z "$curcontext" ]]; then
    curcontext="$1:::"
  else
    curcontext="$1:${curcontext#*:}"
  fi
}

_autocomplete.completion.is_too_long_list() {
  emulate -LR zsh -o noshortloops -o warncreateglobal

  (( (compstate[list_lines] + BUFFERLINES + 1) > LINES
  || (compstate[list_max] != 0 && compstate[nmatches] >= compstate[list_max]) ))
}
