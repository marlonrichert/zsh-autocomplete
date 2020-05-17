_zsh_autocomplete__main() {
  emulate -L zsh -o noshortloops -o warncreateglobal

  _zsh_autocomplete__dependencies
  _zsh_autocomplete__environment_variables
  _zsh_autocomplete__completion_styles
  _zsh_autocomplete__key_bindings
  _zsh_autocomplete__auto_list_choices
}

_zsh_autocomplete__environment_variables() {
  emulate -L zsh -o noshortloops -o warncreateglobal

  [[ ! -v zsh_autocomplete_options ]] && export zsh_autocomplete_options=(
    ALWAYS_TO_END COMPLETE_ALIASES EXTENDED_GLOB GLOB_COMPLETE GLOB_DOTS LIST_PACKED
    no_CASE_GLOB no_COMPLETE_IN_WORD no_LIST_BEEP
  )
  [[ ! -v zsh_autocomplete_directory_tags ]] && export zsh_autocomplete_directory_tags=(
    local-directories directory-stack named-directories directories
  )

  # Configuration for Fzf shell extensions
  [[ ! -v FZF_COMPLETION_TRIGGER ]] && export FZF_COMPLETION_TRIGGER=''
  [[ ! -v fzf_default_completion ]] && export fzf_default_completion='list-more'
  [[ ! -v FZF_DEFAULT_OPTS ]] && export FZF_DEFAULT_OPTS='--bind=ctrl-space:abort,ctrl-k:kill-line'
}

_zsh_autocomplete__dependencies() {
  emulate -L zsh -o noshortloops -o warncreateglobal

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

  autoload -Uz add-zsh-hook
  autoload -Uz add-zle-hook-widget

  autoload -Uz zmathfunc
  zmathfunc
}

_zsh_autocomplete__completion_styles() {
  emulate -L zsh -o noshortloops -o warncreateglobal

  # Remove incompatible styles.
  zstyle -d ':completion:*' format
  zstyle -d ':completion:*:descriptions' format
  zstyle -d ':completion:*' group-name
  zstyle -d '*' single-ignored

  zstyle ':completion:*' completer _oldlist _expand _complete _ignored
  zstyle ':completion:*' menu 'select=long-list'
  zstyle ':completion:*' matcher-list 'r:|[./]=* l:?|=**' 'r:|?=** m:{[:lower:]}={[:upper:]}'
  zstyle ':completion:*' tag-order "! all-expansions" "-"
  zstyle ':completion:*:-command-:*' tag-order "! all-files"
  zstyle -e ':completion:*' max-errors '
    reply="$(( min(7, (${#PREFIX} + ${#SUFFIX}) / 3) )) numeric"'

  # Ignore completions starting with punctuation, unless that punctuation has been typed.
  zstyle -e ':completion:*' ignored-patterns '
    local current_word=$PREFIX$SUFFIX
    reply=( "(*/)#([[:punct:]]~^[^${current_word[1]}])*" )'

  zstyle ':completion:*' list-suffixes false
  zstyle ':completion:*' path-completion false
  zstyle ':completion:*:(-command-|cd|z):*' list-suffixes true
  zstyle ':completion:*:(-command-|cd|z):*' path-completion true

  zstyle ':completion:*' file-patterns \
    '*(#q^-/):all-files:file *(-/):directories:directory' '%p:globbed-files:"file or directory"'
  zstyle ':completion:*:-command-:*' file-patterns \
    '*(-/):directories:directory %p(#q^-/):globbed-files:executable' '*:all-files:file'
  zstyle ':completion:*:z:*' file-patterns '%p(-/):directories:directory'
  zstyle ':completion:*' group-order \
    all-files $zsh_autocomplete_directory_tags globbed-files
  zstyle ':completion:*:-command-:*' group-order \
    globbed-files $zsh_autocomplete_directory_tags all-files
  zstyle ':completion:*:all-files' group-name ''
  zstyle ':completion:*:globbed-files' group-name ''
  zstyle ':completion:*:('${(j:|:)zsh_autocomplete_directory_tags}')' group-name ''

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

_zsh_autocomplete__key_bindings() {
  emulate -L zsh -o noshortloops -o warncreateglobal

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

  zle -C _correct_word menu-select _zsh_autocomplete__c__correct_word

  bindkey ' ' magic-space
  bindkey -M menuselect -s ' ' '^[ '
  zle -N magic-space _zsh_autocomplete__w__magic-space

  bindkey '/' magic-slash
  zle -N magic-slash _zsh_autocomplete__w__magic-slash

  bindkey $key[ControlSpace] expand-word
  zle -C expand-word complete-word _zsh_autocomplete__c__expand-word
  bindkey -M menuselect -s $key[ControlSpace] $key[LineFeed]$key[ControlSpace]

  # Make `terminfo` codes work.
  add-zle-hook-widget line-init _zsh_autocomplete__h__application_mode
  add-zle-hook-widget line-finish _zsh_autocomplete__h__raw_mode

  # Work around the fact that fzf can be sourced/main keymap can be changed in .zshrc _after_
  # zsh-autocomplete has been sourced.
  _zsh_autocomplete__h__bindkey_workaround
  add-zsh-hook precmd _zsh_autocomplete__h__bindkey_workaround
}

_zsh_autocomplete__auto_list_choices() {
  emulate -L zsh -o noshortloops -o warncreateglobal

  typeset -g _zsh_autocomplete_last_buffer
  zle -C list-choices list-choices _zsh_autocomplete__c__list-choices
  add-zle-hook-widget line-pre-redraw _zsh_autocomplete__h__list_choices
}

_zsh_autocomplete__h__application_mode() {
  echoti smkx
}

_zsh_autocomplete__h__raw_mode() {
  echoti rmkx
}

_zsh_autocomplete__h__bindkey_workaround() {
  emulate -L zsh -o noshortloops -o warncreateglobal

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
    zle -N complete-word _zsh_autocomplete__w__complete-word
    zle -C _complete_word complete-word _zsh_autocomplete__c__complete_word

    bindkey $key[BackTab] list-more
    zle -C list-more list-choices _zsh_autocomplete__c__list-more

    if [[ -v key[Undo] ]]
    then
      bindkey -M menuselect -s $key[BackTab] $key[DeleteList]$key[Undo]$key[BackTab]
    fi

    bindkey $key[Up] up-line-or-fuzzy-history
    zle -N up-line-or-fuzzy-history _zsh_autocomplete__w__up-line-or-fuzzy-history

    bindkey '^['$key[Up] fzf-history-widget

    bindkey $key[Down] down-line-or-menu-select
    zle -N down-line-or-menu-select _zsh_autocomplete__w__down-line-or-menu-select

    bindkey '^['$key[Down] menu-select
    zle -C menu-select menu-select _zsh_autocomplete__c__menu-select
  fi

  if zle -l fzf-completion && zle -l fzf-cd-widget
  then
    bindkey $key[ControlSpace] expand-or-fuzzy-find
    zle -N expand-or-fuzzy-find _zsh_autocomplete__w__expand-or-fuzzy-find
  fi

  # Remove itself after being called.
  add-zsh-hook -d precmd $0
}

_zsh_autocomplete__h__list_choices() {
  setopt localoptions $zsh_autocomplete_options

  if [[ $BUFFER == $_zsh_autocomplete_last_buffer ]]
  then
    return
  fi

  local safechars='\-\#\:'
  local histexpansion="${(q)histchars[1]}([$safechars](#c0,1))[^$safechars]*"
  if [[ "${LBUFFER}" == ${~histexpansion} || "${${(z)LBUFFER}[-1]}" == ${~histexpansion} ]]
  then
    return
  fi

  if zle list-choices 2> /dev/null
  then
    _zsh_autocomplete_last_buffer=$BUFFER
  fi
}

_zsh_autocomplete__w__complete-word() {
  setopt localoptions $zsh_autocomplete_options

  local lbuffer=$LBUFFER
  zle _complete_word $@

  if [[ $lbuffer != $LBUFFER ]]
  then
    zle .auto-suffix-retain
  fi

  [[ $lbuffer != $LBUFFER ]]
}

_zsh_autocomplete__w__down-line-or-menu-select() {
  setopt localoptions $zsh_autocomplete_options

  if (( ${#RBUFFER} == 0 || BUFFERLINES == 1 ))
  then
    zle menu-select $@
  else
    zle -M ''
    zle .down-line $@ || zle .end-of-line $@
  fi
}

_zsh_autocomplete__w__expand-or-fuzzy-find() {
  setopt localoptions $zsh_autocomplete_options

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

_zsh_autocomplete__w__magic-space() {
  setopt localoptions $zsh_autocomplete_options

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

  zle _correct_word
  if [[ $LBUFFER[-1] == ' ' ]]
  then
    zle .auto-suffix-remove
  else
    zle .auto-suffix-retain
  fi
  (( CURSOR++ ))

  return 0
}

_zsh_autocomplete__w__magic-slash() {
  setopt localoptions $zsh_autocomplete_options

  local lbuffer=$LBUFFER

  LBUFFER=$LBUFFER'/'
  if [[ $LBUFFER[-2] == [\ \/]# ]]
  then
    return 0
  fi

  zle .split-undo

  LBUFFER=$LBUFFER[1,-2]
  zle _correct_word
  if [[ $LBUFFER[-1] == '/' ]]
  then
    zle .auto-suffix-retain
  else
    zle .auto-suffix-remove
    LBUFFER=$LBUFFER'/'
  fi

  [[ $lbuffer != $LBUFFER ]]
}

_zsh_autocomplete__w__menu-space() {
  setopt localoptions $zsh_autocomplete_options

  local lbuffer=$LBUFFER

  zle .auto-suffix-retain
  if [[ $LBUFFER[-1] != $KEYS[-1] ]]
  then
    zle .self-insert $@
  fi

  [[ $lbuffer != $LBUFFER ]]
}

_zsh_autocomplete__w__up-line-or-fuzzy-history() {
  setopt localoptions $zsh_autocomplete_options

  if (( ${#LBUFFER} == 0 || BUFFERLINES == 1 ))
  then
    zle fzf-history-widget $@
  else
    zle -M ''
    zle .up-line $@ || zle .beginning-of-line $@
  fi
}

_zsh_autocomplete__c__complete_word() {
  setopt localoptions $zsh_autocomplete_options

  local curcontext
  _zsh_autocomplete__curcontext complete-word
  _zsh_autocomplete__menu_complete $@
}

_zsh_autocomplete__c__correct_word() {
  setopt localoptions $zsh_autocomplete_options
  unsetopt GLOB_COMPLETE

  if (( ${#PREFIX} == 0 || ${#SUFFIX} > 0 ))
  then
    return 1
  fi

  local curcontext
  _zsh_autocomplete__curcontext correct-word
  compstate[old_list]=''

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

  if (( compstate[nmatches] < 2 ))
  then
    compstate[list]=''
  fi

  return 0
}

_zsh_autocomplete__c__expand-word() {
  setopt localoptions $zsh_autocomplete_options

  local curcontext
  _zsh_autocomplete__curcontext expand-word
  _main_complete $@

  if _zsh_autocomplete__is_too_long_list
  then
    compstate[insert]='menu'

  elif (( compstate[nmatches] > 1 ))
  then
    compstate[insert]=''
  fi

  (( compstate[nmatches] > 0 ))
}

_zsh_autocomplete__c__list-choices() {
  setopt localoptions $zsh_autocomplete_options
  unsetopt GLOB_COMPLETE

  if (( (PENDING + KEYS_QUEUED_COUNT) > 0 ))
  then
    return 1
  fi

  local curcontext
  _zsh_autocomplete__curcontext list-choices
  _main_complete $@

  if (( compstate[nmatches] == 0 ))
  then
    zle -M ''
    return 1
  fi

  if _zsh_autocomplete__is_too_long_list
  then
    compstate[list]=''
    zle -M ''
  fi

  return 0
}

_zsh_autocomplete__c__list-more() {
  setopt localoptions $zsh_autocomplete_options

  local curcontext
  _zsh_autocomplete__curcontext list-more
  _main_complete $@

  if _zsh_autocomplete__is_too_long_list
  then
    compstate[insert]='menu'
  else
    compstate[insert]=''
  fi

  (( compstate[nmatches] > 0 ))
}

_zsh_autocomplete__c__menu-select() {
  setopt localoptions $zsh_autocomplete_options

  local curcontext
  _zsh_autocomplete__curcontext menu-select
  _zsh_autocomplete__menu_complete $@
}

_zsh_autocomplete__curcontext() {
  emulate -L zsh -o noshortloops

  curcontext="${curcontext:-}"
  if [[ -z "$curcontext" ]]; then
    curcontext="$1:::"
  else
    curcontext="$1:${curcontext#*:}"
  fi
}

_zsh_autocomplete__is_too_long_list() {
  emulate -L zsh -o noshortloops -o warncreateglobal

  (( (compstate[list_lines] + BUFFERLINES + 1) > LINES
  || (compstate[list_max] != 0 && compstate[nmatches] >= compstate[list_max]) ))
}

_zsh_autocomplete__menu_complete() {
  setopt localoptions $zsh_autocomplete_options

  if [[ -v compstate[old_list] ]]
  then
    compstate[old_list]='keep'
    return 0
  fi

  _main_complete $@
  compstate[list]='list'

  if _zsh_autocomplete__is_too_long_list
  then
    compstate[insert]='menu'

  elif (( compstate[nmatches] > 1 ))
  then
    compstate[insert]=''
  fi

  (( compstate[nmatches] > 0 ))
}
