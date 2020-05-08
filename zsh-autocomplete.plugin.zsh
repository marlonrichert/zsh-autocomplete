#!/bin/zsh

if ! zmodload -e zsh/complist
then
  zmodload -i zsh/complist
  autoload -U compinit && compinit
fi
if [[ ! -v _comp_setup ]]
then
  autoload -U compinit && compinit
fi
if ! zmodload -e zsh/terminfo
then
  zmodload -i zsh/terminfo
fi
autoload -U add-zle-hook-widget

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
[[ ! -v FZF_COMPLETION_TRIGGER ]] && export FZF_COMPLETION_TRIGGER=''
[[ ! -v fzf_default_completion ]] && export fzf_default_completion='list-more'
[[ ! -v FZF_DEFAULT_OPTS ]] && export FZF_DEFAULT_OPTS="--bind=ctrl-space:abort,ctrl-k:kill-line"

() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  zstyle -d ':completion:*' format
  zstyle -d ':completion:*:descriptions' format
  zstyle -d ':completion:*:warnings' format
  zstyle -d ':completion:*' group-name
  zstyle -d '*' single-ignored

  zstyle ':completion:*' add-space file
  zstyle ':completion:*' completer _expand _complete _ignored
  zstyle -e ':completion:*' ignored-patterns '
    reply=( "+*" "[[:punct:]]zinit-*" )
    if [[ $PREFIX$SUFFIX != .* ]] then
      reply+=( "(*/)#.*" )
    fi
    if [[ $PREFIX$SUFFIX != _* ]] then
      reply+=( "_*" )
    fi
  '
  zstyle ':completion:*' matcher-list 'r:|.=*' 'r:|?=**' '+m:{[:lower:]}={[:upper:]}'
  zstyle ':completion:*:z:*' file-patterns '%p(-/):directories'
  zstyle ':completion:*:options' ignored-patterns ''
  zstyle ':completion:*:widgets' matcher 'l:?|=**'

  zstyle ':completion:complete-word:*' menu 'auto select'

  zstyle ':completion:(correct-word|list-choices):*' file-patterns \
    '%p(-/):directories %p:all-files'
  zstyle ':completion:correct-word:*' tag-order '! options globbed-files remote-repositories' '-'
  zstyle -e ':completion:list-choices:*' tag-order '
    if [[ $PREFIX$SUFFIX == -* ]] then
      reply=( "options argument-rest" "-" )
    else
      reply=(
        "! commit-tags heads-remote remote-repositories"
        "commit-tags heads-remote"
        "-"
        )
    fi'
  zstyle ':completion:(correct-word|list-choices):*:brew:*' tag-order '! all-commands' '-'

  zstyle ':completion:correct-word:*' accept-exact true
  zstyle ':completion:correct-word:*' completer _complete _correct
  zstyle ':completion:correct-word:*' glob false
  zstyle ':completion:correct-word:*' matcher-list ''

  zstyle ':completion:list-choices:expand:*' glob false

  zstyle ':completion:list-more:*' format '%F{yellow}%d%f'
  zstyle ':completion:list-more:*' group-name ''
  zstyle ':completion:list-more:*' matcher-list 'r:|?=** m:{[:lower:]}={[:upper:]}'
  zstyle ':completion:list-more:*' menu 'select=long-list'

  if [[ ! -v key ]]
  then
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
  if [[ -z $key[ControlSpace] ]]; then key[ControlSpace]='^@'; fi
  if [[ -z $key[Return] ]]; then key[Return]='^M'; fi
  if [[ -z $key[LineFeed] ]]; then key[LineFeed]='^J'; fi
  if [[ -z $key[DeleteList] ]]; then key[DeleteList]='^D'; fi

  bindkey ' ' magic-space
  bindkey '^[ ' self-insert-unmeta
  bindkey $key[BackTab] list-more
  bindkey $key[ControlSpace] expand-or-fuzzy-find
  bindkey -M menuselect $key[Tab] accept-and-hold
}

add-zle-hook-widget zle-keymap-select _zsh_autocomplete_init
add-zle-hook-widget zle-line-init _zsh_autocomplete_init
_zsh_autocomplete_init() {
  emulate -L zsh
  setopt warncreateglobal noshortloops
  echoti smkx

  bindkey $key[Tab] complete-word

  local keymap=$( bindkey -lL main )
  if [[ $keymap == *emacs* ]]
  then
    [[ -z key[ListChoices] ]] || key[ListChoices]='^[^D'
    [[ -z key[Undo] ]] || key[Undo]='^_'
  elif [[ $keymap == *viins* ]]
  then
    [[ -z key[ListChoices] ]] || key[ListChoices]='^D'
    [[ -z key[Undo] ]] || key[Undo]='u'
  else
    return
  fi
  bindkey -M menuselect -s $key[Return] $key[LineFeed]$key[ListChoices]
  bindkey -M menuselect -s $key[BackTab] $key[DeleteList]$key[Undo]$key[BackTab]
  bindkey -M menuselect -s $key[ControlSpace] $key[LineFeed]$key[ControlSpace]

  if zle -l fzf-history-widget
  then
    bindkey $key[Up] up-line-or-fuzzy-history
    bindkey "^[$key[Up]" fzf-history-widget
    bindkey $key[Down] down-line-or-menu-select
    bindkey "^[$key[Down]" menu-select
  fi
}

add-zle-hook-widget zle-line-finish _zsh_autocomplete_finish
_zsh_autocomplete_finish() {
  emulate -L zsh
  setopt warncreateglobal noshortloops
  echoti rmkx
}

# Wrap all text modification widgets to provide auto-completion.
() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  local widget
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
    eval "zle -N $widget _zsh_autocomplete_n_$widget
    _zsh_autocomplete_n_$widget() {
      zle .$widget
      setopt localoptions $zsh_autocomplete_options
      zle list-choices
      true
    }"
  done
}

zle -N magic-space _zsh_autocomplete_n_magic-space
_zsh_autocomplete_n_magic-space() {
  setopt localoptions $zsh_autocomplete_options

  zle correct-word
  zle .magic-space
  zle list-choices
  true
}

zle -N complete-word _zsh_autocomplete_n_complete-word
_zsh_autocomplete_n_complete-word() {
  setopt localoptions $zsh_autocomplete_options

  local buffer=$BUFFER
  zle _complete_word
  if [[ $buffer != $BUFFER ]]
  then
    zle .auto-suffix-retain
    zle list-choices
    true
  fi
}

zle -N down-line-or-menu-select _zsh_autocomplete_n_down-line-or-menu-select
_zsh_autocomplete_n_down-line-or-menu-select() {
  setopt localoptions $zsh_autocomplete_options

  zle -M ''
  if (( ${#RBUFFER} > 0 && BUFFERLINES > 1 )); then
    zle .down-line || zle .end-of-line
  else
    zle menu-select
  fi
}

zle -N up-line-or-fuzzy-history _zsh_autocomplete_n_up-line-or-fuzzy-history
_zsh_autocomplete_n_up-line-or-fuzzy-history() {
  setopt localoptions $zsh_autocomplete_options

  zle -M ''
  if (( ${#LBUFFER} > 0 && BUFFERLINES > 1 )); then
    zle .up-line || zle .beginning-of-line
  else
    fzf-history-widget
  fi
}

zle -N expand-or-fuzzy-find _zsh_autocomplete_n_expand-or-fuzzy-find
_zsh_autocomplete_n_expand-or-fuzzy-find() {
  setopt localoptions $zsh_autocomplete_options

  zle -M ''
  local buffer=$BUFFER
  zle _expand_alias
  zle _expand_word
  if [[ $buffer == $BUFFER ]]
  then
    if zle -l fzf-completion
    then
      while [[ $RBUFFER[1] == [[:graph:]] ]]
      do
        zle .forward-word
      done
      fzf-completion
    else
      zle list-more
    fi
  fi
}

zle -C _complete_word complete-word _zsh_autocomplete_c_complete_word
_zsh_autocomplete_c_complete_word() {
  setopt localoptions $zsh_autocomplete_options

  local curcontext=$( _zsh_autocomplete__context complete-word )
  _zsh_autocomplete__keep_old_list
  _main_complete $@
  _zsh_autocomplete__force_list
}

zle -C menu-select menu-select _zsh_autocomplete_c_menu_select
_zsh_autocomplete_c_menu_select() {
  setopt localoptions $zsh_autocomplete_options

  local curcontext=$( _zsh_autocomplete__context menu-select )
  _zsh_autocomplete__keep_old_list
  _main_complete $@
  _zsh_autocomplete__force_list
}

_zsh_autocomplete__keep_old_list() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  if [[ -v compstate[old_list] ]]
  then
    compstate[old_list]=keep
  fi
}

_zsh_autocomplete__force_list() {
  emulate -L zsh
  setopt warncreateglobal noshortloops

  if (( ${#compstate[old_list]} == 0 ))
  then
    compstate[insert]='automenu'
    compstate[list]='list force'
  fi
}

zle -C correct-word complete-word _zsh_autocomplete_c_correct_word
_zsh_autocomplete_c_correct_word() {
  setopt localoptions $zsh_autocomplete_options

  if [[ $SUFFIX[1] == [[:IFS:]]#
        && $PREFIX != [[:punct:]]#
        && $PREFIX != -[^-]* ]]
  then
    local curcontext=$( _zsh_autocomplete__context correct-word )
    compstate[old_list]=''
    _main_complete $@
    compstate[list]=''
  fi
}

zle -C list-choices list-choices _zsh_autocomplete_c_list_choices
_zsh_autocomplete_c_list_choices() {
  setopt localoptions $zsh_autocomplete_options

  if (( PENDING == 0 && KEYS_QUEUED_COUNT == 0 ))
  then
    local current_word=$PREFIX$SUFFIX
    if (( CURRENT > 1 || ${#words[1]} > 0 || ${#current_word} > 0 ))
    then
      local curcontext=$( _zsh_autocomplete__context list-choices )
      _main_complete $@
      if (( (compstate[list_lines] + BUFFERLINES + 1) > LINES
         || ( compstate[list_max] != 0 && compstate[nmatches] > compstate[list_max] ) ))
      then
        compstate[list]=''
        if (( BUFFERLINES == 1))
        then
          local prompt='^'
          zle -M "${(l:CURSOR+${#prompt}+2:)prompt}"
        fi
      fi
    fi
  fi
}

zle -C list-more list-choices _zsh_autocomplete_c_list_more
_zsh_autocomplete_c_list_more() {
  setopt localoptions $zsh_autocomplete_options

  local curcontext=$( _zsh_autocomplete__context list-more )
  _main_complete $@
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
