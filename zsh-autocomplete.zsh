_zsh_autocomplete__main() {
  _zsh_autocomplete__dependencies
  _zsh_autocomplete__environment_variables
  _zsh_autocomplete__completion_styles
  _zsh_autocomplete__keybindings
  _zsh_autocomplete__auto_list_choices
}

_zsh_autocomplete__environment_variables() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  [[ ! -v zsh_autocomplete_options ]] && export zsh_autocomplete_options=(
    EXTENDED_GLOB
    GLOB_COMPLETE
    GLOB_DOTS
    NO_CASE_GLOB
    WARN_CREATE_GLOBAL
    no_COMPLETE_IN_WORD
    no_LIST_BEEP
    no_SHORT_LOOPS
  )
  [[ ! -v zsh_autocomplete_long_tags ]] && export zsh_autocomplete_long_tags=(
    commit-tags heads-remote
  )
  [[ ! -v zsh_autocomplete_slow_tags ]] && export zsh_autocomplete_slow_tags=(
    globbed-files remote-files remote-repositories
  )

  # Configuration for Fzf shell extensions
  [[ ! -v FZF_COMPLETION_TRIGGER ]] && export FZF_COMPLETION_TRIGGER=''
  [[ ! -v fzf_default_completion ]] && export fzf_default_completion='list-more'
  [[ ! -v FZF_DEFAULT_OPTS ]] && export FZF_DEFAULT_OPTS="--bind=ctrl-space:abort,ctrl-k:kill-line"
}

_zsh_autocomplete__dependencies() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  # Initialize completion system, if it hasn't been done yet.
  # `zsh/complist` is required for `menuselect` keymap & should be loaded _before_ `compinit`.

  if ! zmodload -e zsh/complist
  then
    zmodload -i zsh/complist
    autoload -U compinit
    compinit
  fi

  if [[ ! -v _comp_setup ]]
  then
    autoload -U compinit
    compinit
  fi
}

_zsh_autocomplete__completion_styles() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  # Remove incompatible styles.
  zstyle -d ':completion:*' format
  zstyle -d ':completion:*:descriptions' format
  zstyle -d ':completion:*' group-name
  zstyle -d '*' single-ignored

  zstyle ':completion:*' add-space true
  zstyle ':completion:*' completer _expand _complete _ignored
  zstyle ':completion:*:corrections' format '%F{green}%d:%f'
  zstyle ':completion:*:original' format '%F{yellow}%d:%f'
  zstyle ':completion:*:warnings' format '%F{red}%D%f'

  # Ignore completions starting with punctuation, unless that punctuation has been typed.
  zstyle -e ':completion:*' ignored-patterns '
    local current_word=$PREFIX$SUFFIX
    reply=( "(*/)#([[:punct:]]~^[^${current_word[1]}])*" )'

  zstyle ':completion:*' matcher-list 'r:|.=* l:?|=**' 'r:|?=** m:{[:lower:]}={[:upper:]}'
  zstyle ':completion:*' menu 'select=long-list'
  zstyle ':completion:*' use-cache true

  zstyle ':completion:*:expand:*' tag-order '! all-expansions' '-'
  zstyle ':completion:*:z:*' file-patterns '%p(-/):directories'

  zstyle ':completion:correct-word:*' accept-exact true
  zstyle ':completion:correct-word:*' accept-exact-dirs true
  zstyle ':completion:correct-word:*' glob false
  zstyle ':completion:correct-word:*' matcher-list ''
  zstyle ':completion:correct-word:*' tag-order "! options $zsh_autocomplete_slow_tags" "-"

  zstyle ':completion:correct-word:*:brew*:*' tag-order "! list" "-"

  zstyle ':completion:list-choices:*' file-patterns '%p(-/):directories %p:all-files'
  zstyle ':completion:list-choices:*' glob false
  zstyle ':completion:list-choices:*' menu ''
  zstyle ':completion:list-choices:*' tag-order \
    "options" "! options $zsh_autocomplete_long_tags $zsh_autocomplete_slow_tags" \
    "$zsh_autocomplete_long_tags" "-"

  zstyle ':completion:list-choices:*:brew:*' tag-order "! all-commands argument-rest" "-"
  zstyle -e ':completion:list-choices:*:zle:*' tag-order '
    if [[ $PREFIX$SUFFIX == -* ]]
    then
      reply=( "! widgets" "-" )
    fi'

  zstyle ':completion:list-more:*' format '%F{yellow}%d:%f'
  zstyle ':completion:list-more:*' group-name ''
  zstyle ':completion:list-more:*' matcher-list 'r:|?=** m:{[:lower:]}={[:upper:]}'
}

_zsh_autocomplete__auto_list_choices() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  local widget

  # Wrap all text modification widgets to provide auto-completion.
  for widget in vi-add-eol vi-add-next backward-delete-char vi-backward-delete-char \
    backward-delete-word backward-kill-line backward-kill-word vi-backward-kill-word \
    capitalize-word vi-change vi-change-eol vi-change-whole-line copy-region-as-kill \
    copy-prev-word copy-prev-shell-word vi-delete delete-char vi-delete-char delete-word \
    down-case-word vi-down-case kill-word gosmacs-transpose-chars vi-indent vi-insert \
    vi-insert-bol vi-join kill-line vi-kill-line vi-kill-eol kill-region kill-buffer \
    kill-whole-line vi-match-bracket vi-open-line-above vi-open-line-below vi-oper-swap-case \
    overwrite-mode vi-put-before vi-put-after put-replace-selection quoted-insert \
    vi-quoted-insert quote-line quote-region vi-replace vi-repeat-change vi-replace-chars \
    self-insert self-insert-unmeta vi-substitute vi-swap-case transpose-chars transpose-words \
    vi-unindent vi-up-case up-case-word yank yank-pop vi-yank vi-yank-whole-line vi-yank-eol
  do
    eval "zle -N $widget _zsh_autocomplete__w__$widget
    _zsh_autocomplete__w__$widget() {
      zle .$widget \$@
      _zsh_autocomplete__list_choices
    }"
  done
}

_zsh_autocomplete__keybindings() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

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

  if ! zmodload -e zsh/terminfo; then zmodload -i zsh/terminfo; fi

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

  zle -N complete-word _zsh_autocomplete__w__complete-word
  zle -C _complete_word complete-word _zsh_autocomplete__c__complete_word
  zle -C list-choices list-choices _zsh_autocomplete__c__list-choices

  bindkey ' ' magic-space
  zle -N magic-space _zsh_autocomplete__w__magic-space
  zle -C _correct_word menu-select _zsh_autocomplete__c__correct_word

  bindkey '^[ ' menu-space
  zle -N menu-space _zsh_autocomplete__w__menu-space

  bindkey $key[BackTab] list-more
  zle -C list-more list-choices _zsh_autocomplete__c__list-more

  bindkey $key[ControlSpace] expand-or-fuzzy-find
  zle -N expand-or-fuzzy-find _zsh_autocomplete__w__expand-or-fuzzy-find

  bindkey -M menuselect $key[Tab] accept-and-hold
  bindkey -M menuselect -s $key[ControlSpace] $key[LineFeed]$key[ControlSpace]

  # Needed for both sections below
  autoload -U add-zle-hook-widget

  # Make `terminfo` codes work.
  add-zle-hook-widget line-init _zsh_autocomplete__h__application_mode
  add-zle-hook-widget line-finish _zsh_autocomplete__h__raw_mode

  # Make it so the order in which fzf and zsh-autocomplete are sourced doesn't matter.
  _zsh_autocomplete__h__fzf_keys
  _zsh_autocomplete__h__keymap-specific_keys
  add-zle-hook-widget line-init _zsh_autocomplete__h__fzf_keys
  add-zle-hook-widget line-init _zsh_autocomplete__h__keymap-specific_keys
}

_zsh_autocomplete__h__application_mode() {
  echoti smkx
}

_zsh_autocomplete__h__raw_mode() {
  echoti rmkx
}

_zsh_autocomplete__h__fzf_keys() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  if zle -l fzf-history-widget
  then
    bindkey $key[Tab] complete-word

    bindkey $key[Up] up-line-or-fuzzy-history
    zle -N up-line-or-fuzzy-history _zsh_autocomplete__w__up-line-or-fuzzy-history

    bindkey "^[$key[Up]" fzf-history-widget

    bindkey $key[Down] down-line-or-menu-select
    zle -N down-line-or-menu-select _zsh_autocomplete__w__down-line-or-menu-select

    bindkey "^[$key[Down]" menu-select
    zle -C menu-select menu-select _zsh_autocomplete__c__menu-select
  fi

  # Remove itself after being called.
  add-zle-hook-widget -d line-init _zsh_autocomplete__h__fzf_keys
}

_zsh_autocomplete__h__keymap-specific_keys() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

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
    bindkey -M menuselect -s ' ' '^[ '$key[ListChoices]
    bindkey -M menuselect -s $key[Return] $key[LineFeed]$key[ListChoices]
  fi

  if [[ -v key[Undo] ]]
  then
    bindkey -M menuselect -s $key[BackTab] $key[DeleteList]$key[Undo]$key[BackTab]
  fi

  # Remove itself after being called.
  add-zle-hook-widget -d line-init _zsh_autocomplete__h__keymap-specific_keys
}

_zsh_autocomplete__w__complete-word() {
  setopt localoptions $zsh_autocomplete_options

  local lbuffer=$LBUFFER

  zle _complete_word $@

  if [[ $lbuffer != $LBUFFER ]]
  then
    zle .auto-suffix-retain
    _zsh_autocomplete__list_choices
  fi
}

_zsh_autocomplete__w__down-line-or-menu-select() {
  setopt localoptions $zsh_autocomplete_options

  zle -M ''

  if (( ${#RBUFFER} > 0 && BUFFERLINES > 1 )); then
    zle .down-line $@ || zle .end-of-line $@
  else
    zle menu-select $@
  fi
}

_zsh_autocomplete__w__expand-or-fuzzy-find() {
  setopt localoptions $zsh_autocomplete_options

  zle -M ''

  if zle _expand_alias $@
  then
    _zsh_autocomplete__list_choices
    return
  fi

  local -h comppostfuncs=( _zsh_autocomplete__force_list )

  if zle _expand_word $@
  then
    _zsh_autocomplete__list_choices
    return
  fi

  if zle -l fzf-completion
  then

    while [[ $RBUFFER[1] == [[:graph:]] ]]
    do
      zle .forward-word
    done

    fzf-completion $@
  else
    zle list-more $@
  fi
}

_zsh_autocomplete__w__magic-space() {
  setopt localoptions $zsh_autocomplete_options

  local keys=$KEYS
  LBUFFER=$LBUFFER' '

  if [[ $LBUFFER[-2] == [\ \/] ]]
  then
    _zsh_autocomplete__list_choices
    return 0
  fi

  zle .split-undo
  (( CURSOR-- ))
  local lbuffer=$LBUFFER
  zle .expand-history $@

  if [[ $LBUFFER[-1] == [\ \/] || $lbuffer != $LBUFFER ]]
  then
    (( CURSOR++ ))
    _zsh_autocomplete__list_choices
    return 0
  fi

  zle _correct_word

  if [[ $LBUFFER[-1] == $keys[-1] ]]
  then
    zle .auto-suffix-remove
  else
    zle .auto-suffix-retain
  fi

  (( CURSOR++ ))
  _zsh_autocomplete__list_choices
  return 0
}

_zsh_autocomplete__w__menu-space() {
  zle .auto-suffix-retain
  if [[ $LBUFFER[-1] != $KEYS[-1] ]]
  then
    zle .self-insert $@
  fi
  return 0
}

_zsh_autocomplete__w__up-line-or-fuzzy-history() {
  setopt localoptions $zsh_autocomplete_options

  zle -M ''

  if (( ${#LBUFFER} > 0 && BUFFERLINES > 1 )); then
    zle .up-line $@ || zle .beginning-of-line $@
  else
    fzf-history-widget $@
  fi
}

_zsh_autocomplete__c__complete_word() {
  setopt localoptions $zsh_autocomplete_options
  local curcontext=$( _zsh_autocomplete__context complete-word )
  _zsh_autocomplete__menu_complete $@
}

_zsh_autocomplete__c__correct_word() {
  setopt localoptions $zsh_autocomplete_options
  unsetopt GLOB_COMPLETE

  if _zsh_autocomplete__is_enough_input && [[ $RBUFFER[1] == [[:IFS:]]# ]]
  then
    local curcontext=$( _zsh_autocomplete__context correct-word )
    compstate[old_list]=''

    _main_complete _match

    if (( $compstate[nmatches] > 0 ))
    then
      compstate[insert]=''
      compstate[list]=''
      return 0
    fi

    _main_complete _correct

    if (( $compstate[nmatches] == 0 ))
    then
      return 0
    fi

    _main_complete _complete

    if (( ${#compstate[exact_string]} > 0 )) || [[ ${compstate[unambiguous]} == $PREFIX$SUFFIX ]]
    then
      compstate[insert]=''
      compstate[list]=''
    else
      compstate[list]='ambiguous'
    fi
  fi
  return 0
}

_zsh_autocomplete__c__list-choices() {
  setopt localoptions $zsh_autocomplete_options
  unsetopt GLOB_COMPLETE

  if (( PENDING == 0 && KEYS_QUEUED_COUNT == 0 )) && _zsh_autocomplete__is_enough_input
  then
    local curcontext=$( _zsh_autocomplete__context list-choices )
    _main_complete $@

    if (( compstate[nmatches] == 0 ))
    then
      zle -M ''

    elif _zsh_autocomplete__is_too_long_list
    then
      compstate[list]=''
      zle -M ''
    fi

  fi
  return 0
}

_zsh_autocomplete__c__list-more() {
  setopt localoptions $zsh_autocomplete_options

  local curcontext=$( _zsh_autocomplete__context list-more )
  _main_complete $@
}

_zsh_autocomplete__c__menu-select() {
  setopt localoptions $zsh_autocomplete_options

  local curcontext=$( _zsh_autocomplete__context menu-select )
  _zsh_autocomplete__menu_complete $@
}

_zsh_autocomplete__context() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  local curcontext="${curcontext:-}"

  if [[ -z "$curcontext" ]]; then
    curcontext="$1:::"
  else
    curcontext="$1:${curcontext#*:}"
  fi

  echo $curcontext
}

_zsh_autocomplete__force_list() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  if (( ${#compstate[old_list]} == 0 ))
  then

    if _zsh_autocomplete__is_too_long_list
    then
      compstate[insert]='menu'
    else
      compstate[insert]=''
    fi

    compstate[list]='list force'
  fi
}

_zsh_autocomplete__list_choices() {
  setopt localoptions $zsh_autocomplete_options

  local safechars='\-\#\:'
  local histexpansion="${(q)histchars[1]}([$safechars](#c0,1))[^$safechars]*"

  if [[ "${LBUFFER}" != ${~histexpansion} && "${${(z)LBUFFER}[-1]}" != ${~histexpansion} ]]
  then
    zle list-choices
  fi

  true
}

_zsh_autocomplete__is_enough_input() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  local current_word=$PREFIX$SUFFIX
  (( CURRENT > 1 || ${#words[1]} > 0 || ${#current_word} > 0 ))
}

_zsh_autocomplete__is_too_long_list() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  (( (compstate[list_lines] + BUFFERLINES + 1) > LINES
  || (compstate[list_max] != 0 && compstate[nmatches] >= compstate[list_max]) ))
}

_zsh_autocomplete__menu_complete() {
  setopt localoptions $zsh_autocomplete_options

  if [[ -v compstate[old_list] ]]
  then
    compstate[old_list]='keep'

    _main_complete -
  else
    _main_complete $@
  fi

  if [[ ! -v compstate[old_list] ]]
  then
    compstate[list]='list force'

    if _zsh_autocomplete__is_too_long_list
    then
      compstate[insert]='menu'
    else
      compstate[insert]=''
    fi

  fi
}
