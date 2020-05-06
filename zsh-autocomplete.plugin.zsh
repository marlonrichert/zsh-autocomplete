if ! zmodload -e zsh/complist
then
  zmodload -i zsh/complist
  autoload -U compinit && compinit
fi
if [[ ! -v _comp_setup ]]
then
  autoload -U compinit && compinit
fi

setopt EXTENDED_GLOB
setopt GLOB_COMPLETE
setopt GLOB_DOTS
setopt NO_CASE_GLOB

unsetopt AUTO_CD
unsetopt BEEP
unsetopt COMPLETE_IN_WORD

[[ ! -v FZF_COMPLETION_TRIGGER ]] && export FZF_COMPLETION_TRIGGER=''
[[ ! -v fzf_default_completion ]] && export fzf_default_completion='list-more'
[[ ! -v FZF_DEFAULT_OPTS ]] && export FZF_DEFAULT_OPTS="--bind=ctrl-space:abort,ctrl-k:kill-line"

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

zstyle ':completion:correct-word:*' accept-exact true
zstyle ':completion:correct-word:*' completer _complete _correct _approximate
zstyle ':completion:correct-word:*' glob false
zstyle ':completion:correct-word:*' matcher-list ''

zstyle ':completion:(correct-word|list-choices):*' \
  tag-order '! urls hosts repositories local-repositories remote-repositories' '-'
zstyle ':completion:(correct-word|list-choices):*:brew:*' tag-order '-'
zstyle ':completion:(correct-word|list-choices):*:(for|foreach|select):*' \
  tag-order '! globbed-files' '-'

zstyle ':completion:list-choices:expand:*' glob false
zstyle -e ':completion:list-choices:*' tag-order '
  if [[ $PREFIX$SUFFIX == (-|--)* ]] then
    reply=( "options argument-rest" "-" )
  else
    reply=( "" )
  fi'

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
if ! zmodload -e zsh/terminfo
then
  zmodload -i zsh/terminfo
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

zle -N zle-keymap-select _zsh_autocomplete_init
zle -N zle-line-init _zsh_autocomplete_init
_zsh_autocomplete_init() {
  echoti smkx
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
  bindkey ' ' magic-space
  bindkey '^[ ' self-insert-unmeta

  bindkey $key[Tab] complete-word
  bindkey $key[BackTab] list-more
  bindkey $key[ControlSpace] expand-or-fuzzy-find

  if zle -l fzf-history-widget
  then
    bindkey $key[Up] up-line-or-fuzzy-history
    bindkey "^[$key[Up]" fzf-history-widget
    bindkey $key[Down] down-line-or-menu-select
    bindkey "^[$key[Down]" menu-select
  fi

  # Completion menu behavior
  bindkey -M menuselect $key[Tab] accept-and-hold
  bindkey -M menuselect -s $key[Return] $key[LineFeed]$key[ListChoices]
  bindkey -M menuselect -s $key[BackTab] $key[DeleteList]$key[Undo]$key[BackTab]
  bindkey -M menuselect -s $key[ControlSpace] $key[LineFeed]$key[ControlSpace]
}

zle -N zle-line-finish _zsh_autocomplete_finish
_zsh_autocomplete_finish() {
  echoti rmkx
}

# Wrap existing widgets to provide auto-completion.
local widget
for widget in vi-add-eol vi-add-next backward-delete-char vi-backward-delete-char \
  backward-delete-word backward-kill-line backward-kill-word vi-backward-kill-word \
  capitalize-word vi-change vi-change-eol vi-change-whole-line copy-region-as-kill copy-prev-word \
  copy-prev-shell-word vi-delete delete-char vi-delete-char delete-word down-case-word \
  vi-down-case kill-word gosmacs-transpose-chars vi-indent vi-insert vi-insert-bol vi-join \
  kill-line vi-kill-line vi-kill-eol kill-region kill-buffer kill-whole-line vi-match-bracket \
  vi-open-line-above vi-open-line-below vi-oper-swap-case overwrite-mode vi-put-before \
  vi-put-after put-replace-selection quoted-insert vi-quoted-insert quote-line quote-region \
  vi-replace vi-repeat-change vi-replace-chars self-insert self-insert-unmeta vi-substitute \
  vi-swap-case transpose-chars transpose-words vi-unindent vi-up-case up-case-word yank yank-pop \
  vi-yank vi-yank-whole-line vi-yank-eol
do
  eval "zle -N $widget
  $widget() {
    zle .$widget
    zle list-choices
  }"
done

zle -N magic-space
magic-space() {
  zle correct-word
  zle .magic-space
  zle list-choices
}

zle -N complete-word
complete-word() {
  local buffer=$BUFFER
  zle _complete_word
  if [[ $buffer != $BUFFER ]]
  then
    zle .auto-suffix-retain
    zle list-choices
  fi
}

zle -N down-line-or-menu-select
down-line-or-menu-select() {
  zle -M ''
  if (( ${#RBUFFER} > 0 && BUFFERLINES > 1 )); then
    zle .down-line || zle .end-of-line
  else
    zle menu-select
  fi
}

zle -N up-line-or-fuzzy-history
up-line-or-fuzzy-history() {
  zle -M ''
  if (( ${#LBUFFER} > 0 && BUFFERLINES > 1 )); then
    zle .up-line || zle .beginning-of-line
  else
    fzf-history-widget
  fi
}

zle -N expand-or-fuzzy-find
expand-or-fuzzy-find() {
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

zle -C _complete_word complete-word _complete_word
_complete_word() {
  local curcontext=$( _context complete-word )
  _keep_old_list
  _main_complete $@
  _force_list
}

zle -C menu-select menu-select _menu_select
_menu_select() {
  local curcontext=$( _context menu-select )
  _keep_old_list
  _main_complete $@
  _force_list
}

_keep_old_list() {
  if [[ -v compstate[old_list] ]]
  then
    compstate[old_list]=keep
  fi
}

_force_list() {
  if (( ${#compstate[old_list]} == 0 ))
  then
    compstate[insert]=''
    compstate[list]='list force'
  fi
}

zle -C correct-word complete-word _correct_word
_correct_word() {
  if [[ $PREFIX != [[:punct:]]#
        && $PREFIX != -[^-]* ]]
  then
    local curcontext=$( _context correct-word )
    compstate[old_list]=''
    _main_complete $@
    compstate[list]=''
  fi
}

zle -C list-choices list-choices _list_choices
_list_choices() {
  if (( PENDING == 0 && KEYS_QUEUED_COUNT == 0 ))
  then
    local current_word=$PREFIX$SUFFIX
    if (( CURRENT > 1 || ${#words[1]} > 0 || ${#current_word} > 0 ))
    then
      local curcontext=$( _context list-choices )
      _main_complete $@
      if (( (compstate[list_lines] + BUFFERLINES + 1) > LINES
         || ( compstate[list_max] != 0 && compstate[nmatches] > compstate[list_max] ) ))
      then
        compstate[list]=''
      fi
    fi
    if (( ${#compstate[list]} == 0 ))
    then
      zle -M ''
    fi
    # zle -M "$CURRENT>1? ${#words[1]}>0? ${#current_word}>0? ${compstate[list_lines]}+$BUFFERLINES+1>$LINES? ${compstate[nmatches]}>${compstate[nmatches]}?"
    # zle -M "prefix='$PREFIX'"
  fi
}

zle -C list-more list-choices list_more
list_more() {
  local curcontext=$( _context list-more )
  _main_complete $@
}

_context() {
  local curcontext="${curcontext:-}"
  if [[ -z "$curcontext" ]]; then
    curcontext="$1:::"
  else
    curcontext="$1:${curcontext#*:}"
  fi
  echo $curcontext
}
